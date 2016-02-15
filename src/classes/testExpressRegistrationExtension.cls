@isTest(seealldata=true)
Public class testExpressRegistrationExtension{ 
    public testmethod static void test_Method()
    {
        Lead NewLead = new Lead();
       String page1 = '/apex/ExpressRegistrationPage?projectid='+[select Id,Name from Project_Name__c where Name = 'Casa Bella'].Id;
            PageReference pageRef1 = new PageReference(page1);        
            Test.setCurrentPage(pageRef1);        
        ExpressRegistrationExtension leadoper = new ExpressRegistrationExtension(new Apexpages.StandardController(NewLead));
        
        leadoper.DateOfVisit = '01/01/2011';
        leadoper.leadFirstName = '';        
        leadoper.saveLead();
                
        leadoper.leadFirstName = 'Test Data';
        leadoper.leadLastName = '';
        leadoper.saveLead();
        
        leadoper.leadFirstName = 'Test Data';
        leadoper.leadLastName = 'Test Data';
        leadoper.DateOfVisit = '';
        leadoper.saveLead();
        
        leadoper.leadFirstName = 'Test Data';
        leadoper.leadLastName = 'Test Data';
        leadoper.DateOfVisit = '01/01/2011';
        leadoper.IsValidPlotNo = false;
        leadoper.saveLead();
        
        leadoper.leadFirstName = 'Test Data';
        leadoper.leadLastName = 'Test Data';
        leadoper.DateOfVisit = '01/01/2011';
        leadoper.IsValidPlotNo = true;
        leadoper.city = 'None';
        leadoper.saveLead();
        
        leadoper.leadFirstName = 'Test Data';
        leadoper.leadLastName = 'Test Data';
        leadoper.DateOfVisit = '01/01/2011';
        leadoper.IsValidPlotNo = true;
        leadoper.city = '';
        leadoper.IsValidPinCode = false;
        leadoper.saveLead();
        
        leadoper.leadFirstName = 'Test Data';
        leadoper.leadLastName = 'Test Data';
        leadoper.DateOfVisit = '01/01/2011';
        leadoper.IsValidPlotNo = true;
        leadoper.city = '';
        leadoper.IsValidPinCode = true;
        leadoper.IsValidMobile = false;
        leadoper.saveLead();
        
        leadoper.leadFirstName = 'Test Data';
        leadoper.leadLastName = 'Test Data';
        leadoper.DateOfVisit = '01/01/2011';
        leadoper.IsValidPlotNo = true;
        leadoper.city = '';
        leadoper.IsValidPinCode = true;
        leadoper.IsValidMobile = true;
        leadoper.IsValidEmail = false;
        leadoper.saveLead();

        leadoper.SendErrorMail('Error');
        leadoper.accTypeList.add('3 BHK');
        leadoper.accTypeList.add('4 BHK');
        leadoper.getItems();
    }
}