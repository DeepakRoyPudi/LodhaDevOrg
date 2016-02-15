/*
*    Description: Test class for UpdateAccountUserEmailHelper for Account trigger
*    
*    Version      Date       Author     Description
*     1.0      10/09/2014    Asmita    Initial Draft
*/

@isTest
private class UpdateAccountUserEmailHelperTest {

    static testMethod void updateUserEmailTest() {
        
        List<Contact> listContact = new List<Contact>();
        List<User> listUser = new List<User>();
        
        // Creating Account Records
        List<Account> listAccount = UpdateAccountUserEmailHelperTest.getAccountRecords(2);
        insert listAccount;
        
        // Creating Contact to assign to the Users
        listContact = [select id
                       from Contact
                       where AccountId in :listAccount];
        
        // Creating User records
        if(!listContact.isEmpty()){
            listUser = UpdateAccountUserEmailHelperTest.getUserRecord('Custom Overage High Volume Customer Portal', 2);
            for(Integer i = 0 ; i < listUser.size() ; i++){
                listUser[i].ContactId = listContact[i].Id;
            }
            insert listUser;
        
            // Updating Account so as to fire after update trigger
            for(Integer i = 0 ; i < listAccount.size(); i++){
                listAccount[i].Personal_Email__pc = 'testtest' + i + 1 + '@test1.com';
            }
            UpdateAccountUserEmailHelper.blnIsExecuted = false;
            System.runAs(new User(Id = UserInfo.getUserId())){
                test.startTest();
                    update listAccount;
                test.stopTest();
            }
        
            List<User> listUpdatedUser = [select id,
                                                 Email
                                          from User
                                          where Id in :listUser];
        
            System.assertEquals(listUpdatedUser[0].Email, listAccount[0].Personal_Email__pc);
            System.assertEquals(listUpdatedUser[1].Email, listAccount[1].Personal_Email__pc);
        }
    }
    
    static testMethod void bulkUpdateUserEmailTest(){
        
        List<Contact> listContact = new List<Contact>();
        List<User> listUser = new List<User>();
        
        // Creating Account Records
        List<Account> listAccount = UpdateAccountUserEmailHelperTest.getAccountRecords(200);
        insert listAccount;
        
        // Creating Contact to assign to the Users
        listContact = [select id
                       from Contact
                       where AccountId in :listAccount];
                       
        // Creating User records
        if(!listContact.isEmpty()){
            listUser = UpdateAccountUserEmailHelperTest.getUserRecord('Custom Overage High Volume Customer Portal', 200);
            for(Integer i = 0 ; i < listUser.size() ; i++){
                listUser[i].ContactId = listContact[i].Id;
            }
            insert listUser;
        
            // Updating Account so as to fire after update trigger
            for(Integer i = 0 ; i < listAccount.size(); i++){
                listAccount[i].Personal_Email__pc = 'testtest' + i + 1 + '@test1.com';
            }
            UpdateAccountUserEmailHelper.blnIsExecuted = false;
            System.runAs(new User(Id = UserInfo.getUserId())){
                test.startTest();
                    update listAccount;
                test.stopTest();
            }
        
            List<User> listUpdatedUser = [select id,
                                                 Email
                                          from User
                                          where Id in :listUser];
        
            for(Integer i = 0 ; i < listUpdatedUser.size(); i++){
                System.assertEquals(listUpdatedUser[i].Email, listAccount[i].Personal_Email__pc);
            }
        }
    }
    
    // Method to create Account Records
    public static List<Account> getAccountRecords(Integer pNumberOfRecords){
        
        Account oAcc = new Account();
        List<Account> listAccount = new List<Account>();
        
        for(Integer i = 0 ; i < pNumberOfRecords ; i++){
            
            oAcc = new Account();
            oAcc.RecordTypeId = Account.SObjectType.getDescribe().getRecordTypeInfosByName().get('Booked Account').getRecordTypeId();
            oAcc.LastName = 'test Account ' + i + 1;
            oAcc.Personal_Email__pc = 'test' + i + 1 + '@test.com';
            
            listAccount.add(oAcc);
        }
        return listAccount;
    }// end of getAccountRecords
    
    //Method to create Test User Record for Customer Care Profile
    private static List<User> getUserRecord(String pStrProfile, Integer pNumberOfRecords){
        User objTestUser = new User();
    	List<User> listUser = new List<User>();
    
        Profile customerProfile = [select Id
                                   from Profile
                                   where Name = :pStrProfile];
        
        for(Integer i = 0 ; i < pNumberOfRecords ; i ++){
            objTestUser = new User();
            objTestUser.Alias = 'user' + i + 1;
            objTestUser.Email = 'standarduser' + i + 1 + '@testorg.com'; 
            objTestUser.EmailEncodingKey = 'UTF-8';
            objTestUser.LastName = 'TestUser' + i + 1;
            objTestUser.FirstName = 'Testing';
            objTestUser.LanguageLocaleKey = 'en_US'; 
            objTestUser.LocaleSidKey = 'en_US';
            objTestUser.ProfileId = customerProfile.Id; 
            objTestUser.TimeZoneSidKey = 'America/Los_Angeles';
            objTestUser.UserName = 'TestUserstandarduser' + i + 1 + '@testorg.com';
            objTestUser.IsActive = true;
            objTestUser.CommunityNickname = 'TestUser' + i + 1;
        
            listUser.add(objTestUser);
        }
        
        return listUser;
    }
    
}