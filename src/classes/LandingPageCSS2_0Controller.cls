/*Description:
page that exposes the Landing page functionality

 @Created by: Trupti Dhokla
 @Created Date:18/04/2015
  
 ------------------------------------------------------------------------------------------------------
 | Modified By      | Modified Date       | Version        | Description         |
 ------------------------------------------------------------------------------------------------------
 | Sneha P.            15/04/2015             1.1            Code for Background Image
 ------------------------------------------------------------------------------------------------------
 | Trupti D            7/05                   1.2            Google Analytics parameters 
 ------------------------------------------------------------------------------------------------------
 |Aditi M             26/6/2015                1.3            method for profile Completeness meter
 ------------------------------------------------------------------------------------------------------
*/
public class LandingPageCSS2_0Controller { 

    public String userId                     {get;  set;} 
    public String Customer_Name              {get;  set;}
    //Public user u                          {get;  set;}
    Public String CRN                        {get;  set;} 
    //public String dateVal                    {get;  set;}
    public list<account> RM_DetailsList      {get;  set;} //get RM details using CRN
    public list<Project_Name__c> ProjectType {get;  set;} //get Project Type 
    public list<Booking_Details__c> lstBooking_details {get;set;} //list of Booking_Details__c object  
    
    //Get custom links
    public  String welcome_Guide             {get;  set;}
    public  String Faqs                      {get;  set;}
    public  String service_offerings         {get;  set;}
    public  String my_inbox                  {get;  set;}
    public String possession_info            {get;  set;}

    //Google Analytics variables
    public static String username            {get;set;}
    public static String userCRN             {get;set;}
    public static String userProject         {get;set;}
    public static String userSeqment         {get;set;}
    public static DateTime userLastLogin     {get;set;}
    public Static Integer UserTotalLogins    {get;set;}
    // public Static Integer TotalLogins        {get;set;}//this count gives total login  
    public String currentTime                {get;set;}
    public String currentDate                {get;set;}
    public datetime myDateTime;
    public RMCSS2_0CustomSettingLinkController customlinks;  
    public boolean logoutbtn                {get;set;}
    public boolean reminderpopup            {get;set;}
    public Account account_obj              {get; set;}
    Public Booking_Information__c booking_obj {get;set;}
    public decimal profile_completeness      {get;set;} //store profileCompleteness Value
    public Decimal filled_fields;
    public RestAPICalloutController.CustomerInformationWrapper RestAPICallout_wrapper_obj {get;set;} //instance of RestAPICalloutController CustomerInformationWrapper
    public RestAPICalloutController RestAPICalloutController_obj;//instance of RestAPICalloutController
    public String address {get; set;} // To set address in personal detaill tab 
    public list<CustomerCare_Num_Setting__c> custcare_num{get;set;}
    
    //Constructor
    public LandingPageCSS2_0Controller() 
    {
        logoutbtn = false;
        reminderpopup  = false;
        String date_t = datetime.now().format('dd MMM yyyy __ hh:mm a' );
        List<String> dateTimeList=date_t.split('__');
        currentDate='';
        currentTime='';
        ProjectType = new list<Project_Name__c>();
        if(dateTimeList.size()==2)
        {
            currentDate=dateTimeList[0];
            currentTime=dateTimeList[1];
        }
        userId =Userinfo.getUserid();
        customlinks = new RMCSS2_0CustomSettingLinkController();
        try 
        {
            Customer_Name = [Select Name 
                            from user 
                            where id =: Userinfo.getUserid()].name;//get logged in users name
        }
        catch(Exception e) 
        {
            system.debug(e);
        }
            
           CRN= CreateQueryHelper.getCustomerCRN(userId);
            //get RM details
           if(String.isNotBlank(CRN))
           {
            RM_DetailsList =[Select Owner_Name__c,
                                     Owner.Name,Owner.Phone, Owner.Email, OwnerId 
                                        From Account where CRN__c =:CRN];
                                    
            lstBooking_details =  [Select Id,CRN__c,Project__c 
                                     from Booking_Details__c 
                                     where CRN__c =:CRN limit 1];
                                     
            if(lstBooking_details.size() > 0 && lstBooking_details != null){
                try{
                    ProjectType = [Select Project_Type__c,Name
                                    From Project_Name__c 
                                    where Name = :lstBooking_details [0].Project__c limit 1 ];
                }
                catch(Exception e){
                }
            }
                            
            // Google Analytics
            GoogleAnalyticsHelper.GetReportParameters(userId); 
            username = GoogleAnalyticsHelper.username;
            userCRN = GoogleAnalyticsHelper.userCRN ;
            userProject =GoogleAnalyticsHelper.userProject;
            userSeqment = GoogleAnalyticsHelper.userSeqment;   
            userLastLogin= GoogleAnalyticsHelper.userLastLogin;
            UserTotalLogins =GoogleAnalyticsHelper.UserTotalLogins ;
            //TotalLogins =GoogleAnalyticsHelper.TotalLogins ;
           
            // custom links are used for links associated to landing page
            welcome_Guide = customlinks.getWelcomeGuide();
            Faqs = customlinks.getFaqs();
            service_offerings = customlinks.getServiceOfferings();
            my_inbox = customlinks.getMyinbox();
            possession_info = customlinks.getDetailsOfPossessionProcess(); 
            custcare_num = CustomerCare_Num_Setting__c.getAll().values();              
            // Webservice fields
            RestAPICalloutController_obj = new RestAPICalloutController();
            RestAPICallout_wrapper_obj = new RestAPICalloutController.CustomerInformationWrapper();
            if(!Test.isrunningTest())
            RestAPICallout_wrapper_obj = RestAPICalloutController_obj.parseCustomerInformationJSON(CRN); //pass CRN to RestAPICalloutController method to get webservice Response    
            }
       
     
    }
    
    public PageReference init()
    {
        PageReference pageRef = null;
        //This method calculates profile completeness value used for logout functionality.
        getProfilecompleteness();
        pageRef = AuthenticateCommuntiyUserHelper.forwardToCustomAuthPage();
        if(pageRef != null)
           return pageRef;
        else return null;
    }

    /*This method counts profile completeness value*/
    public  PageReference  getProfilecompleteness() {
        profile_completeness = 0; 
        //count filled values
        filled_fields = 0;
        // total no of fields displayed on page which will be updated if any of the field is added to page 
        Decimal total_fields = 38;
        if(String.isNotBlank(CRN))
        {
            List<Account> accountLst = [Select Id,name,CRN__c,PersonEmail,Click_To_Call__c,Profile_Completeness__pc,
                                        Primary_PAN_number__c,Preferred_Mode_of_Contact__c,
                                        BillingStreet,BillingCity,BillingState,BillingCountry,
                                        TRAI_DND__c,Co_Applicant__c,DOB_Of_Client__c,Marital_Status__c,
                                        Person_email_from_trigger__c,Current_Home_ownership__c,Assets_Owned_Homes__c,
                                        Car_s_Owned__c,Club_Membership__pc,Other_residences_owned_at_Lodha_Group_CC__c,
                                        Specify_Residences_owned_at_Lodha_group__c,
                                        Ethinicity__c,Age__c, Anniversary_Date__c,Spouse_Name__c,DOB_of_Spouse__c,
                                        No_of_children__c,Children_s_DOB__c,Children_Names__c,Purpose_of_Purchase__c,
                                        Hobbies__c,Type_of_Home__c,Occupation_acc__c,Industry,Alternate_Designation__c,isPersonAccount   
                                        from Account 
                                        Where CRN__c=:CRN Limit 1]; 
        
        if(accountLst != null && accountLst.size() > 0)
        {account_obj = accountLst[0];}
        
        List<Booking_Information__c> bookingInformationList = [Select Id,
                                             CRN_Number_SAP__c, 
                                             PAN_Number_of_Co_Applicant__c
                                             From Booking_Information__c 
                                             where CRN_Number_SAP__c=:CRN              
                                             limit 1];  
            booking_obj = new Booking_Information__c();
        if(bookingInformationList.size()>0) {
               
                booking_obj = bookingInformationList[0]; 
            }                                      

         // conditions to count filled values 
        increamentCounter(account_obj.CRN__c);
        increamentCounter(account_obj.name);
        increamentCounter(account_obj.Primary_PAN_number__c);
        increamentCounter(account_obj.Co_Applicant__c);
        increamentCounter(RestAPICallout_wrapper_obj.co_applicant_2);
        increamentCounter(RestAPICallout_wrapper_obj.co_applicant_3);       
        increamentCounter(account_obj.Person_email_from_trigger__c);
        increamentCounter(account_obj.PersonEmail);
        increamentCounter(RestAPICallout_wrapper_obj.residential_status);
        increamentCounter(RestAPICallout_wrapper_obj.office_address);
        increamentCounter(RestAPICallout_wrapper_obj.time_of_communication);
        increamentCounter(address);
        increamentCounter(account_obj.Click_To_Call__c);             
        increamentCounter(account_obj.Marital_Status__c);
        increamentCounter(account_obj.Ethinicity__c);  
        increamentCounter(account_obj.Spouse_Name__c);
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
        increamentCounter(account_obj.Alternate_Designation__c );
        increamentCounter(account_obj.Preferred_Mode_of_Contact__c);
        increamentCounter(booking_obj.PAN_Number_of_Co_Applicant__c);
        
         if (account_obj.DOB_Of_Client__c != null 
             && account_obj.DOB_Of_Client__c <= Date.today()) {
                filled_fields++;
                //this is because if DOB present Age will be present 
                filled_fields++;
        }
        filled_fields++;// for age field
        if (account_obj.Anniversary_Date__c != null 
            && account_obj.Anniversary_Date__c <= Date.today()) {
                filled_fields++;
        }
        if (account_obj.DOB_of_Spouse__c != null
             && account_obj.DOB_of_Spouse__c <= Date.today()) {
                filled_fields++;
        }
        if (account_obj.No_of_children__c != null) {
            filled_fields++;
        }
        if (account_obj.Assets_Owned_Homes__c != null) {
            filled_fields++;
        }
        if (account_obj.Car_s_Owned__c!=null) {
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
        if(profile_completeness<100)
        {
            reminderpopup = true;
        }
        else
        {
          logoutbtn = true;   
        }
        }
       
        return null;
    }

    // method to check field is empty or not and if not empty increament the counter 
    //only for string values
    public void increamentCounter(String str) {
        if (!String.isBlank(str)) {
            filled_fields++;
        }
    }
    
    /*This method is used in reminder functionality for profile 
      completeness on logout button*/
    public Pagereference redirect_ProfileInfoPage()
    {
        PageReference profileinfo= new PageReference('/apex/ProfileInformationCSS2_0');
        profileinfo.setRedirect(true);
        return profileinfo;
    }
}