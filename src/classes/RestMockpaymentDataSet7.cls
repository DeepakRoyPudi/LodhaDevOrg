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

global class RestMockpaymentDataSet7 implements HttpCalloutMock {
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
        addtobody = addtobody + '"Due Date": "03 Jun 2014",';
        addtobody = addtobody + '"Balance Due": "1447.00"';
        addtobody = addtobody + '}';
        addtobody = addtobody + '{';
        addtobody = addtobody + '"Service Tax Outstanding": "0.00",';
        addtobody = addtobody + '"Service Tax Due": "21211.00",';
        addtobody = addtobody + '"Bank Details": "NEFT",';
        addtobody = addtobody + '"Inst Date": "08 Jun 2012",';
        addtobody = addtobody + '"Principal Amount Due": "450000.00",';
        addtobody = addtobody + '"Principal Outstanding": "0.00",';
        addtobody = addtobody + '"Interest Due (Virtual - Charged/As ondate)": "0.000000",';
        addtobody = addtobody + '"Inst Rec Date": "08 Jun 2012",';
        addtobody = addtobody + '"Individual Receipt No": "1700000300",';
        addtobody = addtobody + '"Payment MileStone": "Application money-1",';
        addtobody = addtobody + '"Payments Received": "471211.00",';
        addtobody = addtobody + '"crn": "0001400780",';
        addtobody = addtobody + '"Bill Date": "01 Jun 2012",';
        addtobody = addtobody + '"Principal Amount Received": "450000.00",';
        addtobody = addtobody + '"Reference": "NEFT",';
        addtobody = addtobody + '"Total Due": "471211.00",';
        addtobody = addtobody + '"Inst Entry Date": "08 Feb 2012",';
        addtobody = addtobody + '"Due Date": "14 Jun 2012",';
        addtobody = addtobody + '"Balance Due": "0.00"';
        addtobody = addtobody + '}';
        addtobody = addtobody + '{';
        addtobody = addtobody + '"Service Tax Outstanding": "0.00",';
        addtobody = addtobody + '"Service Tax Due": "21211.00",';
        addtobody = addtobody + '"Bank Details": "ICICI BANK LTD",';
        addtobody = addtobody + '"Inst Date": "15 Jun 2012",';
        addtobody = addtobody + '"Principal Amount Due": "450000.00",';
        addtobody = addtobody + '"Principal Outstanding": "0.00",';
        addtobody = addtobody + '"Interest Due (Virtual - Charged/As ondate)": "0.000000",';
        addtobody = addtobody + '"Inst Rec Date": "15 Jun 2012",';
        addtobody = addtobody + '"Individual Receipt No": "1700000332",';
        addtobody = addtobody + '"Payment MileStone": "Application money-1",';
        addtobody = addtobody + '"Payments Received": "471211.00",';
        addtobody = addtobody + '"crn": "0001400780",';
        addtobody = addtobody + '"Bill Date": "01 Jun 2012",';
        addtobody = addtobody + '"Principal Amount Received": "2640371.00",';
        addtobody = addtobody + '"Reference": "822342",';
        addtobody = addtobody + '"Total Due": "471211.00",';
        addtobody = addtobody + '"Inst Entry Date": "15 Jun 2012",';
        addtobody = addtobody + '"Due Date": "14 Jun 2012",';
        addtobody = addtobody + '"Balance Due": "0.00"';
        addtobody = addtobody + '}';
        addtobody = addtobody + '{';
        addtobody = addtobody + '"Service Tax Outstanding": "0.00",';
        addtobody = addtobody + '"Service Tax Due": "124452.00",';
        addtobody = addtobody + '"Bank Details": "NEFT",';
        addtobody = addtobody + '"Inst Date": "08 Mar 2012",';
        addtobody = addtobody + '"Principal Amount Due": "2640371.00",';
        addtobody = addtobody + '"Principal Outstanding": "0.00",';
        addtobody = addtobody + '"Interest Due (Virtual - Charged/As ondate)": "0.000000",';
        addtobody = addtobody + '"Inst Rec Date": "08 Mar 2012",';
        addtobody = addtobody + '"Individual Receipt No": "1700000300",';
        addtobody = addtobody + '"Payment MileStone": "Application money-2",';
        addtobody = addtobody + '"Payments Received": "2764823.00",';
        addtobody = addtobody + '"crn": "0001400780",';
        addtobody = addtobody + '"Bill Date": "01 Mar 2012",';
        addtobody = addtobody + '"Principal Amount Received": "450000.00",';
        addtobody = addtobody + '"Reference": "NEFT",';
        addtobody = addtobody + '"Total Due": "2764823.00",';
        addtobody = addtobody + '"Inst Entry Date": "08 Mar 2012",';
        addtobody = addtobody + '"Due Date": "15 Mar 2012",';
        addtobody = addtobody + '"Balance Due": "0.00"';
        addtobody = addtobody + '}';
        addtobody = addtobody + '{';
        addtobody = addtobody + '"Service Tax Outstanding": "0.00",';
        addtobody = addtobody + '"Service Tax Due": "124452.00",';
        addtobody = addtobody + '"Bank Details": "ICICI BANK LTD",';
        addtobody = addtobody + '"Inst Date": "15 May 2012",';
        addtobody = addtobody + '"Principal Amount Due": "2640371.00",';
        addtobody = addtobody + '"Principal Outstanding": "0.00",';
        addtobody = addtobody + '"Interest Due (Virtual - Charged/As ondate)": "0.000000",';
        addtobody = addtobody + '"Inst Rec Date": "15 May 2012",';
        addtobody = addtobody + '"Individual Receipt No": "1700000332",';
        addtobody = addtobody + '"Payment MileStone": "Application money-2",';
        addtobody = addtobody + '"Payments Received": "2764823.00",';
        addtobody = addtobody + '"crn": "0001400780",';
        addtobody = addtobody + '"Bill Date": "01 May 2012",';
        addtobody = addtobody + '"Principal Amount Received": "2640371.00",';
        addtobody = addtobody + '"Reference": "822342",';
        addtobody = addtobody + '"Total Due": "2764823.00",';
        addtobody = addtobody + '"Inst Entry Date": "15 May 2012",';
        addtobody = addtobody + '"Due Date": "15 May 2012",';
        addtobody = addtobody + '"Balance Due": "100.00"';
        addtobody = addtobody + '}';
        addtobody = addtobody + '{';
        addtobody = addtobody + '"Interest Due (Virtual - Charged/As ondate)": "0.000000",';
        addtobody = addtobody + '"Service Tax Outstanding": "0.00",';
        addtobody = addtobody + '"Payments Received": "0.00",';
        addtobody = addtobody + '"Payment MileStone": "Earnest money",';
        addtobody = addtobody + '"Service Tax Due": "0.00",';
        addtobody = addtobody + '"Bill Date": "12 Apr 2015",';
        addtobody = addtobody + '"crn": "0001400780",';
        addtobody = addtobody + '"Total Due": "0.00",';
        addtobody = addtobody + '"Principal Outstanding": "0.00",';
        addtobody = addtobody + '"Principal Amount Due": "450000.00",';
        addtobody = addtobody + '"Due Date": "20 Apr 2015",';
        addtobody = addtobody + '"Balance Due": "0.00"';
        addtobody = addtobody + '}';
        addtobody = addtobody + '{';
        addtobody = addtobody + '"Service Tax Outstanding": "0.00",';
        addtobody = addtobody + '"Service Tax Due": "147119.00",';
        addtobody = addtobody + '"Bank Details": "ICICI BANK LTD",';
        addtobody = addtobody + '"Inst Date": "03 Jul 2012",';
        addtobody = addtobody + '"Principal Amount Due": "3121275.00",';
        addtobody = addtobody + '"Principal Outstanding": "0.00",';
        addtobody = addtobody + '"Interest Due (Virtual - Charged/As ondate)": "0.000000",';
        addtobody = addtobody + '"Inst Rec Date": "03 Jul 2012",';
        addtobody = addtobody + '"Individual Receipt No": "1700000809",';
        addtobody = addtobody + '"Payment MileStone": "Foundation raft",';
        addtobody = addtobody + '"Payments Received": "3268394.00",';
        addtobody = addtobody + '"crn": "0001400780",';
        addtobody = addtobody + '"Bill Date": "21 Jun 2012",';
        addtobody = addtobody + '"Principal Amount Received": "3121275.00",';
        addtobody = addtobody + '"Reference": "816830",';
        addtobody = addtobody + '"Total Due": "3268394.00",';
        addtobody = addtobody + '"Inst Entry Date": "05 Jul 2012",';
        addtobody = addtobody + '"Due Date": "05 Jul 2012",';
        addtobody = addtobody + '"Balance Due": "100.00"';
        addtobody = addtobody + '}';
        addtobody = addtobody + '{';
        addtobody = addtobody + '"Service Tax Outstanding": "0.00",';
        addtobody = addtobody + '"Service Tax Due": "109247.00",';
        addtobody = addtobody + '"Bank Details": "ICICI BANK LTD",';
        addtobody = addtobody + '"Inst Date": "03 Jun 2012",';
        addtobody = addtobody + '"Principal Amount Due": "2317779.00",';
        addtobody = addtobody + '"Principal Outstanding": "0.00",';
        addtobody = addtobody + '"Interest Due (Virtual - Charged/As ondate)": "0.000000",';
        addtobody = addtobody + '"Inst Rec Date": "03 Jun 2012",';
        addtobody = addtobody + '"Individual Receipt No": "1700000810",';
        addtobody = addtobody + '"Payment MileStone": "Podium - P2",';
        addtobody = addtobody + '"Payments Received": "2427026.00",';
        addtobody = addtobody + '"crn": "0001400780",';
        addtobody = addtobody + '"Bill Date": "21 Jun 2012",';
        addtobody = addtobody + '"Principal Amount Received": "1878725.00",';
        addtobody = addtobody + '"Reference": "816830",';
        addtobody = addtobody + '"Total Due": "2427026.00",';
        addtobody = addtobody + '"Inst Entry Date": "05 Jun 2012",';
        addtobody = addtobody + '"Due Date": "05 Jun 2012",';
        addtobody = addtobody + '"Balance Due": "100.00"';
        addtobody = addtobody + '}';
        addtobody = addtobody + '{';
        addtobody = addtobody + '"Service Tax Outstanding": "0.00",';
        addtobody = addtobody + '"Service Tax Due": "109247.00",';
        addtobody = addtobody + '"Bank Details": "ICICI BANK LTD",';
        addtobody = addtobody + '"Inst Date": "03 Sep 2012",';
        addtobody = addtobody + '"Principal Amount Due": "2317779.00",';
        addtobody = addtobody + '"Principal Outstanding": "0.00",';
        addtobody = addtobody + '"Interest Due (Virtual - Charged/As ondate)": "0.000000",';
        addtobody = addtobody + '"Inst Rec Date": "03 Sep 2012",';
        addtobody = addtobody + '"Individual Receipt No": "1700000811",';
        addtobody = addtobody + '"Payment MileStone": "Podium - P2",';
        addtobody = addtobody + '"Payments Received": "2427026.00",';
        addtobody = addtobody + '"crn": "0001400780",';
        addtobody = addtobody + '"Bill Date": "21 Sep 2012",';
        addtobody = addtobody + '"Principal Amount Received": "439054.00",';
        addtobody = addtobody + '"Reference": "016856",';
        addtobody = addtobody + '"Total Due": "2427026.00",';
        addtobody = addtobody + '"Inst Entry Date": "05 Sep 2012",';
        addtobody = addtobody + '"Due Date": "05 Sep 2012",';
        addtobody = addtobody + '"Balance Due": "0.00"';
        addtobody = addtobody + '}';
        addtobody = addtobody + '{';
        addtobody = addtobody + '"Service Tax Outstanding": "0.00",';
        addtobody = addtobody + '"Service Tax Due": "109247.00",';
        addtobody = addtobody + '"Bank Details": "ICICI BANK LTD",';
        addtobody = addtobody + '"Inst Date": "03 Oct 2012",';
        addtobody = addtobody + '"Principal Amount Due": "2317779.00",';
        addtobody = addtobody + '"Principal Outstanding": "0.00",';
        addtobody = addtobody + '"Interest Due (Virtual - Charged/As ondate)": "0.000000",';
        addtobody = addtobody + '"Inst Rec Date": "03 Oct 2012",';
        addtobody = addtobody + '"Individual Receipt No": "1700000812",';
        addtobody = addtobody + '"Payment MileStone": "Podium -P6",';
        addtobody = addtobody + '"Payments Received": "2427026.00",';
        addtobody = addtobody + '"crn": "0001400780",';
        addtobody = addtobody + '"Bill Date": "21 Oct 2012",';
        addtobody = addtobody + '"Principal Amount Received": "2317779.00",';
        addtobody = addtobody + '"Reference": "016856",';
        addtobody = addtobody + '"Total Due": "2427026.00",';
        addtobody = addtobody + '"Inst Entry Date": "05 Oct 2012",';
        addtobody = addtobody + '"Due Date": "05 Oct 2012",';
        addtobody = addtobody + '"Balance Due": "0.00"';
        addtobody = addtobody + '}';
        addtobody = addtobody + '{';
        addtobody = addtobody + '"Interest Due (Virtual - Charged/As ondate)": "44196.438538",';
        addtobody = addtobody + '"Service Tax Outstanding": "0.00",';
        addtobody = addtobody + '"Payments Received": "0.00",';
        addtobody = addtobody + '"Payment MileStone": "Possession",';
        addtobody = addtobody + '"Service Tax Due": "0.00",';
        addtobody = addtobody + '"Bill Date": "01 Jun 2015",';
        addtobody = addtobody + '"crn": "0001400780",';
        addtobody = addtobody + '"Total Due": "1545182.00",';
        addtobody = addtobody + '"Principal Outstanding": "1545182.00",';
        addtobody = addtobody + '"Principal Amount Due": "3090364.00",';
        addtobody = addtobody + '"Due Date": "15 Jun 2015",';
        addtobody = addtobody + '"Balance Due": "1545182.00"';
        addtobody = addtobody + '}';
        addtobody = addtobody + '{';
        addtobody = addtobody + '"Service Tax Outstanding": "0.00",';
        addtobody = addtobody + '"Service Tax Due": "144206.00",';
        addtobody = addtobody + '"Bank Details": "ICICI BANK LTD",';
        addtobody = addtobody + '"Inst Date": "15 Nov 2012",';
        addtobody = addtobody + '"Principal Amount Due": "3059468.00",';
        addtobody = addtobody + '"Principal Outstanding": "0.00",';
        addtobody = addtobody + '"Interest Due (Virtual - Charged/As ondate)": "0.000000",';
        addtobody = addtobody + '"Inst Rec Date": "15 Nov 2012",';
        addtobody = addtobody + '"Individual Receipt No": "1700000333",';
        addtobody = addtobody + '"Payment MileStone": "Second Instalment",';
        addtobody = addtobody + '"Payments Received": "3203674.00",';
        addtobody = addtobody + '"crn": "0001400780",';
        addtobody = addtobody + '"Bill Date": "01 Nov 2012",';
        addtobody = addtobody + '"Principal Amount Received": "3059468.00",';
        addtobody = addtobody + '"Reference": "822342",';
        addtobody = addtobody + '"Total Due": "3203674.00",';
        addtobody = addtobody + '"Inst Entry Date": "15 Nov 2012",';
        addtobody = addtobody + '"Due Date": "15 Dec 2012",';
        addtobody = addtobody + '"Balance Due": "0.00"';

        res.setBody('{' + addtobody + '}');
        system.debug('<<<<<<<<<<<<<<<<<<<<<<<<<<<<addtobody' + addtobody);
        res.setStatusCode(200);
        return res;
    }
}