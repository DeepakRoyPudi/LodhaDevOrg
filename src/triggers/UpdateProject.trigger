trigger UpdateProject on Payout_percentage__c (before insert,before update) {
PayoutPercentageProjectInterested.Updatemethod(Trigger.new);
}