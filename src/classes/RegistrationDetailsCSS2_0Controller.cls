/* 
Description: 
Controller class for visusalforce page RegistrationDetailsCSS2_0
It Describes Registration Details of Logged in User

@Created by: Aditi Mulmule
@Created Date: 26/03/2015

--------------------------------------------------------------------------------
| Modified By      | Modified Date       | Version        | Description         |
--------------------------------------------------------------------------------
|Aditi Mulmule      26/03/2015            Initial Draft    Functionality in 
                                                           Progress (UI with Static data)
--------------------------------------------------------------------------------
|Sudeep Dube        2/06/2015                              Schedule and reschedule 
                                                           date time from case
                                                           registration.
--------------------------------------------------------------------------------
| Sudeep Dube        3/7/2015                              Implement Draft Aggremnet link Functionlity 
                                                           with Hide show logic of the same link.                               
--------------------------------------------------------------------------------

*/
public class RegistrationDetailsCSS2_0Controller {
    
    //registration page variables
    public String Draft_Agreement_Link { get; set; } //Link on Page
    
    //below variable blnShowAgreementButton,STRBOOKINGSTATUS,STRHYDERABAD Used in show hide Draft Link
    public Boolean blnShowAgreementButton { get; set; } //show Hide draft link
    //STRBOOKINGSTATUS is the booking status used in booking details__r query in where clause
    private static final String STRBOOKINGSTATUS = 'Inactive';
    //static string for Hyderabad special condition for Hyderabad 
    @Testvisible private static final String STRHYDERABAD = 'Hyderabad';
    public Boolean blnIsFirstView {get; set;}
    public String strDocumentId;
    BoxIntegrationHelper oBoxIntegrationHelper;
    public String strViewAgreementUrl {get; set;}
    public String strAgreementUrl {get; set;}    
    public Boolean blnRenderIframe {get; set;}
    //is messsage show to page the message is only show when %cv<lower limit
    //and the message is not show when %c >higer limit and link also not visible
    public Boolean ShowMessage{get;set;}
    
    public RestAPICalloutController.CustomerInformationWrapper RestAPICallout_wrapper_obj {get;set;}// RestAPICalloutController 
    public Id  userId {get;set;} //variable to store user Id
    public String CRN {get;set;} //store CRN of logged in user
    public String registration_link {get;set;}//store url for registration
    public String registered_agreement_link {get;set;}
    public Account account_obj {get;set;}
    //schedule and reschedule date and time variable for the page
  //  public Case caseforReschedule;
  //  public String schedule_Date{get;set;}   
  //  public String schedule_time{get;set;}  
    
  //  public String reSchedule_Date{get;set;}   
  //  public String reSchedule_time{get;set;}  
    // boolean for edit and rendered the edit section on click for edit reschedule date on registration page
    public Boolean isEdit{get;set;}
    // boolean which used to render the link request for reschedule to be show or not shown
    public Boolean isQueryTypeCaseExist{get;set;}
    //for salesforce date picker stage data field as dummy used and not be stored in database
  //  public case virtualcase{get;set;}
  //   public Time virtualTime{get;set;}
    
    //show , close  and popup related variable
  //  public String response{get;set;}
  //  public boolean displayPopUp{get;set;}
    
    
    //this variables for background image
    public boolean isProjectWise {get;  set;} // used to check whether isProjectWise is Selected in CSSBackgroundImageSetting__c Custom setting
    public string imageUrl  {get;  set;} // variable to store Backgground Image url
    
    // Start of Google Analytics variables - Trupti Dhoka
    public static String username{get;set;}
    public static String userProject{get;set;}
    public static String userSeqment{get;set;}
    public static DateTime userLastLogin {get;set;}
    // End of Google Analytics variables Trupti Dhoka
    //constructor initially loads links and fields from webservice on page
    public RegistrationDetailsCSS2_0Controller(){
         
        //initialization for css draft link visdiblity
        strDocumentId='';
        blnShowAgreementButton =false;
        blnIsFirstView=false;
        oBoxIntegrationHelper = new BoxIntegrationHelper();
        strAgreementUrl = '';
        blnRenderIframe = false;
        ShowMessage=false;
        
        
        //for reschedule request render control variable intialization
       // isEdit=false;
      //  isQueryTypeCaseExist=false;
        //for email render control variable intialization
      //  displayPopUp=false;
        userId = Userinfo.getUserid();      
        CRN = CreateQueryHelper.getCustomerCRN(userId); //Pass user Id and get CRN
        RestAPICalloutController RestAPICalloutController_obj = new RestAPICalloutController();
        RestAPICallout_wrapper_obj = new RestAPICalloutController.CustomerInformationWrapper();
        RestAPICallout_wrapper_obj = RestAPICalloutController_obj.parseCustomerInformationJSON(CRN);    
        if(String.isNotBlank(CRN))
        {   
            //To get fields from webservice,pass CRN to  RestAPICalloutController method    
           Account acc_obj = new Account();
           acc_obj =[select Id,
                                  Count_of_View_Agreement__c,
                                  owner.Email,
                                  lastname, 
                                  //IsFeedbackFormSubmitted__c,
                                  //Date_Of_Possession_Trigger__c,
                           (select Id,
                                   CV_paid_New__c,
                                   Registered_Date__c,
                                   CLuster__c,
                                   Project__c,
                                   Rs_100_Agreement_Date__c,
                                   Total_Demands_Received__c,
                                   Consideration_Value__c
                            from Booking_Details__r
                            where Status__c != :STRBOOKINGSTATUS
                            order by createdDate desc
                            limit 1
                           )
                           From account Where CRN__c=:CRN 
                           limit 1];
            if(acc_obj!=null) {
               account_obj = acc_obj;
            }
          /*  list<case> listcaseforReschedule = [SELECT caseNumber,  
                                                Date_Confirm_Time_place_of_Registratio__c, 
                                                Date_Request_for_rescheduling_the_regist__c 
                                                FROM Case 
                                                WHERE AccountID = :account_obj.Id 
                                                AND Request_for_L1__c='Registration Related' 
                                                AND Request_for_L2__c='Scheduling (SDR already paid)' 
                                                AND Request_for_L3__c INCLUDES
                                                ('Confirm Time & place of Registration') 
                                                ORDER BY Date_Confirm_Time_place_of_Registratio__c
                                                DESC NULLS 
                                                last limit 1];
            
            
            if(listcaseforReschedule.size()>0){
                caseforReschedule=listcaseforReschedule[0];
                if(caseforReschedule!=null){
                    //intialize reschedule Date with default value as today date because it can not less than today
                    
                    //true the boolean that type of case record exist using the above query 
                    isQueryTypeCaseExist=true;
                    virtualcase=new case();
                    virtualcase.Stage_Date__c=System.Today();
                    virtualTime=System.now().time();
                    //extract date and time from datetime field for schedule and rescedule
                    if(caseforReschedule.Date_Confirm_Time_place_of_Registratio__c!=null){
                        String date_t = caseforReschedule.Date_Confirm_Time_place_of_Registratio__c.format('dd MMM yyyy __ hh:mm a' );   
                        List<String> dateTimeList=date_t.split('__');
                        schedule_Date='';
                        schedule_time='';
                        if(dateTimeList.size()==2){
                            schedule_Date=dateTimeList[0];
                            schedule_time=dateTimeList[1];
                        }
                    }
                    if(caseforReschedule.Date_Request_for_rescheduling_the_regist__c!=null){
                        String date_t = caseforReschedule.Date_Request_for_rescheduling_the_regist__c.format('dd MMM yyyy __ hh:mm a' );   
                        List<String> dateTimeList=date_t.split('__');
                        reSchedule_Date='';
                        reSchedule_time='';
                        if(dateTimeList.size()==2){
                            reSchedule_Date=dateTimeList[0];
                            reSchedule_time=dateTimeList[1];
                        }
                    }
                } 
            }  */
        
        
        //fetch registration guidelines link and Draft_Agreement_Link
        RMCSS2_0CustomSettingLinkController reglinks=new RMCSS2_0CustomSettingLinkController();
        registration_link = reglinks.getRegistrationLink();
        registered_agreement_link = reglinks.getRegisteredAgreementLink();
      
        /* Google Analytics*/
        GoogleAnalyticsHelper.GetReportParameters(userId); 
        username = GoogleAnalyticsHelper.username;
        userProject =GoogleAnalyticsHelper.userProject;
        userSeqment = GoogleAnalyticsHelper.userSeqment;   
        userLastLogin= GoogleAnalyticsHelper.userLastLogin; 
        this.checkBackgroundImage();
        } 
    }
    
    //function for toggle edit boolean variable for rerender the rechedule visit edit section 
  /*  public void toggleEdit(){
        
        if(isEdit==true){
            isEdit=false;
        }else{
            isEdit=true; 
        } 
    } */
    
    
    /* Function to determine if the Background image will be displayed project wise 
* or the Default image will be displayed.
*/
    public void checkBackgroundImage() {
        BackgroundImageHelper.populateBackgroundImgParam(CRN);
        isProjectWise = BackgroundImageHelper.isProjectWise;
        imageUrl = BackgroundImageHelper.imageUrl;
    } 
    
   /* public void sendEmailToRM(){
        
        if(caseforReschedule!=null  ){
            if(virtualcase.Stage_Date__c>=System.Today() && virtualcase.Stage_Date__c!=null){
                if((virtualTime>=System.now().time()|| virtualcase.Stage_Date__c>System.Today())
                   && virtualTime!=null ){
                       
                       Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                       List <String> sendTo = new List <String>();                     
                       sendTo.add(account_obj.Owner.Email);
                       
                       mail.setToAddresses(sendTo);
                       String salesforceRecordURL=System.Label.SalesforceBaseURLInstance+'/'
                           +caseforReschedule.id+'/e';
                       String body = 'You have Requested for Recheduling Registration <br/> By:'
                                     +account_obj.lastname +'<br/> CRN No:'+CRN+'<br/>';
                       body += 'Case No: '+caseforReschedule.caseNumber+'<br/> Reschedule Date:'
                               +virtualcase.Stage_Date__c+'<br/> Time:'+ virtualTime ;
                       body +='<br/>For go to case <a href='+salesforceRecordURL+
                              '>click Here</a> <br/>';
                       mail.setSubject('Rescheduling Resitration Case');
                       mail.setHtmlBody(body);
                       try {
                           Messaging.SendEmailResult[] resultMail = 
                                   Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                           if(resultMail[0].isSuccess())  { 
                               displayPopup = true;
                               response = System.Label.Registration_success_response;
                               toggleEdit();
                           } 
                           else{
                               displayPopup = true;
                               response = system.Label.ErrorResponseReferral; 
                           }
                       }
                       catch(System.EmailException ex)
                       {
                           response = ex.getMessage();
                       }
                       
                   }
                else{
                    
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                                                         system.Label.registration_time_validation);
                    ApexPages.addMessage(myMsg);
                }
            }
            else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                                                           system.label.registration_date_validate);
                ApexPages.addMessage(myMsg);
            }    
        }
        else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                                                     system.label.Registration_case_does_not_exist);
            ApexPages.addMessage(myMsg);
        }
        
    }//end of method  */
    
  /*  public void closePopup() {
        
        displayPopup = false;
    } */
    
    
       //Method that displays the Agreement in the IFrame
    public PageReference viewAgreement() {
        
        //Generate the Session URL
        if(!String.isBlank(strDocumentId)){
          if(!Test.isRunningTest()) {
                strAgreementUrl = oBoxIntegrationHelper.generateSessionUrl(strDocumentId);
                strAgreementUrl = oBoxIntegrationHelper.generateSessionUrl(strDocumentId);
            }
            else{
                strAgreementUrl = '1234';
               } 
        }
        if(!String.isBlank(strAgreementUrl)){
        
            if(account_obj!=null){
                Account objAccount = new Account();
                objAccount = account_obj;
            
                objAccount.Count_of_View_Agreement__c = (objAccount.Count_of_View_Agreement__c != NULL) ? (objAccount.Count_of_View_Agreement__c + 1) : 1;             
                Database.SaveResult objSaveResult = Database.update(objAccount);
                blnIsFirstView = false;
            }        
        
            strViewAgreementUrl = strAgreementUrl;
            blnRenderIframe = true;
        }        
        return null;
    }
    
    
    
    //Method executes on page load and identifies if the 'View Agreement' button should be enabled/disabled
    //based on set conditions
    public void enableViewAgreementButton(){
        
        List<Booking_Details__c> listBooking = new List<Booking_Details__c>();
        List<Project_Name__c> listProjectName = new List<Project_Name__c>();
        List<Cluster__c> listCluster = new List<Cluster__c>();
        
        //Retrieve the Account related information
        if(account_obj!=null){
            listBooking = account_obj.Booking_Details__r;
         
            blnIsFirstView = (account_obj.Count_of_View_Agreement__c < 1 ||account_obj.Count_of_View_Agreement__c == NULL) ? true : false;    //Check if User is View the Agreement for the First Time
            
            if(!listBooking.isEmpty()){
                
                if(!String.isBlank(listBooking[0].CLuster__c) && 
                   !String.isBlank(listBooking[0].Project__c) &&
                   listBooking[0].CV_paid_New__c >= View_Agreement_CV_Limits__c.getOrgDefaults().CV_Paid_Lower_Limit__c && //5
                   listBooking[0].CV_paid_New__c <= View_Agreement_CV_Limits__c.getOrgDefaults().CV_Paid_Upper_Limit__c){  //35
                    //Method call out to retrieve the Box Configuration information from the custom settings
                    BoxConfiguration objBoxConfiguration = this.getDocumentUrl(listBooking[0].CLuster__c, listBooking[0].Project__c);
                    
                    //Verify if the Document Url is not blank
                    if(!String.isBlank(objBoxConfiguration.strDocumentUrl)){
                        
                        //Verify what Project Location the current Booking Detail belongs to
                        //If Project Location is Hyderabad make a check on 'Rs. 100 Agreement Date' field
                        if(!String.isBlank(objBoxConfiguration.strProjectLocation) && 
                           objBoxConfiguration.strProjectLocation.equalsIgnoreCase(STRHYDERABAD)){
                            
                            if(listBooking[0].Rs_100_Agreement_Date__c == NULL){
                                blnShowAgreementButton = true;
                            
                            }
                        }
                   
                        //If Project Location is other than Hyderabad make a check on 'Registered' field
                        if(String.isBlank(objBoxConfiguration.strProjectLocation) ||
                           !objBoxConfiguration.strProjectLocation.equalsIgnoreCase(STRHYDERABAD)){
                            
                            if(listBooking[0].Registered_Date__c == NULL){
                                blnShowAgreementButton = true;
                            }
                        }
                        
                        if(blnShowAgreementButton ){
                            if(!Test.isRunningTest())
                                strDocumentId = 
                                    oBoxIntegrationHelper.generateDocumentId(objBoxConfiguration.strDocumentUrl);
                            else
                                strDocumentId = '1234';    
                        }
                    }
                }
                //below if condition checks when the %cv of booking < org level lower limit then the 
                // message will be shown that, pay min amount of cv on vf page 
                // if %cv >upper limit then no message no link will be displaon the vf page
                if(listBooking[0].CV_paid_New__c < View_Agreement_CV_Limits__c.getOrgDefaults().CV_Paid_Lower_Limit__c){
                 ShowMessage=true;
                }
            }
            
          
            //Logic to idnetify the visibility of Possession Feedback Form
            //if(listAccount[0].Date_Of_Possession_Trigger__c != NULL)
                //blnIsCutOffDateReached = (((listAccount[0].Date_Of_Possession_Trigger__c + 30) <= Date.today()) && !listAccount[0].IsFeedbackFormSubmitted__c) ? true : false;
            //blnIsFeedbackFormAvailable = (!listAccount[0].IsFeedbackFormSubmitted__c && !blnIsCutOffDateReached && listAccount[0].Date_Of_Possession_Trigger__c != NULL) ? true : false;            
        }//If
    }//enableViewAgreementButton
    
    
    
    
     //Method returns the Document URL based on the Project Name and the Cluster Name defined in the booking details
    public BoxConfiguration getDocumentUrl(String pClusterName, String pProjectName){
        
        BoxConfiguration oBoxConfiguration = new BoxConfiguration();
        List<BoxConfiguration__c> listBoxConfiguration = BoxConfiguration__c.getAll().values();
        
        for(BoxConfiguration__c objBoxConfig : listBoxConfiguration){
            if(pClusterName.equalsIgnoreCase(objBoxConfig.Cluster_Name__c) && 
               pProjectName.equalsIgnoreCase(objBoxConfig.Project_Name__c) &&
               objBoxConfig.Is_Available__c &&
               !String.isBlank(objBoxConfig.Box_Agreement_Url__c)){
               
                //return objBoxConfig.Box_Agreement_Url__c;
                oBoxConfiguration.strDocumentUrl = !(String.isBlank(objBoxConfig.Box_Agreement_Url__c)) ? objBoxConfig.Box_Agreement_Url__c : '';
                oBoxConfiguration.strProjectLocation = !(String.isBlank(objBoxConfig.Project_Location__c)) ? objBoxConfig.Project_Location__c : '';  
            }
        }
        
        return oBoxConfiguration;
    }
    
    //Inner Class to store the Box Configuration information
    public class BoxConfiguration{
    
        public String strDocumentUrl {get; set;}
        public String strProjectLocation {get; set;}
        
        public BoxConfiguration(){
            
            strDocumentUrl = '';
            strProjectLocation = '';
        }
    }
}