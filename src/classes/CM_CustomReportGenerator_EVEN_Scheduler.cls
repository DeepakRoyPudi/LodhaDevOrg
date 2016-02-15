global class CM_CustomReportGenerator_EVEN_Scheduler implements Schedulable 
{
     global void execute(SchedulableContext SC) {
        CM_CustomReportGenerator_EVEN reportGeneratorEVEN= new CM_CustomReportGenerator_EVEN();
        Database.executeBatch(reportGeneratorEVEN, 10);
   }
}