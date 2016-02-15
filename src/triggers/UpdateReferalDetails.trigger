trigger UpdateReferalDetails on Referral_Payment__c (After Insert , After Update) 
{
UpdateReferalPayments.PaymentDetails(Trigger.New);
}