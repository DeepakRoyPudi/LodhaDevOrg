/* 
Description : Controller class for visusalforce page RMLandingPage
 @Created by: Shruti Nikam
 @Created Date: 25/02/2015
 
 --------------------------------------------------------------------------------
 | Modified By      | Modified Date       | Version        | Description         |
 --------------------------------------------------------------------------------
 |Sneha P.            |31/3/2015                 | 1.0           |updated with method setWidgetSequence() |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------

*/
public class RMLandingPageController1{

    public Static string CRN {get;set;} //param from vf page url
    // non static variable to be use in initialise account method contains same value of CRN
    public string CRN1 {get;set;}
    public string mobileno;
    public Account account_obj {get;set;} // account object to set account info on page 
    public String address {get;set;} // To set address in personal detial tab
    public Booking_Details__c bookingdetails_obj {get;set;} // object to set booking details
    public boolean iserror {get;set;} // for invalid or no CRN 
    public string maskphoneno {get;set;} // to mask phone no on main page
    public LoginDetailsWrapper logindetails_obj {get;set;}
    public string userphoto {get;set;} //contains user smallphotourl
    public String message {get;set;} // error message for save button
    public String errormessage {get;set;} // error message for save button
    public boolean isedit {get;set;} // editable/noneditable
    public string customer_PAN_number; // store pan no which is use to calculate loyalty points
    public RMLoyaltyPoint RMLoyaltyPoint_obj {get;set;}
    public RMServiceIndex RMServiceIndex_obj {get;set;}
    public String parking {get;set;}
    public RMSegmentIndicator RMSegmentIndicator_obj {get;set;}
    public RMCollecetionIndex RMCollecetionIndex_obj {get;set;}
    public RestAPICalloutController.CustomerInformationWrapper RestAPICallout_wrapper_obj {get;set;}
    public RestAPICalloutController RestAPICalloutController_obj;
    public Decimal profile_completeness {get;set;}
    public String project_Location {get;set;}
    public List < Booking_Information__c > bookinginformationLst;
    
    // variable for sequnces
    /* Logic to implement sequencing*/
    public String firstDiv {get;set;}
    public String secondDiv {get;set;}
    public String thirdDiv {get;set;}
    public String fourthDiv {get;set;}
    public String fifthDiv {get;set;}

    public Decimal filled_fields;
    //var End
    
    //Constructor 
    public RMLandingPageController1() {

        //access crn from url
        CRN = ApexPages.currentPage().getParameters().get('CRN');

        //handling null Mobile no 
        if (!String.isBlank(CRN)) {

            //for accepting + sign in url mob no parameter trim mobile no
            //mobileno = mobileno.trim();

            /*for checking with + in mobile no because 
              if stored mob no is contains + sign then with + or without 
              condition in below soql 
            */
           // string plusmobno = '+' + mobileno;

            // query account to get CRN having highest CV using mobile no from url 
             List<account> accList = [Select id, name, CRN__c,PersonEmail, 
                                            Click_To_Call__c, 
                                            Primary_PAN_number__c, Preferred_Mode_of_Contact__c,
                                            Special_instruction_for_RM__c,
                                            Instruction_by_PI_HOD__c, BillingStreet, BillingCity, 
                                            BillingState, BillingCountry,TDS_Related__c, TRAI_DND__c,
                                            CIP__c, Co_Applicant__c, DOB_Of_Client__c, Marital_Status__c,
                                            Person_email_from_trigger__c, Current_Home_ownership__c, 
                                            Assets_Owned_Homes__c, Car_s_Owned__c, Club_Membership__pc, 
                                            Other_residences_owned_at_Lodha_Group_CC__c,
                                            Specify_Residences_owned_at_Lodha_group__c, 
                                            AccountSource, Alternate_Designation__c,
                                            Ethinicity__c, Age__c, Anniversary_Date__c, 
                                            Spouse_Name__c, DOB_of_Spouse__c,
                                            No_of_children__c, Children_s_DOB__c, Children_Names__c, 
                                            Purpose_of_Purchase__c, Hobbies__c, Type_of_Home__c, 
                                            Occupation_acc__c, Industry, isPersonAccount, 
                                            Project_Name__c, (select id from opportunities), 
                                            (select id from CombinedAttachments), 
                                            (select id from Service_Tax_Details__r), 
                                            (select id from ActivityHistories)
                                            from Account
                                            where CRN__c =:CRN limit 1];


            //size check for List
            if (accLIst.size() >0) {
              
                account_obj=accList[0];
                
                list < Booking_Details__c > BookingDLst = [select CRN__c, Consideration_Value__c, Project__c, 
                                                            CLuster__c, Wing__c, Flat_No__c,Flat_ID__c, 
                                                            Flat_Type__c,Application_Date__c, Allotment_Date__c,
                                                            Account__r.Name,CV_paid_New__c, Account__c,Co_Applicant__c 
                                                            from Booking_Details__c
                                                            where Account__c =:account_obj.id
                                                            order by Consideration_Value__c DESC Limit 1];
                                                            
                 
                //size check for List
                if (BookingDLst.size() > 0) {
                   
                    //CRN = BookingDLst[0].CRN__c;
                    //duplicate non static variable 
                    CRN1 = BookingDLst[0].CRN__c;

                    maskmobileno();
                    
                    createAddressString();

                    bookinginformationLst =[Select CRN_Number_SAP__c, 
                                                                Stilt_Parkings__c, Other_Parkings__c,
                                                                Open_Parkings__c, MLCP_Parkings__c, 
                                                                Closed_Parkings__c,PAN_Number_of_Co_Applicant__c
                                                                from Booking_Information__c
                                                                where CRN_Number_SAP__c = : CRN Limit 1];
                    //size check for List
                    if (bookinginformationLst.size() == 1) {
                        // creating a parking pattern string 
                        createParkingString(bookinginformationLst);

                    }

                    //handling null objects (if CRN  have account and do not have booking or donot have both)              
                    if (account_obj != null && BookingDLst.size() == 1) {

                        //the widget seq method called                   
                        this.setWidgetSequence(account_obj);
                        //End of above method called

                        iserror = false;
                        //account_obj = accountLst[0];
                        bookingdetails_obj = BookingDLst[0];
                        
                        // null check if booking not null
                        project_Location=''; 
                        if(String.isNotBlank(bookingdetails_obj.Project__c)) {
                            //query to fetch project location 
                             List<Project_Name__c> ListProject_NameObj = [Select Location__c from Project_Name__c 
                                                           where Name =:bookingdetails_obj.Project__c limit 1];
                            
                            if(ListProject_NameObj!=null && ListProject_NameObj.size()>0 ){
                                Project_Name__c Project_NameObj=ListProject_NameObj[0];
                                project_Location = Project_NameObj.Location__c; 
                            }
                        }
                        
                        // concatenating Billing address in a string
                        customer_PAN_number = account_obj.Primary_PAN_number__c;
                        RestAPICalloutController_obj = new RestAPICalloutController();
                        RestAPICallout_wrapper_obj = new RestAPICalloutController.CustomerInformationWrapper();
                        RestAPICallout_wrapper_obj = RestAPICalloutController_obj.parseCustomerInformationJSON(CRN);

                        //RMLoyaltyPoint object to get loyalty points from RMLoyaltyPoint class
                        RMLoyaltyPoint_obj = new RMLoyaltyPoint(customer_PAN_number);
                        
                        //RMServiceIndex object to get service iindex from RMServiceIndex class
                        RMServiceIndex_obj = new RMServiceIndex(customer_PAN_number);

                        RMSegmentIndicator_obj = 
                            new RMSegmentIndicator(customer_PAN_number, CRN, RestAPICallout_wrapper_obj.residential_status);
                        RMCollecetionIndex_obj = 
                            new RMCollecetionIndex(customer_PAN_number);

                        List < User > usrlst = [Select id, SmallPhotoUrl 
                                                from user 
                                                where AccountId = : account_obj.Id Limit 1];
                        //Condition for user photo if no user is created

                         //login wrapper class object and the user photo initialised  
                        if (usrlst.size() > 0) {
                            //if user exist of the account then eneter the small photo url to the user photo
                            userphoto = usrlst[0].SmallPhotoUrl;
                            //if user exist then call create login data of the user 
                            logindetails_obj = new LoginDetailsWrapper(usrlst);
                        } else {
                            logindetails_obj = new LoginDetailsWrapper();
                            logindetails_obj.last_login_time = 'NA';
                            logindetails_obj.No_of_Login_Last_Month = 0;
                            logindetails_obj.Total_Login_in_Six_Month = 0;
                            logindetails_obj.Max_viewd_widget_page = 'No Pages';
                        }

                        //count profilecompletness;
                        profilecompleteness();


                        //sets Detailview non editable 
                        isedit = false;
                    } else {
                        errormessage = System.Label.RMErrorMsg_NoAccNoBook;
                        iserror = true;
                    }

                } else {

                    errormessage = System.Label.RMErrorMsg_NoBook;
                    isError = true;
                }
            } else {
                errormessage = System.Label.RMErrorMsg_NoAcc;
                isError = true;
            }
        } else {
            errormessage = System.Label.RMErrorMsg_NullMbNo;
            isError = true;
        }
    }

    
    /* This method loads the data fro personal detail bu updating profile info. 
       the method is called from close button of profile Info so that 
       it update the values in personal detail if got edited and saved 
    */
    public void intializeAccount() {

        List < Account > accountLst = [Select id, name, CRN__c, PersonEmail, Click_To_Call__c, 
                                        Primary_PAN_number__c, 
                                        Preferred_Mode_of_Contact__c, Special_instruction_for_RM__c,
                                        Instruction_by_PI_HOD__c, BillingStreet, BillingCity, 
                                        BillingState, BillingCountry,TDS_Related__c, TRAI_DND__c, 
                                        CIP__c, Co_Applicant__c, DOB_Of_Client__c, Marital_Status__c,
                                        Person_email_from_trigger__c, Current_Home_ownership__c, 
                                        Assets_Owned_Homes__c, Car_s_Owned__c, Club_Membership__pc, 
                                        Other_residences_owned_at_Lodha_Group_CC__c,
                                        Specify_Residences_owned_at_Lodha_group__c, AccountSource, 
                                        Alternate_Designation__c,Ethinicity__c, Age__c, 
                                        Anniversary_Date__c, Spouse_Name__c, DOB_of_Spouse__c,
                                        No_of_children__c, Children_s_DOB__c, Children_Names__c, 
                                        Purpose_of_Purchase__c,Hobbies__c, Type_of_Home__c, 
                                        Occupation_acc__c, Industry, isPersonAccount, Project_Name__c
                                        from Account
                                        Where CRN__c = : CRN1 Limit 1];
        
        if (accountLst.size() == 1) {
            account_obj = accountLst[0];
            maskmobileno();
            createAddressString();

        }
    }


   // Method to mask mobile no     
    public void maskmobileno() {
        maskphoneno='';
        if(String.isNotBlank(account_obj.Click_To_Call__c)){
            string p = account_obj.Click_To_Call__c;
            integer i = 0;
            while (i < p.length()) {
    
                if (i == 0) {
                    maskphoneno = p.substring(i, i + 1);
                } else if (i == 1) {
                    maskphoneno += p.substring(i, i + 1);
                } else if (i == p.length() - 1 || i == p.length() - 2) {
                    maskphoneno += p.substring(i, i + 1);
                } else {
                    maskphoneno += 'X';
                }
                i = i + 1;
    
            }
        }
    }
    //method to concatinate address of customer 
    public void createAddressString() {
        address = '';
        address = account_obj.BillingStreet + ' ' + 
            account_obj.BillingCity + ' ' + 
            account_obj.BillingState + ' ' + 
            account_obj.BillingCountry;
        address = address.remove('null');

    }



    // method to create at pattern for parking in booking details 
    public void createParkingString(List < Booking_Information__c > bookinginformationLst) {

        // Booking_Information object initialisation
        Booking_Information__c bookinginformation_obj = new Booking_Information__c();
        bookinginformation_obj = bookinginformationLst[0];
        parking = '';
        if (bookinginformation_obj.Open_Parkings__c != null || 
            bookinginformation_obj.Stilt_Parkings__c != null || 
            bookinginformation_obj.Other_Parkings__c != null || 
            bookinginformation_obj.MLCP_Parkings__c != null || 
            bookinginformation_obj.Closed_Parkings__c != null) {
            //'OP' for Open_Parkings
            if (bookinginformation_obj.Open_Parkings__c != null) {
                parking += 'OP-' + bookinginformation_obj.Open_Parkings__c + ' | ';

            }
            //'S' for Stilt_Parkings
            if (bookinginformation_obj.Stilt_Parkings__c != null) {
                parking += 'S-' + bookinginformation_obj.Stilt_Parkings__c + ' | ';

            }
            //'OT' for Other_Parkings
            if (bookinginformation_obj.Other_Parkings__c != null) {
                parking += 'OT-' + bookinginformation_obj.Other_Parkings__c + ' | ';

            }
            //'M' for MLCP_Parkings
            if (bookinginformation_obj.MLCP_Parkings__c != null) {
                parking += 'M-' + bookinginformation_obj.MLCP_Parkings__c + ' | ';

            }
            //'C' for Closed_Parkings
            if (bookinginformation_obj.Closed_Parkings__c != null) {
                parking += 'C-' + bookinginformation_obj.Closed_Parkings__c + '';
            }
        }
        // if data not available 
        else {
            parking = 'NA';
        }


    }

    //method to claculate percenyt of profile completed
    public void profilecompleteness() {
        profile_completeness = 0;
        //count filled values
        filled_fields = 0;

        // total no of fields displayed on page which will be updated if any of the field is added to page 
        Decimal total_fields = 38;

        // conditions to count filled values 
        increamentCounter(account_obj.CRN__c);
        increamentCounter(account_obj.name);
        increamentCounter(account_obj.Primary_PAN_number__c);
        increamentCounter(account_obj.Co_Applicant__c);
        increamentCounter(RestAPICallout_wrapper_obj.co_applicant_2);
        increamentCounter(RestAPICallout_wrapper_obj.co_applicant_3);
        increamentCounter(maskphoneno);
        increamentCounter(account_obj.Person_email_from_trigger__c);
        increamentCounter(account_obj.PersonEmail);
        increamentCounter(RestAPICallout_wrapper_obj.residential_status);
        increamentCounter(RestAPICallout_wrapper_obj.office_address);
        increamentCounter(RestAPICallout_wrapper_obj.time_of_communication);
        increamentCounter(address);
        //increamentCounter(String.valueOf(account_obj.DOB_Of_Client__c));
        increamentCounter(account_obj.Marital_Status__c);
        increamentCounter(account_obj.Ethinicity__c);
        //increamentCounter(String.valueOf(account_obj.Anniversary_Date__c));
        increamentCounter(account_obj.Spouse_Name__c);
        //increamentCounter(String.valueOf(account_obj.DOB_of_Spouse__c));
        increamentCounter(account_obj.Children_s_DOB__c);
        increamentCounter(account_obj.Children_Names__c);
        increamentCounter(account_obj.Purpose_of_Purchase__c);
        increamentCounter(account_obj.Hobbies__c);
        increamentCounter(account_obj.Current_Home_ownership__c);
        increamentCounter(account_obj.Club_Membership__pc);
        increamentCounter(account_obj.Specify_Residences_owned_at_Lodha_group__c);
        increamentCounter(account_obj.Industry);
        increamentCounter(account_obj.Type_of_Home__c);
        increamentCounter(account_obj.Occupation_acc__c);
        increamentCounter(account_obj.Alternate_Designation__c);
        increamentCounter(account_obj.Preferred_Mode_of_Contact__c);
        if (bookinginformationLst.size()==1) {
            increamentCounter(bookinginformationLst[0].PAN_Number_of_Co_Applicant__c);
        }
        /*if (account_obj.Age__c != null) {
            filled_fields++;
        }*/
        if (account_obj.DOB_Of_Client__c != null && 
            account_obj.DOB_Of_Client__c <= Date.today()) {
            filled_fields++;
            //this is because if DOB present Age will be present 
            filled_fields++;
        }
        if (account_obj.Anniversary_Date__c != null && 
            account_obj.Anniversary_Date__c <= Date.today()) {
            filled_fields++;
        }
        if (account_obj.DOB_of_Spouse__c != null && 
            account_obj.DOB_of_Spouse__c <= Date.today()) {
            filled_fields++;
        }
        if (account_obj.No_of_children__c != null) {
            filled_fields++;
        }
        if (account_obj.Assets_Owned_Homes__c != null) {
            filled_fields++;
        }
        if (account_obj.Car_s_Owned__c != null) {
            filled_fields++;
        }
        if (account_obj.Other_residences_owned_at_Lodha_Group_CC__c != null) {
            filled_fields++;
        }

        if (account_obj.TRAI_DND__c != false) {
            filled_fields++;
        }
        // caluclate percent
        profile_completeness = (filled_fields / total_fields) * 100;
        profile_completeness = profile_completeness.setscale(0);
    }


    // method to check field is empty or not and if not empty increament the counter 
    //only for string values
    public void increamentCounter(String str) {
        if (!String.isBlank(str)) {
            filled_fields++;
        }
    }

    //method for start widget sequencing method with logic 
    public void setWidgetSequence(Account Param_account_obj) {
        //START sequencing 
        list < String > seqList = new list < String > ();

        if (Param_account_obj != null && !String.isBlank(Param_account_obj.Project_Name__c)) {

            //query enable disable
            list < Project_Name__c > prjctName = [Select Id,
                                                    Name,
                                                    OrderType__c, (Select Id,
                                                    Name,
                                                    WidgetInfo__c,
                                                    WidgetInfo__r.Name,
                                                    isEnableForRM__c,
                                                    isEnableForCustomer__c
                                                    From EnableDisable_widgets__r)
                                                    From Project_Name__c p
                                                    where Name = : Param_account_obj.Project_Name__c];

            map < Id, EnableDisable_widgets__c > enableDisableMap = new map < Id, EnableDisable_widgets__c > ();

            if (prjctName.size() > 0 && prjctName[0].EnableDisable_widgets__r.size() > 0) {
                for (EnableDisable_widgets__c EDWidget: prjctName[0].EnableDisable_widgets__r) {
                    enableDisableMap.put(EDWidget.WidgetInfo__c, EDWidget);
                }
            }

            list < Widget_Sequence__c > widgetSeqList = new list < Widget_Sequence__c > ();

            if (prjctName.size() > 0) {
                if (prjctName[0].OrderType__c == 'Dynamic') {
                    //Get the User record for that Account
                    list < User > userList = [Select Username, FirstName, ContactId, AccountId
                    From User where AccountId = : Param_account_obj.Id];

                    widgetSeqList = [Select Project_Name__c, Project_Name__r.Name,
                        Sequence_ClickCount__c, Sequence_for__c, WidgetInfo__c,
                        WidgetInfo__r.Name,
                        User__c from
                        Widget_Sequence__c where
                        RecordTypeId = : Schema.SObjectType.Widget_Sequence__c.getRecordTypeInfosByName().get('Dynamic').getRecordTypeId()
                        AND User__c = : userList[0].id
                        Order by Sequence_ClickCount__c DESC];

                } else if (prjctName[0].OrderType__c == 'Custom') {
                    // Query the sequence from 'Widget Sequence' object where record type is default 
                    widgetSeqList = [Select Project_Name__c, Project_Name__r.Name,
                        Sequence_ClickCount__c, Sequence_for__c, WidgetInfo__c,
                        WidgetInfo__r.Name,
                        User__c from
                        Widget_Sequence__c where Sequence_for__c = : 'RM'
                        AND
                        Project_Name__c = : prjctName[0].Id AND
                        RecordTypeId = : Schema.SObjectType.Widget_Sequence__c.getRecordTypeInfosByName().get('Custom').getRecordTypeId()
                        Order by Sequence_ClickCount__c];
                }

                if (prjctName[0].OrderType__c == 'Default' || widgetSeqList.size() == 0) {

                    // Query the sequence from 'Widget Sequence' object where record type is default 
                    widgetSeqList = [Select Project_Name__c, Project_Name__r.Name,
                            Sequence_ClickCount__c, Sequence_for__c, WidgetInfo__c,
                            WidgetInfo__r.Name,
                            User__c from
                            Widget_Sequence__c where Sequence_for__c = : 'RM'
                            AND
                            RecordTypeId = : Schema.SObjectType.Widget_Sequence__c.getRecordTypeInfosByName().get('Default').getRecordTypeId()
                            Order by Sequence_ClickCount__c];
                }
                for (Widget_Sequence__c widgetSeq: widgetSeqList) {

                    if (!enableDisableMap.isEmpty() && 
                        enableDisableMap.containsKey(widgetSeq.WidgetInfo__c) && 
                        enableDisableMap.get(widgetSeq.WidgetInfo__c).isEnableForRM__c) {

                        seqList.add(widgetSeq.WidgetInfo__r.Name);
                    }
                }
            }
        }
        //set the widget Sequence
        if (seqList.size() > 0) firstDiv = seqList[0];
        if (seqList.size() > 1) secondDiv = seqList[1];
        if (seqList.size() > 2) thirdDiv = seqList[2];
        if (seqList.size() > 3) fourthDiv = seqList[3];
        if (seqList.size() > 4) fifthDiv = seqList[4];
        //END   
    }
    //End widget sequecing method with logic

    public PageReference gotoConstructionUpadatePage(){
      
           PageReference redirectPage = Page.RMConstructionUpadate;          
           redirectPage.getParameters().put('CRN',CRN1);
           return redirectPage;
    
    } 
    

    
    // Wrapper class for login detials 
    public class LoginDetailsWrapper {

        public String last_login_time {get;set;}
        public Integer No_of_Login_Last_Month {get;set;}
        public Integer Total_Login_in_Six_Month {get;set;}
        public String Max_viewd_widget_page {get;set;}
        //non paramererize constructor
        public LoginDetailsWrapper() {}
        //paramerize constructor
        public LoginDetailsWrapper(List < user > usrlst) {
            // check if user is present  
            if (usrlst.size() == 1) {
                //user object to get login info
                User usr = new User();
                usr = usrlst[0];

                List < loginHistory > lohhistry = [SELECT LoginTime 
                    FROM LoginHistory 
                    where userID = : usr.id  
                    order by LoginTime Desc NULLS LAST Limit 1];
                List < Widget_Sequence__c > WidgetSList = 
                    [select WidgetInfo__r.name, Sequence_ClickCount__c 
                        from Widget_Sequence__c 
                        where User__c = : usr.id 
                        order by Sequence_ClickCount__c DESC nulls last limit 1];

                if (lohhistry.size() > 0) {
                    loginHistory loginhistory_obj = new loginHistory();
                    loginhistory_obj = lohhistry[0];
                    this.last_login_time = loginhistory_obj.LoginTime.format('dd MMM yyyy hh:mm a');
                    this.No_of_Login_Last_Month = 
                        (Integer)[select count(LoginTime) logincount 
                            FROM LoginHistory where userID = : usr.id 
                            and LoginTime = Last_Month][0].get('logincount');
                    this.Total_Login_in_Six_Month = 
                        (Integer)[SELECT count(LoginTime) logincountsix 
                            FROM LoginHistory where userID = : usr.id][0].get('logincountsix');
                    if (WidgetSList.size() > 0) {
                        this.Max_viewd_widget_page = WidgetSList[0].WidgetInfo__r.name;
                    } else {
                        this.Max_viewd_widget_page = 'No data available';
                    }

                } else {
                    this.last_login_time = 'No data available';
                    this.No_of_Login_Last_Month = 0;
                    this.Total_Login_in_Six_Month = 0;
                    this.Max_viewd_widget_page = 'No data available';
                }
            }

        }

    }


    
}