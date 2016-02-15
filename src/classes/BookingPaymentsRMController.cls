/* Version  			Created By   	 Created Date       Description
 *
 * 	Initial Draft		Sneha P.         26//02/2015       Controller for BookingPaymentsRM Component
 *
 */
 public with sharing class BookingPaymentsRMController {
    //Get the CRN from attribute
    
    public String userCRN       {get; set;}
    public Integer noOfRecords    {get; set;}   //Get the No. or records to display from attribute of component
    
    private static final String BPTObjName = 'Booking_Payment_Transaction__c';
    
    
     public list<Booking_Payment_Transaction__c> bookingPmntTransList {
        set;
        get{ 
            if(bookingPmntTransList == null){
                bookingPmntTransList = CreateQueryHelper.getRecords(BPTObjName,'Id','where CRN__c =\''+userCRN+'\'',
                                CreateQueryHelper.BookingPaymnetsTransCrispRM, 
                                     'order by CreatedDate DESC','LIMIT '+noOfRecords); 
            }              
            return bookingPmntTransList ;
        }
    } 
    
	//Constructor
    public BookingPaymentsRMController() {}
  
}