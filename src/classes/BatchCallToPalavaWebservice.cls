/*
*    Description: Batch class for making a call to a Palava webservice for sending Oasys code in each call.
*    
*    Version       Date        Author          Description
*     1.0        06/11/2014  Asmita (Eternus)  Initial draft
*/

global class BatchCallToPalavaWebservice implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {

	global List<String> listOasysFlatCode = new List<String>();
	global Integer numberOfOasysCode;
	global String strOasysCode = '';
	
    //Constructor
    global BatchCallToPalavaWebservice(List<String> pListOasysFlatCode, Integer pNumberOfOasysCode){
        listOasysFlatCode = pListOasysFlatCode;
        numberOfOasysCode = pNumberOfOasysCode;
        if(!listOasysFlatCode.isEmpty() && numberOfOasysCode < listOasysFlatCode.size())
            strOasysCode = listOasysFlatCode.get(numberOfOasysCode);
    } 
	
	// Start Method
	global Database.QueryLocator start(Database.BatchableContext bc){
		
	    String strQuery = 'select id from Flat__c where Oasys_Flat_Code__c = \''+ strOasysCode + '\' ';
	    
	    return Database.getQueryLocator(strQuery);
	}// end of start
	
	
	// Execute Method
	global void execute(Database.BatchableContext bc, List<Flat__c> pListFlat){
 	    
	}// end of execute
	
	
	// Finish Method
	global void finish(Database.BatchableContext bc){
		
		FutureClassForConsumingPalavaWebservice.sendOasysCode(strOasysCode);
		numberOfOasysCode = numberOfOasysCode + 1;
		
		if(!listOasysFlatCode.isEmpty() && numberOfOasysCode < listOasysFlatCode.size()){
            BatchCallToPalavaWebservice objBatchCallToWebservice = new BatchCallToPalavaWebservice(listOasysFlatCode, numberOfOasysCode);
            Database.executeBatch(objBatchCallToWebservice);	
		}	
	}

}