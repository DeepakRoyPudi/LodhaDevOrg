trigger MapFieldsToAccount on ProfileInfo__c (before update) {

MapFieldsToAccountHandler mapObj = new MapFieldsToAccountHandler();
 if(trigger.isBefore)
 {
 	
 	if(trigger.isUpdate)
 	{
 		mapObj.getFields(Trigger.new);
 		
 	}
 	
 }



}