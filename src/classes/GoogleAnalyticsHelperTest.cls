/* 
Description - This class contains unit tests for validating the 
 *               behavior of DocumentsSMSCSS2_0controller class

 @Created by: Trupti Dhoka
 @Created Date: 6/may/2015
 
 --------------------------------------------------------------------------------
 | Modified By      | Modified Date       | Version        | Description         |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------
*/

@isTest
public class GoogleAnalyticsHelperTest
{
       
        //method for creating account
        private static Account createAccount(){
        Account objAccount = new Account();
        objAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Booked Account').getRecordTypeId();
        objAccount.FirstName = 'Test1';
        objAccount.LastName = 'Account1';
        objAccount.CRN__c = '154215';
        objAccount.H_Mobile_No__c = '1234560789';
        objAccount.Mobile_Phone__c = '21241222';
        objAccount.Co_Applicant__c = 'test';
        objAccount.Project_Name__c = 'New Cuffe Parade';
        return objAccount;
      } 
      //method for creating community user
       private static User createUser(Account a)
       {
            User objUser = new User();
            contact c=[select id from contact where accountid=:a.id limit 1];
            objUser.ProfileID = [Select Id From Profile Where Name = 'Custom Overage High Volume Customer Portal'].id;
            objUser.EmailEncodingKey = 'ISO-8859-1';
            objUser.LanguageLocaleKey = 'en_US';
            objUser.TimeZoneSidKey = 'America/New_York';
            objUser.LocaleSidKey = 'en_US';
            objUser.FirstName = 'first';
            objUser.LastName = 'last';
            objUser.Username = 'sudeepk86dub1e@gmail.com';
            objUser.CommunityNickname = 'testUser123';
            objUser.Alias = 't1';
            objUser.Email = 'no@email.com';
            objUser.IsActive = true;
            objUser.ContactId = c.id;
            return objUser;
        }  
       
        private static Project_Name__c  createProjectName()
        {
          Project_Name__c objprojectname = new Project_Name__c();
          objprojectname.Name = 'New Cuffe Parade';
          objprojectname.OrderType__c = 'Custom';
          objprojectname.Project_Type__c = 'Hi End / Luxury';
          objprojectname.Record_Type__c ='Residential';
          objprojectname.CSS_Background_Image_URL__c = 'https://c.cs7.content.force.com/servlet/servlet.FileDownload?file=00PM0000003RzGG';
            return objprojectname;
        }

         static testMethod void PositiveHelperTest() 
         {
             //create account
            Account objAccount = createAccount();
            insert objAccount;
            
            //create user
            User u = createUser(objAccount);
            insert u;
            
            
            Project_Name__c projectname = createProjectName();
            insert projectname;
            
            test.StartTest();
            GoogleAnalyticsHelper AnalyticsHelper = new GoogleAnalyticsHelper ();
            LoginPageCSS2_0Controller logincontroller = new LoginPageCSS2_0Controller();
            logincontroller.username = u.Username ;
            logincontroller.password = 'lodha@500';
            logincontroller.login() ;
            GoogleAnalyticsHelper.GetReportParameters(u.Id);
            GoogleAnalyticsHelper.TotalLogins = 5;
            
       
         }

}