/*
*   Description: Apex Controller class for SpFAMEApprovalProcess page
*   
*   Version    Date          Name       Description
*     1.1      05/06/2014    Asmita     Code modification for fixing the issue: List has No Rows for Assignment
*/

public class SpFAMEApprovalProcess {

	// Properties
	public FAME__c fame{get;set;}
	public String relationship_manager{get;set;}
	public Id booking_id{get;set;}
	public List<FAME__c> famelist{get;set;}
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
	
	// Variable
	public SpFAMEApprovalProcess(){}
	
	// Constructor
    public SpFAMEApprovalProcess(ApexPages.StandardController controller) {  
        prevFameStatus = null;
        query = '';
        
        // Modified by- Asmita Description- Initialization for resolving list has no rows for assignment issue
        wing = new Wing__c(); 
        
        booking_id= ApexPages.currentPage().getParameters().get('booking');
        
        if(booking_id != null) {
            query = getObjectQuery('FAME__c', 'Booking_Information__c', String.valueof(booking_id));
            query = query + ' Order By CreatedDate DESC limit 1';
        }
        famelist = database.query(query);
        //system.debug('famelist---> '+FameList);
        if(famelist.size() == 0) {
            fame = new FAME__c();
        }
        else if(famelist.size() > 0) {
            fame= famelist.get(0);
            system.debug('Entered:');
            prevFameStatus = fame.FAME_Status__c;
            system.debug('prevFameStatus:' + prevFameStatus);
        }
        if(fame.Relationship_Manager__c == null) {
            fame.Relationship_Manager__c = UserInfo.getUserId();
            relationship_manager = UserInfo.getName();
        }
        getBookingInfo();
  		
        if(booking.Selected_discount_type__c != 'DAM' && booking.Selected_discount_type__c != 'SCUD'){
            fame.DAM_SCUD_NA__c = True; fame.Dam_Signature_of_SM_SI_and_HOD__c=False;
        }
        else{
            fame.DAM_SCUD_NA__c = False;
        }
  
        if(booking.Customer_Type__c != 'Corporate'){
            fame.Customer_Type_Corporate_NA__c = True;fame.Customer_ID_proof_Company_ID_for_Corp__c = False;
        }
        else{
            fame.Customer_Type_Corporate_NA__c = False;
        }
  
        if(projdet.Project_Type__c != 'Aspirational' && projdet.Project_Type__c != 'Hi End / Luxury' ){
            fame.Project_Type_CASA_Commercial_and_NA__c = True;fame.Deal_Closure_Form_original_photocopy__c = False;
        }
        else{
            fame.Project_Type_CASA_Commercial_and_NA__c = False;
        }
  
        if(booking.Booking_By__c != 'Channel Partner'){
            fame.Booked_BY_Channel_Partner_NA__c = True; 
            fame.Booked_BY_Channel_Partner_NA_02__c = True; 
            fame.Booked_BY_Channel_Partner_NA_03__c = True; 
            fame.Booked_BY_Channel_Partner_NA_04__c = True; 
            fame.Reap_ID_NA__c = True; 
            fame.Channel_Partner_Name_NA__c = True; 
            fame.Channel_Partner_Name__c = ''; 
            fame.Reap_ID_Name__c = '';
            fame.CP_Name_is_same_as_Know_your_deal_page__c = False;
            fame.Customers_signature_verification__c = False;
            fame.REAP_iREAP_ID_verification__c = False;
            fame.CP_signature_verification__c = False;
            fame.Capture_of_Channel_Partner_name__c = False;
            fame.Capture_of_Channel_Partner_Reap_ID__c = False;
        }
        else{
            fame.Booked_BY_Channel_Partner_NA__c = False; 
            fame.Booked_BY_Channel_Partner_NA_02__c = False; 
            fame.Booked_BY_Channel_Partner_NA_03__c = False; 
            fame.Booked_BY_Channel_Partner_NA_04__c = False; 
            fame.Reap_ID_NA__c = False; 
            fame.Channel_Partner_Name_NA__c = False;
        }
  
        if(booking.Booking_By__c != 'referral' && booking.Booking_By__c != 'self-referral'){
            fame.Referral_Self_Referral_NA__c = True;  fame.Channel_partner_Ref_booking_details__c=False;
        }
        else{
            fame.Referral_Self_Referral_NA__c = False;
        }
    
        customer_name_details = booking.Name_of_Applicant__c ;
        flat_details = wing.Project__c + '   ' + wing.Cluster_hidden__c + '   ' + wing.Name + '   ' + booking.Flat__r.Flat_no_text__c;
        FameTask = [Select Id, OwnerId, TAT_for_doc_received_by_PI__c, CreatedDate , Document_Receipt_Date_By_RM__c, Document_Receipt_Date__c, FAME_CHECKLIST_Page_URL__c  from Task where WhatId =: fame.id Order By CreatedDate ASC limit 1];
        if(FameTask.Document_Receipt_Date__c != null) {
            fame.DATE_OF_FORM_RECEIPT_FROM_SALES_TEAM__c = FameTask.Document_Receipt_Date__c;
        }
        else {
            fame.DATE_OF_FORM_RECEIPT_FROM_SALES_TEAM__c = FameTask.Document_Receipt_Date_By_RM__c;
        }
        fame.Relationship_Manager__c = FameTask.OwnerId;
        fame.TAT_for_doc_received_by_PI__c = String.valueOf(FameTask.TAT_for_doc_received_by_PI__c);
        fame.Date__c = Date.today();
        DateTime dT = System.today();
        dateToday = dT.format('MM/dd/yyyy');
        
	}// end of Constructor
	
	// Method
	public PageReference populate_reject_date() {
	
	    if(fame.FAME_Status__c == 'Reject' || fame.FAME_Status__c == 'Hold') {
	        fame.Form_Reject_On_Hold_Date__c = Date.today();
	    }
	    else {
	        fame.Form_Reject_On_Hold_Date__c = null;
	    }
	
	    return null;
	}// end of populate_reject_date()
	
	
	// Method
	public PageReference save() {  
        Integer date_diff;
        Boolean IsExceptiononRejection; 
        IsExceptiononRejection=false;
        String err_msg;
        // Fame Validation.
        if((prevFameStatus == 'Accept' && fame.FAME_Status__c != 'Accept') || (prevFameStatus == 'Reject' && fame.FAME_Status__c != 'Reject')){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Cannot change Fame Status, when Fame is Accepted/Rejected'));   
            return NULL;
        }
   
        if ((fame.FAME_Status__c == 'Accept' || fame.FAME_Status__c == 'FAME Approved (Welcome Call Pending)')&& (fame.Applicant_Co_applicant_names__c != TRUE || fame.Inventory_not_booked_in_other_name__c != TRUE || fame.Booking_date_and_consideration_value__c != TRUE || fame.Rates_offered_wrt_applicable_price_sheet__c != TRUE || fame.Flat_number_typolology__c != TRUE || fame.Current_status_of_const_relevant_field__c != TRUE || fame.Booking_amount_cheque_details_Name__c != TRUE || fame.Sign_at_all_places_according_to_photo_id__c != TRUE || fame.CRN_and_date_of_application__c != TRUE || fame.Pricesheet_attached_signed_by_applicnt__c != TRUE || fame.Preferati_original_form_Card__c != TRUE || fame.Customers_ID_proof__c != TRUE || (fame.overwriting_cancellation_white_ink_NA__c != TRUE && fame.Overwriting_Cancellation_White_ink_sign__c != TRUE) || (fame.Project_Type_CASA_Commercial_and_NA__c != TRUE && fame.Deal_Closure_Form_original_photocopy__c != TRUE) || (fame.Capture_of_Channel_Partner_Reap_ID__c == True && (fame.Reap_ID_Name__c == NULL || fame.Reap_ID_Name__c == '')) || (fame.Reap_ID_NA__c != True && fame.Capture_of_Channel_Partner_Reap_ID__c != TRUE) || (fame.Capture_of_Channel_Partner_name__c == True && (fame.Channel_Partner_Name__c == NULL || fame.Channel_Partner_Name__c == '')) || (fame.Channel_Partner_Name_NA__c != True && fame.Capture_of_Channel_Partner_name__c != TRUE) || (fame.CP_Name_is_same_as_Know_your_deal_page__c != TRUE && fame.Booked_BY_Channel_Partner_NA__c != TRUE) || (fame.Customers_signature_verification__c != TRUE && fame.Booked_BY_Channel_Partner_NA_02__c != TRUE) || (fame.REAP_iREAP_ID_verification__c != TRUE && fame.Booked_BY_Channel_Partner_NA_03__c != TRUE) || (fame.CP_signature_verification__c != TRUE && fame.Booked_BY_Channel_Partner_NA_04__c != TRUE)))
        {    
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please provide all mandatory information before saving.'));   
            return NULL;
        } 
  
        if(fame.DATE_OF_FORM_RECEIPT_FROM_SALES_TEAM__c == null ) {
            if(fame.FAME_Status__c == 'Reject' && fame.FAME_Reason_LOV__c == 'Form not received from sales within 5 days of submission of Fame Task'){
                IsExceptiononRejection=true;
            }
            else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please provide Date of document receipt'));   
                return null;       
            }
        }//end of if
        else{
            date_diff= Date.valueof(FameTask.CreatedDate).daysBetween(fame.DATE_OF_FORM_RECEIPT_FROM_SALES_TEAM__c);  
        }
  
        if(date_diff < 0 && IsExceptiononRejection==false) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please provide Date of document receipt greater than task creation date'));   
            return NULL;
        }
  
        if(fame.FAME_Status__c == 'Reject' && fame.Form_Reject_On_Hold_Date__c == NULL) 
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Date of FAME reject and On hold should not blank.'));   
            return NULL; 
        }
   
  
        if((fame.FAME_Status__c == 'Reject' || fame.FAME_Status__c == 'Hold') && fame.FAME_Reason_LOV__c == null) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please provide reason before saving the record.'));   
            return NULL;
        }   
        fame.Booking_Information__c = booking_id;
        fame.Date__c = Date.today();
        fame.Relationship_Manager__c = UserInfo.getUserId();
        //fame.Unique_key__c = 'FAME' + booking.Flat__r.Flat_no_text__c + string.valueof(booking_id);
 
  
        try {
             upsert fame;
             err_msg = updateBooking(fame, booking_id);
        }
        catch(DMLException e) {
            system.debug('FAME upsert failed' + e.getMessage());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'FAME record save failure.  ' + e.getMessage()));
            return null;
        }

        if(err_msg != null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'FAME record saved but with errors.  ' + err_msg)); 
        }
        else {   
            if(fame.FAME_Status__c == 'Reject') {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'FAME is Rejected and the Project In-charge has been notified.'));     
            }
            else if(fame.FAME_Status__c == 'Accept') {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'FAME is Accepted Successfully.')); 
            }
            else if(fame.FAME_Status__c == 'Hold') {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'FAME is put on Hold and the Project In-charge has been notified.')); 
            }
            else if(fame.FAME_Status__c == 'FAME Approved (Welcome Call Pending)') {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'FAME is Approved and welcome call pendng and the SM has been notified.')); 
            }
            prevFameStatus = fame.FAME_Status__c;
        }// end of else
        
        return null;
	}// end of save()
	
	// Method
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
	}// end of getObjectQuery()
	
	
	// Method
	public void getBookingInfo() {
	  
	    booking = [select Name_Of_Opportunity__c, Flat__c,Name_of_Applicant__c, Oasys_Flat_Code__c,Flat__r.Wing__c, Flat__r.Flat_no_text__c, Sales_Person__c, Sales_Person__r.Name, Project_Hidden__c, booking_status__c, Booking_By__c, Selected_discount_type__c, Customer_Type__c,CreatedById ,CreatedBy.FirstName, CreatedBy.LastName from Booking_Information__c  where Id=:booking_id ];
	    projdet = [select Name, Project_Incharge__c, Site_Incharge__c, Site_Incharge__r.Name, Project_Incharge__r.Name, Project_Type__c from Project_Name__c where Name=: booking.Project_Hidden__c];
	    if(booking.Flat__r != null)
	    	wing = [select Project__c, Cluster_hidden__c, Name, Project_Incharge_Relationship_Manager__c, Project_Incharge_Relationship_Manager__r.Name from Wing__c where Id=:booking.Flat__r.Wing__c];
	    else
	    	wing = new Wing__c();
    }// end of getBookingInfo()
	
	// Method: updateBooking
    public String updateBooking(FAME__c fame, Id booking_id) {
        string error = null;
        String sUrlRewrite = ApexPages.currentPage().getHeaders().get('Host');
        String object_record_link = 'https://'+ sUrlRewrite.substring(2,6) + 'salesforce.com' + '/' + fame.id;

        string SM_name=[select id,name from user where id=:booking.sales_person__c].name;
        string Booking_createdby_name=[select id,name from user where id=:booking.CreatedById].name;

        boolean processed = false;
        //Booking_Information__c booking_info = [select Name_Of_Opportunity__c, Name_of_Applicant__c, Sales_Person__c, booking_status__c, Flat__c from Booking_Information__c where Id=:booking_id];
        Opportunity opp = [select Name,FAME_Return_Date__c, FAME_Return_Remarks__c from Opportunity where Id =: booking.Name_Of_Opportunity__c];
  
        if(fame.FAME_Status__c == 'FAME Approved (Welcome Call Pending)') {
            if(prevFameStatus != 'FAME Approved (Welcome Call Pending)') {
                prevFameStatus = 'FAME Approved (Welcome Call Pending)';
                if(fame.FAME_Approved_Date__c == NULL) {
                    fame.FAME_Approved_Date__c = Date.today();   
                    DateTime dT = System.today();
                    string date_Today = dT.format('MM/dd/yyyy');
                    fame_approved_date = date_Today;
                }
   
                //send email to SM
                String subject = 'FAME Approved (Welcome call pending)- ' + booking.Oasys_Flat_Code__c;
                String html = 'Hello ' + Booking_createdby_name + ' ,' + '<br/><br/> The FAME Status of the Booking for customer ' + booking.Name_of_Applicant__c + ' for ' +   booking.Oasys_Flat_Code__c + ' is  '+ fame.FAME_Status__c + '<br/>Remarks: ' + fame.Remarks__c + '<br/>Regards,<br/>Lodha_CC_Admin';
                String html_sm = 'Hello ' + SM_name+ ' ,' + '<br/><br/> The FAME Status of the Booking for customer ' + booking.Name_of_Applicant__c + ' for ' +   booking.Oasys_Flat_Code__c + ' is  '+ fame.FAME_Status__c + '<br/>Remarks: ' + fame.Remarks__c + '<br/>Regards,<br/>Lodha_CC_Admin';
     
                if(booking.CreatedById == booking.sales_person__c){
                    //send mail to SM         
                    send_email(subject, html ,booking.CreatedById);
                }
                else if(booking.CreatedById != booking.sales_person__c){
                    //send mail to SM created by        
                    send_email(subject, html ,booking.CreatedById);
       
                    //send mail to SM actual       
                    send_email(subject, html_sm ,booking.sales_person__c);
                }    
     
                //send email to SI
                String html_body_1 = 'Hello ' + projdet.Site_Incharge__r.Name + ',' + '<br/><br/> The FAME Status of the Booking for customer ' + booking.Name_of_Applicant__c + ' for ' +   booking.Oasys_Flat_Code__c + ' is  '+ fame.FAME_Status__c + '<br/>Remarks: ' + fame.Remarks__c + '<br/>Regards,<br/>Lodha_CC_Admin';
                send_email(subject, html_body_1 , projdet.Site_Incharge__c);
     
                //send email to PI
                String html_body_2 = 'Hello ' + projdet.Project_Incharge__r.Name + ',' + '<br/><br/> The FAME Status of the Booking for customer ' + booking.Name_of_Applicant__c + ' for ' +   booking.Oasys_Flat_Code__c + ' is  '+ fame.FAME_Status__c + '<br/>Remarks: ' + fame.Remarks__c + '<br/>Regards,<br/>Lodha_CC_Admin';
                send_email(subject, html_body_2 , projdet.Project_Incharge__c);
   
                //send email to RM
                String html_body_3 = 'Hello ' + wing.Project_Incharge_Relationship_Manager__r.Name + ',' + '<br/><br/> The FAME Status of the Booking for customer ' + booking.Name_of_Applicant__c + ' for ' +   booking.Oasys_Flat_Code__c + ' is  '+ fame.FAME_Status__c + '<br/>Remarks: ' + fame.Remarks__c + '<br/>Regards,<br/>Lodha_CC_Admin';
                send_email(subject, html_body_3 , wing.Project_Incharge_Relationship_Manager__c);
            }// end of if
  
        }// end of if
 
        if(fame.FAME_Status__c == 'Reject') {
            booking.booking_status__c = 'FAME RETURN';
            fame.Form_Reject_On_Hold_Date__c = Date.today();
            try {
                update booking;
                processed = true;
                opp.FAME_Return_Date__c = fame.Date__c;
                opp.FAME_Return_Remarks__c = fame.Remarks__c;
                try {
                    update opp;
                    processed = true;
                }
                catch(DMLException e) {
                    processed = false;
                    error = e.getMessage();
                    system.debug('Opportunity upddate failed' + e.getMessage());
                }
            }
            catch(DMLException e) {
                processed = false;
                error = e.getMessage();
                system.debug('Booking update failed for FAME reject' + e.getMessage());
            }
        
            if(processed == true && prevFameStatus != 'Reject' && prevFameStatus != 'Accept') {
   	   
                prevFameStatus = 'Reject';
                FameTask.Document_Receipt_Date_By_RM__c = fame.DATE_OF_FORM_RECEIPT_FROM_SALES_TEAM__c;
                FameTask.Status = 'Completed';
                try {
                    Update FameTask;
                }
                catch(DMLException e) {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error:' + e.getMessage()));   
                    return null;
                }
            
                Id record_type_id = [Select Id from RecordType Where DeveloperName='Fame_Task'].Id;
                Task newTask = new Task(Description = 'FAME Rejected',
                                    RecordTypeId = record_type_id ,
                                    Priority = 'Normal', 
                                    Status = 'Under Action by Me', 
                                    Subject = 'FAME Rejected - ' + booking.Oasys_Flat_Code__c, 
                                    IsReminderSet = true,                                      
                                    ReminderDateTime = System.now()+6, 
                                    ActivityDate = date.today()+7,
                                    OwnerId = projdet.Site_Incharge__c,
                                    WhatId =  fame.Id,
                                    FAME_Reason_for_Reject_or_Hold__c = fame.FAME_Reason_LOV__c,
                                    //FAME_Remarks_for_Reject_Hold__c = fame.Remarks__c,
                                    FAME_CHECKLIST_Page_URL__c = object_record_link);
                                        
                insert newTask;    
     
                String subject = 'FAME Rejected - ' + booking.Oasys_Flat_Code__c;
     
                //send mail to SM
                String html_body = 'Hello ' + Booking_createdby_name  + ' ,' + '<br/><br/> Booking for customer ' + booking.Name_of_Applicant__c + ' for ' +   booking.Oasys_Flat_Code__c + ' has been rejected under FAME process - '+ fame.FAME_Reason_LOV__c + '<br/>Remarks: ' + fame.Remarks__c + '<br/> Click on ' + '<a href="' + object_record_link +'">' + object_record_link + '</a> for complete details.' + '<br/>Regards,<br/>Lodha_CC_Admin';
                String html_body_sm = 'Hello ' + SM_name + ' ,' + '<br/><br/> Booking for customer ' + booking.Name_of_Applicant__c + ' for ' +   booking.Oasys_Flat_Code__c + ' has been rejected under FAME process - '+ fame.FAME_Reason_LOV__c + '<br/>Remarks: ' + fame.Remarks__c + '<br/> Click on ' + '<a href="' + object_record_link +'">' + object_record_link + '</a> for complete details.' + '<br/>Regards,<br/>Lodha_CC_Admin';
     
                if(booking.CreatedById == booking.sales_person__c){
                    //send mail to SM         
                    send_email(subject, html_body ,booking.CreatedById);
                }
                else if(booking.CreatedById != booking.sales_person__c){
                    //send mail to SM created by        
                    send_email(subject, html_body ,booking.CreatedById);
        
                    //send mail to SM actual       
                    send_email(subject, html_body_sm ,booking.sales_person__c);
                }
                     
                send_email(subject, html_body ,booking.CreatedById);
     
                //send mail to site incharge
                String html_body_1 = 'Hello ' + projdet.Site_Incharge__r.Name + ',' + '<br/><br/> Booking for customer ' + booking.Name_of_Applicant__c + ' for ' +   booking.Oasys_Flat_Code__c + ' has been rejected under FAME process - '+ fame.FAME_Reason_LOV__c + '<br/>Remarks: ' + fame.Remarks__c + '<br/> Click on ' + '<a href="' + object_record_link +'">' + object_record_link + '</a> for complete details.' + '<br/>Regards,<br/>Lodha_CC_Admin';
                send_email(subject, html_body_1 ,projdet.Site_Incharge__c);
     
                //send email to Relationship Manager
                String html_body_2 = 'Hello ' + wing.Project_Incharge_Relationship_Manager__r.Name + ',' + '<br/><br/> Booking for customer ' + booking.Name_of_Applicant__c + ' for ' +   booking.Oasys_Flat_Code__c + ' has been rejected under FAME process - '+ fame.FAME_Reason_LOV__c + '<br/>Remarks: ' + fame.Remarks__c + '<br/> Click on ' + '<a href="' + object_record_link +'">' + object_record_link + '</a> for complete details.' + '<br/>Regards,<br/>Lodha_CC_Admin';
                send_email(subject, html_body_2 , wing.Project_Incharge_Relationship_Manager__c);
     
                //send email to Project Incharge
                String html_body_3 = 'Hello ' + projdet.Project_Incharge__r.Name + ',' + '<br/><br/> Booking for customer ' + booking.Name_of_Applicant__c + ' for ' +   booking.Oasys_Flat_Code__c + ' has been rejected under FAME process - '+ fame.FAME_Reason_LOV__c + '<br/>Remarks: ' + fame.Remarks__c + '<br/> Click on ' + '<a href="' + object_record_link +'">' + object_record_link + '</a> for complete details.' + '<br/>Regards,<br/>Lodha_CC_Admin';
                send_email(subject, html_body_3 ,projdet.Project_Incharge__c);
            }// end of if
        }// end of if
 
        if(fame.FAME_Status__c == 'Accept') {
            booking.booking_status__c = 'SOLD';
            booking.Confirmation_Date__c = Date.today();
            try {
                 update booking;
                 processed = true;
                 Flat__c flat = [select Status__c from Flat__c where Id=: booking.Flat__c];
                 flat.Status__c = 'SOLD';
                 try {
                     update flat;
                     processed = true;
                 }
                 catch(DMLException e) {
                    processed  = false;
                    error = e.getMessage();
                    system.debug('Flat update failed' + e.getMessage());
                 }
            }
            catch(DMLException e) {
                processed = false;
                error = e.getMessage();
                system.debug('booking update failed for FAME Accept' + e.getMessage());
            }
   
            if( processed == true && prevFameStatus != 'Reject' && prevFameStatus != 'Accept') {
		        prevFameStatus = 'Accept';
		        FameTask.Document_Receipt_Date_By_RM__c = fame.DATE_OF_FORM_RECEIPT_FROM_SALES_TEAM__c;
		        FameTask.Status = 'Completed';
		        Update FameTask;
		        String subject = 'FAME Accepted - ' + booking.Oasys_Flat_Code__c + ' Sold ';
     
		        //send mail to SM
		        String html_body = 'Hello ' + Booking_createdby_name  + ' ,' + '<br/><br/> Booking for customer ' + booking.Name_of_Applicant__c + ' for ' +   booking.Oasys_Flat_Code__c + ' has been approved under FAME process.' + '<br/>Remarks: ' + fame.Remarks__c + '<br/> Click on ' + '<a href="' + object_record_link +'">' + object_record_link + '</a> for complete details.' + '<br/>Regards,<br/>Lodha_CC_Admin';
		        String html_body_sm = 'Hello ' + SM_name+ ' ,' + '<br/><br/> Booking for customer ' + booking.Name_of_Applicant__c + ' for ' +   booking.Oasys_Flat_Code__c + ' has been approved under FAME process.' + '<br/>Remarks: ' + fame.Remarks__c + '<br/> Click on ' + '<a href="' + object_record_link +'">' + object_record_link + '</a> for complete details.' + '<br/>Regards,<br/>Lodha_CC_Admin';
     
     
		        if(booking.CreatedById == booking.sales_person__c){
		            //send mail to SM         
		            send_email(subject, html_body ,booking.CreatedById);
		        }
			    else if(booking.CreatedById != booking.sales_person__c){
			        //send mail to SM created by        
			        send_email(subject, html_body ,booking.CreatedById);
			        
			        //send mail to SM actual       
			        send_email(subject, html_body_sm ,booking.sales_person__c);
     			} 
     
			    //send mail to site incharge
			    String html_body_1 = 'Hello ' + projdet.Site_Incharge__r.Name + ',' + '<br/><br/> Booking for customer ' + booking.Name_of_Applicant__c + ' for ' +   booking.Oasys_Flat_Code__c + ' has been approved under FAME process.' + '<br/>Remarks: ' + fame.Remarks__c + '<br/> Click on ' + '<a href="' + object_record_link +'">' + object_record_link + '</a> for complete details.' + '<br/>Regards,<br/>Lodha_CC_Admin';
			    send_email(subject, html_body_1 ,projdet.Site_Incharge__c);
			     
			    //send email to Relationship Manager
			    String html_body_2 = 'Hello ' + wing.Project_Incharge_Relationship_Manager__r.Name + ',' + '<br/><br/> Booking for customer ' + booking.Name_of_Applicant__c + ' for ' +   booking.Oasys_Flat_Code__c + ' has been approved under FAME process.' + '<br/>Remarks: ' + fame.Remarks__c + '<br/> Click on ' + '<a href="' + object_record_link +'">' + object_record_link + '</a> for complete details.' + '<br/>Regards,<br/>Lodha_CC_Admin';
			    send_email(subject, html_body_2 ,wing.Project_Incharge_Relationship_Manager__c);
			     
			    //send email to Project Incharge
			    String html_body_3 = 'Hello ' + projdet.Project_Incharge__r.Name + ',' + '<br/><br/> Booking for customer ' + booking.Name_of_Applicant__c + ' for ' +   booking.Oasys_Flat_Code__c + ' has been approved under FAME process.' + '<br/>Remarks: ' + fame.Remarks__c + '<br/> Click on ' + '<a href="' + object_record_link +'">' + object_record_link + '</a> for complete details.' + '<br/>Regards,<br/>Lodha_CC_Admin';
			    send_email(subject, html_body_3 , projdet.Project_Incharge__c);

   			}// end of if
 		}// end of if
 
        if(fame.FAME_Status__c == 'Hold' && prevFameStatus != 'Hold') {
		    String subject = 'FAME HOLD - ' + booking.Oasys_Flat_Code__c;
		    prevFameStatus = 'Hold';
		    fame.Form_Reject_On_Hold_Date__c = Date.today();
   
		    FameTask.Document_Receipt_Date_By_RM__c = fame.DATE_OF_FORM_RECEIPT_FROM_SALES_TEAM__c;
		    FameTask.FAME_Reason_for_Reject_or_Hold__c = fame.FAME_Reason_LOV__c;
		    //FameTask.FAME_Remarks_for_Reject_Hold__c = fame.Remarks__c;
   			Update FameTask;
      
   			//send mail to site incharge
   			String html_body = 'Hello ' + projdet.Site_Incharge__r.Name + ',' + '<br/><br/> Booking for customer ' + booking.Name_of_Applicant__c + ' for ' +   booking.Oasys_Flat_Code__c + ' has been put on HOLD under FAME process - '+ fame.FAME_Reason_LOV__c + '<br/>Remarks: ' + fame.Remarks__c + '<br/> Click on ' + '<a href="' + object_record_link +'">' + object_record_link + '</a> for complete details.' + '<br/>Regards,<br/>Lodha_CC_Admin';
   			send_email(subject, html_body ,projdet.Site_Incharge__c);
     
		    //send email to Relationship Manager
		    String html_body_1 = 'Hello ' + wing.Project_Incharge_Relationship_Manager__r.Name + ',' + '<br/><br/> Booking for customer ' + booking.Name_of_Applicant__c + ' for ' +   booking.Oasys_Flat_Code__c + ' has been put on HOLD under FAME process - '+ fame.FAME_Reason_LOV__c + '<br/>Remarks: ' + fame.Remarks__c + '<br/> Click on ' + '<a href="' + object_record_link +'">' + object_record_link + '</a> for complete details.' + '<br/>Regards,<br/>Lodha_CC_Admin';
		    send_email(subject, html_body_1 ,wing.Project_Incharge_Relationship_Manager__c); 
   
		    //send email to SM
		    String html_body_2 = 'Hello ' +Booking_createdby_name + ' ,' + '<br/><br/> Booking for customer ' + booking.Name_of_Applicant__c + ' for ' +   booking.Oasys_Flat_Code__c + ' has been put on HOLD under FAME process - '+ fame.FAME_Reason_LOV__c + '<br/>Remarks: ' + fame.Remarks__c + '<br/> Click on ' + '<a href="' + object_record_link +'">' + object_record_link + '</a> for complete details.' + '<br/>Regards,<br/>Lodha_CC_Admin';
		    String html_body_2_sm = 'Hello ' +SM_name+ ' ,' + '<br/><br/> Booking for customer ' + booking.Name_of_Applicant__c + ' for ' +   booking.Oasys_Flat_Code__c + ' has been put on HOLD under FAME process - '+ fame.FAME_Reason_LOV__c + '<br/>Remarks: ' + fame.Remarks__c + '<br/> Click on ' + '<a href="' + object_record_link +'">' + object_record_link + '</a> for complete details.' + '<br/>Regards,<br/>Lodha_CC_Admin';
   
            if(booking.CreatedById == booking.sales_person__c){
                //send mail to SM         
                send_email(subject, html_body_2 ,booking.CreatedById);
            }
            else if(booking.CreatedById != booking.sales_person__c){
                //send mail to SM created by        
                send_email(subject, html_body_2 ,booking.CreatedById);
        
                //send mail to SM actual       
                send_email(subject, html_body_2_sm ,booking.sales_person__c);
            }  
        }// end of if
        return error;
	}// end of updateBooking()
	
	
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
        if(Test.isRunningTest()==false){
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
	}// end of send_email()
	

}// end of Controller