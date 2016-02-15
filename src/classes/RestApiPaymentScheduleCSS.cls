/* 
Description : Creating three mock response for payments received data  
 @Created by: Deepak Pudi
 @Created Date: 28/12/2015
 
 --------------------------------------------------------------------------------
 | Modified By      | Modified Date       | Version        | Description         |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------

*/
public with sharing class RestApiPaymentScheduleCSS {
    public List<PaymentScheduleWrapper> paymentScheduleWrapperList {get;set;}
    public PaymentScheduleWrapper PaymentScheduleWrapperobj;
    public decimal totalAmount{get;set;}
    
    public final static String NUL = 'null';
    public final static String NO_DATA_FOUND = 'No data found';
    public final static String PAYMT_NILESTONE = 'MSTXT';
    public final static String PRINC_AMT = 'SLAB_INV';
    
    public RestApiPaymentScheduleCSS(string CRN){
        PaymentScheduleWrapperobj = new PaymentScheduleWrapper();
        paymentScheduleWrapperList = new List<PaymentScheduleWrapper>();
        parsePaymentScheduleJSON(CRN);
        calPercentOfCVAmount();
    }
    
    public string apiResponse(string CRN){
        HTTPRequest req = new  HTTPRequest();
        //Set HTTPRequest Method
        req.setMethod('GET');
        //Set HTTPRequest header properties
        req.setHeader('content-type', 'application/json');
        req.setHeader('Host',system.Label.WebServiceHostId);
        req.setHeader('Connection', 'keep-alive');
        String endpoint_URL = System.Label.url_for_paymentschedule_websercice;
        //CRN = '1210055';
        string endpoint = endpoint_URL + CRN;//create dynamic URl on basis of the CRN.as of now use this one but provide provision in ur code for dynamic URL
        req.setEndpoint(endpoint);
        //req.setHeader('Date','1/1/2016'); 

        //Set the HTTPRequest body    
        req.setBody('0body');
        Http http = new Http();
        String responsestr='';
        try {

            //Execute web service call here     
            HTTPResponse res = http.send(req);

            //Helpful debug messages
            System.debug(res.toString());
            System.debug('STATUS:' + res.getStatus());
            System.debug('STATUS_CODE:' + res.getStatusCode());
            if (res.getStatusCode() == 200 && !String.isBlank(res.getBody().trim() )) {
                responsestr = res.getBody().trim(); //to shruti: pass sr to ur code function for parsing 
            } else {
                
                responsestr = NUL;
            }

        } catch (System.CalloutException e) {
            ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR,'Web Service Not Responding:::'+ e));
            System.debug('Exception Occured::::::' + e);
            //Exception handling goes here....
        }
        system.debug('Response :  '+responsestr);
        return responsestr;
    }
    
    //Parsing response got from rest API to extract customer information
    public void parsePaymentScheduleJSON(string CRN){
        totalAmount = 0;
        string paymentresponseStr ='';
        paymentresponseStr = apiResponse(CRN);
        if (! (paymentresponseStr.equalsIgnoreCase(NUL) || String.isBlank(paymentresponseStr) || paymentresponseStr.contains(NO_DATA_FOUND))) {
            // map to store desieralied web response 
            MAP < String, Object > map_json;
             //As response is coming in multiple records these Lists hold separated records  
            List < String > paymentList = new List < String > ();
             //slipt response to identify single record 
            List < String > eachstr = paymentresponseStr.split('}');
            
            for (string str: eachstr) {
                str = str + '}';
                paymentList.add(str);
                 
            } 
            Integer i = 0;
            for (string strJson: paymentList) {
                map_json = new MAP < String, Object > ();
                
                //parse json and add it to map which holds key-field and value-fieldvalue 
                map_json = (MAP < String, Object > ) JSON.deserializeUntyped(strJson);
                PaymentScheduleWrapper PSWrapper = new PaymentScheduleWrapper();
                
                // each recode in store in wrapper List 
                for (String str: map_json.keyset()) {
                    
                    if (str.equalsIgnoreCase(PAYMT_NILESTONE)) {
                            PSWrapper.Payment_Milestone = (string) map_json.get(str);
                    }
                    if (str.equalsIgnoreCase(PRINC_AMT)) {
                            PSWrapper.Principal_Amount = (string) map_json.get(str);
                            totalAmount += decimal.valueOf(PSWrapper.Principal_Amount);
                    }
                   
                    
                }
                 PSWrapper.Sr_no = ++i;
                paymentScheduleWrapperList.add(PSWrapper);
             }
        }
        system.debug('paymentScheduleWrapperList >>> '+paymentScheduleWrapperList);
    }
    
    public void calPercentOfCVAmount(){
        for(PaymentScheduleWrapper obj :paymentScheduleWrapperList) {
            obj.percentOfCV = (decimal.valueOf(obj.Principal_Amount)/totalAmount)*100;
            obj.percentOfCV = obj.percentOfCV.setScale(0, RoundingMode.HALF_UP);
            
        }
        system.debug('paymentScheduleWrapperList>>>>'+paymentScheduleWrapperList);
    }
    
    //wrapper class to hold data from web response
    public class PaymentScheduleWrapper{
        public integer Sr_no{get;set;}
        public string Payment_Milestone {get;set;}
        public string Principal_Amount {get;set;}
        public decimal percentOfCV {get;set;}
           
        public PaymentScheduleWrapper(){
            Payment_Milestone = '';
            Principal_Amount = '';
        }
    } 
        
}