trigger LeadProcess on Lead (before insert, before update, after insert, after update){
    Public Boolean flag;
    public Map<Id,Lead> IdObjectLst;
    public List<Lead> FinalLst;

    if (trigger.isBefore && trigger.isInsert)
    {
        Web2LeadMobileValidation.CheckLeadLandline(trigger.new);
        Web2LeadForSulekha.CheckSulekha(trigger.new);
        FlagDuplicateLead.findDuplicates(trigger.new);
        LeadTriggersClass.UpdateProjectDetails(trigger.new);        
    }

    if (trigger.isBefore && trigger.isUpdate)
    {
        Web2LeadMobileValidation.CheckLeadLandline(trigger.new);
        //FlagDuplicateLead.findDuplicates(trigger.new);
        LeadTriggersClass.RestrictChangeOwnership(trigger.new);
    }

    /*if (trigger.isAfter && trigger.isInsert)
    {
    LeadTriggersClass.InsertUpdateReferral(trigger.new, trigger.newMap);
    }*/

    if (trigger.isAfter && trigger.isUpdate)
    {
        //LeadTriggersClass.InsertUpdateReferral(trigger.new, trigger.newMap);
        if(!(trigger.new.size() > 1))
        {
        LeadTriggersClass.CallAttemptToOppOnConversion(trigger.new);

        }
    }

    if (trigger.isBefore && trigger.isUpdate)
    {
        IdObjectLst=new Map<Id,Lead>(); 
        FinalLst=new List<Lead>();      
        
        for(Lead a:trigger.old){
            IdObjectLst.put(a.id,a);
            if(a.LeadSource =='Internal Referral')   {
                flag=true;
            }
        }
        integer i=0;
        for(Lead a:trigger.new){
            if(IdObjectLst.containsKey(a.id)){
                if(IdObjectLst.get(a.id).LeadSource=='Internal Referral' && a.LeadSource!='Internal Referral'){
                    trigger.new[i].addError('Changing the LeadSource Picklist Value from "Internal Referral" is Not Allowed');
                }
                else{
                    FinalLst.add(a);
                }
            }   
            i++;
        } 
        referralLead.insertReferralObject(FinalLst);

    }

    if ((trigger.isAfter && trigger.isInsert) ){
        referralLead.insertReferralObject(trigger.new);

    }

}