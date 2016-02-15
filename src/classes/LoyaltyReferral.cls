public  class LoyaltyReferral {
    
    public string Name {get; set;}
    public string Status {get; set;}
    public string Mobile {get; set;}
    public string Country {get; set;}
    public string ProjectName {get; set;}
    Opportunity OppDetails;
    public LoyaltyReferral(ReferralDetails__c refDetails){
        
        if(refDetails.Lead__r.Name != NULL)
        {
            this.Name  =  refDetails.Lead__r.Name; //+' ' +refDetails.Lead__r.LastName;      
        }
        else
        {
            this.Name  =  refDetails.Account_Name__c;
        }
        
        if(refDetails.Lead__r.mobile__c != NULL)
        {
            this.Mobile = refDetails.Lead__r.mobile__c;     
        }
        else
        {
            this.Mobile = refDetails.Opportunity_Phone__c;
        }
        this.status = refDetails.status__c; 
        this.Country = refDetails.Lead__r.Country_O__c;

        if(refDetails.Lead__r.Project_Name__r.Name != NULL)            
        {
            this.ProjectName = refDetails.Lead__r.Project_Name__r.Name;
        }
        else
        {
            this.ProjectName = refDetails.Project_Name__c;
        }
    }

    @istest(seeAlldata=false)
    private static void testLoyaltyReferral(){
        ReferralDetails__c lRD = new ReferralDetails__c(Name = 'TestReferral', status__c = 'Lead Created');
        insert lRD;
        LoyaltyReferral lReferal=new LoyaltyReferral(lRD);
    }
}