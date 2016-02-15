global class ScheduleCaseUpdateBatchClass implements Schedulable{
   global void execute(SchedulableContext sc) {
      CaseUpdateBatchClass CaseUpdateBatchClassObj = new CaseUpdateBatchClass(); 
      database.executebatch(CaseUpdateBatchClassObj);
   }
}