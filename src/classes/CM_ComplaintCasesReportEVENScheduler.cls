global class CM_ComplaintCasesReportEVENScheduler implements Schedulable 
{
     global void execute(SchedulableContext SC) {
       CM_ComplaintCasesReportGeneratorEVEN reportEVEN = new CM_ComplaintCasesReportGeneratorEVEN();
       Database.executeBatch(reportEVEN, 10 );
   }
}