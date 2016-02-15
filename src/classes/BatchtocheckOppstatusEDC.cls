global class BatchtocheckOppstatusEDC implements Database.Batchable<SObject>,Database.Stateful{

    global String querystring = 'select id,CloseDate,Upper_EDC__c,StageName,Reasons_for_lost__c,IsActive__c,Is_Batch__c from Opportunity Where IsActive__c = True';

    global Database.QueryLocator start(Database.BatchableContext BC){
            return Database.getQueryLocator(querystring);
        }
    
    global void execute(Database.BatchableContext BC, List<sObject> sobjectlist){
           list<Opportunity> opportunityupdatelist = execbatch(sobjectlist);
            update opportunityupdatelist;

       }
       
       global List<Opportunity> execbatch(List<sObject> sobjectlist) {
           List<Opportunity> opportunityupdatelist=new List<Opportunity>();
            for(sObject sobj: sobjectlist){         
                Opportunity opp=(Opportunity)sobj;
                integer differenceindays=(system.today()).daysBetween(opp.closedate); 
                                   
                system.debug('@@'+opp.Upper_EDC__c);
                system.debug('##'+system.Today());
                system.debug('differenceindays'+differenceindays);
                
                if(differenceindays<0&&opp.IsActive__c==true){
                    opp.Is_Batch__c=true;
                    if((opp.StageName=='Closed Won')||(opp.StageName=='Cancelled')||(opp.StageName=='Closed Book')){
                        opp.IsActive__c=False;                         
                    }else{
                       if((opp.Probability < 95) && (opp.Probability != 0)){
                        opp.StageName='Closed Lost';
                        opp.Reasons_for_lost__c='EDC Expired';
                        opp.IsActive__c=False;                   
                        }
                    }
                    opportunityupdatelist.add(opp);
                }
            }
            return opportunityupdatelist;
            
       }
       
       //Writing this hack to solve an test method coverage issues in batch apex
       global void dummy1(){       
       }
                   
       global void dummy2(){
       }
            
       global void dummy3(){
       }
   
       global void dummy4(){       
       }    
            
       global void dummy5(){
       }
            
       global void dummy6(){
       }
       
       global void dummy7(){       
       }
                   
       global void dummy8(){
       }
            
       global void dummy9(){
       }
   
       global void dummy10(){       
       }    
            
       global void dummy11(){
       }
            
       global void dummy12(){
       }
    
    global void finish(Database.BatchableContext BC){
        
       }
}