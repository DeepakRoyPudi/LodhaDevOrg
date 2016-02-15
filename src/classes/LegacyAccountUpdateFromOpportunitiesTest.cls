/*
*    Description : Test Class for LegacyAccountUpdateFromOpportunities
*
*       Date        Version      Name     Description
*    28/08/2014       1.0       Asmita    Initial Draft
*/

@isTest
private class LegacyAccountUpdateFromOpportunitiesTest {

    static testMethod void LegacyAccountDataUpdateTest() {
         // Creating Account records
        List<Project_Name__c> listAllProject = new List<Project_Name__c>();
        List<Opportunity> listAllOpportunity = new List<Opportunity>();
        Account oAcc = new Account();
        List<Account> listAccountInBatch = new List<Account>();
        Database.Querylocator qryLocator;
        Database.Batchablecontext bc;
        
        List<Account> listAccount = LegacyAccountUpdateFromOpportunitiesTest.getAccountRecord(1);
        insert listAccount;
        
        // Creating a project to link with Opportunity Mandatory field
        List<Project_Name__c> listProject = LegacyAccountUpdateFromOpportunitiesTest.getProjectrecords('Casa Bella', 1);
        listAllProject.addAll(listProject);
        listProject = LegacyAccountUpdateFromOpportunitiesTest.getProjectrecords('Casa Bella Gold', 1);
        listAllProject.addAll(listProject);
        listProject = LegacyAccountUpdateFromOpportunitiesTest.getProjectrecords('Lodha Aria', 1);
        listAllProject.addAll(listProject);
        listProject = LegacyAccountUpdateFromOpportunitiesTest.getProjectrecords('Lakeshore Greens', 1);
        listAllProject.addAll(listProject);
        insert listAllProject;
        
        // Creating Opportunity Records
        List<Opportunity> listOpportunity = LegacyAccountUpdateFromOpportunitiesTest.getOpportunityRecords('ClubCASA', 1);
        listOpportunity[0].AccountId = listAccount[0].Id;
        listOpportunity[0].Project_Name__c = listAllProject[0].Id;
        listOpportunity[0].Visit_Form_No__c = '111222333';
        listAllOpportunity.addAll(listOpportunity);
        listOpportunity = LegacyAccountUpdateFromOpportunitiesTest.getOpportunityRecords('ClubCASA', 1);
        listOpportunity[0].AccountId = listAccount[0].Id;
        listOpportunity[0].Project_Name__c = listAllProject[1].Id;
        listOpportunity[0].Purpose__c = 'Staying there';
        listOpportunity[0].Visit_Form_No__c = '111222334';
        listAllOpportunity.addAll(listOpportunity);
        insert listAllOpportunity;
        
        LegacyAccountUpdateFromOpportunities oLegacyAccountUpdate = new LegacyAccountUpdateFromOpportunities();
        
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
    
    // Creating Account records
    public static List<Account> getAccountRecord(Integer pNumberOfRecords){
        
        Account oAcc = new Account();
        List<Account> listAccount = new List<Account>();
        
        for(Integer i = 0 ; i < pNumberOfRecords; i++){
            
            oAcc = new Account();
            oAcc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            oAcc.LastName = 'Test Trigger';
            oAcc.Mobile_Phone__c = '9111111111';
            oAcc.Address1_R_cont__pc = 'Lodha Excellus';
            oAcc.Address2_R_cont__pc = 'Apollo Mills';
            oAcc.Address2_O_cont__pc = 'Apollo Mills';
            oAcc.Address3_R_cont__pc = 'Mahalaxmi';
            oAcc.City_cont__pc = 'Mumbai';
            oAcc.Pincode_R_cont__pc = '422120';
            oAcc.Lead_Company_Name_cont__pc = 'Lodha';
            oAcc.Designation__pc = 'CXO';
            oAcc.Address3_O_cont__pc = 'Lower Parel';
            oAcc.Type_of_Home__c = '1 BHK';
            //oAcc.Existing_Booked_Customer__c = 'Yes';
            oAcc.Current_Home_ownership__c = 'Owned';
            
            listAccount.add(oAcc);
        }
        
        return listAccount;
    }// end of getAccountRecords
    
    // Creating Project Name records
     public static List<Project_Name__c> getProjectRecords(String pStrProjectName, Integer pNumberOfRecords){
         
         Project_Name__c oProject = new Project_Name__c();
         List<Project_Name__c> listProject = new List<Project_Name__c>();
         
         for(Integer i = 0; i < pNumberOfRecords; i++){
             
             oProject = new Project_Name__c();
             
             oProject.Project_Type__c = 'Casa';
             oProject.Record_Type__c = 'Residential';
             oProject.Name = pStrProjectName;
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
            oOpp.StageName = 'Closed Won';
            oOpp.Servicing_Team__c = 'Presales';
            oOpp.Name_of_PSC__c = 'Amarjyot Kaur';
            oOpp.Expected_Close_Date__c = System.today();
            oOpp.CloseDate = System.today();
            oOpp.LeadSource = pStrLeadSource;
            oOpp.Marketing_Source__c = 'Cross Project';
            oOpp.Purpose__c = 'Personal Use';
            oOpp.Purpose__c = 'Gift';
            oOpp.Date_of_Visit__c = System.today();
            oOpp.Visiting_on_behalf_of__c = 'Self';
            oOpp.Possession_desired_in__c = 'Ready to move in';
            oOpp.Walk_in_Source__c = 'TV';
            oOpp.Budgeted_Price__c = 20000000;
            oOpp.Type_of_Accomodation__c = '1 BHK';
            
            listOpportunity.add(oOpp);
        }
        
        return listOpportunity;
        
    }// end of getOpportunityRecords()
}