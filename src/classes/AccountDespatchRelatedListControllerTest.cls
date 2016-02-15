/*
*        Description : Test Class for AccountDespatchRelatedListController
*
*        Version     Date          Author             Description
*        1.0         01/09/2014    Asmita(Eternus)    Intial Draft
*/

@isTest
private class AccountDespatchRelatedListControllerTest {

    static testMethod void despatchRelatedListTest() {
    	
        ApexPages.StandardController sc;
        AccountDespatchRelatedListController objDespatchRelatedList;
    	
        // Creating Account
        List<Account> listAccount = AccountDespatchRelatedListControllerTest.getAccountRecord(1);
        insert listAccount;
        
        // Creating User Of Functional Team Lead Profile
        User objTestUser = AccountDespatchRelatedListControllerTest.getUserRecord('Customer Care');
        insert objTestUser;
        
        List<Despatch__c> listDespatch = AccountDespatchRelatedListControllerTest.getDespatchRecords(1);
        listDespatch[0].Account__c = listAccount[0].Id;
        insert listDespatch; 
        
        test.startTest();
            
            ApexPages.currentPage().getParameters().put('id',listAccount[0].Id);
            sc = new ApexPages.StandardController(listAccount[0]);
            objDespatchRelatedList = new AccountDespatchRelatedListController(sc);
            
            System.runAs(objTestUser){
            	
            	objDespatchRelatedList.renderActionLinks();
            }
            
            objDespatchRelatedList.toggleSort();
            
            //searchContent != '' && fromDate != null && toDate != null && searchStatus != ''
            objDespatchRelatedList.searchContent = 'allotment*';
            objDespatchRelatedList.fromDateSearch.Despatch_Date__c = System.today();
            objDespatchRelatedList.toDateSearch.Despatch_Date__c = System.today(); 
            objDespatchRelatedList.searchStatus = 'Delivered*'; 
            System.assertEquals(null, objDespatchRelatedList.searchByFilter());
        
            //searchContent != '' && fromDate != null && toDate != null && searchStatus == ''
            objDespatchRelatedList.searchContent = 'testFile*';
            objDespatchRelatedList.fromDateSearch.Despatch_Date__c = System.today();
            objDespatchRelatedList.toDateSearch.Despatch_Date__c = System.today();
            objDespatchRelatedList.searchStatus = '';
            System.assertEquals(null, objDespatchRelatedList.searchByFilter());
        
            //searchContent != '' && fromDate != null && toDate == null && searchStatus != ''
            objDespatchRelatedList.searchContent = 'testFile*';
            objDespatchRelatedList.fromDateSearch.Despatch_Date__c = System.today();
            objDespatchRelatedList.toDateSearch.Despatch_Date__c = null;
            objDespatchRelatedList.searchStatus = 'Delivered*';
            System.assertEquals(null, objDespatchRelatedList.searchByFilter());
        
            //searchContent != '' && fromDate != null && toDate == null && searchStatus == ''
            objDespatchRelatedList.searchContent = 'testFile*';
            objDespatchRelatedList.fromDateSearch.Despatch_Date__c = System.today();
            objDespatchRelatedList.toDateSearch.Despatch_Date__c = null;
            objDespatchRelatedList.searchStatus = '';
            System.assertEquals(null, objDespatchRelatedList.searchByFilter());
        
            //searchContent != '' && fromDate == null && toDate != null && searchStatus != ''
            objDespatchRelatedList.searchContent = 'testFile*';
            objDespatchRelatedList.fromDateSearch.Despatch_Date__c = null;
            objDespatchRelatedList.toDateSearch.Despatch_Date__c = System.today();
            objDespatchRelatedList.searchStatus = 'Delivered*';
            System.assertEquals(null, objDespatchRelatedList.searchByFilter());
        
            //searchContent != '' && fromDate == null && toDate != null && searchStatus == ''
            objDespatchRelatedList.searchContent = 'testFile*';
            objDespatchRelatedList.fromDateSearch.Despatch_Date__c = null;
            objDespatchRelatedList.toDateSearch.Despatch_Date__c = System.today();
            objDespatchRelatedList.searchStatus = '';
            System.assertEquals(null, objDespatchRelatedList.searchByFilter());
        
            //searchContent != '' && fromDate == null && toDate == null && searchStatus != ''
            objDespatchRelatedList.searchContent = 'testFile*';
            objDespatchRelatedList.fromDateSearch.Despatch_Date__c = null;
            objDespatchRelatedList.toDateSearch.Despatch_Date__c = null;
            objDespatchRelatedList.searchStatus = 'Delivered*';
            System.assertEquals(null, objDespatchRelatedList.searchByFilter());
            
            //searchContent != '' && fromDate == null && toDate == null && searchStatus == ''
            objDespatchRelatedList.searchContent = 'testFile*';
            objDespatchRelatedList.fromDateSearch.Despatch_Date__c = null;
            objDespatchRelatedList.toDateSearch.Despatch_Date__c = null;
            objDespatchRelatedList.searchStatus = '';
            System.assertEquals(null, objDespatchRelatedList.searchByFilter());
            
            //searchContent == '' && fromDate != null && toDate != null && searchStatus != ''
            objDespatchRelatedList.searchContent = '';
            objDespatchRelatedList.fromDateSearch.Despatch_Date__c = System.today();
            objDespatchRelatedList.toDateSearch.Despatch_Date__c = System.today();
            objDespatchRelatedList.searchStatus = 'Delivered*';
            System.assertEquals(null, objDespatchRelatedList.searchByFilter());
            
            //searchContent == '' && fromDate != null && toDate != null && searchStatus == ''
            objDespatchRelatedList.searchContent = '';
            objDespatchRelatedList.fromDateSearch.Despatch_Date__c = System.today();
            objDespatchRelatedList.toDateSearch.Despatch_Date__c = System.today();
            objDespatchRelatedList.searchStatus = '';
            System.assertEquals(null, objDespatchRelatedList.searchByFilter());
            
            //searchContent == '' && fromDate != null && toDate == null && searchStatus != ''
            objDespatchRelatedList.searchContent = '';
            objDespatchRelatedList.fromDateSearch.Despatch_Date__c = System.today();
            objDespatchRelatedList.toDateSearch.Despatch_Date__c = null;
            objDespatchRelatedList.searchStatus = 'Delivered*';
            System.assertEquals(null, objDespatchRelatedList.searchByFilter());
            
            //searchContent == '' && fromDate != null && toDate == null && searchStatus == ''
            objDespatchRelatedList.searchContent = '';
            objDespatchRelatedList.fromDateSearch.Despatch_Date__c = System.today();
            objDespatchRelatedList.toDateSearch.Despatch_Date__c = null;
            objDespatchRelatedList.searchStatus = '';
            System.assertEquals(null, objDespatchRelatedList.searchByFilter());
            
            //searchContent == '' && fromDate = null && toDate != null && searchStatus != ''
            objDespatchRelatedList.searchContent = '';
            objDespatchRelatedList.fromDateSearch.Despatch_Date__c = null;
            objDespatchRelatedList.toDateSearch.Despatch_Date__c = System.today();
            objDespatchRelatedList.searchStatus = 'Delivered*';
            System.assertEquals(null, objDespatchRelatedList.searchByFilter());
            
            //searchContent == '' && fromDate = null && toDate != null && searchStatus == ''
            objDespatchRelatedList.searchContent = '';
            objDespatchRelatedList.fromDateSearch.Despatch_Date__c = null;
            objDespatchRelatedList.toDateSearch.Despatch_Date__c = System.today();
            objDespatchRelatedList.searchStatus = '';
            System.assertEquals(null, objDespatchRelatedList.searchByFilter());
            
            //searchContent == '' && fromDate = null && toDate == null && searchStatus != ''
            objDespatchRelatedList.searchContent = '';
            objDespatchRelatedList.fromDateSearch.Despatch_Date__c = null;
            objDespatchRelatedList.toDateSearch.Despatch_Date__c = null;
            objDespatchRelatedList.searchStatus = 'Delivered*';
            System.assertEquals(null, objDespatchRelatedList.searchByFilter());
            
            ApexPages.currentPage().getParameters().put('despatchId', listDespatch[0].Id); 
            System.assertEquals('/' + listDespatch[0].Id, objDespatchRelatedList.openDespatch().getUrl());
            ApexPages.currentPage().getParameters().put('desId', listDespatch[0].Id); 
            System.assertEquals('/' + listDespatch[0].Id + '/e?retURL=%2F' + listAccount[0].Id, objDespatchRelatedList.editDespatch().getUrl());
            objDespatchRelatedList.listDespatch.add(listDespatch[0]);
            objDespatchRelatedList.deleteDespatch();
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
    
    // Creating Despatch records
    public static List<Despatch__c> getDespatchRecords(Integer pNumberOfRecords){
        
        Despatch__c oDespatch = new Despatch__c();
        List<Despatch__c> listDespatch = new List<Despatch__c>();
        
        for(Integer i =0 ; i < pNumberOfRecords ; i++){
            oDespatch = new Despatch__c();
            oDespatch.Slug__c = 'DHL';
            listDespatch.add(oDespatch);       
        }
        return listDespatch;
    }
}