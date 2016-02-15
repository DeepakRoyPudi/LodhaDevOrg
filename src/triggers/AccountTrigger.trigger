/*
*    Description : Trigger for Account object
*
*       Date        Version      Name     Description
*    17/07/2014       1.0       Asmita    Initial Draft
*/

trigger AccountTrigger on Account (before Insert, before Update, after Update) {
     
    // Before Insert Event
    if(trigger.isBefore && trigger.isInsert){
        
        AccountTriggerHandler oAccountTriggerHandler = new AccountTriggerHandler();
        oAccountTriggerHandler.onBeforeInsert(trigger.new); 
    }
    
    // Before Update Event
    if(trigger.isBefore && trigger.isUpdate){
        
        AccountTriggerHandler oAccountTriggerHandler = new AccountTriggerHandler();
        oAccountTriggerHandler.onBeforeUpdate(trigger.oldMap, trigger.newMap);
    }
    
    // After Insert Event
    if(trigger.isAfter && trigger.isUpdate){
    
        //Update Email id on user object if personal email is change on Account object    
        AccountTriggerHandler oAccountTriggerHandler = new AccountTriggerHandler();
        oAccountTriggerHandler.onAfterUpdate(trigger.oldMap,trigger.newMap); 
    }
}