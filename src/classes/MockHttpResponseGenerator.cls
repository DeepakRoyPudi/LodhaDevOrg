@isTest

/*    Description: Creating a Mock Callout class to set the response of the callout made while consumin Box Integration webservice.
*    
*    Version            Date            Author                    Description
*    1.0                10/06/2014      Asmita(Eternus)           Initial Draft
*/


global class MockHttpResponseGenerator implements HttpCalloutMock{
    
    global  HTTPResponse respond(HTTPRequest req){
    	
    	
    	// Creating a fake response
    	HttpResponse oHResponse = new HttpResponse(); 
    	oHResponse.setHeader('Content-Type', 'application/json');
    	oHResponse.setBody('{"id":"12345", "status":"done", "url":"https://view-api.box.com/1/sessions/12345/view?theme=dark"}');
    	oHResponse.setStatusCode(200);
    	
    	return oHResponse;
    }

}