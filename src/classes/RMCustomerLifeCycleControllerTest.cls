/* 
Description :Test class for customer Life cycle  
 @Created by: Shruti Nikam
 @Created Date: 13/05/2015
 
 --------------------------------------------------------------------------------
 | Modified By      | Modified Date       | Version        | Description         |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------

*/
@isTest
public class RMCustomerLifeCycleControllerTest {

    public testmethod static void RMCustomerLifeCycleTestmethod() {

        // creating custom setting used in payments     
        createCustomSettingData();
    
        //creating custom setting data 
        List < LifeCycleColorCode__c > LifeCycleColorCode_List = 
            new List < LifeCycleColorCode__c > ();
        LifeCycleColorCode__c LifeCycleColorCode_obj1 = 
            new LifeCycleColorCode__c(name = 'Completed', ColorCode__c = 'rgb(139, 183, 239)');
        LifeCycleColorCode__c LifeCycleColorCode_obj2 = 
            new LifeCycleColorCode__c(name = 'Current', ColorCode__c = '#7fe484');
        LifeCycleColorCode__c LifeCycleColorCode_obj3 = 
            new LifeCycleColorCode__c(name = 'Upcoming', ColorCode__c = 'Upcoming');
        LifeCycleColorCode_List.add(LifeCycleColorCode_obj1);
        LifeCycleColorCode_List.add(LifeCycleColorCode_obj2);
        LifeCycleColorCode_List.add(LifeCycleColorCode_obj3);
        insert LifeCycleColorCode_List;

        Test.startTest();
       
        // Set mock callout class RestMockCollectionDataSet() for the successfull response      
        Test.setMock(HttpCalloutMock.class, new RestMockRMCustomerLifeCycleDataSet());
        //invoke constructor to test condition in customer life cycle 
        RMCustomerLifeCycleController lifecycle = new RMCustomerLifeCycleController();
        lifecycle.PARAM_CRN='1400780';
        lifecycle.getPreInitialize();   
        // Set mock callout class RestMockCollectionDataSet() for the successfull response      
        Test.setMock(HttpCalloutMock.class, new RestMockRMCustomerLifeCycleDataSet1());
        //invoke constructor to test condition in customer life cycle 
        RMCustomerLifeCycleController lifecycle1 = new RMCustomerLifeCycleController();
        lifecycle1.PARAM_CRN='1400780';
        lifecycle1.getPreInitialize();           
        
        // Set mock callout class RestMockCollectionDataSet() for the successfull response      
        Test.setMock(HttpCalloutMock.class, new RestMockRMCustomerLifeCycleDataSet2());
        //invoke constructor to test condition in customer life cycle 
        RMCustomerLifeCycleController lifecycle2 = new RMCustomerLifeCycleController();
        lifecycle2.PARAM_CRN='1400780';
        lifecycle2.getPreInitialize();   
        // Set mock callout class RestMockCollectionDataSet() for the successfull response      
        Test.setMock(HttpCalloutMock.class, new RestMockRMCustomerLifeCycleDataSet3());
        //invoke constructor to test condition in customer life cycle 
        RMCustomerLifeCycleController lifecycle3 = new RMCustomerLifeCycleController();
        lifecycle3.PARAM_CRN='1400780';
        lifecycle3.getPreInitialize();   
        // Set mock callout class RestMockCollectionDataSet() for the successfull response      
        Test.setMock(HttpCalloutMock.class, new RestMockRMCustomerLifeCycleDataSet4());
        //invoke constructor to test condition in customer life cycle 
        RMCustomerLifeCycleController lifecycle4 = new RMCustomerLifeCycleController();
        lifecycle4.PARAM_CRN='1400780';
        lifecycle4.getPreInitialize();   
        // Set mock callout class RestMockCollectionDataSet() for the successfull response      
        Test.setMock(HttpCalloutMock.class, new RestMockRMCustomerLifeCycleDataSet5());
        //invoke constructor to test condition in customer life cycle 
        RMCustomerLifeCycleController lifecycle5 = new RMCustomerLifeCycleController();
        lifecycle5.PARAM_CRN='1400780';
        lifecycle5.getPreInitialize();   
        // Set mock callout class RestMockCollectionDataSet() for the successfull response     
         RestMockRMCustomerLifeCycleDataSet6 RestMock_6= new RestMockRMCustomerLifeCycleDataSet6(); 
         RestMock_6.dayDifference(0); 
        Test.setMock(HttpCalloutMock.class, RestMock_6);
        //invoke constructor to test condition in customer life cycle 
        RMCustomerLifeCycleController lifecycle6 = new RMCustomerLifeCycleController();
        lifecycle6.PARAM_CRN='1400780';
        lifecycle6.getPreInitialize();  
        // Set mock callout class RestMockCollectionDataSet() for the successfull response     
         RestMockRMCustomerLifeCycleDataSet6 RestMock_7= new RestMockRMCustomerLifeCycleDataSet6();
         RestMock_7.dayDifference(-1); 
        Test.setMock(HttpCalloutMock.class, RestMock_7);
        //invoke constructor to test condition in customer life cycle   
        RMCustomerLifeCycleController lifecycle7 = new RMCustomerLifeCycleController();
        lifecycle7.PARAM_CRN='1400780';
        lifecycle7.getPreInitialize();  
        // Set mock callout class RestMockCollectionDataSet() for the successfull response     
         RestMockRMCustomerLifeCycleDataSet6 RestMock_8= new RestMockRMCustomerLifeCycleDataSet6();
         RestMock_8.dayDifference(-2); 
        Test.setMock(HttpCalloutMock.class, RestMock_8);
        //invoke constructor to test condition in customer life cycle   
        RMCustomerLifeCycleController lifecycle8 = new RMCustomerLifeCycleController();
        lifecycle8.PARAM_CRN='1400780';
        lifecycle8.getPreInitialize();  
        // Set mock callout class RestMockCollectionDataSet() for the successfull response     
         RestMockRMCustomerLifeCycleDataSet6 RestMock_9= new RestMockRMCustomerLifeCycleDataSet6();        
         RestMock_9.dayDifference(-3); 
        Test.setMock(HttpCalloutMock.class, RestMock_9);
        //invoke constructor to test condition in customer life cycle   
        RMCustomerLifeCycleController lifecycle9 = new RMCustomerLifeCycleController();
        lifecycle9.PARAM_CRN='1400780';
        lifecycle9.getPreInitialize();  
       
       
        // Set mock callout class RestMockCollectionDataSet() for the successfull response 
         RestMockRMCustomerLifeCycleDataSet7 RestMock_10= new RestMockRMCustomerLifeCycleDataSet7();
         RestMock_10.dayDifference(0);      
         Test.setMock(HttpCalloutMock.class, RestMock_10);
        //invoke constructor to test condition in customer life cycle 
        RMCustomerLifeCycleController lifecycle10 = new RMCustomerLifeCycleController();
        lifecycle10.PARAM_CRN='1400780';
        lifecycle10.getPreInitialize();  
         // Set mock callout class RestMockCollectionDataSet() for the successfull response 
         RestMockRMCustomerLifeCycleDataSet7 RestMock_11= new RestMockRMCustomerLifeCycleDataSet7();
         RestMock_11.dayDifference(1);      
         Test.setMock(HttpCalloutMock.class, RestMock_11);
        //invoke constructor to test condition in customer life cycle 
        RMCustomerLifeCycleController lifecycle11 = new RMCustomerLifeCycleController();
        lifecycle11.PARAM_CRN='1400780';
        lifecycle11.getPreInitialize();  
          // Set mock callout class RestMockCollectionDataSet() for the successfull response 
         RestMockRMCustomerLifeCycleDataSet7 RestMock_12= new RestMockRMCustomerLifeCycleDataSet7();
         RestMock_12.dayDifference(2);      
         Test.setMock(HttpCalloutMock.class, RestMock_12);
        //invoke constructor to test condition in customer life cycle 
        RMCustomerLifeCycleController lifecycle12 = new RMCustomerLifeCycleController();
        lifecycle12.PARAM_CRN='1400780';
        lifecycle12.getPreInitialize();  
        // Set mock callout class RestMockCollectionDataSet() for the successfull response     
         RestMockRMCustomerLifeCycleDataSet6 RestMock_13= new RestMockRMCustomerLifeCycleDataSet6();
         RestMock_13.dayDifference(-5); 
        Test.setMock(HttpCalloutMock.class, RestMock_13);
        //invoke constructor to test condition in customer life cycle   
        RMCustomerLifeCycleController lifecycle13 = new RMCustomerLifeCycleController();
        lifecycle13.PARAM_CRN='1400780';
        lifecycle13.getPreInitialize();  
        
    }
    
    private static void createCustomSettingData() {
        List < PaymentsColorCodes__c > PaymentsColorCodes_List = new List < PaymentsColorCodes__c > ();
        PaymentsColorCodes__c PaymentsColorCode_obj1 = 
            new PaymentsColorCodes__c(name = 'PaymentRecievedAfterDue', Color_Code__c = 'Red', No_of_days__c = 0);
        PaymentsColorCodes__c PaymentsColorCode_obj2 = 
            new PaymentsColorCodes__c(name = 'PaymentRecievedBeforeDue', Color_Code__c = 'Green', No_of_days__c = 0);
        PaymentsColorCodes__c PaymentsColorCode_obj3 = 
            new PaymentsColorCodes__c(name = 'UpcomingPayments0daysLeft', Color_Code__c = 'Red', No_of_days__c = 0);
        PaymentsColorCodes__c PaymentsColorCode_obj4 = 
            new PaymentsColorCodes__c(name = 'UpcomingPayments3daysLeft', Color_Code__c = '#FF9721', No_of_days__c = -3);
        PaymentsColorCodes__c PaymentsColorCode_obj5 = new 
            PaymentsColorCodes__c(name = 'UpcomingPayments4daysLeft', Color_Code__c = 'Green', No_of_days__c = -4);

        PaymentsColorCodes_List.add(PaymentsColorCode_obj1);
        PaymentsColorCodes_List.add(PaymentsColorCode_obj2);
        PaymentsColorCodes_List.add(PaymentsColorCode_obj3);
        PaymentsColorCodes_List.add(PaymentsColorCode_obj4);
        PaymentsColorCodes_List.add(PaymentsColorCode_obj5);
        insert PaymentsColorCodes_List;
    }

}