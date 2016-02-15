trigger changeOwner on Service_Tax_Detail__c (before insert, before update) {
    
    public List<id> accIdList = new List<id>();
    public Map<id,id> accIDUserIDMapping = new Map<id, id>();
    
    for (Service_Tax_Detail__c std :trigger.new)
        {
            if(std.Account__c != null)accIdList.add(std.Account__c); 
        }
    system.debug('accIdList: '+accIdList);
    List<User> uList = [Select id,ContactID,AccountID FROM User where AccountID IN :accIdList];
    system.debug('uList: '+uList);
    for (USer u :uList)
        {
            accIDUserIDMapping.put(u.AccountID, u.id);
        }
    
    for (Service_Tax_Detail__c std :trigger.new)
        {
            if(accIDUserIDMapping.get(std.Account__c) != null)std.ownerid = accIDUserIDMapping.get(std.Account__c); 
            
        }
    }