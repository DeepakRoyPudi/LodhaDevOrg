trigger CreateLoyaltyDetails on Account (before insert, before update){
     
     if(!StaticVariableUtility.createLoyaltyDetailsBeforeInsertUpdateRunOnce()){
     
     List<Account> accnt=new List<Account>();
     List<Loyalty_Detail__c> loyalDetailsLst=new  List<Loyalty_Detail__c>();
     Set<String> loyaltyIdSet = new Set<String>();
     Map<String, Loyalty_Detail__C> loyaltyDetailMap = new Map<String,Loyalty_Detail__C>();

     //Siddharth 25/08/2014 Removed the SOQL query for record type and put a describe statement
     //id recId = [Select id from RecordType where Name = 'Booked Account'].id;
     Id recId = Account.SObjectType.getDescribe().getRecordTypeInfosByName().get('Booked Account').getRecordTypeId();
     
     for (Account anAcc:trigger.new) {
         if(anAcc.LoyaltyID__c!=null) {
             loyaltyIdSet.add(anAcc.LoyaltyID__c);
         }
     }
     for(Loyalty_Detail__c ld :[select Loyalty_Id__c,Id  from Loyalty_Detail__c where Loyalty_Id__c  = :loyaltyIdSet])
     {
         loyaltyDetailMap.put(ld.Loyalty_Id__c,ld);
     }
     for (Account a:trigger.new){ 
         if(a.RecordTypeId==recId){
             if(a.LoyaltyID__c!=null){
                 if(!loyaltyDetailMap.containsKey(a.LoyaltyID__c)) {
                     Loyalty_Detail__c ldnew=new  Loyalty_Detail__c();
                     ldnew.Loyalty_Id__C = a.LoyaltyID__c;
                     loyalDetailsLst.add(ldnew); 
                     loyaltyDetailMap.put(a.LoyaltyID__c,ldnew);
               //      a.Loyalty_Details__c = loyaltyDetailMap.get(a.LoyaltyID__c).Id;
                 
                   }
                  
              } 
          }
      }
      insert loyalDetailsLst;
      for(Account accRec: trigger.new) {
         if(accRec.RecordTypeId==recId){
             if(accRec.LoyaltyID__c!=null){
                accRec.Loyalty_Details__c = loyaltyDetailMap.get(accRec.LoyaltyID__c).Id;
             }
         }
      }
      
     }//Static Variable If
}