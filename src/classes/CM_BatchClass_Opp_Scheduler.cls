global class CM_BatchClass_Opp_Scheduler implements Schedulable 
{
     global void execute(SchedulableContext SC) {
        CM_BatchClass_Opp_Case_Transfer a= new CM_BatchClass_Opp_Case_Transfer();
        Database.executeBatch(a,1000);
   }
}