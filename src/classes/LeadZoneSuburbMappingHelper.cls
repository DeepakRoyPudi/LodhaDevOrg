/*
*    Description : Helper class for Lead trigger to map the Zone value depending on the selected Suburb
*
*       Date        Version      Name     Description
*    17/07/2014       1.0       Asmita    Initial Draft
*/

public class LeadZoneSuburbMappingHelper {
	
	private static final String STROTHERCITY = 'OTHER CITY';
	
    // Method to populate the Zone field if the Suburb field is not null
    public void insertZoneDependingOnSuburb(List<Lead> listNewLead){
    	
        // Iterating through new Leads
        for(Lead oLead : listNewLead){
        	
                // populating value for Zone_O from custom setting depending on Suburb selected
                if(oLead.Suburb_OS__c != null && !oLead.Suburb_OS__c.equalsIgnoreCase(STROTHERCITY)){            	
            	    if(ZoneSuburbMapping__c.getall().containsKey(oLead.Suburb_OS__c)){
            	        oLead.Zone_OS__c = (ZoneSuburbMapping__c.getValues(oLead.Suburb_OS__c) != NULL && ZoneSuburbMapping__c.getValues(oLead.Suburb_OS__c).Zone__c != NULL) ? ZoneSuburbMapping__c.getValues(oLead.Suburb_OS__c).Zone__c : '';
            	    }            	    
                }
                else if(oLead.Suburb_OS__c == null)
                    oLead.Zone_OS__c = null;
            
                // populating value for Zone_R from custom setting depending on Suburb selected
                if(oLead.Suburb_RS__c != null && !oLead.Suburb_RS__c.equalsIgnoreCase(STROTHERCITY)){            	
            	    if(ZoneSuburbMapping__c.getall().containsKey(oLead.Suburb_RS__c)){
            	        oLead.Zone_RS__c = (ZoneSuburbMapping__c.getValues(oLead.Suburb_RS__c) != NULL && ZoneSuburbMapping__c.getValues(oLead.Suburb_RS__c).Zone__c != NULL) ? ZoneSuburbMapping__c.getValues(oLead.Suburb_RS__c).Zone__c : '';
            	     }            	    
                }
                else if(oLead.Suburb_RS__c == null)
                    oLead.Zone_RS__c = null;
                
        }// end of for
    }
    
    // Method to update the Zone if the Suburb field is changed
    public void updateZoneDependingOnSuburb(Map<Id, Lead> mapOldLead, Map<Id, Lead> mapNewLead){
        
        // Iterating through Lead
        for(Lead oLead : mapNewLead.values()){
        	    
                // populating value for Zone_O from custom setting depending on Suburb selected
                if(mapOldLead.get(oLead.id).Suburb_OS__c != mapNewLead.get(oLead.id).Suburb_OS__c){
            	    if(oLead.Suburb_OS__c != null && !oLead.Suburb_OS__c.equalsIgnoreCase(STROTHERCITY)){
            	        if(ZoneSuburbMapping__c.getall().containsKey(oLead.Suburb_OS__c)){
            	            oLead.Zone_OS__c = (ZoneSuburbMapping__c.getValues(oLead.Suburb_OS__c) != NULL && ZoneSuburbMapping__c.getValues(oLead.Suburb_OS__c).Zone__c != NULL) ? ZoneSuburbMapping__c.getValues(oLead.Suburb_OS__c).Zone__c : '';
            	        }  
            	    }
            	    else if(oLead.Suburb_OS__c == null)
                        oLead.Zone_OS__c = null;
                }// end of if
            
                // populating value for Zone_R from custom setting depending on Suburb selected
                if(mapOldLead.get(oLead.id).Suburb_RS__c != mapNewLead.get(oLead.id).Suburb_RS__c){
            	    if(oLead.Suburb_RS__c != null && !oLead.Suburb_RS__c.equalsIgnoreCase(STROTHERCITY)){            	
            	        if(ZoneSuburbMapping__c.getall().containsKey(oLead.Suburb_RS__c)){
            	            oLead.Zone_RS__c = (ZoneSuburbMapping__c.getValues(oLead.Suburb_RS__c) != NULL && ZoneSuburbMapping__c.getValues(oLead.Suburb_RS__c).Zone__c != NULL) ? ZoneSuburbMapping__c.getValues(oLead.Suburb_RS__c).Zone__c : '';
            	        }            	    
                    }
                    else if(oLead.Suburb_RS__c == null)
                        oLead.Zone_RS__c = null;
                }// end of if
        }// end of for
    }

}