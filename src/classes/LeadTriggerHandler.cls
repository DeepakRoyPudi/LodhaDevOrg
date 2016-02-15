/*
*    Description : Handler class for Lead trigger
*
*       Date        Version      Name     Description
*    17/07/2014       1.0       Asmita    Initial Draft
*/

public class LeadTriggerHandler {
	
	// Method will be executed if before insert event occures	
	 public void onBeforeInsert(List<Lead> listNewLead){
         
         // Calling LeadZoneSuburbMappingHelper to populate the Zone field depending on Sunburb value selected
         LeadZoneSuburbMappingHelper oLeadZoneSuburbMapper = new LeadZoneSuburbMappingHelper();
         oLeadZoneSuburbMapper.insertZoneDependingOnSuburb(listNewLead);
     }
     
     // Method will be executed if before update event occures
     public void onBeforeUpdate(Map<Id, Lead> mapOldLead, Map<Id, Lead> mapNewLead){
         
         // Calling LeadZoneSuburbMappingHelper to populate the Zone field depending on Sunburb value selected
         LeadZoneSuburbMappingHelper oLeadZoneSuburbMapper = new LeadZoneSuburbMappingHelper();
         oLeadZoneSuburbMapper.updateZoneDependingOnSuburb(mapOldLead, mapNewLead);
     }

}