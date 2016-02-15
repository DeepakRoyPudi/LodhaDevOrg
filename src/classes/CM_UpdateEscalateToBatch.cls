/**********************************************************************************
Name:  CM_UpdateEscalateToBatch 
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
1.0 -   CG Dev Team          14/12/2013      INITIAL DEVELOPMENT
**********************************************************************************/

global class CM_UpdateEscalateToBatch implements Database.Batchable<SObject>{
    
    global final string query;
    
    //Description : Constructor for the Escalated To batch.
    
    global CM_UpdateEscalateToBatch(){
        //query = 'Select CaseNumber,Status,IsEscalated,IsClosed,BusinessHoursId,ClosedDate,CreatedDate,CM_TAT__c,Escalated_To__c from Case Where IsClosed = false and IsEscalated = true';                       
        /* added logic to exclude duplicate cases */        
        query = 'Select CaseNumber,Status,IsEscalated,IsClosed,IsDuplicate__c, BusinessHoursId,ClosedDate,CreatedDate,CM_TAT__c,Escalated_To__c from Case Where IsClosed = false and IsDuplicate__c = false and IsEscalated = true';                       
    }
    
    //Description : Start method for the Escalated To batch which will process batch of case records.
      
    global Database.QueryLocator start(Database.BatchableContext BC){       
        return Database.getQueryLocator(query);      
    }         
    
    //Description : Process the retrieved records to find out whether it has exceeded the TAT leveles .
      
    global void execute(Database.BatchableContext BC, List<Case> scope){
        
        datetime level2;
        datetime level3;
        datetime level4;
        
        List<Case> caseList =  new List<Case>();
                
        for(Case caseVar : scope){
            
            //Esclated to Levels
            
            level2 = caseVar.CM_TAT__c+2; level3 = caseVar.CM_TAT__c+4; level4 = caseVar.CM_TAT__c+6;
            
            system.debug('@@ level2 : '+level2);
            system.debug('@@ level3 : '+level3);
            system.debug('@@ level4 : '+level4);       
                    
            if((caseVar.Escalated_To__c == 'L1') && (level2 < system.now())){caseVar.Escalated_To__c = 'L2';caseList.add(caseVar);}
            
            if((caseVar.Escalated_To__c == 'L2') && ( level3 < system.now())){caseVar.Escalated_To__c = 'L3';caseList.add(caseVar);}
            
            if((caseVar.Escalated_To__c == 'L3') && ( level4 < system.now())){caseVar.Escalated_To__c = 'L4';caseList.add(caseVar);}
                        
            system.debug('@@ caseList.size() : '+caseList.size());
        }
        if(caseList.size()!=0 && caseList != null){
            try{
                upsert caseList;
            }catch(Exception e){system.debug(e);}
        }
    }         
    
    //Description : Process the retrieved records to find out whether it has exceeded the TAT .
      
    global void finish(Database.BatchableContext BC){
    }  
}