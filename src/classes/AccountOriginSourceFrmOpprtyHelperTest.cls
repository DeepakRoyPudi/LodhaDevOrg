/*
*    Description : Helper class for After Insert Opportunity trigger to populate the Account Lead Origin value 
*                  with related first Opportunity Lead Source
*
*       Date        Version      Name     Description
*    22/07/2014       1.0       Asmita    Initial Draft
*/

@isTest
private class AccountOriginSourceFrmOpprtyHelperTest {

    static testMethod void populateAccountOriginSourceHelperTest() {
        
        List<Account> listUpdatedAccount = new List<Account>();
        
        // Creating Account records
        List<Account> listAccount = AccountOriginSourceFrmOpprtyHelperTest.getAccountRecord(1);
        insert listAccount;
        
        // Creating a project to link with Opportunity Mandatory field
        List<Project_Name__c> listProject = AccountOriginSourceFrmOpprtyHelperTest.getProjectrecords(1);
        insert listProject;
        
        // Creating Opportunity Records
        List<Opportunity> listOpportunity = AccountOriginSourceFrmOpprtyHelperTest.getOpportunityRecords('ClubCASA', 1);
        listOpportunity[0].AccountId = listAccount[0].Id;
        listOpportunity[0].Project_Name__c = listProject[0].Id;
        insert listOpportunity;
        
        listOpportunity = AccountOriginSourceFrmOpprtyHelperTest.getOpportunityRecords('Email', 1);
        listOpportunity[0].AccountId = listAccount[0].Id;
        listOpportunity[0].Project_Name__c = listProject[0].Id;
        insert listOpportunity;
        
        // Creating Opportunity Records in bulk
        listOpportunity = AccountOriginSourceFrmOpprtyHelperTest.getOpportunityRecords('Just Dial', 200);
        for(Integer i = 0; i < listOpportunity.size(); i++){
            listOpportunity[i].AccountId = listAccount[0].Id;
            listOpportunity[i].Project_Name__c = listProject[0].Id;
        }
        insert listOpportunity;
        
        // Checking whether the Account Origin Lead Source is populated with firstly created Opportunity value
        listUpdatedAccount = [select id, Origin_Source_of_Lead__c from Account where id = :listAccount[0].Id and RecordTypeId = :Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId()];
        System.assertEquals('ClubCASA', listUpdatedAccount[0].Origin_Source_of_Lead__c);
    }
    
    // Creating Account records
    public static List<Account> getAccountRecord(Integer pNumberOfRecords){
        
        Account oAcc = new Account();
        List<Account> listAccount = new List<Account>();
        
        for(Integer i = 0 ; i < pNumberOfRecords; i++){
            
            oAcc = new Account();
            oAcc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            oAcc.LastName = 'Test Trigger';
            oAcc.Mobile_Phone__c = '9111111111';
            
            listAccount.add(oAcc);
        }
        
        return listAccount;
    }// end of getAccountRecords
    
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
     
     // Creating Opportunity Records
    public static List<Opportunity> getOpportunityRecords(String pStrLeadSource, Integer pNumberOfRecords){
        
        Opportunity oOpp = new Opportunity();
        List<Opportunity> listOpportunity = new List<Opportunity>();
        
        for(Integer i = 0; i < pNumberOfrecords; i++){
            
            oOpp = new Opportunity();
            
            oOpp.Name = 'Test Opporunity Trigger';
            oOpp.StageName = 'Qualification';
            oOpp.Servicing_Team__c = 'Presales';
            oOpp.Expected_Close_Date__c = System.today();
            oOpp.CloseDate = System.today();
            oOpp.LeadSource = pStrLeadSource;
            
            listOpportunity.add(oOpp);
        }
        
        return listOpportunity;
        
    }// end of getOpportunityRecords()
}