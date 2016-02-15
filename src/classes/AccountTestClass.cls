@isTest
private class AccountTestClass
{
     public static testMethod void testAccountClasses() 
     {         
        VisitorFormGlobalVariables__c gv = VisitorFormGlobalVariables__c.getInstance();      
        string pid = gv.ProjectId__c; 
         
        //Run as Fioranze user
        Profile p = [select id,name from profile where name='IPad Profile']; 
        User u = new User(alias = 'standt', email='standarduser@testorg.com', emailencodingkey='UTF-8',lastname='Testing', languagelocalekey='en_US',localesidkey='en_US', profileid = p.Id, timezonesidkey='America/Los_Angeles', username='standarduser123@testorg.com');

        Opportunity oppty = [Select Id, AccountId from Opportunity where project_name__c=:pid LIMIT 1 ];            
        string aid = oppty.AccountId;
        string oid = oppty.Id;
        Account a = [Select Id from account where id =: aid];
        ApexPages.StandardController controller1 = new ApexPages.StandardController(a);  
        AccountRedirectExtensions ctrl1 =  new AccountRedirectExtensions(controller1);
        ctrl1.pageredirect();    
        
        String page1 = '/apex/AccountPage' + '?id=' +aid + '&pid=' + pid + '&oid=' + oid;                  
        PageReference pageRef1 = new PageReference(page1);        
        Test.setCurrentPage(pageRef1);                          
        ApexPages.StandardController controller2 =  new ApexPages.StandardController(a);        
        AccountExtensions ctrl2 =  new AccountExtensions(controller2);                 
        ctrl2.submitAccount();
        ctrl2.getItems();          
        
        String page2 = '/apex/AccountPage' + '?id=' + aid+ '&pid=' + pid;                  
        PageReference pageRef2 = new PageReference(page2);        
        Test.setCurrentPage(pageRef2);          
        ctrl2.submitAccount();              

        aid='1213';
        String page3 =  '/apex/AccountPage' + '?id=' + aid+ '&pid=' + pid;       
        PageReference pageRef3 = new PageReference(page3);        
        Test.setCurrentPage(pageRef3);  
        ApexPages.StandardController controller3 =  new ApexPages.StandardController(a); 
        AccountExtensions ctrl3 =  new AccountExtensions(controller3);                 
        ctrl3.submitAccount(); 
     }
}