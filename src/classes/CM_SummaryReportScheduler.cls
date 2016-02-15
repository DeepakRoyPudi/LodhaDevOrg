/*
*    Description: Scheduler for generating the Summary Report for Complaint and Grievance Cases everyday at 7 PM 
*    
*    Version       Date            Name             Description
*	 1.0           07/07/2014      Asmita Bubane    Initial Draft
*/

global class CM_SummaryReportScheduler implements Schedulable 
{
     global void execute(SchedulableContext SC) {
     
        /*CM_SummaryReportGenerator summaryReport = new CM_SummaryReportGenerator();
        Database.executeBatch(summaryReport , 200 );*/
        
        SummaryReportParentBatch oSummaryBatch = new SummaryReportParentBatch();
        Database.executeBatch(oSummaryBatch); 
   }
}