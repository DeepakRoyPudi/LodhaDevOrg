/***********************************************************************************
Name:  LoyaltyMgmtOnDemandTrg
Copyright © 2012  Lodha Group
===================================================================================
===================================================================================
Purpose:
-------
Loyalty mgmt triger help to allocate points while making 9.9% of booking payments  
===================================================================================
===================================================================================
History
-------
VERSION    AUTHOR                DATE             DETAIL              
1.0        CG Dev Team           25/07/2012      INITIAL DEVELOPMENT
************************************************************************************/
trigger LoyaltyMgmtOnDemandTrg on Demands__c (after insert, after update) {
    try{
        Set<Id> bookingIds = new Set<Id>();
        for(Demands__c demand : Trigger.new){
            bookingIds.add(demand.Flat_ID__c);
        }
        if(!bookingIds.isEmpty()){
            List<Booking_Details__c> BookingDetailsList = new List<Booking_Details__c>();
            BookingDetailsList = [Select CRN__c, Referrer_Booking_Id__c, Cluster__c From Booking_Details__c Where Id=:bookingIds AND Referrer_Booking_Id__c != NULL AND Referrer_Loyalty_Id__c != NULL];
            if(!BookingDetailsList.isEmpty()){
                BookingDetailsTrgController TrgCtrlObj = new BookingDetailsTrgController();    
                TrgCtrlObj.MapBookedAccountAndOpportunity(BookingDetailsList);        
            }
            system.debug(' booking ids ' + bookingIds + ' Booking Details List'  + BookingDetailsList);

        }
    }catch(Exception e){
        system.Debug('#Exception : '+e);
    }    

}