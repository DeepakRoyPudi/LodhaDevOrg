public class SpFAMEBySales {

public FAME_By_Sales__c fame{get;set;}
public FAME__c fameCC{get;set;}
public String Sales_manager{get;set;}
public Id booking_id{get;set;}
public List<FAME_By_Sales__c> famelist{get;set;}
public String query;
public Booking_Information__c booking{get;set;}
public Project_Name__c projdet {get;set;}
public Wing__c wing {get;set;}
public String customer_name_details{get;set;}
public String flat_details{get;set;}
public String dateToday{get;set;}
public Task FameTask{get;set;}
public String prevFameStatus{get;set;}
public String fame_approved_date{get;set;}


public static string myid;
public SpFAMEBySales (){}
public SpFAMEBySales (ApexPages.StandardController controller) {  
  prevFameStatus = null;
  query = '';
  booking_id= ApexPages.currentPage().getParameters().get('booking');
  if(booking_id != null) {
    query = getObjectQuery('FAME_By_Sales__c', 'Booking_Information__c', String.valueof(booking_id));
    query = query + ' Order By CreatedDate DESC limit 1';
  }
  famelist = database.query(query);
  //system.debug('famelist---> '+FameList);
  if(famelist.size() == 0) {
    fame = new FAME_By_Sales__c();
  }
  else if(famelist.size() > 0) {
    fame= famelist.get(0);
    SpFAMEBySales.myid=Fame.id;
    system.debug('!!!!!!!!id'+SpFAMEBySales.myid);
    system.debug('Entered:');
    prevFameStatus = fame.FAME_Status__c;
    system.debug('prevFameStatus:' + prevFameStatus);
  }
  if(fame.Sales_Manager_User__c== null) {
    fame.Sales_Manager_User__c= UserInfo.getUserId();
    Sales_manager = UserInfo.getName();
  }
  else{
      Sales_manager =[select name from user where id=:fame.Sales_Manager_User__c].name;
  }
  getBookingInfo();
  
    if(booking.Selected_discount_type__c != 'DAM' && booking.Selected_discount_type__c != 'SCUD'){
        fame.DAM_SCUD_NA__c = True; fame.Dam_Signature_of_SM_SI_and_HOD__c=False;
    }else{
        fame.DAM_SCUD_NA__c = False;
    }
  
    if(booking.Customer_Type__c != 'Corporate'){
        fame.Customer_Type_Corporate_NA__c = True;fame.Customer_ID_proof_Comp_ID_for_Corp_book__c = False;
    }else{
        fame.Customer_Type_Corporate_NA__c = False;
    }
  
    if(projdet.Project_Type__c != 'Aspirational' && projdet.Project_Type__c != 'Hi End / Luxury' ){
        fame.Project_Type_CASA_Commercial_and_NA__c = True;fame.Deal_Closure_Form_original_photocopy__c = False;
    }else{
        fame.Project_Type_CASA_Commercial_and_NA__c = False;
    }
    //new field suggested
    fame.All_relevant_doc_incl_SCUD_DAM_NA__c=true;
    fame.Booked_BY_Channel_Partner_NA__c = True; 
    fame.Booked_BY_Channel_Partner_NA_02__c = True; 
    fame.Booked_BY_Channel_Partner_NA_03__c = True; 
    fame.Booked_BY_Channel_Partner_NA_04__c = True; 
    fame.Reap_ID_NA__c = True; 
    fame.Channel_Partner_Name_NA__c = True; 
    fame.Channel_Partner_Name__c = ''; 
    fame.Reap_ID_Name__c = '';
    fame.CP_Name_is_same_as_Know_your_deal_page__c = False;
    fame.Customer_s_signature_verification__c= False;
    fame.REAP_iREAP_ID_verification__c = False;
    fame.CP_signature_verification__c = False;
    fame.Capture_of_Channel_Partner_name__c = False;
    fame.Capture_of_Channel_Partner_Reap_ID__c = False;
        
        
    if(booking.Booking_By__c != 'referral' && booking.Booking_By__c != 'self-referral'){
        fame.Referral_Self_Referral_NA__c = True;
        fame.Channel_partner_Ref_booking_details__c=False;
    }else{
        fame.Referral_Self_Referral_NA__c = False;
    }
    
  customer_name_details = booking.Name_of_Applicant__c ;
  flat_details = wing.Project__c + '   ' + wing.Cluster_hidden__c + '   ' + wing.Name + '   ' + booking.Flat__r.Flat_no_text__c;
  FameTask = [Select Id, OwnerId, TAT_for_doc_received_by_PI__c, CreatedDate , Document_Receipt_Date_By_RM__c, Document_Receipt_Date__c, FAME_CHECKLIST_Page_URL__c  from Task where WhatId =:fame.id Order By CreatedDate DESC limit 1];
  fame.Sales_Manager_User__c= FameTask.OwnerId;
  fame.Date__c = Date.today();
  DateTime dT = System.today();
  dateToday = dT.format('MM/dd/yyyy');
}

public PageReference hold(){
    
 try {   
       string prevFameStatus2=[select id,FAME_Status__c from FAME_By_Sales__c where Booking_Information__c=:booking.id Order By CreatedDate DESC Limit 1].FAME_Status__c;
       if(prevFameStatus2 !='FAME submission'){
           fame.FAME_Status__c = '';
           fame.FAME_By_Sales_Last_saved_date__c=date.today();
           upsert fame;   
           
           fametask.Fame_by_sales_last_hold_date__c = date.today();
           update fametask;
           
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'FAME BY SALES saved Successfully')); 
       }  
       else{
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Cannot update once Submitted')); 
       }
   }
   catch(exception e){
       system.debug('!!!!!!!!!!fame save'+e);
   }
   return null;

}
public PageReference save() {  
   //system.debug('!!!!!!!!!fs'+SpFAMEBySales.myid+'-'+prevFameStatus);
   string prevFameStatus1=[select id,FAME_Status__c from FAME_By_Sales__c where Booking_Information__c=:booking.id Order By CreatedDate DESC Limit 1].FAME_Status__c;
   Integer date_diff;
   fame.FAME_Status__c = 'FAME submission';
   String err_msg;
  // Fame Validation.
   if(prevFameStatus1 == 'FAME submission'){
       ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Cannot update once Submitted'));   
       return NULL;
   }
   
  if (fame.Applicant_Co_applicant_names__c != TRUE || fame.Inventory_not_booked_in_other_name__c != TRUE || fame.Booking_date_and_consideration_value__c != TRUE || fame.Rates_offered_wrt_applicable_price_sheet__c != TRUE || fame.Flat_number_typolology__c != TRUE || fame.Current_status_of_const_relevant_field__c != TRUE || fame.Booking_amount_cheque_details_Name__c != TRUE || fame.Sign_at_all_places_according_to_photo_id__c != TRUE || fame.CRN_and_date_of_application__c != TRUE || fame.Pricesheet_attached_signed_by_applicnt__c != TRUE || fame.Preferati_original_form_Card__c != TRUE || fame.Customer_s_ID_proof__c != TRUE || (fame.overwriting_cancellation_white_ink_NA__c != TRUE && fame.Overwriting_Cancellation_White_ink_sign__c != TRUE) || (fame.Project_Type_CASA_Commercial_and_NA__c != TRUE && fame.Deal_Closure_Form_original_photocopy__c != TRUE))
  {    
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please provide all mandatory information before saving.'));   
        return NULL;
  } 
  
  //fame.Booking_Information__c = booking_id;
  fame.Date__c = Date.today();
  fame.Sales_Manager_User__c = UserInfo.getUserId();
  fame.FAME_By_Sales_Submitted_date__c=Date.today();
  //fame.Unique_key__c = 'FAME' + booking.Flat__r.Flat_no_text__c + string.valueof(booking_id);

  try {
   
   upsert fame;
   
   FameTask.Status = 'Completed';
   Update FameTask;
   
   fameCC= new FAME__c();
   fameCC.Booking_Information__c = booking.id;
   fameCC.Unique_key__c = 'FAME' + booking.Flat__r.Flat_no_text__c+ string.valueof(booking.id);
   fameCC.FAME_Task_Created_Date__c = date.today();
   insert fameCC;
   
   String baseUrl = System.URL.getSalesforceBaseUrl().getHost().remove('-api' );
   baseUrl = 'https://' + baseUrl.substring(2,6) + 'salesforce.com';   
   String fame_url = baseUrl  + '/apex/SpFAMEApproval1?booking='+ booking.id;  
   
   Id record_type_id = [Select Id from RecordType Where DeveloperName='Fame_Task'].Id;
   Task newTask = new Task(Description = 'FAME By CC Initiated for ' + booking.Oasys_Flat_Code__c,
                                        RecordTypeId = record_type_id ,
                                        Priority = 'Normal', 
                                        Status = 'Under Action by Me', 
                                        Subject = 'FAME By CC Initiated - ' + booking.Oasys_Flat_Code__c, 
                                        IsReminderSet = true,                                      
                                        ReminderDateTime = System.now()+6, 
                                        ActivityDate = date.today()+7,
                                        //OwnerId = wing.Project_Incharge_Relationship_Manager__c,
                                        OwnerId = wing.FAME_Back_end_RM__c,
                                        WhatId =  fameCC.Id,
                                        //FAME_Reason_for_Reject_or_Hold__c = fame.FAME_Reason_LOV__c,
                                        //FAME_Remarks_for_Reject_Hold__c = fame.Remarks__c,
                                        FAME_CHECKLIST_Page_URL__c = fame_url,
                                        FAME_By_Sales_Remarks__c=fame.Remarks__c);
   if(booking.Name_Of_Opportunity__r.Welcome_Call_Return_Date__c != null && booking.Name_Of_Opportunity__r.Welcome_Call_Return_Remarks__c != null){
       newTask.Welcome_Call_Resubmision__c='Welcome Call Resubmitted';
   }
   else{
       newTask.Welcome_Call_Resubmision__c='';
   }
                                        
   insert newTask;   
   
   opportunity opps=[select id,name,fame_status__c from opportunity where id=:booking.Name_Of_Opportunity__c];
   opps.fame_status__c='Pending with CC';
   update opps;   
   
   String subject = 'FAME By CC Task Initiated - ' + booking.Oasys_Flat_Code__c;
   
   //send email to FAME back end Relationship Manager
     String html_body_2 = 'Hello ' + wing.FAME_Back_end_RM__r.name + ',' + '<br/><br/> Booking for customer ' + booking.Name_of_Applicant__c + ' for booking- ' +   booking.Oasys_Flat_Code__c + ' has been initiated a FAME By CC Task. <br/>FAME by sales Remarks: ' + fame.Remarks__c + '<br/> Please click on the following link to view the same: '+ baseUrl + '/' + newTask.Id +'&nbsp; for complete details.<br/><br/>Regards,<br/>Lodha_CC_Admin';
     send_email(subject, html_body_2 , wing.FAME_Back_end_RM__c);
     
   //send email to RM TL:
     String html_body_3 = 'Hello ' + booking.Flat__r.Wing__r.RM_Team_Lead__r.Name + ',' + '<br/><br/> Booking for customer ' + booking.Name_of_Applicant__c + ' for booking- ' +   booking.Oasys_Flat_Code__c + ' has been initiated a FAME By CC Task.<br/>FAME by sales Remarks: ' + fame.Remarks__c + '<br/> Please click on the following link to view the same: '+ baseUrl + '/' + newTask.Id +'&nbsp; for complete details.<br/><br/>Regards,<br/>Lodha_CC_Admin';
     send_email(subject, html_body_3 , booking.Flat__r.Wing__r.RM_Team_Lead__c);
     
     //send email to PI:
     String html_body_4 = 'Hello ' + projdet.Project_Incharge__r.Name + ',' + '<br/><br/> Booking for customer ' + booking.Name_of_Applicant__c + ' for booking- ' +   booking.Oasys_Flat_Code__c + ' has been initiated a FAME By CC Task.<br/>FAME by sales Remarks: ' + fame.Remarks__c + '<br/> Please click on the following link to view the same: '+ baseUrl + '/' + newTask.Id +'&nbsp; for complete details.<br/><br/>Regards,<br/>Lodha_CC_Admin';
     send_email(subject, html_body_4 , projdet.Project_Incharge__c);
     
   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'FAME By Sales is Submitted Successfully and Corresponding RM notified for New Task "FAME BY CC".')); 
   //err_msg = updatebooking(fame, booking_id);
  }
  catch(DMLException e) {
    system.debug('FAME upsert failed' + e.getMessage());
    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'FAME record save failure.  ' + e.getMessage()));
    return null;
  }

  return null;
}

public String getObjectQuery(String Object_Name, String Where_param, String Where_param_value) {
  String objectName = Object_Name;  // modify as needed
  String sqlquery = 'SELECT';
  Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
 
  // Grab the fields from the describe method and append them to the queryString one by one.
  for(String s : objectFields.keySet()) {    
     sqlquery += ' ' + s + ', ';
  }

  // Strip off the last comma if it exists.
     sqlquery = sqlquery.removeEnd(', ');

  // Add FROM statement
  sqlquery += ' FROM ' + objectName;
 
  // Add on a WHERE/ORDER/LIMIT statement as needed
  sqlquery += ' WHERE ' + Where_param + ' = \''+ Where_param_value +'\''; // modify as needed 
  system.debug('sqlquery : ' + sqlquery);
  return sqlquery;
}


public void getBookingInfo() {
  
  booking = [select Name_Of_Opportunity__c,Name_Of_Opportunity__r.Welcome_Call_Return_Date__c,Name_Of_Opportunity__r.Welcome_Call_Return_Remarks__c,Flat__c,Flat__r.Wing__r.RM_Team_Lead__r.Name,Flat__r.Wing__r.RM_Team_Lead__c,Name_of_Applicant__c, Oasys_Flat_Code__c,Flat__r.Wing__c, Flat__r.Flat_no_text__c, Sales_Person__c, Sales_Person__r.Name, Project_Hidden__c, booking_status__c, Booking_By__c, Selected_discount_type__c, Customer_Type__c,CreatedById ,CreatedBy.FirstName, CreatedBy.LastName from Booking_Information__c  where Id=:booking_id ];
  projdet = [select Name, Project_Incharge__c, Site_Incharge__c, Site_Incharge__r.Name, Project_Incharge__r.Name, Project_Type__c from Project_Name__c where Name=: booking.Project_Hidden__c];
  wing = [select Project__c, Cluster_hidden__c, Name, Project_Incharge_Relationship_Manager__c,FAME_Back_end_RM__c,FAME_Back_end_RM__r.name,Project_Incharge_Relationship_Manager__r.Name from Wing__c where Id=:booking.Flat__r.Wing__c];
  
}

public void send_email(String subject, String html_body, Id receipient_id) {
  system.debug('Subject: ' + subject + ' Html_body' + html_body + ' Id: ' + receipient_id);
  Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
  mail.setBccSender(false);
  mail.setUseSignature(false);
  mail.setTargetObjectId(receipient_id);
  mail.setSubject(subject);
  mail.setHtmlBody(html_body);
  mail.setReplyTo('noreplay@LodhaGroup.com');
  mail.setSenderDisplayName('Lodha Admin');
  mail.setSaveAsActivity(false); 
  if(Test.isRunningtest()==false){
      Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
  }
}
}