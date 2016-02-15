trigger LeadTrigger on Lead (before insert, before update) {
	
	Map<Id, Lead> mapNewLead = new Map<Id, Lead>();
     
    // Before Insert Event
    if(trigger.isBefore && trigger.isInsert){
        
        LeadTriggerHandler oLeadTriggerHandler = new LeadTriggerHandler();
        oLeadTriggerHandler.onBeforeInsert(trigger.new);
    }
    
    // Before Update Event
    if(trigger.isBefore && trigger.isUpdate){
        
        LeadTriggerHandler oLeadTriggerHandler = new LeadTriggerHandler();
        oLeadTriggerHandler.onBeforeUpdate(trigger.oldMap, trigger.newMap);
    }

}