/* 
Description: Controller class for visusalforce page ReferralCSS2_0
@Created by: Aditi Mulmule
@Created Date: 4/03/2015

--------------------------------------------------------------------------------
| Modified By      | Modified Date       | Version        | Description         |
--------------------------------------------------------------------------------
|Aditi Mulmule       18/03/2015           Initial Draft    Referral Information
                                                           sent through
                                                           email Functionality
--------------------------------------------------------------------------------
|Aditi Mulmule       23/03/2015            1.1            On click of Self Referred
                                                          Freeze RelationShip 
                                                          picklist
--------------------------------------------------------------------------------
|Aditi Mulmule       11/04/2015            1.2            On click of Self 
                                                          Referred ,load information
                                                          from user object and 
                                                          freeze Contact Name 
--------------------------------------------------------------------------------
|Aditi Mulmule       29/04/2015            1.3           Changed Email Validation
                                                         from Client Side to server 
                                                         side
--------------------------------------------------------------------------------
|Aditi Mulmule       06/05/2015            1.4          On click of Self 
                                                        Referred ,load information
                                                        from Account object and 
                                                        freeze Contact Name
--------------------------------------------------------------------------------
*/
public  class ReferralCSS2_0Controller {
    
    public String options { get; set; }//variable to store option from project picklist on vf
    public String salutationvalues {get;set;}
    public String contactName {get;set;} //variable to store contact name
    public Boolean selfReferred {get;set;} //variable to check contact is self referred
    public String contactNumber {get;set;} //variable to store contact Number
    public String emailId {get;set;} //variable to store contact email Id
    public String body; //variable to store body of email
    public Id  userId{get;set;} //variable to get userId of logged in user
    public String CRN {get;set;} //variable to store CRN of user
    public String response{get;set;} //String to store response of success and error
    public list<Account> CSS_DetailList{get;set;} // list to get email for particular crn
    public boolean displayPopup {get; set;}    
    public list<Project_Name__c> ProjectList{get;set;} //list of project names
    public Map<String,String> selectedProject{get;set;} //map to store id and name of projects
    public String noneValue {get;set;}
    public String relationship {get;set;}
    // Start of Google Analytics variables - Trupti Dhoka 
    public static String username {get;set;}
    public static String userProject {get;set;}
    public static String userSeqment {get;set;}
    public static DateTime userLastLogin {get;set;}  
    // End of Google Analytics variables 
    public boolean isProjectWise {get;  set;}
    public string imageUrl {get;  set;}
    public string contactNameCopy {get;set;} // variable to store account name
    public string contactEmailCopy {get;set;} //variable to store accpunt's Email
    public string contactNumberCopy {get;set;} // vairable to store account's contact no
    private static final string relationLabel ='Relationship : ';
    private static final string defaultStd_code = '22';
    private static final string defaultIsd_code = '91';
    public string std_code {get;set;}
    public string isd_code {get;set;}
    //contstructor
    public ReferralCSS2_0Controller() {
        
        initialMethod();
    }
    
    public void initialMethod() {
        userId = Userinfo.getUserid();
        CSS_DetailList= new list<Account>();
        selectedProject = new Map<String,String>();
        CRN = CreateQueryHelper.getCustomerCRN(userId);       
        
        //set initial value to variables
        
        //get RM details
        if(String.isNotBlank(CRN)) {
            std_code = defaultStd_code;
            isd_code = defaultIsd_code;
            displayPopup = false;
            
            CSS_DetailList=[Select Personal_Email__pc,
                            Name,
                            Click_To_Call__c,
                            CRN__c,
                            Owner.Email 
                            From Account
                            Where CRN__c =:CRN 
                            limit 1];
            //store values on contactName,contactEmail and  contactNumber for selfReferred checkbox                  
            contactNameCopy = CSS_DetailList[0].Name;
            contactNumberCopy = CSS_DetailList[0].Click_To_Call__c;
            
            if(contactNumberCopy.startswith('91')){
                contactNumberCopy = contactNumberCopy.remove('91');
            }
            if(contactNumberCopy.startswith('+91')){
                contactNumberCopy = contactNumberCopy.remove('+91');
            }
            contactEmailCopy = CSS_DetailList[0].Personal_Email__pc;
            noneValue ='-None-';
            relationship ='Relative';
        }
        else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
                                                        system.label.CRNvalueNull));
        }
        //Google analytics variables
        GoogleAnalyticsHelper.GetReportParameters(userId); 
        username = GoogleAnalyticsHelper.username;
        userProject =GoogleAnalyticsHelper.userProject;
        userSeqment = GoogleAnalyticsHelper.userSeqment;   
        userLastLogin= GoogleAnalyticsHelper.userLastLogin; 
        //set BackgroundImage
        this.checkBackgroundImage();
    }
    
    public void setRelationship() {
        relationship = Apexpages.currentPage().getParameters().get('relationParam'); 
    }
    
    
    //Method to send an email to account
    public void send() {
        //Send an Email     
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String interestedProject;
        String salutation;  
        String selfReferralValue;                                 
        interestedProject = selectedProject.get(options);
        salutation = salutationvalues;
        displayPopup = false;
        if(String.isBlank(interestedProject)){
            interestedProject = 'None';
        }
        if(salutation.equalsIgnoreCase(noneValue)){
            salutation = '';
        }
        
        selfReferralValue = (selfReferred ? 'Yes' : 'No');
        
        List <String> sendTo = new List <String>();
        for (Account accountObj : CSS_DetailList) {            
            sendTo.add(accountObj.Owner.Email);
        } 
        
        mail.setToAddresses(sendTo); //set addresses to send Email
        mail.setSubject(system.Label.ReferralSubject); //set Subject for Email
        body = system.Label.NameReferral+' '+ salutation+' '+contactName + system.Label.NewLine;
        body += system.Label.selfRefered+' '+ selfReferralValue + system.Label.NewLine;
        body += system.Label.EmailIDReferral+' '+ emailId + system.Label.NewLine;
        body += system.Label.ContactNoReferral +' + '+isd_code+' '+std_code+' '
            +contactNumber + system.Label.NewLine;
        body += system.Label.ProjectInterestedReferral +' '+ interestedProject
            + system.Label.NewLine;
        body += relationLabel + relationship;
        
        
        mail.setHtmlBody(body); //Set body for Email
        try{
            //send Email
            Messaging.SendEmailResult[] resultMail = Messaging.sendEmail(new
                                                                         Messaging.SingleEmailMessage[] { mail });
            //check if email has been sent successfully and display the popup
            if(resultMail[0].isSuccess())  {  
                displayPopup = true;   
                response = system.Label.ReferralSuccessMsg;
            } 
            else{
                displayPopup = true;
                response = system.Label.ErrorResponseReferral; 
            }
        }
        catch(System.EmailException ex){
            
            ApexPages.Message ErMsg = new ApexPages.Message(ApexPages.severity.ERROR,
                                                            system.Label.ErrorSendingMail);
            ApexPages.addMessage(ErMsg); 
        }   
    }
    
    /* Function to determine if the Background image will be displayed project wise 
* or the Default image will be displayed.
*/
    public void checkBackgroundImage() {
        BackgroundImageHelper.populateBackgroundImgParam(CRN);
        isProjectWise = BackgroundImageHelper.isProjectWise;
        imageUrl = BackgroundImageHelper.imageUrl;
    } 
    
    //method to close popup
    public void closePopup() {
        displayPopup = false;
    }
    //method to display project names in picklist
    public List<selectOption> getProjects() {
        List<selectOption> options = new List<selectOption>(); 
        ProjectList = new list<Project_Name__c>();
        ProjectList =[Select Name 
                      from Project_Name__c];
        options.add(new selectOption('', '- None -')); 
        selectedProject.put('', '- None -');
        for (Project_Name__c project : [SELECT Id,
                                        Name 
                                        FROM Project_Name__c]) { 
                                            
                                            options.add(new selectOption(project.id, project.Name)); 
                                            selectedProject.put(project.id, project.Name);
        }
        return options;
    }
    
}