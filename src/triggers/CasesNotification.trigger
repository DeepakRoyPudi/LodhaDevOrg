/*
      Version    Date           Author    Description
      1.0                                 Initial Draft
      1.1        09/10/2014     Asmita    Modified the code for resolving to many SOQL queries issue
*/
trigger CasesNotification on Case (after insert , after update) {

    List<Case> caseList = new list<Case>(); 
    set<Id> CaseIds = new set<Id>();
    
    Sendmailforcases Sm = new Sendmailforcases();
    
    if(trigger.Isinsert && trigger.Isafter){
        for (case cs :Trigger.new){
            CaseIds.add(cs.id);
        }
    
        caseList = [Select Id, AccountId, Account.Name, Mobile_Phone__c, CreatedById, Manager__c, ADF__c, Subject from Case where id IN: CaseIds];
        Sm.sendmailafterinsert(caseList);
        
        sm.adfNotification(Trigger.new,null);
        
    }
    
    if(trigger.Isupdate && trigger.Isafter){
        for (case cs :Trigger.new){
            CaseIds.add(cs.id);
        }
        
        caseList = [Select Id, AccountId, Account.Name, Mobile_Phone__c, CreatedById, Manager__c, ADF__c from Case where id IN: CaseIds];
        Sm.sendmailafterupdate(caseList);
        
        sm.adfNotification(Trigger.new,Trigger.oldMap);
        
    }
}