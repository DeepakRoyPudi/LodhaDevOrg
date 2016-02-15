trigger CreateChannelPartnerAccount on Channel_Partner__c (after update) {
    List<Account> accountList = new List<Account>();
    List<account> OldAccountList;
    Set<Id> ChIdSet= new Set<Id>();
    Map<id,List<account>> OldAccountMap=new Map<id,List<account>>();
    Map<Id,String> OldChannelPartnerStatus=new Map<Id,String>();
    Id recTypeId = [Select id from RecordType where Name = 'Channel Partner Account'].id;
    
    for(Channel_Partner__c OldChPartner:Trigger.old){
        OldChannelPartnerStatus.put(OldChPartner.Id,OldChPartner.Activation_Status__c);   
    }
    
    for(Channel_Partner__c chPartner:Trigger.new){
        ChIdSet.add(chPartner.Id);
    }
    
    OldAccountList=[select id,ispersonaccount,Channel_Partner__c,recordtypeid,recordtype.name from account where recordtype.name='Channel Partner Account' AND Channel_Partner__c IN:ChIdSet]; 
    
    system.debug('=======================OldAccountList'+OldAccountList);
    
    for(Account a:OldAccountList){
         if(OldAccountMap.containskey(a.Channel_Partner__c)){
             OldAccountMap.get(a.Channel_Partner__c).add(a);
         }
         else{
             List<account> acc=new List<account>();
             acc.add(a);
             OldAccountMap.put(a.Channel_Partner__c,acc);
         }      
    }
    
    system.debug('=======================OldAccountMap'+OldAccountMap);
    
    for(Channel_Partner__c chPartner:Trigger.new){        
        if(OldAccountMap.containsKey(chPartner.id)==false && OldChannelPartnerStatus.get(chPartner.Id)!='Active' && chPartner.Activation_Status__c=='Active'){
            system.debug('=======================inside account creation'+chPartner);
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
    }
}