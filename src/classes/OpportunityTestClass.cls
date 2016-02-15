@isTest
private class OpportunityTestClass
{
    static string p1_id;
    public static testMethod void testOpportunityClasses() 
    {        
        VisitorFormGlobalVariables__c gv = VisitorFormGlobalVariables__c.getInstance();      
        string p_id = gv.ProjectId__c; 

        //Run as Fioranze user
        Profile p = [select id from profile where name='IPad Wadala Profile']; 
        OppTest(p_id);
        
     }
    public static void  OppTest(String pid)
    {
        Opportunity oppty = [Select Id,Name, Budgeted_Price__c,Lead_Source_Details__c,LeadSource, Type_of_Accomodation__c,AccountId from Opportunity where Project_Name__c =:pid LIMIT 1];    
        String page1 = '/apex/OpportunityPage?aid=' + oppty.AccountId + '&pid=' + pid;                
        PageReference pageRef1 = new PageReference(page1);        
        Test.setCurrentPage(pageRef1);         
        ApexPages.StandardController controller1 = new ApexPages.StandardController(oppty);  
        OpportunityExtensions ctrl1 =  new OpportunityExtensions(controller1);
        //ctrl1.o = oppty;
        ctrl1.accomTypes = new String[]{'2 BHK','3 BHK'};
        ctrl1.leadsource = 'Web';
        ctrl1.getItems();    
        ctrl1.getLeadSourceList();
        ctrl1.goBack();
        ctrl1.submitOpportunity();  
        
        String page2 = '/apex/OpportunityPage?aid=' + oppty.AccountId + '&pid=' + pid + '&id=' + oppty.Id;                
        PageReference pageRef2 = new PageReference(page2);        
        Test.setCurrentPage(pageRef2);
        oppty = [Select Id,Name, Budgeted_Price__c,Lead_Source_Details__c,LeadSource, Type_of_Accomodation__c,AccountId from Opportunity where Project_Name__c =:pid LIMIT 1];    
        ApexPages.StandardController controller2 = new ApexPages.StandardController(oppty);  
        OpportunityExtensions ctrl2 =  new OpportunityExtensions(controller2);
        ctrl2.o = oppty;
        ctrl2.accomTypes = new String[]{'2 BHK','3 BHK'};
        ctrl2.leadsource = 'Web';
        ctrl2.getItems();    
        ctrl2.getLeadSourceList();
        ctrl2.goBack();
        ctrl2.submitOpportunity();
        
        
        String page3 = '/apex/OpportunityPage?aid=' + oppty.AccountId + '&pid=' + pid + '&id=' + oppty.Id;                
        PageReference pageRef3 = new PageReference(page3);        
        Test.setCurrentPage(pageRef3);
        oppty = [Select Total_Consideration_Value__c,stagename,Booking_Date__c,Id,Name, Budgeted_Price__c,Lead_Source_Details__c,LeadSource, Type_of_Accomodation__c,AccountId from Opportunity where Project_Name__c =:pid LIMIT 1];    
        oppty.stagename='cancelled';
        oppty.Total_Consideration_Value__c='';
        oppty.Booking_Date__c=system.today();      
        update oppty;
        ApexPages.StandardController controller3 = new ApexPages.StandardController(oppty);  
        OpportunityExtensions ctrl3 =  new OpportunityExtensions(controller3);
        ctrl3.o = oppty;
        ctrl3.accomTypes = new String[]{'2 BHK','3 BHK'};
        ctrl3.leadsource = 'Web';
        ctrl3.getItems();    
        ctrl3.getLeadSourceList();
        ctrl3.goBack();
        ctrl3.submitOpportunity();
        ctrl3.ProjectName='Lodha Fiorenza'; 
        ctrl3.getItems();   
        ctrl3.ProjectName='New Cuffe Parade'; 
        ctrl3.getItems(); 
        ctrl3.ProjectName='The Park'; 
        ctrl3.getItems(); 
    }
}