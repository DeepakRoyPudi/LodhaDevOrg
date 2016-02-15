/* 
Description:
Controller class for visusalforce page ProfileInformationCSS2_0
1.It describes Profile Information of Logged In user
2.Edit Functionality for Each Section is Provided except Information Registered With Lodha
@Created by: Aditi Mulmule
@Created Date: 20/03/2015

--------------------------------------------------------------------------------
| Modified By      | Modified Date       | Version        | Description         |
--------------------------------------------------------------------------------
|Aditi Mulmule       23/03/2015           Initial Draft
--------------------------------------------------------------------------------
|Aditi Mulmule       23/04/2015                            Seperate sections for 
1.1              each kind of detail
with no of children 
popup functionality
and Profile Completeness
updates meter
--------------------------------------------------------------------------------
*/

public class ProfileInformationCSS2_0Controller{   
    public RestAPICalloutController.CustomerInformationWrapper RestAPICallout_wrapper_obj {get;set;} //instance of RestAPICalloutController CustomerInformationWrapper
    public RestAPICalloutController RestAPICalloutController_obj;//instance of RestAPICalloutController
    public string CRN {get; set;} //param from vf page url
    public Account account_obj {get; set;} // account object to set account info on page 
    public Account account_objComm {get; set;}
    public Account account_objPersn {get; set;}
    public Account account_objFamily {get; set;}
    public Account account_objRes {get; set;}
    public String address {get; set;} // To set address in personal detial tab 
    public boolean iserror {get; set;} // for invalid or no CRN 
    public boolean isedit {get; set;} // editable/noneditable
    public Id  userId{get;set;}  //store ID of Loggedin user
    public String no_of_children{get;set;} //store No of Children value
    public list<ProfileWrapper> profileWrapList {get;set;} //list of ProfileWrapper that contains Child Information
    public String childrenNames{get;set;} //store Children Names appended with comma 
    public String dobChildren{get;set;} //store Date of Birth appended with comma 
    public boolean isEditCom{get;set;} // variable to edit Communication details section
    public boolean isEditPerson{get;set;} // variable to edit Personal details section
    public boolean isEditFamily{get;set;} // variable to edit Family details section
    public boolean isEditResidential{get;set;} // variable to Residential  details section
    public Despatch__c desObj {get;set;} // Contact instance for date type field Birthdate
    public boolean iserrorPopup {get;set;} // variable for displaying error or success message
    public Decimal filled_fields;
    public Integer Age {get;set;}
    // Start of Google Analytics variables - Trupti Dhoka 
    public static String username{get;set;}
    public static String userProject{get;set;}
    public static String userSeqment{get;set;}
    public static DateTime userLastLogin {get;set;}   
    // End of Google Analytics variables 
    
    public boolean isProjectWise {get;  set;}// used to check whether isProjectWise is Selected in CSSBackgroundImageSetting__c Custom setting
    public string imageUrl               {get;  set;} // variable to store Backgground Image url
    
    public decimal profile_completeness {get;set;} //store profileCompleteness Value
    Public static final String validation_msg_residences = 'No. of residences owned cannot be less than no. of residences owned at Lodha';
    Public static final String crnEmpty = 'No value for CRN';
    Public Booking_Information__c booking_obj {get;set;}
    //Contructor 
    public ProfileInformationCSS2_0Controller() 
    {   
        initialMethod();
    }
    
    public void initialMethod() {
        desObj = new Despatch__c();
        //for fields from webservice
       
          userId=Userinfo.getUserid();   
          CRN = CreateQueryHelper.getCustomerCRN(userId);  
          if(String.isNotBlank(CRN))
          {
                /* Google Analytics*/
                GoogleAnalyticsHelper.GetReportParameters(userId); 
                username = GoogleAnalyticsHelper.username;
                userProject =GoogleAnalyticsHelper.userProject;
                userSeqment = GoogleAnalyticsHelper.userSeqment;   
                userLastLogin = GoogleAnalyticsHelper.userLastLogin; 
        
                this.checkBackgroundImage();
            /*    RestAPICalloutController_obj = new RestAPICalloutController();
                RestAPICallout_wrapper_obj = new RestAPICalloutController.CustomerInformationWrapper();
                RestAPICallout_wrapper_obj = RestAPICalloutController_obj.parseCustomerInformationJSON(CRN); //pass CRN to RestAPICalloutController method to get webservice Response
            */
                getProfileInfo();  //get values from Account and webservice 
                desObj.Despatch_Date__c = null;
                iserrorPopup = false;
              
               
        }
        else
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.label.CRNvalueNull));
        }
        
    }
    
     
    //Method to save Children Details on Popup
    public PageReference saveChildDetails() {
        
        childrenNames = '';
        dobChildren = '';
        Integer index = 0;
        iserrorPopup = false;
        Integer countchild = 0;
        
        list<ProfileWrapper> tempList = new list<ProfileWrapper>();
        
        for(integer i=profileWrapList.size()-1;i>=0;i--){
            //If nameOfChild is Blank and Birthdate Has value throw error to fill nameOfChild
            if(String.isBlank(profileWrapList[i].nameOfChild) &&
                (profileWrapList[i].desObj.Despatch_Date__c!= null)){
                iserrorPopup = true;
                ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR,
                                                            system.Label.ProfilenameOfChild));
            }
            //If Birthdate is Blank and nameOfChild Has value throw error to fill Birthdate
            if(String.isNotBlank(profileWrapList[i].nameOfChild)  
                && (profileWrapList[i].desObj.Despatch_Date__c== null)){
                iserrorPopup = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
                                                           system.Label.profileDOB));
            }
            
            //If nameOfChild is not Blank and Birthdate not b null but have greater than today in date Child
            if(String.isNotBlank(profileWrapList[i].nameOfChild) &&
                (profileWrapList[i].desObj.Despatch_Date__c!= null) && (profileWrapList[i].desObj.Despatch_Date__c>Date.today())){
                iserrorPopup = true;
                ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR,
                                                            'Date of Birth cannot be future date'));
            }
            
            //For all details entered on popup check blank fields and remove them from list
            if(String.isBlank(profileWrapList[i].nameOfChild) &&
               (profileWrapList[i].desObj.Despatch_Date__c == null) &&
               (profileWrapList[i].desObj.Despatch_Date__c>Date.today()) ) {
                profileWrapList.remove(i);
            }             
        }
        //Logic for appending comma after each name and date of Birth
        if(profileWrapList.size()>0){    
            for(integer i=0; i<(profileWrapList.size()-1);i++) {                 
                if((profileWrapList[i].nameOfChild!= null && profileWrapList[i].nameOfChild!= '')
                    && (profileWrapList[i].desObj.Despatch_Date__c!=null) &&
                    (profileWrapList[i].desObj.Despatch_Date__c<=Date.today())) {
                      if(String.isBlank(childrenNames) && String.isBlank(dobChildren)) {
                        childrenNames = childrenNames + profileWrapList[i].nameOfChild +' ';
                        dobChildren = dobChildren + 
                                      String.ValueOf(profileWrapList[i].desObj.Despatch_Date__c.format())
                                      +' '; 
                       }
                       else{
                        childrenNames = childrenNames + '| '+ profileWrapList[i].nameOfChild + ' ';
                        dobChildren = dobChildren + '| '+ 
                                      String.ValueOf(profileWrapList[i].desObj.Despatch_Date__c.format()) 
                                      +' '; 
                       }
                      countchild ++;   
                      index ++;
                 }
           }
            
            
            if((profileWrapList[index].nameOfChild!= null && 
                profileWrapList[index].desObj.Despatch_Date__c!= null) && 
                (profileWrapList[index].nameOfChild!= '') && 
                (profileWrapList[index].desObj.Despatch_Date__c<=Date.today())){
                if(index == 0){
                    childrenNames = childrenNames +profileWrapList[index].nameOfChild +' ';
                    dobChildren = dobChildren +
                                  String.ValueOf(profileWrapList[index].desObj.Despatch_Date__c.format())
                                  +' '; 
                    countchild++;
                }
                else{
                    childrenNames = childrenNames + '| '+profileWrapList[index].nameOfChild +' ';
                    dobChildren = dobChildren + '| '
                                  +String.ValueOf(profileWrapList[index].desObj.Despatch_Date__c.format())+
                                  ' '; 
                    countchild++;
                }
                
            } 
            //remove time value
            dobChildren = dobChildren.remove(' 00:00:00');         
            //Save details in Account object fields
            account_objFamily.Children_Names__c = childrenNames;
            account_objFamily.Children_s_DOB__c = dobChildren;
            account_objFamily.No_of_children__c = countchild;
            no_of_children = String.valueOf(countchild);
            
            if(iserrorPopup != true) {
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,
                                                           system.Label.RecordSavedSuccessFully));
            }
        }
        //reset Values with Blank and clear Wrapper list
        else{
            account_objFamily.Children_Names__c = '';
            account_objFamily.Children_s_DOB__c = '';
            account_objFamily.No_of_children__c = countchild;
            no_of_children = String.valueOf(countchild);
            profileWrapList.clear();            
        }                
        return null;
    }
    //Method to initialize popup with already existing children details from Account Object
    public PageReference ChildPopup() {
        profileWrapList = new list<ProfileWrapper>();
        no_of_children = Apexpages.currentPage().getParameters().get('firstParam');       
        integer no ;
        list<Account> accListPopup = new list<Account>();
        if(String.isNotBlank(CRN))
        {
        //fetch field values from account
        accListPopup = [Select Children_Names__c, 
                               Children_s_DOB__c 
                        from Account 
                        Where CRN__c=:CRN 
                        limit 1];
        list<String> childList = new List<String>();
        list<date> dobList = new List<date>();
        String s1='';
        String s2='';
        //Split Children_Names__c and Children_s_DOB__c values by comma
        if(accListPopup[0].Children_Names__c!=null && accListPopup[0].Children_s_DOB__c!=null) {
            s1 = accListPopup[0].Children_Names__c;  
            s2 = accListPopup[0].Children_s_DOB__c;                 
        }          
        //Add all names to childList
        for(string str :s1.split(' \\| ')) {  
            if(String.isNotBlank(str)) {
                childList.add(str);
            }
        }
        //add all DOB to dobList
        for(String str :s2.split(' \\| ')) { 
            if(String.isNotBlank(str)) {
                dobList.add(Date.parse(str));
            }
        }
        //Add Names and DOB to wrapper of child names and dateOfBirth
        if(childList!=null && childList.size()>0){
            for(integer i=0;i<childList.size();i++) {
                profileWrapList.add(new ProfileWrapper(childList[i],dobList[i]));
            }
        }
        
        Integer val = profileWrapList.size();
        Integer num = 5 - val;                
        for(integer i=0;i<num;i++){
            profileWrapList.add(new ProfileWrapper('',null));
        }
      }  
        return null;
    }
    
    /* Function to determine if the Background image will be displayed project wise 
    * or the Default image will be displayed.
   */
    public void checkBackgroundImage() {
        
        BackgroundImageHelper.populateBackgroundImgParam(CRN);
        isProjectWise = BackgroundImageHelper.isProjectWise;
        imageUrl = BackgroundImageHelper.imageUrl;
    } 
    
    
    //method to calculate percentage of profile completed
    public void profilecompleteness() {
        profile_completeness = 0;
        //count filled values
        filled_fields = 0;
        
        /* total no of fields displayed on page which will be updated 
        if any of the field is added to page */
        Decimal total_fields = 38;
        
        // conditions to count filled values 
        increamentCounter(account_obj.CRN__c);
        increamentCounter(account_obj.name);
        increamentCounter(account_obj.Primary_PAN_number__c);
        increamentCounter(account_obj.Co_Applicant__c);
     //   increamentCounter(RestAPICallout_wrapper_obj.co_applicant_2);
     //   increamentCounter(RestAPICallout_wrapper_obj.co_applicant_3);       
        increamentCounter(account_obj.Person_email_from_trigger__c);
        increamentCounter(account_obj.PersonEmail);
    //    increamentCounter(RestAPICallout_wrapper_obj.residential_status);
    //    increamentCounter(RestAPICallout_wrapper_obj.office_address);
    //    increamentCounter(RestAPICallout_wrapper_obj.time_of_communication);
        increamentCounter(address);
        increamentCounter(account_obj.Click_To_Call__c);             
        increamentCounter(account_objFamily.Marital_Status__c);
        increamentCounter(account_objPersn.Ethinicity__c);  
        increamentCounter(account_objFamily.Spouse_Name__c);   
        increamentCounter(account_objFamily.Children_s_DOB__c);
        increamentCounter(account_objFamily.Children_Names__c);
        increamentCounter(account_objRes.Purpose_of_Purchase__c);
        increamentCounter(account_objPersn.Hobbies__c);
        increamentCounter(account_objRes.Current_Home_ownership__c);
        increamentCounter(account_objPersn.Club_Membership__pc);
        increamentCounter(account_obj.Specify_Residences_owned_at_Lodha_group__c);
        increamentCounter(account_objPersn.Industry);
        increamentCounter(account_objRes.Type_of_Home__c);
        increamentCounter(account_objPersn.Occupation_acc__c);
        increamentCounter(account_objPersn.Alternate_Designation__c );
        increamentCounter(account_objComm.Preferred_Mode_of_Contact__c);
        increamentCounter(booking_obj.PAN_Number_of_Co_Applicant__c);
        
        if (account_objPersn.DOB_Of_Client__c != null && 
            account_objPersn.DOB_Of_Client__c <= Date.today()) {
            filled_fields++;
            //this is because if DOB present Age will be present 
            filled_fields++;
        }
        if (account_objFamily.Anniversary_Date__c != null &&
            account_objFamily.Anniversary_Date__c <= Date.today()) {
            filled_fields++;
        }
        if (account_objFamily.DOB_of_Spouse__c != null && 
            account_objFamily.DOB_of_Spouse__c <= Date.today()) {
            filled_fields++;
        }
        if (account_objFamily.No_of_children__c != null) {
            filled_fields++;
        }
        if (account_objRes.Assets_Owned_Homes__c != null) {
            filled_fields++;
        }
        if (account_objPersn.Car_s_Owned__c!=null) {
            filled_fields++;
        }
        if (account_objRes.Other_residences_owned_at_Lodha_Group_CC__c != null) {
            filled_fields++;
        }
        
        if (account_objComm .TRAI_DND__c != false) {
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
    
    //get Information from Account object
    public void getProfileInfo(){
        
        if(String.isNotBlank(CRN)){              
            // account List to query feilds 
            List<Account> accountLst = [Select Id,name,CRN__c,PersonEmail,Click_To_Call__c,
                                        Profile_Completeness__pc,Primary_PAN_number__c,
                                        Preferred_Mode_of_Contact__c,BillingStreet,BillingCity,
                                        BillingState,BillingCountry,TRAI_DND__c,Co_Applicant__c,
                                        DOB_Of_Client__c,Marital_Status__c,Age__c,Hobbies__c,
                                        Person_email_from_trigger__c, Current_Home_ownership__c,
                                        Assets_Owned_Homes__c,Car_s_Owned__c,Club_Membership__pc,                                        
                                        Other_residences_owned_at_Lodha_Group_CC__c, Ethinicity__c,
                                        Specify_Residences_owned_at_Lodha_group__c,
                                        Anniversary_Date__c,Spouse_Name__c,DOB_of_Spouse__c,
                                        No_of_children__c,Children_s_DOB__c,Children_Names__c,
                                        Purpose_of_Purchase__c,Type_of_Home__c,Occupation_acc__c,
                                        Industry,Alternate_Designation__c,isPersonAccount   
                                        from Account 
                                        Where CRN__c=:CRN 
                                        limit 1]; 
                                        
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
                                                                              
            //handling null objects (if CRN  have account and do not have booking or donot have both)              
            if(accountLst.size()==1) 
            {
                iserror=false; 
                account_objComm = new Account();
                account_objPersn = new Account();
                account_objFamily = new Account();
                account_objRes = new Account();
                account_obj = accountLst[0];
                //Communication Details
                account_objComm.Id = accountLst[0].Id;
                account_objComm.TRAI_DND__c = accountLst[0].TRAI_DND__c;
                account_objComm.Preferred_Mode_of_Contact__c = accountLst[0].Preferred_Mode_of_Contact__c;
                
                //Personal Details
                account_objPersn.Id = accountLst[0].Id;
                account_objPersn.Age__c = accountLst[0].Age__c;
                account_objPersn.Occupation_acc__c = accountLst[0].Occupation_acc__c;
                
                account_objPersn.DOB_Of_Client__c = accountLst[0].DOB_Of_Client__c;
                account_objPersn.Alternate_Designation__c = accountLst[0].Alternate_Designation__c;
                account_objPersn.Ethinicity__c = accountLst[0].Ethinicity__c;
                account_objPersn.Industry = accountLst[0].Industry;
                account_objPersn.Hobbies__c = accountLst[0].Hobbies__c;
                account_objPersn.Car_s_Owned__c = accountLst[0].Car_s_Owned__c;
                account_objPersn.Club_Membership__pc = accountLst[0].Club_Membership__pc;
                
                //Family
                account_objFamily.Id = accountLst[0].Id;
                account_objFamily.No_of_children__c = accountLst[0].No_of_children__c;
                account_objFamily.Spouse_Name__c = accountLst[0].Spouse_Name__c;
                account_objFamily.DOB_of_Spouse__c = accountLst[0].DOB_of_Spouse__c;
                account_objFamily.Children_s_DOB__c = accountLst[0].Children_s_DOB__c;
                account_objFamily.Children_Names__c = accountLst[0].Children_Names__c;
                account_objFamily.Anniversary_Date__c = accountLst[0].Anniversary_Date__c;
                account_objFamily.Marital_Status__c= accountLst[0].Marital_Status__c;
                // residential
                account_objRes.Id = accountLst[0].Id;
                account_objRes.Assets_Owned_Homes__c = accountLst[0].Assets_Owned_Homes__c;
                account_objRes.Type_of_Home__c = accountLst[0].Type_of_Home__c;
                account_objRes.Other_residences_owned_at_Lodha_Group_CC__c = accountLst[0].Other_residences_owned_at_Lodha_Group_CC__c;
                account_objRes.Current_Home_ownership__c = accountLst[0].Current_Home_ownership__c;
                account_objRes.Specify_Residences_owned_at_Lodha_group__c = accountLst[0].Specify_Residences_owned_at_Lodha_group__c;
                account_objRes.Purpose_of_Purchase__c = accountLst[0].Purpose_of_Purchase__c;
                
                //address null field handling
                address = '';
                
                address =  account_obj.BillingStreet +' '+ account_obj.BillingCity +' '
                           + account_obj.BillingState +' '+ account_obj.BillingCountry;
                address = address.remove('null');           
                isedit = false;
                
                if(account_objPersn.DOB_Of_Client__c == null){
                    Age = 0;
                }
                else {
                    Date startDate = Date.today();
                    Date DOB= account_objPersn.DOB_Of_Client__c;
                    Age= DOB.daysBetween(startDate);
                    Age = Age/365;
                    if(Age<0)
                    Age = 0;
                }
                profilecompleteness();
                
            }
            else {
                iserror=true;
            }
        }
        else{
            isError=true;
        }  
    }
    
    // action for save button Communication Details Section
    public pagereference saveComm() {
        
        updateRec((sObject)account_objComm);          
        isEditCom = false;
        return null;
    }
    
    
    // action for save button Personal Details Section
    public pagereference savePersn(){
        
        
        if(account_objPersn.DOB_Of_Client__c == null){
            Age = 0;
        }
        else{
            if(account_objPersn.DOB_Of_Client__c <= Date.today()){
            Date startDate = Date.today();
            Date DOB= account_objPersn.DOB_Of_Client__c;
            Age= DOB.daysBetween(startDate);
            Age = Age/365;
            if(Age<0)
              Age = 0;
            }
            else{
             ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR,
                                                        'Date of Birth cannot be future date'));
             return null;
            }  
        }
        
        updateRec((sObject)account_objPersn);
        isEditPerson = false;
        return null;
    }
    
    // action for save button Family Details Section
    public pagereference saveFamily() {
        if(account_objFamily.DOB_of_Spouse__c <= Date.today() || account_objFamily.DOB_of_Spouse__c==null){
        updateRec((sObject)account_objFamily);
        isEditFamily = false;
        return null;
        }
        else{
         ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR,
                                                        'Spouse DOB cannot be future date'));
         return null;
        }
    }
    // action for save button Residential Details Section
    public pagereference saveRes() {
      if(account_objRes.Assets_Owned_Homes__c 
            >= account_objRes.Other_residences_owned_at_Lodha_Group_CC__c
           || (account_objRes.Assets_Owned_Homes__c == null 
           || account_objRes.Other_residences_owned_at_Lodha_Group_CC__c == null ) ) {
               updateRec((sObject)account_objRes);
               
               isEditResidential = false;
           }
        else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
                                                       validation_msg_residences));
        }
        
        return null;
    }
    public void updateRec(sObject sObj) {
        try {
            update sObj;
            profilecompleteness();
        }catch(Exception e){
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
                                                       system.Label.ErrorSavingProfileInfo));      
        }
    }
    // action for edit button Communication Details   
    public PageReference editComm() {
        
        getProfileInfo();
        isEditCom = true;
        return null;
    }
    // action for edit button Personal Details  
    public PageReference editPerson() {
        getProfileInfo();
        isEditPerson = true;
        return null;
    }
    // action for edit button Family Details  
    public pagereference editFamily() {
        getProfileInfo();
        isEditFamily = true;
        return null;
    }
    // action for edit button Residential Details  
    public pagereference editRes() {
        getProfileInfo();
        isEditResidential = true;
        return null;
    }
    //method for cancelling edit mode
    public pagereference cancelCom() {
        getProfileInfo();
        isEditCom = false;
        return null;
    }
    //method for cancelling edit mode
    public pagereference cancelPersn() {
        getProfileInfo();
        isEditPerson = false;
        return null;
    }
    //method for cancelling edit mode
    public pagereference cancelFamily() {
        getProfileInfo();
        isEditFamily = false;
        return null;
    }
    //method for cancelling edit mode
    public pagereference cancelRes() {
        getProfileInfo();
        isEditResidential = false;
        return null;
    }
    //method to add new row for new child record in No. of Children Popup
    public PageReference AddRow() {
        if(profileWrapList.size()<=4) {
            profileWrapList.add(new ProfileWrapper('',null));
        }
        else {
            ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR,
                                                        system.Label.ProfileInfoAddRow));
        }
        return null;
    }
    //Wrapper Class for Binding name and dob of Child for Children Details
      public class ProfileWrapper{
        
        public String nameOfChild{get;set;}
        public Despatch__c desObj{get;set;}
        
        public ProfileWrapper(String Child,Date DOBirth)
        {
            nameOfChild = Child;
            desObj = new Despatch__c();
            if(DOBirth == null)
            {
                desObj.Despatch_Date__c = null;
            }
            else
            {
                desObj.Despatch_Date__c = DOBirth;
            }
        }
    }
    
    
}