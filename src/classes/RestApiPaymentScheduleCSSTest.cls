/* 
Description : Creating three mock response for payments received data  
 @Created by: Deepak Pudi
 @Created Date: 14/01/2016
 
 --------------------------------------------------------------------------------
 | Modified By      | Modified Date       | Version        | Description         |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------

*/

@isTest
public with sharing class RestApiPaymentScheduleCSSTest {
    public testmethod static void paymentSchedule(){
        // Set mock callout class RestMockHttpResponseGenerator for the successfull response with my gain yes 
        Test.setMock(HttpCalloutMock.class, new RestMockPaymentScheduleDataSet());
        RestApiPaymentScheduleCSS rc1=new RestApiPaymentScheduleCSS ('1401807');
        System.assertNotEquals(null,rc1); 
    }
    
}