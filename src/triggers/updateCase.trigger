/* This trigger updates the Case Owner whenever the case is created.
The case owner is picked from SAPBookingIDAgentMapping object based on the Flat Details for 'Other Cases' and Case Owner is set to Account Owner for 'CSS Cases'
*/
trigger updateCase on Case (before insert) {

    //Declare the map with Combination as the key and Agent ids as the keyset
    Map<String, id> SAPBookingIDAgentMap = new Map<string, id>();
    Map<String, String> BookingIdMap = new Map<String, String>();
    Map<String, id> BookindObjMap = new Map<String, id>();
    List<BookingId__c> bookindIdObjList = [Select Id, Name from BookingId__c];   
    //Map<String, id> accIdBookingIdmapping = new Map<String, id>();
    //List<Account> accListCQS  = new List<Account>();
    Map<id, id> accIdOwnerIdmapping = new Map<id, id>();
    List<id> accids = new List<id>();
            
    for (Case c:trigger.new){
        system.debug('accountid: '+c.accountid);
        accids.add(c.accountid);
    }
    
    List<Account> accList = [Select id, ownerid from Account where id IN:accids];
    system.debug('accList********: '+accList);
    accids.clear();
    //Integer count = 0;
    for(Account a:accList)
    {
        accIdOwnerIdmapping.put(a.id, a.ownerid);
        system.debug('accIdOwnerIdmapping********: '+accIdOwnerIdmapping);
        //accList.remove(count);
        //count++;
    }
    accList.clear();
    for(BookingId__c bookindIdRecs :bookindIdObjList ){
    BookindObjMap.put(bookindIdRecs.Name, bookindIdRecs.Id);
    }
    
    
    /*if(bookindIdObjList.size() != 0){
    accListCQS = [Select id, CRN__c from Account where CRN__c IN :BookindObjMap.keyset()];
    }
    
    for (Account a:accListCQS){
        accIdBookingIdmapping.put(a.CRN__c,a.id);
    }*/
    
//    List<SAPBookingIDAgentMapping_del__c> mappingObjList = [Select Agent_Name__c,Booking_ID__c, Combination__c from SAPBookingIDAgentMapping_del__c LIMIT 10000];
    //Putting data in the map
    for (SAPBookingIDAgentMapping_del__c allRecs:[Select Agent_Name__c,Booking_ID__c, Combination__c from SAPBookingIDAgentMapping_del__c LIMIT 10000]){
        System.debug('allRecs.Combination__c = ' + allRecs);  
        SAPBookingIDAgentMap.put(allRecs.Combination__c, allRecs.Agent_Name__c); 
        System.debug('SAPBookingIDAgentMap = ' +SAPBookingIDAgentMap );  
        BookingIdMap.put(allRecs.Combination__c, allRecs.Booking_ID__c);
        System.debug('allRecs.Combination__c = ' + allRecs.Combination__c );   
    }
 for (Case c:trigger.new){    
        //the combination key for the Map
        String CaseCombination = c.Project__c+c.Buildings_Name__c+c.Wing__c+c.X4DigitFlatNo__c;
        CaseCombination = CaseCombination.toUpperCase();
        System.debug('CaseCombination = ' + CaseCombination );
        system.debug('c.account.ownerid: '+c.account);        
        if(RecordTypeHelper.getRecordTypeName(c.RecordTypeid) == 'Other Cases'){          
            if(SAPBookingIDAgentMap.get(CaseCombination) != null)
                {   
                    c.OwnerId = SAPBookingIDAgentMap.get(CaseCombination);
                    System.debug('SAPBookingIDAgentMap = ' + SAPBookingIDAgentMap.get(CaseCombination) );
                    System.debug('CaseCombination = ' + CaseCombination );
                        //c.BookingId__c = BookingIdMap.get(CaseCombination);
                        if(BookingIdMap.get(CaseCombination) != null){
                        c.BookingIdLookup__c = BookindObjMap.get(BookingIdMap.get(CaseCombination));
                        /*c.accountid = accIdBookingIdmapping.get(BookingIdMap.get(CaseCombination));
                        //update(c);*/
                        }
                }   
                else
                {
                    System.debug('SAPBookingIDAgentMap = ' + SAPBookingIDAgentMap.get(CaseCombination) );
                    System.debug('CaseCombination = ' + CaseCombination );
                    //If the details do not match, the customer should not be allowed to create a case
                    c.addError('Sorry, the residence credentials you have entered are incorrect.  Please re-enter the details correctly.');
                }

        }else if(RecordTypeHelper.getRecordTypeName(c.RecordTypeid) == 'CSS Cases')
                { 
                    system.debug('accIdOwnerIdmapping.get(c.accountid)' +accIdOwnerIdmapping.get(c.accountid));
                    c.ownerId = accIdOwnerIdmapping.get(c.accountid);
                    c.Email__c = c.Email_Formula__c;
                }
    }
    SAPBookingIDAgentMap.clear(); 
    accIdOwnerIdmapping.clear();
    BookingIdMap.clear();
    BookindObjMap.clear();
    
 }