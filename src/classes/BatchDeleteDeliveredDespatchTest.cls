/*    Description: Test Class for BatchDeleteDeliveredDespatch Aftership Integration
*    
*    Version            Date            Author                    Description
*    1.0                02/09/2014      Asmita(Eternus)           Initial Draft
*/

@isTest
private class BatchDeleteDeliveredDespatchTest {

    static testMethod void deleteDespatchFromAftershipTest() {
    	
    	Database.Querylocator qryLocator;
    	Database.Batchablecontext bc;
    	BatchDeleteDeliveredDespatch objBatchDeleteDespatch = new BatchDeleteDeliveredDespatch();
    	Despatch__c oDespatch = new Despatch__c();
    	
        // Setting MockCallout class which will call respond method of MochHttpResponseForAftership
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseForAftership());
        
         // Creating Account
        List<Account> listAccount = BatchDeleteDeliveredDespatchTest.getAccountRecord(1);
        insert listAccount;
        
        List<Despatch__c> listDespatch = BatchDeleteDeliveredDespatchTest.getDespatchRecords(1);
        listDespatch[0].Account__c = listAccount[0].Id;
        insert listDespatch;
        
        test.startTest();
            qryLocator = objBatchDeleteDespatch.start(bc);
            
            Database.Querylocatoriterator qryLocatorIterator = qryLocator.iterator();
            while(qryLocatorIterator.hasNext()){
                
                oDespatch = (Despatch__c)qryLocatorIterator.next();
                listDespatch.add(oDespatch);
                
            }// end of while
            
            objBatchDeleteDespatch.execute(bc, listDespatch);
            objBatchDeleteDespatch.finish(bc);
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
    
    // creating the Despatch Records
    public static List<Despatch__c> getDespatchRecords(Integer pNumberOfRecords){
        Despatch__c oDespatch = new Despatch__c();
        List<Despatch__c> listDespatch = new List<Despatch__c>();
        
        for(Integer i = 0 ; i < pNumberOfRecords ; i++){
            oDespatch = new Despatch__c();
            oDespatch.Waybill_No__c = 'RA123456543HK';
            oDespatch.Slug__c = 'hong-kong-post';
            oDespatch.Last_Delivery_Status__c = 'Delivery';
            
            listDespatch.add(oDespatch);       
        }
        return listDespatch;
    }
}