/*Description:
An apex test for forgot password functionality

 @Created by: Trupti Dhoka
 @Created Date:18/04/2015
 
 --------------------------------------------------------------------------------
 | Modified By      | Modified Date       | Version        | Description         |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------
*/
@IsTest(SeeAllData=false)

public class ForgotPasswordControllerCSS2_0Test {
    
        //method for creating account
        private static Account createAccount(){
        Account objAccount = new Account();
        objAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Booked Account').getRecordTypeId();
        objAccount.FirstName = 'Test1';
        objAccount.LastName = 'Account1';
        objAccount.CRN__c = '154215';
        objAccount.Personal_Email__pc = 'trupti.dhoka@eternussolutions.com';
        objAccount.H_Mobile_No__c = '1234560789';
        objAccount.Mobile_Phone__c = '21241222';
        objAccount.Co_Applicant__c = 'test';
        return objAccount;
      } 
      
      private static Account createAccount1(){
        Account objAccount = new Account();
        objAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Booked Account').getRecordTypeId();
        objAccount.FirstName = 'Test1';
        objAccount.LastName = 'Account1';
        objAccount.CRN__c = '154215';
        objAccount.Personal_Email__pc = 'no1@email.com';
        objAccount.H_Mobile_No__c = '1234560789';
        objAccount.Mobile_Phone__c = '21241222';
        objAccount.Co_Applicant__c = 'test';
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
            objUser.Username = 'test@appirio.com';
            objUser.CommunityNickname = 'testUser123';
            objUser.Alias = 't1';
            objUser.Email = 'trupti.dhoka@eternussolutions.com';
            objUser.IsActive = true;
            objUser.ContactId = c.id;
            return objUser;
        }  
         private static User createUser1(Account a)
       {
            User objUser = new User();
           // contact c=[select id from contact where accountid=:a.id limit 1];
            objUser.ProfileID = [Select Id From Profile Where Name = 'Standard User'].id;
            objUser.EmailEncodingKey = 'ISO-8859-1';
            objUser.LanguageLocaleKey = 'en_US';
            objUser.TimeZoneSidKey = 'America/New_York';
            objUser.LocaleSidKey = 'en_US';
            objUser.FirstName = 'first';
            objUser.LastName = 'last';
            objUser.Username = 'test111@appirio.com';
            objUser.CommunityNickname = 'testUser123';
            objUser.Alias = 't1';
            objUser.Email = 'nno2@email.com';
            objUser.IsActive = true;
            //objUser.ContactId = c.id; 
            return objUser;
        }  
        
        /*this method tests the functionality for valid CRN */
        static testmethod void PositiveForgotpasswordTest()
        {
            Account objAccount = createAccount();
            insert objAccount;
            
            //create user
            User u = createUser(objAccount);
            insert u;
            
            list<account> acc  = new  list<account>();
            list<user> usr = new  list<user>();
            
            test.startTest();
            
            ForgotPasswordControllerCSS2_0  forgotpassword = new ForgotPasswordControllerCSS2_0 ();
            ChangePasswordController controller = new ChangePasswordController();
            forgotpassword.crn = '154215';
            forgotpassword.forgotPassword();
            System.assertEquals(forgotpassword.forgotPassword(),null); 
            Test.stopTest();
        }
        
        /*this method tests the functionality for Invalid/empty CRN */
        static testmethod void NegativeForgotpasswordTest()
        {
            Account objAccount = createAccount1();
            insert objAccount;
            
            //create user
            User u = createUser1(objAccount);
            insert u;
            
            list<account> acc  = new  list<account>();
            list<user> usr = new  list<user>();
            
            test.startTest();
            
                ForgotPasswordControllerCSS2_0  forgotpassword = new ForgotPasswordControllerCSS2_0 ();
                forgotpassword.crn = '';
                forgotpassword.forgotPassword();
                forgotpassword.crn = '63464tg';
                forgotpassword.forgotPassword();
                forgotpassword.crn = '154215';
                forgotpassword.forgotPassword();
                
            Test.stopTest();
        }
    

}