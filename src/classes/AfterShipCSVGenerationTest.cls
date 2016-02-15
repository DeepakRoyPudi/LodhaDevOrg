/*
*        Description : Test Class for AfterShipCSVGeneration
*
*        Version     Date          Author             Description
*        1.0         01/09/2014    Asmita(Eternus)    Intial Draft
*/

@isTest
private class AfterShipCSVGenerationTest {

    static testMethod void aftershipCsvContentsGenerationTest() {
    	
    	List<Despatch__c> listAllDespatch = new List<Despatch__c>();
    	
    	List<CourierSlugMapping__c> listCourierSlugMapping = AfterShipCSVGenerationTest.getCourierSlugMappingRecords(1);
    	insert listCourierSlugMapping;
    	
    	// Creating Account
        List<Account> listAccount = AfterShipCSVGenerationTest.getAccountRecord(1);
        insert listAccount;
        
        List<Despatch__c> listDespatch = AfterShipCSVGenerationTest.getDespatchRecords(1);
        listDespatch[0].Account__c = listAccount[0].Id;
        listAllDespatch.addAll(listDespatch);
        listDespatch = AfterShipCSVGenerationTest.getDespatchRecords(1);
        listDespatch[0].Account__c = listAccount[0].Id;
        listDespatch[0].Slug__c = '';
        listAllDespatch.addAll(listDespatch);
        insert listDespatch; 
        
        AfterShipCSVGeneration.generateCSVString();
    }
    
    // Creating CourierSlugMapping custom setting records
    public static List<CourierSlugMapping__c> getCourierSlugMappingRecords(Integer pNumberOfRecords){
    
        CourierSlugMapping__c oSetting = new CourierSlugMapping__c();
        List<CourierSlugMapping__c> listCourierSlugMapping = new List<CourierSlugMapping__c>();
        
        for(Integer i = 0 ; i < pNumberOfRecords; i++){
            
            oSetting = new CourierSlugMapping__c();
            oSetting.Name = 'DHL';
            oSetting.Slug__c = 'dhl';
            
            listCourierSlugMapping.add(oSetting);
        }
        return listCourierSlugMapping;
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
    
    // Creating Despatch records
    public static List<Despatch__c> getDespatchRecords(Integer pNumberOfRecords){
        
        Despatch__c oDespatch = new Despatch__c();
        List<Despatch__c> listDespatch = new List<Despatch__c>();
        
        for(Integer i =0 ; i < pNumberOfRecords ; i++){
            oDespatch = new Despatch__c();
            oDespatch.Slug__c = 'DHL';
            oDespatch.Waybill_No__c = 'DABQ12387543';
            listDespatch.add(oDespatch);       
        }
        return listDespatch;
    }
}