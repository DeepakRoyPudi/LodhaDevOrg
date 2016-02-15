@isTest
private class LeadTestClass
{
     public static testMethod void testLeadClasses() 
     {
         
                VisitorFormGlobalVariables__c gv = VisitorFormGlobalVariables__c.getInstance();      
                string pid = gv.ProjectId__c; 
            
                //Run as Fioranze user
                Profile p = [select id,name from profile where name='IPad Profile']; 
                User u = new User(alias = 'standtq', email='standarduser1@testorg.com', emailencodingkey='UTF-8',lastname='Testing1', languagelocalekey='en_US',localesidkey='en_US', profileid = p.Id, timezonesidkey='America/Los_Angeles', username='standarduser12345@testorg.com');
                System.runAs(u)   
                {
                    //Edit Lead
                    Lead l = [Select Id,Visiting_on_behalf_of__c,FromVisitorForm__c,Interested__c,Status,Project_Name__c,Type_of_Accomodation__c,Occupation__c  from Lead where Isconverted = false AND LeadSource  != null AND Occupation__c != null AND Visiting_on_behalf_of__c!=null AND Type_of_Accomodation__c !=null LIMIT 1];                   
                    ApexPages.StandardController controller1 = new ApexPages.StandardController(l);  
                    LeadRedirectExtensions ctrl1 =  new LeadRedirectExtensions(controller1);
                    ctrl1.pageredirect();    
                    String page1 = '/apex/LeadPage' + '?id=' + l.Id + '&pid=' + pid;             
                    PageReference pageRef1 = new PageReference(page1);        
                    Test.setCurrentPage(pageRef1);                    
                    ApexPages.StandardController controller2 =  new ApexPages.StandardController(l);        
                    LeadExtensions ctrl2 =  new LeadExtensions(controller2);
                    ctrl2.getItems();
                    ctrl2.getoptions(); 
                    ctrl2.getLeadSourceList();
                    ctrl2.submitLead();
                                    
                    
                    //New Lead
                    ApexPages.StandardController controller3 = new ApexPages.StandardController(l);
                    System.currentPageReference().getParameters().put('pid',pid);   //CG Dev Team 03/10/2011 Include ProjectId for the Projectname Query in LeadExtension Controller                 
                    LeadRedirectExtensions ctrl3 =  new LeadRedirectExtensions(controller3);
                    ctrl3.pageredirect();    
                    String page3 = '/apex/LeadPage&pid=' + pid;   
                    PageReference pageRef3 = new PageReference(page3);        
                    Test.setCurrentPage(pageRef3 );
                    ApexPages.StandardController controller4 =  new ApexPages.StandardController(l);        
                    System.currentPageReference().getParameters().put('pid',pid);    //CG Dev Team 03/10/2011 Include ProjectId for the Projectname Query in LeadExtension Controller  
                    LeadExtensions ctrl4 =  new LeadExtensions(controller4);
                    ctrl4.getItems();                    
                    ctrl4.getLeadSourceList();
                    ctrl4.submitLead();
                    ctrl4.ProjectName='New Cuffe Parade';
                    ctrl4.getItems();  
                    ctrl4.ProjectName='Lodha Fiorenza';
                    ctrl4.getItems();  
                    ctrl4.ProjectName='The Park';
                    ctrl4.getItems();    
    
                }
                //Run as System Admin
                //Edit Lead
                Lead l = [Select Id from Lead where Isconverted = false LIMIT 1];                   
                ApexPages.StandardController controller1 = new ApexPages.StandardController(l);  
                LeadRedirectExtensions ctrl1 =  new LeadRedirectExtensions(controller1);
                ctrl1.pageredirect();    
                String page1 = '/apex/LeadPage' + '?id=' + l.Id + '&pid=' + pid;             
                PageReference pageRef1 = new PageReference(page1);        
                Test.setCurrentPage(pageRef1);
                ApexPages.StandardController controller2 =  new ApexPages.StandardController(l);        
                LeadExtensions ctrl2 =  new LeadExtensions(controller2);
                ctrl2.getItems();
                ctrl2.getLeadSourceList();
                ctrl2.submitLead(); 
                
                //New Lead
                ApexPages.StandardController controller3 = new ApexPages.StandardController(l);  
                LeadRedirectExtensions ctrl3 =  new LeadRedirectExtensions(controller3);
                ctrl3.pageredirect();    
                String page3 = '/apex/LeadPage&pid=' + pid;   
                PageReference pageRef3 = new PageReference(page3);        
                Test.setCurrentPage(pageRef3 );
                ApexPages.StandardController controller4 =  new ApexPages.StandardController(l);        
                System.currentPageReference().getParameters().put('pid',pid);    //CG Dev Team 03/10/2011 Include ProjectId for the Projectname Query in LeadExtension Controller                
                LeadExtensions ctrl4 =  new LeadExtensions(controller4);
                ctrl4.getItems();
                ctrl4.getLeadSourceList();
                ctrl4.submitLead();      

                
     }
}