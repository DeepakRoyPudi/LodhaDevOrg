/*    Description: Creating a Mock Callout class to set the response of the callout made for Palava webservice
*    
*    Version         Date            Author              Description
*    1.0            07/11/2014      Asmita(Eternus)      Initial Draft
*/

@isTest
global class MockupResponseForReturningStatusPalava implements HttpCalloutMock{

    global  HTTPResponse respond(HTTPRequest req){
        String strResBody = '';
        
        // Creating a fake response
        HttpResponse oHResponse = new HttpResponse(); 
        oHResponse.setHeader('Content-Type', 'application/json');
        strResBody = '"status":"ok"';
        oHResponse.setBody(strResBody);
        oHResponse.setStatusCode(200);
        return oHResponse;
    }
}