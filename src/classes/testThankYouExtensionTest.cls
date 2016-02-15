@istest(seealldata=true)
    Public class testThankYouExtensionTest{
    
        public static  testMethod void ThankYouExtensionTest() 
    {
        System.currentPageReference().getParameters().put('id',[select Id,Date_of_visit__c from Lead where Date_of_visit__c != null limit 1].Id);
        ApexPages.StandardController controller;
        ThankYouExtension t = new ThankYouExtension(controller);
    }  
    }