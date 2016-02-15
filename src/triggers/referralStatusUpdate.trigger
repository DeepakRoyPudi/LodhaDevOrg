trigger referralStatusUpdate on Opportunity (before insert,before update) {
/*
if ((trigger.isAfter && trigger.isUpdate) || Trigger.isInsert)
    {
      //  LodhaReferralDetailsUtilities.updateOpportunityReferralDetails(trigger.new);
    }
    */
    
    if(!StaticVariableUtility.referralStatusUpdateBeforeInsertUpdateRunOnce()){
    
    if((trigger.Isbefore&& trigger.Isinsert)|| (trigger.isupdate && trigger.Isbefore  )){
        BookingDetailsTrgController flatCodeObj= new BookingDetailsTrgController();
        list<Opportunity> lstOpps = flatCodeObj.createSrcRefFlatCode(trigger.new);
        if(trigger.new.size()>0){
            updateInferenceOverOpportunity.UpdateInferences(trigger.new);
        }
        
        //Newly Added for SRCG-172
        
        Set<String> uname = new Set<String>();
        
        for(Opportunity Opp : trigger.new){
            if(Opp.Name_of_CC_Associated__c!= null){
                uname.add(Opp.Name_of_CC_Associated__c);
            }
        }
        
        List<User> ulist = [Select id, email from User Where Name =: uname];
        
        if(ulist.size()>0){
            for(User u : ulist){            
                for(Opportunity Opp : trigger.new){
                    Opp.CC_email__c = u.email;
                }
            }
        }
    }
    }//Static Variable If
}