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
global class RestMockPaymentScheduleDataSet implements HttpCalloutMock{
     // Implement this interface method
     global HTTPResponse respond(HTTPRequest req){
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        String endpoint_URL = System.Label.url_for_paymentschedule_websercice;
         Integer qIndex1=endpoint_URL.indexOf('?');
         Integer qIndex2 = req.getEndpoint().indexOf('?');
         System.assertEquals(endpoint_URL.substring(0, qIndex1), req.getEndpoint().substring(0, qIndex2));
         System.assertEquals('GET', req.getMethod());
          // Create a fake response
           HttpResponse res = new HttpResponse();
           res.setHeader('Content-Type', 'application/json');
           String addtobody = '"MSTXT":"Fit- Outs",';
           addtobody = addtobody + '"SLAB_INV":"268664.00"';
           addtobody = addtobody + '}';
           addtobody = addtobody + '{';
           addtobody = addtobody+'"MSTXT ":"RCC work for Level 14",';
           addtobody = addtobody + '"SLAB_INV":"262664.00"';
           res.setBody('{' + addtobody + '}');
	       system.debug('<<<<<<<<<<<<<<<<<<<<<<<<<<<<addtobody' + addtobody);
	       res.setStatusCode(200);
	       return res;
          
     }
    
}