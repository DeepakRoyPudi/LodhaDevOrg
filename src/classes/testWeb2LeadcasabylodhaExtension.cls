@isTest
private class testWeb2LeadcasabylodhaExtension{    
    static testMethod void myUnitTest() {


    String ProjectIdCASA = [SELECT Id, Project_Type__c, Type_of_Accomodation__c, Call_Patch_Category__c FROM Project_Name__c WHERE Project_Type__c = 'CASA' AND Type_of_Accomodation__c != '' lIMIT 1].Id;  
    String ProjectIdCOMM = [select id, Project_Type__c, Type_of_Accomodation__c, Call_Patch_Category__c from project_name__c where Project_Type__c = 'COMMERCIAL' limit 1].Id;  
    /*test no projectId*/
    ApexPages.StandardController controller0 = new ApexPages.StandardController(new Lead()); 
    Web2LeadcasabylodhaExtension w0 = new Web2LeadcasabylodhaExtension(controller0);    
    /*test constructor */
    ApexPages.StandardController controller1 = new ApexPages.StandardController(new Lead()); 
    system.currentPageReference().getParameters().put('projectid','asd');    
    Web2LeadcasabylodhaExtension w1 = new Web2LeadcasabylodhaExtension(controller1);
    /*test noncommercial */
   
    ApexPages.StandardController controller2 = new ApexPages.StandardController(new Lead());     
    system.currentPageReference().getParameters().put('projectid',ProjectIdCASA);    
    system.currentPageReference().getParameters().put('campaign','campaign');        
    system.currentPageReference().getParameters().put('publisher','publisher');     
    Web2LeadcasabylodhaExtension w2 = new Web2LeadcasabylodhaExtension(controller2);
    w2.leadName = 'test';
    w2.leademail = 'test@test.com';
    w2.leadmobile = '9876543210';
    w2.leadphone = '45678912';
    w2.leadstdcode = '022';
    w2.countries = 'India';
    w2.city = 'Mumbai';
    w2.countrycode = '0091';
    w2.designation = 'SE';
    w2.companyname = 'COMAPANY';
    w2.city1 = 'NY';
    w2.AccommodationValue = new list<String>{'2bhk','3bhk'};
    system.assertEquals(w2.saveLead(),null);
    system.assertEquals(w2.senderrmsg(),null);
    /*test other city*/
    w2.countries = 'US';
    w2.city1 = 'NY';
    system.assertEquals(w2.saveLead(),null);
    /*test invalid */
    w2.leadphone = '4567891';
    w2.leadstdcode = '022';
    system.assertEquals(w2.saveLead(),null);
    /*test other city*/
    w2.leadphone = '456789121';
    w2.leadstdcode = '22';
    system.assertEquals(w2.saveLead(),null);
    /*test commercial */

    ApexPages.StandardController controller3 = new ApexPages.StandardController(new Lead());     
    system.currentPageReference().getParameters().put('projectid',ProjectIdCOMM);    
    Web2LeadcasabylodhaExtension w3 = new Web2LeadcasabylodhaExtension(controller3);
    w3.leadName = 'test';
    w3.leademail = 'test@test.com';
    w3.leadmobile = '9876543210';
    w3.leadphone = '45678912';
    w3.leadstdcode = '022';
    w3.countries = 'India';
    w3.city = 'Mumbai';
    w3.countrycode = '0091';
    w3.designation = 'SE';
    w3.companyname = 'COMAPANY';
    w3.city1 = 'NY';
    system.assertEquals(w3.saveLead(),null);
    system.assertEquals(w3.senderrmsg(),null);
    /* test other city for commercial*/
    w3.countries = 'US';
    w3.city1 = 'NY';
    system.assertEquals(w3.saveLead(),null);         
    }
}