trigger CalculateACD on Task (before insert, before update) {

if(trigger.Isbefore&&trigger.isinsert){
    
    for(Task newtask: trigger.new){
    
        if(newtask.Status=='Completed'){
        
            newtask.Actual_Completion_Date__c=System.today();
        }
    
    
    }
}


if(trigger.Isbefore&&trigger.isupdate){
    
    for(Task newtask: trigger.new){
    
        if(newtask.Status=='Completed'){
        
            newtask.Actual_Completion_Date__c=System.today();
        }
    
    
    }
}

}