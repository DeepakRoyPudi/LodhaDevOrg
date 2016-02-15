@isTest(seealldata=false)  
private class testCampaignUniqueName {                    
    public static testMethod void myunittest() {
    
    id RTId = [Select id from RecordType where Name = 'Campaign'].id;
    
    Campaign c = new Campaign(Name = 'test',
                            Mode_of_Advertisement__c= 'Newspaper',
                            Recordtypeid = RTId,
                            Type = 'Email'
                            );
    insert c;
    
            
    c.Type = 'other';
    update c;
    
   
    }
}