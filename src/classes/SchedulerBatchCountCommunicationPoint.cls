global class SchedulerBatchCountCommunicationPoint implements Schedulable {
	
    global void execute(SchedulableContext sc) {
    	
        BatchCountCommunicationPoint objBatch = new BatchCountCommunicationPoint(); 
        database.executebatch(objBatch);
    }
}