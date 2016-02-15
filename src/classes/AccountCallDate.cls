public class AccountCallDate{

    public void Updatelastcalldate(List<Call_Attempts__c> callattemptlist){
    
        Set<Id> oppId=new Set<Id>();
        Set<Id> accId=new Set<Id>();
        if(!callattemptlist.IsEmpty()){
            for(Call_Attempts__c callattempt:callattemptlist){ 
            if(callattempt.Opportunity__c!=null){              
                oppId.add(callattempt.Opportunity__c);
               }
            }  
          

         List<AggregateResult> accOppAgg =[select max(Last_Call_Date_RO__c) lastSpokenOn ,AccountId AcctId from Opportunity where id IN: oppId group by AccountId];
         Map<Id,DateTime> accMap =new Map<Id,DateTime>();
         for(AggregateResult accOpp:accOppAgg )
         {
             
             accMap.put((ID)accOpp.get('AcctId'), (DateTime)accOpp.get('lastSpokenOn'));
         }
        
         List<Account> acctUpdateList = [select id,Last_call_date__c from Account where id In:accMap.keySet()];
         for(Account a: acctUpdateList) {
          system.debug('GETACCOUNT');    
         if(a.Last_call_date__c==null){  
             system.debug('Inside Null');       
                 a.Last_call_date__c = accMap.get(a.Id);
             }else if(a.Last_call_date__c!=null&&(a.Last_call_date__c<accMap.get(a.Id))){
                     system.debug('Inside MAX');
                 a.Last_call_date__c = accMap.get(a.Id);
             }

         }
         update(acctUpdateList);
       }     
    }
    static testmethod void testAccountCallDate(){
         /*EDC_for_opportunity__c edcopp=new EDC_for_opportunity__c();
         edcopp.Name='Test';
         edcopp.Project_Type__c='Casa';
         edcopp.EDC_from_Created_date__c='25';
         edcopp.EDC_from_Visit_date__c='30';
         edcopp.Upper_Limit__c='90';
         edcopp.Call_Attempt_Limit__c='7';
         edcopp.Call_Attempt_EDC__c='8';
         insert edcopp;*/
     
         Account a=new Account();
         a.FirstName='Test';
         a.LastName='One';
         insert a;
    
         Project_Name__c project=new Project_Name__c();
         project.Name='Test';
         project.Project_Type__c='Casa';
         insert project;
         
         List<Opportunity> opplist=new List<Opportunity>();
         Opportunity opp=new Opportunity();
         opp.Name='Test';
         opp.AccountId=a.Id;
         opp.closedate=date.newinstance(2012, 7, 2);
         opp.Project_Name__c=project.Id;
         opp.StageName='Qualified';  
         //opp.IsActive__c=true; 
         opplist.add(opp);                
         insert opplist;
          
        List<Call_Attempts__c> callattemptlist=new List<Call_Attempts__c>();             
        Call_Attempts__c callattempt=new Call_Attempts__c();
        callattempt.Project_name__c=project.Id;
        callattempt.Opportunity__c=opp.Id;
        callattempt.Call_Type__c='Email';
        callattempt.Call_Attempt_Status__c='Fallow up';
        callattempt.Attempted_By__c='Presales';
        callattempt.Call_Attempted_by__c='Group A';
        callattempt.Next_Action_Date__c=System.Today();
        callattempt.Proposed_Date_of_Visit__c=System.Now();
        callattemptlist.add(callattempt);
        insert callattemptlist;
    
    }  
}