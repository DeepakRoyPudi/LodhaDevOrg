@isTest
private class TestLandingpageExtenstion{

     static testMethod void myUnitTest() {
     
     String ProjectId= [select id,Project_Type__c,Type_of_Accomodation__c from project_name__c where Name = 'Lodha Fiorenza' limit 1].Id; 
     
            /*test no projectId*/
            
            ApexPages.StandardController controller_no_pid = new ApexPages.StandardController(new Lead()); 
            LandingpageExtenstion extention_no_pid = new LandingpageExtenstion(controller_no_pid);    
        
            /*test invalid project id */
            
            ApexPages.StandardController test_invalid_controller = new ApexPages.StandardController(new Lead()); 
            system.currentPageReference().getParameters().put('projectid','asd');    
            LandingpageExtenstion test_invalid = new LandingpageExtenstion(test_invalid_controller);
        
    
            /*test valid project id */
            
            ApexPages.StandardController test_valid_controller= new ApexPages.StandardController(new Lead()); 
            system.currentPageReference().getParameters().put('projectid',ProjectId);
            LandingpageExtenstion test_valid= new LandingpageExtenstion(test_valid_controller);
            
            
            
            
            Channel_Partner__c cp=new Channel_Partner__c();
            cp.Name='Test Record';
            cp.Contact_Person__c='Test Contact';
            cp.Mobile_Phone__c='1248961594';
            cp.PAN_Card_Number__c='ada5434hb';
            cp.REAP_ID__c='LD074747';
            cp.Address__c='mumbai';
            cp.City__c='Mumbai';
            insert cp;
            
            
            /* Empty Reap id*/
            
            ApexPages.StandardController test_empty_REAPID_controller= new ApexPages.StandardController(new Lead());
            system.currentPageReference().getParameters().put('projectid',ProjectId);
            LandingpageExtenstion test_empty_REAPID = new LandingpageExtenstion(test_empty_REAPID_controller);
            test_empty_REAPID.reapid='';
            test_empty_REAPID.SubmitReapId();
            
            
            
             /*Invalid Reap id*/       
                   
            ApexPages.StandardController test_invalid_REAPID_controller= new ApexPages.StandardController(new Lead());
            system.currentPageReference().getParameters().put('projectid',ProjectId);
            LandingpageExtenstion test_invalid_REAPID= new LandingpageExtenstion(test_invalid_REAPID_controller);
            test_invalid_REAPID.reapid='DNU12345';
            test_invalid_REAPID.SubmitReapId();
            
            
            
            /*Valid Reap id*/
            
            ApexPages.StandardController test_valid_REAPID_controller= new ApexPages.StandardController(new Lead());
            system.currentPageReference().getParameters().put('projectid',ProjectId);
            LandingpageExtenstion test_valid_REAPID= new LandingpageExtenstion(test_valid_REAPID_controller);
            test_valid_REAPID.reapid=cp.REAP_ID__c;
            test_valid_REAPID.SubmitReapId();
            
 
            /*Test for save lead*/
            
            ApexPages.StandardController test_save_lead_controller= new ApexPages.StandardController(new Lead());
            system.currentPageReference().getParameters().put('projectid',ProjectId);
            LandingpageExtenstion test_save_lead= new LandingpageExtenstion(test_save_lead_controller);
            
            test_save_lead.channelpartnernameId=cp.id;
            test_save_lead.reapid=cp.REAP_ID__c;            
            test_save_lead.projectId=ProjectId;
            test_save_lead.firstname='First Name';
            test_save_lead.lastname='Last Name';
            test_save_lead.country='India';
            test_save_lead.city='Mumbai';
            test_save_lead.city1='Mumbai';
            test_save_lead.suburb='Local';
             test_save_lead.CountryCode='0091';
            test_save_lead.mobile='1248961594';          
            test_save_lead.occupation='Service';
            test_save_lead.other_occupation='others';
            test_save_lead.company='Company';
            test_save_lead.designation='Designation';
            test_save_lead.budget='10';
            test_save_lead.carsowned='3';
            test_save_lead.destination_India='Shimla';
            test_save_lead.destination_Abroad='France';
            
            system.assertEquals(test_save_lead.saveLead(),null);  
            
            ApexPages.StandardController test_save_lead_more_controller= new ApexPages.StandardController(new Lead());
            system.currentPageReference().getParameters().put('projectid',ProjectId);           
            LandingpageExtenstion test_save_more_lead= new LandingpageExtenstion(test_save_lead_more_controller);
            test_save_more_lead.savemorelead();       
           
 
         }
         
}