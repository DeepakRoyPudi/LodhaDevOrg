/*
Description:
class to calculate Service Index for booking and customer specific 
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

public class RMServiceIndex {
    public static final String str_Complaint='Complaint';
    public static final String str_Grievance='Grievance';
    public static final String str_ClosedSatisfied='Closed Satisfied';
    public static final String str_ClosedUnSatisfied='Closed UnSatisfied';
    public static final String str_Call='Call';
    public static final String str_Email='Email';
     
    public Decimal service_index_CustomerSpecific {get;set;}
    public list < BookingSpecificServiceIndex > service_index_BookingSpecific {get;set;}
    public BookingSpecificServiceIndex bk {get;set;}

    //default contrutor is empty intialize
    public RMServiceIndex() {}

    //this is used creating the object ,this parameterize construcor
    //input : Pan NO which is primary co-applicant pan no field api name: Primary_PAN_number__c on account object 
    public RMServiceIndex(String PAN_number) {
        //Fetching the record type id for booked account 
         id recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Booked Account').getRecordTypeId();

        //select all the booked aaccount of the passes Pan no.
        list < Account > accList = [select CRN__c, (Select Status, Nature_of_Request__c, 
                Interaction_Mode__c 
                from cases where status!=null 
                and Nature_of_Request__c!=null 
                and Interaction_Mode__c!=null  ) 
                from Account Where Primary_PAN_number__c = : PAN_number and RecordTypeId =: recordtypeid and Primary_PAN_number__c != null];

        service_index_BookingSpecific = new list < BookingSpecificServiceIndex > ();

        //for each booked account calculate the service index parameters.
        for (Account a: accList) {

            //intialize the booking specific service index parameters with default values
            bk = new BookingSpecificServiceIndex();
            bk.BookingID = a.CRN__C;
            bk.no_of_Compaints = 0;
            bk.no_of_Grievances = 0;
            bk.no_of_Cases = 0;
            bk.no_of_Closed_Unsatisfied_casesWithoutGrievanceComplaint = 0;
            bk.no_of_Closed_Unsatisfied_casesWithGrievanceComplaint = 0;
            bk.no_of_Closed_satisfied_casesWithoutGrievanceComplaint = 0;
            bk.no_of_Closed_satisfied_casesWithGrievanceComplaint = 0;
            bk.no_of_call_recieved = 0;
            bk.no_of_Email_recieved = 0;

            //Customer specific calculation for the servoce index 
            //for each case calculte the booking nspecific parameter evaluated based on cases related to booked account
            for (case c:a.cases) {

                bk.no_of_Cases = bk.no_of_Cases + 1;
                String str_nature_request=String.valueOf(c.Nature_of_Request__c);
                String str_status=String.valueOf(c.Status);
                String str_inter_mode=String.valueOf(c.Interaction_Mode__c);
               
                if (str_nature_request.equalsIgnoreCase(RMServiceIndex.str_Complaint)) {
                    bk.no_of_Compaints = bk.no_of_Compaints + 1;
                }

                if (str_nature_request.equalsIgnoreCase(RMServiceIndex.str_Grievance)) {
                    bk.no_of_Grievances = bk.no_of_Grievances + 1;
                }
                
                if (str_status.equals(RMServiceIndex.str_ClosedUnSatisfied)) {
                    if (str_nature_request.equals(RMServiceIndex.str_Complaint) || 
                        str_nature_request.equals(RMServiceIndex.str_Grievance)) {
                        bk.no_of_Closed_Unsatisfied_casesWithGrievanceComplaint = 
                            bk.no_of_Closed_Unsatisfied_casesWithGrievanceComplaint + 1;
                    } else {
                        bk.no_of_Closed_Unsatisfied_casesWithoutGrievanceComplaint = 
                        bk.no_of_Closed_Unsatisfied_casesWithoutGrievanceComplaint + 1;
                    }
                }

                if (str_status.equals(RMServiceIndex.str_ClosedSatisfied)) {
                    if (str_nature_request.equals(RMServiceIndex.str_Complaint) || 
                        str_nature_request.equals(RMServiceIndex.str_Grievance)) {
                            
                        bk.no_of_Closed_satisfied_casesWithGrievanceComplaint = 
                            bk.no_of_Closed_satisfied_casesWithGrievanceComplaint + 1;
                    } else {
                        bk.no_of_Closed_satisfied_casesWithoutGrievanceComplaint = 
                            bk.no_of_Closed_satisfied_casesWithoutGrievanceComplaint + 1;
                    }
                }

                if (str_inter_mode.equals(RMServiceIndex.str_Call)) {
                    bk.no_of_call_recieved = bk.no_of_call_recieved + 1;
                }
                if (str_inter_mode.equals(RMServiceIndex.str_Email)) {
                    bk.no_of_Email_recieved = bk.no_of_Email_recieved + 1;
                }

            }
            service_index_BookingSpecific.add(bk);
        }


        //Customer specific calculation for the servoce index 
        //it is calculated based on all the account of the customer and the cases of relted account 
        //which is stored in service_index_booking_specific
        Decimal total_no_of_Grievance_Complaints = 0;
        Decimal total_no_of_cases = 0;
        Decimal total_no_of_Closed_unsatisfied_casesWithoutGrievanceComplaints = 0;
        for (BookingSpecificServiceIndex bk: service_index_BookingSpecific) {
           
            total_no_of_cases = total_no_of_cases + bk.no_of_Cases;
            total_no_of_Grievance_Complaints = total_no_of_Grievance_Complaints + 
                bk.no_of_Compaints + bk.no_of_Grievances;
                
            total_no_of_Closed_unsatisfied_casesWithoutGrievanceComplaints = 
                total_no_of_Closed_unsatisfied_casesWithoutGrievanceComplaints + 
                bk.no_of_Closed_Unsatisfied_casesWithoutGrievanceComplaint;
        }
        service_index_CustomerSpecific = 0.00;
        //if the any cases exist in of the customer for any 
        //biiking then formula will be used to calculate the service index 
        //other wise service index is 100.00
        if (total_no_of_cases != 0) {

            //this below formula used for service index at customer specific..
            service_index_CustomerSpecific = 100 - 
                (((total_no_of_Grievance_Complaints) / total_no_of_cases) * 100) - 
                ((total_no_of_Closed_unsatisfied_casesWithoutGrievanceComplaints / total_no_of_cases) 
                * 100);

        } else {
            service_index_CustomerSpecific = 100.00;
        }
          
       service_index_CustomerSpecific=service_index_CustomerSpecific.setScale(2);   
    } //end of contructor 


    //Wrapper class for the Booked accountService index 
    public class BookingSpecificServiceIndex {
        public String BookingID {get;set;}
        public integer no_of_Compaints {get;set;}
        public integer no_of_Grievances {get;set;}
        public integer no_of_Cases {get;set;}
        //Except Grievance or Complaint
        public integer no_of_Closed_Unsatisfied_casesWithoutGrievanceComplaint {get;set;} 
        // include only for  Grievance orComplaint
        public integer no_of_Closed_Unsatisfied_casesWithGrievanceComplaint {get;set;} 
         //Except Grievance or Complaint
        public integer no_of_Closed_satisfied_casesWithoutGrievanceComplaint {get;set;}
        // incule only for  Grievance orComplaint)
        public integer no_of_Closed_satisfied_casesWithGrievanceComplaint {get;set;} 
        public integer no_of_call_recieved {get;set;}
        public integer no_of_Email_recieved {get;set;}
    }

}