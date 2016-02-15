/*
Description:
class to calculate Segment Indicator for RM Landing page by
used in Rmlanding Page Controller by creating object 
The object must be created by parametrized constructor
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


public class RMSegmentIndicator {

    public String CurrentBookingSegment {get;set;}
    public List < BookingSpecificSegmentIndicator > booking_Segments {get;set;}
    public String isNri {get;set;}
    public RMSegmentIndicator() {}

    //pan no ,CRN of current booking and isNRI from web service response
    public RMSegmentIndicator(String PAN_number, String CRNSTR, String isNRI) {
        //CurrentBookingSegment=segment;
        this.isNri = isNRI;

        set < string > CRNSet = new set < string > ();
        
        //Fetching the record type id for booked account 
        id recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Booked Account').getRecordTypeId();

        list < Account > accList = [select id, CRN__c 
                                    from Account 
                                    Where Primary_PAN_number__c = : PAN_number 
                                    and RecordTypeId =: recordtypeid and Primary_PAN_number__c != null];
      
        for (Account a: accList) {
            if(String.isNOtBlank(a.CRN__c)){
            CRNSet.add(a.CRN__c);
            }
         
        }

        list < Booking_Details__c > BookingDetails = [select CRN__c, Consideration_Value__c, Project__c 
                                                     from Booking_Details__c 
                                                     where CRN__C in : CRNSet];
   
        set < String > Projectset = new set < String > ();

        for (Booking_Details__c bookd: BookingDetails) {
            
            if(string.isNotBlank(bookd.Project__c)){
            Projectset.add(bookd.Project__c);
            }
           
        }

        Map < String, Project_Name__c > mapprojectidtoProject = new map < String, Project_Name__c >();
        
        List<Project_name__c>  project_list=[select id,name, Project_Type__c from Project_Name__c 
                                                    where name in : Projectset];
                                                    
        for(Project_name__c pobj:project_list){
           if(String.isNotBlank(pobj.name)){
            mapprojectidtoProject.put(pobj.name.toUpperCase(),pobj);
            }
        }                                                  
       
        /*
        initialize with emoty value to current booking segment because below code we check for its 
        value if not found then it remain empty,that prevent us from null error.
        */
        CurrentBookingSegment=''; 
        booking_Segments = new List < BookingSpecificSegmentIndicator > ();
        for (Booking_Details__c bookd: BookingDetails) {
            BookingSpecificSegmentIndicator bk = new BookingSpecificSegmentIndicator();
            
            //check null and assignmnet 
            
            bk.BookingCRN = bookd.CRN__c; 
            bk.CV = bookd.Consideration_Value__c; 
            bk.segment ='';
            if(String.isNotBlank(bookd.Project__c)){
            if(mapprojectidtoProject.containsKey(bookd.Project__c.toUpperCase())){
                if(!String.isBlank(mapprojectidtoProject.get(bookd.Project__c.toUpperCase()).Project_Type__c)){
            
                 bk.segment = mapprojectidtoProject.get(bookd.Project__c.toUpperCase()).Project_Type__c;
                }
                else{
                   bk.segment ='';
                }
             }
             else{
                 bk.segment ='';
             }   
            //it denote CRNSTR for current booking crn 
             if(!String.isBlank(CRNSTR)){              
                    if (CRNSTR.equalsIgnoreCase( (String)bookd.CRN__c)) {
                       
                       if(mapprojectidtoProject.containsKey(bookd.Project__c.toUpperCase())){
                        CurrentBookingSegment = mapprojectidtoProject.get(bookd.Project__c.toUpperCase()).Project_Type__c;
                        }
                        else{
                            CurrentBookingSegment ='';
                        }
                    }
             }
            }        
           booking_Segments.add(bk);
        }
        

    }
    public class BookingSpecificSegmentIndicator {
        public String BookingCRN {get;set;}
        public Decimal CV {get;set;}
        public String segment {get;set;}

    }
}