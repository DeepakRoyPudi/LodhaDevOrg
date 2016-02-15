/* 
Description : Test class for mygain web service 
 @Created by: Sudeep Dube
 @Created Date: 31/3/2015
 
 --------------------------------------------------------------------------------
 | Modified By      | Modified Date       | Version        | Description         |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------

*/
@isTest(seeAllData=false)
public class RestAPICalloutControllerTest{

    public testmethod static void calloutTestmethod(){
        
        // Set mock callout class RestMockHttpResponseGenerator for the successfull response with my gain yes 
        Test.setMock(HttpCalloutMock.class, new RestMockHttpResponseGeneratorDataSet1());
        RestAPICalloutController rc1=new RestAPICalloutController ();
        System.assertNotEquals(null,rc1.parseCustomerInformationJSON('1210000')); 
                   
        // Set mock callout class RestMockHttpResponseGenerator for the successfull response with my gain value NO 
        Test.setMock(HttpCalloutMock.class, new RestMockHttpResponseGeneratorDataSet2 ());
        RestAPICalloutController rc2=new RestAPICalloutController ();
        System.assertNotEquals(null,rc2.parseCustomerInformationJSON('1210055')); 
             
        // Set mock callout class RestMockHttpResponseGenerator for the unsuccessful response 
        Test.setMock(HttpCalloutMock.class, new RestMockHttpResponseGeneratorDataSet3 ());
        RestAPICalloutController rc3=new RestAPICalloutController ();
        System.assertNotEquals(null,rc3.parseCustomerInformationJSON('1210055')); 
             
    }

}