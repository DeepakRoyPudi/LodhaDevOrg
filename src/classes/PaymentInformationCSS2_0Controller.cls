/* Class for Payment Information tab CSS
   @Created by: Trupti Dhokla
   @Created Date: 04/03/2015
   
   -------------------------------------------------------------------------------------
   | Modified By      | Modified Date       | Version        |  Description         |
   -------------------------------------------------------------------------------------
   |Trupti Dhoka       18/03/2015                1.1            Updated UI 
   --------------------------------------------------------------------------------------
   |Trupti Dhoka       23/03/2015                1.2            updated pagination logic
   --------------------------------------------------------------------------------------
   |Trupti Dhoka       15/06/2015                1.3            enhancement of detail view
   ---------------------------------------------------------------------------------------
   |Trupti Dhoka       06/07/2015                1.4            interest on all outstanding slabs 
                                                                by entering a date.
*/
public class PaymentInformationCSS2_0Controller {

    public final static String Milestones_Paid = 'Milestones_Paid';
    public final static String Milestones_Outstanding = 'Milestones_Outstanding';
    public final static String Milestones_Upcoming = 'Milestones_Upcoming';
    public final static String percentMvatMilestone = '1% MVAT Recovery';
    public final static String dateNotPresentError='Enter Date of Payment Received by Lodha';
    public final static String Interest ='Interest';

    //Get logged in customer's CRN
    public String userId;
    public static String Cust_CRN{get;set;} 

    //Google Analytics variables
    public static String username{get;set;}
    public static String userCRN{get;set;}
    public static String userProject{get;set;}
    public static String userSeqment{get;set;}
    public static DateTime userLastLogin {get;set;}

    //public RestAPICalloutController RestAPICalloutController_obj;   
    public List<CSS2_0TabEnableDisableSetting__c> tabEnableDisableSetting {get;set;} 
    public RestAPICalloutPayment restAPICalloutPayment{get;set;}
    public RestApiPaymentScheduleCSS restApiPaymentSchedule{get;set;}
    public List<Service_Tax_Detail__c> serviceTaxList{get;set;}

    //used for showing Loan details
    //public RestAPICalloutController.CustomerInformationWrapper RestAPICallout_wrapper_obj {get;set;}
    //for my gain data [both basic detail and complete details of mygain, these are are two list]
    public RestAPICalloutMygain rcMygain{get;set;}

    //fields for background images
    public boolean isProjectWise {get;set;}
    public string imageUrl {get;set;}

    /*--------------------New Payment detail view 15/07/2015-----------------------------------*/

    Booking_Details__c bookingObj;
    public List<Demands__c> listDemands;
    public list<DemandWrapper>  listDemandWrapper {get;set;}
    public list<DemandWrapper>  paymentScheduleWrapperList {get;set;}
    public Payments_backgroundColorCode__c Milestones_Paid_obj {get;set;}
    public Payments_backgroundColorCode__c Milestones_Outstanding_obj {get;set;}
    public Payments_backgroundColorCode__c Milestones_Upcoming_obj {get;set;}
    public Despatch__c acc {get;set;}
    public Despatch__c receiveddate {get;set;}
    public boolean showamt  {get; set;} 
    public boolean showtotalamt {get; set;} 
    public string errorMsg {get; set;}
    public string errorMsg1 {get; set;}
    public virtualInterest total_virtual_interest_obj {get;set;}
    public virtualInterest virtualInterest_obj {get;set;}
    public decimal TotalAmtDue {get; set;}
    public VirtualInterestCalculator_InterestRate__c Interest_obj;
    public PaymentInformationCSS2_0Controller()
    {
        init();
    }

    public void init()
    {
        Interest_obj = VirtualInterestCalculator_InterestRate__c.getvalues(Interest);
        Milestones_Paid_obj = Payments_backgroundColorCode__c.getvalues(Milestones_Paid);
        Milestones_Outstanding_obj = Payments_backgroundColorCode__c.getvalues(Milestones_Outstanding);
        Milestones_Upcoming_obj = Payments_backgroundColorCode__c.getvalues(Milestones_Upcoming);
        tabEnableDisableSetting = CSS2_0TabEnableDisableSetting__c.getall().values();
        try
        {
           userId=Userinfo.getUserid();
        }
        catch(Exception e)
        {
            system.debug(e);
        }
        Cust_CRN= CreateQueryHelper.getCustomerCRN(userId);
        
        if(String.isNotBlank(Cust_CRN))
        {
            GoogleAnalyticsHelper.GetReportParameters(userId); 
            username = GoogleAnalyticsHelper.username;
            userCRN = GoogleAnalyticsHelper.userCRN ;
            userProject =GoogleAnalyticsHelper.userProject;
            userSeqment = GoogleAnalyticsHelper.userSeqment;   
            userLastLogin= GoogleAnalyticsHelper.userLastLogin;   
            this.checkBackgroundImage();
            restAPICalloutPayment = new RestAPICalloutPayment(Cust_CRN); 
            //RestAPICalloutController_obj = new RestAPICalloutController();
            restApiPaymentSchedule = new RestApiPaymentScheduleCSS(Cust_CRN);
 
            //Used to show Customer Loan Details
            /*RestAPICallout_wrapper_obj = new RestAPICalloutController.CustomerInformationWrapper();
            RestAPICallout_wrapper_obj = RestAPICalloutController_obj.parseCustomerInformationJSON(Cust_CRN);*/
            virtualInterest_obj = new virtualInterest();
            total_virtual_interest_obj = new virtualInterest();
            TotalAmtDue = 0; 
            paymentScheduleWrapperList = new list<DemandWrapper>();
            // account instance for dummy date field
            acc = new Despatch__c();
            receiveddate = new Despatch__c();
            acc.Despatch_Date__c = Date.today();
            receiveddate.Despatch_Date__c = Date.today();
            serviceTaxList = new List<Service_Tax_Detail__c>();
            //check my is available for user or not
            rcMygain=new RestAPICalloutMygain(Cust_CRN);

            /*-------------------------New Payment Detail view 15/7/15------------*/
            listDemandWrapper = new List<DemandWrapper>();
            List<Booking_Details__c> bdList = new List<Booking_Details__c>
                                ([Select id,
                                         Account__c,
                                         Flat_ID__c  
                                    from Booking_Details__c 
                                   where CRN__c = :Cust_CRN LIMIT 1]);
            if(bdList.size()>0) {

                serviceTaxList = [ Select Id,
                                          Balance_due__c, 
                                          Pref_location_Service_Tax__c,
                                          Const_Service_tax_Amount__c,
                                          Taxable_Service_Tax_Amount__c,
                                          ST_on_Construction_Serv__c,
                                          ST_on_Preferential_Location__c,
                                          Total_ST_Payable__c,
                                          Payment_Received__c
                                     from Service_Tax_Detail__c 
                                    where Account__c = :bdList[0].Account__c];

                listDemands = [select Flat_ID__r.Consideration_Value__c,
                                      Payment_Milestone_Formula__c,
                                      Billing_Date__c,
                                      Custom_Due_Date__c, 
                                      Due_Date__c,
                                      Payment_received_on__c,
                                      Demand_amount__c,
                                      Amount_received__c,
                                      Balance_Due__c,
                                      Overdue_Status__c 
                                 FROM Demands__c
                                WHERE Flat_ID__c =:bdList[0].id];
                if(listDemands.size() > 0){
                    for(Demands__c d : listDemands){
                        if(d.Balance_Due__c != null ){
                            TotalAmtDue = TotalAmtDue + d.Balance_Due__c ;
                        }
                    }
                }
            }
            //call paymentlistcolor code method to set colors to records according to condition
            PaymentlstColorCode(); 
        }
    }

    /*This method sets color code according to payment types i.e received/overdue*/
    public void PaymentlstColorCode()
    { 
        DemandWrapper DemandWrapperObj;
        for(Demands__c dobj: listDemands )
        {
            DemandWrapperObj = new DemandWrapper();
            DemandWrapperObj.Payment_Milestone_Formula  =  dobj.Payment_Milestone_Formula__c;
            DemandWrapperObj.Custom_Due_Date  =  dobj.Custom_Due_Date__c;
            DemandWrapperObj.Due_Date  =  dobj.Due_Date__c;
            DemandWrapperObj.Payment_received_on  =  dobj.Payment_received_on__c;
            DemandWrapperObj.Demand_amount  =  dobj.Demand_amount__c;
            DemandWrapperObj.Amount_received  =  dobj.Amount_received__c;
            DemandWrapperObj.Balance_Due  =  dobj.Balance_Due__c;
            DemandWrapperObj.Overdue_Status  =  dobj.Overdue_Status__c;
            DemandWrapperObj.Billing_Date = dobj.Billing_Date__c;
            DemandWrapperObj.objDemand = dobj;

            if(dobj.Flat_ID__r.Consideration_Value__c != null) {
                DemandWrapperObj.cv = ((dobj.Balance_Due__c)/dobj.Flat_ID__r.Consideration_Value__c)*100;
                DemandWrapperObj.cv = DemandWrapperObj.cv.setscale(2);
            }
            //this condition is used for milestone paid

            if(dobj.Billing_Date__c != null && dobj.Balance_Due__c <= 0 
                && Milestones_Paid_obj != null
                && String.isNotBlank(Milestones_Paid_obj.ColorCode__c))
            {
                DemandWrapperObj.background_color  =  Milestones_Paid_obj.ColorCode__c;
            }

            //this condition is used for milestone Outstanding
            else if (dobj.Billing_Date__c != null && dobj.Balance_Due__c > 0 
                && Milestones_Outstanding_obj != null
                && String.isNotBlank(Milestones_Outstanding_obj.ColorCode__c) ) {
                DemandWrapperObj.background_color  =  Milestones_Outstanding_obj.ColorCode__c;
            }

            //this condition is used for milestone upcoming
            else if (dobj.Billing_Date__c == null && Milestones_Upcoming_obj != null && 
                        String.isNotBlank(Milestones_Upcoming_obj.ColorCode__c) ) {

                DemandWrapperObj.background_color  =  Milestones_Upcoming_obj.ColorCode__c;
            }

            else {
                DemandWrapperObj.background_color = 'black';
            }

            listDemandWrapper.add(DemandWrapperObj);

            if(DemandWrapperObj.Payment_Milestone_Formula != null && 
                DemandWrapperObj.Payment_Milestone_Formula != '' &&
                !DemandWrapperObj.Payment_Milestone_Formula.equalsIgnoreCase(percentMvatMilestone)) {
                paymentScheduleWrapperList.add(DemandWrapperObj);
            }
        }
    }

    /* PaymentModes For CSS2_0*/
    public PageReference PaymentMode()
    {
        PageReference payMode = page.PaymentModesCSS2_0;
        payMode.setREdirect(true);
        return payMode;
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
        if (acc.Despatch_Date__c == null) {
            errorMsg = dateNotPresentError;
            showamt = false;
            return null;
        }

        // many times web service is provided with empty values so we need to check them 
        if (virtualInterest_obj.duedate != null && acc.Despatch_Date__c != null) {
            decimal noOfDays = virtualInterest_obj.duedate.daysBetween(acc.Despatch_Date__c);
            InterestAmount = (virtualInterest_obj.outstandingamt * noOfDays * InterestRate) / (365 * 100);
            InterestAmount = InterestAmount.setScale(2);

            if (InterestAmount < 0) {
                InterestAmount = 0;
            }

            InterestAmountstr = String.valueOf(InterestAmount);
            virtualInterest_obj.totalamt = InterestAmountstr;
            errorMsg = '';
        } 
        else {
            virtualInterest_obj.totalamt = '0';
            errorMsg = '';
        }
        return null;
    }

    public void clearValues() {
        errorMsg = '';
        acc.Despatch_Date__c = Date.today();
        virtualInterest_obj.totalamt = null;
        showamt = false;
        virtualInterest_obj.duedate = null;
        virtualInterest_obj.outstandingamt = null;
    }

    public void autoPopulateMyGainVar() {
        String dt = apexpages.currentpage().getparameters().get('dueDate');
        String amt = apexpages.currentpage().getparameters().get('amt');
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

        if (str.size() == 6) {
            Integer day = Integer.valueOf(str[2]);
            String month = str[1];
            Integer year = Integer.valueOf(str[5]);

            if (month != '' && 
                month != null && 
                monthMap.containsKey(month.toLowerCase())) {
                virtualInterest_obj.duedate = 
                    Date.newInstance(year, monthMap.get(month.toLowerCase()), day);
            }

            else { 
                virtualInterest_obj.duedate = null;
            }
        } 
        else {
            virtualInterest_obj.duedate = null;
        }

        if (amt != null && amt != '') {
            virtualInterest_obj.outstandingamt = Decimal.valueOf(amt);
        }
        else {
            virtualInterest_obj.outstandingamt = null;
        }

        acc.Despatch_Date__c = Date.today();
        virtualInterest_obj.totalamt = null;
        showamt = false;
    }

    //method to create total virtual interest for all slabs 
    public void calculateTotal_VirtualInterest(){
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
        if (receiveddate.Despatch_Date__c == null) {
            errorMsg1 = dateNotPresentError;
            showtotalamt= false;
        }
        payments_received_date = receiveddate.Despatch_Date__c;

        //iterate over Payments outstanding records 
        for(Demands__c outstanding_obj :listDemands) {
            if (outstanding_obj.Balance_Due__c > 0 && outstanding_obj.Billing_Date__c != null) {
                // dummy date feild use for datepicker 
                if (receiveddate.Despatch_Date__c == null) {
                    errorMsg1 = dateNotPresentError;
                    showtotalamt = false;
                }
                if(outstanding_obj.Due_Date__c != null && payments_received_date!=null && outstanding_obj.Balance_Due__c != null) {
                    noOfDays = outstanding_obj.Due_Date__c.daysBetween(payments_received_date);

                    if(noOfDays<0) {
                        noOfDays =0;
                    } 
                    interestamount = (outstanding_obj.Balance_Due__c * noOfDays * rate_of_interest) / (365 * 100);
                    
                    if(interestamount<0) {
                        interestamount=0;
                    }
                    sum_interestamount += interestamount; 
                    total_virtual_interest_obj.outstandingamt += outstanding_obj.Balance_Due__c; 
                    errorMsg1=''; 
                }
            }
        }
        sum_interestamount = sum_interestamount.setScale(2);   
        total_virtual_interest_obj.totalamt = String.valueOf(sum_interestamount);
    }

    public void totalvirtualcal_clearValues() {
        errorMsg1 = '';
        receiveddate.Despatch_Date__c = Date.today();
        total_virtual_interest_obj.totalamt = null;
        showtotalamt = false;
    }

    /* Function to determine if the Background image will be displayed project wise 
     or the Default image will be displayed.*/
    public void checkBackgroundImage() 
    {
        BackgroundImageHelper.populateBackgroundImgParam(userCRN);
        isProjectWise = BackgroundImageHelper.isProjectWise;
        imageUrl = BackgroundImageHelper.imageUrl;    
    }

    /*-----New payment Detail View----------*/
    public class DemandWrapper
    {
        public String Payment_Milestone_Formula {get;set;}
        public Date Custom_Due_Date {get; set;}
        public Date Due_Date {get; set;}
        public Date Payment_received_on {get; set;}
        public Decimal Demand_amount {get; set;}
        public Decimal Amount_received {get; set;}
        public Decimal Balance_Due {get;set;}
        public String Overdue_Status {get; set;}
        public Date Billing_Date {get;set;}
        public String background_color {get; set;} 
        public Decimal cv {get;set;}
        public Demands__c objDemand {get; set;}
    }
    /*--------------------------------------*/

     //wrapper to hold details required virtual calcualtor 
    public class virtualInterest {
        public Date duedate {get;set;}
        public decimal outstandingamt {get;set;}
        public string totalamt {get;set;}
        
        public virtualInterest() {}
    }
}