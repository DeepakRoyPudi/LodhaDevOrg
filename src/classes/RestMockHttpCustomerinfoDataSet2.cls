/* 
Description : Creating three mock response for payments received data  
 @Created by: Shruti Nikam
 @Created Date: 08/07/2015
 
 --------------------------------------------------------------------------------
 | Modified By      | Modified Date       | Version        | Description         |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------

*/


@isTest
                        
global class RestMockHttpCustomerinfoDataSet2 implements HttpCalloutMock {

public integer dayDiff;
    //this method is used for initialization of day difference class variable
    //and this method have to be called after instance creation of the above class
    //after that you must call the response method 
    public void dayDifference(integer daydiff){
    this.dayDiff=daydiff;
    }
  

  // Implement this interface method
  global HTTPResponse respond(HTTPRequest req) {
    // Optionally, only send a mock response for a specific endpoint
    // and method.
    
     String endpoint_URL = System.Label.Url_for_customerinfo_web_services;
     Integer qIndex1=endpoint_URL.indexOf('?');
        
     Integer qIndex2 = req.getEndpoint().indexOf('?');
        
     System.assertEquals(endpoint_URL.substring(0, qIndex1), req.getEndpoint().substring(0, qIndex2));
    
     System.assertEquals('GET', req.getMethod());
            
    // Create a fake response
    HttpResponse res = new HttpResponse();
    res.setHeader('Content-Type', 'application/json');
    Datetime mydate = Date.today()+daydiff;
    String assigndate1 = mydate.format('yyyy-MM-dd'); 
    mydate = mydate-5;
    String assigndate2 = mydate.format('yyyy-MM-dd');  
    mydate = mydate-5;
    String assigndate3 = mydate.format('yyyy-MM-dd');  
    mydate = mydate-5;
    String assigndate4 = mydate.format('yyyy-MM-dd');  
    mydate = mydate-5;
    String assigndate5 = mydate.format('yyyy-MM-dd'); 
    mydate = mydate-5;
    String assigndate6 = mydate.format('yyyy-MM-dd');
    mydate = mydate-5;
    String assigndate7 = mydate.format('yyyy-MM-dd');
    mydate = mydate-5;
    String assigndate8 = mydate.format('yyyy-MM-dd');
    mydate = mydate-5;
    String assigndate9 = mydate.format('yyyy-MM-dd');
    mydate = mydate-5;
    String assigndate10 = mydate.format('yyyy-MM-dd');
    mydate = mydate-5;
    String assigndate11 = mydate.format('yyyy-MM-dd');
    mydate = mydate-5;
    String assigndate12 = mydate.format('yyyy-MM-dd');
    mydate = mydate-5;
    String assigndate13 = mydate.format('yyyy-MM-dd');
    mydate = mydate-5;
    String assigndate14 = mydate.format('yyyy-MM-dd');
    
    
    
    String addtobody='"Office_Address": "Lodha Excelus,N MJoshi Marg,Mumbai",';
    addtobody=addtobody+'"Age": "29",';
    addtobody=addtobody+'"MY_GAIN_CUSTOMER": "Yes",';
    addtobody=addtobody+'"REGISTRATION_STATUS": "Registered",';
    addtobody=addtobody+'"Residential_Status": "NRI",';
    addtobody=addtobody+'"TIMEBOUND_DEMAND_42DAYS": "'+assigndate14+' 11:03:34",';
    addtobody=addtobody+'"Legal_Notice_Sent_Received": "Yes",';
    addtobody=addtobody+'"TIMEBOUND_PAYMENT_RECEIPT_42DAYS": "'+assigndate13+' 11:03:34",';
    addtobody=addtobody+'"LOAN_SANCTIONED_LETTER_DATE": "'+assigndate12+' 11:03:34",';
    addtobody=addtobody+'"REGISTRATION_CHARGES": "500",';
    addtobody=addtobody+'"TIMEBOUND_PAYMENT_RECEIPT_21DAYS": "'+assigndate11+' 11:03:34",';
    addtobody=addtobody+'"Management_Booking": "Yes",';
    addtobody=addtobody+'"DISBURSAL_AMOUNT": "200000",';
    addtobody=addtobody+'"STAMP_DUTY": "12345",';
    addtobody=addtobody+'"crn": "1210055",';
    addtobody=addtobody+'"Time_of_Communication": "Evening",';
    addtobody=addtobody+'"Loan_Against_Property": "No",';
    addtobody=addtobody+'"REGISTRATION_DATE": "'+assigndate10+' 11:03:34",';
    addtobody=addtobody+'"NOC_ROC_DATE": "'+assigndate9+' 11:03:34",';
    addtobody=addtobody+'"KEY_HANDOVER_DATE": "'+assigndate8+' 11:03:34",';
    addtobody=addtobody+'"ALLOTMENT_LETTER_DATE": "'+assigndate7+' 11:03:34",';
    addtobody=addtobody+'"WELCOME_ONBOARD": "'+assigndate6+' 11:03:34",';
    addtobody=addtobody+'"TIMEBOUND_DEMAND_21DAYS": "'+assigndate5+' 11:03:34",';
    addtobody=addtobody+'"AMOUNT_SANCTIONED": "20000",';
    addtobody=addtobody+'"REGISTRATION_CHALLAN_DATE": "'+assigndate4+' 11:03:34",';
    addtobody=addtobody+'"CV_SANCTIONED": "4.5",';
    addtobody=addtobody+'"BANK_NAME": "HFDC",';
    addtobody=addtobody+'"Legal_Case_On-going": "No",';
    addtobody=addtobody+'"Co_applicant_2": "Robin Jain",';
    addtobody=addtobody+'"Co_applicant_3": "Shivam Kunwar",';
    addtobody=addtobody+'"POSSESSION_DATE": "'+assigndate1 +' 11:03:34",';
    addtobody=addtobody+'"SANCTIONED_DATE": "'+assigndate2+' 09:08:07",';
    addtobody=addtobody+'"FUNDING_STATUS": "Bank Funded",';
    addtobody=addtobody+'"OFFER_FOR_FITOUT_POSSESSION": "'+assigndate3+' 11:03:34"';
    
    res.setBody('{'+addtobody+'}');
    res.setStatusCode(200);
    return res;
  }
}