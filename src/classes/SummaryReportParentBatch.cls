/*
*    Description: Parent Batch Class for Summary Report Email to Director which will create a list of Project and pass it to Child Batch
*    
*    Version       Date            Name             Description
*	 1.0           07/07/2014      Asmita Bubane    Initial Draft
*/

global class SummaryReportParentBatch implements Database.Batchable<sObject>, Database.stateful{
	
	global Set<String> setProjectName = new Set<String>();
	global List<String> listProjectName = new List<String>();
	String strQuery = '';
	
	// Start Method
	global Database.QueryLocator start(Database.BatchableContext bc){
		
	    strQuery = 'select id, Project_Name_CM__c from Case where (Project_Name_CM__c != null or Project_Name_CM__c != \'\') AND CreatedDate = YESTERDAY';
	    
	    return Database.getQueryLocator(strQuery);
	}// end of start
	
	// Execute Method
	global void execute(Database.BatchableContext bc, List<Case> pListCase){
	    
	    // Generating a list of Project Name from list of Cases
	    if(!pListCase.isEmpty()){
	        
	        for(Case oCase: pListCase){
	    	
	    	if(oCase.Project_Name_CM__c != null || String.isBlank(oCase.Project_Name_CM__c))
	            listProjectName.add(oCase.Project_Name_CM__c);
		    }
		    setProjectName.addAll(listProjectName);
		    listProjectName = new List<String>();
		    listProjectName.addAll(setProjectName);
	        
	    }
	    
	}// end of execute
	
	// Finish Method
	global void finish(Database.BatchableContext bc){
		
		System.debug('================= List of Projects ' + listProjectName);
		System.debug('================= List of Projects ' + listProjectName.size());
		
		if(!listProjectName.isEmpty()){
		    
		    listProjectName.sort();
		    // Passing the list of Project Name and 0 as the index of the list to SummaryReportChildBatch.
	        SummaryReportChildBatch oChildBatch = new SummaryReportChildBatch(listProjectName, 0);
	        Database.executeBatch(oChildBatch);    
		}
		
	}

}