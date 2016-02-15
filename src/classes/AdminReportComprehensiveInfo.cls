/*@Created by: Deepak Pudi 
     @Created Date:   5/3/2015 -->
 
 -- ------------------------------------------------------------------------------
 | Modified By      | Modified Date       | Version        | Description         |
 --------------------------------------------------------------------------------
 |Deepak Pudi           25/4/2015            1.0           ComphrensiveInformation  of all Customers
 --------------------------------------------------------------------------------
 |
 ------------------------------------------------------------------------------ --*/

public with sharing class AdminReportComprehensiveInfo {
    map < String, Account > MapAccount {get;set;}
    map < string, Booking_Details__c > MapBooking{get;set;}
    map < String, ServiceIndexWrapper> CRN_map_with_Service_Index;
    map < String, Decimal > CRN_map_with_Loyaltypoint;
    map < String, boolean > CRN_map_with_LegalAlert;
   	public integer caseNumber;
    public integer grievanceCount;
    public integer complaintCount;
    public String queryString;
    public list < Wrapper > lstWrapper {get;set;}

    
    //Constructor
    public AdminReportComprehensiveInfo() {
        lstWrapper = new list < Wrapper > ();
         getLstWraprecords();
    }

   //Getting all the records into Wrapper List
    public void getLstWraprecords() {
       mapAccount = new map < String, Account > ();
       for (Account acc: Database.query('Select id,CRN__c, Co_Applicant__c ,LoyaltyID__c,Legal_Alert__c,Collection_Index__c, CIP__c ,'+
       											' Preferred_mode_of_Contact__c ,Owner.name,Client_Type__c , Ethinicity__c , Age__c , Marital_Status__c ,' +
                								+'No_of_children__c ,Project_Name__c, Purpose_of_Purchase__c , Industry from Account Order by CRN__c')) {
            if (acc.CRN__c != null)
                MapAccount.put(acc.CRN__c, acc);
		}
        
        MapBooking = new map < string, Booking_Details__c > ();
        for (Booking_Details__c bookings: Database.query('select id,Account__r.CRN__c, Consideration_Value__c , CV_paid__c , Project__c,Project_Name__c  from Booking_Details__c ')) {
            if (bookings.Account__r.CRN__c != null)
                MapBooking.put(bookings.Account__r.CRN__c, bookings);

            system.debug('@@MapBooking@@' + MapBooking);
        }
        this.RMServiceIndex();
        this.RMloyaltypt();
        for (String crn: MapAccount.keySet()) {
       		Wrapper w=new Wrapper();
            w.crn=crn;    
            w.MapAccount=MapAccount.get(crn);
            w.MapBooking= MapBooking.containsKey(crn) ? MapBooking.get(crn) : null;
           	w.service_index =CRN_map_with_Service_Index.containsKey(crn) ? CRN_map_with_Service_Index.get(crn).service_index: null;
            w.no_of_cases=CRN_map_with_Service_Index.containsKey(crn) ? CRN_map_with_Service_Index.get(crn).no_of_cases: null;
            w.no_of_complaints=CRN_map_with_Service_Index.containsKey(crn) ? CRN_map_with_Service_Index.get(crn).no_of_complaints: null;
            w.no_of_grivances=CRN_map_with_Service_Index.containsKey(crn) ? CRN_map_with_Service_Index.get(crn).no_of_grievances: null;
            w.loyalty_points =CRN_map_with_Loyaltypoint.containsKey(crn) ? CRN_map_with_Loyaltypoint.get(crn) : null;
     			if(w.MapAccount.Client_Type__c=='NRI'){
           			w.IsNRI='true';
           		}else{
           			w.IsNRI='false';
           			}
           lstWrapper.add(w);
        }
	}

    //Rm Service Index
    public void RMServiceIndex() {
		CRN_map_with_Service_Index = new map < String, ServiceIndexWrapper> ();
		list < Account > accList = [select CRN__c, (Select Status, Nature_of_Request__c from cases) from Account];
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
            //this is remaining to assign values

            // end of remaning 
            for(case c:a.cases) {
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
            ServiceIndexWrapper siw=new ServiceIndexWrapper();
            siw.CRN=bk.crn;
            siw.no_of_cases=bk.no_of_Cases;
            siw.no_of_complaints=bk.no_of_Compaints;
            siw.no_of_grievances=bk.no_of_Grievances;
            siw.service_index=Service_Index_at_Booking;
            CRN_map_with_Service_Index.put(bk.crn, siw);
        }
	}
   public class ServiceIndexWrapper{
   public string CRN=null;
   public integer no_of_cases=0;
   public integer no_of_complaints=0;
   public integer no_of_grievances=0;
   public Decimal service_index=0.00;
   public ServiceIndexWrapper(){}
   }

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
            system.debug('&loyalty_points&'+ bs.loyalty_points);
            bs.loyalty_points=bs.loyalty_points.setScale(2);
            BookingSpecificLoyaties.add(bs);
            CRN_map_with_Loyaltypoint.put(bs.CRN, bs.loyalty_points);
        	
        }
        for (BookingSpecificLoyaltyPoints b: BookingSpecificLoyaties) {
            System.debug(b);
        }
	System.debug('exit%%%loyaltypoint');
	}
    public class Wrapper {
        public string crn {get;set;}
        public Account MapAccount{get;set;}
        public Booking_Details__c MapBooking {get;set;}
        public Decimal service_index {get;set;}
        public Decimal loyalty_points {get;set;}
        public integer no_of_cases{get;set;}
        public integer no_of_complaints{get;set;}
        public integer no_of_grivances{get;set;}
        public string IsNRI{get;set;}
        public wrapper(string crn, Account MapAccount, Booking_Details__c MapBooking, Decimal ser_ind, Decimal loyaltypt) {}
		public Wrapper() {}
    }
    public PageReference ExportToCSV() {
        PageReference PageRef = page.AdminReportComprehensiveInfoExport;
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
        public String CRN {get;set;} //Booking ID of Booking Detail Object  
        public Decimal CV {get;set;} //Cv on booking Details
        public Decimal loyalty_points{get;set;}
        public BookingSpecificLoyaltyPoints() {}

    }

}