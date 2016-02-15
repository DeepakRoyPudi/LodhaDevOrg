trigger InventoryUpdate on SCUD_Information__c (after update) {

     Map<Id, String> pbeIds = new Map<Id, String>();
     List<Flat__c> flatList = new List<Flat__c>();
          
     for(SCUD_Information__c scud : trigger.new){
        if (scud.SCUD_Status__c == 'Approved'){
             pbeIds.put(scud.Booking_Information__c, 'BOOKING');
             //SpBookInventory spbi = new SpBookInventory();
             //spbi.createfametask();
        } 
         else if(scud.SCUD_Status__c != NULL){
             if(scud.SCUD_Status__c.contains('Reject')){
            	pbeIds.put(scud.Booking_Information__c, 'SCUD REJECT');
             }
        }
     }
                
     Map<Id, Booking_Information__c> BookingMap = new Map<Id, Booking_Information__c>([select Id, Flat__c, Booking_Status__c from Booking_Information__c where Id in :pbeIds.KeySet()]);
                
     for (Booking_Information__c booking : BookingMap.values())    
     {
          booking.Booking_Status__c = pbeIds.get(booking.Id);
          Flat__c flatobj = new Flat__c(Id = booking.Flat__c, Status__c = pbeIds.get(booking.Id));
          flatList.add(flatobj);
     }
     update BookingMap.Values();
     update flatList;
          
}