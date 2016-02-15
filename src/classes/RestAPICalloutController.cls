/* Controller class for customer info web service 
 @Created by: Shruti Nikam
 @Created Date: 18/03/2015
 
 --------------------------------------------------------------------------------
 | Modified By      | Modified Date       | Version        | Description         |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------
*/

public class RestAPICalloutController {
    public CustomerInformationWrapper CustomerInformationWrapperobj;
    public final static String REGISTRATIONSTATUS = 'REGISTRATION_STATUS';
    public final static String REGISTRATIONCHALLAN_DATE = 'REGISTRATION_CHALLAN_DATE';
    public final static String STAMPDUTY = 'STAMP_DUTY';
    public final static String REGISTRATIONDATE = 'REGISTRATION_DATE';
    public final static String MYGAIN_CUSTOMER = 'MY_GAIN_CUSTOMER';
    public final static String LEGALNOTICE_SENT_RECEIVED = 'Legal_Notice_Sent_Received';
    public final static String LEGALCASE_ON_GOING = 'Legal_Case_On-going';
    public final static String TIMEFOR_COMMUNICATION = 'Time_of_Communication';
    public final static String COAPPLICANT_2 = 'Co_applicant_2';
    public final static String COAPPLICANT_3 = 'Co_applicant_3';
    public final static String RESIDENTIALSTATUS = 'Residential_Status';
    public final static String NRI = 'NRI';
    public final static String OFFICEADDRESS = 'Office_Address';
    public final static String MANAGEMENTBOOKING = 'Management_Booking';
    public final static String LOANAGAINST_PROPERTY ='Loan_Against_Property';
    public final static String WELCOMEONBOARD = 'WELCOME_ONBOARD';
    public final static String TIMEBOUNDDEMAND_21DAYS = 'TIMEBOUND_DEMAND_21DAYS';
    public final static String TIMEBOUNDDEMAND_42DAYS = 'TIMEBOUND_DEMAND_42DAYS';
    public final static String ALLOTMENTLETTER_DATE ='ALLOTMENT_LETTER_DATE';
    public final static String TIMEBOUNDPAYMENT_RECEIPT_21DAYS = 'TIMEBOUND_PAYMENT_RECEIPT_21DAYS';
    public final static String TIMEBOUNDPAYMENT_RECEIPT_42DAYS = 'TIMEBOUND_PAYMENT_RECEIPT_42DAYS';
    public final static String FUNDINGSTATUS = 'FUNDING_STATUS';
    public final static String LOANSANCTIONED_LETTER_DATE  = 'LOAN_SANCTIONED_LETTER_DATE';
    public final static String DISBURSALAMOUNT = 'DISBURSAL_AMOUNT';
    public final static String NOCROC_DATE = 'NOC_ROC_DATE';
    public final static String OFFERFOR_FITOUT_POSSESSION = 'OFFER_FOR_FITOUT_POSSESSION';
    public final static String POSSESSIONDATE = 'POSSESSION_DATE';
    public final static String KEYHANDOVER_DATE = 'KEY_HANDOVER_DATE';
    public final static String REGISTRATIONCHARGES = 'REGISTRATION_CHARGES';
    public final static String BANKNAME = 'BANK_NAME';
    public final static String CVSANCTIONED = 'CV_SANCTIONED';
    public final static String SANCTIONEDDATE = 'SANCTIONED_DATE';
    public final static String AMOUNTSANCTIONED = 'AMOUNT_SANCTIONED';
    public final static String YES ='Yes';
    public final static String NO ='No';
    public final static String NUL = 'null';
    public final static String NO_DATA_FOUND = 'No data found';
    
    //Constructor of RestAPICalloutController
    public RestAPICalloutController() {
        // initialise wrapper object;
        CustomerInformationWrapperobj = new CustomerInformationWrapper();
    }

    //method who returns RestAPI response
 
    public string APIResponse(string CRN) {

        HttpRequest req = new HttpRequest();

        //Set HTTPRequest Method
        req.setMethod('GET');

        //Set HTTPRequest header properties
        req.setHeader('content-type', 'application/json');

        // req.setHeader('Content-Length','1024');
        req.setHeader('Host',system.Label.WebServiceHostId);
        req.setHeader('Connection', 'keep-alive');
        String endpoint_URL = System.Label.Url_for_customerinfo_web_services;
        string endpoint = endpoint_URL + CRN;
        //create dynamic URl on basis of the CRN.as of now use this one but provide provision in ur code for dynamic URL
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
        return responsestr;
    }

    //Parsing response got from rest API to extract customer information     
    public CustomerInformationWrapper parseCustomerInformationJSON(string CRN) {
        CustomerInformationWrapper CustomerIW_obj = new CustomerInformationWrapper();
        String responsestr = '';

        //responsestr = APIResponse('1210055');
        responsestr = APIResponse(CRN);
        //if bad response from server then no need to parse handle the error 
        if (! (responsestr.equalsIgnoreCase(NUL) || String.isBlank(responsestr) || responsestr.contains(NO_DATA_FOUND))) {

            MAP < String, Object > map_json;


            // map that holds parse records 
            map_json = new MAP < String, Object > ();
            map_json = (MAP < String, Object > ) JSON.deserializeUntyped(responsestr);

            // parse records and assign it to wrapper variables 
            for (String str: map_json.keyset()) {
                if (str.equalsIgnoreCase(REGISTRATIONSTATUS)) {
                    CustomerIW_obj.registration_status = (string) map_json.get(str);
                } else if (str.equalsIgnoreCase(REGISTRATIONCHALLAN_DATE)) {
                    CustomerIW_obj.registration_challan_date = (string) map_json.get(str);
                    CustomerIW_obj.registration_challan_date = getdate(CustomerIW_obj.registration_challan_date);
                } else if (str.equalsIgnoreCase(STAMPDUTY)) {
                    CustomerIW_obj.stamp_duty = (string) map_json.get(str);
                } else if (str.equalsIgnoreCase(REGISTRATIONDATE)) {
                    CustomerIW_obj.registration_date = (string) map_json.get(str);
                    CustomerIW_obj.registration_date = getdate(CustomerIW_obj.registration_date);
                }
                //set boolena value according to data from web service 
                else if (str.equalsIgnoreCase(MYGAIN_CUSTOMER)) {
                    if (((string) map_json.get(str)).equalsIgnoreCase(YES)) {
                        CustomerIW_obj.my_gain_customer = true;
                    } else {
                        CustomerIW_obj.my_gain_customer = false;
                    }
                } else if (str.equalsIgnoreCase(LEGALNOTICE_SENT_RECEIVED)) {
                    CustomerIW_obj.legal_notice_sent_received = (string) map_json.get(str);
                } else if (str.equalsIgnoreCase(LEGALCASE_ON_GOING)) {
                    CustomerIW_obj.legal_case_on_going = (string) map_json.get(str);
                } else if (str.equalsIgnoreCase(TIMEFOR_COMMUNICATION)) {
                    CustomerIW_obj.time_of_communication = (string) map_json.get(str);
                } else if (str.equalsIgnoreCase(COAPPLICANT_2)) {
                    CustomerIW_obj.co_applicant_2 = (string) map_json.get(str);
                } else if (str.equalsIgnoreCase(COAPPLICANT_3)) {
                    CustomerIW_obj.co_applicant_3 = (string) map_json.get(str);
                }

                //set boolena value according to data from web service 
                else if (str.equalsIgnoreCase(RESIDENTIALSTATUS)) {
                    CustomerIW_obj.residential_status = (string) map_json.get(str);
                    if (CustomerIW_obj.residential_status.equalsIgnoreCase(NRI)) {
                        CustomerIW_obj.isnri = YES;
                    } else {
                        CustomerIW_obj.isnri = NO;
                    }
                } else if (str.equalsIgnoreCase(OFFICEADDRESS)) {
                    CustomerIW_obj.office_address = (string) map_json.get(str);
                }

                //set boolena value according to data from web service 
                else if (str.equalsIgnoreCase(MANAGEMENTBOOKING)) {
                    if (((string) map_json.get(str)).equalsIgnoreCase(YES)) {
                        CustomerIW_obj.management_booking = true;
                    } else {
                        CustomerIW_obj.management_booking = false;
                    }
                }

                //set boolena value according to data from web service 
                else if (str.equalsIgnoreCase(LOANAGAINST_PROPERTY)) {
                    if (((string) map_json.get(str)).equalsIgnoreCase(YES)) {
                        CustomerIW_obj.loan_against_property = true;
                    } else {
                        CustomerIW_obj.loan_against_property = false;
                    }
                } else if (str.equalsIgnoreCase(WELCOMEONBOARD)) {
                    CustomerIW_obj.welcome_onboard = 
                            (string) map_json.get(str);
                    CustomerIW_obj.welcome_onboard = 
                            getdate(CustomerIW_obj.welcome_onboard);
                } else if (str.equalsIgnoreCase(TIMEBOUNDDEMAND_21DAYS)) {
                    CustomerIW_obj.timebound_demand_21days = 
                            (string) map_json.get(str);
                    CustomerIW_obj.timebound_demand_21days = 
                            getdate(CustomerIW_obj.timebound_demand_21days);
                } else if (str.equalsIgnoreCase(ALLOTMENTLETTER_DATE)) {
                    CustomerIW_obj.allotment_letter = 
                            (string) map_json.get(str);
                    CustomerIW_obj.allotment_letter = 
                            getdate(CustomerIW_obj.allotment_letter);
                } else if (str.equalsIgnoreCase(TIMEBOUNDPAYMENT_RECEIPT_21DAYS)) {
                    CustomerIW_obj.timebound_payment_receipt_21days = 
                            (string) map_json.get(str);
                    CustomerIW_obj.timebound_payment_receipt_21days = 
                            getdate(CustomerIW_obj.timebound_payment_receipt_21days);
                } else if (str.equalsIgnoreCase(TIMEBOUNDDEMAND_42DAYS)) {
                    CustomerIW_obj.timebound_demand_42days = 
                            (string) map_json.get(str);
                    CustomerIW_obj.timebound_demand_42days = 
                            getdate(CustomerIW_obj.timebound_demand_42days);
                } else if (str.equalsIgnoreCase(TIMEBOUNDPAYMENT_RECEIPT_42DAYS)) {
                    CustomerIW_obj.timebound_payment_receipt_42days = 
                            (string) map_json.get(str);
                    CustomerIW_obj.timebound_payment_receipt_42days = 
                            getdate(CustomerIW_obj.timebound_payment_receipt_42days);
                } else if (str == FUNDINGSTATUS) {
                    CustomerIW_obj.funding_status = 
                            (string) map_json.get(str);
                } else if (str.equalsIgnoreCase(LOANSANCTIONED_LETTER_DATE)) {
                    CustomerIW_obj.loan_sanctioned_letter_date = 
                            (string) map_json.get(str);
                    CustomerIW_obj.loan_sanctioned_letter_date = 
                            getdate(CustomerIW_obj.loan_sanctioned_letter_date);
                } else if (str.equalsIgnoreCase(DISBURSALAMOUNT)) {
                    CustomerIW_obj.disbursal_amount = (string) map_json.get(str);
                } else if (str.equalsIgnoreCase(NOCROC_DATE)) {
                    CustomerIW_obj.noc_roc_date = 
                            (string) map_json.get(str);
                    CustomerIW_obj.noc_roc_date = 
                            getdate(CustomerIW_obj.noc_roc_date);
                } else if (str.equalsIgnoreCase(OFFERFOR_FITOUT_POSSESSION)) {
                    CustomerIW_obj.offer_for_fitout_possession = 
                            (string) map_json.get(str);
                    CustomerIW_obj.offer_for_fitout_possession = 
                            getdate(CustomerIW_obj.offer_for_fitout_possession);
                } else if (str.equalsIgnoreCase(POSSESSIONDATE)) {
                    CustomerIW_obj.possession_date = 
                            (string) map_json.get(str);
                    CustomerIW_obj.possession_date = 
                            getdate(CustomerIW_obj.possession_date);
                } else if (str.equalsIgnoreCase(KEYHANDOVER_DATE)) {
                    CustomerIW_obj.key_handover_date = 
                            (string) map_json.get(str);
                    CustomerIW_obj.key_handover_date = 
                            getdate(CustomerIW_obj.key_handover_date);
                } else if (str.equalsIgnoreCase(REGISTRATIONCHARGES)) {
                    CustomerIW_obj.registration_charges = 
                            (string) map_json.get(str);
                } else if (str.equalsIgnoreCase(BANKNAME)) {
                    CustomerIW_obj.bank_name = (string) map_json.get(str);
                } else if (str.equalsIgnoreCase(CVSANCTIONED)) {
                    CustomerIW_obj.cv_sanctioned = (string) map_json.get(str);
                } else if (str.equalsIgnoreCase(SANCTIONEDDATE)) {
                    CustomerIW_obj.sanctioned_date = (string) map_json.get(str);
                    CustomerIW_obj.sanctioned_date = getdate(CustomerIW_obj.sanctioned_date);
                } else if (str.equalsIgnoreCase(AMOUNTSANCTIONED)) {
                    CustomerIW_obj.amount_sanctioned = (string) map_json.get(str);
                }

            }

             //set boolena value according to data from web service 
            if (CustomerIW_obj.legal_notice_sent_received.equalsIgnoreCase(YES) 
                || CustomerIW_obj.legal_case_on_going.equalsIgnoreCase(YES)) {
                CustomerIW_obj.legal_alert = true;
            } else {
                CustomerIW_obj.legal_alert = false;
            }
        } // end of if condition)
        return CustomerIW_obj;
    }

    // method to convert datatime to date   
    public string getdate(string strdate) {
        if(!String.isBlank(strdate)) {
            Datetime dt = datetime.valueOf(strdate);
            Date myDate = dt.date();
        
            return String.valueOf(myDate);
        }
        else {
            return strdate;
        }
    }

//wrapper class to hold data from web response
    public class CustomerInformationWrapper {
        public string registration_status {get;set;}
        public string registration_challan_date {get;set;}
        public string stamp_duty {get;set;}
        public string registration_date {get;set;}
        public boolean my_gain_customer {get;set;}
        public string legal_notice_sent_received;
        public string legal_case_on_going;
        public string time_of_communication {get;set;}
        public string co_applicant_2 {get;set;}
        public string co_applicant_3 {get;set;}
        public string residential_status {get;set;}
        public string office_address {get;set;}
        public boolean management_booking {get;set;}
        public boolean loan_against_property {get;set;}
        public boolean legal_alert {get;set;}
        public string welcome_onboard {get;set;}
        public string timebound_demand_21days {get;set;}
        public string timebound_payment_receipt_21days {get;set;}
        public string allotment_letter {get;set;}
        public string timebound_demand_42days {get;set;}
        public string timebound_payment_receipt_42days {get;set;}
        public string funding_status {get;set;}
        public string loan_sanctioned_letter_date {get;set;}
        public string disbursal_amount {get;set;}
        public string noc_roc_date {get;set;}
        public string offer_for_fitout_possession {get;set;}
        public string possession_date {get;set;}
        public string key_handover_date {get;set;}
        public string registration_charges {get;set;}
        public string isnri {get;set;}
        public String bank_name {get;set;}
        public string cv_sanctioned {get;set;}
        public String sanctioned_date {get;set;}
        public string amount_sanctioned {get;set;}
       
        // initialising values to null in constructor       
        public CustomerInformationWrapper() {

            registration_status = null;
            registration_challan_date = null;
            stamp_duty = null;
            registration_date = null;
            my_gain_customer = false;
            legal_notice_sent_received = 'no';
            legal_case_on_going = 'no';
            time_of_communication = null;
            co_applicant_2 = null;
            co_applicant_3 = null;
            residential_status = null;
            office_address = null;
            management_booking = false;
            loan_against_property = false;
            legal_alert = false;
            welcome_onboard = null;
            timebound_demand_21days = null;
            timebound_payment_receipt_21days = null;
            allotment_letter = null;
            timebound_demand_42days = null;
            timebound_payment_receipt_42days = null;
            funding_status = null;
            loan_sanctioned_letter_date = null;
            disbursal_amount = null;
            noc_roc_date = null;
            offer_for_fitout_possession = null;
            possession_date = null;
            key_handover_date = null;
            registration_charges = null;
            bank_name = null;
            cv_sanctioned = null;
            sanctioned_date = null;
            amount_sanctioned = null;
        }
    }
}