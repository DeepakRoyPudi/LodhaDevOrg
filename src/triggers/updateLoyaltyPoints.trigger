trigger updateLoyaltyPoints on Loyalty_Points_History__c (after update, after insert,after delete) {

 
    if ((trigger.isAfter && trigger.isUpdate) ||Trigger.isInsert)
    {
        LodhaReferralDetailsUtilities.updateReferralPointsDetails(trigger.new);
    }
    else if(Trigger.isDelete)
    {
     LodhaReferralDetailsUtilities.updateReferralPointsDetails(Trigger.old);
    }
   
    
}