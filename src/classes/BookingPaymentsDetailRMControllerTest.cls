/* Version  			Created By   	 Created Date       Description
 *
 * 	Initial Draft		 Madan         18/04/2015       		Test Class for 
 *														BookingPaymentsDetailRMController
 *
 */
@isTest
private class BookingPaymentsDetailRMControllerTest {

   static testMethod void bookingPaymentsDetailRMTestWithPayment(){
        // insert Account
        Account objAccount = BookingPaymentsDetailRMControllerTest.createAccount();
        insert objAccount;
        
        ApexPages.CurrentPage().getparameters().put('CRN',objAccount.CRN__c);
        
        
        list<Booking_Payment_Transaction__c> bookingPaymentTransList = createBookingPaymentTrans(objAccount.Id);
        
        PageReference Pageref=Page.BookingPaymentsDetailRM;
        System.test.setCurrentPageReference(Pageref);
        
        BookingPaymentsDetailRMController objBookingPaymentsDetailRMController = new BookingPaymentsDetailRMController();
        
        Test.startTest();
        
        //Check if 10 records are displayed o First Page 
        system.assertEquals(10,objBookingPaymentsDetailRMController.BookingPaymentTransList.size()); 
        
        objBookingPaymentsDetailRMController.next();
        System.assertEquals(10,objBookingPaymentsDetailRMController.OffsetSize);
        
        objBookingPaymentsDetailRMController.FirstPage();
        System.assertEquals(0,objBookingPaymentsDetailRMController.OffsetSize);
        
        System.assertEquals(true,objBookingPaymentsDetailRMController.getnxt());
        objBookingPaymentsDetailRMController.next();
        
        system.assertEquals(false,objBookingPaymentsDetailRMController.getprev());
        objBookingPaymentsDetailRMController.previous();
        System.assertEquals(0,objBookingPaymentsDetailRMController.OffsetSize);
        
        objBookingPaymentsDetailRMController.toggleSortBPT();
        system.assertEquals(10,objBookingPaymentsDetailRMController.BookingPaymentTransList.size()); 
        
        objBookingPaymentsDetailRMController.LastPage();
        
        objBookingPaymentsDetailRMController.utr.UTR_Code__c = '12345612341';
        objBookingPaymentsDetailRMController.utr.Transaction_Date__c = system.today();
        objBookingPaymentsDetailRMController.searchUtr();
        system.assertEquals(10,objBookingPaymentsDetailRMController.BookingPaymentTransList.size()); 
        
        Test.stopTest();
    }
    
    private static List<Booking_Payment_Transaction__c> createBookingPaymentTrans(Id accId) {
		list<Booking_Payment_Transaction__c> bookingPaymentTransList = new list<Booking_Payment_Transaction__c>();
        for(Integer i = 0; i < 11; i++){
			Booking_Payment_Transaction__c objBooking_Payment_Transaction = 
						new Booking_Payment_Transaction__c(Account_Name__c = accId, 
              											   Type_of_Transaction_del__c='RTGS',
              											   Status__c='Pending',
              											   UTR_Code__c='12345612341574124');
        	bookingPaymentTransList.add(objBooking_Payment_Transaction);
		}
		insert bookingPaymentTransList; 
		return bookingPaymentTransList;	
    }
    
    private static Account createAccount(){
        Account objAccount = new Account();
        objAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        objAccount.FirstName='Test1 ';
        objAccount.LastName='Account1';
        objAccount.CRN__c='154215';
        objAccount.H_Mobile_No__c='1234560789';
        objAccount.Mobile_Phone__c='21241222';
        objAccount.Co_Applicant__c='test';
        return objAccount;
      }  
      
}