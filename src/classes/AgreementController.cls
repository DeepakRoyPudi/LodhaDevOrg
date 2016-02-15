/*
*    Description : Apex Controller class for Agreement.page to be displayed on 'Agreement' tab on Customer Portal
*    
*    Version            Author            Date            Description
*
*    1.0                Siddharth         13/05/2014      Initial Draft
*
*    1.1                Siddharth         11/08/2014      Code Development for including 'Possession Feedback
*                                                         Form' Button on Home Page
*/

public class AgreementController {

    private static final String STRBOOKINGSTATUS = 'Inactive';
    private static final String STRHYDERABAD = 'Hyderabad';
    
    @TestVisible String strDocumentId;
    BoxIntegrationHelper oBoxIntegrationHelper;
    
    public Boolean blnRenderIframe {get; set;}
    public Boolean blnShowAgreementButton {get; set;}    //Boolean variale to show/hide the Agreement Button
    public String strViewAgreementUrl {get; set;}
    public String strAgreementUrl {get; set;}    
    public Boolean blnIsFirstView {get; set;}
    public Boolean blnIsFeedbackFormAvailable {get; set;}
    public Boolean blnIsCutOffDateReached {get; set;}
    
    // Variables
    List<Account> listAccount = new List<Account>();
    
    public AgreementController() {
        
        strDocumentId = '';
        
        blnShowAgreementButton = false;
        blnRenderIframe = false;
        blnIsFirstView = false;
        blnIsFeedbackFormAvailable = false;
        blnIsCutOffDateReached = false;
        
        strAgreementUrl = '';
        oBoxIntegrationHelper = new BoxIntegrationHelper();
    }
    
    //Method returns the Account Id of the Currently Logged In User
    public void getAccountRecord(){
    
        //Get the User
        List<User> listCurrentUser = [Select Id,
                                             AccountId
                                      from User
                                      where Id = :UserInfo.getUserId()
                                      limit 1];
                                      
        if(!listCurrentUser.isEmpty()){
            
            listAccount = [select Id,
                                  Count_of_View_Agreement__c,
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
                           from Account
                           where Id = :listCurrentUser[0].AccountId
                           limit 1];
        }
    }
    
    //Method that displays the Agreement in the IFrame
    public PageReference viewAgreement() {
        
        //Generate the Session URL
        if(!String.isBlank(strDocumentId)){
        	if(!Test.isRunningTest())
                strAgreementUrl = oBoxIntegrationHelper.generateSessionUrl(strDocumentId);
            else
                strAgreementUrl = '1234';
        }
        
        if(!String.isBlank(strAgreementUrl)){
        	 
            this.getAccountRecord();
        
            if(!listAccount.isEmpty()){
            
                Account objAccount = new Account();
                objAccount = listAccount[0];
            
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
        
        this.getAccountRecord();        //Retrive the Account Record and associated details for the currently logged in User
        
        //Retrive the Account related information
        if(!listAccount.isEmpty()){
        
            listBooking = listAccount[0].Booking_Details__r;
            
            blnIsFirstView = (listAccount[0].Count_of_View_Agreement__c < 1 || listAccount[0].Count_of_View_Agreement__c == NULL) ? true : false;    //Check if User is View the Agreement for the First Time
            
            if(!listBooking.isEmpty()){
                
                if(!String.isBlank(listBooking[0].CLuster__c) && 
                   !String.isBlank(listBooking[0].Project__c) &&
                   listBooking[0].CV_paid_New__c >= View_Agreement_CV_Limits__c.getOrgDefaults().CV_Paid_Lower_Limit__c && //9.9
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
                        
                        if(blnShowAgreementButton){
                            if(!Test.isRunningTest())
                                strDocumentId = oBoxIntegrationHelper.generateDocumentId(objBoxConfiguration.strDocumentUrl);
                            else
                                strDocumentId = '1234';    
                        }
                    }
                }
            }
            
            //Siddharth 1.1
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