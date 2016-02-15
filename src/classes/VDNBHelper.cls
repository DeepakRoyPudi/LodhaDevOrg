/*
* Description : VDNB Trigger Helper
*
* Version     Date          Author             Description
* 1.0         09/12/2014    Anupam Agrawal     Intial Draft
*/

public class VDNBHelper 
{
	//Populate Mobile no and Project Name field of VDNB as per opportunity values.
	public void populateOtherValue(List<VDNB__c> lstNewVDNB)
	{  
        Set<Id> setOpportunityId = new Set<Id>();
        
        //Collect Opportunity Id.
        for(VDNB__c objVDNB : lstNewVDNB)
        {
        	if(objVDNB.Opportunity__c != null) 
        		setOpportunityId.add(objVDNB.Opportunity__c);
        }
        
        
        Map<Id, Opportunity> mapIdToOpportunity = new Map<Id, Opportunity>([Select Id, Mobile_no__c, Project_Name__c
        																		from Opportunity 
        																		where Id IN: setOpportunityId]);
        if(!setOpportunityId.isEmpty())
        {
        	for(VDNB__c objVDNB : lstNewVDNB)
        	{
        		if(objVDNB.Opportunity__c != null)
        		{
        			//Enter values
        			Opportunity objOpp = mapIdToOpportunity.get(objVDNB.Opportunity__c);
        			if(objOpp != null)
        			{
	        			objVDNB.Mobile__c = objOpp.Mobile_no__c ;
	        			objVDNB.Project_name__c = objOpp.Project_Name__c;
        			}
        		}
        	}
        }
	}
	
	//Update Opportunity With VDNB values
	public void updateOpportunityWithLastVDNB(List<VDNB__c> lstNewVDNB)
	{
		List<Opportunity> lstUpdateOpportunity = new List<Opportunity>();
	    Set<Id> setOpportuntiyId = new Set<Id>();
	    Set<Id> setCampaignId = new Set<Id>();
	    
	    for(VDNB__c objVDNB : [Select Id, Opportunity__c, Attempted_By__c, Call_Attempted_by__c, 
	    							Description__c, Call_Date__c, Rating__c 
	    						from VDNB__c where Id IN: lstNewVDNB  order by CreatedDate desc])
	    {
	        if(objVDNB.Opportunity__c != null)
	        {
	        	//Populate 6 opporutniy fields based on Recently entered VDNB record
	            if(!setOpportuntiyId.contains(objVDNB.Opportunity__c))
	            {
	            	Opportunity objOpp = new Opportunity(Id = objVDNB.Opportunity__c);
	            	
	            	objOpp.VDNB__c = objVDNB.Id;
	            	objOpp.VDNB_Attempted_By__c = objVDNB.Attempted_By__c;
	            	objOpp.VDNB_Call_Attempted_by__c = objVDNB.Call_Attempted_by__c;
	            	objOpp.VDNB_Call_Date__c = objVDNB.Call_Date__c;
	            	objOpp.VDNB_Description__c = objVDNB.Description__c;
	            	objOpp.VDNB_Rating__c = objVDNB.Rating__c;
	            	
	            	lstUpdateOpportunity.add(objOpp);
	            	setOpportuntiyId.add(objVDNB.Opportunity__c);
	            }
	        }
	    }
	    
	    //Update Opportunities
	    if(!lstUpdateOpportunity.IsEmpty())
	    {
	    	try
	    	{
	        	update lstUpdateOpportunity;
	    	}
	    	catch(Exception e)
	    	{
	    		System.debug('--------------e---'+e);
	    	}
	        
	    }
	}
}