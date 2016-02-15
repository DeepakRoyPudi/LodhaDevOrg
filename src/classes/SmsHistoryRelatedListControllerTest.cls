/*
*        Description : Test Class for SMSHistoryRelatedListController
*
*        Version     Date          Author             Description
*        1.0         01/09/2014    Asmita(Eternus)    Intial Draft
*/

@isTest
private class SmsHistoryRelatedListControllerTest {

    static testMethod void SmsHistoryRelatedListTest() {
        
        ApexPages.StandardController sc;
        SMSHistoryRelatedListController objSmsHistoryRelatedList;
        
        // Creating Account
        List<Account> listAccount = SmsHistoryRelatedListControllerTest.getAccountRecord(1);
        insert listAccount;
        
        // Creating User Of Functional Team Lead Profile
        User objTestUser = SmsHistoryRelatedListControllerTest.getUserRecord('Customer Care');
        insert objTestUser;
        
        List<SMS_History__c> listSmsHistory = SmsHistoryRelatedListControllerTest.getSmsHistoryRecords(1);
        listSmsHistory[0].Account__c = listAccount[0].Id;
        insert listSmsHistory;  
        
        test.startTest();
            
            ApexPages.currentPage().getParameters().put('id',listAccount[0].Id);
            sc = new ApexPages.StandardController(listAccount[0]);
            objSmsHistoryRelatedList = new SMSHistoryRelatedListController(sc);
            
            System.runAs(objTestUser){
                
                objSmsHistoryRelatedList.renderActionLinks();
            }
            
            objSmsHistoryRelatedList.toggleSort();
            
            //searchName != '' && fromDate != null && toDate != null
            objSmsHistoryRelatedList.searchName = 'testFile*';
            objSmsHistoryRelatedList.fromDateSearch.Created_Date__c = System.now();
            objSmsHistoryRelatedList.toDateSearch.Created_Date__c = System.now(); 
            System.assertEquals(null, objSmsHistoryRelatedList.searchByFilter());
        
            //searchName != '' && fromDate != null && toDate == null
            objSmsHistoryRelatedList.searchName = 'testFile*';
            objSmsHistoryRelatedList.fromDateSearch.Created_Date__c = System.now();
            objSmsHistoryRelatedList.toDateSearch.Created_Date__c = null;
            System.assertEquals(null, objSmsHistoryRelatedList.searchByFilter());
        
            //searchName != '' && fromDate == null && toDate != null
            objSmsHistoryRelatedList.searchName = 'testFile*';
            objSmsHistoryRelatedList.fromDateSearch.Created_Date__c = null;
            objSmsHistoryRelatedList.toDateSearch.Created_Date__c = System.now();
            System.assertEquals(null, objSmsHistoryRelatedList.searchByFilter());
        
            //searchName != '' && fromDate == null && toDate == null
            objSmsHistoryRelatedList.searchName = 'testFile*';
            objSmsHistoryRelatedList.fromDateSearch.Created_Date__c = null;
            objSmsHistoryRelatedList.toDateSearch.Created_Date__c = null;
            System.assertEquals(null, objSmsHistoryRelatedList.searchByFilter());
        
            //searchName == '' && fromDate != null && toDate != null
            objSmsHistoryRelatedList.searchName = '';
            objSmsHistoryRelatedList.fromDateSearch.Created_Date__c = System.now();
            objSmsHistoryRelatedList.toDateSearch.Created_Date__c = System.now();
            System.assertEquals(null, objSmsHistoryRelatedList.searchByFilter());
        
            //searchName == '' && fromDate == null && toDate != null
            objSmsHistoryRelatedList.searchName = '';
            objSmsHistoryRelatedList.fromDateSearch.Created_Date__c = null;
            objSmsHistoryRelatedList.toDateSearch.Created_Date__c = System.now();
            System.assertEquals(null, objSmsHistoryRelatedList.searchByFilter());
        
            //searchName == '' && fromDate != null && toDate == null
            objSmsHistoryRelatedList.searchName = '';
            objSmsHistoryRelatedList.fromDateSearch.Created_Date__c = System.now();
            objSmsHistoryRelatedList.toDateSearch.Created_Date__c = null;
            System.assertEquals(null, objSmsHistoryRelatedList.searchByFilter());
            
            ApexPages.currentPage().getParameters().put('smsId', listSmsHistory[0].Id); 
            
            System.assertEquals(null, objSmsHistoryRelatedList.displayReport());
            System.assertEquals('/' + listSmsHistory[0].Id, objSmsHistoryRelatedList.openSmsrecord().getUrl());
            System.assertEquals('/' + listSmsHistory[0].Id + '/e?retURL=%2F' + listAccount[0].Id, objSmsHistoryRelatedList.editSmsHistory().getUrl());
            objSmsHistoryRelatedList.listSmsHistory.add(listSmsHistory[0]);
            objSmsHistoryRelatedList.deleteSmsHistory();
        test.stopTest();
    }
    
     // Creating Account records
    public static List<Account> getAccountRecord(Integer pNumberOfRecords){
        
        Account oAcc = new Account();
        List<Account> listAccount = new List<Account>();
        
        for(Integer i = 0 ; i < pNumberOfRecords; i++){
            
            oAcc = new Account();
            oAcc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
            oAcc.Name = 'TestAccount';
            oAcc.Mobile_Phone__c = '9211111111';
            
            listAccount.add(oAcc);
        }
        
        return listAccount;
    }// end of getAccountRecords
    
    //Method to create Test User Record for Customer Care Profile
    private static User getUserRecord(String pStrProfile){
    
        Profile customerProfile = [select Id
                                   from Profile
                                   where Name = :pStrProfile];
        
        User objTestUser = new User();
        objTestUser.Alias = 'standt';
        objTestUser.Email = 'standarduser@testorg.com'; 
        objTestUser.EmailEncodingKey = 'UTF-8';
        objTestUser.LastName = 'TestUser';
        objTestUser.FirstName = 'Testing';
        objTestUser.LanguageLocaleKey = 'en_US'; 
        objTestUser.LocaleSidKey = 'en_US';
        objTestUser.ProfileId = customerProfile.Id; 
        objTestUser.TimeZoneSidKey = 'America/Los_Angeles';
        objTestUser.UserName = 'TestUserstandarduser@testorg.com';
        objTestUser.IsActive = true;
        objTestUser.CommunityNickname = 'TestUser';
        
        return objTestUser;
    }
    
    // Creating SMS History records
    public static List<SMS_History__c> getSmsHistoryRecords(Integer pNumberOfRecords){
        
        SMS_History__c oSmsHistory = new SMS_History__c();
        List<SMS_History__c> listSmsHistory = new List<SMS_History__c>();
        
        for(Integer i =0 ; i < pNumberOfRecords ; i++){
            oSmsHistory = new SMS_History__c();
            oSmsHistory.Mobile_Number__c = '9930996390';
            listSmsHistory.add(osmsHistory);       
        }
        return listSmsHistory;
    }
}