@isTest
private class Test_Leads_Serviced {

    static testMethod void myUnitTest() {
    	   list <Lead> lstLead = new list <Lead>();
    	   Project_Name__c pn1 = new Project_Name__c (Name = 'Lodha Aria');
    	   Lead l1=new Lead (Date_of_visit__c= datetime.now(),status = 'Follow up',Project_Interested__c='Lodha Aria', Project_Name__c = pn1.id ,Mobile__c='234567892', LastName='LastName', LeadSource='Web', Allow_to_Save__c = False);
           lstLead.add(l1);
           PageReference pageRef = new PageReference('/00Q/o');
       	   Test.setCurrentPage(pageRef);
           Leads_Serviced ls = new Leads_Serviced(new ApexPages.StandardSetController(lstLead));
           ls.mark();
       }  
}