/* 
Description :Test class for calculating collection index 
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
@isTest(seeAllData=false)
public class UpcomingDuePaymentsRMControllertest{

public testmethod static void UpcomingDuePaymentsTestmethod(){ 
  
            
           List<PaymentsColorCodes__c> PaymentsColorCodes_List = new List<PaymentsColorCodes__c>();
           PaymentsColorCodes__c PaymentsColorCode_obj1 = new PaymentsColorCodes__c(name='PaymentRecievedAfterDue',Color_Code__c='Red',No_of_days__c=0);
           PaymentsColorCodes__c PaymentsColorCode_obj2 = new PaymentsColorCodes__c(name='PaymentRecievedBeforeDue',Color_Code__c='Green',No_of_days__c=0);
           PaymentsColorCodes__c PaymentsColorCode_obj3 = new PaymentsColorCodes__c(name='UpcomingPayments0daysLeft',Color_Code__c='Red',No_of_days__c=0);
           PaymentsColorCodes__c PaymentsColorCode_obj4 = new PaymentsColorCodes__c(name='UpcomingPayments3daysLeft',Color_Code__c='#FF9721',No_of_days__c=-3);
           PaymentsColorCodes__c PaymentsColorCode_obj5 = new PaymentsColorCodes__c(name='UpcomingPayments4daysLeft',Color_Code__c='Green',No_of_days__c=-4);
           
           PaymentsColorCodes_List.add(PaymentsColorCode_obj1);
           PaymentsColorCodes_List.add(PaymentsColorCode_obj2);
           PaymentsColorCodes_List.add(PaymentsColorCode_obj3);
           PaymentsColorCodes_List.add(PaymentsColorCode_obj4);
           PaymentsColorCodes_List.add(PaymentsColorCode_obj5);
           insert PaymentsColorCodes_List; 
           system.debug('Custom Setting :::::::::::::'+PaymentsColorCodes_List);
           Test.startTest();
             // Set mock callout class RestMockHttpResponseGenerator for the successfull response with my gain yes 
           Test.setMock(HttpCalloutMock.class, new RestMockpaymentDataSet());
           
           RestAPICalloutPayment rc1=new RestAPICalloutPayment('1400780');
            // Set mock callout class RestMockHttpResponseGenerator for the successfull response with status code 500
           Test.setMock(HttpCalloutMock.class, new RestMockpaymentDataSet1());
           
           RestAPICalloutPayment rc2=new RestAPICalloutPayment('1400780');
           UpcomingDuePaymentsRMController up1 = new UpcomingDuePaymentsRMController();
           up1.getPreIntialize();
           up1.NoOfRecords = 5;
           Test.stopTest();
           System.assertNotEquals(null,up1); 
         
               
     
}

}