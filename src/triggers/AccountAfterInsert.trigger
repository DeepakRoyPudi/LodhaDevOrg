trigger AccountAfterInsert on Account (after insert) {
    Set<Id> accIdSet = new set<id>();
    Set<Id> userIdSet = new set<id>();
    for(Account acc:Trigger.new){
        accIdSet.add(acc.id);
    }
    try{
    List<User> userList = new List<User>();
    
    Profile profiles = [Select p.name, p.id From Profile p where p.UserLicense.Name like '%Customer Portal%' and p.name like 'Lodha Channel Partner'  limit 1];
    
    List<Account>accountList =[select id,lastName,isViaCP__c,Personal_Email__pc,PersonEmail,PersonContactId from Account where id IN:accIdSet];
    if(accountList!=null && accountList.size()>0){
        for(Account acc:accountList){
            if(acc.isViaCP__c){
                if(acc.Personal_Email__pc!=null){
                    User u = new User(alias = 'standt', email=acc.Personal_Email__pc,
                                        emailencodingkey='UTF-8', lastname=acc.lastname, languagelocalekey='en_US',
                                        localesidkey='en_US', profileid = profiles.id, contactId=acc.PersonContactId,
                                        timezonesidkey='America/Los_Angeles', username=acc.PersonEmail);
                    userList.add(u);
                }
            } 
        }
    }   
    if(userList!=null && userList.size()>0){
        insert userList;
        for(User userRec:userList){
            userIdSet.add(userRec.id);
            System.resetPassword(userRec.Id, true);
        }
    }
    }catch(Exception e){
        system.debug('Error occured while inserting account'+e);
    }
    
}