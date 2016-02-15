/*
*    Version        Date                Author                Description
*    1.0                               Anonymous             Initial Draft
*    1.2         17/11/2014           Deepak Pudi           IT HD-46636 - Welcome call checklist print bug resolution
*    2.0         18/11/2014           Siddharth             IT HD-44967 - Welcome Call Checklist Revamp 
*    3.0         06/12/2014           Deepak Pudi           IT HD-60869 - Welcome Call Checklist Remarks Task & Opportunity
*/
public class SpWelcomeCallCheckListController {

public Id booking_id{get;set;}
Public Welcome_Call_CheckList__c welcomecall {get; set;}
Public Welcome_Call_Details__c welcomecall1;
Public string rolename;
Public Booking_Information__c booking;
Public String customer_name_details {get; set;}
Public String flat_details {get; set;}
public Project_Name__c projdet {get;set;}
public Wing__c wing {get;set;}
Public boolean isSubmitted{get; set;}
Public boolean isSaved{get; set;}
Public Task welcomeTask;
Public string prevStatus;

//Siddharth 2.0
public User managerUser {get; set;}
public Boolean blnIsNewSource {get; set;}

Public string SM_name{get; set;}
Public string Booking_createdby_name{get; set;}

Public SpWelcomeCallCheckListController(){

}
    public SpWelcomeCallCheckListController(ApexPages.StandardController controller) {
        isSubmitted=false;
        isSaved=false;
        string Query='';
        string Query1='';
        wing = new Wing__c();
        booking_id= ApexPages.currentPage().getParameters().get('booking');
        if(booking_id != null) {
            Query=getObjectQuery('Welcome_Call_CheckList__c', 'Booking_Information__c',String.valueof(booking_id));
            Query= Query + ' Order By CreatedDate DESC limit 1';
            Query1=getObjectQuery('Welcome_Call_Details__c', 'Booking_Information__c',String.valueof(booking_id));
            Query1= Query1 + ' Order By CreatedDate DESC limit 1';
            welcomecall=Database.Query(Query); 
            welcomecall1=Database.Query(Query1);   
            getBookingInfo();
            customer_name_details = booking.Name_of_Applicant__c ;
            flat_details = wing.Project__c + '   ' + wing.Cluster_hidden__c + '   ' + wing.Name + '   ' + booking.Flat__r.Flat_no_text__c;   
            prevStatus=welcomecall.Welcome_Call_Status__c;     
        }
        id s=[select id,name,profile.name,UserRoleId from user where id=:UserInfo.getUserId()].UserRoleId;
        rolename = [select id,DeveloperName from UserRole where id=:s].DeveloperName;        
        welcomeTask = [Select Id, OwnerId,Welcome_Call_Checklist_Last_Hold_Date__c,TAT_for_doc_received_by_PI__c, CreatedDate , Document_Receipt_Date_By_RM__c, Document_Receipt_Date__c, FAME_CHECKLIST_Page_URL__c  from Task where WhatId =:welcomecall1.id Order By CreatedDate ASC limit 1];
        welcomecall.Welcome_Call_Monitor_date__c=date.today();        
        if(welcomecall.Welcome_Call_Status__c == 'Accept'){
            isSubmitted=true;
            isSaved=true;
            
        }
        else if(welcomecall.Welcome_Call_Status__c == 'Reject'){
            isSubmitted=true;
            isSaved=true;
        }
        
        SM_name=[select id,name from user where id=:booking.sales_person__c].name;
        Booking_createdby_name=[select id,name from user where id=:booking.CreatedById].name;
        
        //Siddharth 2.0
        managerUser = new User();
        managerUser = this.getManager();
        blnIsNewSource = false;
        if(!String.isBlank(welcomecall.Details_of_Source__c)) 
            blnIsNewSource = welcomecall.Details_of_Source__c.equalsIgnoreCase('dispute') ? true : false;
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
    
   // 2.0 Deepak Pudi(Eternus)
    public void welcomeCallPrint(){
    //this function will not return anything
    }
    
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('US','US')); 
        options.add(new SelectOption('CANADA','Canada')); 
        options.add(new SelectOption('MEXICO','Mexico')); return options; 
    }
    
    public void getBookingInfo() {
        booking = [select Name_Of_Opportunity__c,Name_Of_Opportunity__r.Welcome_Call_Return_Date__c,Name_Of_Opportunity__r.Welcome_Call_Return_Remarks__c,Flat__r.Wing__r.RM_Team_Lead__r.Name,Flat__r.Wing__r.RM_Team_Lead__c,Parking_Nos_2W__c,Parking_Nos_4w__c,Parking_Type__c,Consideration_Rs__c,Consideration_Actual_Rs__c,Secondary_Applicant__c,Contact_Nos__c,Email__c,Address1__c,Address2__c,Address3__c,Application_Date__c,Name_Of_Opportunity__r.accountid, Flat__c,Name_of_Applicant__c, Oasys_Flat_Code__c,Flat__r.Wing__c, Flat__r.Flat_no_text__c, Sales_Person__c, Sales_Person__r.Name, Project_Hidden__c, booking_status__c, Booking_By__c,Booking_Date__c,Selected_discount_type__c, Customer_Type__c,CreatedById ,CreatedBy.FirstName, CreatedBy.LastName from Booking_Information__c  where Id=:booking_id ];
        projdet = [select Name, Project_Incharge__c, Site_Incharge__c,Sap_Mapper__c,Sap_Mapper__r.name,Site_Incharge__r.Name, Project_Incharge__r.Name, Project_Type__c from Project_Name__c where Name=: booking.Project_Hidden__c];
        if(booking.Flat__r != null)
            wing = [select Project__c, Cluster_hidden__c, Name, Project_Incharge_Relationship_Manager__c, Project_Incharge_Relationship_Manager__r.Name from Wing__c where Id=:booking.Flat__r.Wing__c];
        }
    Public List<selectOption> getCorrectItems(){
        
        List<selectOption> a=new List<selectOption>();
        a.add(new selectoption('Correct','Correct'));
        a.add(new selectoption('Incorrect','Incorrect'));
        return a;
    }
    
    Public List<selectOption> getCorrectNAItems(){
        
        List<selectOption> a=new List<selectOption>();
        a.add(new selectoption('Correct','Correct'));
        a.add(new selectoption('Incorrect','Incorrect'));
        a.add(new selectoption('N/A','N/A'));
        return a;
    }
    
    Public List<selectOption> getOrderItems(){
        List<selectOption> a=new List<selectOption>();
        a.add(new selectoption('Inorder','Inorder'));
        a.add(new selectoption('Not Inorder','Not Inorder'));
        return a;    
    
    }
    
    Public List<selectOption> getOrderNAItems(){
        List<selectOption> a=new List<selectOption>();
        a.add(new selectoption('Inorder','Inorder'));
        a.add(new selectoption('Not Inorder','Not Inorder'));
        a.add(new selectoption('N/A','N/A'));
        return a;    
    
    }
    
    public List<selectOption> getYesItems(){
        List<selectOption> a=new List<selectOption>();
        //Siddharth 2.0
        /*
        a.add(new selectoption('Yes','Yes'));
        a.add(new selectoption('No','No'));
        a.add(new selectoption('Requires Improvement','Requires Improvement'));
        */
        a.add(new selectoption('Agree','Agree'));
        a.add(new selectoption('Disagree','Disagree'));
        return a;   
    
    }
    
    //Siddharth 2.0
    public List<selectOption> getDisputeItems(){
        
        List<selectOption> optionList = new List<selectOption>();
        optionList.add(new selectoption('Okay','Okay'));
        optionList.add(new selectoption('Dispute','Dispute'));
        return optionList;
    }
    
    Public List<selectOption> getYesNoItems(){
        List<selectOption> a=new List<selectOption>();
        a.add(new selectoption('Yes','Yes'));
        a.add(new selectoption('No','No'));
        return a;   
    
    }
    
    Public pagereference save(){
 
        //Siddharth 2.0
        if(!this.validateRemarks())
            return null;
 
        if(welcomecall.Welcome_Call_Date__c == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Welcome call date should be mandatory for saving a record.'));
            return null;
        }
        
        if(welcomecall.Welcome_Call_Date__c > date.today()){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Dont allow to enter future date for saving a record.'));
            return null; 
        }
        
        if(welcomecall.Remarks__c == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Remarks is mandatory for hold.'));
            return null;
        }
         
        //Siddharth 2.0        
        //welcomecall.PI_User__c=wing.Project_Incharge_Relationship_Manager__c;
        //welcomecall.RM_User__c=projdet.Project_Incharge__c;
        welcomecall.PI_User__c = Userinfo.getUserId();        
        welcomecall.RM_User__c = (managerUser != NULL) ? managerUser.Id : null;
        welcomecall.Last_Hold_Date__c=date.today();
        upsert welcomecall;
        
        welcometask.Welcome_Call_Checklist_Last_Hold_Date__c=date.todaY();
        UPDATE WELCOMETASK;
        
        String sUrlRewrite = ApexPages.currentPage().getHeaders().get('Host');
        String object_record_link = 'https://'+ sUrlRewrite.substring(2,6) + 'salesforce.com' + '/' + welcomecall.id;
        String object_record_link1 = 'https://'+ sUrlRewrite.substring(2,6) + 'salesforce.com' + '/' + welcomecall1.id;
        
        String subject = 'Welcome call Hold - ' + booking.Oasys_Flat_Code__c;
 
        //send mail to SM
        String html_body = 'Hello ' +Booking_createdby_name+ ' ,' + '<br/><br/> Booking for customer ' + booking.Name_of_Applicant__c + ' for booking- ' +   booking.Oasys_Flat_Code__c + ' has been hold under Welcome call. <br/>Remarks: ' + welcomecall.Remarks__c+ '<br/><br/>Regards,<br/>Lodha_CC_Admin';
        String html_body_sm = 'Hello ' +SM_name+ ' ,' + '<br/><br/> Booking for customer ' + booking.Name_of_Applicant__c + ' for booking- ' +   booking.Oasys_Flat_Code__c + ' has been hold under Welcome call. <br/>Remarks: ' + welcomecall.Remarks__c+ '<br/><br/>Regards,<br/>Lodha_CC_Admin';
        
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
        String html_body_1 = 'Hello ' + projdet.Site_Incharge__r.Name + ',' + '<br/><br/> Booking for customer ' + booking.Name_of_Applicant__c + ' for booking- ' +   booking.Oasys_Flat_Code__c + ' has been hold under Welcome call.<br/>Remarks: ' + welcomecall.Remarks__c + '<br/><br/>Regards,<br/>Lodha_CC_Admin';
        send_email(subject, html_body_1 ,projdet.Site_Incharge__c);
        
        //send email to Relationship Manager
        String html_body_2 = 'Hello ' + wing.Project_Incharge_Relationship_Manager__r.Name + ',' + '<br/><br/> Booking for customer ' + booking.Name_of_Applicant__c + ' for booking-' +   booking.Oasys_Flat_Code__c + 'has been hold under Welcome call.<br/>Remarks: ' + welcomecall.Remarks__c +'<br/> Click on ' + '<a href="' + object_record_link1 +'">' + object_record_link1 + '</a> for Welcome Call Details.<br/> Click on <a href="' + object_record_link +'">' + object_record_link + '</a> for Welcome Call Checklist Details.<br/><br/>Regards,<br/>Lodha_CC_Admin';
        send_email(subject, html_body_2 , wing.Project_Incharge_Relationship_Manager__c);
        
        //send email to RM Team Lead:
        String html_body_4 = 'Hello ' + booking.Flat__r.Wing__r.RM_Team_Lead__r.Name + ',' + '<br/><br/> Booking for customer ' + booking.Name_of_Applicant__c + ' for booking-' +   booking.Oasys_Flat_Code__c + 'has been hold under Welcome call.<br/>Remarks: ' + welcomecall.Remarks__c +'<br/> Click on ' + '<a href="' + object_record_link1 +'">' + object_record_link1 + '</a> for Welcome Call Details.<br/> Click on <a href="' + object_record_link +'">' + object_record_link + '</a> for Welcome Call Checklist Details.<br/><br/>Regards,<br/>Lodha_CC_Admin';
        send_email(subject, html_body_4 , booking.Flat__r.Wing__r.RM_Team_Lead__c);
        
        //send email to Project Incharge
        String html_body_3 = 'Hello ' + projdet.Project_Incharge__r.Name + ',' + '<br/><br/> Booking for customer ' + booking.Name_of_Applicant__c + ' for booking-' +   booking.Oasys_Flat_Code__c + 'has been hold under Welcome call.<br/>Remarks: ' + welcomecall.Remarks__c + '<br/> Click on ' + '<a href="' + object_record_link1 +'">' + object_record_link1 + '</a> for Welcome Call Details.<br/> Click on <a href="' + object_record_link +'">' + object_record_link + '</a> for Welcome Call Checklist Details.<br/><br/>Regards,<br/>Lodha_CC_Admin';
        send_email(subject, html_body_3 ,projdet.Project_Incharge__c);         
        
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.info,'Welcome Call checklist saved Successfully and Stakeholders notified.'));
        return null;
    
    
    }
    
    Public pagereference submit(){
        
        //Siddharth 2.0
        if(!this.validateRemarks())
            return null;
                
        if(welcomecall.Welcome_Call_Date__c == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Welcome call date should be mandatory for submitting a record.'));
            return null;
        }
        
        if(welcomecall.Welcome_Call_Date__c > date.today()){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Dont allow to enter future date for submitting a record.'));
            return null; 
        }
        
        String sUrlRewrite = ApexPages.currentPage().getHeaders().get('Host');
        String object_record_link = 'https://'+ sUrlRewrite.substring(2,6) + 'salesforce.com' + '/' + welcomecall.id;
        String object_record_link1 = 'https://'+ sUrlRewrite.substring(2,6) + 'salesforce.com' + '/' + welcomecall1.id;
                
        if(welcomecall.Welcome_Call_Status__c == 'Accept'){
            
            //Siddharth 2.0
            /*
            if(welcomecall.Applicant_Co_applicant_Name__c ==null || welcomecall.Date_of_booking_Flat_Details_Carpet_A__c == null || welcomecall.Information_on_Exclusive_area_for_use__c==null || welcomecall.Consideration_Value__c==null ||  welcomecall.Contact_Details__c == null || welcomecall.Parking_allotment__c==null ||  welcomecall.PAYMENT_SCHEDULE_21_days__c ==null || welcomecall.PS_42nd_45th_day_registration_process__c==null ||  welcomecall.PS_Construction_linked_payment__c ==null || welcomecall.RP_Stamp_duty_DD__c==null || welcomecall.RP_MVAT_DD__c ==null || welcomecall.RP_Registration_DD__c==null || welcomecall.PD_Due_date__c ==null ){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Please fill mandatory fields for saving a record.'));
                return null;             
            }*/
            
            //Siddharth 2.0        
            //welcomecall.PI_User__c=wing.Project_Incharge_Relationship_Manager__c;
            //welcomecall.RM_User__c=projdet.Project_Incharge__c;
            welcomecall.PI_User__c = Userinfo.getUserId();
            welcomecall.RM_User__c = (managerUser != NULL) ? managerUser.Id : null;
            welcomecall.Welcome_Call_Accepted_Date__c=date.today();
            upsert welcomecall;
            isSubmitted=true;
            isSaved=true;

            if(prevStatus !='Accept' ){
                welcomeTask.status='Completed';
                update welcomeTask;       
                
                booking.Booking_Status__c='BOOKED';
                update booking;
                
                String subject1 = 'Welcome call Accepted - ' + booking.Oasys_Flat_Code__c;
         
                //send mail to SM
                String html_body5 = 'Hello ' +Booking_createdby_name + ',' + '<br/><br/> Booking for customer ' + booking.Name_of_Applicant__c + ' for booking- ' +   booking.Oasys_Flat_Code__c + ' has been Accepted under Welcome call. <br/>Remarks: ' + welcomecall.Remarks__c+ '<br/><br/>Regards,<br/>Lodha_CC_Admin';
                String html_body5_sm = 'Hello ' +SM_name+ ' ,' + '<br/><br/> Booking for customer ' + booking.Name_of_Applicant__c + ' for booking- ' +   booking.Oasys_Flat_Code__c + ' has been Accepted under Welcome call. <br/>Remarks: ' + welcomecall.Remarks__c+ '<br/><br/>Regards,<br/>Lodha_CC_Admin';
                
                
                if(booking.CreatedById == booking.sales_person__c){
                    //send mail to SM         
                    send_email(subject1 , html_body5 ,booking.CreatedById);
                }
                else if(booking.CreatedById != booking.sales_person__c){
                    //send mail to SM created by        
                    send_email(subject1 , html_body5 ,booking.CreatedById);
                    
                    //send mail to SM actual       
                    send_email(subject1 , html_body5_sm ,booking.sales_person__c);
                }              
                
                //send mail to site incharge
                String html_body_6 = 'Hello ' + projdet.Site_Incharge__r.Name + ',' + '<br/><br/> Booking for customer ' + booking.Name_of_Applicant__c + ' for booking- ' +   booking.Oasys_Flat_Code__c + ' has been Accepted under Welcome call.<br/>Remarks: ' + welcomecall.Remarks__c + '<br/><br/>Regards,<br/>Lodha_CC_Admin';
                send_email(subject1, html_body_6 ,projdet.Site_Incharge__c);
                
                //send email to Relationship Manager
                String html_body_7 = 'Hello ' + wing.Project_Incharge_Relationship_Manager__r.Name + ',' + '<br/><br/> Booking for customer ' + booking.Name_of_Applicant__c + ' for booking-' +   booking.Oasys_Flat_Code__c + 'has been Accepted under Welcome call.<br/>Remarks: ' + welcomecall.Remarks__c +'<br/> Click on ' + '<a href="' + object_record_link1 +'">' + object_record_link1 + '</a> for Welcome Call Details.<br/> Click on <a href="' + object_record_link +'">' + object_record_link + '</a> for Welcome Call Checklist Details.<br/><br/>Regards,<br/>Lodha_CC_Admin';
                send_email(subject1, html_body_7 , wing.Project_Incharge_Relationship_Manager__c);
                
                //send email to RM Team Lead:
                String html_body_8 = 'Hello ' + booking.Flat__r.Wing__r.RM_Team_Lead__r.Name + ',' + '<br/><br/> Booking for customer ' + booking.Name_of_Applicant__c + ' for booking-' +   booking.Oasys_Flat_Code__c + 'has been Accepted under Welcome call.<br/>Remarks: ' + welcomecall.Remarks__c +'<br/> Click on ' + '<a href="' + object_record_link1 +'">' + object_record_link1 + '</a> for Welcome Call Details.<br/> Click on <a href="' + object_record_link +'">' + object_record_link + '</a> for Welcome Call Checklist Details.<br/><br/>Regards,<br/>Lodha_CC_Admin';
                send_email(subject1, html_body_8 , booking.Flat__r.Wing__r.RM_Team_Lead__c);
                
                //send email to Project Incharge
                String html_body_9 = 'Hello ' + projdet.Project_Incharge__r.Name + ',' + '<br/><br/> Booking for customer ' + booking.Name_of_Applicant__c + ' for booking-' +   booking.Oasys_Flat_Code__c + 'has been Accepted under Welcome call.<br/>Remarks: ' + welcomecall.Remarks__c + '<br/> Click on ' + '<a href="' + object_record_link +'">' + object_record_link + '</a> for Welcome Call Details.<br/> Click on <a href="' + object_record_link +'">' + object_record_link + '</a> for Welcome Call Checklist Details.<br/><br/>Regards,<br/>Lodha_CC_Admin';
                send_email(subject1, html_body_9 ,projdet.Project_Incharge__c);  
                
                
                //Task creation for SAP Mapper if its accepts first...   
                SOCreation__c soobject=new SOCreation__c(Booking_Information__c=welcomecall.Booking_Information__c,SO_Task_Created_Date__c=date.today());
                insert soobject;
                                                
                String sUrlRewrite1 = ApexPages.currentPage().getHeaders().get('Host').remove('-api');
                String SoCreationPageUrl= 'https://'+ sUrlRewrite1.substring(2,6) + 'salesforce.com' + '/apex/SOCreationCheckList?bookingid='+welcomecall.Booking_Information__c;
                
                Id record_type_id = [Select Id from RecordType Where DeveloperName='SO_Creation_Task'].Id;
                Task newTask = new Task(Description = 'SO Creation Initiated for ' + booking.Oasys_Flat_Code__c,                                        
                                    RecordTypeId = record_type_id,
                                    Priority = 'Normal', 
                                    Status = 'Under Action by Me', 
                                    Subject = 'SO Creation Initiated- ' + booking.Oasys_Flat_Code__c, 
                                    IsReminderSet = true,                                      
                                    ReminderDateTime = System.now()+6, 
                                    ActivityDate = date.today()+7,
                                    OwnerId = projdet.Sap_Mapper__c,
                                    WhatId =  soobject.id,
                                    So_Creation_Checklist_Page_URL__c = SoCreationPageUrl);
                // 3.0 Deepak Pudi
                 if(welcomecall.Remarks__c.length() >255){
                    newTask.Welcome_Call_Remarks__c=welcomecall.Remarks__c.abbreviate(255);
                 }else{
                      newTask.Welcome_Call_Remarks__c=welcomecall.Remarks__c;
                     }
                                    
                if(booking.Name_Of_Opportunity__r.Welcome_Call_Return_Date__c != null && booking.Name_Of_Opportunity__r.Welcome_Call_Return_Remarks__c != null){
                    system.debug('@@@@@@@@@@@@inside resubmission');
                    newTask.Welcome_Call_Resubmision__c='Welcome Call Resubmitted';
                }
                else{
                    system.debug('@@@@@@@@@@@@Outside resubmission');
                    newTask.Welcome_Call_Resubmision__c='';
                }
                try {
                insert newTask;
                }
                catch(DMLException e) {   
                System.debug('Unable to create task' + e.getMessage());
                }
                
                String object_record_link2 = 'https://'+ sUrlRewrite1.substring(2,6) + 'salesforce.com' + '/' + newTask.id;
                String subject = 'SO creation Initiated- ' + booking.Oasys_Flat_Code__c;
                //send mail to SAP MAPPER
                String html_body = 'Hello ' + projdet.Sap_Mapper__r.name +',' + '<br/><br/> So Creation Task has been created for booking-'+   booking.Oasys_Flat_Code__c +'<br/>Remarks: ' + welcomecall.Remarks__c+ '.<br/> Please click on the following link to view the same.<br/>' + object_record_link2  + '<br/><br/>Regards,<br/>Lodha_CC_Admin';
                send_email(subject, html_body ,projdet.Sap_Mapper__c);
                
            }       
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.info,'Record Accepted successfully and assigned new SO creation task to SAP mapper.'));
            return null;
        }
        else if(welcomecall.Welcome_Call_Status__c == 'Reject'){
             if(prevStatus =='Reject'){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Invalid Status'));
                return null;
            }
            if(welcomecall.Welcome_Call_Date__c == null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Welcome call date should be mandatory.'));
                return null;             
            }
            if(welcomecall.Remarks__c == null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Remarks should be mandatory.'));
                return null;
            }
           
            
            if(prevStatus !='Reject'){
                welcomecall.Last_Welcome_Call_Rejected_Date__c=date.today();
                //Siddharth 2.0        
                //welcomecall.PI_User__c=wing.Project_Incharge_Relationship_Manager__c;
                //welcomecall.RM_User__c=projdet.Project_Incharge__c;
                welcomecall.PI_User__c = Userinfo.getUserId();
                welcomecall.RM_User__c = (managerUser != NULL) ? managerUser.Id : null;
                upsert welcomecall;
                
                welcomeTask.status='Completed';
                update welcomeTask;  
                
                booking.Booking_Status__c='WELCOME CALL REJECT';
                update booking;
                
                Flat__c flat = [select Status__c from Flat__c where Id=: booking.Flat__c];
                flat.Status__c = 'BOOKING';
                update flat;
                
                Opportunity opp = [select Name,Welcome_Call_Return_Date__c, Welcome_Call_Return_Remarks__c from Opportunity where Id =: booking.Name_Of_Opportunity__c];
                opp.StageName='Closed Lost';
                opp.Reasons_for_lost__c='Welcome Call Reject';
                opp.Welcome_Call_Return_Date__c= date.today();
                opp.Welcome_Call_Return_Remarks__c =welcomecall.Remarks__c;
                
                update opp;
                
                //Welcome_Call_Details__c welcomedetails=[Select Id from Welcome_Call_Details__c where Booking_Information__c=:String.valueof(booking_id) Order by CreatedDate DESC Limit 1];
                
                

                Id record_type_id = [Select Id from RecordType Where DeveloperName='Welcome_Call_Task'].Id;
                Task newTask = new Task(Description = 'Welcome Call Rejected for ' + booking.Oasys_Flat_Code__c,                                        
                                    RecordTypeId = record_type_id,
                                    Priority = 'Normal', 
                                    Status = 'Completed', 
                                    Subject = 'Welcome Call Rejected-' + booking.Oasys_Flat_Code__c, 
                                    IsReminderSet = true,                                      
                                    ReminderDateTime = System.now()+6, 
                                    ActivityDate = date.today()+7,
                                    OwnerId = projdet.Project_Incharge__c,
                                    WhatId =  welcomecall1.Id,
                                    Welcome_Call_Details_Page_URL__c= object_record_link1,
                                    Welcome_Call_Checklist_Page_URL__c=object_record_link);
              
                // 3.0 Deepak Pudi                    
                 if(welcomecall.Remarks__c.length() > 255){
                    newTask.Welcome_Call_Remarks__c = welcomecall.Remarks__c.abbreviate(255);
                 }else{
                      newTask.Welcome_Call_Remarks__c = welcomecall.Remarks__c;
                      }
                                    
                try {
                insert newTask;
                }
                catch(DMLException e) {   
                System.debug('Unable to create task' + e.getMessage());
                }
                
                String subject = 'Welcome Call Reject : ' + booking.Oasys_Flat_Code__c;
         
                //send mail to SM
                
                String html_body = 'Hello ' +Booking_createdby_name+ ' ,' + '<br/><br/> Booking for customer <b>' + booking.Name_of_Applicant__c + '</b> for booking- ' +   booking.Oasys_Flat_Code__c + ' has been rejected under Welcome call. <br/><br/>Remarks: ' + welcomecall.Remarks__c+ '<br/><br/>Regards,<br/>Lodha_CC_Admin';
                String html_body_sm = 'Hello ' +SM_name+ ' ,' + '<br/><br/> Booking for customer <b>' + booking.Name_of_Applicant__c + '</b> for booking- ' +   booking.Oasys_Flat_Code__c + ' has been rejected under Welcome call. <br/><br/>Remarks: ' + welcomecall.Remarks__c+ '<br/><br/>Regards,<br/>Lodha_CC_Admin';
                
                
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
                
                String html_body_1 = 'Hello ' + projdet.Site_Incharge__r.Name + ',' + '<br/><br/> Booking for customer <b>' + booking.Name_of_Applicant__c + '</b> for booking- ' +   booking.Oasys_Flat_Code__c + ' has been rejected under Welcome call.<br/><br/>Remarks: ' + welcomecall.Remarks__c + '<br/><br/>Regards,<br/>Lodha_CC_Admin';
                send_email(subject, html_body_1 ,projdet.Site_Incharge__c);
                
                //send email to Relationship Manager
                String html_body_2 = 'Hello ' + wing.Project_Incharge_Relationship_Manager__r.Name + ',' + '<br/><br/> Booking for customer <b>' + booking.Name_of_Applicant__c + '</b> for booking-' +   booking.Oasys_Flat_Code__c + 'has been rejected under Welcome call.<br/><br/>Remarks: ' + welcomecall.Remarks__c +'<br/><br/>Regards,<br/>Lodha_CC_Admin';
                send_email(subject, html_body_2 , wing.Project_Incharge_Relationship_Manager__c);
                
                //send email to RM Team Lead:
                String html_body_4 = 'Hello ' + booking.Flat__r.Wing__r.RM_Team_Lead__r.Name + ',' + '<br/><br/> Booking for customer <b>' + booking.Name_of_Applicant__c + '</b> for booking-' +   booking.Oasys_Flat_Code__c + 'has been rejected under Welcome call.<br/><br/>Remarks: ' + welcomecall.Remarks__c +'<br/><br/>Regards,<br/>Lodha_CC_Admin';
                send_email(subject, html_body_4 , booking.Flat__r.Wing__r.RM_Team_Lead__c);
                
                //send email to Project Incharge
                String html_body_3 = 'Hello ' + projdet.Project_Incharge__r.Name + ',' + '<br/><br/> Booking for customer <b>' + booking.Name_of_Applicant__c + '</b> for booking-' +   booking.Oasys_Flat_Code__c + 'has been rejected under Welcome call.<br/><br/>Remarks: ' + welcomecall.Remarks__c + '<br/><br/>Regards,<br/>Lodha_CC_Admin';
                send_email(subject, html_body_3 ,projdet.Project_Incharge__c);         
         
                isSubmitted=true;
                isSaved=true;
                welcomecall.Last_Welcome_Call_Rejected_Date__c=date.today();
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.info,'Record has been rejected and stakeholders notified.'));
            }
            return null;
        }
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Please choose welcome call status to submit the record.'));
            return null;        
        }
        return null;
    
    
    }
    
    public void send_email(String subject, String html_body, Id receipient_id) {
        system.debug('Subject:------------ ' + subject + ' Html_body-----------' + html_body + ' Id:---------- ' + receipient_id);
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
    
    //Siddharth 2.0
    public Boolean validateRemarks(){
        
        if(!String.isBlank(welcomecall.Welcome_Call__c)){
            if(String.isBlank(welcomecall.Welcome_Call_Remarks__c) && welcomecall.Welcome_Call__c.equalsIgnoreCase('disagree')){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Please fill Remarks in the Welcome Section'));
                return false;
            }            
        }
        if(!String.isBlank(welcomecall.Greetings__c)){
            if(String.isBlank(welcomecall.Greetings_Remarks__c) && welcomecall.Greetings__c.equalsIgnoreCase('disagree')){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Please fill Remarks in the Greetings Section'));
                return false;
            }
        }
        if(!String.isBlank(welcomecall.Source_of_Booking__c)){
            if(String.isBlank(welcomecall.Source_of_Booking_Remarks__c) && welcomecall.Source_of_Booking__c.equalsIgnoreCase('disagree')){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Please fill Remarks in the Source of Booking Section'));
                return false;
            }    
        }
        if(!String.isBlank(welcomecall.Details_of_Source__c)){
            if(String.isBlank(welcomecall.Details_of_Source_Remarks__c) && welcomecall.Details_of_Source__c.equalsIgnoreCase('dispute')){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Please fill Remarks in the Details of Source Section'));
                return false;
            }    
        }
        if(!String.isBlank(welcomecall.Details_of_Source__c) && !String.isBlank(welcomecall.New_Booking_Source__c)){
            if(welcomecall.Details_of_Source__c.equalsIgnoreCase('dispute') && welcomecall.New_Booking_Source__c.equalsIgnoreCase(booking.Booking_By__c)){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'The Value for New Source cannot be ' + booking.Booking_By__c));
                return false;
            }    
        }
        if(!String.isBlank(welcomecall.Closing_Note__c)){
            if(String.isBlank(welcomecall.Closing_Note_Remarks__c) && welcomecall.Closing_Note__c.equalsIgnoreCase('disagree')){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Please fill Remarks in the Closing Note Section'));
                return false;
            }    
        }
        return true;
    }
    
    //Siddharth 2.0
    public User getManager(){
        
        List<User> userList = [select ManagerId
                               from User
                               where Id =: Userinfo.getUserId()];
        if(!userList.isEmpty()){
            if(userList[0].ManagerId != NULL){
                return [select Id,
                               Name 
                        from User 
                        where Id =: userList[0].ManagerId];    
            }
        }
        return NULL;
    }
    
    //Siddharth 2.0
    public void verifySourceOfBooking(){
        blnIsNewSource = (welcomecall.Details_of_Source__c.equalsIgnoreCase('dispute')) ? true : false;
    }
}