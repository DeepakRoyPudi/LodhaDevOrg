Public class SOTrigger{

public static boolean block=false;
boolean stopUnneccessaryupdate;
Map<id,Booking_Information__c > BookingOldmap;
set<id> BookingIdSet;
set<id> FlatIdSet;
Map<Id,FAME__c> FAMEMap;
Task newTask;
string Subject;
String html_body_new;
SpSOCreationCheckList sp;
Map<id,Flat__c> BMap;

public SOTrigger(){
BookingOldmap=new Map<id,Booking_Information__c >();
FAMEMap=new Map<Id,FAME__c>();
sp=new SpSOCreationCheckList();
BMap=new Map<id,Flat__c>();
BookingIdSet=new set<Id>();
FlatIdSet=new set<Id>();
}

public SOTrigger(string dummy){

}

Public void CancellationEmail(List<Booking_Information__c> oldbooking,List<Booking_Information__c> Newbooking){
Map<id,Booking_Information__c > oldBookingmap=new Map<id,Booking_Information__c >();
List<Booking_Information__c> Booking;
string subject;
String html;
string urls;
Map<String,boolean> IsSP2Conf=new Map<String,boolean>();
Map<Id,Booking_Information__c > BookingMap=new Map<Id,Booking_Information__c >();
    for(Booking_Information__c old:oldbooking){
        oldBookingmap.put(old.id,old);
        system.debug('!!!!!!!!!!!'+oldBookingmap);
    }
    
    for(Booking_Information__c cc:Newbooking){
        IsSP2Conf.put(cc.id,null);
    }
    
    List<Booking_Information__c > blst= [select id,Flat__r.Wing__r.Cluster__r.Project_Name__r.isSP2__c from Booking_Information__c where Id IN:IsSP2Conf.keyset()];
    system.debug('!!!!!!!!!!!!!!!!!!IsSP2Confbefore'+IsSP2Conf);
    
    IsSP2Conf.clear();
    
    system.debug('!!!!!!!!!!!!!!!!!!IsSP2Confafter'+IsSP2Conf);
    
    for(Booking_Information__c f:blst){
          IsSP2Conf.put(f.id,f.Flat__r.Wing__r.Cluster__r.Project_Name__r.isSP2__c);
    }
    
    system.debug('!!!!!!!!!!!!!!!!!!IsSP2Conffinal'+IsSP2Conf);
    
    for(Booking_Information__c newacc:Newbooking){
        system.debug('!!!!!!!!!!!O'+newacc);
        system.debug('IsSP2Conf'+IsSP2Conf.get(newacc.id)+'-'+newacc.id);
        if(oldBookingmap.get(newacc.id).Booking_Status__c != 'CANCELLATION' && ( oldBookingmap.get(newacc.id).Cancellation_Date__c== null || oldBookingmap.get(newacc.id).Reason_for_Cancellation__c == null )&& oldBookingmap.get(newacc.id).Oasys_Flat_Code__c != null){
            if(newacc.Cancellation_Date__c!= null && newacc.Reason_for_Cancellation__c != null && newacc.Reason_for_Cancellation__c != 'Transferred to a New Company' && IsSP2Conf.get(newacc.id)==true){
               system.debug('@@@@@@@@@@@@@CAncellation inside'+IsSP2Conf.get(newacc.id));
               BookingMap.put(newacc.id,newacc); 
            }        
        }    
    }
    Booking=[select id,name,Flat__c,Flat__r.Wing__r.RM_Team_Lead__c,Flat__r.Wing__r.RM_Team_Lead__r.Name,Flat__r.Wing__r.Cluster__r.Project_Name__c,Flat__r.Wing__r.Project_Incharge_Relationship_Manager__c,Flat__r.Wing__r.Project_Incharge_Relationship_Manager__r.name,Name_of_Applicant__c ,Oasys_Flat_Code__c,InActive__c,Reason_for_Cancellation__c,Booking_status__c from Booking_Information__c where Id IN:BookingMap.keyset()];   
    urls= URL.getSalesforceBaseUrl().toExternalForm()+'/apex/CancellationPage?bookingid=';
    for(Booking_Information__c b:Booking){
        system.debug('!!!!!!!!!!!b'+b);
        subject = 'Booking information need to be cancelled in SFDC-' + b.Oasys_Flat_Code__c;
        html = 'Hello ' + b.Flat__r.Wing__r.RM_Team_Lead__r.name + ',' + '<br/><br/> The Booking ' + b.Name_of_Applicant__c + ' with ' +   b.Oasys_Flat_Code__c + ' is cancelled in SAP with <br/>Confirmation Date: '+ BookingMap.get(b.id).Cancellation_Date__c+',<br/>Reason for Cancellation: '+BookingMap.get(b.id).Reason_for_Cancellation__c +'<br/> Click here: '+urls+b.id+' for completion of cancellation.<br/><br/>Regards,<br/>Lodha_CC_Admin';
        cancellationcontroller.send_email(subject, html ,b.Flat__r.Wing__r.RM_Team_Lead__c);    
        html = 'Hello ' + b.Flat__r.Wing__r.Project_Incharge_Relationship_Manager__r.name + ',' + '<br/><br/> The Booking ' + b.Name_of_Applicant__c + ' with ' +   b.Oasys_Flat_Code__c + ' is cancelled in SAP with <br/>Confirmation Date: '+ BookingMap.get(b.id).Cancellation_Date__c+',<br/>Reason for Cancellation: '+BookingMap.get(b.id).Reason_for_Cancellation__c +'<br/> Click here: '+urls+b.id+' for completion of cancellation.<br/><br/>Regards,<br/>Lodha_CC_Admin';
        cancellationcontroller.send_email(subject, html ,b.Flat__r.Wing__r.Project_Incharge_Relationship_Manager__c);
    }
    
}
public void mymethod(List<Booking_Information__c> oldbooking,List<Booking_Information__c> Newbooking){
    String sUrlRewrite =System.URL.getSalesforceBaseUrl().getHost().remove('-api' );
    Id record_type_id = [Select Id from RecordType Where DeveloperName='Welcome_Email_Task'].Id;
    
    Map<String,boolean> IsSP2Conf=new Map<String,boolean>();
    
    for(Booking_Information__c cc:Newbooking){
        IsSP2Conf.put(cc.id,null);
    }
    
    List<Booking_Information__c > blst= [select id,Flat__r.Wing__r.Cluster__r.Project_Name__r.isSP2__c from Booking_Information__c where Id IN:IsSP2Conf.keyset()];
    system.debug('!!!!!!!!!!!!!!!!!!IsSP2Confbefore'+IsSP2Conf);
    
    IsSP2Conf.clear();
    
    system.debug('!!!!!!!!!!!!!!!!!!IsSP2Confafter'+IsSP2Conf);
    
    for(Booking_Information__c f:blst){
        IsSP2Conf.put(f.id,f.Flat__r.Wing__r.Cluster__r.Project_Name__r.isSP2__c);
    }
    
    system.debug('!!!!!!!!!!!!!!!!!!IsSP2Conffinal'+IsSP2Conf);
    
    for(Booking_Information__c a:oldbooking){
        BookingOldmap.put(a.id,a);
    }
    System.debug('!!!!!!!BookingOldmap'+BookingOldmap);
    
    for(Booking_Information__c a:Newbooking){
        system.debug('@@@@@@@@@@@@@'+a.id+'-'+IsSP2Conf.get(a.id));
        if(IsSP2Conf.get(a.id)==true){
            system.debug('@@@@@@@@@@@@@inside'+a.id);
            BookingIdSet.add(a.id);
            FlatIdSet.add(a.Unique_booking_Id__c);
        }
    }
    
    System.debug('!!!!!!!BookingIdSet'+BookingIdSet);
    System.debug('!!!!!!!FlatIdSet'+FlatIdSet);
    
    Map<id,Booking_Information__c> BookingMap=new Map<id,Booking_Information__c>([select id,SALESORDER_NO__c,CRN_Number_SAP__c,SO_Creation_Date_time__c,Reap_Id__c,Reap_Id__r.Email__c,Reap_Id__r.Reap_Id__c,Reap_Id__r.Name,CRN__c,Unique_booking_Id__c ,Address1__c,Address2__c,Address3__c,Contact_Nos__c,Name_of_Applicant__c,Base_Rate_Sq_ft_Rs__c,Base_Rate_Sq_ft_Actual_Rs__c,Application_Date__c,Oasys_Flat_Code__c,Flat__r.Name,Flat__r.Wing__r.Project_Incharge_Relationship_Manager__r.name,Flat__r.Wing__r.Project_Incharge_Relationship_Manager__c,Email__c,Flat__r.Wing__r.Cluster_hidden__c,Flat__r.Wing__r.RM_Team_Lead__c,Flat__r.Wing__r.Name,Flat__r.Wing__r.RM_Team_Lead__r.name,Flat__r.Wing__r.Cluster__r.Project_Name__r.name,Flat__r.Wing__r.Cluster__r.Project_Name__r.Project_Incharge__c,Flat__r.Wing__r.Cluster__r.Project_Name__r.Project_Incharge__r.Name,Flat__r.Wing__r.Cluster__r.Project_Name__r.Sap_Mapper__c,Flat__r.Wing__r.Cluster__r.Project_Name__r.Sap_Mapper__r.Name,Flat__r.Wing__r.FAME_Back_end_RM__r.name,Flat__r.Wing__r.FAME_Back_end_RM__c from Booking_Information__c where id IN:BookingIdSet]);
    Map<Id,Flat__c> flat = new Map<Id,Flat__c>([select Id,Status__c from Flat__c where Id IN:FlatIdSet]);
    
    System.debug('!!!!!!!BookingMap'+BookingMap);
    System.debug('!!!!!!!flat '+flat);
    
    for(Id a:BookingMap.keyset()){
        if(flat.containsKey(BookingMap.get(a).Unique_booking_Id__c)==true){
            BMap.put(a,flat.get(BookingMap.get(a).Unique_booking_Id__c));
        }
    }
    System.debug('!!!!!!!BMap'+BMap);
    
    for(FAME__c a:[select id,DATE_OF_FORM_LOGIN_IN_SAP__c,Booking_Information__c from FAME__c where Booking_Information__c IN:BookingIdSet and FAME_Status__c='Accept']){
        FAMEMap.put(a.Booking_Information__c,a);
    }
    System.debug('!!!!!!!FAMEMap'+FAMEMap);
    stopUnneccessaryupdate=false;
    for(Booking_Information__c a:Newbooking){
        System.debug('!!!!!!!inside'+block+'-'+a+'-'+BookingOldmap.get(a.id).CRN_Number_SAP__c);
        //System.debug('!!!!!!!insidesp2'+a.Flat__r.Wing__r.Cluster__r.Project_Name__r.isSP2__c);
        if(IsSP2Conf.get(a.id)==true){
        
            if(BookingMap.get(a.id).SALESORDER_NO__c != null && (BookingOldmap.get(a.id).SALESORDER_NO__c == null || BookingOldmap.get(a.id).CRN_Number_SAP__c == null) && BookingMap.get(a.id).CRN_Number_SAP__c != null && BookingOldmap.get(a.id).Booking_Status__c != 'CANCELLATION' && BookingOldmap.get(a.id).InActive__c ==false && SOTrigger.block==false){
                stopUnneccessaryupdate=true;
                System.debug('!!!!!!!inside if'+BookingOldmap.get(a.id).SALESORDER_NO__c +'-'+BookingOldmap.get(a.id).CRN_Number_SAP__c );
                BookingMap.get(a.id).Booking_Status__c='SOLD'; 
                BookingMap.get(a.id).SO_Creation_Date_time__c=system.now();
                BMap.get(a.id).Status__c='SOLD';  
                FAMEMap.get(a.id).DATE_OF_FORM_LOGIN_IN_SAP__c=date.today();        
                newTask = new Task(Description = 'Welcome Email Task initiated - ' + BookingMap.get(a.id).Oasys_Flat_Code__c,
                                            RecordTypeId = record_type_id ,
                                            Priority = 'Normal', 
                                            Status = 'Under Action by Me', 
                                            Subject = 'Welcome Email Task initiated - ' + BookingMap.get(a.id).Oasys_Flat_Code__c, 
                                            IsReminderSet = true,                                      
                                            ReminderDateTime = System.now()+6, 
                                            ActivityDate = date.today()+7,
                                            OwnerId = BookingMap.get(a.id).Flat__r.Wing__r.Project_Incharge_Relationship_Manager__c,
                                            Booking_Id__c=BookingMap.get(a.id).Id
                                            );                                        
               insert newTask;
        
               //sUrlRewrite= 'https://' + sUrlRewrite.substring(2,6) + 'salesforce.com';
               sUrlRewrite= 'https://' +sUrlRewrite;
               Subject = 'Welcome Email Task Initiated -' + BookingMap.get(a.id).Oasys_Flat_Code__c; 
               //send email to RM:
               html_body_new = 'Hello ' + BookingMap.get(a.id).Flat__r.Wing__r.Project_Incharge_Relationship_Manager__r.name+ ','+ '<br/><br/>Welcome Email task has been created and assigned to you by '  + Userinfo.getname() + ' for booking-' +  BookingMap.get(a.id).Oasys_Flat_Code__c + '.<br/><br/> Please click on the following link to view the same.<br/>' + sUrlRewrite+ '/' + newTask.Id + '<br/><br/>Regards, <br/>Lodha Admin';
               sp.send_email(subject,html_body_new,BookingMap.get(a.id).Flat__r.Wing__r.Project_Incharge_Relationship_Manager__c); 
            
               //send email to RM Team Lead:
               html_body_new = 'Hello ' + BookingMap.get(a.id).Flat__r.Wing__r.RM_Team_Lead__r.name+ ','+ '<br/><br/>Welcome Email task has been created and assigned to you by '  + Userinfo.getname() + ' for booking-' +  BookingMap.get(a.id).Oasys_Flat_Code__c + '.<br/><br/> Please click on the following link to view the same.<br/>' + sUrlRewrite+ '/' + newTask.Id + '<br/><br/>Regards, <br/>Lodha Admin';
               sp.send_email(subject,html_body_new,BookingMap.get(a.id).Flat__r.Wing__r.RM_Team_Lead__c); 
               
               Subject = 'Creation of mylodha Id & CSS activation'; 
               //send email to Deepthi:
               html_body_new = 'Dear IT,<br/><br/>Customer Id '+BookingMap.get(a.id).CRN_Number_SAP__c+' has been created for Customer <b>'+BookingMap.get(a.id).Name_of_Applicant__c+'</b> for his booking in '+BookingMap.get(a.id).Oasys_Flat_Code__c+', having contact details :<br/>E-mail : '+BookingMap.get(a.id).Email__c+'<br/>Mobile No : '+BookingMap.get(a.id).Contact_Nos__c+'<br/><br/>Please generate his mylodha mailbox id & activate his CSS account at the earliest.<br/><br/>Regards, <br/>Lodha Admin';
               //sp.send_email1(subject,html_body_new,'kumaresan.m@capgemini.com'); 
               sp.send_email1(subject,html_body_new,sp_2_email_user_config__c.getinstance('Creation_of_mylodha_Id').User_Id__c);  
               
               if(BookingMap.get(a.id).Reap_Id__c != null){
                   Subject = 'Confirmation of Channel Partner booking for SAP ID '+ BookingMap.get(a.id).CRN_Number_SAP__c;
                   //send email to Channel partner:
                   html_body_new ='Dear Team,<br/><br/>The below booking has been confirmed by us through our channel partner. Kindly note the following details for your reference.<br/>Mentioned below are the details of the customer.<br/><br/><table border="2"><tr><td style="font-weight:bold;font-size:15px;">Customer Id</td><td style="font-weight:bold;font-size:15px;">Customer Name</td><td style="font-weight:bold;font-size:15px;">Project Name</td><td style="font-weight:bold;font-size:15px;">Cluster Name</td><td style="font-weight:bold;font-size:15px;">Wing</td><td style="font-weight:bold;font-size:15px;">Flat No</td><td style="font-weight:bold;font-size:15px;">Channel Partner Name</td><td style="font-weight:bold;font-size:15px;">Reap Id</td></tr><tr><td>'+BookingMap.get(a.id).CRN_Number_SAP__c+'</td><td>'+BookingMap.get(a.id).Name_of_Applicant__c+'</td><td>'+BookingMap.get(a.id).Flat__r.Wing__r.Cluster__r.Project_Name__r.name+'</td><td>'+BookingMap.get(a.id).Flat__r.Wing__r.Cluster_hidden__c+'</td><td>'+BookingMap.get(a.id).Flat__r.Wing__r.Name+'</td><td>'+BookingMap.get(a.id).Flat__r.Name+'</td><td>'+BookingMap.get(a.id).Reap_Id__r.Name+'</td><td>'+BookingMap.get(a.id).Reap_Id__r.Reap_Id__c+'</td></tr></table><br/><br/>Regards, <br/>Lodha Admin';
                   //sp.send_email1(subject,html_body_new,'kumaresan.m@capgemini.com');   
                   sp.send_email(subject,html_body_new,sp_2_email_user_config__c.getinstance('Channel_partner_confirmation_email_1').User_Id__c);        
                   sp.send_email(subject,html_body_new,sp_2_email_user_config__c.getinstance('Channel_partner_confirmation_email_2').User_Id__c);        
                }
                
                Subject = 'Successful generation of SO in SAP';
                //send email to RM,RM TEAM LEAD,PI,SAP MAPPER:
                html_body_new ='Dear '+BookingMap.get(a.id).Flat__r.Wing__r.Project_Incharge_Relationship_Manager__r.Name+',<br/><br/>Sales order no. '+BookingMap.get(a.id).SALESORDER_NO__c+' has been generated for Customer <b>'+BookingMap.get(a.id).Name_of_Applicant__c+'</b>, <b>'+BookingMap.get(a.id).CRN_Number_SAP__c+'</b> for his booking dated '+Date.ValueOf(BookingMap.get(a.id).Application_Date__c)+' in '+BookingMap.get(a.id).Oasys_Flat_Code__c+' has been successfully created in SAP.<br/>Please : <br/>1. Release the demands for time-bound milestones in the system. <br/>2. Welcome-call e-mail to the customer.<br/><br/>Thanks & regards, <br/>Lodha CC Admin';
                sp.send_email(subject,html_body_new,BookingMap.get(a.id).Flat__r.Wing__r.Project_Incharge_Relationship_Manager__c);        
                
                string html_body_new1 ='Dear '+BookingMap.get(a.id).Flat__r.Wing__r.Cluster__r.Project_Name__r.Project_Incharge__r.Name+',<br/><br/>Sales order no. '+BookingMap.get(a.id).SALESORDER_NO__c+' has been generated for Customer <b>'+BookingMap.get(a.id).Name_of_Applicant__c+'</b>, <b>'+BookingMap.get(a.id).CRN_Number_SAP__c+'</b> for his booking dated '+Date.ValueOf(BookingMap.get(a.id).Application_Date__c)+' in '+BookingMap.get(a.id).Oasys_Flat_Code__c+' has been successfully created in SAP.<br/>Please : <br/>1. Release the demands for time-bound milestones in the system. <br/>2. Welcome-call e-mail to the customer.<br/><br/>Thanks & regards, <br/>Lodha CC Admin';
                sp.send_email(subject,html_body_new1,BookingMap.get(a.id).Flat__r.Wing__r.Cluster__r.Project_Name__r.Project_Incharge__c);   
                
                string html_body_new2 ='Dear '+BookingMap.get(a.id).Flat__r.Wing__r.Cluster__r.Project_Name__r.Sap_Mapper__r.Name+',<br/><br/>Sales order no. '+BookingMap.get(a.id).SALESORDER_NO__c+' has been generated for Customer <b>'+BookingMap.get(a.id).Name_of_Applicant__c+'</b>, <b>'+BookingMap.get(a.id).CRN_Number_SAP__c+'</b> for his booking dated '+Date.ValueOf(BookingMap.get(a.id).Application_Date__c)+' in '+BookingMap.get(a.id).Oasys_Flat_Code__c+' has been successfully created in SAP.<br/>Please : <br/>1. Release the demands for time-bound milestones in the system. <br/>2. Welcome-call e-mail to the customer.<br/><br/>Thanks & regards, <br/>Lodha CC Admin';
                sp.send_email(subject,html_body_new2,BookingMap.get(a.id).Flat__r.Wing__r.Cluster__r.Project_Name__r.Sap_Mapper__c); 
                
                string html_body_new3 ='Dear '+BookingMap.get(a.id).Flat__r.Wing__r.RM_Team_Lead__r.Name+',<br/><br/>Sales order no. '+BookingMap.get(a.id).SALESORDER_NO__c+' has been generated for Customer <b>'+BookingMap.get(a.id).Name_of_Applicant__c+'</b>, <b>'+BookingMap.get(a.id).CRN_Number_SAP__c+'</b> for his booking dated '+Date.ValueOf(BookingMap.get(a.id).Application_Date__c)+' in '+BookingMap.get(a.id).Oasys_Flat_Code__c+' has been successfully created in SAP.<br/>Please : <br/>1. Release the demands for time-bound milestones in the system. <br/>2. Welcome-call e-mail to the customer.<br/><br/>Thanks & regards, <br/>Lodha CC Admin';
                sp.send_email(subject,html_body_new3,BookingMap.get(a.id).Flat__r.Wing__r.RM_Team_Lead__c); 
            }
        
        }
    }
    if(SOTrigger.block == false && stopUnneccessaryupdate==true){
    SOTrigger.block=true;
    system.debug('!!!!!!!block'+block);
    update BookingMap.values();
    update flat.values();
    update FAMEMap.values();
    }
    
}
}