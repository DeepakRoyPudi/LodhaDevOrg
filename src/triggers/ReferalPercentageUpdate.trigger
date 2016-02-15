trigger ReferalPercentageUpdate on Account (before insert, before update) {
    
    if(!StaticVariableUtility.referalPercentageUpdateBeforeInsertUpdateRunOnce()){
    
    Map<id, string> userIdNameMapping = new Map<id, String>();
    List<id> accOwnerIds = new List<Id>();
    
    for(Account a:trigger.new){ 
        accOwnerIds.add(a.ownerid);
    }
    List <User> uList = [Select id, Name from User where id IN:accOwnerIds];
    
    for (User u:uList){
        userIdNameMapping.put(u.id, u.name);
    }
    
    if(trigger.Isupdate)
    {
        AccountReferalCheck.PercentageReceived(Trigger.New);
        
        for(Account a:trigger.new){     
        a.Person_email_from_trigger__c = a.PersonEmail;     
        a.Mobile_CSS__c = a.PersonMobilePhone;     
        a.Owner_Name__c = userIdNameMapping.get(a.ownerid);
        }
    }
    
    if(trigger.Isinsert)
    {
        for(Account a:trigger.new){
        a.Person_email_from_trigger__c = a.PersonEmail; 
        a.Mobile_CSS__c = a.PersonMobilePhone;      
        a.Owner_Name__c = userIdNameMapping.get(a.ownerid);
        }
    }
    
    }//Static Variable If
}