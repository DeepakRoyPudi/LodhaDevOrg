/*
*    Description : Trigger for Opportunity Object
*
*       Date        Version      Name     Description
*    18/07/2014       1.0       Asmita    Initial Draft
*/


trigger OpportunityTrigger on Opportunity (after insert, after update, after delete) {
    
    // AfterInsert
    if(trigger.isAfter && trigger.isInsert){
        
        OpportunityTriggerHandler oOppTriggerHandler = new OpportunityTriggerHandler();
        oOppTriggerHandler.isAfterInsert(trigger.oldMap, trigger.newMap);
    }
    
    // AfterUpdate
    if(trigger.isAfter && trigger.isUpdate){
        
        OpportunityTriggerHandler oOppTriggerHandler = new OpportunityTriggerHandler();
        oOppTriggerHandler.isAfterUpdate(trigger.oldMap, trigger.newMap);  
    }
    
    // AfterDelete
    if(trigger.isAfter && trigger.isDelete){
        
        OpportunityTriggerHandler oOppTriggerHandler = new OpportunityTriggerHandler();
        oOppTriggerHandler.isAfterDelete(trigger.oldMap, trigger.newMap);  
    }

}