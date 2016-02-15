/*
*    Description : "Booking Payment Transaction" Trigger Handler class
*
*    Version            Date            Author            Description
*
*    1.0                22/08/2014      Anupam Agrawal     Initial Draft
*/

public with sharing class BookingPaymentTransactionHandler { 
    BookingPaymentTransactionHelper objHelper = new BookingPaymentTransactionHelper();
	
	//On Before Insert tigger Handler Method
	public void onBeforeInsert(List<Booking_Payment_Transaction__c> lstNewBookingPaymentTransaction){
	    objHelper.avoidDuplicateUTR(lstNewBookingPaymentTransaction);
	    BookingPaymentTransactionHelper.setFirstRunFalse();
    }
	
	//On Before Update tigger Handler Method
    public void onBeforeUpdate(Map<Id, Booking_Payment_Transaction__c> mapNewIdToBookingPaymentTransaction, 
	                           Map<Id, Booking_Payment_Transaction__c> mapOldIdToBookingPaymentTransaction){
	    if(BookingPaymentTransactionHelper.isFirstRun() || Test.isRunningTest()){                      	
		    objHelper.avoidDuplicateUTR(mapNewIdToBookingPaymentTransaction, mapOldIdToBookingPaymentTransaction);
		    BookingPaymentTransactionHelper.setFirstRunFalse();
	    }
    }
}