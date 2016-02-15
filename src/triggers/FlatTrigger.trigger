/*
*    Description: Trigger on Flat object
*    
*    Version       Date        Author          Description
*     1.0        18/6/2014   Lodha Group IT    Initial Draft
*     1.1        16/10/2014  Asmita (Eternus)  to perform webservice callout on after insert and after update event
*/

trigger FlatTrigger on Flat__c (after insert, after update) {
    
    // 1.1 Asmita 
    if(Trigger.isAfter && Trigger.isInsert){
    	// Calling the handler of flat trigger
        FlatTriggerHandler oFlatTriggerHandler = new FlatTriggerHandler();
        oFlatTriggerHandler.onAfterInsert(Trigger.oldMap, Trigger.newMap);
    }
    if(Trigger.isAfter && Trigger.isUpdate){
        
        //Invoke Handler Class Method
        FlatTriggerHandler oFlatTriggerHandler = new FlatTriggerHandler();
        oFlatTriggerHandler.onAfterUpdate(Trigger.oldMap, Trigger.newMap);
    }

}