/***********************************************************************************
Name:  BookedAccountAndOpportunityTrigger 
Copyright © 2012  Lodha Group
===================================================================================
===================================================================================
Purpose:
-------
This trigger finds the right Opportunity record for the Booked account and Updates that to Booked Account. 
===================================================================================
===================================================================================
History
-------
VERSION    AUTHOR                DATE             DETAIL              
1.0        CG Dev Team           21/06/2012      INITIAL DEVELOPMENT
************************************************************************************/
trigger BookedAccountAndOpportunityTrigger on Booking_Details__c (after insert, after update) {

    try{
        if(!BookingDetailsTrgController.isTriggerExecuted()){
            BookingDetailsTrgController.TriggerExecuted();
            BookingDetailsTrgController TrgCtrlObj = new BookingDetailsTrgController();   
            List<Booking_Details__c> referralbookingDetailLst = new List<Booking_Details__c>();

            for(Booking_Details__c bookingDetails: Trigger.New)
            {
                if(bookingDetails.Referrer_Booking_Id__c != NULL && bookingDetails.Referrer_Loyalty_Id__c != NULL)
                    referralbookingDetailLst.add(bookingDetails);
            }
            
            //TrgCtrlObj.MapBookedAccountAndOpportunity(Trigger.New);
            TrgCtrlObj.MapBookedAccountAndOpportunity(referralbookingDetailLst);
        }
    }catch(Exception e){
        system.Debug('#Exception : '+e);
    }

}