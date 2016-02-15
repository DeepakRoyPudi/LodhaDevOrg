/*
*        Description : Test Class for DocumentRelatedListController
*
*        Version     Date          Author             Description
*        1.0         01/09/2014    Asmita(Eternus)    Intial Draft
*/

@isTest
private class DocumentRelatedListControllerTest {

    static testMethod void documentRelatedListTest() {
        
        ApexPages.StandardController sc;
        DocumentRelatedListController objDocumentRelatedList;
        
        // Creating Account
        List<Account> listAccount = DocumentRelatedListControllerTest.getAccountRecord(1);
        insert listAccount;
        
        List<Documents__c> listDocument = DocumentRelatedListControllerTest.getDocumentRecords(1);
        listDocument[0].Account__c = listAccount[0].Id;
        insert listDocument;
        
        // Creating User Of Functional Team Lead Profile
        User objTestUser = DocumentRelatedListControllerTest.getUserRecord('Customer Care');
        insert objTestUser;
        
        test.startTest();
            
            ApexPages.currentPage().getParameters().put('id',listAccount[0].Id);
            sc = new ApexPages.StandardController(listAccount[0]);
            objDocumentRelatedList = new DocumentRelatedListController(sc);
            
            System.runAs(objTestUser){
                
                objDocumentRelatedList.renderActionLinks();
            }
            
            objDocumentRelatedList.toggleSort();
            
            //searchName != '' && fromDate != null && toDate != null
            objDocumentRelatedList.searchName = 'testFile*';
            objDocumentRelatedList.fromDateSearch.Despatch_Date__c = System.today();
            objDocumentRelatedList.toDateSearch.Despatch_Date__c = System.today(); 
            System.assertEquals(null, objDocumentRelatedList.searchByFilter());
        
            //searchName != '' && fromDate != null && toDate == null
            objDocumentRelatedList.searchName = 'testFile*';
            objDocumentRelatedList.fromDateSearch.Despatch_Date__c = System.today();
            objDocumentRelatedList.toDateSearch.Despatch_Date__c = null;
            System.assertEquals(null, objDocumentRelatedList.searchByFilter());
        
            //searchName != '' && fromDate == null && toDate != null
            objDocumentRelatedList.searchName = 'testFile*';
            objDocumentRelatedList.fromDateSearch.Despatch_Date__c = null;
            objDocumentRelatedList.toDateSearch.Despatch_Date__c = System.today();
            System.assertEquals(null, objDocumentRelatedList.searchByFilter());
        
            //searchName != '' && fromDate == null && toDate == null
            objDocumentRelatedList.searchName = 'testFile*';
            objDocumentRelatedList.fromDateSearch.Despatch_Date__c = null;
            objDocumentRelatedList.toDateSearch.Despatch_Date__c = null;
            System.assertEquals(null, objDocumentRelatedList.searchByFilter());
        
            //searchName == '' && fromDate != null && toDate != null
            objDocumentRelatedList.searchName = '';
            objDocumentRelatedList.fromDateSearch.Despatch_Date__c = System.today();
            objDocumentRelatedList.toDateSearch.Despatch_Date__c = System.today();
            System.assertEquals(null, objDocumentRelatedList.searchByFilter());
        
            //searchName == '' && fromDate == null && toDate != null
            objDocumentRelatedList.searchName = '';
            objDocumentRelatedList.fromDateSearch.Despatch_Date__c = null;
            objDocumentRelatedList.toDateSearch.Despatch_Date__c = System.today();
            System.assertEquals(null, objDocumentRelatedList.searchByFilter());
        
            //searchName == '' && fromDate != null && toDate == null
            objDocumentRelatedList.searchName = '';
            objDocumentRelatedList.fromDateSearch.Despatch_Date__c = System.today();
            objDocumentRelatedList.toDateSearch.Despatch_Date__c = null;
            System.assertEquals(null, objDocumentRelatedList.searchByFilter());
            
            ApexPages.currentPage().getParameters().put('docId', listDocument[0].Id); 
            
            System.assertEquals(null, objDocumentRelatedList.generateDocuments());
            System.assertEquals(null, objDocumentRelatedList.displayIss());
            System.assertEquals(null, objDocumentRelatedList.displayReport());
            System.assertEquals('/' + listDocument[0].Id, objDocumentRelatedList.openDocument().getUrl());
            System.assertEquals('/' + listDocument[0].Id + '/e?retURL=%2F' + listAccount[0].Id, objDocumentRelatedList.editDocument().getUrl());
            objDocumentRelatedList.listDocument.add(listDocument[0]);
            objDocumentRelatedList.deleteDocument();
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
    
    // Creating Custom Documents records
    public static List<Documents__c> getDocumentRecords(Integer pNumberOfRecords){
        
        Documents__c oDoc = new Documents__c();
        List<Documents__c> listDocument = new List<Documents__c>();
        
        for(Integer i = 0 ; i < pNumberOfRecords; i++){
            
            oDoc = new Documents__c();
            oDoc.Name = 'Test Doc 1';
            oDoc.Date_of_Generation__c = System.now();
            listDocument.add(oDoc);
        }
        return listDocument;
    }
    
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
}