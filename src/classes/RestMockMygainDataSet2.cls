/* 
Description : Creating three mock response for payments received data  
 @Created by: Shruti Nikam
 @Created Date: 18/05/2015
 
 --------------------------------------------------------------------------------
 | Modified By      | Modified Date       | Version        | Description         |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------

*/
@isTest
                        
global class RestMockMygainDataSet2 implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
         String endpoint_URL =  System.Label.Url_for_mygain_web_services;
        Integer qIndex1=endpoint_URL.indexOf('?');
        
        Integer qIndex2 = req.getEndpoint().indexOf('?');
        
        System.assertEquals(endpoint_URL.substring(0, qIndex1), req.getEndpoint().substring(0, qIndex2));
        System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
  
        String addtobody;
        res.setBody('{'+addtobody+'}');
        res.setStatusCode(500);
        return res;
    }
}