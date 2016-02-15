trigger ReferralPullAccountInformation on Referrals__c (before Insert,before Update) {
AccountInformation.pullmethod(Trigger.new);
}