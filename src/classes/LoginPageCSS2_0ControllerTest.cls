/* 
Description: Test Class For LoginPageCSS2_0Controller
@Created by: Trupti Dhoka
@Created Date: 22/04/2015

--------------------------------------------------------------------------------
| Modified By      | Modified Date       | Version        | Description         |
--------------------------------------------------------------------------------
|
---------------------------------------------------------------------------------
*/
@IsTest 
global  class LoginPageCSS2_0ControllerTest {

   private static Account createAccount(){
        Account objAccount = new Account();
        objAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Booked Account').getRecordTypeId();
        objAccount.FirstName = 'Test1';
        objAccount.LastName = 'Account1';
        objAccount.CRN__c = '1400780';
        objAccount.H_Mobile_No__c = '1234560789';
        objAccount.Mobile_Phone__c = '21241222';
        objAccount.Co_Applicant__c = 'test';
        objAccount.Project_Name__c = 'New Cuffe Parade';
        return objAccount;
      }  
      
      //Account with no CRN value
       private static Account createAccountWithNoCRN(){
        Account objAccount = new Account();
        objAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Booked Account').getRecordTypeId();
        objAccount.FirstName = 'Test1';
        objAccount.LastName = 'Account1';
        //objAccount.CRN__c = '1400780';
        objAccount.H_Mobile_No__c = '1234560789';
        objAccount.Mobile_Phone__c = '21241222';
        objAccount.Co_Applicant__c = 'test';
        objAccount.Project_Name__c = 'New Cuffe Parade';
        return objAccount;
      }
      
       //method for creating community user
     private static User createUserforAccount(Account a)
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
          objUser.Username = 'test1@appirio.com';
          objUser.CommunityNickname = 'testUser1234';
          objUser.Alias = 't1';
          objUser.Email = 'no@email.com';
          objUser.IsActive = true;
          objUser.ContactId = c.id;
      return objUser;
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
          objUser.Username = 'test@appirio.com';
          objUser.CommunityNickname = 'testUser123';
          objUser.Alias = 't1';
          objUser.Email = 'no@email.com';
          objUser.IsActive = true;
          objUser.ContactId = c.id;
      return objUser;
      }  
   
   //This test method test the positive login functionality 
   @isTest
   global static void testCommunitiesLoginController1 () {
       
       Account a = createAccount();
       insert a;
       
       User u = createUser(a);
       insert u;
       
       Account a1 =createAccountWithNoCRN();
       insert a1;
       
       User u1 = createUserforAccount(a1);
       insert u1;
       
       test.StartTest();
       LoginPageCSS2_0Controller logincontroller = new LoginPageCSS2_0Controller();
       logincontroller.forwardToCustomAuthPage();
       logincontroller.username = u.Username ;
       logincontroller.password = 'lodha@500';
       logincontroller.login() ;
       //check login functionality for empty crn
        logincontroller.username = u1.Username ;
       logincontroller.password = 'lodha@500';
       logincontroller.login() ;
       
       test.StopTest();
               
    }    
}