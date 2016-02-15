global class CM_EmailSenderScheduler implements Schedulable 
{
     global void execute(SchedulableContext SC) {
      CM_EmailSender emailSender = new CM_EmailSender();
      Database.executeBatch(emailSender);
   }
}