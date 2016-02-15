trigger SOCreationEmailTriggers on Booking_Information__c (After Update) {
SOTrigger a=new SOTrigger();
a.mymethod(trigger.old,trigger.new);
SOTrigger b=new SOTrigger('dummy');
b.CancellationEmail(trigger.old,trigger.new);
}