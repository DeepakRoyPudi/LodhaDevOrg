/*
*    Description: Child batch class called from the finish method of SummaryReportParentClass. This class will get the Cases related to each project and 
*                 send a summary report of related cases to director.
*    
*    Version       Date            Name             Description
*	 1.0           07/07/2014      Asmita Bubane    Initial Draft
*/

global class SummaryReportChildBatch implements Database.Batchable<sObject>, Database.Stateful{
	
	String strProjectName = '';
	String strQuery = '';
	global List<String> listProjName = new List<String>();
	global Integer intListIndex;
	global List<Case> listConsolidatedCases = new List<Case>();
	
    //Constructor
    global SummaryReportChildBatch(List<String> pListProjectName, Integer pIntIndex){
    	
    	listProjName = pListProjectName;
    	intListIndex =  pIntIndex;
        strProjectName = listProjName.get(intlistIndex);
        listConsolidatedCases = new List<Case>();
    } 
	
	// Start Method
	global Database.QueryLocator start(Database.BatchableContext bc){
		
	    strQuery = 'select caseNumber, CreatedDate, Nature_of_Request__c, Request_for_L1__c, Request_for_L2__c, Request_for_L3_a__c, Request_for_L3__c, Status, TL_EmailId__c, Owner_EmailId__c, TL__c, PIC_EmailId__c,Remaining_Hours__c, Owner.name, createdBy.email, Date_of_Complaint__c, Date_of_Grievance__c, Interaction_Mode__c, Priority, Case_Summary__c, Case_Resolution__c, Dependency_on_Internal_functions__c,Project_Name_CM__c, account.Id from Case where (Nature_of_Request__c =\'Grievance\' or ( Nature_of_Request__c =\'Complaint\' and Needs_approval_from_director__c = \'NO\')) AND ( Request_for_L1__c != \'\' AND Request_for_L2__c != \'\' ) AND CreatedDate = YESTERDAY and Project_NAME_CM__c = \''+ strProjectName + '\' ';
	    
	    return Database.getQueryLocator(strQuery);
	}// end of start
	
	
	// Execute Method
	global void execute(Database.BatchableContext bc, List<Case> pListCase){
	    
	    // Iterating through list of Cases
		if(!pListCase.isEmpty()){
            listConsolidatedCases.addAll(pListCase);
		}
	    
	}// end of execute
	
	
	// Finish Method
	global void finish(Database.BatchableContext bc){
		
		if(!listConsolidatedCases.isEmpty()){
		    SummaryReportBatchHandler oBatchHandler = new SummaryReportBatchHandler();
		    oBatchHandler.sendSummaryReportEmail(listConsolidatedCases, strProjectName);
		}
		
		if(intListIndex < listProjName.size()-1){
		    SummaryReportChildBatch oChildBatch = new SummaryReportChildBatch(listProjName, intListIndex + 1);
		    Database.executeBatch(oChildBatch);
		}    
	}

}