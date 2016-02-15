/**********************************************************************************
Name:  CM_Upd_Val_SMS_Notification
Copyright © 2013  Lodha Group
===================================================================================
===================================================================================
Purpose:
-------
Controller For CM_CaseUpdationsValidationsAndSMSNotification Case Trigger
===================================================================================
===================================================================================
History
-------
VERSION    AUTHOR                DATE             DETAIL              
1.0 -   CG Dev Team          27/11/2013      INITIAL DEVELOPMENT
**********************************************************************************/

public class CM_Upd_Val_SMS_Notification{
    
    public Boolean stopSms{get;set;}
    public String mobile{get;set;}
    public String smsText{get;set;}
    public String smsType{get;set;}
    public String CaseId{get;set;}
    public String caseNumber{get;set;}
    public String caseCreator{get;set;}
    
    
    Public CM_Upd_Val_SMS_Notification(){    
        stopSms=false;
    }
    //Method to send sms notification to customer when a new case is created
    public void sendCaseCreationSMSAfterInsert(List<Case> caseList){
        
        List<smagicinteract__smsMagic__c> smsObjList = new List<smagicinteract__smsMagic__c>();
        
        try{
            for(Case c: caseList){
                
                if(c.Status != 'Closed Satisfied' && c.Status != 'Closed UnSatisfied' && c.Communication_Type__c == 'Inbound'){
                    
                    CaseId = c.Id;
                    caseNumber = c.caseNumber;
                    mobile = c.Mobile_Phone__c;
                    caseCreator = c.Createdby.Name;
                    smsType = 'Case Creation';
                    smsText = 'We have noted your request/requirement and Case ID for the same is '+caseNumber+'. Regards, '+caseCreator;
                    
                    smagicinteract__smsMagic__c smsObj = new smagicinteract__smsMagic__c();
                    
                    smsObj.smagicinteract__PhoneNumber__c = mobile;
                    smsObj.smagicinteract__SMSText__c = smsText;
                    smsObj.smagicinteract__SenderId__c = 'Lodha-CRM';
                    smsObj.Case__c = CaseId;                
                    smsObj.SMS_Type__c = smsType;
                    smsObj.smagicinteract_Name_custom__c = c.Account.Name;              
                    smsObj.smagicinteract__external_field__c = smagicinteract.ApexAPI.generateUniqueKey();
                    
                    system.debug('## smsObj : '+smsObj);
                    
                    smsObjList.add(smsObj);
                    
                    if(stopSms == true){
                        smsObj.smagicinteract__disableSMSOnTrigger__c = 1;
                    }
                    else{
                        smsObj.smagicinteract__disableSMSOnTrigger__c = 0;
                    }
                }        
            }
            
            //insert smsObjList;
            
        }
            catch(Exception exp)
        {
            system.debug('## Exception occcured while sending SMS : '+exp); 
        }
    }
    
    //Method to send sms notification to customer when a new case is created
    public void sendCaseClosureSMSAfterInsertOrUpdate(List<Case> caseCloseList){
        
        List<smagicinteract__smsMagic__c> smsObjList = new List<smagicinteract__smsMagic__c>();
        
        try{
            for(Case c: caseCloseList){
                if((c.Status == 'Closed Satisfied' || c.Status == 'Closed UnSatisfied') && c.Communication_Type__c == 'Inbound'){
                    CaseId = c.Id;
                    caseNumber = c.caseNumber;
                    mobile = c.Mobile_Phone__c;
                    caseCreator = c.Createdby.Name;
                    smsType = 'Case Closure';
                    smsText = 'This is to notify that we have completed your request submitted via Case ID '+caseNumber+'. Regards, '+caseCreator;
                    
                    smagicinteract__smsMagic__c smsObj = new smagicinteract__smsMagic__c();
                    
                    smsObj.smagicinteract__PhoneNumber__c = mobile;
                    smsObj.smagicinteract__SMSText__c = smsText;
                    smsObj.smagicinteract__SenderId__c = 'Lodha-CRM';
                    smsObj.Case__c = CaseId;                
                    smsObj.SMS_Type__c = smsType;
                    smsObj.smagicinteract_Name_custom__c = c.Account.Name;              
                    smsObj.smagicinteract__external_field__c = smagicinteract.ApexAPI.generateUniqueKey();
                    
                    system.debug('## smsObj : '+smsObj);
                    
                    smsObjList.add(smsObj);
                    
                    if(stopSms == true){
                        smsObj.smagicinteract__disableSMSOnTrigger__c = 1;
                    }
                    else{
                        smsObj.smagicinteract__disableSMSOnTrigger__c = 0;
                    }
                }
            }
            
            //insert smsObjList;
        }
            catch(Exception exp)
        {
            system.debug('## Exception occcured while sending SMS : '+exp); 
        }
    }
    
    
    public List<Assignment_Group_Queues__c> agQueueList{get;set;}
    
    public void orgQueueName(List<Case> queueNewList){
        
        List<Case> csList = new List<Case>();
        
        agQueueList = [SELECT Id,Name,QueueId__c FROM Assignment_Group_Queues__c];
        
        try{
            for(Case c: queueNewList){
                for(Assignment_Group_Queues__c ag : agQueueList){
                
                    if(ag.QueueId__c == c.Queue_Id__c){
                        c.Queue_Name__c = ag.Name;
                        system.debug('## c.Queue_Name__c : '+c.Queue_Name__c); 
                        
                        csList.add(c);
                        
                    }
                }
            }
            
            update csList;
        }
            catch(Exception exp)
        {
            system.debug('## Exception occcured : '+exp); 
        }
        
    }
    
    
        
    
    
    /*
    Id recTypeDummyParentId = [SELECT Id,Name FROM RecordType WHERE Name = 'CM_Dummy_Parent' LIMIT 1].Id;        
    Id recTypeParentOnlyId = [SELECT Id,Name FROM RecordType WHERE Name = 'CM_Parent_Only' LIMIT 1].Id;
    Id recTypeChildCaseId = [SELECT Id,Name FROM RecordType WHERE Name = 'CM_Child_Case' LIMIT 1].Id;        
    Id recTypeActionItemId = [SELECT Id,Name FROM RecordType WHERE Name = 'CM_Action_Item' LIMIT 1].Id;
    */
    
    public void updateEscalatedToEmail(List<Case> newCaseList){
        
        List<CM_Escalated_To__c> escList = [SELECT CaseType__c,Email__c,Escalated_To__c,Id,Name,Assignee__c FROM CM_Escalated_To__c];
        
        for (Case c : newCaseList){
            if(c.TL_EmailId__c != ''){
                c.TL_Email_Id__c = c.TL_EmailId__c;
            }
            if(c.PIC_EmailId__c != ''){
                c.PIC_Email_Id__c = c.PIC_EmailId__c;
            }
            
            for (CM_Escalated_To__c cs : escList){
                if(c.CaseType__c == cs.CaseType__c && c.Escalated_To__c == cs.Escalated_To__c ){
                    c.Escalated_To_EmailId__c = cs.Email__c;
                    c.Escalated_To_Name__c = cs.Assignee__c;
                }
                
            }
        }
    }
    
    
     public void sendComplaintCaseNotificationEmail(List<Case> newCaseList){
         System.debug('2..............................');
         for (Case c : newCaseList){
             System.debug('2.1........c.Nature_of_Request__c .............' + c.Nature_of_Request__c );
             if (c.Nature_of_Request__c == 'Complaint' ){
                 System.debug('3......................................');
                 //CM_ComplaintCasesReportGenerator obj = new CM_ComplaintCasesReportGenerator();
                 //obj.execute(newCaseList, true, null, null);
                 CM_ComplaintCasesReportHelper helperObj = new CM_ComplaintCasesReportHelper();
                 helperObj.execute(newCaseList, true, c.createdDate, '', true);
             }else if (c.Nature_of_Request__c == 'Grievance' ){
                 System.debug('4......................................');
                 //CM_ComplaintCasesReportGenerator obj = new CM_ComplaintCasesReportGenerator();
                 //obj.execute(newCaseList, true, null, null);
                 CM_ComplaintCasesReportHelper helperObj = new CM_ComplaintCasesReportHelper();
                 helperObj.execute(newCaseList, true, c.createdDate, '', false);
             }
         }
     }
    
    
}