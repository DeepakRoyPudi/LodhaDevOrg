global class ScheduleBatchNotificationEmail implements Schedulable{
   global void execute(SchedulableContext sc) {
      SPbatchSendNotificationEmail BatchSendNotification = new SPbatchSendNotificationEmail (); 
      database.executebatch(BatchSendNotification );
   }
}