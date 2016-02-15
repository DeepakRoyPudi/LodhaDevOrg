/*
*    Description : Test class for Account trigger Helper to map the Zone value depending on the selected Suburb
*
*       Date        Version      Name     Description
*    22/07/2014       1.0       Asmita    Initial Draft
*/
 
@isTest
private class AccountZoneSuburbMappingHelperTest {
	
	private static final String strSuburb1 = 'Koti';
    private static final String strSuburb2 = 'RC Puram';
    private static final String strSuburb3 = 'Parel';
    private static final String strSuburb4 = 'Karve Road';
    	
    private static final String strZone1 = 'Central Hyderabad';
    private static final String strZone2 = 'North Hyderabad';
    private static final String strZone3 = 'South Central';
    private static final String strZone4 = 'West Pune';
    
    // Method for testing the trigger for before Insert
    static testMethod void insertZoneSuburbMappingTest() {
    	List<Account> listInsertedAccount = new List<Account>();
    	List<Account> listAllAccount = new List<Account>();
        
        List<ZoneSuburbMapping__c> listAllZoneSuburbMapping = new List<ZoneSuburbMapping__c>();
        
        // Creating Custom Setting record for ZoneSuburbMapping
        List<ZoneSuburbMapping__c> listZoneSuburbMapping = AccountZoneSuburbMappingHelperTest.getZoneSuburbMappingRecords(strSuburb1, strZone1, 1);
        listAllZoneSuburbMapping.addAll(listZoneSuburbMapping);
        
        listZoneSuburbMapping = AccountZoneSuburbMappingHelperTest.getZoneSuburbMappingRecords(strSuburb2, strZone2, 1);
        listAllZoneSuburbMapping.addAll(listZoneSuburbMapping);
        
        listZoneSuburbMapping = AccountZoneSuburbMappingHelperTest.getZoneSuburbMappingRecords(strSuburb3, strZone3, 1);
        listAllZoneSuburbMapping.addAll(listZoneSuburbMapping);
        
        listZoneSuburbMapping = AccountZoneSuburbMappingHelperTest.getZoneSuburbMappingRecords(strSuburb4, strZone4, 1);
        listAllZoneSuburbMapping.addAll(listZoneSuburbMapping);
        insert listAllZoneSuburbMapping;
        
        // Creating Account records
        List<Account> listAccount = AccountZoneSuburbMappingHelperTest.getAccountRecord(strSuburb1, strSuburb3, 1);
        insert listAccount;
        listInsertedAccount = [select Zone_O_cont__pc, Zone_R_cont__pc, RecordTypeId from Account where id = :listAccount[0].id];
        System.assertEquals(ZoneSuburbMapping__c.getValues(listAccount[0].Suburb_O_cont__pc).Zone__c, listInsertedAccount[0].Zone_O_cont__pc);
        System.assertEquals(ZoneSuburbMapping__c.getValues(listAccount[0].Suburb_R_cont__pc).Zone__c, listInsertedAccount[0].Zone_R_cont__pc);
        listAllAccount.add(listAccount[0]);
        
        listAccount = AccountZoneSuburbMappingHelperTest.getAccountRecord(strSuburb1, null, 1);
        insert listAccount;
        listInsertedAccount = [select Zone_O_cont__pc, Zone_R_cont__pc, RecordTypeId from Account where id = :listAccount[0].id];
        System.assertEquals(ZoneSuburbMapping__c.getValues(listAccount[0].Suburb_R_cont__pc).Zone__c, listInsertedAccount[0].Zone_R_cont__pc);
        System.assertEquals(null, listAccount[0].Zone_O_cont__pc);
        listAllAccount.add(listAccount[0]);
        
        listAccount = AccountZoneSuburbMappingHelperTest.getAccountRecord(null, strSuburb4, 1);
        insert listAccount;
        listInsertedAccount = [select Zone_O_cont__pc, Zone_R_cont__pc, RecordTypeId from Account where id = :listAccount[0].id];
        System.assertEquals(null, listAccount[0].Zone_R_cont__pc);
        System.assertEquals(ZoneSuburbMapping__c.getValues(listAccount[0].Suburb_O_cont__pc).Zone__c, listInsertedAccount[0].Zone_O_cont__pc);
        listAllAccount.add(listAccount[0]);
        
    }// end of insertZoneSuburbMappingTest()
    
    // Method for testing the trigger for before Update
    static testMethod void updateZoneSuburbMappingTest() {
        
        List<Account> listAllAccount = new List<Account>();
        List<Account> listAccountUpdate = new List<Account>();
        Map<Id, Account> MapAccountUpdate = new Map<Id, Account>();
        Map<Id, Account> mapAccountInserted = new Map<Id, Account>();
         
        List<ZoneSuburbMapping__c> listAllZoneSuburbMapping = new List<ZoneSuburbMapping__c>();
        
        // Creating Custom Setting record for ZoneSuburbMapping
        List<ZoneSuburbMapping__c> listZoneSuburbMapping = AccountZoneSuburbMappingHelperTest.getZoneSuburbMappingRecords(strSuburb1, strZone1, 1);
        listAllZoneSuburbMapping.addAll(listZoneSuburbMapping);
        
        listZoneSuburbMapping = AccountZoneSuburbMappingHelperTest.getZoneSuburbMappingRecords(strSuburb2, strZone2, 1);
        listAllZoneSuburbMapping.addAll(listZoneSuburbMapping);
        
        listZoneSuburbMapping = AccountZoneSuburbMappingHelperTest.getZoneSuburbMappingRecords(strSuburb3, strZone3, 1);
        listAllZoneSuburbMapping.addAll(listZoneSuburbMapping);
        
        listZoneSuburbMapping = AccountZoneSuburbMappingHelperTest.getZoneSuburbMappingRecords(strSuburb4, strZone4, 1);
        listAllZoneSuburbMapping.addAll(listZoneSuburbMapping);
        insert listAllZoneSuburbMapping;
        
        // Inserting bulk Account Records
        List<Account> listAccount = AccountZoneSuburbMappingHelperTest.getAccountRecord(strSuburb1, strSuburb3, 2);
        insert listAccount;
        listAllAccount.addAll(listAccount);
        
        // Updating the Account Records
        if(!listAllAccount.isEmpty()){ 
            listAllAccount[0].Suburb_O_cont__pc = strSuburb2;
            listAllAccount[0].Suburb_R_cont__pc = null;
            AccountZoneSuburbMappingHelper.isExecuteOnUpdateOrDelete = false;
            update listAllAccount[0];
	        listAccountUpdate = [select id, Zone_O_cont__pc, Zone_R_cont__pc, Suburb_O_cont__pc, Suburb_R_cont__pc, RecordTypeId from Account where id = :listAllAccount[0].id];
	        System.assertEquals(ZoneSuburbMapping__c.getValues(listAllAccount[0].Suburb_O_cont__pc).Zone__c, listAccountUpdate[0].Zone_O_cont__pc);
	        System.assertEquals(null, listAccountUpdate[0].Zone_R_cont__pc);
	
	        listAllAccount[1].Suburb_O_cont__pc = null;
            listAllAccount[1].Suburb_R_cont__pc = strSuburb4;
            
            AccountZoneSuburbMappingHelper.isExecuteOnUpdateOrDelete = false;
            update listAllAccount[1];
	        listAccountUpdate = [select Zone_O_cont__pc, Zone_R_cont__pc, Suburb_R_cont__pc, Suburb_O_cont__pc, RecordTypeId from Account where id = :listAllAccount[1].id];
	        System.assertEquals(ZoneSuburbMapping__c.getValues(listAllAccount[1].Suburb_R_cont__pc).Zone__c, listAccountUpdate[0].Zone_R_cont__pc);
	        System.assertEquals(null, listAccountUpdate[0].Zone_O_cont__pc);
	        
	        listAllAccount[0].Suburb_O_cont__pc = strSuburb1;
            listAllAccount[0].Suburb_R_cont__pc = strSuburb3;
            AccountZoneSuburbMappingHelper.isExecuteOnUpdateOrDelete = false;
            update listAllAccount[0];
	        listAccountUpdate = [select id, Zone_O_cont__pc, Zone_R_cont__pc, Suburb_O_cont__pc, Suburb_R_cont__pc, RecordTypeId from Account where id = :listAllAccount[0].id];
	        System.assertEquals(ZoneSuburbMapping__c.getValues(listAllAccount[0].Suburb_O_cont__pc).Zone__c, listAccountUpdate[0].Zone_O_cont__pc);
	        System.assertEquals(ZoneSuburbMapping__c.getValues(listAllAccount[0].Suburb_R_cont__pc).Zone__c, listAccountUpdate[0].Zone_R_cont__pc);
	    
        }
        System.debug('ListAllAccount is Empty......');
              
    }// end of updateZoneSuburbMappingTest()
    
    static testmethod void bulkInsertZoneSuburbMappingTest(){
        
        List<Account> listInsertedAccount = new List<Account>();
    	List<Account> listAllAccount = new List<Account>();
        List<ZoneSuburbMapping__c> listAllZoneSuburbMapping = new List<ZoneSuburbMapping__c>();
        
        // Creating Custom Setting record for ZoneSuburbMapping
        List<ZoneSuburbMapping__c> listZoneSuburbMapping = AccountZoneSuburbMappingHelperTest.getZoneSuburbMappingRecords(strSuburb1, strZone1, 1);
        listAllZoneSuburbMapping.addAll(listZoneSuburbMapping);
        
        listZoneSuburbMapping = AccountZoneSuburbMappingHelperTest.getZoneSuburbMappingRecords(strSuburb2, strZone2, 1);
        listAllZoneSuburbMapping.addAll(listZoneSuburbMapping);
        
        listZoneSuburbMapping = AccountZoneSuburbMappingHelperTest.getZoneSuburbMappingRecords(strSuburb3, strZone3, 1);
        listAllZoneSuburbMapping.addAll(listZoneSuburbMapping);
        
        listZoneSuburbMapping = AccountZoneSuburbMappingHelperTest.getZoneSuburbMappingRecords(strSuburb4, strZone4, 1);
        listAllZoneSuburbMapping.addAll(listZoneSuburbMapping);
        insert listAllZoneSuburbMapping;
        
        List<Account> listAccount = AccountZoneSuburbMappingHelperTest.getAccountRecord(strSuburb1, strSuburb3, 200);
        insert listAccount;
        listAllAccount.addAll(listAccount);
        
        // Checking the value of Zone are assigned correctly by System.seertEquals
	    listInsertedAccount = [select Zone_O_cont__pc, Zone_R_cont__pc, Suburb_R_cont__pc, Suburb_O_cont__pc, RecordTypeId from Account where id in :listAccount];
	    for(Integer i = 0; i < listInsertedAccount.size(); i++){
            System.assertEquals(ZoneSuburbMapping__c.getValues(listInsertedAccount[i].Suburb_O_cont__pc).Zone__c, listInsertedAccount[i].Zone_O_cont__pc);
            System.assertEquals(ZoneSuburbMapping__c.getValues(listInsertedAccount[i].Suburb_R_cont__pc).Zone__c, listInsertedAccount[i].Zone_R_cont__pc);
	    }
    }
    
    static testmethod void bulkUpdateZoneSuburbMappingTest(){
        
        List<Account> listAllAccount = new List<Account>();
        List<Account> listAccountUpdate = new List<Account>();
        Map<Id, Account> MapAccountUpdate = new Map<Id, Account>();
        Map<Id, Account> mapAccountInserted = new Map<Id, Account>();
        List<ZoneSuburbMapping__c> listAllZoneSuburbMapping = new List<ZoneSuburbMapping__c>();
        
        // Creating Custom Setting record for ZoneSuburbMapping
        List<ZoneSuburbMapping__c> listZoneSuburbMapping = AccountZoneSuburbMappingHelperTest.getZoneSuburbMappingRecords(strSuburb1, strZone1, 1);
        listAllZoneSuburbMapping.addAll(listZoneSuburbMapping);
        
        listZoneSuburbMapping = AccountZoneSuburbMappingHelperTest.getZoneSuburbMappingRecords(strSuburb2, strZone2, 1);
        listAllZoneSuburbMapping.addAll(listZoneSuburbMapping);
        
        listZoneSuburbMapping = AccountZoneSuburbMappingHelperTest.getZoneSuburbMappingRecords(strSuburb3, strZone3, 1);
        listAllZoneSuburbMapping.addAll(listZoneSuburbMapping);
        
        listZoneSuburbMapping = AccountZoneSuburbMappingHelperTest.getZoneSuburbMappingRecords(strSuburb4, strZone4, 1);
        listAllZoneSuburbMapping.addAll(listZoneSuburbMapping);
        insert listAllZoneSuburbMapping;
        
         // Inserting bulk Account Records
        List<Account> listAccount = AccountZoneSuburbMappingHelperTest.getAccountRecord(strSuburb1, strSuburb3, 200);
        insert listAccount;
        listAllAccount.addAll(listAccount);
        
        if(!listAllAccount.isEmpty()){ 
	    
	        // Updating the Account records in bulk
	        for(Integer i = 0; i < listAllAccount.size(); i++){
	    	
	    	    mapAccountInserted.put(listAllAccount[i].Id, listAllAccount[i]);
	    	
	            listAllAccount[i].Suburb_O_cont__pc = strSuburb3;
                listAllAccount[i].Suburb_R_cont__pc = strSuburb4;
		
	            MapAccountUpdate.put(listAllAccount[i].Id, listAllAccount[i]);
	        }
	        
	        AccountZoneSuburbMappingHelper.isExecuteOnUpdateOrDelete = false;
	        if(!MapAccountUpdate.isEmpty())
	            update MapAccountUpdate.values();
	            
	        // Checking the value of Zone are assigned correctly by System.seertEquals
	        listAccountUpdate = [select id, Zone_O_cont__pc, Zone_R_cont__pc, Suburb_R_cont__pc, Suburb_O_cont__pc, RecordTypeId from Account where id in :mapAccountInserted.keySet()];
	        for(Integer i = 0; i < listAccountUpdate.size(); i++){
	        	
	            System.assertEquals(ZoneSuburbMapping__c.getValues(listAccountUpdate[i].Suburb_O_cont__pc).Zone__c, listAccountUpdate[i].Zone_O_cont__pc);
	            System.assertEquals(ZoneSuburbMapping__c.getValues(listAccountUpdate[i].Suburb_R_cont__pc).Zone__c, listAccountUpdate[i].Zone_R_cont__pc);
	        }
	        
        }
    }
    
    // Creating Custom setting records
    public static List<ZoneSuburbMapping__c> getZoneSuburbMappingRecords(String pStrSuburb, String pStrZone, Integer pNumberOfRecords){
        
        ZoneSuburbMapping__c oZoneSuburb = new ZoneSuburbMapping__c();
        List<ZoneSuburbMapping__c> listZoneSuburbMapping = new List<ZoneSuburbMapping__c>();
        
        for(Integer i = 0; i < pNumberOfRecords ; i++){
            
            oZoneSuburb = new ZoneSuburbMapping__c();            
            oZoneSuburb.Name = pStrSuburb;
            oZoneSuburb.Zone__c = pStrZone;        
            listZoneSuburbMapping.add(oZoneSuburb);
        }
        
        return listZoneSuburbMapping;
    }// end of getZoneSuburbMappingRecords()
    
    // Creating Account records
    public static List<Account> getAccountRecord(String pStrSuburbR, String pStrSuburbO, Integer pNumberOfRecords){
        
        Account oAcc = new Account();
        List<Account> listAccount = new List<Account>();
        
        for(Integer i = 0 ; i < pNumberOfRecords; i++){
            
            oAcc = new Account();
            oAcc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            oAcc.LastName = 'Test Trigger';
            oAcc.Mobile_Phone__c = '9111111111';
            oAcc.Suburb_O_cont__pc = pStrSuburbO;
            oAcc.Suburb_R_cont__pc = pStrSuburbR;
            
            listAccount.add(oAcc);
        }
        
        return listAccount;
    }// end of getAccountRecords
}