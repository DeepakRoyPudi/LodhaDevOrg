trigger CalculateOpportunityEDC on Call_Attempts__c (after insert,after update) {

 EDCCalculationController edccontroller=new EDCCalculationController();
    if(trigger.Isafter && trigger.Isinsert){
                   
        edccontroller.CalculateEDCaftercallattemptinsert(trigger.new);
    }
    if(trigger.Isafter && trigger.IsUpdate){
     edccontroller.CalculateEDCaftercallattemptinsert(trigger.new);
    }

}