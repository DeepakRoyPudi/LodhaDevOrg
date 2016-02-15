/*
*        Description : Case Trigger
*
*        Version     Date          Author           Description
*          1.0     19/06/2014   Asmita(Eternus)     Intial Draft
*          2.0     18/11/2014   Anupam Agrawal      Case Mangement validation on "Date Confirm Registration"
*/

trigger CaseTrigger on Case (before insert, before update) {
	
	//2.0
	if(trigger.isBefore && trigger.isInsert){
		CaseTriggerHandler objCaseTriggerHandler = new CaseTriggerHandler();
		objCaseTriggerHandler.onBeforeInsert(trigger.new);
	}
	
    if(Trigger.isBefore && Trigger.isUpdate){
        
        // Before Update Trigger
        CaseTriggerHandler oCaseTriggerHandler = new CaseTriggerHandler();
        oCaseTriggerHandler.onBeforeUpdate(Trigger.oldMap, Trigger.newMap);
    }
}