/*
Description:
class to calculate Loyalty points  for booking and customer specific 
class object must be created by using the parametrize constructor
 
@Created by: Sudeep Kumar Dube 
 @Created Date: 18/03/2015
 
 --------------------------------------------------------------------------------
 | Modified By      | Modified Date       | Version        | Description         |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------

*/


public class RMLoyaltyPoint {

    public Decimal Loyalty_Points_customer_specific {get;set;}
    public List < BookingSpecific > BookingSpecificLoyaties {get;set;}
    public BookingSpecific bs {get;set;}

    //default contrutor is empty intialize
    public RMLoyaltyPoint() {}

    //this is used creating the object ,this parameterize construcor
    //input : Pan NO which is primary co-applicant pan no field api name: Primary_PAN_number__c on account object 
    public RMLoyaltyPoint(String PAN_number) {
        //Fetching the record type id for booked account 
        id recordtypeid = 
            Schema.SObjectType.Account.getRecordTypeInfosByName().get('Booked Account').getRecordTypeId();
        //select all the booked aaccount of the passes Pan no.
        list < Account > accList = [select CRN__c, AccountSource
                    from Account
                    Where Primary_PAN_number__c = : PAN_number and RecordTypeId = : recordtypeid and Primary_PAN_number__c != null];
        //integer no_of_Additional_Booking = accList.size();

        //all the CRN mapped with the Account Source
        map < String, String > Map_of_CRN_Addition_Booking_with_Source = new Map < String, String > ();
        for (Account a: accList) {
            Map_of_CRN_Addition_Booking_with_Source.put(a.CRN__C, a.AccountSource);

        }

        //get booking list of the additional CRN...
        list < Booking_Details__c > booking_List = [select CRN__c, Consideration_Value__c, CV_paid_New__c
                        from Booking_Details__c
                        where CRN__C in : Map_of_CRN_Addition_Booking_with_Source.keyset()];
        Decimal sum_of_CV_self = 0.00;
        integer no_of_Additional_Booking = booking_List.size();

        for (Booking_Details__c bookd: booking_List) {
            if (bookd.Consideration_Value__c != null) {
                sum_of_CV_self = sum_of_CV_self + bookd.Consideration_Value__c;
            } else {
                //asign with 0.00 to cv beacause it will be use in below code of booking specific calculation
                bookd.Consideration_Value__c = 0.00;
            }
        }



        //customer specific loyalty point calculation..
        //formula that evaluate loyalty points ..
        Decimal loyalty_total_in_Contribution = 0.00;
        loyalty_total_in_Contribution = (no_of_Additional_Booking * 100) + 
                (sum_of_CV_self * 100 / 10000000);


        Loyalty_Points_customer_specific = (no_of_Additional_Booking * 100) + 
                (sum_of_CV_self * 100 / 10000000) + (1 * 50) + (1 * 50 / 10000000);

        Loyalty_Points_customer_specific = Loyalty_Points_customer_specific.setscale(2);

        //booking specific loyalty point calculation..
        BookingSpecificLoyaties = new List < BookingSpecific > ();
        Decimal booking_loyaltpnts = 0.00;
        for (Booking_Details__c bookd: booking_List) {
            bs = new BookingSpecific();
            bs.CRN = bookd.CRN__C;
            bs.CV = bookd.Consideration_Value__c;
            bs.percentage_cv_paid = bookd.CV_paid_New__c;
            //formula evaluate the loyalty point...
            booking_loyaltpnts = (1 * 100) + (bookd.Consideration_Value__c * 100 / 10000000);
            bs.loyalty_Contribution = (booking_loyaltpnts / loyalty_total_in_Contribution) * 100;
            bs.loyalty_Contribution = bs.loyalty_Contribution.setscale(2);
            bs.Source_booking = '';
            //CRN conatins in in map then the value should be updated to orignal value source booking 
            if (Map_of_CRN_Addition_Booking_with_Source.containsKey(bookd.CRN__C)) {
                bs.Source_booking = Map_of_CRN_Addition_Booking_with_Source.get(bookd.CRN__C);
            }
            BookingSpecificLoyaties.add(bs);

            booking_loyaltpnts = 0.00;
        }
    }

    //wrapper class for booked account specific loyalty detail view fields 
    public class BookingSpecific {
        public String CRN {get;set;} //Booking ID of Booking Detail Object  
        public Decimal CV {get;set;} //Cv on booking Details
        public Decimal percentage_cv_paid {get;set;} //CV_paid_New__c of booking Details
        //Contribution in total loyalty it is bookig Specific
        public Decimal loyalty_Contribution {get;set;} 
        public String Source_booking {get;set;} //this is field on Booked Account object 

    }


}