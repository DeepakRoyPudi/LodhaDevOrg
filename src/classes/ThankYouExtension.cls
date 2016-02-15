/*
Author - CG DEV
Date Created - 03/11/2011
Purpose - Controller for Thankyou Page
*/
public class ThankYouExtension {
    public String ProposedDate {get;set;}
  
    public ThankYouExtension(ApexPages.StandardController controller) {
        ProposedDate  =  [select Date_of_visit__c from lead where id=:ApexPages.currentPage().getParameters().get('id')].Date_of_visit__c.format(); 
    }

    /*public static  testMethod void ThankYouExtensionTest() 
    {
        System.currentPageReference().getParameters().put('id',[select Id,Date_of_visit__c from Lead where Date_of_visit__c != null limit 1].Id);
        ApexPages.StandardController controller;
        ThankYouExtension t = new ThankYouExtension(controller);
    }  */
}