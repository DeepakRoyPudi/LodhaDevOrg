/*
*    Description: Helper for trigger on Flat object which will make a callout to the php Webservice for Palava
*    
*    Version       Date        Author          Description
*     1.0        06/11/2014  Asmita (Eternus)  Initial Draft
*/

public with sharing class ServiceForSendingBookedFlatHelper {
    
    private static final String STRBLOCKED = 'BLOCKED';
    private static final String STRBOOKED = 'BOOKED';
    private static final String STRSOLD = 'SOLD';
    
    public void makeCalloutToWebserviceOnInsert(Map<Id, Flat__c> pOldFlatMap, Map<Id, Flat__c> pNewFlatMap){
    	
    	List<String> listOasysFlatCode = new List<String>();
        
        for(Flat__c objFlat : pNewFlatMap.values()){
        	if(objFlat.Status__c != null){
        		if(objFlat.Status__c.equalsIgnoreCase(STRBLOCKED) || objFlat.Status__c.equalsIgnoreCase(STRBOOKED) || objFlat.Status__c.equalsIgnoreCase(STRSOLD)){
        			if(!String.isBlank(objFlat.Oasys_Flat_Code__c))
        		        listOasysFlatCode.add(objFlat.Oasys_Flat_Code__c);
        		}
        	} // end of if
        }// end of for
        
        if(!listOasysFlatCode.isEmpty()){
            BatchCallToPalavaWebservice objBatchCallToWebservice = new BatchCallToPalavaWebservice(listOasysFlatCode, 0);
            Database.executeBatch(objBatchCallToWebservice);
        }
    }
    
    public void makeCalloutToWebserviceOnUpdate(Map<Id, Flat__c> pOldFlatMap, Map<Id, Flat__c> pNewFlatMap){
    	
    	List<String> listOasysFlatCode = new List<String>();
        
        for(Flat__c objFlat : pNewFlatMap.values()){
        	if((objFlat.Status__c != null || objFlat.Status__c != '') && (pOldFlatMap.get(objFlat.Id).Status__c != null || pOldFlatMap.get(objFlat.Id).Status__c != '')){
        		if(!objFlat.Status__c.equalsIgnoreCase(pOldFlatMap.get(objFlat.Id).Status__c) && (objFlat.Status__c.equalsIgnoreCase(STRBLOCKED) || objFlat.Status__c.equalsIgnoreCase(STRBOOKED) || objFlat.Status__c.equalsIgnoreCase(STRSOLD))){
        		    if(!String.isBlank(objFlat.Oasys_Flat_Code__c))
        		        listOasysFlatCode.add(objFlat.Oasys_Flat_Code__c);
        		}
        	} // end of if
        }// end of for
        if(!listOasysFlatCode.isEmpty()){
            BatchCallToPalavaWebservice objBatchCallToWebservice = new BatchCallToPalavaWebservice(listOasysFlatCode, 0);
            Database.executeBatch(objBatchCallToWebservice);
        }
    }
}