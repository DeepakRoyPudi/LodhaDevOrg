/*
*        Description : Class called from Case Trigger and it checks if L3(a) and L3(b) fields holds L3 value, if  so replace it with null
*
*        Version     Date          Author             Description
*          1.0       01/07/2014    Asmita(Eternus)    Intial Draft
*/

public class UpdateL3Value {

    public void replaceL3WithNull(Map<Id, Case> mapOldCase, Map<Id, Case> mapNewCase){
        
        // Iterating over new Case Values
        for(Case oCase : mapNewCase.values()){
            
            // If L3(a) contains L3 replace it with null
            if(mapOldCase.get(oCase.id).Request_for_L3_a__c != null)
                if(!String.isBlank(mapOldCase.get(oCase.id).Request_for_L3_a__c))
                    if(mapOldCase.get(oCase.id).Request_for_L3_a__c.contains('L3') && oCase.Request_for_L3_a__c != null){
            	        oCase.Request_for_L3_a__c = oCase.Request_for_L3_a__c.replace('L3','');
            }
            
            // If L3(b) contains L3 replace it with null
            if(mapOldCase.get(oCase.id).Request_for_L3__c != null )
                if(!String.isBlank(mapOldCase.get(oCase.id).Request_for_L3__c)) 
                    if(mapOldCase.get(oCase.id).Request_for_L3__c.contains('L3') && oCase.Request_for_L3__c != null){
            	        oCase.Request_for_L3__c = oCase.Request_for_L3__c.replace('L3','');
            }
        }// end of for
    }

}