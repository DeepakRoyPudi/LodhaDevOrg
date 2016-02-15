public class PayoutPercentageProjectInterested{
 public static void Updatemethod(Payout_percentage__c[] PP){      
        for( Payout_Percentage__c Pay:PP) {
              Opportunity[] Opp = [Select Project_Interested__c from Opportunity where id =:Pay.Opportunity__c limit 1];
               if(Opp.size() > 0){
               Pay.Project__c = Opp[0].Project_Interested__c;
                }
                }
                }
static testMethod void PayoutPercentageProjectInterested()
{
Channel_Partner__c[] CP=new Channel_Partner__c[]
{
new Channel_Partner__c(Name='Aparnafirms',Type_of_Channel_Partner__c='Domestic',Email__c='xy@hotmail.com')
};
Insert CP;
Payout_percentage__c[] pp=new Payout_percentage__c[]
{
new Payout_percentage__c(Channel_Partner__c=CP[0].id,Payout_Percentage__c=2)
};
Insert pp;
PayoutPercentageProjectInterested.Updatemethod(pp);
}
}