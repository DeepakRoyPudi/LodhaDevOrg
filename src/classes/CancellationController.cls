public class CancellationController {

Public string booking_Id {get; set;}
Public Booking_Information__c booking{get; set;}
Public boolean iscancelled {get; set;}
Public boolean isNegativeRetention {get; set;}
Public Boolean IsRemarks {get; set;}
Public flat__c flat;
Public Project_Name__c projdet;
Public opportunity opp;
Public boolean isApprover{get; set;}
Public Account BookedAccount;
Public CancellationController(){
    booking_Id = ApexPages.currentPage().getParameters().get('bookingid');
    IsRemarks =false;
    isNegativeRetention =false;
    isApprover=false;
    iscancelled = true;
    try{
    booking=[select id,Booking_Status__c,Cancellation_Date__c,CRN_Number_SAP__c,Cancel_Confirm_Date__c,Flat__c,Sales_Person__c,SALESORDER_NO__c,Sales_Person__r.name,Confirmation_Date__c ,Unique_booking_Id__c,CreatedBy.FirstName,CreatedBy.LastName,CreatedById,Cancellation_Type__c,Project_Hidden__c,has_the_customer_initiated_deed_of_cance__c,Oasys_Flat_Code__c,Name_Of_Opportunity__c,Has_retention_efforts_been_carried_out__c,InActive__c,Is_the_customer_registered__c,Confirmation_Remark__c,Approval_sought__c,Approver_s_name__c,Reason_for_Cancellation__c,Name_of_Applicant__c ,Result_of_retention_efforts__c from Booking_Information__c where id=:booking_Id];
    if(booking != null){
       if(booking.Booking_Status__c == 'SOLD' && booking.InActive__c==false){
            iscancelled = true;
        }
        else{
            iscancelled = false;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'This Booking is not allowed to cancellation'));        
        }
    }
    flat=[Select Id, Name, Wing__r.name,Flat_Type__r.Name,Wing__c, Wing__r.Project__c,View__c, Total_Rate_Sq_Ft_Rs__c, Token_Amount_Rs__c,Status__c, Stage_Completed__c, Salable_Area__c, Premium_Sq_Ft_Rs__c,
                   Infrastructure_Incl_in_CV__c, Infrastructure_Cost_Rs__c, Infrastructure_Cost2_Rs__c, Infrastructure2_Incl_in_CV__c,
                   Floor__c, Floor_Rise_Sq_Ft_Rs__c, Flat_Type__c, Flat_No__c, Flat_Cost_Rs__c,Wing__r.Cluster_hidden__c,Wing__r.Project_Incharge_Relationship_Manager__c,
                   DAM_Offer_Sq_Ft_Rs__c, Consideration_Rs__c, Club_Charges_Rs__c, Club_Charges_Incl_in_CV__c, Carpet_Area__c, Base_Rate_Sq_Ft_Rs__c,Oasys_Flat_code__c,
                   Applicable_Waiver_Sq_Ft_Rs__c, Wing__r.Project_Incharge_Relationship_Manager__r.Name, Calculated_Total_SqFt_Rate__c,Amount_Due_Rs__c From Flat__c Where Id =:booking.Flat__c];
    projdet = [select Name, Project_Incharge__c, Site_Incharge__c,Sales_Strategist__c,Sales_Strategist__r.name,Site_Incharge__r.Name, Project_Incharge__r.Name, Project_Type__c from Project_Name__c where Name=: booking.Project_Hidden__c];
    opp= [select id from opportunity where id=:booking.Name_Of_Opportunity__c];
    }
    catch(exception e){
        system.debug('!!!!!!!!!!!e'+e);
    }
}

Public pagereference renderRemarks(){
    /*if(booking.has_the_customer_initiated_deed_of_cance__c=='Yes'){
        IsRemarks =true;
    }
    else{
        IsRemarks =false;
        booking.Confirmation_Remark__c=null;
    }*/
    
    if(booking.Result_of_retention_efforts__c == 'Positive'){
        isNegativeRetention=true;
    }
    else{
        isNegativeRetention=false;
        booking.Cancel_Confirm_Date__c=null;
    }
    
    if(booking.Approval_sought__c =='Yes'){
        isApprover=true;
    }
    else{
        isApprover=false;
        booking.Approver_s_name__c=null;
    }
    return null;
}
Public pagereference renderdateofConfirm(){

    return null;

}

public PageReference Confirm() {
     String cancel=[select id,InActive__c,Booking_Status__c from Booking_Information__c where id=:booking_Id].Booking_Status__c;
     String Id=[select id,flat__c,InActive__c,Booking_Status__c from Booking_Information__c where id=:booking_Id].flat__c;
     boolean cancelconfirm=false;
     boolean cancellationflat=false;
     string Booking_createdby_name=[select id,name from user where id=:booking.CreatedById].name;
 
     try {
          if(cancel == 'SOLD' && booking.InActive__c==false){
            if(booking.Cancellation_Type__c ==null || booking.Is_the_customer_registered__c == null || (booking.Is_the_customer_registered__c == 'Yes' && booking.has_the_customer_initiated_deed_of_cance__c==null) || (booking.has_the_customer_initiated_deed_of_cance__c=='No' && booking.Confirmation_Remark__c == null)|| booking.Has_retention_efforts_been_carried_out__c==null || (booking.Has_retention_efforts_been_carried_out__c=='Yes' && booking.Result_of_retention_efforts__c ==null) || (booking.Result_of_retention_efforts__c == 'Positive' && booking.Cancel_Confirm_Date__c==null) || (booking.Result_of_retention_efforts__c != 'Positive' && booking.Cancel_Confirm_Date__c!=null)|| booking.Approval_sought__c == null || (booking.Approval_sought__c == 'Yes' && booking.Approver_s_name__c ==null) || booking.Reason_for_Cancellation__c ==null ){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please provide mandatory fields...'));
                return null;
            }
            flat.Status__c = 'OPEN';
            booking.Booking_Status__c ='CANCELLATION';
            booking.Flat__c = null;
            booking.InActive__c = TRUE;
            //booking.Cancellation_Date__c=date.today();
            //booking.Confirmation_Date__c = null;
            Upsert booking;
            cancelconfirm= true; 
            flat.Actual_Consideration__c = 0;            
        }
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Booking Cancelled already'));
           return null;
        }
      }
      catch(DMLException e) {
        cancelconfirm= false;
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Booking Cancellation Failed' + e.getMessage()));
        System.debug('Booking Cancellation Failed' + e.getMessage());
      } 
      
    try {
        if(cancelconfirm==true){
          update flat;
          cancellationflat=true;
        }
    }
    catch(DMLException e) {
      cancellationflat=false;
      System.debug('Update Flat Failed' + e.getMessage());
    }
     try{
        System.debug('cancellationstatus1' + cancellationflat);
              if(cancellationflat==true){
                  BookedAccount=[select id,ispersonaccount,IsJodi__c,Jodi_Account__c,Jodi_Flat__c,Jodi_Indicator__c,lastname,status__c,crn__c from account where recordtype.name='booked account' and crn__c=:booking.CRN_Number_SAP__c limit 1];
                  List<account> JodiAccountLst;
                  if(BookedAccount != null){
                      System.debug('booked account'+BookedAccount);
                      if( BookedAccount.IsJodi__c==true && BookedAccount.Jodi_Flat__c ==true && BookedAccount.Jodi_Account__c != null ){
                          System.debug('booked account child jodis');
                          JodiAccountLst=[select id,ispersonaccount,IsJodi__c,Jodi_Account__c,Jodi_Flat__c,Jodi_Indicator__c,lastname,status__c,crn__c from account where recordtype.name='booked account' AND ( Jodi_Account__c=:BookedAccount.Jodi_Account__c OR Id=:BookedAccount.Jodi_Account__c )];
                          System.debug('booked account child jodis after'+JodiAccountLst);
                      }
                      else if(BookedAccount.IsJodi__c==true && BookedAccount.Jodi_Flat__c ==false && BookedAccount.Jodi_Account__c == null){
                          System.debug('booked account parent jodi');
                          JodiAccountLst=[select id,ispersonaccount,IsJodi__c,Jodi_Account__c,Jodi_Flat__c,Jodi_Indicator__c,lastname,status__c,crn__c from account where recordtype.name='booked account' AND ( Jodi_Account__c=:BookedAccount.Id OR Id=:BookedAccount.Id )];
                          System.debug('booked account parent jodis after'+JodiAccountLst);
                      }
                                                           
                      if(JodiAccountLst != null && JodiAccountLst.size() > 0){
                          System.debug('inside updates start');                           
                          for(Account acc:JodiAccountLst){
                              
                              System.debug('inside updates all');   
                              acc.IsJodi__c=false;
                              acc.Jodi_Account__c=null;
                              acc.Jodi_Flat__c=false;     
                              if(acc.id==BookedAccount.id){
                                  System.debug('inside updates parent');   
                                  acc.status__c='Cancelled';
                              }                                                
                          }
                          System.debug('JodiAccountLst final'+JodiAccountLst);   
                          update JodiAccountLst;
                      }
                      else{
                          System.debug('booked account');
                          BookedAccount.status__c='Cancelled';
                          update BookedAccount;
                      }
                      
                  }
                  System.debug('went inside' +cancellationflat+booking.Flat__c+BookedAccount);
                  //flat__c myflat=[select id,wing__c from flat__c where id=:Id];
                  wing__c mywing=[select id from wing__c where id=:flat.Wing__c limit 1];
                  System.debug('went inside1' +cancellationflat+mywing);
                  if(Test.isRunningTest()==false){
                      SpGenerateInventory generateInventer=new SpGenerateInventory(mywing);
                      generateInventer.generateInventory(); 
                  }
                  ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Booking got cancelled successfully'));             
             
                  //send email to SM
                  string subject = 'Inventory has been opened up-' + booking.Oasys_Flat_Code__c;
                  
                  String html = 'Hello ' +Booking_createdby_name + ' ,' + '<br/><br/> The Inventory has been opened up because of cancellation of booking named' + booking.Name_of_Applicant__c + ' with ' +   booking.Oasys_Flat_Code__c + '<br/>Please take neccessary action.<br/> Please find Cancellation Details Below:<br/>Cancellation Date: '+booking.Cancellation_Date__c+',<br/>Reason for Cancellation: '+booking.Reason_for_Cancellation__c+'<br/>Related Opportunity Link: '+URL.getSalesforceBaseUrl().toExternalForm()+'/'+opp.id+' for complete Details.<br/><br/>Regards,<br/>Lodha_CC_Admin';
                  String html_sm = 'Hello ' +booking.Sales_Person__r.name + ' ,' + '<br/><br/> The Inventory has been opened up because of cancellation of booking named' + booking.Name_of_Applicant__c + ' with ' +   booking.Oasys_Flat_Code__c + '<br/>Please take neccessary action.<br/> Please find Cancellation Details Below:<br/>Cancellation Date: '+booking.Cancellation_Date__c+',<br/>Reason for Cancellation: '+booking.Reason_for_Cancellation__c+'<br/>Related Opportunity Link: '+URL.getSalesforceBaseUrl().toExternalForm()+'/'+opp.id+' for complete Details.<br/><br/>Regards,<br/>Lodha_CC_Admin';
                  
                  
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
                  
                  //send email to SS

                  String html1 = 'Hello ' + projdet.Sales_Strategist__r.name +',' + '<br/><br/> The Inventory has been opened up because of cancellation of booking named' + booking.Name_of_Applicant__c + ' with ' +   booking.Oasys_Flat_Code__c + '<br/>Please take neccessary action.<br/>Please find Cancellation Details Below:<br/>Cancellation Date: '+booking.Cancellation_Date__c+',<br/>Reason for Cancellation: '+booking.Reason_for_Cancellation__c+'<br/>Related Opportunity Link: '+URL.getSalesforceBaseUrl().toExternalForm()+'/'+opp.id+' for complete Details.<br/><br/>Regards,<br/>Lodha_CC_Admin';
                  send_email(subject, html1 ,projdet.Sales_Strategist__c);
                  
                  //send email to Admin SM ( once get who is the user, need to put here.--->crm.admin@lodhagroup.com)

                  String html4 = 'Hello Sales Admin,' + '<br/><br/> The Inventory has been opened up because of cancellation of booking named' + booking.Name_of_Applicant__c + ' with ' +   booking.Oasys_Flat_Code__c + '<br/>Please take neccessary action.<br/>Please find Cancellation Details Below:<br/>Cancellation Date: '+booking.Cancellation_Date__c+',<br/>Reason for Cancellation: '+booking.Reason_for_Cancellation__c+'<br/>Related Opportunity Link: '+URL.getSalesforceBaseUrl().toExternalForm()+'/'+opp.id+' for complete Details.<br/><br/>Regards,<br/>Lodha_CC_Admin';
                  send_email(subject, html4 ,sp_2_email_user_config__c.getinstance('Inventory_openup_for_adminSM').User_Id__c);
                  
                  //send email to RM

                  String html2 = 'Hello ' + flat.Wing__r.Project_Incharge_Relationship_Manager__r.Name +',' + '<br/><br/> The Inventory has been opened up because of cancellation of booking named' + booking.Name_of_Applicant__c + ' with ' +   booking.Oasys_Flat_Code__c + '<br/>Please take neccessary action.<br/>Please find Cancellation Details Below:<br/>Cancellation Date: '+booking.Cancellation_Date__c+',<br/>Reason for Cancellation: '+booking.Reason_for_Cancellation__c+'<br/>Related Opportunity Link: '+URL.getSalesforceBaseUrl().toExternalForm()+'/'+opp.id+' for complete Details.<br/><br/>Regards,<br/>Lodha_CC_Admin';
                  send_email(subject, html2 ,flat.Wing__r.Project_Incharge_Relationship_Manager__c);
                  
                  //send email to PI

                  String html3 = 'Hello ' + projdet.Project_Incharge__r.name +',' + '<br/><br/> The Inventory has been opened up because of cancellation of booking named' + booking.Name_of_Applicant__c + ' with ' +   booking.Oasys_Flat_Code__c + '<br/>Please take neccessary action.<br/>Please find Cancellation Details Below:<br/>Cancellation Date: '+booking.Cancellation_Date__c+',<br/>Reason for Cancellation: '+booking.Reason_for_Cancellation__c+'<br/>Related Opportunity Link: '+URL.getSalesforceBaseUrl().toExternalForm()+'/'+opp.id+' for complete Details.<br/><br/>Regards,<br/>Lodha_CC_Admin';
                  send_email(subject, html3 ,projdet.Project_Incharge__c);
             
              }
        }
        catch(DMLException e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Booking Cancellation Failed1' + e.getMessage()));
            System.debug('Booking Cancellation Failed1' + e.getMessage());
        }
        
     
   return null;
}

public static void send_email(String subject, String html_body, Id receipient_id) {
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

public void send_email1(String subject, String html_body,string receipient_id) {
  system.debug('Subject: ' + subject + ' Html_body' + html_body + ' Id: ' + receipient_id);
  Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
  string[] toaddress=new string[]{receipient_id};
  mail.setBccSender(false);
  mail.setUseSignature(false);
  mail.setSubject(subject);
  mail.setHtmlBody(html_body);
  mail.setReplyTo('noreplay@LodhaGroup.com');
  mail.setSenderDisplayName('Lodha Admin');
  mail.setSaveAsActivity(false); 
  mail.settoaddresses(toaddress);
  if(Test.isRunningtest()==false){
      Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
  }
}

}