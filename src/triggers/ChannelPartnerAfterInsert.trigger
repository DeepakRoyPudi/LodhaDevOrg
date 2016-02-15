trigger ChannelPartnerAfterInsert on Channel_Partner__c (after insert){
    List<Account> accountList = new List<Account>();
    Set<Id> accIdSet= new Set<Id>();
   // Id recTypeId = [Select Id From RecordType  Where SobjectType = 'Account' and DeveloperName = 'Channel_Partner_Account'].id;
    Id recTypeId = [Select id from RecordType where Name = 'Channel Partner Account'].id;
     
    for(Channel_Partner__c chPartner:Trigger.new){
        if(chPartner.Activation_Status__c=='Active'){
            Account accRecord = new Account();
            //accRecord.firstName = chPartner.name ;
            accRecord.lastName = chPartner.name ;
            accRecord.recordTypeId = recTypeId;
            accRecord.Personal_Email__pc = chPartner.Email__c;
            accRecord.PersonEmail=chPartner.REAP_ID__c+'@mylodha.com';
            accRecord.Status__c= 'Active';
            accRecord.isViaCP__c = true;
            accRecord.Channel_Partner__c = chPartner.id;
            accountList.add(accRecord);
        }
    }
    if(accountList!=null){
        insert accountList;
        for(Account acc:accountList){
            accIdSet.add(acc.id);
        }
    }
    //ChannelPartnerAfterInsert.createUser(accIdSet);
}