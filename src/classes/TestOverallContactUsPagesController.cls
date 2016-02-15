@isTest
/********************Overall Testclass for Contact us Controllers******************************/

private class TestOverallContactUsPagesController{  
/********************Testmethods for Web2LeadExtension Controller******************************/
    @isTest(seealldata=true)
    Private static void myUnitTest() {
    
    String ProjectIdCASA = [select id,Project_Type__c,Type_of_Accomodation__c from project_name__c where Project_Type__c = 'Casa' and Type_of_Accomodation__c != '' limit 1].Id;  
    String ProjectIdCOMM = [select id,Project_Type__c,Type_of_Accomodation__c from project_name__c where Project_Type__c = 'COMMERCIAL' limit 1].Id;  
    /*test no projectId*/
    ApexPages.StandardController controller0 = new ApexPages.StandardController(new Lead()); 
    Web2LeadExtension w0 = new Web2LeadExtension(controller0);    
    /*test constructor */
    ApexPages.StandardController controller1 = new ApexPages.StandardController(new Lead()); 
    system.currentPageReference().getParameters().put('projectid','asd');    
    Web2LeadExtension w1 = new Web2LeadExtension (controller1);
    /*test noncommercial */
   
    ApexPages.StandardController controller2 = new ApexPages.StandardController(new Lead());     
    system.currentPageReference().getParameters().put('projectid',ProjectIdCASA);    
    system.currentPageReference().getParameters().put('campaign','campaign');        
    system.currentPageReference().getParameters().put('publisher','publisher');     
    Web2LeadExtension w2 = new Web2LeadExtension (controller2);
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
    w2.AccommodationValue ='2bhk;3bhk';
    system.AssertEquals(w2.saveLead(),null);   
    system.AssertEquals(w2.senderrmsg(),null);   
    /*test other city*/
    w2.countries = 'US';
    w2.city1 = 'NY';
    system.AssertEquals(w2.saveLead(),null);
    /*test invalid */
    w2.leadphone = '4567891';
    w2.leadstdcode = '022';
    system.AssertEquals(w2.saveLead(),null);
    /*test other city*/
    w2.leadphone = '456789121';
    w2.leadstdcode = '22';
    system.AssertEquals(w2.saveLead(),null);
    /*test commercial */

    ApexPages.StandardController controller3 = new ApexPages.StandardController(new Lead());     
    system.currentPageReference().getParameters().put('projectid',ProjectIdCOMM);    
    Web2LeadExtension w3 = new Web2LeadExtension (controller3);
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
    system.AssertEquals(w3.saveLead(),null);
    system.AssertEquals(w3.senderrmsg(),null);    
    /* test other city for commercial*/
    w3.countries = 'US';
    w3.city1 = 'NY';
    system.AssertEquals(w3.saveLead(),null);         
    }
    
/********************Testmethods for Web2LeadcasabylodhaExtension Controller******************************/
    @isTest(seealldata=true)
    private static void myUnitTest1() {
    
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
    
/********************Testmethods for Web2LeadcasabylodhaExtensionCommcial Controller******************************/

    @istest(seeAlldata=True)        
    private static void testWebform(){
    String ProjectIdCASA = [select id,Project_Type__c,Type_of_Accomodation__c,Call_Patch_Category__c from project_name__c where Project_Type__c = 'CASA' and Type_of_Accomodation__c != '' limit 1].Id;  
    String ProjectIdCOMM = [select id,Project_Type__c,Type_of_Accomodation__c,Call_Patch_Category__c from project_name__c where Project_Type__c = 'COMMERCIAL' limit 1].Id;  
    /*test no projectId*/
    ApexPages.StandardController controller0 = new ApexPages.StandardController(new Lead()); 
    Web2LeadcasabylodhaExtensionCommercial w0 = new Web2LeadcasabylodhaExtensionCommercial(controller0);    
    /*test constructor */
    ApexPages.StandardController controller1 = new ApexPages.StandardController(new Lead()); 
    system.currentPageReference().getParameters().put('projectid','asd');    
    Web2LeadcasabylodhaExtensionCommercial w1 = new Web2LeadcasabylodhaExtensionCommercial(controller1);
    /*test noncommercial */
   
    ApexPages.StandardController controller2 = new ApexPages.StandardController(new Lead());     
    system.currentPageReference().getParameters().put('projectid',ProjectIdCASA);    
    system.currentPageReference().getParameters().put('campaign','campaign');        
    system.currentPageReference().getParameters().put('publisher','publisher');     
    Web2LeadcasabylodhaExtensionCommercial w2 = new Web2LeadcasabylodhaExtensionCommercial(controller2);
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
    Web2LeadcasabylodhaExtensionCommercial w3 = new Web2LeadcasabylodhaExtensionCommercial (controller3);
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
    
    ApexPages.StandardController controller4 = new ApexPages.StandardController(new Lead());     
    system.currentPageReference().getParameters().put('projectid',ProjectIdCOMM);    
    Web2LeadcasabylodhaExtensionCommercial w4 = new Web2LeadcasabylodhaExtensionCommercial (controller3);
    w4.leadName = 'test';
    w4.leademail = 'test@test.com';
    w4.leadmobile = '9876543210';
    w4.leadphone = '45678912';
    w4.leadstdcode = '022';
    w4.countries = 'Ghana';
    w4.city = 'Mumbai';
    w4.countrycode = '00233';
    w4.designation = 'SE';
    w4.companyname = 'COMAPANY';
    w4.city1 = 'NY';
    w4.saveLead();
    w4.senderrmsg();        
    }
    
/********************Testmethods for Web2LeadcasabylodhaExtensionInterim Controller******************************/

    @istest(seeAlldata=false)
    private static void testLoyaltyInfoUtilities1(){
    Project_Name__c pname=new Project_Name__c();
    pname.name='Lodha Dummy';
    pname.Project_Type__c='CASA';
    pname.Record_Type__c='Residential';
    pname.Isactive__c=true;
    pname.Allow_mobile_verification__c=true;
    pname.Allow_Call_Patching__c=true;
    pname.City__c='Mumbai';
    pname.Call_Patch_Category__c = 'Dummy Call';
    pname.Type_of_Accomodation__c = '1 BHK';
    insert pname;
    
    Project_Name__c pname2=new Project_Name__c();
    pname2.name='Lodha Dummy1';
    pname2.Project_Type__c='COMMERCIAL';
    pname2.Record_Type__c='Residential';
    pname2.Isactive__c=true;
    pname2.Allow_mobile_verification__c=true;
    pname2.Allow_Call_Patching__c=true;
    pname2.City__c='Mumbai';
    pname2.Call_Patch_Category__c = 'Dummy Call';
    pname2.Type_of_Accomodation__c = '1 BHK';
    insert pname2;
    
    CallPatchCategory__c cpatch=new CallPatchCategory__c ();
    cpatch.name='Dummy Call';
    cpatch.Call_Center_Number__c='7984561475';
    insert cpatch;
    

    WebToLeadPages__c c=new WebToLeadPages__c();
    c.name='Lodha Dummy-RI';
    c.Admin_Email__c='kumki@gmail.com';
    c.Email_template__c='MyTemplate';
    insert c;
    
    WebToLeadPages__c d=new WebToLeadPages__c();
    d.name='Lodha Dummy-NRI';
    d.Admin_Email__c='kumki@gmail.com';
    d.Email_template__c='MyTemplate';
    insert d;
    
    
    WebToLeadPages__c e=new WebToLeadPages__c();
    e.name='Lodha Dummy1-RI';
    e.Admin_Email__c='kumki@gmail.com';
    e.Email_template__c='MyTemplate';
    insert e;
    
    WebToLeadPages__c f=new WebToLeadPages__c();
    f.name='Lodha Dummy1-NRI';
    f.Admin_Email__c='kumki@gmail.com';
    f.Email_template__c='MyTemplate';
    insert f;
    
    WebToLeadPages__c g=new WebToLeadPages__c();
    g.name='CasabyLodha';
    g.Admin_Email__c='kumki@gmail.com';
    g.Email_template__c='MyTemplate';
    insert g;
    
    
    /*test no projectId*/
    ApexPages.StandardController controller01 = new ApexPages.StandardController(new Lead()); 
    Web2LeadcasabylodhaExtensionInterim w0 = new Web2LeadcasabylodhaExtensionInterim(controller01);    
    /*test constructor */
    ApexPages.StandardController controller11 = new ApexPages.StandardController(new Lead());   
    Web2LeadcasabylodhaExtensionInterim w1 = new Web2LeadcasabylodhaExtensionInterim(controller11);
    /*test noncommercial */
   
     WebToLeadPages__c b=new WebToLeadPages__c();
    b.name='Exception Tracking Admin';
    b.Admin_Email__c='kumki@gmail.com';
    b.Email_template__c='MyTemplate';
    insert b;
    
    ApexPages.StandardController controller2 = new ApexPages.StandardController(new Lead());        
    system.currentPageReference().getParameters().put('campaign','campaign');        
    system.currentPageReference().getParameters().put('publisher','publisher');     
    
    Web2LeadcasabylodhaExtensionInterim w4 = new Web2LeadcasabylodhaExtensionInterim(controller2);    
    w4.emailid='kumki@gmail.com';
    w4.e='test';
    w4.leadName = 'test';
    w4.SendErrorMail('test');
    w4.leademail = 'test@test.com';
    w4.leadmobile = '9876543210';
    w4.leadphone = '45678912';
    w4.leadstdcode = '022';
    w4.countries = 'India';
    w4.city = 'Mumbai';
    w4.countrycode = '0091';
    w4.designation = 'SE';
    w4.companyname = 'COMAPANY';
    w4.city1 = 'NY';
    w4.senderrmsg();
    
    
    
    Web2LeadcasabylodhaExtensionInterim w2 = new Web2LeadcasabylodhaExtensionInterim(controller2);
    w2.leadName = 'test';
    w2.leademail = 'test@test.com';
    w2.leadmobile = '9876543210';
    w2.leadphone = '45678912';
    w2.leadstdcode = '022';
    w2.countries = 'India';
    w2.projectid = pname.id;
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
    w2.projectid = pname.id;
    w2.ProjectName();
    system.assertEquals(w2.saveLead(),null);
    /*test commercial */

    ApexPages.StandardController controller3 = new ApexPages.StandardController(new Lead());        
    Web2LeadcasabylodhaExtensionInterim w3 = new Web2LeadcasabylodhaExtensionInterim(controller3);
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
    w3.saveLead();
    w3.senderrmsg();
    w3.countries = 'US';
    w3.city1 = 'NY';
    w3.projectid = pname2.id;
    w3.ProjectName();
    system.assertEquals(w3.saveLead(),null);

   
    }
      
/********************Testmethods for CasaGroupContactusController Controller******************************/

        static testmethod void testcasaleadcapture()    {
            Project_Name__c pname=new Project_Name__c();
            pname.name='Lodha Dummy';
            pname.Project_Type__c='CASA';
            pname.Record_Type__c='Residential';
            pname.Isactive__c=true;
            pname.Allow_mobile_verification__c=true;
            pname.Allow_Call_Patching__c=true;
            pname.City__c='Mumbai';
            pname.Call_Patch_Category__c = 'Dummy Call';
            pname.Type_of_Accomodation__c = '1 BHK';
            insert pname;
            
            Project_Name__c pname2=new Project_Name__c();
            pname2.name='Lodha Dummy';
            pname2.Project_Type__c='COMMERCIAL';
            pname2.Record_Type__c='Residential';
            pname2.Isactive__c=true;
            pname2.Allow_mobile_verification__c=true;
            pname2.Allow_Call_Patching__c=true;
            pname2.City__c='Mumbai';
            pname2.Call_Patch_Category__c = 'Dummy Call';
            pname2.Type_of_Accomodation__c = '1 BHK';
            insert pname2;
            
           WebToLeadPages__c cust=new WebToLeadPages__c(Name='CasabyLodha',Admin_Email__c='kumki@gmail.com',Email_template__c='test template');
           insert cust;
           
           WebToLeadPages__c cust1=new WebToLeadPages__c(Name='Lodha Dummy-NRI',Admin_Email__c='kumki@gmail.com',Email_template__c='test template');
           insert cust1;
           
           WebToLeadPages__c cust2=new WebToLeadPages__c(Name='Lodha Dummy-RI',Admin_Email__c='kumki@gmail.com',Email_template__c='test template');
           insert cust2;
            
           CasaGroupContactusController casagroup=new CasaGroupContactusController();
           casagroup.name='test';
           casagroup.email='test@test.com';
           casagroup.country='India';
           casagroup.city='Mumbai';
           casagroup.projectType='COMMERCIAL';
           casagroup.mobileNumber='14725836954';
           casagroup.submitLead();
           casagroup.senderrmsg();
           
           WebToLeadPages__c cust3=new WebToLeadPages__c(Name='Exception Tracking Admin',Admin_Email__c='kumki@gmail.com',Email_template__c='test template');
           insert cust3;
           
           /*
            * Test record for country India and projecttype Non commercial
            */
            
           CasaGroupContactusController casagroup1=new CasaGroupContactusController();
          
           casagroup1.selectedproject='Casa Bella';
           casagroup1.name='test';
           casagroup1.email='test@test.com';
           casagroup1.country='India';
           casagroup1.city='Mumbai';
           casagroup1.projectType='residential';
           casagroup1.mobileNumber='14725836954';
           casagroup1.sourceofinformation='Radio';
            casagroup1.projectInterested = pname.id;
           casagroup1.ProjectName();
           casagroup1.submitLead();                                           
           casagroup1.senderrmsg();
          
           
           /*
            * Test record for country Non India and projectType is commercial
            */
           CasaGroupContactusController casagroup2=new CasaGroupContactusController();
           
           casagroup2.selectedproject=pname2.id;
           casagroup2.name='test';
           casagroup2.email='test@test.com';
           casagroup2.country='France';
           casagroup2.city='test';
           casagroup2.projectType='COMMERCIAL';
           casagroup2.mobileNumber='14725836954';
           casagroup2.sourceofinformation='Radio';
           casagroup2.projectInterested = pname2.id;
           casagroup2.ProjectName();
           casagroup2.submitLead();                     
           casagroup2.senderrmsg();
           
           /*
            * Test record for country  Non India and projectType Non commercial
            */
           CasaGroupContactusController casagroup3=new CasaGroupContactusController();
          
           casagroup3.selectedproject= pname.id;
           casagroup3.name='test';
           casagroup3.email='test@test.com';
           casagroup3.country='France';
           casagroup3.city='Test';
           casagroup3.projectType='residential';
           casagroup3.mobileNumber='14725836954';
           casagroup3.submitLead();                       
           casagroup3.senderrmsg();
           
           casagroup3.ProjectName();
           CasaGroupContactusController casagroup4=new CasaGroupContactusController();
           
           casagroup4.name='';
           casagroup4.mobileNumber='';          
           casagroup4.submitLead();                     
           casagroup4.senderrmsg();
          
      }
      
/********************Testmethods for LodhaGroupContactController Controller******************************/

        static testmethod void testlodhaleadcapture()    
            { 
            Project_Name__c pname=new Project_Name__c();
            pname.name='Lodha Dummy';
            pname.Project_Type__c='CASA';
            pname.Record_Type__c='Residential';
            pname.Isactive__c=true;
            pname.Allow_mobile_verification__c=true;
            pname.Allow_Call_Patching__c=true;
            pname.City__c='Mumbai';
            pname.Call_Patch_Category__c = 'Dummy Call';
            pname.Type_of_Accomodation__c = '1 BHK';
            insert pname;
            
            Project_Name__c pname2=new Project_Name__c();
            pname2.name='Lodha Dummy';
            pname2.Project_Type__c='COMMERCIAL';
            pname2.Record_Type__c='Residential';
            pname2.Isactive__c=true;
            pname2.Allow_mobile_verification__c=true;
            pname2.Allow_Call_Patching__c=true;
            pname2.City__c='Mumbai';
            pname2.Call_Patch_Category__c = 'Dummy Call';
            pname2.Type_of_Accomodation__c = '1 BHK';
            insert pname2;
            
            CallPatchCategory__c cpatch=new CallPatchCategory__c ();
            cpatch.name='Dummy Call';
            cpatch.Call_Center_Number__c='7984561475';
            insert cpatch;           
           
           WebToLeadPages__c cust=new WebToLeadPages__c(Name='CasabyLodha',Admin_Email__c='kumki@gmail.com',Email_template__c='test template');
           insert cust;
           
           WebToLeadPages__c cust1=new WebToLeadPages__c(Name='Lodha Dummy-NRI',Admin_Email__c='kumki@gmail.com',Email_template__c='test template');
           insert cust1;
           
           WebToLeadPages__c cust2=new WebToLeadPages__c(Name='Lodha Dummy-RI',Admin_Email__c='kumki@gmail.com',Email_template__c='test template');
           insert cust2;
           
           ApexPages.currentPage().getParameters().put('campaign','test');
           ApexPages.currentPage().getParameters().put('publisher','test');
           ApexPages.currentPage().getParameters().put('CountryName','test');
           
           LodhaGroupContactController lodhagroup=new LodhaGroupContactController();
           lodhagroup.name='test';
           lodhagroup.email='test@test.com';
           lodhagroup.country='India';
           lodhagroup.city='Mumbai';
           lodhagroup.projectType='COMMERCIAL';
           lodhagroup.mobileNumber='14725836954';        
           lodhagroup.projectInterested='Casa Bella';
           lodhagroup.submitLead();
           
           
           WebToLeadPages__c cust3=new WebToLeadPages__c(Name='Exception Tracking Admin',Admin_Email__c='kumki@gmail.com',Email_template__c='test template');
           insert cust3;
           /*
            * Test record for country India and projecttype Non commercial
            */
            
           LodhaGroupContactController lodhagroup1=new LodhaGroupContactController();
           lodhagroup1.name='test';
           lodhagroup1.email='test@test.com';
           lodhagroup1.country='India';
           lodhagroup1.city='Mumbai';
           lodhagroup1.projectType='residential';
           lodhagroup1.mobileNumber='14725836954';
           lodhagroup1.submitLead();
           lodhagroup1.senderrmsg();
           
           
           /*
            * Test record for country Non India and projectType is commercial
            */
           LodhaGroupContactController lodhagroup2=new LodhaGroupContactController();
           lodhagroup2.name='test';
           lodhagroup2.email='test@test.com';
           lodhagroup2.country='France';
           lodhagroup2.city='test';
           lodhagroup2.projectType='COMMERCIAL';
           lodhagroup2.mobileNumber='14725836954';
           lodhagroup2.submitLead();
           lodhagroup2.senderrmsg();
           
           /*
            * Test record for country  Non India and projectType Non commercial
            */
           LodhaGroupContactController lodhagroup3=new LodhaGroupContactController();
           lodhagroup3.name='test';
           lodhagroup3.email='test@test.com';
           lodhagroup3.country='France';
           lodhagroup3.city='Test';
           lodhagroup3.projectType='residential';
           lodhagroup3.mobileNumber='14725836954';
           lodhagroup3.projectInterested  = pname.id;
           lodhagroup3.ProjectName();
           lodhagroup3.submitLead();
           lodhagroup3.senderrmsg();
           
           LodhaGroupContactController lodhagroup4=new LodhaGroupContactController();
           lodhagroup4.name='test';
           lodhagroup4.email='test@test.com';
           lodhagroup4.country='India';
           lodhagroup4.city='Test';
           lodhagroup4.projectType='residential';
           lodhagroup4.mobileNumber='14725836954';
           lodhagroup4.projectInterested  = pname.id;
           lodhagroup4.ProjectName();
           lodhagroup4.submitLead();
           lodhagroup4.senderrmsg();
        }
}