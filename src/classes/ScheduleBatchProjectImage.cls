global class ScheduleBatchProjectImage implements Schedulable{
   global void execute(SchedulableContext sc) {
      BatchProjectImage BatchProjectImageObj = new BatchProjectImage(); 
      database.executebatch(BatchProjectImageObj);
   }
}