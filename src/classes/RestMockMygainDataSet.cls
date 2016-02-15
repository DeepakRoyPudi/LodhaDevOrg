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
                        
global class RestMockMygainDataSet implements HttpCalloutMock {
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
      
        String addtobody= '"Cust_Id": "0001401350",';
        addtobody=addtobody+'"BENEFIT_TILL": "2015-05-07",';
        addtobody=addtobody+'"INSTRUMENT_ENTRY_DATE": "2015-03-25",';
        addtobody=addtobody+'"INT_RATE": 12,';
        addtobody=addtobody+'"MY_GAIN_AMT_RECEIVED": -6399810,';
        addtobody=addtobody+'"BENEFIT_DAYS": 25,';
        addtobody=addtobody+'"INSTRUMENT_NUMBER": "20150325",';
        addtobody=addtobody+'"MY_GAIN_ALREADY_ADJUSTED": 0,';
        addtobody=addtobody+'"INSTRUMENT_RECEIVED_DATE": "2014-09-02",';
        addtobody=addtobody+'"BANK_DETAILS": "",';
        addtobody=addtobody+'"MY_GAIN_BALANCE_AS_ON_DATE": 6399810,';
        addtobody=addtobody+'"TEXT": "MYgain",';
        addtobody=addtobody+'"BENEFIT_FROM": "2015-04-13",';
        addtobody=addtobody+'"INSTRUMENT_DATE": "2014-08-28",';
        addtobody=addtobody+'"REBATE_CALCULATED": 52601';
        addtobody=addtobody+' }, {';
        addtobody=addtobody+'"Cust_Id": "0001401350",';
        addtobody=addtobody+'"BENEFIT_TILL": "2015-05-07",';
        addtobody=addtobody+'"INSTRUMENT_ENTRY_DATE": "2015-03-25",';
        addtobody=addtobody+'"INT_RATE": 12,';
        addtobody=addtobody+'"MY_GAIN_AMT_RECEIVED": 6399810,';
        addtobody=addtobody+'"BENEFIT_DAYS": 25,';
        addtobody=addtobody+'"INSTRUMENT_NUMBER": "20150325",';
        addtobody=addtobody+'"MY_GAIN_ALREADY_ADJUSTED": 0,';
        addtobody=addtobody+'"INSTRUMENT_RECEIVED_DATE": "2014-09-02",';
        addtobody=addtobody+'"BANK_DETAILS": "",';
        addtobody=addtobody+'"MY_GAIN_BALANCE_AS_ON_DATE": -6399810,';
        addtobody=addtobody+'"TEXT": "MYgain",';
        addtobody=addtobody+'"BENEFIT_FROM": "2015-04-13",';
        addtobody=addtobody+'"INSTRUMENT_DATE": "2014-08-28",';
        addtobody=addtobody+'"REBATE_CALCULATED": -52601';
        addtobody=addtobody+'},{';
        addtobody=addtobody+'"Cust_Id": "0001401350",';
        addtobody=addtobody+'"BENEFIT_TILL": "2015-05-07",';
        addtobody=addtobody+'"INSTRUMENT_ENTRY_DATE": "2014-09-03",';
        addtobody=addtobody+'"INT_RATE": 12,';
        addtobody=addtobody+'"MY_GAIN_AMT_RECEIVED": -6399810,';
        addtobody=addtobody+'"BENEFIT_DAYS": 226,';
        addtobody=addtobody+'"INSTRUMENT_NUMBER": "523137",';
        addtobody=addtobody+'"MY_GAIN_ALREADY_ADJUSTED": 2261483,';
        addtobody=addtobody+'"INSTRUMENT_RECEIVED_DATE": "2014-09-02",';
        addtobody=addtobody+'"BANK_DETAILS": "AXIS BANK LTD",';
        addtobody=addtobody+'"MY_GAIN_BALANCE_AS_ON_DATE": 4138327,';
        addtobody=addtobody+'"TEXT": "Mygain Advance",';
        addtobody=addtobody+'"BENEFIT_FROM": "2014-09-24",';
        addtobody=addtobody+'"INSTRUMENT_DATE": "2014-08-28",';
        addtobody=addtobody+'"REBATE_CALCULATED": 307483';
        addtobody=addtobody+'},{';
        addtobody=addtobody+'"Cust_Id": "0001401350",';
        addtobody=addtobody+'"AMT_ON_WHICH_DEBATE_CALCULATED": 0,';
        addtobody=addtobody+'"BENEFIT_DAYS": 0,';
        addtobody=addtobody+'"REBATE_CALCULATED_FROM": "0000-00-00",';
        addtobody=addtobody+'"REBATE_CALCULATED_TILL": "0000-00-00",';
        addtobody=addtobody+'"REBATE_POSTED": 0';
        addtobody=addtobody+'},{';
        addtobody=addtobody+'"Cust_Id": "0001401350",';
        addtobody=addtobody+'"AMT_ON_WHICH_DEBATE_CALCULATED": 0,';
        addtobody=addtobody+'"BENEFIT_DAYS": 0,';
        addtobody=addtobody+'"REBATE_CALCULATED_FROM": "0000-00-00",';
        addtobody=addtobody+'"REBATE_CALCULATED_TILL": "0000-00-00",';
        addtobody=addtobody+'"REBATE_POSTED": 0';
    
        res.setBody('{"array": [{'+addtobody+'}]}');
        res.setStatusCode(200);
        return res;
    }
}