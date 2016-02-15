global class CallRatingUpdaterBatch implements Database.batchable<sObject>{
	
	global String queryOpp = 'select o.Id, o.Call_Rating__c, o.Last_Call_Date_New__c, o.Follow_Up_Date_New__c, o.Call_Proposed_Date_of_Visit_New__c, o.Last_Call_Description_New__c, o.Last_Call_Attempted_by_New__c, o.Last_Attempted_By_New__c, o.Last_Call_Attempt_Status_New__c, (Select Id, Name, Call_Attempt_Status__c, Attempted_By__c, Call_Attempted_by__c, Call_Date__c, Description__c, Proposed_Date_of_Visit__c , Next_Action_Date__c From R00NR0000000VhoWMAS__r order by CreatedDate desc) From Opportunity o';
	
	global Database.QueryLocator start(Database.BatchableContext info)
	{
    	return Database.getQueryLocator(queryOpp);
    }
    
	global void execute(Database.BatchableContext info, List<sObject> scope)
	{
    	map <string, string> mapStatusMapping = new map<string, string>();
		mapStatusMapping.put('Booking Done', 'Visit Done');
		mapStatusMapping.put('Follow up', 'Follow Up');
		mapStatusMapping.put('Lost', 'Lost');
		mapStatusMapping.put('Lost - Internal', 'Lost');
		mapStatusMapping.put('Meeting Done', 'Visit Done');
		mapStatusMapping.put('Meeting Fixed', 'Visit Confirmed');
		mapStatusMapping.put('No Show', 'No Show');
		mapStatusMapping.put('Open', 'Open');
		mapStatusMapping.put('Visit Confirmed', 'Visit Confirmed');
		mapStatusMapping.put('Visit Done', 'Visit Done');
		mapStatusMapping.put('Visit Proposed', 'Visit Proposed');
		
		map <string, Call_Rating__c> mapCallRating = Call_Rating__c.getAll();
    	
    	List<Opportunity> lstOpp = new List<Opportunity>();
     
		for(sObject s : scope)
		{
			Opportunity o = (Opportunity)s; 
				
			if (o.R00NR0000000VhoWMAS__r != null)
			{
				if (o.R00NR0000000VhoWMAS__r.size()>0)
				{
					if (mapStatusMapping.containsKey(o.R00NR0000000VhoWMAS__r[0].Call_Attempt_Status__c))
					{
						o.Call_Rating__c = mapCallRating.get(mapStatusMapping.get(o.R00NR0000000VhoWMAS__r[0].Call_Attempt_Status__c)).Default__c;
						o.Last_Call_Date_New__c = o.R00NR0000000VhoWMAS__r[0].Call_Date__c;
						o.Follow_Up_Date_New__c = o.R00NR0000000VhoWMAS__r[0].Next_Action_Date__c;
						o.Call_Proposed_Date_of_Visit_New__c = o.R00NR0000000VhoWMAS__r[0].Proposed_Date_of_Visit__c;
						o.Last_Call_Description_New__c = o.R00NR0000000VhoWMAS__r[0].Description__c;
						o.Last_Call_Attempted_by_New__c = o.R00NR0000000VhoWMAS__r[0].Call_Attempted_by__c;
						o.Last_Attempted_By_New__c = o.R00NR0000000VhoWMAS__r[0].Attempted_By__c;
						o.Last_Call_Attempt_Status_New__c = o.R00NR0000000VhoWMAS__r[0].Call_Attempt_Status__c;						
					}				
				}
				lstOpp.add(o);
			}            
		}
	    try
	    {
	       	database.update(lstOpp, false);
	    }
	    catch(Exception e)
	    {
	        system.debug('Opportunities failed to update'+ e.getMessage());
	    }
	}

	global void finish(Database.BatchableContext BC)
	{
		system.debug('Completed');
	}
	

}