/*    Description: Creating a Mock Callout class to set the response of the callout made while consuming Aftership Integration webservice.
*    
*    Version            Date            Author                    Description
*    1.0                02/09/2014      Asmita(Eternus)           Initial Draft
*/

@isTest
global class MockHttpResponseForAftership implements HttpCalloutMock {
	
     global  HTTPResponse respond(HTTPRequest req){
    	
    	// Creating a fake response
    	HttpResponse oHResponse = new HttpResponse(); 
    	oHResponse.setHeader('Content-Type', 'application/json');
    	oHResponse.setBody('"meta": {"code": 200},"data": {"tracking": {"tracking_number": "RA123456543HK","slug": "hong-kong-post"}}');
    	oHResponse.setStatusCode(200);
    	return oHResponse;
    }
}