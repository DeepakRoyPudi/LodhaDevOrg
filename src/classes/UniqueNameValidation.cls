Public class UniqueNameValidation{
    
    public void nameValidation(List<Campaign> mapNew){
    
        List<Campaign> CampaignList = new list<Campaign>();
        try{
            if(mapNew != null){
                
                String cname;
                Id cid;
                
                for(Campaign cm : mapNew){
                    cname = cm.Name;
                    cid = cm.id;
                }
                
                CampaignList = [Select Id, Name from Campaign where id !=: cid and Name =: cname];
                
                for(Campaign cm : mapNew){
                    for(Campaign cl : CampaignList){
                    
                        if(cname == cl.Name){
                            cm.addError('This Campaign Name already exists. Please use a new Campaign Name.');
                        }
                    }
                }
            }        
        }
            catch(Exception exp)
        {
            system.debug('Exception occcured while validating Campaign Name'+exp); 
        }
    }
    
    
    /**************Test Methods***************/
    public static testmethod void TestUniqueNameValidation() {
    
        Campaign c = new Campaign();
        c.Name='Test CG';
        c.Ad_Communication__c='Product';
        insert c;
        
        Campaign c1 = new Campaign();
        c1.Name='Test_CG';
        c1.Ad_Communication__c='Promotion';
        insert c1;
    
    }
}