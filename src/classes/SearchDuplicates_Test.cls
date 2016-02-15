/*
 This Class has the test methods for the controller class SearchDuplicates.cls of VF Page NewLeadOverride.page
 */
@isTest(SeeAllData=False)
private class SearchDuplicates_Test {

    static testMethod void testSearchDuplicates() {
        
        Project_Name__c pn1 = new Project_Name__c (Name = 'Lodha Aria', Record_Type__c = 'Residential');        // CG Dev Team 18/10/2011 Included Record_Type__c" picklist values as residential for code coverage 
        Project_Name__c pn2 = new Project_Name__c (Name = 'Unknown Project', Record_Type__c = 'Residential');   // CG Dev Team 18/10/2011 Included Record_Type__c" picklist values as residential for code coverage 
        list <Project_Name__c> lstPN = new list <Project_Name__c> ();
        lstPN.add(pn1);
        lstPN.add(pn2);
        insert lstPN;
        
        Lead l1=new Lead (Company='Company',Date_of_visit__c= datetime.now(),status = 'Follow up',Project_Interested__c='Lodha Aria', Project_Name__c = pn1.id ,Mobile__c='2345678926', LastName='LastName', LeadSource='Web', Allow_to_Save__c = False);
        Lead l2= new Lead (status='Follow up', Mobile__c='1234567892', LastName='LN', Interested__c='Yes', LeadSource = 'Web', Project_Name__c = pn2.id, Project_Interested__c = 'Unknown Project', OWNERID=UserInfo.getUserId(), Allow_to_Save__c = False);
        Lead l3= new Lead (status='Follow up', Mobile__c='7584632155', LastName='LastN', Interested__c='Yes', LeadSource = 'Web', Project_Name__c = pn2.id, Project_Interested__c = 'Lodha Aria', OWNERID=UserInfo.getUserId(), Allow_to_Save__c = False);
        list <Lead> lstLead = new list <Lead>();
        lstLead.add(l1);
        lstLead.add(l2);
        lstLead.add(l3);
        insert lstLead;
        
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(l1.id);
        lc.setConvertedStatus('Converted');
        lc.setOwnerId(UserInfo.getUserId());
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        
        ApexPages.StandardController ctr1 = new ApexPages.StandardController(l1);
        ApexPages.StandardController ctr2 = new ApexPages.StandardController(l2);
        ApexPages.StandardController ctr3 = new ApexPages.StandardController(l3);
        
        SearchDuplicates sd0 = new SearchDuplicates(ctr2);
        sd0.Phone = '1234567892';
        sd0.Project = pn2.Id;
        sd0.search();
        sd0.NewLead();
 
        Profile p = [select id from profile where name = 'IPad Profile' ];//Id='00eD0000001GLMM']; 
        User u = new User(alias = 'standt', email='standarduser@testorg.com', emailencodingkey='UTF-8',lastname='Testing', languagelocalekey='en_US',localesidkey='en_US', profileid = p.Id, timezonesidkey='America/Los_Angeles', username='Teststandarduser123@testorg.com');        
        system.runas(u)
        {
        SearchDuplicates sd1 = new SearchDuplicates(ctr2);
        sd1.Phone = '1234567892';
        sd1.Project = pn2.Id;
        sd1.search();
        sd1.NewLead();
        
        SearchDuplicates sd2 = new SearchDuplicates(ctr2);
        sd2.Phone = '1234567892';
        sd2.Project = pn1.Id;
        sd2.search();
        sd2.NewLead();
        
        SearchDuplicates sd3 = new SearchDuplicates(ctr1);
        sd3.Phone = '234567892';
        sd3.Project = pn2.Id;
        sd3.search();
        sd3.NewLead();
        
        SearchDuplicates sd4 = new SearchDuplicates(ctr1);
        sd4.Phone = null;
        sd4.Project = null;
        sd4.search();
        sd4.NewLead();
        
        SearchDuplicates sd5 = new SearchDuplicates(ctr1);
        sd5.Phone = '1234563218';
        sd5.Project = pn2.id;
        sd5.search();
        sd5.NewLead();
        }
 
          
    }
}