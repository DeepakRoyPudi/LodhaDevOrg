/*
*    Description : Test Class for LegacyAccountUpdatesOpportunity
*
*    Version                    Date                    Author                        Description
*    1.0                        23/07/2014              Asmita(Eternus)            Initial Draft
*/

@isTest
private class LegacyAccountUpdatesOpportunityTest {

    static testMethod void accountUpdateTest() {
    	
    	Account oAcc = new Account();
    	List<Account> listAccountInBatch = new List<Account>();
    	Database.Querylocator qryLocator;
    	Database.Batchablecontext bc;
        
        // Creating a project to link with Opportunity Mandatory field
        List<Project_Name__c> listProject = LegacyAccountUpdatesOpportunityTest.getProjectrecords(1);
        insert listProject;
        
        // Creating Account record with Possession Type
        List<Account> listAccount = LegacyAccountUpdatesOpportunityTest.getAccountRecords('Ready to Move In', 1);
        insert listAccount;
        
        // Creating an Opportunity related to above account with Possession type
        List<Opportunity> listOpportunity = LegacyAccountUpdatesOpportunityTest.getOpportunityRecords('Ready to Move In',1);
        listOpportunity[0].AccountId = listAccount[0].Id;
        listOpportunity[0].Project_Name__c = listProject[0].Id;
        insert listOpportunity;
        
        listOpportunity = LegacyAccountUpdatesOpportunityTest.getOpportunityRecords('Under Construction < 1 year',1);
        listOpportunity[0].AccountId = listAccount[0].Id;
        listOpportunity[0].Project_Name__c = listProject[0].Id;
        insert listOpportunity;
        
        // Creating another Account with Type of Accomodation and Possession type as null        
        listAccount = LegacyAccountUpdatesOpportunityTest.getAccountRecords(null, 1);
        listAccount[0].Type_of_Accommodation_Required__c = null;
        insert listAccount;
        
        // Creating an Opportunity related to above account
        listOpportunity = LegacyAccountUpdatesOpportunityTest.getOpportunityRecords('',1);
        listOpportunity[0].AccountId = listAccount[0].Id;
        listOpportunity[0].Project_Name__c = listProject[0].Id;
        insert listOpportunity;
        
        LegacyAccountUpdatesOpportunity oLegacyAccountUpdate = new LegacyAccountUpdatesOpportunity();
        
        Test.startTest();
            qryLocator = oLegacyAccountUpdate.start(bc);
            
            Database.Querylocatoriterator qryLocatorIterator = qryLocator.iterator();
            while(qryLocatorIterator.hasNext()){
                
                oAcc = (Account)qryLocatorIterator.next();
                listAccountInBatch.add(oAcc);
                
            }// end of while
            
            oLegacyAccountUpdate.execute(bc, listAccountInBatch);
            oLegacyAccountUpdate.finish(bc);
           
        Test.stopTest();
        
    }
    
    // testing getPossessionTypeValue value
    static testMethod void getPossessionTypeValueTest() {
        
        LegacyAccountUpdatesOpportunity oLegacyAccountUpdate = new LegacyAccountUpdatesOpportunity();
        System.assertEquals(oLegacyAccountUpdate.getPossessionTypeValue('Ready to Move In'), 'Ready to Move In');
        System.assertEquals(oLegacyAccountUpdate.getPossessionTypeValue('Under Construction < 1 year'), '6 to 12 Months');
        System.assertEquals(oLegacyAccountUpdate.getPossessionTypeValue('Under Construction 1 - 2 years'), '1 to 2 Years');
        System.assertEquals(oLegacyAccountUpdate.getPossessionTypeValue('Under Construction > 2 years'), '2 to 5 Years');
    }
    
    // Creating Project Name records
     public static List<Project_Name__c> getProjectRecords(Integer pNumberOfRecords){
         
         Project_Name__c oProject = new Project_Name__c();
         List<Project_Name__c> listProject = new List<Project_Name__c>();
         
         for(Integer i = 0; i < pNumberOfRecords; i++){
             
             oProject = new Project_Name__c();
             
             oProject.Project_Type__c = 'Casa';
             oProject.Record_Type__c = 'Residential';
             oProject.Name = 'Casa Bella';
             oProject.CRN_INIT__c = '100';
             
             listProject.add(oProject);
         }
         
         return listProject;
     }// end of getProjectrecords()
    
    // Creating Account records
    public static List<Account> getAccountRecords(String pStrPossessionType, Integer pNumberOfRecords){
        
        Account oAcc = new Account();
        List<Account> listAccount = new List<Account>();
        
        for(Integer i = 0 ; i < pNumberOfRecords; i++){
            
            oAcc = new Account();
            oAcc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            oAcc.LastName = 'Test Account Rec';
            oAcc.Mobile_Phone__c = '9111111111';
            oAcc.Possession_Type__c = pStrPossessionType;
            oAcc.Type_of_Accommodation_Required__c = '3 BHK';
            
            listAccount.add(oAcc);
        }
        
        return listAccount;
    }// end of getAccountRecords
    
    // Creating Opportunity Records
    public static List<Opportunity> getOpportunityRecords(String pStrPossessionType, Integer pNumberOfRecords){
        
        Opportunity oOpp = new Opportunity();
        List<Opportunity> listOpportunity = new List<Opportunity>();
        
        for(Integer i = 0; i < pNumberOfrecords; i++){
            
            oOpp = new Opportunity();
            
            oOpp.Name = 'Test Opporunity Trigger';
            oOpp.StageName = 'Qualification';
            oOpp.Servicing_Team__c = 'Presales';
            oOpp.Expected_Close_Date__c = System.today();
            oOpp.CloseDate = System.today();
            oOpp.Possession_desired_in__c = pStrPossessionType;
            oOpp.Type_of_Accomodation__c = '5 BHK';
            
            listOpportunity.add(oOpp);
        }
        
        return listOpportunity;
        
    }// end of getOpportunityRecords()
}