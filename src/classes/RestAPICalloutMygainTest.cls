/* test class for payments web service 
 @Created by: Shruti Nikam
 @Created Date: 7/5/2015
 
 --------------------------------------------------------------------------------
 | Modified By      | Modified Date       | Version        | Description         |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------

*/
@isTest(seeAllData=false)
public class RestAPICalloutMygainTest{
	public testmethod static void httpcalloutTestmethod(){
		Test.startTest();
	        // Set mock callout class RestMockMygainDataSet for the successfull response with my gain yes 
	        Test.setMock(HttpCalloutMock.class, new RestMockMygainDataSet());
	        RestAPICalloutMygain rc1=new RestAPICalloutMygain('1401350') ;
	  		System.assertNotEquals(null,rc1); 
	               
	        // Set mock callout class RestMockMygainDataSet2 for the successfull response with my gain value NO 
	        Test.setMock(HttpCalloutMock.class, new RestMockMygainDataSet2());
	        RestAPICalloutMygain rc2=new RestAPICalloutMygain('1401350') ;
	        System.assertNotEquals(null,rc2); 
	        System.assertNotEquals(0,rc1.MygainBasicRecords.size());
		Test.stopTest();
	    
	         
	}

}