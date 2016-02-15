/*
  Version    Date         Auther             Description
  1.1      08/20/2014    Asmita(Eternus)    Modified the code as the Too Many SOQL exception was occuring while deploying the Lead related components
*/

@Istest
private class CallAttemptToOppOnConversion {

    static testMethod void CallAttemptToOppOnConversion () {

    Project_Name__c pr=new Project_Name__c(name='Aqua');
    insert   pr;
    Project_Name__c pr1=new Project_Name__c(name='Aqua1');
    insert   pr1;
    Lead lead=new Lead(project_name__c=pr.Id,Company='Wipro',Project_Interested__c='Loreal',Mobile__c='2345678912',LastName='Technologies',LeadSource='Web');
    insert lead;
///
    //lead=[Select FirstName from lead where Id=:lead.Id];
    //lead.FirstName='Hello';
    //Update lead;

//    
    
    
    Account acc=new account(name='test');
    insert acc;
//    lead=[select Status,id from lead where id=:lead.ID];
 //   lead.Status='Booking Done';
//    lead.ConvertedAccountId=acc.id; 
   // update lead;
    Call_Attempts__c Ca=new Call_Attempts__c (Project_Name__c=pr1.ID,Lead__c=lead.id,project_interested__c='Loreal',Mobile__c=lead.Mobile__c,Attempted_By__c='CEO',Call_Attempted_by__c='test',Call_Attempt_Status__c='Open',Call_Type__c='email');
    insert Ca;
    test.startTest();
    Database.LeadConvert lc = new database.LeadConvert();
    lc.setLeadId(lead.id);
    lc.setConvertedStatus('Converted');
    //Updated by Compro - As this was throwing exception while deployment because lead owner was queue
    lc.setOwnerId('00520000000qYii');
    Database.LeadConvertResult lcr = Database.convertLead(lc);
    test.stopTest();
    Ca=[select Project_Name__c,Opportunity__c,id,Project_Name__r.Name from Call_Attempts__c where Lead__c=:lead.Id];
    Opportunity opp;
    if(Ca.Project_name__c!=lead.Project_name__c)
    {
    opp=new Opportunity(Name=lead.lastName+' '+lead.firstname+'-'+pr.name,closeDate=System.today()+90,StageName='Qualification',AccountId=lead.ConvertedAccountId,Project_Name__c=pr.id);
    insert opp;
    
/*    opp=[select id from opportunity where project_name__c=:pr.id and ];
    Ca.Opportunity__c=opp.Id;
    update Ca;*/
    }
   /* ca=[select Project_name__C from Call_Attempts__c  where id=:ca.id];
    ca.Project_name__c=pr.id;
    update ca;*/
    integer flag;
    if(opp.project_name__c==Ca.project_name__c)
    {
        flag=1;
    }
    
    
}


}