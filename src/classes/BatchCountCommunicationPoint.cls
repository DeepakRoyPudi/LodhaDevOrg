/*
*    Description : Batch apex to count last 6 month Call attempt to associated with opportunities belong to  
*                  same Account and Populating call attempt count on Account Detail page. 
*
*    Version            Date            Author            Description
*
*    1.0                12/08/2014      Anupam Agrawal     Initial Draft
*/

global class BatchCountCommunicationPoint implements Database.Batchable<sObject>
{
	global String strQuery;
	
    //Overridden method of Batchable interface
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        strQuery = 'Select Id from Account where RecordType.Name = \'Person Account\' ';
        return Database.getQueryLocator(strQuery);
    }
	
    //Override execute method to count call attempt
    global void execute(Database.BatchableContext BC, List<sObject> scope){

        Map<Id, Integer> mapAccountIdToCount = new Map<Id, Integer>();
        List<Account> lstAccount = (List<Account>)scope;

        //Fetch all Opportunity records with call attempt associated with same Account
        List<Opportunity> lstOpp = [Select Id, 
                                           AccountId, 
                                           (Select Id 
		                                    From R00NR0000000VhoWMAS__r 
                                            where CreatedDate = LAST_N_DAYS:180)  
                                    from opportunity  
                                    where Account.isPersonAccount = true and 
                                          AccountId IN : lstAccount and 
                                          isActive__c = true] ;
										
        //Map between account and call attempt count.
        for(Opportunity objOpp : lstOpp){
			
            if(!mapAccountIdToCount.containsKey(objOpp.AccountId))
                mapAccountIdToCount.put(objOpp.AccountId, objOpp.R00NR0000000VhoWMAS__r.size());
			else{

            Integer previousCount = mapAccountIdToCount.get(objOpp.AccountId);
            mapAccountIdToCount.put(objOpp.AccountId, previousCount + objOpp.R00NR0000000VhoWMAS__r.size());
            }
        }
		
        List<Account> lstUpdateAccount = new List<Account>();
		
		// Account with call attempt count value.
        for(Id accId : mapAccountIdToCount.keySet()){

            Account objAccount = new Account(Id = accId, communication_points_in_a_last_6_month__c = mapAccountIdToCount.get(accId));
            lstUpdateAccount.add(objAccount);
        }			
		
        //Update Account
        if(!lstUpdateAccount.isEmpty()) 
            Database.Saveresult[] srList = Database.update(lstUpdateAccount);
    }
    
    //Finish Method of batchable interface
    global void finish(Database.BatchableContext BC){
        //Not doing any things.
    }
}