/*
*        Description : Test Class for UpdateDespatchLastStatusFromAftership
*
*        Version     Date          Author             Description
*        1.0         03/09/2014    Asmita(Eternus)    Intial Draft
*/

@isTest
private class UpdateDespatchLastStatusFrmAftershipTest {

    static testMethod void DepatchLastDeliveryTest() {
    	
    	// Creating Account
        List<Account> listAccount = UpdateDespatchLastStatusFrmAftershipTest.getAccountRecord(1);
        insert listAccount;
        
        List<Despatch__c> listDespatch = UpdateDespatchLastStatusFrmAftershipTest.getDespatchRecords(1);
        listDespatch[0].Account__c = listAccount[0].Id;
        insert listDespatch;
        
        // Setting MockCallout class which will call respond method of MochHttpResponseForAftership
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseForAftershipLastDelivery());
        
        test.startTest();
            UpdateDespatchLastStatusFromAftership oUpdateLastDelivery = new UpdateDespatchLastStatusFromAftership();
            UpdateDespatchLastStatusFromAftership.MainWrapper oMainWrapper = new UpdateDespatchLastStatusFromAftership.MainWrapper();
            UpdateDespatchLastStatusFromAftership.DataWrapper oDataWrapper = new UpdateDespatchLastStatusFromAftership.DataWrapper();
            UpdateDespatchLastStatusFromAftership.TrackingWrapper oTrackingWrap = new UpdateDespatchLastStatusFromAftership.TrackingWrapper();
            UpdateDespatchLastStatusFromAftership.CheckpointWrapper oCheckWrap = new UpdateDespatchLastStatusFromAftership.CheckpointWrapper();
            //UpdateDespatchLastStatusFromAftership oUpdateLastDelivery1 = new UpdateDespatchLastStatusFromAftership();
            oUpdateLastDelivery.getTrackings();
            oUpdateLastDelivery.updateLastStatus();
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
            oDespatch.Waybill_No__c = '123456789';
            oDespatch.Slug__c = 'dhl';
            
            listDespatch.add(oDespatch);       
        }
        return listDespatch;
    }
}