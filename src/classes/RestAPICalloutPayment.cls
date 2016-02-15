/* 
Description : Controller class for payments web service 
 @Created by: Shruti Nikam
 @Created Date: 2/4/2015
 
 --------------------------------------------------------------------------------
 | Modified By      | Modified Date       | Version        | Description         |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------

*/

public class RestAPICalloutPayment {
    
    //Uniform List which holds all payments records from the web service   
    public List < paymentInfo > paymentInfoList {get;set;}
    //List which holds all PaymentReceived records from the web service 
    public List < PaymentReceived > PaymentReceivedList {get;set;}
    //List which holds all PaymentUpcoming records from the web service
    public List < PaymentUpcoming > PaymentUpcomingList {get;set;}
    //List which holds all PaymentSchedule records from the web service
    public List < PaymentSchedule > PaymentScheduleList {get;set;}
    
    //List which holds all AccountLedger records from the web service
    public List < AccountLedger > AccountLedgerList {get;set;}
    //Holds total received payments 
    public decimal TotalPaymentR {get;set;}
    
    //Holds total Due payments
    public decimal TotalDue {get;set;}
    
    //Holds total received payments percentage 
    public decimal received_percent {get;set;}
    
    //Holds total due payments percentage
    public decimal due_percent{get;set;}
    
    public String Milestones_Paid_color {get; set;}
    public String Milestones_Outstanding_color {get; set;}
    public String Milestones_Upcoming_color {get; set;}
    public List<Booking_Details__c> bookingList;
    
    public final static String NUL = 'null';
    public final static String NO_DATA_FOUND = 'No data found';
    public final static String C_CRN = 'crn'; 
    public final static String PAYMENTMILESTONE = 'Payment MileStone';
    public final static String BILLDATE = 'Bill Date';
    public final static String DUEDATE = 'Due Date';
    public final static String PRINC_AMT_DUE = 'Principal Amount Due';
    public final static String PRINC_AMT_RECVD = 'Principal Amount Received';
    public final static String PRINC_OUTSTANDING = 'Principal Outstanding';
    public final static String SER_TAX_DUE = 'Service Tax Due';
    public final static String SER_TAX_RECVD ='Service Tax Received';
    public final static String SER_TAX_OUTSTANDING = 'Service Tax Outstanding';
    public final static String INT_DUE_ASONDATE = 'Interest Due (Virtual - Charged/As ondate)';
    public final static String TOT_DUE = 'Total Due';
    public final static String PAYMENT_RECVD = 'Payments Received';
    public final static String BAL_DUE = 'Balance Due';
    public final static String INST_RECVD_DATE = 'Inst Rec Date';
    public final static String MODE_PAYMENT = 'Mode Of Payment';
    public final static String BANK_DEL = 'Bank Details';
    public final static String STAT = 'Status';
    public final static String REF = 'Reference';
    public final static String INDIV_RECEIPT_NO = 'Individual Receipt No';
    public final static String INS_DATE = 'Inst Date';
    public final static String ONE_PER_MVAT = '1% MVAT Recovery';
    public final static String JAN = 'Jan';
    public final static String FEB = 'Feb';
    public final static String MAR = 'Mar';
    public final static String APR = 'Apr';
    public final static String MAY = 'May';
    public final static String JUN = 'Jun';
    public final static String JUL = 'Jul';
    public final static String AUG = 'Aug';
    public final static String SEP = 'Sep';
    public final static String OCT = 'Oct';
    public final static String NOV = 'Nov';
    public final static String DEC = 'Dec';
    public final static String ONE = '-01-';
    public final static String TWO = '-02-';
    public final static String THREE = '-03-';
    public final static String FOUR = '-04-';
    public final static String FIVE = '-05-';
    public final static String SIX = '-06-';
    public final static String SEVEN = '-07-';
    public final static String EIGHT = '-08-';
    public final static String NINE = '-09-';
    public final static String TEN = '-10-';
    public final static String ELEVEN = '-11-';
    public final static String TWELVE = '-12-';
    
    public final static String PaymentRecievedBeforeDue = 'PaymentRecievedBeforeDue';
    public final static String PaymentRecievedAfterDue = 'PaymentRecievedAfterDue';
    public final static String UpcomingPayments0daysLeft = 'UpcomingPayments0daysLeft';
    public final static String UpcomingPayments3daysLeft = 'UpcomingPayments3daysLeft';
    public final static String UpcomingPayments4daysLeft = 'UpcomingPayments4daysLeft';
    
    
    public PaymentsColorCodes__c PaymentRecievedBeforeDue_obj = PaymentsColorCodes__c.getvalues(PaymentRecievedBeforeDue);
    public PaymentsColorCodes__c PaymentRecievedAfterDue_obj = PaymentsColorCodes__c.getvalues(PaymentRecievedAfterDue);
    public PaymentsColorCodes__c UpcomingPayments0daysLeft_obj = PaymentsColorCodes__c.getvalues(UpcomingPayments0daysLeft);
    public PaymentsColorCodes__c UpcomingPayments3daysLeft_obj = PaymentsColorCodes__c.getvalues(UpcomingPayments3daysLeft);
    public PaymentsColorCodes__c UpcomingPayments4daysLeft_obj = PaymentsColorCodes__c.getvalues(UpcomingPayments4daysLeft);
    
    public final static String Milestones_Paid = 'Milestones_Paid';
    public final static String Milestones_Outstanding = 'Milestones_Outstanding';
    public final static String Milestones_Upcoming = 'Milestones_Upcoming';
    
    public Payments_backgroundColorCode__c Milestones_Paid_obj =Payments_backgroundColorCode__c.getvalues(Milestones_Paid);
    public Payments_backgroundColorCode__c Milestones_Outstanding_obj =Payments_backgroundColorCode__c.getvalues(Milestones_Outstanding);
    public Payments_backgroundColorCode__c Milestones_Upcoming_obj =Payments_backgroundColorCode__c.getvalues(Milestones_Upcoming);
    
   
    public RestAPICalloutPayment(String CRN) {
        // lists initialisaton 
        paymentInfoList = new List < paymentInfo > ();
        PaymentReceivedList = new List < PaymentReceived > ();
        PaymentUpcomingList = new List < PaymentUpcoming > ();
        PaymentScheduleList = new List < PaymentSchedule > ();
        AccountLedgerList = new List < AccountLedger > ();
        paymentInfo obj = new paymentInfo();
        
        //parse the web service response and assign it to uniform payment List
        //parseJSON('1400780');
        parseJSON(CRN);
        
        //divide List into upcoming, o/s and received list according to different conditions  
        assignLists(CRN);
        
        //set color code to identify payments stage 
        setcolorcode();
        
        //calculate total for payment received till date and due payment   
        calculateTotals();
        
        //sort list to display latest record first 
        sortpaymentsReceived();
        sortpaymentsUpcoming();
        
        //create account ledger List according to the conditions 
        addaccountLedger();
    }



    public string PaymentAPIResponse(string CRN) {

        HttpRequest req = new HttpRequest();

        //Set HTTPRequest Method
        req.setMethod('GET');

        //Set HTTPRequest header properties
        req.setHeader('content-type', 'application/json');

        // req.setHeader('Content-Length','1024');
        req.setHeader('Host',system.Label.WebServiceHostId);
        req.setHeader('Connection', 'keep-alive');
        
        String endpoint_url = System.Label.Url_for_payment_web_services;
        string endpoint = endpoint_url + CRN;
        /*
        create dynamic URl on basis of the CRN.
        As of now use this one but provide provision in ur code for dynamic URL  
        */
        req.setEndpoint(endpoint); 
        req.setHeader('Date', '1/1/2016');

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
            if (res.getStatusCode() == 200 && 
                !String.isBlank(res.getBody().trim() )) {
                
                //to shruti: pass sr to ur code function for parsing 
                responsestr = res.getBody().trim(); 
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

    //parsing JSON
    public void parseJSON(String CRN) {
        string paymentresponseStr ='';
        paymentresponseStr = PaymentAPIResponse(CRN);
        //if bad response from server then no need to parse handle the error 
        if (!(paymentresponseStr.equalsIgnoreCase(NUL) || String.isBlank(paymentresponseStr) || paymentresponseStr.contains(NO_DATA_FOUND) )) {
            
            // map to store desieralied wed reponse 
            MAP < String, Object > map_json;
            
            //As response is coming in multiple records these Lists hold separated records  
            List < String > paymentList = new List < String > ();
            
            //slipt response to identify single record 
            List < String > eachstr = paymentresponseStr.split('}');
            
            // create seperate JSON for each record 
            for (string str: eachstr) {
                str = str + '}';
                paymentList.add(str);
            }
            
            // parse each JSON and assign values tp respection variabels of uniform Payments wrapper 
           
            for (string strJson: paymentList) {
                map_json = new MAP < String, Object > ();
                
                //parse json and add it to map which holds key-field and value-fieldvalue 
                map_json = (MAP < String, Object > ) JSON.deserializeUntyped(strJson);
                paymentInfo paymentInfo_Obj = new paymentInfo();
                 
                // each recode in store in wrapper List 
                for (String str: map_json.keyset()) {

                    if (str.equalsIgnoreCase(C_CRN)) {
                        paymentInfo_Obj.CRN = (string) map_json.get(str);
                    } else if (str.equalsIgnoreCase(PAYMENTMILESTONE)) {
                        paymentInfo_Obj.payment_mileStone = (string) map_json.get(str);
                    } else if (str.equalsIgnoreCase(BILLDATE)) {
                        paymentInfo_Obj.bill_date = (String) map_json.get(str);
                    } else if (str.equalsIgnoreCase(DUEDATE)) {
                        paymentInfo_Obj.due_date = (String) map_json.get(str);
                    } else if (str.equalsIgnoreCase(PRINC_AMT_DUE)) {
                        paymentInfo_Obj.principal_amount_due = (String) map_json.get(str);
                    } else if (str.equalsIgnoreCase(PRINC_AMT_RECVD)) {
                        paymentInfo_Obj.principal_amount_received = (String) map_json.get(str);
                    } else if (str.equalsIgnoreCase(PRINC_OUTSTANDING)) {
                        paymentInfo_Obj.principal_outstanding = (String) map_json.get(str);
                    } else if (str.equalsIgnoreCase(SER_TAX_DUE)) {
                        paymentInfo_Obj.service_tax_due = (String) map_json.get(str);
                    } else if (str.equalsIgnoreCase(SER_TAX_RECVD)) {
                        paymentInfo_Obj.service_tax_received = (String) map_json.get(str);
                    } else if (str.equalsIgnoreCase(SER_TAX_OUTSTANDING)) {
                        paymentInfo_Obj.service_tax_outstanding = (String) map_json.get(str);
                    } else if (str.equalsIgnoreCase(INT_DUE_ASONDATE)) {
                        paymentInfo_Obj.interest_due_as_ondate = (String) map_json.get(str);
                    } else if (str.equalsIgnoreCase(TOT_DUE)) {
                        paymentInfo_Obj.total_due = (String) map_json.get(str);
                    } else if (str.equalsIgnoreCase(PAYMENT_RECVD)) {
                        paymentInfo_Obj.payments_received = (String) map_json.get(str);
                    } else if (str.equalsIgnoreCase(BAL_DUE)) {
                        paymentInfo_Obj.balance_due = (String) map_json.get(str);
                    } else if (str.equalsIgnoreCase(INST_RECVD_DATE)) {
                        paymentInfo_Obj.received_date = (String) map_json.get(str);
                    } else if (str.equalsIgnoreCase(MODE_PAYMENT)) {
                        paymentInfo_Obj.mode_of_payment = (string) map_json.get(str);
                    } else if (str.equalsIgnoreCase(BANK_DEL)) {
                        paymentInfo_Obj.bank_details = (string) map_json.get(str);
                    } else if (str.equalsIgnoreCase(STAT)) {
                        paymentInfo_Obj.status = (string) map_json.get(str);
                    } else if (str.equalsIgnoreCase(REF)) {
                        paymentInfo_Obj.reference = (string) map_json.get(str);
                    } else if (str.equalsIgnoreCase(INDIV_RECEIPT_NO)) {
                        paymentInfo_Obj.receipt_no = (string) map_json.get(str);
                    } else if (str.equalsIgnoreCase(INS_DATE)) {
                        paymentInfo_Obj.Instrument_Date = (string) map_json.get(str);
                    }
                }
                paymentInfoList.add(paymentInfo_Obj);
            }
        } //end of if condtion 
    }


    // as all data is coming as string this method is to convter string to desire date formate  
    public Date getdate(String mydate) {

        String s = mydate.normalizeSpace();
        s = s.trim();
        List < string > datesplit = new List < string > ();
        datesplit = s.split(' ');
        if (datesplit.size() == 3) {
            if (datesplit[1].equalsIgnoreCase(JAN)) {
                datesplit[1] = ONE;
            } else if (datesplit[1].equalsIgnoreCase(FEB)) {
                datesplit[1] = TWO;
            } else if (datesplit[1].equalsIgnoreCase(MAR)) {
                datesplit[1] = THREE;
            } else if (datesplit[1].equalsIgnoreCase(APR)) {
                datesplit[1] = FOUR;
            } else if (datesplit[1].equalsIgnoreCase(MAY)) {
                datesplit[1] = FIVE;
            } else if (datesplit[1].equalsIgnoreCase(JUN)) {
                datesplit[1] = SIX;
            } else if (datesplit[1].equalsIgnoreCase(JUL)) {
                datesplit[1] = SEVEN;
            } else if (datesplit[1].equalsIgnoreCase(AUG)) {
                datesplit[1] = EIGHT;
            } else if (datesplit[1].equalsIgnoreCase(SEP)) {
                datesplit[1] = NINE;
            } else if (datesplit[1].equalsIgnoreCase(OCT)) {
                datesplit[1] = TEN;
            } else if (datesplit[1].equalsIgnoreCase(NOV)) {
                datesplit[1] = ELEVEN;
            } else if (datesplit[1].equalsIgnoreCase(DEC)) {
                datesplit[1] = TWELVE;
            }
            s = datesplit[2] + datesplit[1] + datesplit[0];
            return Date.valueOf(s);
        } else {

            return Date.valueOf(mydate);
        }

    }


    //Sliping uniform list to payment received upcoming and scheduel 
    public void assignLists(String CRN) {
        /* 
         intilization of payements recieved upcoming and schedule list intialization
         declearing objects for payment received , upcoming and schedude
         if the list contains any data menas size grater than zero then excute further otherit prevents exception
       */
        bookingList = [select Consideration_Value__c from Booking_Details__c where CRN__c = : CRN limit 1];
        //storing color code to table background in List 
        if(Milestones_Outstanding_obj!=null && String.isNotBlank(Milestones_Outstanding_obj.ColorCode__c)&&
            Milestones_Paid_obj!=null && String.isNotBlank(Milestones_Paid_obj.ColorCode__c) &&
            Milestones_Upcoming_obj!=null && String.isNotBlank(Milestones_Upcoming_obj.ColorCode__c)) {
         
                                Milestones_Outstanding_color = Milestones_Outstanding_obj.ColorCode__c;
                                Milestones_Paid_color =Milestones_Paid_obj.ColorCode__c;
                                Milestones_Upcoming_color = Milestones_Upcoming_obj.ColorCode__c;
                            }
        
        //null check for List before use 
        if (paymentInfoList.size() > 0) {

            PaymentReceived PaymentR_obj;
            PaymentUpcoming PaymentU_obj;
            PaymentSchedule PaymentS_obj;
     
            for (paymentInfo paymentobj: paymentInfoList) {
                if (!String.isBlank(paymentobj.payment_mileStone)) {
                    PaymentR_obj = new PaymentReceived();
                    PaymentU_obj = new PaymentUpcoming();
                    PaymentS_obj = new PaymentSchedule();
                    
                    // condition to identify payments received records 
                    if ((!String.isBlank(paymentobj.bill_date))&& Decimal.valueOf(paymentobj.balance_due) == 0) {
                        
                        // adding bg_color to paymentinfo List 
                        if(Milestones_Paid_obj!=null && String.isNotBlank(Milestones_Paid_obj.ColorCode__c)) {
                            Paymentobj.bg_color=Milestones_Paid_obj.ColorCode__c;
                            Milestones_Paid_color =Milestones_Paid_obj.ColorCode__c;
                        }
                        Paymentobj.text_color = setcolorcodePaymentReceived(Paymentobj.due_date,Paymentobj.received_date);
                       
                        PaymentR_obj.payment_mileStone = Paymentobj.payment_mileStone;
                        PaymentR_obj.bill_date = Paymentobj.bill_date;
                        PaymentR_obj.due_date = Paymentobj.due_date;
                        PaymentR_obj.principal_amount_due = Paymentobj.principal_amount_due;
                        PaymentR_obj.principal_amount_received = Paymentobj.principal_amount_received;
                        PaymentR_obj.principal_outstanding = Paymentobj.principal_outstanding;
                        PaymentR_obj.service_tax_due = Paymentobj.service_tax_due;
                        PaymentR_obj.service_tax_received = Paymentobj.service_tax_received;
                        PaymentR_obj.service_tax_outstanding = Paymentobj.service_tax_outstanding;
                        PaymentR_obj.interest_due_as_ondate = Paymentobj.interest_due_as_ondate;
                        PaymentR_obj.total_due = Paymentobj.total_due;
                        PaymentR_obj.payments_received = Paymentobj.payments_received;
                        PaymentR_obj.balance_due = Paymentobj.balance_due;
                        PaymentR_obj.received_date = Paymentobj.received_date;
                        PaymentR_obj.mode_of_payment = Paymentobj.mode_of_payment;
                        PaymentR_obj.bank_details = Paymentobj.bank_details;
                        PaymentR_obj.status = Paymentobj.status;
                        PaymentR_obj.reference = Paymentobj.reference;
                        PaymentReceivedList.add(PaymentR_obj);
                        
                        
                        // condition to identify Payments schedule records 
                        if (!Paymentobj.payment_mileStone.equalsIgnoreCase(ONE_PER_MVAT)) {
                            PaymentS_obj.percent_cv = 0.00;
                            PaymentS_obj.payment_mileStone = Paymentobj.payment_mileStone;
                            PaymentS_obj.principal_amount_due = Paymentobj.principal_amount_due;
                            PaymentS_obj.service_tax_due = Paymentobj.service_tax_due;
                            PaymentS_obj.total_due = Paymentobj.total_due;
                            if(bookingList.size()>0 && 
                               !String.isBlank(Paymentobj.principal_amount_due) && 
                                bookingList[0].Consideration_Value__c!=null && 
                                bookingList[0].Consideration_Value__c!= 0) {
                                
                                PaymentS_obj.percent_cv=(decimal.valueOf(Paymentobj.principal_amount_due)/bookingList[0].Consideration_Value__c)*100;
                                PaymentS_obj.percent_cv=PaymentS_obj.percent_cv.setscale(2);
                            }
                            PaymentScheduleList.add(PaymentS_obj);
                        }

                    }
                    // condition to identify Upcoming payments records 
                    else {
                        
                        //logic to add color code for Milestone outstanding and Milestone upcoming
                        //condition for Milestone outstanding background color
                        if((!String.isBlank(paymentobj.bill_date))&& Decimal.valueOf(paymentobj.balance_due) != 0){
                            // adding bg_color to paymentinfo List 
                            if(Milestones_Outstanding_obj!=null && String.isNotBlank(Milestones_Outstanding_obj.ColorCode__c)) {
                                Paymentobj.bg_color=Milestones_Outstanding_obj.ColorCode__c;
                                Milestones_Outstanding_color = Milestones_Outstanding_obj.ColorCode__c;
                            }
                            Paymentobj.text_color = setcolorcodePaymentoutstanding(Paymentobj.due_date);
                        }
                        
                        //condition for Milestone upcoming background color
                        else if((String.isBlank(paymentobj.bill_date))&& Decimal.valueOf(paymentobj.balance_due) != 0){
                            // adding bg_color to paymentinfo List
                            if(Milestones_Upcoming_obj!=null && String.isNotBlank(Milestones_Upcoming_obj.ColorCode__c)) {
                                Paymentobj.bg_color = Milestones_Upcoming_obj.ColorCode__c;
                                Milestones_Upcoming_color = Milestones_Upcoming_obj.ColorCode__c;
                            }
                        }
     
                        // system.debug('PaymentS_obj<<<<<<<else<<<<<<<<<<'+PaymentS_obj);
                        if((!String.isBlank(paymentobj.bill_date))&& Decimal.valueOf(paymentobj.balance_due) != 0){
                            PaymentU_obj.payment_mileStone = Paymentobj.payment_mileStone;
                            PaymentU_obj.bill_date = Paymentobj.bill_date;
                            PaymentU_obj.due_date = Paymentobj.due_date;
                            PaymentU_obj.principal_amount_due = Paymentobj.principal_amount_due;
                            PaymentU_obj.principal_amount_received = Paymentobj.principal_amount_received;
                            PaymentU_obj.principal_outstanding = Paymentobj.principal_outstanding;
                            PaymentU_obj.service_tax_due = Paymentobj.service_tax_due;
                            PaymentU_obj.service_tax_received = Paymentobj.service_tax_received;
                            PaymentU_obj.service_tax_outstanding = Paymentobj.service_tax_outstanding;
                            PaymentU_obj.interest_due_as_ondate = Paymentobj.interest_due_as_ondate;
                            PaymentU_obj.total_due = Paymentobj.total_due;
                            PaymentU_obj.payments_received = Paymentobj.payments_received;
                            PaymentU_obj.balance_due = Paymentobj.balance_due;
                            PaymentU_obj.received_date = Paymentobj.received_date;
                            PaymentU_obj.mode_of_payment = Paymentobj.mode_of_payment;
                            PaymentU_obj.bank_details = Paymentobj.bank_details;
                            PaymentU_obj.status = Paymentobj.status;
                            PaymentU_obj.reference = Paymentobj.reference;
                           
                            // condition to identify payments schedule records 
                            PaymentUpcomingList.add(PaymentU_obj);
                        }
                        if (!Paymentobj.payment_mileStone.equalsIgnoreCase(ONE_PER_MVAT)) {
                            PaymentS_obj.percent_cv = 0.00;
                            PaymentS_obj.payment_mileStone = Paymentobj.payment_mileStone;
                            PaymentS_obj.principal_amount_due = Paymentobj.principal_amount_due;
                            PaymentS_obj.service_tax_due = Paymentobj.service_tax_due;
                            PaymentS_obj.total_due = Paymentobj.total_due;
                            
                            if(bookingList.size()>0 && 
                              !String.isBlank(Paymentobj.principal_amount_due) &&
                              bookingList[0].Consideration_Value__c!=null &&
                              bookingList[0].Consideration_Value__c!= 0) {
                                
                                PaymentS_obj.percent_cv=(decimal.valueOf(Paymentobj.principal_amount_due)/bookingList[0].Consideration_Value__c)*100;
                                PaymentS_obj.percent_cv=PaymentS_obj.percent_cv.setscale(2);
                            }
                            PaymentScheduleList.add(PaymentS_obj);
                        }
                    }
                }
            }

        } //if condition close End
        
    }
    
    // method to set text color for payments received in uniform payments list it self 
    public String setcolorcodePaymentReceived(String due_date, String received_date){
        String text_color;
        if (!String.isBlank(due_date) && !String.isBlank(received_date)) {
                    
           if( PaymentRecievedBeforeDue_obj !=null && PaymentRecievedBeforeDue_obj.No_of_days__c!=null &&
                        !String.isBlank(PaymentRecievedBeforeDue_obj.Color_Code__c) &&
                         PaymentRecievedAfterDue_obj!=null && PaymentRecievedAfterDue_obj.No_of_days__c !=null &&
                          !String.isBlank(PaymentRecievedAfterDue_obj.Color_Code__c)){
                 if (getdate(due_date).daysBetween(getdate(received_date)) >= PaymentRecievedBeforeDue_obj.No_of_days__c) {
                            text_color = PaymentRecievedBeforeDue_obj.Color_Code__c;  
                 } else if (getdate(due_date).daysBetween(getdate(received_date)) < PaymentRecievedAfterDue_obj.No_of_days__c) {
                            text_color = PaymentRecievedAfterDue_obj.Color_Code__c;
                 }
           }
        } else {

            text_color = 'black';
        }
                
                return text_color;
    }
    
    
    // method to set text color for payments outstanding in uniform payments list it self 
    public String setcolorcodePaymentoutstanding(String due_date) {
        String text_color;
        if (!String.isBlank(due_date)) {
            if(UpcomingPayments0daysLeft_obj != null && 
               UpcomingPayments0daysLeft_obj.No_of_days__c!=null && 
              (!String.isBlank(UpcomingPayments0daysLeft_obj.Color_Code__c)) &&
               UpcomingPayments3daysLeft_obj != null && 
               UpcomingPayments3daysLeft_obj.No_of_days__c!=null && 
              (!String.isBlank(UpcomingPayments3daysLeft_obj.Color_Code__c)) &&
                UpcomingPayments4daysLeft_obj !=null && 
                UpcomingPayments4daysLeft_obj.No_of_days__c!=null &&
              (!String.isBlank(UpcomingPayments4daysLeft_obj.Color_Code__c)) ){
                    
                        if (getdate(due_date).daysBetween(Date.Today()) > 
                            UpcomingPayments0daysLeft_obj.No_of_days__c) {
    
                            text_color = UpcomingPayments0daysLeft_obj.Color_Code__c;
                          
                        } else if ((getdate(due_date).daysBetween(Date.Today()) >= 
                                    UpcomingPayments3daysLeft_obj.No_of_days__c) && 
                                    (getdate(due_date).daysBetween(Date.Today()) < = 
                                    UpcomingPayments0daysLeft_obj.No_of_days__c)) {
    
                            text_color = UpcomingPayments3daysLeft_obj.Color_Code__c;
                           
                        } else if (getdate(due_date).daysBetween(Date.Today()) <= 
                                   UpcomingPayments4daysLeft_obj.No_of_days__c) {
                            text_color = UpcomingPayments4daysLeft_obj.Color_Code__c;
                        }
                    }
                } else {

                    text_color = 'black';
                }
                return text_color;
    }
    
    
   // method to set text color
    public void setcolorcode() {
        // assigning color code to Payment received list 
        if (PaymentReceivedList.size() > 0) {

            for (PaymentReceived p_recvd: PaymentReceivedList) {
                if (!String.isBlank(p_recvd.due_date) && !String.isBlank(p_recvd.received_date)) {
                    
                    if( PaymentRecievedBeforeDue_obj !=null && 
                        PaymentRecievedBeforeDue_obj.No_of_days__c!=null &&
                       !String.isBlank(PaymentRecievedBeforeDue_obj.Color_Code__c) &&
                        PaymentRecievedAfterDue_obj!=null && 
                        PaymentRecievedAfterDue_obj.No_of_days__c !=null &&
                       !String.isBlank(PaymentRecievedAfterDue_obj.Color_Code__c)){
                       
                        if (getdate(p_recvd.due_date).daysBetween(getdate(p_recvd.received_date)) >= 
                            PaymentRecievedBeforeDue_obj.No_of_days__c) {
                            
                            p_recvd.Payment_color = PaymentRecievedBeforeDue_obj.Color_Code__c;  
                        
                        } else if (getdate(p_recvd.due_date).daysBetween(getdate(p_recvd.received_date)) < 
                                   PaymentRecievedAfterDue_obj.No_of_days__c) {
                                   
                            p_recvd.Payment_color = PaymentRecievedAfterDue_obj.Color_Code__c;
                        }
                    }
                } else {

                    p_recvd.Payment_color = 'black';
                }
            }


            // assigning color code to upcoming Payment list
            for (PaymentUpcoming p_upcm: PaymentUpcomingList) {

                if (!String.isBlank(p_upcm.due_date)) {
                    if(UpcomingPayments0daysLeft_obj != null && 
                       UpcomingPayments0daysLeft_obj.No_of_days__c!=null && 
                     (!String.isBlank(UpcomingPayments0daysLeft_obj.Color_Code__c)) &&
                       UpcomingPayments3daysLeft_obj != null && 
                       UpcomingPayments3daysLeft_obj.No_of_days__c!=null && 
                     (!String.isBlank(UpcomingPayments3daysLeft_obj.Color_Code__c)) &&
                       UpcomingPayments4daysLeft_obj !=null && 
                       UpcomingPayments4daysLeft_obj.No_of_days__c!=null && 
                       (!String.isBlank(UpcomingPayments4daysLeft_obj.Color_Code__c)) ){
                    
                        if (getdate(p_upcm.due_date).daysBetween(Date.Today()) > 
                            UpcomingPayments0daysLeft_obj.No_of_days__c) {
    
                            p_upcm.Payment_color = UpcomingPayments0daysLeft_obj.Color_Code__c;
                          
                        } else if ((getdate(p_upcm.due_date).daysBetween(Date.Today()) >= 
                                    UpcomingPayments3daysLeft_obj.No_of_days__c) && 
                                   (getdate(p_upcm.due_date).daysBetween(Date.Today()) < = 
                                    UpcomingPayments0daysLeft_obj.No_of_days__c)) {
    
                            p_upcm.Payment_color = UpcomingPayments3daysLeft_obj.Color_Code__c;
                           
                        } else if (getdate(p_upcm.due_date).daysBetween(Date.Today()) <= 
                                   UpcomingPayments4daysLeft_obj.No_of_days__c) {
                            p_upcm.Payment_color = UpcomingPayments4daysLeft_obj.Color_Code__c;
                            
                        }
                    }



                } else {

                    p_upcm.Payment_color = 'black';
                }
            }
        }
    }


    //Method to calculate total payment received and total due
    public void calculateTotals() {

        TotalPaymentR = 0;
        TotalDue = 0;
        received_percent = 0;
        due_percent = 0;
       
            if (PaymentReceivedList.size() > 0) {
                for (PaymentReceived p_recvd: PaymentReceivedList) {
                    if (!String.isBlank(p_recvd.payments_received)) { 
                        
                        //calculating total payment
                        TotalPaymentR += decimal.valueOf(p_recvd.payments_received);
                    }
                }
            }
            if(PaymentUpcomingList.size()>0) {
                for (PaymentUpcoming p_upcm: PaymentUpcomingList) {
    
                    if (!String.isBlank(p_upcm.total_due)) {
                        //calculating total due
                        TotalDue += decimal.valueOf(p_upcm.total_due);
                    }
    
                }
                 
            }
            
            if(bookingList.size()>0 && 
               bookingList[0].Consideration_Value__c!=null && 
               bookingList[0].Consideration_Value__c != 0) {
               
                        received_percent = (TotalPaymentR /bookingList[0].Consideration_Value__c) * 100;
                        due_percent = (TotalDue /bookingList[0].Consideration_Value__c) * 100;
                        received_percent = received_percent.setscale(2);
                        due_percent = due_percent.setscale(2);
            }
    }

    // method to create list of records for account ledger 
    public void addaccountLedger() {

        for (paymentInfo paymentobj: paymentInfoList) {
            if (paymentobj.reference != null && 
                paymentobj.received_date != null && 
                paymentobj.Instrument_Date != null && 
                paymentobj.payment_mileStone != null && 
                paymentobj.bank_details != null && 
                paymentobj.receipt_no != null && 
                paymentobj.principal_amount_received != null) {
                
                AccountLedger AccountLedger_Obj = new AccountLedger();
                AccountLedger_Obj.reference = paymentobj.reference;
                AccountLedger_Obj.received_date = paymentobj.received_date;
                AccountLedger_Obj.Instrument_Date = paymentobj.Instrument_Date;
                AccountLedger_Obj.bank_details = paymentobj.bank_details;
                AccountLedger_Obj.receipt_no = paymentobj.receipt_no;
                AccountLedger_Obj.principal_amount_received = paymentobj.principal_amount_received;
                AccountLedger_Obj.payment_mileStone = paymentobj.payment_mileStone;
                AccountLedgerList.add(AccountLedger_Obj);
            }
        }
    }




    // method for sorting payments receievd list according to received dates        
    public void sortpaymentsReceived() {
        List < PaymentReceived > tempList = new List < PaymentReceived > ();
        List < PaymentReceived > tempnulldateList = new List < PaymentReceived > ();

        for (PaymentReceived obj: PaymentReceivedList) {
            if (!String.isBlank(obj.received_date)) {
                tempList.add(obj);
            } else {
                tempnulldateList.add(obj);
            }
        }

        for (integer i = 0; i < tempList.size(); i++) {
            for (integer j = 1; j < (tempList.size() - i); j++) {

                if (getdate(tempList[j - 1].received_date).daysBetween(getdate(tempList[j].received_date)) < 0) {
                
                    PaymentReceived temp = new PaymentReceived();
                    // swapping with objects 
                    temp.payment_mileStone = tempList[j - 1].payment_mileStone;
                    temp.bill_date = tempList[j - 1].bill_date;
                    temp.due_date = tempList[j - 1].due_date;
                    temp.principal_amount_due = tempList[j - 1].principal_amount_due;
                    temp.principal_amount_received = tempList[j - 1].principal_amount_received;
                    temp.principal_outstanding = tempList[j - 1].principal_outstanding;
                    temp.service_tax_due = tempList[j - 1].service_tax_due;
                    temp.service_tax_received = tempList[j - 1].service_tax_received;
                    temp.service_tax_outstanding = tempList[j - 1].service_tax_outstanding;
                    temp.interest_due_as_ondate = tempList[j - 1].interest_due_as_ondate;
                    temp.total_due = tempList[j - 1].total_due;
                    temp.payments_received = tempList[j - 1].payments_received;
                    temp.balance_due = tempList[j - 1].balance_due;
                    temp.received_date = tempList[j - 1].received_date;
                    temp.mode_of_payment = tempList[j - 1].mode_of_payment;
                    temp.bank_details = tempList[j - 1].bank_details;
                    temp.status = tempList[j - 1].status;
                    temp.reference = tempList[j - 1].reference;
                    temp.Payment_color = tempList[j - 1].Payment_color;


                    tempList[j - 1].payment_mileStone = tempList[j].payment_mileStone;
                    tempList[j - 1].bill_date = tempList[j].bill_date;
                    tempList[j - 1].due_date = tempList[j].due_date;
                    tempList[j - 1].principal_amount_due = tempList[j].principal_amount_due;
                    tempList[j - 1].principal_amount_received = tempList[j].principal_amount_received;
                    tempList[j - 1].principal_outstanding = tempList[j].principal_outstanding;
                    tempList[j - 1].service_tax_due = tempList[j].service_tax_due;
                    tempList[j - 1].service_tax_received = tempList[j].service_tax_received;
                    tempList[j - 1].service_tax_outstanding = tempList[j].service_tax_outstanding;
                    tempList[j - 1].interest_due_as_ondate = tempList[j].interest_due_as_ondate;
                    tempList[j - 1].total_due = tempList[j].total_due;
                    tempList[j - 1].payments_received = tempList[j].payments_received;
                    tempList[j - 1].balance_due = tempList[j].balance_due;
                    tempList[j - 1].received_date = tempList[j].received_date;
                    tempList[j - 1].mode_of_payment = tempList[j].mode_of_payment;
                    tempList[j - 1].bank_details = tempList[j].bank_details;
                    tempList[j - 1].status = tempList[j].status;
                    tempList[j - 1].reference = tempList[j].reference;
                    tempList[j - 1].Payment_color = tempList[j].Payment_color;

                    tempList[j].payment_mileStone = temp.payment_mileStone;
                    tempList[j].bill_date = temp.bill_date;
                    tempList[j].due_date = temp.due_date;
                    tempList[j].principal_amount_due = temp.principal_amount_due;
                    tempList[j].principal_amount_received = temp.principal_amount_received;
                    tempList[j].principal_outstanding = temp.principal_outstanding;
                    tempList[j].service_tax_due = temp.service_tax_due;
                    tempList[j].service_tax_received = temp.service_tax_received;
                    tempList[j].service_tax_outstanding = temp.service_tax_outstanding;
                    tempList[j].interest_due_as_ondate = temp.interest_due_as_ondate;
                    tempList[j].total_due = temp.total_due;
                    tempList[j].payments_received = temp.payments_received;
                    tempList[j].balance_due = temp.balance_due;
                    tempList[j].received_date = temp.received_date;
                    tempList[j].mode_of_payment = temp.mode_of_payment;
                    tempList[j].bank_details = temp.bank_details;
                    tempList[j].status = temp.status;
                    tempList[j].reference = temp.reference;
                    tempList[j].Payment_color = temp.Payment_color;

                }

            }

        }
        PaymentReceivedList.clear();
        for (integer i = tempList.size() - 1; i >= 0; i--) {
            PaymentReceivedList.add(tempList[i]);
        }
        for (PaymentReceived obj: tempnulldateList) {
            PaymentReceivedList.add(obj);
        }

    }




    // method for sorting upcoming payments list according to due dates       
    public void sortpaymentsUpcoming() {
        List < PaymentUpcoming > tempList = new List < PaymentUpcoming > ();
        List < PaymentUpcoming > tempnulldateList = new List < PaymentUpcoming > ();

        for (PaymentUpcoming obj: PaymentUpcomingList) {
            if (!String.isBlank(obj.due_date)) {
                tempList.add(obj);
            } else {
                tempnulldateList.add(obj);
            }
        }

        for (integer i = 0; i < tempList.size(); i++) {
            for (integer j = 1; j < (tempList.size() - i); j++) {

                if (getdate(tempList[j - 1].due_date).daysBetween(getdate(tempList[j].due_date)) < 0) {
                    PaymentUpcoming temp = new PaymentUpcoming();
                    // swapping with objects 
                    temp.payment_mileStone = tempList[j - 1].payment_mileStone;
                    temp.bill_date = tempList[j - 1].bill_date;
                    temp.due_date = tempList[j - 1].due_date;
                    temp.principal_amount_due = tempList[j - 1].principal_amount_due;
                    temp.principal_amount_received = tempList[j - 1].principal_amount_received;
                    temp.principal_outstanding = tempList[j - 1].principal_outstanding;
                    temp.service_tax_due = tempList[j - 1].service_tax_due;
                    temp.service_tax_received = tempList[j - 1].service_tax_received;
                    temp.service_tax_outstanding = tempList[j - 1].service_tax_outstanding;
                    temp.interest_due_as_ondate = tempList[j - 1].interest_due_as_ondate;
                    temp.total_due = tempList[j - 1].total_due;
                    temp.payments_received = tempList[j - 1].payments_received;
                    temp.balance_due = tempList[j - 1].balance_due;
                    temp.received_date = tempList[j - 1].received_date;
                    temp.mode_of_payment = tempList[j - 1].mode_of_payment;
                    temp.bank_details = tempList[j - 1].bank_details;
                    temp.status = tempList[j - 1].status;
                    temp.reference = tempList[j - 1].reference;
                    temp.Payment_color = tempList[j - 1].Payment_color;


                    tempList[j - 1].payment_mileStone = tempList[j].payment_mileStone;
                    tempList[j - 1].bill_date = tempList[j].bill_date;
                    tempList[j - 1].due_date = tempList[j].due_date;
                    tempList[j - 1].principal_amount_due = tempList[j].principal_amount_due;
                    tempList[j - 1].principal_amount_received = tempList[j].principal_amount_received;
                    tempList[j - 1].principal_outstanding = tempList[j].principal_outstanding;
                    tempList[j - 1].service_tax_due = tempList[j].service_tax_due;
                    tempList[j - 1].service_tax_received = tempList[j].service_tax_received;
                    tempList[j - 1].service_tax_outstanding = tempList[j].service_tax_outstanding;
                    tempList[j - 1].interest_due_as_ondate = tempList[j].interest_due_as_ondate;
                    tempList[j - 1].total_due = tempList[j].total_due;
                    tempList[j - 1].payments_received = tempList[j].payments_received;
                    tempList[j - 1].balance_due = tempList[j].balance_due;
                    tempList[j - 1].received_date = tempList[j].received_date;
                    tempList[j - 1].mode_of_payment = tempList[j].mode_of_payment;
                    tempList[j - 1].bank_details = tempList[j].bank_details;
                    tempList[j - 1].status = tempList[j].status;
                    tempList[j - 1].reference = tempList[j].reference;
                    tempList[j - 1].Payment_color = tempList[j].Payment_color;

                    tempList[j].payment_mileStone = temp.payment_mileStone;
                    tempList[j].bill_date = temp.bill_date;
                    tempList[j].due_date = temp.due_date;
                    tempList[j].principal_amount_due = temp.principal_amount_due;
                    tempList[j].principal_amount_received = temp.principal_amount_received;
                    tempList[j].principal_outstanding = temp.principal_outstanding;
                    tempList[j].service_tax_due = temp.service_tax_due;
                    tempList[j].service_tax_received = temp.service_tax_received;
                    tempList[j].service_tax_outstanding = temp.service_tax_outstanding;
                    tempList[j].interest_due_as_ondate = temp.interest_due_as_ondate;
                    tempList[j].total_due = temp.total_due;
                    tempList[j].payments_received = temp.payments_received;
                    tempList[j].balance_due = temp.balance_due;
                    tempList[j].received_date = temp.received_date;
                    tempList[j].mode_of_payment = temp.mode_of_payment;
                    tempList[j].bank_details = temp.bank_details;
                    tempList[j].status = temp.status;
                    tempList[j].reference = temp.reference;
                    tempList[j].Payment_color = temp.Payment_color;

                }

            }

        }
        PaymentUpcomingList.clear();
        for (integer i = tempList.size() - 1; i >= 0; i--) {
            PaymentUpcomingList.add(tempList[i]);
        }
        for (PaymentUpcoming obj: tempnulldateList) {
            PaymentUpcomingList.add(obj);
        }

    }

    //uniform wrapper class for payment information
    public class paymentInfo {

        public String CRN {get;set;}
        public String payment_mileStone {get;set;}
        public String bill_date {get;set;}
        public String due_date {get;set;}
        public String principal_amount_due {get;set;}
        public String principal_amount_received {get;set;}
        public String principal_outstanding {get;set;}
        public String service_tax_due {get;set;}
        public String service_tax_received {get;set;}
        public String service_tax_outstanding {get;set;}
        public String interest_due_as_ondate {get;set;}
        public String total_due{get;set;}
        public String payments_received{get;set;}
        public String balance_due {get;set;}
        public String received_date {get;set;}
        public String mode_of_payment{get;set;}
        public String bank_details {get;set;}
        public String status {get;set;}
        public String reference {get;set;}
        public String Instrument_Date {get;set;}
        public String receipt_no {get;set;}
        public String bg_color {get;set;}
        public String text_color {get;set;}

        public paymentInfo() {

            CRN = null;
            payment_mileStone = null;
            bill_date = null;
            due_date = null;
            principal_amount_due = null;
            principal_amount_received = null;
            principal_outstanding = null;
            service_tax_due = null;
            service_tax_received = null;
            service_tax_outstanding = null;
            interest_due_as_ondate = null;
            total_due = null;
            payments_received = null;
            balance_due = null;
            received_date = null;
            mode_of_payment = null;
            bank_details = null;
            status = null;
            reference = null;
            Instrument_Date = null;
            receipt_no = null;
            bg_color = null;
            text_color = null;

        }

    }

    //Wrapper class for payment Received  
    public class PaymentReceived {
        public String payment_mileStone{get;set;}
        public String bill_date {get;set;}
        public String due_date {get;set;}
        public String principal_amount_due{get;set;}
        public String principal_amount_received{get;set;}
        public String principal_outstanding {get;set;}
        public String service_tax_due {get;set;}
        public String service_tax_received {get;set;}
        public String service_tax_outstanding {get;set;}
        public String interest_due_as_ondate {get;set;}
        public String total_due {get;set;}
        public String payments_received {get;set;}
        public String balance_due {get;set;}
        public String received_date {get;set;}
        public String mode_of_payment {get;set;}
        public String bank_details{get;set;}
        public String status {get;set;}
        public String reference{get;set;}
        public string Payment_color {get;set;}

    }

    // wrapper class for payments upcoming
    public class PaymentUpcoming {

        public String payment_mileStone {get;set;}
        public String bill_date{get;set;}
        public String due_date {get;set;}
        public String principal_amount_due{get;set;}
        public String principal_amount_received{get;set;}
        public String principal_outstanding{get;set;}
        public String service_tax_due {get;set;}
        public String service_tax_received{get;set;}
        public String service_tax_outstanding{get;set;}
        public String interest_due_as_ondate{get;set;}
        public String total_due{get;set;}
        public String payments_received {get;set;}
        public String balance_due {get;set;}
        public String received_date{get;set;}
        public String mode_of_payment {get;set;}
        public String bank_details {get;set;}
        public String status {get;set;}
        public String reference {get;set;}
        public string Payment_color{get;set;}


    }

    //wrapper class for payment schedule
    public class PaymentSchedule {

        public String payment_mileStone {get;set;}
        public String principal_amount_due {get;set;}
        public String service_tax_due {get;set;}
        public String total_due {get;set;}
        public Decimal percent_cv {get;set;}

    }


    // wrapper class for account ledger
    public class AccountLedger {
        public String reference {get;set;}
        public String received_date {get;set;}
        public String payment_mileStone{get;set;}
        public String Instrument_Date {get;set;}
        public String bank_details {get;set;}
        public String receipt_no{get;set;}
        public String principal_amount_received {get;set;}
      
    }

}