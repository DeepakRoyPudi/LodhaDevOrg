/* Version              Created By       Created Date       Description
 *
 *  Initial Draft       Sneha P.         11/04/2015       This class contains unit tests for validating
 *														  the behavior of 
 *														  RecentDocsSMSDispatchDetailRMController class
 */
 
@isTest
private class RecentDocsSMSDispatchDetailRMCtlTest {
	
	//Test Method to check initial no of Records for Document and the search document functionaltiy 
	static testMethod void DocumentTest() {
		//Create an Account record
		Account objAccount = RecentDocsSMSDispatchDetailRMCtlTest.createAccount();
      	insert objAccount;
		
		//Create Doc records
		list<Documents__c> docList =createDoc(objAccount, 15);
		insert docList;
		
        PageReference Pageref=Page.RecentDocsSMSDispatchDetailRm;
        System.test.setCurrentPageReference(Pageref);
        
		ApexPages.CurrentPage().getparameters().put('CRN',objAccount.CRN__c);
        ApexPages.CurrentPage().getparameters().put('selectedTab','Document');
        
		RecentDocsSMSDispatchDetailRMController  objController = new RecentDocsSMSDispatchDetailRMController();
		
		Test.startTest();
			system.assertEquals(objController.PARAM_CRN, objAccount.CRN__c);
			
			//Check if the current tab is Document
			system.assertEquals('Document', objController.currentTab);
			system.assertEquals(10, objController.docList.size());
			
			// Assign a Date range and check the search Doc functionality
			objController.fromDateSearch.Date_of_Generation__c = system.Today();
			objController.toDateSearch.Date_of_Generation__c = system.Today();
			
			objController.searchDocs();
			
			objController.sortDir = 'asc NULLS Last';
		    objController.toggleSortDoc();
		    
		    system.assert(objController.getprev() == true);
		     system.assert(objController.getnxtDoc() == true);
		    
		    objController.LastPageDoc();
			
		    objController.generateDocuments();
		    system.assert(objController.doc_generate_page == System.Label.GenerateDocumentAddress);

		    objController.displayIss();
		    objController.displayReport();
		    
		    apexpages.currentpage().getparameters().put('docId',docList[0].Id);
		    objController.deleteDetailDocument();
		    
		    list<Documents__c> updatedDocList = [Select Id from Documents__c 
		    							   where Account__c =: objAccount.Id];
		    							   
		    //Assert to check if the list size is updated to 14 after deletion
		    system.assertEquals(14, updatedDocList.size());
		    
		    apexpages.currentpage().getparameters().put('currTab', 'SMS');
		    objController.resetOnTabChange();
		Test.stopTest();
    }
    
    /* Test Method to check flow when SMS tab is current Tab and the search SMS functionaltiy
     */ 
    static testMethod void SMSTest() {
		//Create an Account record
		Account objAccount = RecentDocsSMSDispatchDetailRMCtlTest.createAccount();
      	insert objAccount;
		
		//Create SMS records
		list<SMS_History__c> smsList =createSMS(objAccount, 15);
		insert smsList;
		
        PageReference Pageref=Page.RecentDocsSMSDispatchDetailRm;
        System.test.setCurrentPageReference(Pageref);
        
		ApexPages.CurrentPage().getparameters().put('CRN',objAccount.CRN__c);
        ApexPages.CurrentPage().getparameters().put('selectedTab','SMS');
        
		RecentDocsSMSDispatchDetailRMController  objController = new RecentDocsSMSDispatchDetailRMController();
		
		Test.startTest();
			system.assertEquals(objController.PARAM_CRN, objAccount.CRN__c);
			
			//Check if the current tab is SMS
			system.assertEquals(objController.currentTab, 'SMS');
			//Check if only first 10 records are displayed on Page
			system.assertEquals(10, objController.smsList.size());
			
			//objController.sms.SMS_Type__c = 'Sent';
			objController.getSmsType();
			objController.selectedSmsType = 'Sent';
		    objController.sms.Created_Date__c = system.Today();
			objController.smsDateTo.Created_Date__c = system.Today();
			
		    objController.searchSms();
		    
		    objController.sortDir = 'asc NULLS First';
		    objController.toggleSortSMS();
		    system.assert(objController.getnxt() == true);
		    objController.LastPage();
		    
		    apexpages.currentpage().getparameters().put('currTab', 'Dispatch');
		    objController.resetOnTabChange();
		    //Check if tab is changed to Dispatch
		    system.assertEquals(objController.currentTab, 'Dispatch');
							
		Test.stopTest();
    }
    
    /* Test Method to check flow when Dispatch tab is current Tab and the search Dispatch functionaltiy
     */ 
    static testMethod void DispatchTest() {
		//Create an Account record
		Account objAccount = RecentDocsSMSDispatchDetailRMCtlTest.createAccount();
      	insert objAccount;
		
		//Create Dispatch records
		list<Despatch__c> dispatchList =createDispatch(objAccount, 15);
		insert dispatchList;
		
        PageReference Pageref=Page.RecentDocsSMSDispatchDetailRm;
        System.test.setCurrentPageReference(Pageref);
        
		ApexPages.CurrentPage().getparameters().put('CRN',objAccount.CRN__c);
        ApexPages.CurrentPage().getparameters().put('selectedTab','Dispatch');
        
		RecentDocsSMSDispatchDetailRMController  objController = new RecentDocsSMSDispatchDetailRMController();
		
		Test.startTest();
			system.assertEquals(objController.PARAM_CRN, objAccount.CRN__c);
			
			//Check if the current tab is Dispatch
			system.assertEquals(objController.currentTab, 'Dispatch');
			//system.assertEquals(objController.smsList.size(), 4);
			
			system.assertEquals(objController.getnxtDispatch(), true);
			
			objController.next();
			objController.LastPageDispatch();
			system.assertEquals(objController.getprev(), false);
			objController.previous();
			objController.FirstPage();
			
			//Set the values in search fields
			objController.dispatch.Contents__c = 'Test';
		    objController.dispatch.Last_Delivery_Status__c = 'Sent';
		    objController.dispatchDateFrom.Despatch_Date__c = system.today();
		    objController.dispatchDateTo.Despatch_Date__c = system.today();
			
			//Check if all 15 records are fetched for the above parameters
		    objController.searchDispatch();
		    system.assertEquals(15, objController.mapDispatch.size());
		    
		    objController.sortDir = 'asc NULLS Last';
		    objController.toggleSortDispatch();
		    
		    apexpages.currentpage().getparameters().put('currTab', 'Documents');
		    objController.resetOnTabChange();
		    
			//system.assertEquals(objController.smsList.size(), 4);
							
		Test.stopTest();
    }
    
    private static list<Despatch__c> createDispatch(Account acc , Integer noOfRecd) {
    	list<Despatch__c> dispatchList = new list<Despatch__c>();
    	
    	for(Integer i=0 ; i < noOfRecd ; i++ ) {
    		dispatchList.add(new Despatch__c(Account__c = acc.Id, 
    										Despatch_Date__c = system.today(),
    										Waybill_No__c = '3454554'+i,
    										Courier_Name__c = 'Test',
    										Contents__c = 'Test '+i,
    										Last_Delivery_Status__c = 'Sent'
    										));
    	}
    	
    	return dispatchList;
    }
    
    private static list<SMS_History__c> createSMS(Account acc , Integer noOfRecd) {
    	list<SMS_History__c> smsList = new list<SMS_History__c>();
    	
    	for(Integer i=0 ; i < noOfRecd ; i++ ) {
    		smsList.add(new SMS_History__c(Account__c = acc.Id, CRN__c = acc.CRN__c,
    										Mobile_Number__c = '1234567'+i,
    										SMS_Text__c = 'Test SMS',
    										Status__c = 'Sent',
    										SMS_Type__c = 'Sent'));
    	}
    	
    	return smsList;
    }
    
    private static list<Documents__c> createDoc(Account acc , Integer noOfRecd) {
    	list<Documents__c> docList = new list<Documents__c>();
    	
    	for(Integer i=0 ; i < noOfRecd ; i++ ) {
    		docList.add(new Documents__c(Account__c = acc.Id, CRN__c = acc.CRN__c));
    	}
    	
    	return docList;
    }
    
    private static Account createAccount() {
        Account objAccount = new Account();
        objAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Booked Account').getRecordTypeId();
        objAccount.FirstName='Test1';
        objAccount.LastName='Account1';
        objAccount.CRN__c='154215';
        objAccount.H_Mobile_No__c='1234560789';
        objAccount.Mobile_Phone__c='21241222';
        objAccount.Co_Applicant__c='test';
        return objAccount;
     } 
      
}