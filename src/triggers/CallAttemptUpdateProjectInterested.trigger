trigger CallAttemptUpdateProjectInterested on Call_Attempts__c(before insert) {
CallAttemptUpdateProjectInterested.Updatemethod(Trigger.new);
}