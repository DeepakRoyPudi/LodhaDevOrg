/*
Purpose - Test Class for STEnquiry and STEnquiryResult Pages' Controllers 
Developer - Jayant
Date Last Modified - 23/06/2011
*/

@isTest

private class Test_STEnquiry {

    public static testmethod void testSTEnquiry(){
    
    try{
    
    STDesc__c test = new STDesc__c();
    test.Customer_ID__c = '1000000';
    test.Balance_Due_CS__c = '10000';
    test.Balance_Due_FR__c = '10000';
    test.Balance_Due_PR__c = '10000';
    test.Building_Name__c = 'Casa Town';
    test.Customer_Name__c = 'ABC';
    test.Flat_No__c = 1000;
    test.Net_Value_FR__c = '100000';
    test.Net_Value_Inst__c = '100000';
    test.Net_Value_PR__c = '100000';
    test.Project_Name__c = 'Casa Township';
    test.Rate_CS__c = '2.75%';
    test.Rate_FR__c = '2.75%';
    test.Rate_PR__c = '2.75%';
    test.Service_Tax_FR__c = '20000';
    test.Service_Tax_Inst__c = '20000';
    test.Service_Tax_PR__c = '20000';
    test.Service_Tax_Collected_CS__c = '10000';
    test.Service_Tax_Collected_FR__c = '10000';
    test.Service_Tax_Collected_PR__c = '10000';
    
    Insert test;
    
    Apexpages.currentPage().getParameters().put('CustID','1000000');
    Apexpages.currentPage().getParameters().put('FlatNum','1000');
    
    STEnquiryResultController sc = new STEnquiryResultController (); 
    sc.goBack();   
    sc.tillDate = Date.Today();
    sc.getTillDate();
    sc.getResult();
    
    }
    catch(Exception e){}
    
    }
}