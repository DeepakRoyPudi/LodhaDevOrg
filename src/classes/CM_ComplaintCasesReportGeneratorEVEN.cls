/**********************************************************************************
Name: CM_CustomReportGenerator_EVEN
Copyright © 2012 Lodha Group
===================================================================================
===================================================================================
Purpose:
-------
Class to send Emails for Escalated cases
===================================================================================
===================================================================================
History
-------
VERSION AUTHOR DATE DETAIL 
1.0 - CG Dev Team 05/12/2013 INITIAL DEVELOPMENT
**********************************************************************************/

/*********************************************************************
Purpose : To Send custom email
Parameters : None
Returns : None
**********************************************************************/ 


global class CM_ComplaintCasesReportGeneratorEVEN implements Database.batchable<sObject>{ 

    public String query= '';
    

    /* start */
    global Database.QueryLocator start(Database.BatchableContext obj){
        try{
            query = 'Select CreatedDate, Nature_of_Request__c, Request_for_L1__c, Request_for_L2__c, Request_for_L3_a__c, Request_for_L3__c,              Status, TL_EmailId__c, Owner_EmailId__c, TL__c, PIC_EmailId__c,     Remaining_Hours__c, Owner.name, createdBy.email, Date_of_Complaint__c, Interaction_Mode__c, Priority, Case_Summary__c, Case_Resolution__c, Dependency_on_Internal_functions__c from case  where Nature_of_Request__c =\'Complaint\' and Needs_approval_from_director__c = \'YES\'';
            
            
            System.debug('Query => ' + query );
        }catch(Exception ex){
            System.debug('Error in CM_ComplaintCasesReportGenerator -> Start => '+ ex);
        }
            
        return Database.getQueryLocator(query);
    }
    
    
    /* execute */
    global void execute(Database.BatchableContext obj, List<Case> caseList){
        if (caseList != null && caseList.size() > 0){
            System.debug('Total no of complaint cases retrieved = '+ caseList.size());
            
            /* Creating date instance for YESTERDAY 3 PM */
            ////////////////////////////////****************** /////////////////////////////////////////////////////////////
            DateTIme startDateTime = DateTime.newInstance((Date.today()).addDays(-1), Time.newInstance(15,0,0,0));
            ///////////////DateTIme startDateTime = DateTime.newInstance((Date.today()).addDays(-5), Time.newInstance(15,0,0,0));
            System.debug('startDateTime => ' + startDateTime );
            
            /* Creating date instance for TODAY 8 AM */
            /////////////////////////////////////////////////////////////////////////////////////////////
            ///////////////DateTIme endDateTime = DateTime.newInstancegmt((Date.today()), Time.newInstance(8,0,0,0));
            DateTIme endDateTime = DateTime.newInstance((Date.today()), Time.newInstance(8,0,0,0));
            System.debug('endDateTime => ' + endDateTime );
            
            CM_ComplaintCasesReportHelper helperObj = new CM_ComplaintCasesReportHelper ();
            
            List<Case> filteredCasesList = helperObj.filterCases(caseList, startDateTime , endDateTime );
            System.debug('filteredCasesList =>' +  filteredCasesList );
            
            helperObj.execute(filteredCasesList, false, Date.today().addDays(-1),'Director', true );
            System.debug('after execute!!!!!!!!!!!!!!!!!!!' );
        }
    }
    
    
    /* finish */
    global void finish(Database.BatchableContext obj){
    }
    
}