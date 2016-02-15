/*
*    Description : Test Class for AccountUpdateFromOpportunityHelper
*
*       Date        Version      Name     Description
*    27/08/2014       1.0       Asmita    Initial Draft
*/

@isTest
private class AccountUpdateFromOpportunityHelperTest {

    static testMethod void updateAccountAfterInsertTest() {
        // Creating Account records
        List<Project_Name__c> listAllProject = new List<Project_Name__c>();
        List<Opportunity> listAllOpportunity = new List<Opportunity>();
        
        List<Account> listAccount = AccountUpdateFromOpportunityHelperTest.getAccountRecord(1);
        insert listAccount;
        
        // Creating a project to link with Opportunity Mandatory field
        List<Project_Name__c> listProject = AccountUpdateFromOpportunityHelperTest.getProjectrecords('Casa Bella', 1);
        listAllProject.addAll(listProject);
        listProject = AccountUpdateFromOpportunityHelperTest.getProjectrecords('Casa Bella Gold', 1);
        listAllProject.addAll(listProject);
        insert listAllProject;
        
        // Creating Opportunity Records
        List<Opportunity> listOpportunity = AccountUpdateFromOpportunityHelperTest.getOpportunityRecords(1);
        listOpportunity[0].AccountId = listAccount[0].Id;
        listOpportunity[0].Project_Name__c = listAllProject[0].Id;
        listOpportunity[0].Visit_Form_No__c = '111222333';
        listAllOpportunity.addAll(listOpportunity);
        listOpportunity = AccountUpdateFromOpportunityHelperTest.getOpportunityRecords(1);
        listOpportunity[0].AccountId = listAccount[0].Id;
        listOpportunity[0].Project_Name__c = listAllProject[1].Id;
        listOpportunity[0].Purpose__c = 'Staying there';
        listOpportunity[0].Visit_Form_No__c = '111222334';
        listAllOpportunity.addAll(listOpportunity);
        test.startTest();
            insert listAllOpportunity;
        test.stopTest();
        
        List<Account> listUpdatedAccount = [select Id, 
                                                   Product_History__c, 
                                                   Reason_for_Purchase__c, 
                                                   Cross_Project_Exposure__c, 
                                                   Booked_Customers__c, 
                                                   Visit_Count__c
                                            from Account
                                            where id = :listAccount[0].Id]; 
        List<Opportunity> listInsertedOpportunity = [select Id,
                                                            Project_Name__r.Name,
                                                            Purpose__c
                                                     from Opportunity
                                                     where AccountId = :listAccount[0].Id];
        System.debug('Project Name ::::::: ' + listUpdatedAccount[0].Product_History__c);
        System.assertEquals(listUpdatedAccount[0].Product_History__c.contains(listInsertedOpportunity[0].Project_Name__r.Name), true);
        System.assertEquals(listUpdatedAccount[0].Reason_for_Purchase__c.contains(listInsertedOpportunity[0].Purpose__c), true);
        System.assertEquals(listUpdatedAccount[0].Cross_Project_Exposure__c, listInsertedOpportunity.size());
        System.assertEquals(listUpdatedAccount[0].Visit_Count__c, listInsertedOpportunity.size());
        System.assertEquals(listUpdatedAccount[0].Booked_Customers__c, true);
        
    }
    
    static testMethod void updateAccountAfterUpdateTest() {
        // Creating Account records
        List<Project_Name__c> listAllProject = new List<Project_Name__c>();
        List<Opportunity> listAllOpportunity = new List<Opportunity>();
        
        List<Account> listAccount = AccountUpdateFromOpportunityHelperTest.getAccountRecord(1);
        insert listAccount;
        
        // Creating a project to link with Opportunity Mandatory field
        List<Project_Name__c> listProject = AccountUpdateFromOpportunityHelperTest.getProjectrecords('Casa Bella', 1);
        listAllProject.addAll(listProject);
        listProject = AccountUpdateFromOpportunityHelperTest.getProjectrecords('Casa Bella Gold', 1);
        listAllProject.addAll(listProject);
        listProject = AccountUpdateFromOpportunityHelperTest.getProjectrecords('Lodha Aria', 1);
        listAllProject.addAll(listProject);
        insert listAllProject;
        
        // Creating Opportunity Records
        List<Opportunity> listOpportunity = AccountUpdateFromOpportunityHelperTest.getOpportunityRecords(1);
        listOpportunity[0].AccountId = listAccount[0].Id;
        listOpportunity[0].Project_Name__c = listAllProject[0].Id;
        listOpportunity[0].Visit_Form_No__c = '111222333';
        listAllOpportunity.addAll(listOpportunity);
        listOpportunity = AccountUpdateFromOpportunityHelperTest.getOpportunityRecords(1);
        listOpportunity[0].AccountId = listAccount[0].Id;
        listOpportunity[0].Project_Name__c = listAllProject[1].Id;
        listOpportunity[0].Visit_Form_No__c = '111222334';
        listAllOpportunity.addAll(listOpportunity);
        insert listAllOpportunity;
        
        listOpportunity[0].Project_Name__c = listAllProject[2].Id;
        listOpportunity[0].Purpose__c = 'Staying there';
        test.startTest();
            AccountUpdateFromOpportunityHelper.isExecuteOnUpdateOrDelete = false;
            update listAllOpportunity;
        test.stopTest();
        
        List<Account> listUpdatedAccount = [select Id, 
                                                   Product_History__c, 
                                                   Reason_for_Purchase__c, 
                                                   Cross_Project_Exposure__c, 
                                                   Booked_Customers__c, 
                                                   Visit_Count__c
                                            from Account
                                            where id = :listAccount[0].Id]; 
        List<Opportunity> listUpdatedOpportunity = [select Id,
                                                            Project_Name__r.Name,
                                                            Purpose__c
                                                     from Opportunity
                                                     where AccountId = :listAccount[0].Id];
        System.assertEquals(listUpdatedAccount[0].Product_History__c.contains(listUpdatedOpportunity[0].Project_Name__r.Name), true);
        System.assertEquals(listUpdatedAccount[0].Reason_for_Purchase__c.contains(listUpdatedOpportunity[0].Purpose__c), true);
        System.assertEquals(listUpdatedAccount[0].Cross_Project_Exposure__c, listUpdatedOpportunity.size());
        System.assertEquals(listUpdatedAccount[0].Visit_Count__c, listUpdatedOpportunity.size());
        System.assertEquals(listUpdatedAccount[0].Booked_Customers__c, true);
    }
    
    static testMethod void updateAccountAfterDeleteTest() {
        // Creating Account records
        List<Project_Name__c> listAllProject = new List<Project_Name__c>();
        List<Opportunity> listAllOpportunity = new List<Opportunity>();
        
        List<Account> listAccount = AccountUpdateFromOpportunityHelperTest.getAccountRecord(1);
        insert listAccount;
        
        // Creating a project to link with Opportunity Mandatory field
        List<Project_Name__c> listProject = AccountUpdateFromOpportunityHelperTest.getProjectrecords('Casa Bella', 1);
        listAllProject.addAll(listProject);
        listProject = AccountUpdateFromOpportunityHelperTest.getProjectrecords('Lodha Aria', 1);
        listAllProject.addAll(listProject);
        listProject = AccountUpdateFromOpportunityHelperTest.getProjectrecords('Lakeshore Greens', 1);
        listAllProject.addAll(listProject);
        insert listAllProject;
        
        // Creating Opportunity Records
        List<Opportunity> listOpportunity = AccountUpdateFromOpportunityHelperTest.getOpportunityRecords(1);
        listOpportunity[0].AccountId = listAccount[0].Id;
        listOpportunity[0].Project_Name__c = listAllProject[0].Id;
        listOpportunity[0].Visit_Form_No__c = '111222333';
        listAllOpportunity.addAll(listOpportunity);
        listOpportunity = AccountUpdateFromOpportunityHelperTest.getOpportunityRecords(1);
        listOpportunity[0].AccountId = listAccount[0].Id;
        listOpportunity[0].Project_Name__c = listAllProject[1].Id;
        listOpportunity[0].Visit_Form_No__c = '111222334';
        listAllOpportunity.addAll(listOpportunity);
        insert listAllOpportunity;
        test.startTest();
            AccountUpdateFromOpportunityHelper.isExecuteOnUpdateOrDelete = false; 
            delete listAllOpportunity;
        test.stopTest();
    }
    
    // Trigger to insert bulk opportunities
    static testmethod void bulkOpportunityInsertTest(){
        
        List<Account> listAccount = AccountUpdateFromOpportunityHelperTest.getAccountRecord(2);
        insert listAccount;
        
        List<Project_Name__c> listProject = AccountUpdateFromOpportunityHelperTest.getProjectrecords('Test Project', 200);
        insert listProject;
        
        List<Opportunity> listOfOpportunity = AccountUpdateFromOpportunityHelperTest.getOpportunityRecords(200);
        for(Integer i = 0 ; i < 100 ; i++){
            listOfOpportunity[i].AccountId = listAccount[0].Id;
            listOfOpportunity[i].Project_Name__c = listProject[i].Id;
            if(i <= 9){
                listOfOpportunity[i].Visit_Form_No__c = '11122200' + i; 
            }
            else if(i > 9 && i <= 99){
                listOfOpportunity[i].Visit_Form_No__c = '1112220' + i;
            }
        }
        for(Integer i = 100 ; i < 200 ; i++){
            listOfOpportunity[i].AccountId = listAccount[1].Id;
            listOfOpportunity[i].Project_Name__c = listProject[i].Id;
            listOfOpportunity[i].Visit_Form_No__c = '111222' + i;
        }
        
        test.StartTest();
            insert listOfOpportunity;
        test.stopTest();
        
        List<Account> listUpdatedAccount = [select Id, 
                                                   Product_History__c, 
                                                   Reason_for_Purchase__c, 
                                                   Cross_Project_Exposure__c, 
                                                   Booked_Customers__c, 
                                                   Visit_Count__c
                                            from Account
                                            where id = :listAccount[0].Id]; 
        List<Opportunity> listInsertedOpportunity = [select Id,
                                                            Project_Name__r.Name,
                                                            Purpose__c
                                                     from Opportunity
                                                     where AccountId = :listAccount[0].Id];
        for(Opportunity oOpp : listInsertedOpportunity){
            System.assertEquals(listUpdatedAccount[0].Product_History__c.contains(oOpp.Project_Name__r.Name), true);
            System.assertEquals(listUpdatedAccount[0].Reason_for_Purchase__c.contains(oOpp.Purpose__c), true);
        }
        System.assertEquals(listUpdatedAccount[0].Cross_Project_Exposure__c, listInsertedOpportunity.size());
        System.assertEquals(listUpdatedAccount[0].Visit_Count__c, listInsertedOpportunity.size());
        System.assertEquals(listUpdatedAccount[0].Booked_Customers__c, true);
    }
    
    // Trigger to update bulk opportunities
    static testmethod void bulkOpportunityUpdateTest(){
        
        List<Account> listAccount = AccountUpdateFromOpportunityHelperTest.getAccountRecord(2);
        insert listAccount;
        
        List<Project_Name__c> listProject = AccountUpdateFromOpportunityHelperTest.getProjectrecords('Test Project', 200);
        insert listProject;
        
        List<Opportunity> listOfOpportunity = AccountUpdateFromOpportunityHelperTest.getOpportunityRecords(200);
        for(Integer i = 0 ; i < 100 ; i++){
            listOfOpportunity[i].AccountId = listAccount[0].Id;
            listOfOpportunity[i].Project_Name__c = listProject[i].Id;
            if(i <= 9){
                listOfOpportunity[i].Visit_Form_No__c = '11122200' + i; 
            }
            else if(i > 9 && i <= 99){
                listOfOpportunity[i].Visit_Form_No__c = '1112220' + i;
            }
        }
        for(Integer i = 100 ; i < 200 ; i++){
            listOfOpportunity[i].AccountId = listAccount[1].Id;
            listOfOpportunity[i].Project_Name__c = listProject[i].Id;
            listOfOpportunity[i].Visit_Form_No__c = '111222' + i;
        }
        insert listOfOpportunity;
        
        for(Integer i = 0 ; listOfOpportunity.size() < 100 ; i++){
            listOfOpportunity[i].Purpose__c = 'Staying there';
        }
        for(Integer i = 100 ; listOfOpportunity.size() < 200 ; i++){
            listOfOpportunity[i].Marketing_Source__c = 'ClubCASA';
        }
        
        test.StartTest();
            AccountUpdateFromOpportunityHelper.isExecuteOnUpdateOrDelete = false;
            update listOfOpportunity;
        test.stopTest();
        
        List<Account> listUpdatedAccount = [select Id, 
                                                   Product_History__c, 
                                                   Reason_for_Purchase__c, 
                                                   Cross_Project_Exposure__c, 
                                                   Booked_Customers__c, 
                                                   Visit_Count__c
                                            from Account
                                            where id in :listAccount]; 
        List<Opportunity> listUpdatedOpportunity = [select Id,
                                                            Project_Name__r.Name,
                                                            Purpose__c
                                                     from Opportunity
                                                     where AccountId in :listAccount];
        for(Opportunity oOpp : listUpdatedOpportunity){
            System.assertEquals(listUpdatedAccount[0].Reason_for_Purchase__c.contains(oOpp.Purpose__c), true);
        }
        System.assertEquals(listUpdatedAccount[1].Cross_Project_Exposure__c, 100);
        System.assertEquals(listUpdatedAccount[0].Booked_Customers__c, true);
    }
    
    // Trigger to delete bulk opportunities
    static testmethod void bulkOpportunityDeleteTest(){
        
        List<Account> listAccount = AccountUpdateFromOpportunityHelperTest.getAccountRecord(2);
        insert listAccount;
        
        List<Project_Name__c> listProject = AccountUpdateFromOpportunityHelperTest.getProjectrecords('Test Project', 200);
        insert listProject;
        
        List<Opportunity> listOfOpportunity = AccountUpdateFromOpportunityHelperTest.getOpportunityRecords(200);
        for(Integer i = 0 ; i < 100 ; i++){
            listOfOpportunity[i].AccountId = listAccount[0].Id;
            listOfOpportunity[i].Project_Name__c = listProject[i].Id;
            if(i <= 9){
                listOfOpportunity[i].Visit_Form_No__c = '11122200' + i; 
            }
            else if(i > 9 && i <= 99){
                listOfOpportunity[i].Visit_Form_No__c = '1112220' + i;
            }
        }
        for(Integer i = 100 ; i < 200 ; i++){
            listOfOpportunity[i].AccountId = listAccount[1].Id;
            listOfOpportunity[i].Project_Name__c = listProject[i].Id;
            listOfOpportunity[i].Visit_Form_No__c = '111222' + i;
        }
        insert listOfOpportunity;
        
        test.StartTest();
            AccountUpdateFromOpportunityHelper.isExecuteOnUpdateOrDelete = false;
            delete listOfOpportunity;
        test.stopTest();
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
             oProject.Name = pStrProjectName + i+1;
             oProject.CRN_INIT__c = '100';
             
             listProject.add(oProject);
         }
         
         return listProject;
     }// end of getProjectrecords()
     
     // Creating Opportunity Records
    public static List<Opportunity> getOpportunityRecords(Integer pNumberOfRecords){
        
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
            oOpp.LeadSource = 'ClubCASA';
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