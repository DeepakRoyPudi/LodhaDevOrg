public class LoyaltyDetails {
    
    public string loyaltyId {get; set;}
    public string bookedAccId {get; set;}
    public string referredId {get; set;}    
    public double preferatiPoints {get; set;}
    public string casaLadder {get; set;}
    
    public LoyaltyDetails(Loyalty_Detail__c aLoyalty){
        
        this.LoyaltyId = aLoyalty.Loyalty_Id__c;
        this.casaLadder = aLoyalty.Current_casa_ladder__c;
        this.preferatiPoints = aLoyalty.Total_preferati_points__c;
    }

    @istest(seeAlldata=false)
    private static void testLoyaltyDetails(){
        Loyalty_Detail__c lLD = new Loyalty_Detail__c(Name = 'TestLoyaltyDetails', Loyalty_Id__c = '01pL00000008cld', Current_casa_ladder__c = 'testLadder', Total_preferati_points__c = decimal.valueof('1000'));
        insert lLD;
        LoyaltyDetails loyaltyDetails=new LoyaltyDetails(lLD);
    }
}