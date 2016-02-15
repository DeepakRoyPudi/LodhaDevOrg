/* Version  			Created By   	 Created Date       Description
 *
 * 	Initial Draft		 Madan         26/02/2015       Controller for BookingPaymentsRMController 
 *
 */
@isTest
private class BookingPaymentsRMControllerTest {
   // Account with no payment
   
    static testMethod void BookingWithNoPmntTest() {
    	// Creating Account
		Account objAccount = BookingPaymentsRMControllerTest.createAccount();
		insert objAccount;
      
		Test.startTest();
			// initialising Controller
			BookingPaymentsRMController  objBookingPaymentsRMController = new BookingPaymentsRMController();
			objBookingPaymentsRMController.userCRN=objAccount.CRN__c;
			objBookingPaymentsRMController.noOfRecords=7;
			objBookingPaymentsRMController.bookingPmntTransList=Null;
		Test.stopTest();
		system.assertEquals(0,objBookingPaymentsRMController.bookingPmntTransList.size());
    }
    
    // Account with many payments
    static testMethod void BookingWithPmntTest() {
		// Creating Account
		Account objAccount = BookingPaymentsRMControllerTest.createAccount();
		insert objAccount;
		
		// Creating List of Booking_Payment_Transaction__c
		List<Booking_Payment_Transaction__c> lstBooking_Payment_Transaction = new List<Booking_Payment_Transaction__c>();
		for(Integer i = 0; i < 10; i++){
        	Booking_Payment_Transaction__c objBooking_Payment_Transaction = new Booking_Payment_Transaction__c();
        	objBooking_Payment_Transaction.Account_Name__c = objAccount.Id; 
        	objBooking_Payment_Transaction.Type_of_Transaction_del__c='RTGS';
			objBooking_Payment_Transaction.UTR_Code__c='12345612341574124';
			lstBooking_Payment_Transaction.add(objBooking_Payment_Transaction);
		}
        insert lstBooking_Payment_Transaction;
		Test.startTest();
      		// initialising Controller
			BookingPaymentsRMController  objBookingPaymentsRMController = new BookingPaymentsRMController();
			objBookingPaymentsRMController.userCRN=objAccount.CRN__c;
			objBookingPaymentsRMController.noOfRecords=7;
			objBookingPaymentsRMController.bookingPmntTransList=lstBooking_Payment_Transaction;
			System.assertEquals(10,objBookingPaymentsRMController.bookingPmntTransList.size());
		Test.stopTest();
	}
    
	private static Account createAccount(){
        Account objAccount = new Account();
        objAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        objAccount.FirstName='Test1';
        objAccount.LastName='Account1';
        objAccount.CRN__c='154215';
        objAccount.H_Mobile_No__c='1234560789';
        objAccount.Mobile_Phone__c='21241222';
        objAccount.Co_Applicant__c='test';
        return objAccount;
	} 
}