@isTest
private class testBookingDetailsController {    
    static testMethod void myUnitTest() {
    
        Profile p = [Select id from Profile where Name = 'Custom Overage High Volume Customer Portal'];
        User u = [Select id,accountid from User where ProfileId = :p.id AND IsActive = true LIMIT 1];
        system.debug('user details: '+u.id);
        system.debug('user acc: '+u.accountid);
     // System.runAs(u){
            BookingDetailsController BookingDetailsControllerobj = new BookingDetailsController();
            BookingDetailsControllerobj.autoAssignment();
            BookingDetailsControllerobj.gettotalDemandAmt();
            BookingDetailsControllerobj.gettotalAmtReceived();
            BookingDetailsControllerobj.gettotalBalnceDue();
            
            InterestCalculatorController InterestCalculatorControllerobj = new InterestCalculatorController ();
            InterestCalculatorControllerobj.getProxyObject();
            InterestCalculatorControllerobj.getInterestAmount();
            InterestCalculatorControllerobj.outstandingAmount = 1000000;
      //  }
    }
}