// This Trigger is used to display the Last Call Attempt fields on Opportunity Layout.
trigger UpdateOpportunityLastCallAttempt_AfterInsert on Call_Attempts__c (After Insert) 
{
    List<Opportunity> oppList=new List<Opportunity>();
    List<ID> oppID=new List<ID>();
    ID CallID;
    for(Call_Attempts__c ca:Trigger.new)
    {
    /* Store the Call Attempt ID in a Variable 'CallID'
       Check the Call Attempt record to see if it contains the Opportunity lookup.
       If Opportunity lookup exists; store the Opportunity lookup id into a List
    */
        CallID=ca.ID;
        if(ca.Opportunity__c!=null)
            oppID.add(ca.Opportunity__c);
    }

    /* if the OppID List is not blank, query the Opportunity object for the Ids
       and set the Opportunity 'Last Call Attempt Data' field to Call Attempt ID
    */
    
    if(!oppID.IsEmpty())
    {    
        oppList=[Select Last_Call_Attempt_Data__c from opportunity where ID IN : oppID];
        oppList[0].Last_Call_Attempt_Data__c =CallID;
        
        update oppList;
    }
}