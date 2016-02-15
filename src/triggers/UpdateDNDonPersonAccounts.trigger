trigger UpdateDNDonPersonAccounts on Account (After insert,After Update) {

Map<String, Boolean> FilteredBookedAccountMobileMap=new Map<String, Boolean>();

if(trigger.isinsert){
    for(account a:trigger.new){
        
        if(a.RecordtypeId=='012D0000000hZXJ' && a.personmobilephone != null && a.personmobilephone!='' && a.TRAI_DND__c==true){
            FilteredBookedAccountMobileMap.put(a.personmobilephone, a.TRAI_DND__c);
        }
    
    }
}

if(trigger.isupdate){
    Map<Id,Account> OldBAccountMap=new Map<Id,Account>();
    for(account b:trigger.old){
        if(b.RecordtypeId=='012D0000000hZXJ'){
            OldBAccountMap.put(b.id,b);
        }       
    
    }
    
    for(account c:trigger.new){
        if(OldBAccountMap.containskey(c.Id)==true){
            if( ( (OldBAccountMap.get(c.Id).TRAI_DND__c==false && c.TRAI_DND__c==true) || (OldBAccountMap.get(c.Id).TRAI_DND__c==true && c.TRAI_DND__c==false ) ) && c.personmobilephone != null && c.personmobilephone!=''){
                FilteredBookedAccountMobileMap.put(c.personmobilephone, c.TRAI_DND__c);
            } 
        }   
    }

}

if(FilteredBookedAccountMobileMap.size()>0){
    List<account> RelatedPersonaccountLst=[select id,mobile_phone__c,Mobile1__c,Mobile_CSS__c,recordtypeid,TRAI_DND__c,PersonDoNotCall,Not_Interested_Customer__c from Account where recordtype.name='Person Account' AND mobile_phone__c IN:FilteredBookedAccountMobileMap.keySet()];
    
    if(RelatedPersonaccountLst != null && RelatedPersonaccountLst.size()>0){
        for(account acc:RelatedPersonaccountLst){
            if(FilteredBookedAccountMobileMap.get(acc.mobile_phone__c) == true){
                if(acc.PersonDoNotCall==false || acc.Not_Interested_Customer__c==false || acc.TRAI_DND__c==false){
                    acc.PersonDoNotCall=true;
                    acc.Not_Interested_Customer__c=true; 
                    acc.TRAI_DND__c = true;
                }
            }
            else if(FilteredBookedAccountMobileMap.get(acc.mobile_phone__c) == false){
                if(acc.PersonDoNotCall==true || acc.Not_Interested_Customer__c==true || acc.TRAI_DND__c==true){
                    acc.PersonDoNotCall=false;
                    acc.Not_Interested_Customer__c=false;       
                    acc.TRAI_DND__c = false;
                }      
            }
        }
        update RelatedPersonaccountLst;
    }
} 

// Updation of account email address in the Customer profile page in SFDC
/*
    if(trigger.isUpdate && trigger.isAfter){
    
        Set<Id> recTypeIds = new Set<Id>();
    
            for(Account acc:Trigger.old){
                recTypeIds.add(acc.RecordTypeId) ;
            }
        
        Id  recTypeAcc = [SELECT Id,Name FROM RecordType WHERE Name = 'Booked Account' LIMIT 1].Id; 
    
  
    
        System.debug('----SOQL---- '+recTypeAcc+'----recTypeIds----'+recTypeIds+'----oldMap----'+Trigger.oldMap+'----Newmap---- '+Trigger.newMap);

//If record type is Booked Account then move further     
         if(recTypeIds.contains(recTypeAcc))
         {

          UpdateDNDonPersonAccountsHandler oUpdateDNDonPersonAccountsHandler = new UpdateDNDonPersonAccountsHandler();
          oUpdateDNDonPersonAccountsHandler.onAfterUpdate(Trigger.oldMap,Trigger.newMap);
      
          }

      
    }
    */
}