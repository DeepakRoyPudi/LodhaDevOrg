/*
*    Description: Handler for trigger on Flat object
*    
*    Version       Date        Author          Description
*     1.0        18/6/2014   Lodha Group IT    Initial Draft
*     1.1        16/10/2014  Asmita (Eternus)  to perform webservice callout on after insert and after update event
*/ 

public class FlatTriggerHandler {

    public void onAfterInsert(Map<Id, Flat__c> pOldFlatMap, Map<Id, Flat__c> pNewFlatMap){
    	
        // Calling the helper class which will make a callout to the webservice
        ServiceForSendingBookedFlatHelper objServiceForBookedFlat = new ServiceForSendingBookedFlatHelper();
        objServiceForBookedFlat.makeCalloutToWebserviceOnInsert(pOldFlatMap, pNewFlatMap);
    }    
    public void onAfterUpdate(Map<Id, Flat__c> pOldMap, Map<Id, Flat__c> pNewMap){
        
        //Invoke ArchiveFlats Method
        /*ArchiveFlats oArchiveFlats = new ArchiveFlats();
        oArchiveFlats.archiveFlats(pOldMap, pNewMap);*/
         // Calling the helper class which will make a callout to the webservice
        ServiceForSendingBookedFlatHelper objServiceForBookedFlat = new ServiceForSendingBookedFlatHelper();
        objServiceForBookedFlat.makeCalloutToWebserviceOnUpdate(pOldMap, pNewMap);
    }
}