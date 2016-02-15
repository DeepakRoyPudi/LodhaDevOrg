global class CM_CustomReportGenerator_MORN_Scheduler implements Schedulable 
{
     global void execute(SchedulableContext SC) {
        CM_CustomReportGenerator_MORN reportGeneratorMORN= new CM_CustomReportGenerator_MORN();
        Database.executeBatch(reportGeneratorMORN, 10);
   }
}