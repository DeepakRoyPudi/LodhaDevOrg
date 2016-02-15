/*<!-- VisualForce Compoenent for submit a query 
@Created by: Trupti Dhoka
@Created Date: 04/03/2015

--------------------------------------------------------------------------------
| Modified By      | Modified Date       | Version        | Description         |
--------------------------------------------------------------------------------
|Trupti Dhoka       18/03/2015               1.1            updated validation for 
                                                            input fields
--------------------------------------------------------------------------------
|Trupti Dhoka       23/03/2015               1.2            added functionality for showing 
                                                            modal popup
--------------------------------------------------------------------------------
|Aditi Mulmule      02/06/2015               1.3             1.Functionality for creating
                                                             case for every query 
                                                             2.Included L1 picklist on page
                                                             3.Removed Email Functionality
--------------------------------------------------------------------------------
|Aditi Mulmule      08/07/2015               1.4             1.Removed Subject field of case updation
------------------------------------------------------------------------------------

-->*/

public class SubmitQueryCSS2_0Controller {
    public String response{get;set;} // Variable to store message displayed in popup after case creation
    public Id  userId{get;set;} // Store userId of logged in user
    public String CRN {get;set;} //Store CRN value
    public boolean displayPopup {get; set;} // Boolean to show and hide popup
    public Case case_obj {get;set;} // Create caseObj
    public Account account_obj{get;set;} 
    // Constants for Email content
    private static final String subjectEmail ='CSS Case Initiation Notification | Case No.';
    private static final String subjectEmail2 = ' | CRN ';
    private static final String dear = 'Dear ';
    private static final String comma =',';
    private static final String emailContent1 ='This is to notify that a case # ';
    private static final String emailContent2 = ' has been initiated by ';
    private static final String withString =' with ';
    private static final String emailContent3 =' from the CSS Portal.';
    private static final String emailContent4 = ' This is for your kind information and further action. ';
    private static final String regards = ' Regards';
    private static final String emailContent5 =' SFDC Admin ';
    private static final String onString = ' on ';
    //constructor
    public SubmitQueryCSS2_0Controller(){   
        init();
    }
    // Initial method to query on account if CRN is not null
    public void init()
    {
        userId=Userinfo.getUserid();
        CRN = CreateQueryHelper.getCustomerCRN(userId);
        if(String.isNotBlank(CRN)) {
           account_obj = new Account();
           reintializeCase();
           account_obj = [Select Id,Name,
                                 Owner.Email,
                                 Owner.Name
                          from Account
                          where CRN__c=:CRN];
           displayPopup = false;
        }
        else {
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                                                            system.label.CRNvalueNull);
            ApexPages.addMessage(errorMsg);
        }
        
    }
    // Function to close popup
    public PageReference closePopup() 
    {
        reintializeCase();
        displayPopup = false;
        String currentPageUrl = ApexPages.currentPage().getURL().toLowerCase();
        Integer qIndex = currentPageUrl.indexOf('?');
        if (qIndex >= 0) {
        currentPageUrl = currentPageUrl.substring(0, qIndex);
        }
        if(!currentPageUrl.equalsIgnoreCase(Page.HomeCSS2_0.getURL() ) ){
         
           return null;    
        }
        PageReference newPage  = Page.HomeCSS2_0;
        newPage.setRedirect(true);
       return newPage;
    }
    // Function to create case and send email to RM with query details
    public PageReference submitQuery()
    {
        
        String body; //variable to store body of Email
        
        // Validation for subject and description must contain a value
        if(case_obj.Request_for_L1__c ==null && String.isBlank(case_obj.Description)) {
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                                                             system.label.SubmitAQueryRelatedToAndDescriptionError);
            ApexPages.addMessage(errorMsg);
        }
        // Validation for required field Request_for_L1__c
        else if(case_obj.Request_for_L1__c ==null) {
            ApexPages.Message errorMsgRelatedTo = new ApexPages.Message(ApexPages.Severity.ERROR,system.label.SubmitAQueryBroadlyRelatedTo);
            ApexPages.addMessage(errorMsgRelatedTo);
        }
        // If description is blank throw error
        else if(String.isBlank(case_obj.Description)) {
            ApexPages.Message errorMsgDes = new ApexPages.Message(ApexPages.Severity.ERROR,system.label.SubmitAQueryDescriptionError);
            ApexPages.addMessage(errorMsgDes);
        } 
        
        else {
              if(account_obj!=null) {
                case_obj.AccountId = account_obj.Id;
                case_obj.recordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CM_Parent_Only').getRecordTypeId();
                case_obj.Interaction_Mode__c = 'CSS';
                case_obj.Communication_Type__c = 'Inbound';
                case_obj.Status ='Open';
                case_obj.Nature_of_Request__c='Query'; 
                case_obj.Request_for_L2__c='L2';
                case_obj.Request_for_L3_a__c='L3';
                case_obj.Request_for_L3__c='L3'; 
                insert case_obj;
                
                Case caseInserted = new Case();
                caseInserted = [Select CaseNumber,CreatedDate
                                from Case
                                Where Id=:case_obj.Id
                                limit 1];
                                
                
                // Logic for sending email to RM
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                List <String> sendTo = new List <String>();                     
                sendTo.add(account_obj.Owner.Email);
               
                mail.setToAddresses(sendTo);
                body = dear + account_obj.Owner.Name + comma + system.Label.NewLine;
                body += system.Label.NewLine;
                body += emailContent1+caseInserted.CaseNumber+emailContent2+account_obj.Name+withString;
                body += CRN +onString+caseInserted.CreatedDate.format('dd MMM yyyy hh:mm a')
                        +emailContent3+system.Label.NewLine;
                body += emailContent4+system.Label.NewLine;
                body += system.Label.NewLine;
                body += regards +comma+system.Label.NewLine;
                body += emailContent5;
                mail.setSubject(subjectEmail+caseInserted.CaseNumber+subjectEmail2+CRN);
                mail.setHtmlBody(body);
                try
                {
                    Messaging.SendEmailResult[] resultMail = 
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                    if(resultMail[0].isSuccess()) { 
                       displayPopup = true;
                       response = system.label.SubmitAQuerySuccessMessage;
                    } 
                    else {
                        displayPopup = true;
                        response = system.Label.ErrorResponseReferral; 
                    }
                }
                catch(System.EmailException ex) {
                    ApexPages.Message ErMsg = new ApexPages.Message(ApexPages.severity.ERROR,
                                                                system.Label.ErrorSendingMail);
                ApexPages.addMessage(ErMsg); 
                } 
                reintializeCase();
            }
        }
        return null;
    }
    // Method to initialize case object
    public void reintializeCase() {
        case_obj = new Case();
    }
    
    
}