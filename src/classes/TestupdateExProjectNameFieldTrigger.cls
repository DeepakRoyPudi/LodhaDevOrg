@isTest

private class TestupdateExProjectNameFieldTrigger{

    static testMethod void myUnitTest() {
    
            Project_Name__c projectname=new Project_Name__c();
            projectname.Name='Test_Pradeep';
            projectname.Project_Type__c='Aspirational';
            projectname.Record_Type__c='Residential';      
            insert projectname;
            
            
            
    
    }



}