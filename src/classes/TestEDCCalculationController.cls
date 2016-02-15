/*
 *    Test Class for EDCCalculationController
 */
@isTest(seealldata = false)
private class TestEDCCalculationController {

    static testMethod void myUnitTest() {
        
        EDC_for_opportunity__c edcopp=new EDC_for_opportunity__c();
        edcopp.Name='Test';
        edcopp.Project_Type__c='Casa';
        edcopp.EDC_from_Created_date__c='0';
        edcopp.EDC_from_Visit_date__c='0';
        edcopp.Upper_Limit__c='0';
        edcopp.Call_Attempt_Limit__c='0';
        edcopp.Call_Attempt_EDC__c='0';
        insert edcopp;
        
        
        /* ****************************************** */    
        Account a=new Account();
        a.FirstName='Test';
        a.LastName='One';
        a.Personal_Email__pc='test1@cg.com';
        
        insert a;
        
        Project_Name__c project=new Project_Name__c();
        project.Name='Test_project_1';
        project.Project_Type__c='Casa';
        
        insert project;
        
        Project_Name__c project2=new Project_Name__c();
        project2.Name='Test_project_2';
        project2.Project_Type__c='Casa';
        
        insert project2;
        
        Opportunity opp=new Opportunity();
        opp.Name='Testopp';
        opp.AccountId=a.Id;
        opp.Project_Name__c=project.Id;
        opp.Date_of_Visit__c =system.today();
        opp.StageName='Qualified';
        opp.Visit_Form_No__c='XPLV00024';
        opp.Walk_in_Source__c='Web';
        opp.CloseDate=system.today();
        
        insert opp;
        
        opp.Name='Testopp';
        opp.AccountId=a.Id;
        opp.Project_Name__c=project2.Id;
        opp.StageName='Qualified';
        opp.Date_of_Visit__c = system.today();
        opp.Visit_Form_No__c='XPLV00024';
        opp.Walk_in_Source__c='Web';
        opp.CloseDate=system.today();
        update opp;
        
        Call_Attempts__c call=new Call_Attempts__c();
        call.Opportunity__c = opp.Id;
        call.Project__c = project.Id;
        call.Call_Type__c = 'Email';
        call.Call_Attempt_Status__c = 'Visit Proposed';
        call.Next_Action_Date__c = system.Today();
        call.Proposed_Date_of_Visit__c = date.newinstance(2013, 9, 1);
        call.Attempted_By__c = 'Presales';
        call.Call_Attempted_by__c = 'Group B';
        
        insert call;

        
        /* ***************************************** */   
        
        Account a1=new Account();
        a1.FirstName='Test1';
        a1.LastName='One1';
        a1.Personal_Email__pc='test11@cg.com';
       
        insert a1;
        
        Project_Name__c project1=new Project_Name__c();
        project1.Name='Test100';
        project1.Project_Type__c='Lodha Bellissimo';
       
        insert project1;
        
        Opportunity opp1=new Opportunity();
        opp1.Name='Testopp100';
        opp1.AccountId=a1.Id;
        opp1.Project_Name__c=project1.Id;
        opp1.StageName = 'Closed Book';
        opp1.CRM_form__c = true;
        opp1.Date_of_Visit__c = system.today();
        opp1.Application_Form__c = true;
        opp1.Visit_Form_No__c='XPLV00025';
        opp1.Walk_in_Source__c='Web';
        opp1.CloseDate=system.today();
        opp1.IsActive__c=true;
        opp1.Multiple_Booking__c=false;
        
        insert opp1;
    }
}