/* 
Description : Controller class for mygain web service 
 @Created by: Shruti Nikam
 @Created Date: 6/4/2015
 
 --------------------------------------------------------------------------------
 | Modified By      | Modified Date       | Version        | Description         |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------

*/
public class RestAPICalloutMygain {

    //List holding mygain details 
    public List < MygainBasic > MygainBasicRecords {get;set;}

    //List holding mygain rebate details 
    public List < MygainComplete > MygaincompleteRecords {get;set;}
    
    public final static String NUL = 'null';
    public final static String NO_DATA_FOUND = 'No data found';
    public final static String INSTRUMENTNUMBER = 'INSTRUMENT_NUMBER';
    public final static String BANKDETAILS = 'BANK_DETAILS';
    public final static String INSTRUMENTDATE = 'INSTRUMENT_DATE';
    public final static String INSTRUMENTRECEIVED_DATE = 'INSTRUMENT_RECEIVED_DATE';
    public final static String INSTRUMENTENTRY_DATE = 'INSTRUMENT_ENTRY_DATE';
    public final static String MYGAIN_AMT_RECEIVED ='MY_GAIN_AMT_RECEIVED';
    public final static String MYGAIN_ALREADY_ADJUSTED = 'MY_GAIN_ALREADY_ADJUSTED';
    public final static String MYGAIN_BALANCE_AS_ON_DATE = 'MY_GAIN_BALANCE_AS_ON_DATE';
    public final static String BENEFITFROM = 'BENEFIT_FROM';
    public final static String BENEFITTILL = 'BENEFIT_TILL';
    public final static String REBATECALCULATED = 'REBATE_CALCULATED';
    public final static String CTEXT = 'TEXT';
    public final static String INTRATE = 'INT_RATE';
    public final static String BENEFITDAYS = 'BENEFIT_DAYS';
    public final static String AMTON_WHICH_DEBATE_CALCULATED = 'AMT_ON_WHICH_DEBATE_CALCULATED';
    public final static String REBATEPOSTED ='REBATE_POSTED';
    public final static String REBATECALCULATED_FROM = 'REBATE_CALCULATED_FROM';
    public final static String REBATECALCULATED_TILL = 'REBATE_CALCULATED_TILL';
    
    // constructor 
    public RestAPICalloutMygain(String CRN) {
        MygaincompleteRecords = new List < Mygaincomplete > ();
        MygainBasicRecords = new List < MygainBasic > ();
        //parseJSON('1401350');
        parseJSON(CRN);
    }


    // method to make web service callout  
    public string myGainAPIResponse(string CRN) {

        HttpRequest req = new HttpRequest();

        //Set HTTPRequest Method
        req.setMethod('GET');

        //Set HTTPRequest header properties
        req.setHeader('content-type', 'application/json');

        // req.setHeader('Content-Length','1024');
        req.setHeader('Host',system.Label.WebServiceHostId);
        req.setHeader('Connection', 'keep-alive'); 
        String endpoint_URL = System.Label.Url_for_mygain_web_services;
        string endpoint = endpoint_URL + CRN;
        req.setEndpoint(endpoint); //create dynamic URl on basis of the CRN.as of now use this one but provide provision in ur code for dynamic URL  
        // req.setHeader('Date','1/1/2016'); 

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
            if (res.getStatusCode() == 200 &&  !String.isBlank(res.getBody().trim() )) {
                responsestr = res.getBody().trim(); //to shruti: pass sr to ur code function for parsing 
            } else {

                responsestr = NUL;
            }

        } catch (System.CalloutException e) {
            ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR,'Web Service Not Responding:::'+ e));
            System.debug('Exception Occured::::::' + e);
            //Exception handling goes here....
        }
     return responsestr.trim();

    }

    // method to parse json response from web services 
    public void parseJSON(String CRN) {
        string responseStr ='';
        responseStr= myGainAPIResponse(CRN);
        //if bad response from server then no need to parse handle the error 
        if (! (responsestr.equalsIgnoreCase(NUL) || String.isBlank(responsestr) || responsestr.contains(NO_DATA_FOUND))) {


            // map that holds parsed data from web service 
            MAP < String, Object > map_json;
            List < String > mygainList = new List < String > ();

            // slip json to differtiate records 
            List < String > eachstr = responseStr.split('},');

            // create json for seperate records 
            for (string str: eachstr) {
                system.debug('Value:<<<<<<<<<<<<<<<<<' + str);
                str = str + '}';
                mygainList.add(str);
            }

            // parse each record 
            List < string > strList = new List < string > ();
            strList = mygainList[0].split('\\[');
            mygainList[0] = strList[1];
            strList = mygainList[mygainList.size() - 1].split(']');
            mygainList[mygainList.size() - 1] = strList[0];
       
            // assign values to wrapper variables 
            for (string strJson: mygainList) {
                map_json = new MAP < String, Object > ();
                map_json = (MAP < String, Object > ) JSON.deserializeUntyped(strJson);
                MygainComplete MygainComplete_obj = new MygainComplete();
                MygainBasic MygainBasic_obj = new MygainBasic();
                for (String str: map_json.keyset()) {
                    if (str.equalsIgnoreCase(INSTRUMENTNUMBER)) {
                        MygainComplete_obj.Instrument_Number = String.valueOf(map_json.get(str));
                    } else if (str.equalsIgnoreCase(BANKDETAILS)) {
                        MygainComplete_obj.Bank_Details = String.valueOf(map_json.get(str));
                    } else if (str.equalsIgnoreCase(INSTRUMENTDATE)) {
                        MygainComplete_obj.Instrument_Date = String.valueOf(map_json.get(str));
                    } else if (str.equalsIgnoreCase(INSTRUMENTRECEIVED_DATE)) {
                        MygainComplete_obj.Instrument_Receive_Date = String.valueOf(map_json.get(str));
                    } else if (str.equalsIgnoreCase(INSTRUMENTENTRY_DATE)) {
                        MygainComplete_obj.Instrument_Posting_Date = String.valueOf(map_json.get(str));
                    } else if (str.equalsIgnoreCase(MYGAIN_AMT_RECEIVED)) {
                        MygainComplete_obj.My_Gain_Amt_Receive = String.valueOf(map_json.get(str));
                    } else if (str.equalsIgnoreCase(MYGAIN_ALREADY_ADJUSTED)) {
                        MygainComplete_obj.My_Gain_Already_Adjusted = String.valueOf(map_json.get(str));
                    } else if (str.equalsIgnoreCase(MYGAIN_BALANCE_AS_ON_DATE)) {
                        MygainComplete_obj.My_Gain_Balance_as_on_Date = String.valueOf(map_json.get(str));
                    } else if (str.equalsIgnoreCase(BENEFITFROM)) {
                        MygainComplete_obj.Benefit_From = String.valueOf(map_json.get(str));
                    } else if (str.equalsIgnoreCase(BENEFITTILL)) {
                        MygainComplete_obj.Benefit_Till = String.valueOf(map_json.get(str));
                    } else if (str.equalsIgnoreCase(REBATECALCULATED)) {
                        MygainComplete_obj.Rebate_Calculated = String.valueOf(map_json.get(str));
                    } else if (str.equalsIgnoreCase(CTEXT)) {
                        MygainComplete_obj.Text = String.valueOf(map_json.get(str));
                    } else if (str.equalsIgnoreCase(INTRATE)) {
                        MygainComplete_obj.Intrest_Rate = String.valueOf(map_json.get(str));
                    } else if (str.equalsIgnoreCase(BENEFITDAYS)) {
                        MygainComplete_obj.Benefit_Days = String.valueOf(map_json.get(str));
                    }

                }

                // identify rabate record 
                if (MygainComplete_obj != null) {
                
                    if (MygainComplete_obj.Instrument_Number != null || 
                        MygainComplete_obj.Bank_Details != null || 
                        MygainComplete_obj.Instrument_Date != null || 
                        MygainComplete_obj.Instrument_Receive_Date != null || 
                        MygainComplete_obj.Instrument_Posting_Date != null || 
                        MygainComplete_obj.My_Gain_Amt_Receive != null || 
                        MygainComplete_obj.My_Gain_Already_Adjusted != null || 
                        MygainComplete_obj.My_Gain_Balance_as_on_Date != null || 
                        MygainComplete_obj.Benefit_From != null || 
                        MygainComplete_obj.Benefit_Till != null || 
                        MygainComplete_obj.Rebate_Calculated != null || 
                        MygainComplete_obj.Text != null || 
                        MygainComplete_obj.Intrest_Rate != null) {

                        MygaincompleteRecords.add(MygainComplete_obj);
                    }
                }


                // assign to wrapper variable 
                for (String str: map_json.keyset()) {
                
                    if (str.equalsIgnoreCase(AMTON_WHICH_DEBATE_CALCULATED)) {
                        MygainBasic_obj.Amt_For_Rebate_Calculated = String.valueOf(map_json.get(str));
                    } else if (str.equalsIgnoreCase(REBATEPOSTED)) {
                        MygainBasic_obj.Rebate_Posted = String.valueOf(map_json.get(str));
                    } else if (str.equalsIgnoreCase(REBATECALCULATED_FROM)) {
                        MygainBasic_obj.Rebate_Calculated_From = String.valueOf(map_json.get(str));
                    } else if (str.equalsIgnoreCase(REBATECALCULATED_TILL)) {
                        MygainBasic_obj.Rebate_Calculated_Till = String.valueOf(map_json.get(str));
                    } else if (str.equalsIgnoreCase(BENEFITDAYS)) {
                        MygainBasic_obj.Benefit_Days = String.valueOf(map_json.get(str));
                    }

                }
                if (MygainBasic_obj != null) {
                    
                    if (MygainBasic_obj.Amt_For_Rebate_Calculated != null ||
                        MygainBasic_obj.Rebate_Posted != null || 
                        MygainBasic_obj.Rebate_Calculated_From != null || 
                        MygainBasic_obj.Rebate_Calculated_Till != null) {

                        MygainBasicRecords.add(MygainBasic_obj);
                    }
                }

            }

        } //end of if condtion 
    }

    //Wrapper class for mygain Basic record list 
    public class MygainBasic {

        public String Amt_For_Rebate_Calculated {get;set;}
        public String Rebate_Posted {get;set;}
        public String Rebate_Calculated_From {get;set;}
        public String Rebate_Calculated_Till {get;set;}
        public String Benefit_Days {get;set;}

        public MygainBasic() {
            Amt_For_Rebate_Calculated = null;
            Rebate_Posted = null;
            Rebate_Calculated_From = null;
            Rebate_Calculated_Till = null;
            Benefit_Days = null;
        }
    }

    // wrapper class for mygain  details 
    public class MygainComplete {

        public String Instrument_Number {get;set;}
        public String Bank_Details {get;set;}
        public String Instrument_Date {get;set;}
        public String Instrument_Receive_Date {get;set;}
        public String Instrument_Posting_Date {get;set;}
        public String My_Gain_Amt_Receive {get;set;}
        public String My_Gain_Already_Adjusted {get;set;}
        public String My_Gain_Balance_as_on_Date {get;set;}
        public String Benefit_From {get;set;}
        public String Benefit_Till {get;set;}
        public String Benefit_Days {get;set;}
        public String Rebate_Calculated {get;set;}
        public String Text {get;set;}
        public String Intrest_Rate {get;set;}

        public MygainComplete() {
            Instrument_Number = null;
            Bank_Details = null;
            Instrument_Date = null;
            Instrument_Receive_Date = null;
            Instrument_Posting_Date = null;
            My_Gain_Amt_Receive = null;
            My_Gain_Already_Adjusted = null;
            My_Gain_Balance_as_on_Date = null;
            Benefit_From = null;
            Rebate_Calculated = null;
            Text = null;
            Intrest_Rate = null;
        }
    }

}