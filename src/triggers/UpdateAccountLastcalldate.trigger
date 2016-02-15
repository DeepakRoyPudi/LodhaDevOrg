trigger UpdateAccountLastcalldate on Call_Attempts__c (after insert,after update) {

    AccountCallDate acd=new AccountCallDate();
    
    if(Trigger.Isafter && Trigger.IsInsert){
        acd.Updatelastcalldate(Trigger.new);
    }
     
    if(Trigger.Isafter && Trigger.IsUpdate){
        acd.Updatelastcalldate(Trigger.new);
    }


}