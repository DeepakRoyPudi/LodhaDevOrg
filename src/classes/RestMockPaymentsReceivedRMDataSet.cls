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

//this class work for call two web service and its responses 
global class RestMockPaymentsReceivedRMDataSet implements HttpCalloutMock {

    // Implement this interface method 
    global HTTPResponse respond(HTTPRequest req) {

        // Optionally, only send a mock response for a specific endpoint
        // and method.
        // mock when payments is reqiured 
        String endpoint_URL_Cust = System.Label.Url_for_customerinfo_web_services;
        Integer qIndex1=endpoint_URL_Cust.indexOf('?');
        endpoint_URL_Cust=endpoint_URL_Cust.substring(0, qIndex1);

        Integer qIndex2 = req.getEndpoint().indexOf('?');
        String  req_endpoint_URL=req.getEndpoint().substring(0, qIndex2);

        String endpoint_URL_Payments =  System.Label.Url_for_payment_web_services;
        Integer qIndex3=endpoint_URL_Payments.indexOf('?');
        endpoint_URL_Payments=endpoint_URL_Payments.substring(0, qIndex3);
        
        String endpoint_URL_Mygain =  System.Label.Url_for_mygain_web_services;
        Integer qIndex4=endpoint_URL_Mygain.indexOf('?');
        endpoint_URL_Mygain=endpoint_URL_Mygain.substring(0, qIndex4);
        
        if (req_endpoint_URL.equalsIgnoreCase(endpoint_URL_Payments)) {
            System.assertEquals(endpoint_URL_Payments, req_endpoint_URL);
            System.assertEquals('GET', req.getMethod());
            HttpResponse res = new RestMockpaymentDataSet().respond(req);
            return res;
        } 
        else {
            // mock when mygain is reqiured 
            if (req_endpoint_URL.equalsIgnoreCase(endpoint_URL_Mygain)) {
                System.assertEquals(endpoint_URL_Mygain, req_endpoint_URL);
                System.assertEquals('GET', req.getMethod());
                HttpResponse res = new RestMockMygainDataSet().respond(req);
                return res;
            } 
            else {
                if (req_endpoint_URL.equalsIgnoreCase(endpoint_URL_Cust)) {
                    System.assertEquals(endpoint_URL_Cust, req_endpoint_URL);
                    System.assertEquals('GET', req.getMethod());
                    HttpResponse res = new RestMockHttpResponseGeneratorDataSet1().respond(req);
                    return res;
                } 
                else {
                    HttpResponse res = new HttpResponse();
                    return res;
                }
            }
        }
    }
}