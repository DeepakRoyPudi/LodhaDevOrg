global class Batchupdateaccspokendate implements Database.Batchable<SObject>,Database.Stateful{

    public String querystring;
    global Database.QueryLocator start(Database.BatchableContext BC){
    
          querystring='select id,Last_Call_Date_RO__c from Opportunity where Last_Call_Date_RO__c!=null';
          
          return Database.getQueryLocator(querystring);
       }
       
       global void execute(Database.BatchableContext BC, List<sObject> sobjectlist){
       
           Set<Id> oppId=new Set<Id>();
           for(sObject sobj: sobjectlist){ 
               Opportunity opp=(Opportunity)sobj;
               oppId.add(opp.Id);
           }
        List<AggregateResult> accOppAgg =[select max(Last_Call_Date_RO__c) lastSpokenOn ,AccountId AcctId from Opportunity where id IN: oppId group by AccountId];
         Map<Id,DateTime> accMap =new Map<Id,DateTime>();
         for(AggregateResult accOpp:accOppAgg )
         {
             
             accMap.put((ID)accOpp.get('AcctId'), (DateTime)accOpp.get('lastSpokenOn'));
         }
        
List<Account> acctUpdateList = [select id,Last_call_date__c from Account where id In:accMap.keySet()];
         for(Account a: acctUpdateList) {  
         if(a.Last_call_date__c==null){  
     
                 a.Last_call_date__c = accMap.get(a.Id);
             }else if(a.Last_call_date__c!=null&&(a.Last_call_date__c<accMap.get(a.Id))){

                 a.Last_call_date__c = accMap.get(a.Id);
             }

         }
         update(acctUpdateList);
           
           
       }
       
       global void finish(Database.BatchableContext BC){
        
       }

}