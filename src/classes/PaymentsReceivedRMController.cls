/* 
Description : Controller class for visusalforce page PaymentsReceived Detailview
 @Created by: Shruti Nikam
 @Created Date: 26/2/2015
 
 --------------------------------------------------------------------------------
 | Modified By      | Modified Date       | Version        | Description         |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------

*/
public with sharing class PaymentsReceivedRMController {

    //Get the CRN from attribute
    public String PARAM_CRN {get;set;}
    public virtualInterest virtualInterest_obj {get;set;}
    public boolean showamt {get;set;}
    public boolean showtotalamt {get;set;}
    public String errorMsg {get;set;}
    public String errorMsg1 {get;set;}
    public RestAPICalloutController RestAPICalloutController_obj;
    public RestAPICalloutController.CustomerInformationWrapper RestAPICallout_wrapper_obj {get;set;}
    public ReminderWrapper reminderWrapper_obj{get;set;}
    //for my gain data [both basic detail and complete details of mygain, these are are two list]
    public RestAPICalloutMygain rcMygain {get;set;}
    public account acc {get;set;}
    public account receiveddate {get;set;}
    public Integer NoOfRecords {get;set;}
    public RestAPICalloutPayment RestAPICalloutPayment_obj {get;set;}
    public virtualInterest total_virtual_interest_obj {get;set;}

    // stores no of reminder active
    public integer reminder_count {get;set;}
    public date issue_date {get; set;}
    
    //reminder List 
    public List<ReminderWrapper> reminderWrapperList {get; set;}

    public final static String after12days ='after12days';
    public final static String afterfivedays = 'afterfivedays';
    public final static String afteroneday = 'afteroneday';
    //constants used in code 
    public final static String dateNotPresentError='Enter Date of Payment Received by Lodha';
    public final static String interestNotice = 'Interest Notice';
    public final static String interestLetter1 = 'Interest Letter 1';
    public final static String interestLetter2 = 'Interest Letter 2';
    
    public Reminder_no_of_days__c after12Days_Obj = Reminder_no_of_days__c.getvalues(after12days);
    public Reminder_no_of_days__c afterFiveDays_Obj = Reminder_no_of_days__c.getvalues(afterfivedays);
    public Reminder_no_of_days__c afterOneDay_Obj = Reminder_no_of_days__c.getvalues(afteroneday);
    
    public final static String Interest ='Interest';
    
    public VirtualInterestCalculator_InterestRate__c Interest_obj = VirtualInterestCalculator_InterestRate__c.getvalues(Interest);
    // constructor 
    public PaymentsReceivedRMController() {
        errorMsg = '';
        errorMsg1 = '';
        PARAM_CRN = ApexPages.currentPage().getParameters().get('CRN');
       
        // calling web services for fetching data 
        RestAPICalloutPayment_obj = new RestAPICalloutPayment(PARAM_CRN);
        
        // account instance for dummy date field
        acc = new account();
        receiveddate = new account();
        // virtual interest wrapper object initialisation
        virtualInterest_obj = new virtualInterest();
        total_virtual_interest_obj = new virtualInterest();


        // reminder wrapper object initialisation 
        reminderWrapper_obj = new ReminderWrapper();

        reminder_count = 0;
        set_reminder();

        acc.PersonBirthdate = Date.today();
        receiveddate.PersonBirthdate = Date.today();
        showamt = false;
        showtotalamt = false;
        //check my is available for user or not
        //RestAPICallout_wrapper_obj.my_gain_customer
        RestAPICalloutController_obj = new RestAPICalloutController();
        RestAPICallout_wrapper_obj = new RestAPICalloutController.CustomerInformationWrapper();
        RestAPICallout_wrapper_obj = RestAPICalloutController_obj.parseCustomerInformationJSON(PARAM_CRN);
        
        rcMygain = new RestAPICalloutMygain(PARAM_CRN); 
    }
    
   public String getPreIntialization(){
        // calling web services for fetching data 
        RestAPICalloutPayment_obj = new RestAPICalloutPayment(PARAM_CRN);
        return '';
   }

    //method to calculate virtual interest for upcoming payments 
    public pagereference InterestAmount() {
        decimal InterestAmount;
        string InterestAmountstr;
        decimal InterestRate = 0;
        if(Interest_obj !=null && Interest_obj.Interest_Rate__c != null) {
            InterestRate = Interest_obj.Interest_Rate__c;
        }
        showamt = true;

        // dummy date feild use for datepicker 
        if (acc.PersonBirthdate == null) {
            errorMsg = dateNotPresentError;
            showamt = false;
            return null;
        }

        // many times web service is provided with empty values so we need to check them 
        if (virtualInterest_obj.duedate != null && acc.PersonBirthdate != null) {


            decimal noOfDays = virtualInterest_obj.duedate.daysBetween(acc.PersonBirthdate);

            InterestAmount = (virtualInterest_obj.outstandingamt * noOfDays * InterestRate) / (365 * 100);
            InterestAmount = InterestAmount.setScale(2);

            if (InterestAmount < 0) {
                InterestAmount = 0;
            }

            InterestAmountstr = String.valueOf(InterestAmount);

            virtualInterest_obj.totalamt = InterestAmountstr;
            errorMsg = '';
        } else {
            virtualInterest_obj.totalamt = '0';
            errorMsg = '';
        }
        return null;
    }

   
    public void clearValues() {
        errorMsg = '';
        acc.PersonBirthdate = Date.today();
        virtualInterest_obj.totalamt = null;
        showamt = false;
        virtualInterest_obj.duedate = null;
        virtualInterest_obj.outstandingamt = null;
    }
    
    public void autoPopulateMyGainVar() {
        String dt = apexpages.currentpage().getparameters().get('dueDate');
        String amt = apexpages.currentpage().getparameters().get('amt');
        //string dateinput = 
        errorMsg = '';
        list < String > str = new list < String > ();
        map < String, Integer > monthMap = new map < String, Integer > {
            'jan' => 1, 'feb' => 2, 'mar' => 3,
                'apr' => 4, 'may' => 5, 'jun' => 6,
                'jul' => 7, 'aug' => 8, 'sep' => 9,
                'oct' => 10, 'nov' => 11, 'dec' => 12
        };

        if (dt != null && dt != '' && dt.contains(' ')) {
            str = dt.split(' ');
        }

        if (str.size() == 3) {
            Integer day = Integer.valueOf(str[0]);
            String month = str[1];
            Integer year = Integer.valueOf(str[2]);

            if (month != '' && 
                    month != null && 
                        monthMap.containsKey(month.toLowerCase())) virtualInterest_obj.duedate = 
                                Date.newInstance(year, monthMap.get(month.toLowerCase()), day);
            else virtualInterest_obj.duedate = null;
        } else {
            virtualInterest_obj.duedate = null;
        }

        if (amt != null && amt != '') virtualInterest_obj.outstandingamt = Decimal.valueOf(amt);
        else virtualInterest_obj.outstandingamt = null;

        acc.PersonBirthdate = Date.today();
        virtualInterest_obj.totalamt = null;
        showamt = false;
    }
    
     // method to set reminders for payments 
    public void set_reminder() {
        // to calculate issue date 
         reminderWrapperList = new List<ReminderWrapper>();
        if(RestAPICalloutPayment_obj.PaymentUpcomingList.size()>0) {
           
            if (RestAPICalloutPayment_obj.PaymentUpcomingList[0].due_date != null && RestAPICalloutPayment_obj.PaymentUpcomingList[0].due_date != '') {
                if(afterOneDay_Obj != null && afteroneday_obj.no_of_days__c!=null && afteroneday_obj.Letter_issue_days__c!=null) {
                    if ((RestAPICalloutPayment_obj.getdate(RestAPICalloutPayment_obj.PaymentUpcomingList[0].due_date)).daysBetween(Date.Today()) >= afteroneday_obj.no_of_days__c ) {
                        ReminderWrapper reminderWrapper_obj1 = new ReminderWrapper();
                        reminderWrapper_obj1.milestone_name = RestAPICalloutPayment_obj.PaymentUpcomingList[0].payment_mileStone;
                        reminderWrapper_obj1.due_date = RestAPICalloutPayment_obj.PaymentUpcomingList[0].due_date;
                        reminderWrapper_obj1.reminder_type = interestLetter1;
                        reminderWrapper_obj1.issue_date = RestAPICalloutPayment_obj.getdate(RestAPICalloutPayment_obj.PaymentUpcomingList[0].due_date) + integer.valueOf(afteroneday_obj.Letter_issue_days__c);
                        reminderWrapperList.add(reminderWrapper_obj1);
        
                    } 
                }
                if(afterFiveDays_Obj != null && afterFiveDays_Obj.no_of_days__c!=null && afterFiveDays_Obj.Letter_issue_days__c!=null) { 
                    if ((RestAPICalloutPayment_obj.getdate(RestAPICalloutPayment_obj.PaymentUpcomingList[0].due_date)).daysBetween(Date.Today()) >= afterFiveDays_Obj.no_of_days__c ) {
                        ReminderWrapper reminderWrapper_obj2 = new ReminderWrapper();
                        reminderWrapper_obj2.milestone_name = RestAPICalloutPayment_obj.PaymentUpcomingList[0].payment_mileStone;
                        reminderWrapper_obj2.due_date = RestAPICalloutPayment_obj.PaymentUpcomingList[0].due_date;
                        reminderWrapper_obj2.reminder_type = interestLetter2;
                        reminderWrapper_obj2.issue_date = RestAPICalloutPayment_obj.getdate(RestAPICalloutPayment_obj.PaymentUpcomingList[0].due_date) + integer.valueOf(afterFiveDays_Obj.Letter_issue_days__c);
                        reminderWrapperList.add(reminderWrapper_obj2);
        
                    }
                }
                if(after12Days_Obj != null && after12days_obj.no_of_days__c!=null && after12days_obj.Letter_issue_days__c!=null) {
                    if ((RestAPICalloutPayment_obj.getdate(RestAPICalloutPayment_obj.PaymentUpcomingList[0].due_date)).daysBetween(Date.Today()) >= after12days_obj.no_of_days__c) {
                        ReminderWrapper reminderWrapper_obj3 = new ReminderWrapper();
                        reminderWrapper_obj3.milestone_name = RestAPICalloutPayment_obj.PaymentUpcomingList[0].payment_mileStone;
                        reminderWrapper_obj3.due_date = RestAPICalloutPayment_obj.PaymentUpcomingList[0].due_date;
                        reminderWrapper_obj3.reminder_type = interestNotice;
                        reminderWrapper_obj3.issue_date = RestAPICalloutPayment_obj.getdate(RestAPICalloutPayment_obj.PaymentUpcomingList[0].due_date) + integer.valueOf(after12days_obj.Letter_issue_days__c);
                        reminderWrapperList.add(reminderWrapper_obj3);
                    }
                }
            }
       }
       
       reminder_count=reminderWrapperList.size();
    
    }

    //method to create total virtual interest for all slabs 
    public void calculateTotal_VirtualInterest(){
        //initialise obj 
        
        decimal interestamount;
        decimal amount;
        decimal sum_interestamount=0;
        decimal rate_of_interest=0;
        total_virtual_interest_obj.outstandingamt=0;
        Date payments_received_date;  
        decimal noOfDays=0;
        if(Interest_obj !=null && Interest_obj.Interest_Rate__c != null) {
            rate_of_interest = Interest_obj.Interest_Rate__c;
        }
        showtotalamt = true;
        errorMsg1='';
        if (receiveddate.PersonBirthdate == null) {
            errorMsg1 = dateNotPresentError;
            showtotalamt = false;
        }
        payments_received_date = receiveddate.PersonBirthdate;
        
        //iterate over Payments outstanding records 
        for(RestAPICalloutPayment.PaymentUpcoming outstanding_obj :RestAPICalloutPayment_obj.PaymentUpcomingList) {
            // dummy date feild use for datepicker 
            if (receiveddate.PersonBirthdate == null) {
                errorMsg1 = dateNotPresentError;
                showtotalamt = false;
            }
            if(!String.isBlank(outstanding_obj.due_date) && payments_received_date!=null && !String.isBlank(outstanding_obj.balance_due)) {
                noOfDays = RestAPICalloutPayment_obj.getdate(outstanding_obj.due_date).daysBetween(payments_received_date);
                if(noOfDays<0){
                    noOfDays =0;
                } 
                interestamount = (Decimal.valueOf(outstanding_obj.balance_due) * noOfDays * rate_of_interest) / (365 * 100);
                if(interestamount<0) {
                    interestamount=0;
                }
                sum_interestamount += interestamount; 
                total_virtual_interest_obj.outstandingamt += Decimal.valueOf(outstanding_obj.balance_due); 
                 errorMsg1=''; 
            }
        }
        sum_interestamount = sum_interestamount.setScale(2);   
        total_virtual_interest_obj.totalamt = String.valueOf(sum_interestamount);
       
    }
    
    
    public void totalvirtualcal_clearValues() {
        errorMsg1 = '';
        receiveddate.PersonBirthdate = Date.today();
        total_virtual_interest_obj.totalamt = null;
        showtotalamt = false;
    }
    

    //wrapper to hold details required virtual calcualtor 
    public class virtualInterest {
        public Date duedate {get;set;}
        public decimal outstandingamt {get;set;}
        public string totalamt {get;set;}
        
        public virtualInterest() {

        }

    }
    
    //wrapper to hold details of reminder
    public class ReminderWrapper {
        public string milestone_name {get;set;}
        public String due_date {get;set;}
        public string reminder_type {get;set;}
        public Date issue_date {get; set;}


        public ReminderWrapper() {
            milestone_name = '';
            due_date = '';
            reminder_type = '';
            issue_date =null;

        }

    }

}