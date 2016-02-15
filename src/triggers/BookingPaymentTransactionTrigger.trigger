trigger BookingPaymentTransactionTrigger on Booking_Payment_Transaction__c (before insert, before update){
    BookingPaymentTransactionHandler handler = new BookingPaymentTransactionHandler();
    
    if(trigger.isBefore){
        if(trigger.isInsert){
            handler.onBeforeInsert(trigger.new);
        }
        else if(trigger.isUpdate){
            handler.onBeforeUpdate(trigger.newMap, trigger.oldMap);
        }
    }
}