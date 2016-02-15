global class CM_ComplaintCasesReportMORNScheduler implements Schedulable 
{
     global void execute(SchedulableContext SC) {
        CM_ComplaintCasesReportGeneratorMORN reportMORN = new CM_ComplaintCasesReportGeneratorMORN();
        Database.executeBatch(reportMORN, 10 );
   }
}