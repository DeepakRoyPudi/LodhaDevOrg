/**********************************************************************************
Name:  CM_SLAEscalationBatch
Copyright © 2013  Lodha Group
===================================================================================
===================================================================================
Purpose:
-------
Batch job to take care SLA escalation of case
===================================================================================
===================================================================================
History
-------
VERSION    AUTHOR              DATE               DETAIL              
1.0 -   CG Dev Team          07/12/2013      INITIAL DEVELOPMENT
**********************************************************************************/

global class CM_SLAEscalationBatch implements Database.Batchable<SObject>{
    
    global final string query;
    
    //Description : Constructor for the SLA Escalation batch.
    
    global CM_SLAEscalationBatch(){
        //query = 'Select CaseNumber,Status,IsEscalated,IsClosed,BusinessHoursId,ClosedDate,CreatedDate,CM_TAT__c from Case Where IsClosed = false and IsEscalated = false';                       
        query = 'Select CM_Alert_Time__c,CM_Alerted__c,CaseNumber,Status,IsEscalated,IsClosed,IsDuplicate__c, BusinessHoursId,ClosedDate,CreatedDate,CM_TAT__c from Case Where IsClosed = false and IsDuplicate__c = false and IsEscalated = false';                       
    }
    
    //Description : Start method for the SLA Escalation batch which will process batch of case records.
      
    global Database.QueryLocator start(Database.BatchableContext BC){       
        return Database.getQueryLocator(query);      
    }         
    
    //Description : Process the retrieved records to find out whether it has exceeded the TAT .
      
    global void execute(Database.BatchableContext BC, List<Case> scope){
        
        caseComment caseCommentVar;
        double timeTaken;
        datetime timeSLA;
        List<Case> caseList =  new List<Case>();
        List<Case> caseList1 =  new List<Case>();
        List<caseComment> caseCommentList = new List<caseComment>();
        List<caseComment> caseCommentList1 = new List<caseComment>();
                
        for(Case caseVar : scope){
            
            //Calculating time spent on a open case
            timeTaken = BusinessHours.diff(caseVar.BusinessHoursId, caseVar.CreatedDate, system.Now())/1000;
            Integer s = Integer.valueof(timeTaken); 
            timeSLA = caseVar.CreatedDate.addSeconds(s);
            
            system.debug('@@ timeTaken : '+timeTaken);
            system.debug('@@ timeTaken : '+timeSLA);
            
                system.debug('@@## id: '+caseVar.Id);
            system.debug('@@## Alert time: '+caseVar.CM_Alert_Time__c);
            system.debug('@@## Alert time: '+caseVar.CM_TAT__c);
            system.debug('@@## CM_Alerted__c : '+caseVar.CM_Alerted__c );
            
            //Added Newly        
            if(timeSLA > caseVar.CM_Alert_Time__c && caseVar.CM_Alerted__c != True){
            
                system.debug('@@## inside time: '+timeSLA);
                system.debug('@@## Alert time: '+caseVar.CM_Alert_Time__c);
                system.debug('@@## CM_Alerted__c : '+caseVar.CM_Alerted__c );
                
                caseVar.CM_Alerted__c = True;
                
                system.debug('@@## CM_Alerted__c : '+caseVar.CM_Alerted__c );
                
                caseCommentVar = new caseComment();
                caseCommentVar.CommentBody = 'BatchJob Run successfully and this case has been Alerted regarding SLA Violation';
                caseCommentVar.ParentId = caseVar.Id;
                caseCommentList.add(caseCommentVar);
                caseList.add(caseVar);
                system.debug('@@## caselst: '+caseList.size());
            system.debug('@@## caseCommentList: '+caseCommentList.size());
            } else if( timeSLA > caseVar.CM_TAT__c){
                caseVar.IsEscalated = true;
                caseVar.Escalated_To__c = 'L1';
                caseCommentVar = new caseComment();
                caseCommentVar.CommentBody = 'BatchJob Run successfully and this case violated the SLA';
                caseCommentVar.ParentId = caseVar.Id;
                caseCommentList1.add(caseCommentVar);
                caseList1.add(caseVar);
            }  
            system.debug('@@## caselst1: '+caseList1.size());
            system.debug('@@## caseCommentList1: '+caseCommentList1.size());     
        }
        if(caseList.size()!=0 && caseList.size()!= null && caseCommentList.size()!=0 && caseCommentList != null ){
            try{
                upsert caseList;
                upsert caseCommentList;
            }catch(Exception e){
                system.debug(e);
            }
        }else if(caseList1.size()!=0 && caseList1.size()!= null && caseCommentList1.size()!=0 && caseCommentList1 != null ){
            try{
                upsert caseList1;
                upsert caseCommentList1;
            }catch(Exception e){
                system.debug(e);
            }
        }
    }         
    
    //Description : Process the retrieved records to find out whether it has exceeded the TAT .
      
    global void finish(Database.BatchableContext BC){
    }  
}