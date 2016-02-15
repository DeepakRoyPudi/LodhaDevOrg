/**********************************************************************************
Name:  Sendmailforcases
Copyright © 2012  Lodha Group
===================================================================================
===================================================================================
Purpose:
-------
For sending notification mails
===================================================================================
===================================================================================
History
-------
VERSION    AUTHOR                DATE             DETAIL              
1.0 -   CG Dev Team          20/07/2012      INITIAL DEVELOPMENT
**********************************************************************************/

Public class Sendmailforcases{
    
    List<Case> caseList{get; set;}
    String CaseId;
    String user;
    String manager;
    String custname;
    String email;
    String mobile;
    String subject;
    
    //Method to send email notification when a new case is created
    public void sendmailafterinsert(List<Case> caseList){
    
        try{
            for(Case c: caseList){
                CaseId = c.Id;
                user = c.CreatedbyId;
                manager = c.Manager__c;
                custname= c.Account.Name;
                mobile=c.Mobile_Phone__c;
                subject=c.Subject;
            }
            
            User myUser = [SELECT Id, Name, Email FROM User where name=:manager LIMIT 1];
                email = myUser.email;
               
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            //To address
            String[] toAdd =  new String[]{email};
            mail.setToAddresses(toAdd);
           
            //Reply to address
            mail.setReplyTo('noreply@lodhagroup.com');
            
            //Display name
            mail.setSenderDisplayName('Lodha Group');
            
            //Subject
            mail.setSubject('New Case Created');
            
            //Body content
            String htmlcontent='<p> Dear '+manager+',</p><p> A new case : "'+CaseId+'" with the subject "'+subject+'" has been created for customer "'+custname+
            '" having mobile number  "'+mobile+'"  by user : "' +user+ '" . </p><p>Regards,</p><p> Team - Lodha Group</p>' ;
            
            mail.sethtmlbody(htmlcontent);
            
            //Bcc sender
            mail.setBccSender(false);
            
            //Signature
            mail.setUseSignature(false);
            
            //Sending mail
            List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.Email[]{ mail });
        }
            catch(Exception exp)
        {
            system.debug('Exception occcured while sending mail'+exp); 
        }
    }
    
    //Method to send email notification after editing.
    public void sendmailafterupdate(List<Case> caseList){
        try{
            for(Case c: caseList){
                CaseId = c.Id;
                user = c.CreatedbyId;
                manager = c.Manager__c;
                custname= c.Account.Name;
                mobile=c.Mobile_Phone__c;
            }
            
            User myUser = [SELECT Id, Name, Email FROM User where name=:manager LIMIT 1];
                email = myUser.email;
               
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            //To address
            String[] toAdd =  new String[]{email};
            mail.setToAddresses(toAdd);
           
            //Reply to address
            mail.setReplyTo('noreply@lodhagroup.com');
            
            //Display name
            mail.setSenderDisplayName('Lodha Group');
            
            //Subject
            mail.setSubject('Case has been edited');
            
            //Body content
            String htmlcontent='<p> Dear '+manager+',</p><p> Customer information has been edited for "'+custname+
            '" having mobile number  "'+mobile+'"  by user : "' +user+ '" . </p><p>Regards,</p><p> Team - Lodha Group</p>' ;
            
            mail.sethtmlbody(htmlcontent);
            
            //Bcc sender
            mail.setBccSender(false);
            
            //Signature
            mail.setUseSignature(false);
            
            //Sending mail
            List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.Email[]{ mail });
        }
            catch(Exception exp)
        {
            system.debug('Exception occcured while sending mail'+exp); 
        }
    }
    
    
    //Method to send email notification when ADF is accepted
    public void adfNotification( List<Case> mapNew, Map<id,Case> mapOld){
        
        try{
        
            set<Id> CaseIds = new set<Id>();
            
            caseList = [Select Id, AccountId, Account.Name, Mobile_Phone__c, CreatedById, Manager__c, ADF__c, Subject from Case where id IN: CaseIds];
            
            for(Case ch : mapNew){    
                CaseIds.add(ch.id);
             
            }
            
            if(mapOld == null){
                
                //insert action
                for(Case ch : mapNew){
                
                    if(ch.ADF__c == 'Yes' || ch.ADF__c == 'No'){
                        adfNotificationMail(caseList);    
                    }
                }
            }else{
                 
                //update action
                for(Case ch : mapNew){
                    
                    //get case value from old map
                    Case oldCase = mapOld.get(ch.id);
                    
                    if((ch.ADF__c != oldCase.ADF__c)&&(ch.ADF__c !='none')){
                        adfNotificationMail(caseList);    
                    }
                }
            
            }
        }
            catch(Exception exp)
        {
            system.debug('Exception occcured on ADF notification'+exp); 
        }
       
    }
    
    
    
    //Email Template for ADF Notifation
    public void adfNotificationMail(List<Case> caseList){
    
        try{
                    
            for(Case c: caseList){
                CaseId = c.Id;
                user = c.CreatedbyId;
                manager = c.Manager__c;
                custname= c.Account.Name;
                mobile=c.Mobile_Phone__c;
            }
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            //To address
            String[] toAdd =  new String[]{'Arvind.kale@lodhagroup.com','Sangeeta.parab@lodhagroup.com'};
            mail.setToAddresses(toAdd);
            
            //Reply to address
            mail.setReplyTo('noreply@lodhagroup.com');
            
            //Display name
            mail.setSenderDisplayName('Lodha Group');
            
            //Subject
            mail.setSubject('ADF Notification');
            
            //Body content
            String htmlcontent='<p> To Lodha Group,</p><p>The customer "'+custname+'" having mobile number "'+mobile+
            '" has accepted ADF in case : "'+CaseId+'" created by user "' +user+ 
            '" </p><p>Thanks & Regards,</p><p> Support Team</p>' ;
            
            mail.sethtmlbody(htmlcontent);
            
            //Bcc sender
            mail.setBccSender(false);
            
            //Signature
            mail.setUseSignature(false);
            
            //Sending mail
            List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.Email[]{ mail });
        }
            catch(Exception exp)
        {
            system.debug('Exception occcured while sending mail :' + exp); 
        }
    }
    
}