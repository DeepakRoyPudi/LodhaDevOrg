global class CM_BatchClass_Opp_Case_Transfer implements Database.batchable<Sobject>{ 
   global Database.QueryLocator start(Database.BatchableContext info){ 
       string Query='select id,name,OASYS_Status__c,(select id,name,Name_Of_Opportunity__c,inactive__c,Booking_Status__c,CRN_Number_SAP__c from Booking_Informations1__r where Booking_Status__c=\'SOLD\' and CRN_Number_SAP__c != null) from opportunity';
       return Database.getQueryLocator(query);
   }     
   global void execute(Database.BatchableContext info, List<Sobject> scope){
        Opportunity oppyt=null;
        set<Id> SelectedOpptyIdList=new set<Id>();
        List<case> SelectedCaseList;
        List<case> FinalCaseList;
        Map<Id,List<case>> OpptyMap;
        Map<Id,List<String>> OpptyCRN=new Map<Id,List<String>>();
        List<string> bookingStringLst;
        List<string> bookingIdLst=new List<string>();
        set<string> bookingCRNLst=new set<string>();
        Map<String,Id> AccIdCRNMap=new Map<String,Id>();
        List<Account> AccLst;
        for(Sobject a:scope){
            oppyt=(Opportunity)a;
            if( oppyt.Booking_Informations1__r.size() != 0 ){
                SelectedOpptyIdList.add(oppyt.id);
                bookingStringLst=new List<string>();
                for(Booking_Information__c b:oppyt.Booking_Informations1__r){
                    bookingStringLst.add(b.CRN_Number_SAP__c); 
                    bookingIdLst.add(b.id);  
                    bookingCRNLst.add(b.CRN_Number_SAP__c);                                  
                }
                OpptyCRN.put(oppyt.id,bookingStringLst);  
                bookingStringLst=null;                            
            }         
        }
        if(bookingCRNLst.size() > 0){
            AccLst=[select id,CRN__c from account where recordtype.name='Booked Account' AND CRN__c IN:bookingCRNLst];
            if(AccLst.size() != 0){
                for(Account d:AccLst){
                    AccIdCRNMap.put(d.CRN__c,d.Id);
                }
            }
        }
        
        if(SelectedOpptyIdList.size() != 0){
            SelectedCaseList=[select id,Opportunity__c,Related_Booking__c,Related_Booking__r.CRN_Number_SAP__c,AccountId,IsMoved__c from case where Opportunity__c IN:SelectedOpptyIdList AND IsMoved__c=false AND Related_Booking__c IN:bookingIdLst];         
            if(SelectedCaseList.size()!=0){
                OpptyMap=new  Map<Id,List<case>>();           
                for(Case c:SelectedCaseList){
                    if(OpptyMap.ContainsKey(c.Opportunity__c)){
                        OpptyMap.get(c.Opportunity__c).add(c);
                    }
                    else{
                    List<Case> mynewcaselst=new List<Case>();
                    mynewcaselst.add(c);
                    OpptyMap.put(c.Opportunity__c,mynewcaselst);
                    }                                    
                }
                if(OpptyMap.keyset().size()!=0){
                    for(Id i:OpptyMap.keyset()){
                        if(OpptyMap.get(i).size()>0){
                            for(Case c:OpptyMap.get(i)){
                                c.IsMoved__c=true;
                                c.AccountId=AccIdCRNMap.get(c.Related_Booking__r.CRN_Number_SAP__c);                                
                            }
                        }                 
                    }
                }
                FinalCaseList=new List<case>();
                for(List<case> f:OpptyMap.values()){
                    for(case g:f){
                        FinalCaseList.add(g);
                    }
                }
                Update FinalCaseList;
            }
        }
   }     
   global void finish(Database.BatchableContext info){     
   } 
}