/*@Created by: Deepak Pudi 
     @Created Date:  4/3/2015 -->
 
 -- ------------------------------------------------------------------------------
 | Modified By      | Modified Date       | Version        | Description         |
 --------------------------------------------------------------------------------
 |Deepak Pudi           25/4/2015           1.0           Profile Information of all Customers
 --------------------------------------------------------------------------------
 |
 ------------------------------------------------------------------------------ --*/
public class ProfileInfoController {
    map < String, Account > AcountMap { get; set; }
    map < String, Decimal > CRN_map_with_Service_Index;
    map < String, Decimal > CRN_map_with_Loyaltypoint;
    public list < Wrapper > lstWrapper { get; set; }
	//Constructor
    public ProfileInfoController() {
        AcountMap = new map < String, Account > ();
        lstWrapper = new list < Wrapper > ();
        getmAccounts();
	}
    /*Gets all the records and adds it wrapper list*/
    public void getmAccounts() {
       for (Account acc: Database.query('Select a.CRN__c, a.Co_Applicant__c,a.Client_Type__c ,a.LoyaltyID__c, CIP__c ,a.Preferred_mode_of_Contact__c ,'
       									+'a.OwnerId ,a.Legal_Alert__c,a.Collection_Index__c, a.Ethinicity__c , a.Age__c , a.Marital_Status__c ,' +
       								    +'a.No_of_children__c ,a.DOB_of_Spouse__c ,a.Anniversary_Date__c,'
       								    +'a.Purpose_of_Purchase__c,(Select Consideration_Value__c from Booking_Details__r), a.Industry from Account a ')) {
           if (acc.CRN__c != null)
               AcountMap.put(acc.CRN__c, acc);
           
        }
        RMServiceIndex();
        RMloyaltypt();
        if (!AcountMap.isEmpty())
            for (String crn: AcountMap.keySet()) {
                system.debug('-----crn-----' + crn);
                Booking_Details__c listBookingDetails;
                if(AcountMap.get(crn).Booking_Details__r.size()>0 && AcountMap.get(crn).Booking_Details__r != null){
                    listBookingDetails = AcountMap.get(crn).Booking_Details__r[0];
                }
                
                wrapper objWrapper = new wrapper(crn, AcountMap.containsKey(crn) ? AcountMap.get(crn) : null, CRN_map_with_Service_Index.containsKey(crn) ? CRN_map_with_Service_Index.get(crn) : null, CRN_map_with_Loyaltypoint.containsKey(crn) ? CRN_map_with_Loyaltypoint.get(crn) : null, listBookingDetails);
                if(objWrapper.AcountMap.Client_Type__c=='NRI'){
                   objWrapper.IsNRI='true';
                   }else{
                   objWrapper.IsNRI='false';
                }
                lstWrapper.add(objWrapper);
                system.debug('@@lstWrapper@@' + lstWrapper);
            }
    }
   /*RM Service Index*/
    public void RMServiceIndex() {
        system.debug('this is service Index <<<<<<<<<<<<<<<<<<<<<<<<<<<<<');
        CRN_map_with_Service_Index = new map < String, Decimal > ();
        list < Account > accList = [select CRN__c, (Select Status, Nature_of_Request__c from cases where status!=null and Nature_of_Request__c!=null and Interaction_Mode__c!=null) from Account];
        list < BookinSpecificServiceParameter > service_parameter_BookingSpecific = new list < BookinSpecificServiceParameter > ();
        for (Account a: accList) {
            BookinSpecificServiceParameter bk = new BookinSpecificServiceParameter();
            bk.crn = a.CRN__C;
            bk.no_of_Compaints = 0;
            bk.no_of_Grievances = 0;
            bk.no_of_Cases = 0;
            bk.no_of_Closed_Unsatisfied_casesWithoutGrievanceComplaint = 0;
            bk.no_of_Closed_Unsatisfied_casesWithGrievanceComplaint = 0;
            bk.no_of_Closed_satisfied_casesWithoutGrievanceComplaint = 0;
            bk.no_of_Closed_satisfied_casesWithGrievanceComplaint = 0;
           
            for (
                case c:
                    a.cases) {
                bk.no_of_Cases = bk.no_of_Cases + 1;
                if (c.Nature_of_Request__c == 'Complaint') {
                    bk.no_of_Compaints = bk.no_of_Compaints + 1;
                }
                if (c.Nature_of_Request__c == 'Grievance') {
                    bk.no_of_Grievances = bk.no_of_Grievances + 1;
                }
                if (c.Status == 'Closed UnSatisfied') {
                    if (c.Nature_of_Request__c == 'Complaint' || c.Nature_of_Request__c == 'Grievance') {
                        bk.no_of_Closed_Unsatisfied_casesWithGrievanceComplaint = bk.no_of_Closed_Unsatisfied_casesWithGrievanceComplaint + 1;
                    } else {
                        bk.no_of_Closed_Unsatisfied_casesWithoutGrievanceComplaint = bk.no_of_Closed_Unsatisfied_casesWithoutGrievanceComplaint + 1;
                    }
                }
                if (c.Status == 'Closed Satisfied') {
                    if (c.Nature_of_Request__c == 'Complaint' || c.Nature_of_Request__c == 'Grievance') {
                        bk.no_of_Closed_satisfied_casesWithGrievanceComplaint = bk.no_of_Closed_satisfied_casesWithGrievanceComplaint + 1;
                    } else {
                        bk.no_of_Closed_satisfied_casesWithoutGrievanceComplaint = bk.no_of_Closed_satisfied_casesWithoutGrievanceComplaint + 1;
                    }
                }
            }
            service_parameter_BookingSpecific.add(bk);
        }
        Decimal no_of_Grievance_Complaints = 0;
        Decimal no_of_cases = 0;
        Decimal no_of_Closed_unsatisfied_casesWithoutGrievanceComplaints = 0;
        for (BookinSpecificServiceParameter bk: service_parameter_BookingSpecific) {
            system.debug(bk);
            no_of_cases = bk.no_of_Cases;
            no_of_Grievance_Complaints = bk.no_of_Compaints + bk.no_of_Grievances;
            no_of_Closed_unsatisfied_casesWithoutGrievanceComplaints = bk.no_of_Closed_Unsatisfied_casesWithoutGrievanceComplaint;
            Decimal Service_Index_at_Booking = 0.00;
            if (no_of_cases != 0) {
                Service_Index_at_Booking = 100 - (((no_of_Grievance_Complaints) / no_of_cases) * 100) - ((no_of_Closed_unsatisfied_casesWithoutGrievanceComplaints / no_of_cases) * 100);
            } else {
                Service_Index_at_Booking = 100.00;
            }
            Service_Index_at_Booking = Service_Index_at_Booking.setScale(2);
            CRN_map_with_Service_Index.put(bk.crn, Service_Index_at_Booking);
        }
    }
   /*RM Loyalty Points*/
    public void RMloyaltypt() {
    	system.debug('%%inside RM Loyalty%%');
		BookingSpecificLoyaltyPoints bs;
        CRN_map_with_Loyaltypoint = new map < String, Decimal > ();
        
        //get booking list of the additional CRN...
        list < Booking_Details__c > booking_List = [select CRN__c, Consideration_Value__c from Booking_Details__c where CRN__c!=null and Consideration_Value__c!=null ];
        List < BookingSpecificLoyaltyPoints > BookingSpecificLoyaties = new List < BookingSpecificLoyaltyPoints > ();
        Decimal booking_loyaltpnts = 0.00;
        for (Booking_Details__c bookd: booking_List) {
        
        	system.debug('*inside Forr Loop*');
            bs = new BookingSpecificLoyaltyPoints();
            bs.CRN = bookd.CRN__C;
            bs.CV = bookd.Consideration_Value__c;
          
            bs.loyalty_points = (1 * 100) + (bookd.Consideration_Value__c * 100 / 10000000) + (1 * 50) + (1 * 50 / 10000000);
            system.debug('&loyalty_points&'+ bs.loyalty_points);bs.loyalty_points=bs.loyalty_points.setScale(2);
            BookingSpecificLoyaties.add(bs);
            CRN_map_with_Loyaltypoint.put(bs.CRN, bs.loyalty_points);
        	
        }
        for (BookingSpecificLoyaltyPoints b: BookingSpecificLoyaties) {
            System.debug(b);
        }
	System.debug('exit%%%loyaltypoint');
	}
    public class Wrapper {
        public string crn{ get; set; }//public String BookingID {get; set;}
        public Account AcountMap { get; set; }
        public Decimal service_index { get; set; }
        public Decimal loyalty_points { get; set; }
        public string IsNRI{get;set;}
        public Booking_Details__c bookingDetails{get;set;}

        public Wrapper(string crn, Account AcountMap, Decimal ser_ind, Decimal loyaltypt, Booking_Details__c bookingDetails) {
            this.crn = crn;
            this.AcountMap = AcountMap;
            this.service_index = ser_ind;
            this.loyalty_points = loyaltypt;
            this.bookingDetails = bookingDetails;
        }

    }
   /*Method to export CSV*/
    public PageReference ExportToCSV() {
        PageReference PageRef = new PageReference('/apex/AdminReportProfileInfoExport');
        PageRef.setRedirect(false);
        return PageRef;
    }
    public class BookinSpecificServiceParameter {
        public string crn;
        public integer no_of_Compaints;
        public integer no_of_Grievances;
        public integer no_of_Cases;
        public integer no_of_Closed_Unsatisfied_casesWithoutGrievanceComplaint; //Except Grievance or Complaint
        public integer no_of_Closed_Unsatisfied_casesWithGrievanceComplaint; // incule only for  Grievance orComplaint
        public integer no_of_Closed_satisfied_casesWithoutGrievanceComplaint; //Except Grievance or Complaint
        public integer no_of_Closed_satisfied_casesWithGrievanceComplaint; // incule only for  Grievance orComplaint)
        public BookinSpecificServiceParameter() {}
    }
    public class BookingSpecificLoyaltyPoints {
        public String CRN { get; set; }//Booking ID of Booking Detail Object  
        public Decimal CV { get; set; } //Cv on booking Details
        public Decimal loyalty_points { get; set; } //Contribution in total loyalty it is bookig Specific
        public BookingSpecificLoyaltyPoints() {}
    }
}