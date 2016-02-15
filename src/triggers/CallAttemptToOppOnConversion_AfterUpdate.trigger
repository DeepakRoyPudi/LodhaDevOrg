trigger CallAttemptToOppOnConversion_AfterUpdate on Lead(After Update)
{


    public ID LeadID,ProjectID,opportunityID,AccountID;
    Call_Attempts__c Cmp;
    List<Call_Attempts__c> ListConvertToOpp=null;
    List<Opportunity> oppList;
    opportunity opp;
/* Lodha's requirement on 20 May 2011 as follows:
Requirement is to extend this functionality so that when a Lead with multiple call attempts 
for different projects is converted, the Last Call Attempt Data section on the new project 
specific Opportunities created, based on the Call Attempts on Leads, 
should reflect the Last call attempt status.

Compro: Created the following Opportunity object and then set the Call Attempt ID with it.
*/    
    ////Compro 25 May 2011
    opportunity oppUpdate;
    ////Compro 25 May 2011

    ID Record_type=null;
    Date ClsDate;
    String fullName;
    opportunity opp_data=null;
    
    for(Lead lead:Trigger.new)
    {
       if (lead.IsConverted) 
        {
      
        LeadID=lead.Id;
        ProjectID=lead.Project_name__c;
        AccountID=lead.ConvertedAccountId;
        opportunityID=lead.ConvertedOpportunityId;
        if (lead.FirstName!= null)
            fullName=lead.FirstName + ' '+ lead.LastName ; 
        else
            fullName=lead.LastName ; 
      
        }
    
    }

    if(opportunityID!=null && LeadID!=null)
    {
         opp_data=[select RecordTypeId,CloseDate from opportunity where id=:opportunityID];
        
            ClsDate=opp_data.CloseDate; 
            Record_type=opp_data.RecordTypeId;
            ListConvertToOpp=new List<Call_Attempts__C>();
            oppList=new List<opportunity>();

    /*Compro 25 May 2011
     1. Creating a variable to ensure that the Opportunity which gets created from the Lead Converstion,  
     Call Attempt is also set for that Opportunity.
     
     2. Changing the Query below to add the 'CreatedDate' and 'Order by Created Date Descending' to ensure that only the last Call attempt
        for a Projects on a Lead will be mapped to the Opportunity
    */
    
    Integer flag2=0;
//   for(Call_Attempts__c CA:[Select Project_Name__c,Opportunity__c,id,Project_Name__r.Name from Call_Attempts__c where Lead__c=:LeadID and Opportunity__c=null ])
   for(Call_Attempts__c CA:[Select Name, Project_Name__c,Opportunity__c,id,Project_Name__r.Name, CreatedDate from Call_Attempts__c where Lead__c=:LeadID and Opportunity__c=null order by CreatedDate Desc])
   
////above update by Compro on 25 May 2011   
    {
        Integer flag=0;
        if(CA.project_name__c!=ProjectID)
        {
        for(Integer i=0;i<oppList.Size();i++)
        {
            if(oppList[i].Project_Name__c==CA.project_name__c)
            {
                 flag=1;
            }
        }
        if (flag!=1)
        {
        opp=new Opportunity();
        opp.Name = fullName+'-'+CA.Project_Name__r.Name;
        opp.CloseDate = ClsDate;
        opp.RecordTypeId=Record_type;
        opp.StageName='Qualification';
        opp.Project_Name__c=CA.Project_Name__c;
    //Compro 25 May 2011
    //Setting the Last Call Attempt Data record to the Opportunity
        opp.Last_Call_Attempt_Data__c=CA.Id;
    //Compro 25 May 2011
        
        opp.AccountId=accountId;
        oppList.add(opp);
        }
                ListConvertToOpp.add(CA);

        }
        else if(CA.project_name__c==ProjectID)
        {
            CA.Opportunity__c=opportunityID;
            ListConvertToOpp.add(CA);
    ////Compro 25 May 2011
    
    //Adding the following code to set the Last Call Attempt on Opportunity that is created from Lead Conversion
            System.debug('Call Attempt Name:'+CA.Name);    
            if (flag2==0)
            {
              oppUpdate= new Opportunity(Id=opportunityID);
              oppUpdate.Last_Call_Attempt_Data__c=CA.Id;
              flag2=1;
            }
    ////Compro 25 May 2011
        }
    }
  update ListConvertToOpp;
    if(oppList.size()>0)
        insert oppList; 

    ////Compro 25 May 2011
    //Updating the Opportunity object if it is not null
      if (oppUpdate<>null)
         update oppUpdate;
    ////Compro 25 May 2011
        
        
   if(oppList.size()>0) 
   {

for(Integer i=0;i<oppList.size();i++)
{
   
    for(Integer j=0;j<ListConvertToOpp.size();j++)
    {

            if(oppList[i].Project_Name__c==ListConvertToOpp[j].Project_Name__c)
            {
                ListConvertToOpp[j].Opportunity__c=oppList[i].ID;
            }
               
    }

}
    update ListConvertToOpp;
}
    }
}