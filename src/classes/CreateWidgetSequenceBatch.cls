/* Version              Created By       Created Date       Description
 *
 *  Initial Draft       Sneha P.          6th July 2015    Batch class to initially create Widget Sequence
 * 														   records for Dynamic type for all Portal users 
 *														   and widgets
 *
 */
global class CreateWidgetSequenceBatch implements Database.Batchable<sObject>{
	
	global list<WidgetInfo__c> widgetInfoList;
	
	global CreateWidgetSequenceBatch(){
    }
       
    // Start Method
	global Database.QueryLocator start(Database.BatchableContext BC){
		String query = 'Select id from user where Profile.Name = \'Custom Overage High Volume Customer Portal\'';
		return Database.getQueryLocator(query);
	}
      
	// Execute Logic
	global void execute(Database.BatchableContext BC, List<sObject>scope){
 		
 		//Get all the Widgets
 		widgetInfoList = [Select Id from WidgetInfo__c];
 		
 		list<Widget_Sequence__c> widgetSeqList = new list<Widget_Sequence__c>();
 		
 		//Create a widget Sequence record for all User and all widgets
 		for(User objUser : (List<User>)scope) {
 			for(WidgetInfo__c widgetInfo: widgetInfoList) {
                widgetSeqList.add(
                		new Widget_Sequence__c(
 				 				WidgetInfo__c = widgetInfo.id,
								User__c = objUser.id,
								Sequence_ClickCount__c = 0,
								Recordtypeid = 
          						Schema.SObjectType.Widget_Sequence__c.getRecordTypeInfosByName().get('Dynamic').getRecordTypeId()
          								)
          						);
 			}
		}
		
		if(widgetSeqList.size() > 0) {
			system.debug('***widgetSeqList*'+widgetSeqList);
			insert widgetSeqList;
		}
	}
     
	global void finish(Database.BatchableContext BC){
		// Logic to be Executed at finish
		AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
      							 TotalJobItems, CreatedBy.Email
      					  FROM AsyncApexJob WHERE Id =:BC.getJobId()];
	   
	   // Send an email for Apex job's  notifying of job completion.
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		String[] toAddresses = new String[] {'sneha.patil@eternussolutions.com'};
		mail.setToAddresses(toAddresses);
		mail.setSubject('Apex Sharing Recalculation ' + a.Status);
		mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems +
							  ' batches with '+ a.NumberOfErrors + ' failures.');
		Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
	}

}