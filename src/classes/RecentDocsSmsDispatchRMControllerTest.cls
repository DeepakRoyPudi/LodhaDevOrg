/* Version  			Created By   	 Created Date       Description
 *
 * 	Initial Draft		Sneha P.         18/05/2015       Test Class for RecentDocsSmsDispatchController
 *
 */
@isTest
private class RecentDocsSmsDispatchRMControllerTest {

    static testMethod void validateTest() {
    	 
    	 //Create Account record 
    	 Account acc = createAccount();
    	 
    	 //Create Document records
    	 createDoc(6, acc);
    	 
    	 //Create SMS Records
    	 createSms(6, acc);
    	 
    	 //Create Dispatch Records
    	 createDispatch(6, acc);
    	 
    	 RecentDocsSmsDispatchRMController objController = new RecentDocsSmsDispatchRMController();    
    	 objController.PARAM_CRN= '154215';
         objController.noOfRecords=5;
         
         //Check if only 5 records for document are displayed
         system.assertEquals( 5, objController.docList.size());
         
          //Check if only 5 records for SMS are displayed
         system.assertEquals( 5, objController.smsWrapperList.size());
         
         //Check if only 5 records for Dispatch are displayed
         system.assertEquals( 5, objController.dispatchList.size());
         
         ApexPages.currentPage().getParameters().put('selectedTab', 'Document');
         objController.viewAll();
		 system.assertEquals(objController.tab,'Document');
    }
    
    // Method to create test data for Dispatch object
    private static list<Despatch__c> createDispatch(Integer noOfRecords, Account acc) {
    	
    	list<Despatch__c> dispatchList = new list<Despatch__c>();
    	
    	for(Integer i=0; i<noOfRecords ; i++){
    		dispatchList.add(new Despatch__c(Customer_No__c = '154215', Account__c = acc.Id,
    										 Waybill_No__c = '1221'+i, Contents__c = 'Test Process' ));
    									 	
    	}
    	insert dispatchList;
    	return dispatchList;
    }
    
    // Method to create test data for SMS History object
    private static list<SMS_History__c> createSms(Integer noOfRecords, Account acc) {
    	
    	list<SMS_History__c> smsList = new list<SMS_History__c>();
    	
    	for(Integer i=0; i<noOfRecords ; i++){
    		smsList.add(new SMS_History__c(CRN__c = '154215', Account__c = acc.Id,
    									   Mobile_Number__c = '237',
    									   SMS_Text__c = 'Revenue Process' ));
    									 	
    	}
    	insert smsList;
    	return smsList;
    }
    
    // Method to create test data for Document object
    private static list<Documents__c> createDoc(Integer noOfRecords, Account acc) {
    	
    	list<Documents__c> docList = new list<Documents__c>();
    	
    	for(Integer i=0; i<noOfRecords ; i++){
    		docList.add(new Documents__c(CRN__c = '154215', Account__c = acc.Id,
    									 Document_Category__c = 'Revenue Process' ));
    									 	
    	}
    	insert docList;
    	return docList;
    }
    
    // Method to create test data for Account object
    private static Account createAccount(){
        Account objAccount = new Account();
        objAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Booked Account').getRecordTypeId();
        objAccount.FirstName='Test1 ';
        objAccount.LastName='Account1';
        objAccount.CRN__c='154215';
        objAccount.H_Mobile_No__c='1234560789';
        objAccount.Mobile_Phone__c='21241222';
        objAccount.Co_Applicant__c='test';
        insert objAccount;
        return objAccount;
      }  
}