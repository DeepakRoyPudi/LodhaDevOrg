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

global class RestMockpaymentDataSet3 implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
          String endpoint_URL = System.Label.Url_for_payment_web_services;
        Integer qIndex1=endpoint_URL.indexOf('?');
        
        Integer qIndex2 = req.getEndpoint().indexOf('?');
        
        System.assertEquals(endpoint_URL.substring(0, qIndex1), req.getEndpoint().substring(0, qIndex2));
        
        System.assertEquals('GET', req.getMethod());

        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        String addtobody = '"Interest Due (Virtual - Charged/As ondate)": "223.353357",';
        addtobody = addtobody + '"Service Tax Outstanding": "0.00",';
        addtobody = addtobody + '"Payments Received": "0.00",';
        addtobody = addtobody + '"Payment MileStone": "1% MVAT Recovery",';
        addtobody = addtobody + '"Service Tax Due": "0.00",';
        addtobody = addtobody + '"Bill Date": "19 Jun 2014",';
        addtobody = addtobody + '"crn": "0001400780",';
        addtobody = addtobody + '"Total Due": "1447.00",';
        addtobody = addtobody + '"Principal Outstanding": "1447.00",';
        addtobody = addtobody + '"Principal Amount Due": "1447.00",';
        addtobody = addtobody + '"Due Date": "03 Jul 2014",';
        addtobody = addtobody + '"Balance Due": "1447.00"';
        addtobody = addtobody + '}';
        addtobody = addtobody + '{';
        addtobody = addtobody + '"Service Tax Outstanding": "0.00",';
        addtobody = addtobody + '"Service Tax Due": "21211.00",';
        addtobody = addtobody + '"Bank Details": "NEFT",';
        addtobody = addtobody + '"Inst Date": "08 May 2012",';
        addtobody = addtobody + '"Principal Amount Due": "450000.00",';
        addtobody = addtobody + '"Principal Outstanding": "0.00",';
        addtobody = addtobody + '"Interest Due (Virtual - Charged/As ondate)": "0.000000",';
        addtobody = addtobody + '"Inst Rec Date": "08 May 2012",';
        addtobody = addtobody + '"Individual Receipt No": "1700000300",';
        addtobody = addtobody + '"Payment MileStone": "Application money-1",';
        addtobody = addtobody + '"Payments Received": "471211.00",';
        addtobody = addtobody + ' "crn": "0001400780",';
        addtobody = addtobody + '"Bill Date": "01 May 2012",';
        addtobody = addtobody + '"Principal Amount Received": "450000.00",';
        addtobody = addtobody + '"Reference": "NEFT",';
        addtobody = addtobody + '"Total Due": "471211.00",';
        addtobody = addtobody + '"Inst Entry Date": "08 May 2012",';
        addtobody = addtobody + '"Due Date": "14 May 2012",';
        addtobody = addtobody + '"Balance Due": "0.00"';
        res.setBody('{' + addtobody + '}');
        system.debug('<<<<<<<<<<<<<<<<<<<<<<<<<<<<addtobody' + addtobody);
        res.setStatusCode(200);
        return res;
    }
}