/*
*    Description    :    After Insert and After Update Trigger on Case Object
*
*    Version            Date                Author                Description
*    1.0                27/11/2013          Capgemini             Initial Draft
*    1.1                07/08/2014          Sid (Eternus)         Commented code to send Email notification
*                                                                 on Case Creation / Case Closure
*                                                                 due to breach of limit of sending 1000 emails per day
*    1.2                09/10/2014          Asmita                To resolve too many SOQL exception
*    1.3                12/08/2014          Sid (Eternus)         Un Commented code to send Email notification
*                                                                 on Case Creation / Case Closure
*/

trigger CM_CaseTatCalUpdationAndSMSNotification on Case (After Insert, After Update) {
    
    List<Case> pList = new list<Case>(); 
    List<Case> cList = new list<Case>();
    List<Case> caseCloseList = new list<Case>();
    List<Case> queueList = new list<Case>();
    
    set<Id> CaseCloseIds = new set<Id>();
    set<Id> parentCaseIds = new set<Id>();
    set<Id> childCaseIds = new set<Id>();
    set<Id> queueIds = new set<Id>();
    
    CM_Upd_Val_SMS_Notification Sms = new CM_Upd_Val_SMS_Notification();
    CM_TAT_CalculationController caseTAT = new CM_TAT_CalculationController();
    CM_Dynamic_Case_Access caseAccess = new CM_Dynamic_Case_Access();
    CM_FutureMethods future = new CM_FutureMethods();
    
    // 1.2 Asmita
    Id recTypeDummyParentId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CM_Dummy_Parent').getRecordTypeId();        
    Id recTypeParentOnlyId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CM_Parent_Only').getRecordTypeId();
    Id recTypeChildCaseId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CM_Child_Case').getRecordTypeId();        
    Id recTypeActionItemId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CM_Action_Item').getRecordTypeId();
    
    if(trigger.IsInsert && trigger.IsAfter){
        
        for(case cs : Trigger.new){
            
            if(cs.RecordTypeId == recTypeDummyParentId || cs.RecordTypeId == recTypeParentOnlyId){   
                parentCaseIds.add(cs.id);
            }
            
            if(cs.RecordTypeId == recTypeChildCaseId || cs.RecordTypeId == recTypeActionItemId){
                childCaseIds.add(cs.id);
            }

        }
        
        if(parentCaseIds != null){
            pList = [SELECT Id, Communication_Type__c, Queue_Id__c,OwnerId,CreatedById,AccountId,Account.Name,CreatedBy.name,caseNumber,Mobile_Phone__c, OldOwnerId__c, Status, BusinessHoursId, RecordTypeId, Request_for_L1__c,Request_for_L2__c, Request_for_L3_a__c, Request_for_L3__c, Queue_Name__c, CreatedDate, Remaining_Hours__c, CM_TAT__c, ParentId, Nature_of_Request__c, TL__c, TL_EmailId__c, PIC_EmailId__c, IsClosed FROM Case WHERE Id IN: parentCaseIds];
        }
        system.debug('## pList : '+pList.size());
        if(childCaseIds != null){
            cList = [SELECT Id, Communication_Type__c, Queue_Id__c,CreatedById,caseNumber,CreatedBy.name,AccountId,Account.Name,Mobile_Phone__c, OldOwnerId__c, Status, BusinessHoursId, RecordTypeId, Request_for_L1__c,Request_for_L2__c, Request_for_L3_a__c, Request_for_L3__c, Queue_Name__c, CreatedDate, Remaining_Hours__c, CM_TAT__c, ParentId, OwnerId, Nature_of_Request__c, TL__c, TL_EmailId__c, PIC_EmailId__c, IsClosed FROM Case WHERE Id IN: childCaseIds];
        }
        system.debug('## cList : '+cList.size());
        
        if(pList.size() > 0){
            Sms.sendCaseCreationSMSAfterInsert(pList);
            caseTAT.parentTatCal(pList);
            System.debug('Sending internal notification on complaint case creation for parent cases......');
            
            //Siddharth 1.1
            Sms.sendComplaintCaseNotificationEmail(pList);    //Siddharth 1.3
        }
        
        if(cList.size() > 0){
            Sms.sendCaseClosureSMSAfterInsertOrUpdate(cList);
            Sms.orgQueueName(cList); 
            caseTAT.childTatCal(cList);
            caseAccess.childCaseInsert(cList);
            System.debug('Sending internal notification on complaint case creation for child cases........');
            
            //Siddharth 1.1
            Sms.sendComplaintCaseNotificationEmail(cList);    //Siddharth 1.3
}
        
    }
    
    if(trigger.IsUpdate && trigger.IsAfter){
        
        if(CM_FutureMethods.flag == true){
           CM_FutureMethods.flag = false;
            
            for(case cs : Trigger.new){
                if((cs.Status == 'Closed Satisfied' || cs.Status == 'Closed UnSatisfied') && (cs.RecordTypeId == recTypeDummyParentId || cs.RecordTypeId == recTypeParentOnlyId)){   
                    CaseCloseIds.add(cs.id);
                }
                
                if(cs.RecordTypeId == recTypeChildCaseId || cs.RecordTypeId == recTypeActionItemId){
                    childCaseIds.add(cs.id);
                }
                
                for(case c : Trigger.old){
                    if((c.RecordTypeId == recTypeChildCaseId || c.RecordTypeId == recTypeActionItemId)){   
                        queueIds.add(c.id);
                    }
                }
                
                
            }
            
            if(CaseCloseIds != null){
                caseCloseList = [Select Id,Communication_Type__c,Queue_Id__c,OwnerId, ParentId, OldOwnerId__c, Createdby.Name, CaseNumber, Mobile_Phone__c, Account.Name, Status, IsClosed from Case where id IN: CaseCloseIds];
            }
            system.debug('## caseCloseList : '+caseCloseList.size());
            
            if(queueIds != null){
                queueList = [Select Id, ParentId, OldOwnerId__c, OwnerId, Queue_Name__c, Queue_Id__c, Status from Case where id IN: queueIds];    
            }
            system.debug('## queueListUpdate : '+queueList.size());
            
            if(childCaseIds != null){
                cList = [SELECT Id,Queue_Id__c, OldOwnerId__c, Status, BusinessHoursId, RecordTypeId, Request_for_L1__c, Queue_Name__c, CreatedDate, Remaining_Hours__c, CM_TAT__c, ParentId, OwnerId, IsClosed FROM Case WHERE Id IN: childCaseIds];
            }
            system.debug('## cList : '+cList.size());
            
            if(caseCloseList.size() > 0){
                Sms.sendCaseClosureSMSAfterInsertOrUpdate(caseCloseList);
            }
                
            if(queueList.size() > 0 && cList.size() > 0){
                Sms.orgQueueName(cList);
                caseAccess.childCaseUpdate(cList, queueList);
            }
            
        }
        
    }
    
     
}