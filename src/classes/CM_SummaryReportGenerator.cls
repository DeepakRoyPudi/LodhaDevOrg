/**********************************************************************************
Name: CM_GrievanceCasesRptGenerator
Copyright © 2012 Lodha Group
===================================================================================
===================================================================================
Purpose:
-------
Class to send Emails for Grievance Cases
===================================================================================
===================================================================================
History
-------
VERSION AUTHOR DATE DETAIL 
1.0 - CG Dev Team 15/04/2014 INITIAL DEVELOPMENT
**********************************************************************************/

/*********************************************************************
Purpose : To Send custom email for Grievance Cases
Parameters : None
Returns : None
**********************************************************************/ 


global class CM_SummaryReportGenerator implements Database.batchable<sObject>, Database.Stateful{ 

    public String query= '';
    
    global List<Case> listConsolidatedCase = new List<Case>();

    /* start */
    global Database.QueryLocator start(Database.BatchableContext obj){
        try{
        		// Initializing Created date to filterize the Cases from Yesterday 8 AM to Today 8 AM - Asmita - 12/6
        	    DateTime dtCreatedDateFrom = DateTime.newInstance((System.today()-1).year(), (System.today()-1).month(), (System.today()-1).day(), 08, 00, 00);
        	    DateTime dtCreatedDateTo = DateTime.newInstance(System.today().year(), System.today().month(), System.today().day(), 08, 00, 00);
                query = 'Select caseNumber, CreatedDate, Nature_of_Request__c, Request_for_L1__c, Request_for_L2__c, Request_for_L3_a__c, Request_for_L3__c, Status, TL_EmailId__c, Owner_EmailId__c, TL__c, PIC_EmailId__c,Remaining_Hours__c, Owner.name, createdBy.email, Date_of_Complaint__c, Date_of_Grievance__c, Interaction_Mode__c, Priority, Case_Summary__c, Case_Resolution__c, Dependency_on_Internal_functions__c,Project_Name_CM__c, account.Id from case  where (Nature_of_Request__c =\'Grievance\' or ( Nature_of_Request__c =\'Complaint\' and Needs_approval_from_director__c = \'NO\')) AND ( Request_for_L1__c != \'\' AND Request_for_L2__c != \'\' ) AND CreatedDate >= :dtCreatedDateFrom and CreatedDate <= :dtCreatedDateTo ORDER BY Project_Name_CM__c';
                System.debug('Query => ' + query );
        }catch(Exception ex){
            System.debug('Error in CM_GrievanceCasesRptGenerator -> Start => '+ ex);
        }
            
        return Database.getQueryLocator(query);
    }
    
    
    /* execute */
    global void execute(Database.BatchableContext obj, List<Case> caseList){
        if (caseList != null && caseList.size() > 0){
            System.debug('Total no of complaint cases retrieved = '+ caseList.size());
            
            /* Creating date instance for YESTERDAY 0:0:0 */
            //AKG       
          // ##    DateTIme startDateTime = DateTime.newInstance((Date.today()).addDays(-1), Time.newInstance(0,0,0,0));
           DateTIme startDateTime = DateTime.newInstance((Date.today()).addDays(-20), Time.newInstance(0,0,0,0));
           
            System.debug('startDateTime => ' + startDateTime );
            
            /* Creating date instance for YESTERDAY 23:59:59 */

            DateTIme endDateTime = DateTime.newInstance((Date.today()).addDays(-1), Time.newInstance(23,59,59,0));
            //////////////////DateTIme endDateTime = DateTime.newInstance(Date.today(), Time.newInstance(23,59,59,0));
            System.debug('endDateTime => ' + endDateTime );
            
          
           CM_SummaryReportHelper helperObj = new CM_SummaryReportHelper();
           
           
            
            //List<Case> filteredCasesList = helperObj.filterCases(caseList, startDateTime , endDateTime );
            //System.debug('filtered Grievance cases =>' +  filteredCasesList );
            
            //Siddharth - Commented to avoid sending multiple emails
            //helperObj.execute(filteredCasesList, false, Date.today().addDays(-1), 'Summary', false );
            //System.debug('after execute!!!!!!!!!!!!!!!!!!!' + filteredCasesList.size());
            
            listConsolidatedCase.addAll(caseList);
            System.debug('============ Consolidated Case List ' + caseList.size());
        }
    }
    
    
    /* finish */
    global void finish(Database.BatchableContext obj){
    
        //Logic to Send one single Consolidated Email irrespective of the number of batches executed
        System.debug('============ Finish Consolidated Case List ' + listConsolidatedCase.size());
        CM_SummaryReportHelper objCM_SummaryReportHelper = new CM_SummaryReportHelper();
        objCM_SummaryReportHelper.execute(listConsolidatedCase, false, Date.today().addDays(-1), 'Summary', false);
    }
}