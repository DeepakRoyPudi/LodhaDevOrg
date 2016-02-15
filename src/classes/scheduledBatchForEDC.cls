global class scheduledBatchForEDC implements Schedulable{
   global void execute(SchedulableContext sc) {
      BatchtocheckOppstatusEDC  edcbatch = new BatchtocheckOppstatusEDC(); 
      Database.executebatch(edcbatch);
   }
}