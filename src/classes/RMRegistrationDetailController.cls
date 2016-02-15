/*
Description:
class is used as controller in VFcomponent name Rmsidebar component 
and this class object is created in LandingPageCSS2_0Controller,registiondetailscontroller for acceessing the methods 
the class contains methods which access custom setting records url and convert it with the http prefix
 
@Created by: Sudeep Kumar Dube 
 @Created Date: 27/03/2015
 
 --------------------------------------------------------------------------------
 | Modified By      | Modified Date       | Version        | Description         |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------
 | Aditi Mulmule     04/06/2015             1.2             1.Changes in Registration 
                                                               Details Popup for Resheduling Dates
                                                               by user and mail functionality to
                                                               send email to RM
 | Aditi Mulmule     17/06/2015             1.3             Changed Universal Standard to
                                                            Universal Standard and Responses.
                                                            Removed Responses Link.                                                            
 --------------------------------------------------------------------------------

*/

public class RMRegistrationDetailController {

    //constant declaration and definitions 
    //public static final String Responses = 'Responses';
    public static final String RegistrationGuidelines = 'RegistrationGuidelines';
    
    //page parameters 
    public string CRNval {get;set;}
    public string registration_charges{get;set;}
    public string stamp_duty{get;set;}
    public string registration_date{get;set;}
    public string registration_status{get;set;}
    public string registration_challan_date{get;set;}
    
   // public String copyCRN;
    public Account account_obj;
    //schedule and reschedule date and time variable for the page
    public Case caseforReschedule;
    public Date schedule_Date {get;set;}
    public Time schedule_time {get;set;}

    public Date reSchedule_Date {get;set;}
    public Time reSchedule_time {get;set;}

    // boolean for edit and rendered the edit section on click for edit reschedule date on registration page
    public Boolean isEdit {get;set;}
    // boolean which used to render the link request for reschedule to be show or not shown
    public Boolean isQueryTypeCaseExist {get;set;}

    //for sales force date picker stage data field as dummy used and not be stored in database
    public case virtualcase {get;set;}
    public Time virtualTime {get;set;}

    //show , close  and popup related variable
    public String response {get;set;}
        //public boolean displayPopUp {get;set;}
    //constructor
    public RMRegistrationDetailController() {
     
    }

    public void getIntialMethod() {
        
        CRNval=ApexPages.currentPage().getParameters().get('CRN'); 
        registration_charges=ApexPages.currentPage().getParameters().get('charges'); 
        stamp_duty=ApexPages.currentPage().getParameters().get('stampDuty'); 
        registration_date=ApexPages.currentPage().getParameters().get('Date'); 
        registration_status=ApexPages.currentPage().getParameters().get('Status'); 
        registration_challan_date=ApexPages.currentPage().getParameters().get('challanDate');   
        system.debug('CEN:::'+CRNval);
        if (String.isNotBlank(CRNval)) {
            //copyCRN=CRNval;
           
            list<Account> accountList= [select id,
                                       owner.Email,
                                       lastname 
                                       from account 
                                       where crn__c = : CRNval 
                                       limit 1];
                 
           if(accountList.size()>0){
                account_obj=accountList[0];
           if (account_obj != null) {
                list <case> listcaseforReschedule = 
                    [SELECT caseNumber, Date_Confirm_Time_place_of_Registratio__c, 
                    Date_Request_for_rescheduling_the_regist__c
                    FROM Case
                    where AccountID = : account_obj.id 
                    and Request_for_L1__c = 'Registration Related'
                    and Request_for_L2__c = 'Scheduling (SDR already paid)'
                    and Request_for_L3__c INCLUDES('Confirm Time & place of Registration')
                    ORDER BY Date_Confirm_Time_place_of_Registratio__c DESC NULLS last Limit 1];
             
                if (listcaseforReschedule.size() > 0) {
                    System.debug('list have data22');
                    caseforReschedule = listcaseforReschedule[0];
                    if (caseforReschedule != null) {
                        //intialize reschedule Date with default value as today date because it can not less than today

                        //true the boolean that type of case record exist using the above query 
                        isQueryTypeCaseExist = true;

                        virtualcase = new
                        case ();
                        virtualcase.Stage_Date__c = System.Today();
                        virtualTime = System.now().time();
                        
                        //extract date and time from datetime field for schedule and rescedule
                        if (caseforReschedule.Date_Confirm_Time_place_of_Registratio__c != null) {
                        DateTime dt = caseforReschedule.Date_Confirm_Time_place_of_Registratio__c;
                        schedule_Date = Date.newinstance(dT.year(), dT.month(), dT.day());
                        schedule_time = caseforReschedule.Date_Confirm_Time_place_of_Registratio__c.time();
                        }
                        if (caseforReschedule.Date_Request_for_rescheduling_the_regist__c != null) {
                            DateTime dt = caseforReschedule.Date_Request_for_rescheduling_the_regist__c;
                           reSchedule_Date = Date.newinstance(dT.year(), dT.month(), dT.day());
                           reSchedule_time = caseforReschedule.Date_Request_for_rescheduling_the_regist__c.time();
                        }
                    }
                }

            }
          } 
        }
        
    }

   
 

    //function for toggle edit boolean variable for rerender the rechedule visit edit section 
    public void toggleEdit() {

        if (isEdit == true) {
            isEdit = false;
        } else {
             isEdit = true;
             
             if(virtualcase!=null) {
                 virtualcase.Stage_Date__c = System.Today();
                 virtualTime = System.now().time();
             }
        }
    }

    public void sendEmailToRM() {
       
        if (caseforReschedule != null) {

            if (virtualcase.Stage_Date__c >= System.Today() && 
                    virtualcase.Stage_Date__c != null) {

                if ((virtualTime >= System.now().time() || 
                            virtualcase.Stage_Date__c > System.Today()) && 
                                virtualTime != null) {

                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    //string[] toaddress = New String[] {'sudeepkdube@gmail.com'};
                    List < String > sendTo = new List < String > ();
                    sendTo.add(account_obj.Owner.Email);

                    mail.setToAddresses(sendTo);
                    String salesforceRecordURL = System.Label.SalesforceBaseURLInstance + 
                        '/' + caseforReschedule.id + '/e';
                    String body = 'You have Requested for Rescheduling Registration <br/> By: ' 
                        + account_obj.lastname + '<br/> CRN No: ' + CRNval + '<br/>';
                    body += 'Case No: ' + caseforReschedule.caseNumber + 
                        '<br/> Reschedule Date: ' + virtualcase.Stage_Date__c + 
                        '<br/> Time: ' + virtualTime;
                    body += '<br/>For go to case <a href=' + 
                        salesforceRecordURL + '>click Here</a> <br/>';
                    mail.setSubject('Rescheduling Registration Case ');
                    mail.setHtmlBody(body);
                    try {
                        Messaging.SendEmailResult[] resultMail = 
                            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {
                            mail
                        });
                        if (resultMail[0].isSuccess()) {
                            // displayPopup = true;
                            // response = response_success;
                            ApexPages.Message myMsg = 
                                new ApexPages.Message(ApexPages.Severity.CONFIRM, 
                                                      System.Label.Registration_success_response);
                            ApexPages.addMessage(myMsg);
                            toggleEdit();
                        } else {
                            //displayPopup = true;
                            //response = response_error;
                            ApexPages.Message myMsg = 
                                new ApexPages.Message(ApexPages.Severity.ERROR, 
                                                      system.Label.ErrorResponseReferral);
                            ApexPages.addMessage(myMsg);
                        }
                    } catch (System.EmailException ex) {
                        response = ex.getMessage();
                    }

                } else {
                    
                    ApexPages.Message myMsg = 
                        new ApexPages.Message(ApexPages.Severity.ERROR, 
                                              system.Label.registration_time_validation);
                    ApexPages.addMessage(myMsg);
                }
            } else {
                ApexPages.Message myMsg = 
                    new ApexPages.Message(ApexPages.Severity.ERROR,
                                          system.label.registration_date_validate);
                ApexPages.addMessage(myMsg);
            }
        } else {
            ApexPages.Message myMsg = 
                new ApexPages.Message(ApexPages.Severity.ERROR,
                                      system.label.Registration_case_does_not_exist);
            ApexPages.addMessage(myMsg);
        }

    } //end of method
/*
    public void closePopup() {

        displayPopup = false;
    }
*/
    //all below methods acces custom setting links 
    //check if not http or https prefix and then it add into the URL and return it 

   
    public String getRegistrationLink() {

        return createUrl(RegistrationGuidelines);

    }
    

    public string createUrl(string urlfor) {
        Customer360AndCSS2_0Links01__c Customer360AndCSS2_0Links01_obj = 
                    Customer360AndCSS2_0Links01__c.getvalues(urlfor);
        String url;

        if (Customer360AndCSS2_0Links01_obj != null && !String.isBlank(Customer360AndCSS2_0Links01_obj.Links__c)) {
            url = Customer360AndCSS2_0Links01_obj.Links__c;
           
        }
        if (String.isBlank(url)) {
            url = '#';
            return url;
        } else {
            if (!(url.startsWith('http://') || url.startsWith('https://'))) {

                url = 'http://' + url;
            }
            return url;
        }
    }
}