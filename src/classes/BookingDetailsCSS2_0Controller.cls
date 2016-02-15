/* 
Description:
Controller class for visusalforce page BookingDetailsCSS2_0
@Created by: Aditi Mulmule
@Created Date: 16/03/2015

--------------------------------------------------------------------------------
| Modified By      | Modified Date       | Version        | Description         |
--------------------------------------------------------------------------------
|Aditi Mulmule       16/03/2015           Initial Draft    Booking details of 
Logged In user
--------------------------------------------------------------------------------

*/
public class BookingDetailsCSS2_0Controller {
    
    public list<Booking_Details__c> lstBooking_detailView {get;set;} //list of Booking_Details__c   
    public String cust_parking {get; set;} //variable to store Parking Details
    public string CRN {get; set;} //store CRN no of logged in user
    // Start of Google Analytics variables - Trupti Dhoka
    public static String username{get;set;}
    public static String userProject{get;set;}
    public static String userSeqment{get;set;}
    public static DateTime userLastLogin {get;set;}
    // End of Google Analytics variables Trupti Dhoka
    public boolean isProjectWise {get;  set;}
    // used to check whether isProjectWise is Selected in CSSBackgroundImageSetting__c Custom setting
    
    public string imageUrl {get;  set;} // variable to store Backgground Image url
    
    public string projectLocation {get;set;}
    // Load the booking Information from Booking_Details__c and Booking_Information__c
    
    private static final String pipe = ' | ';
    private static final String open_parking ='OP - ';
    private static final String stilt_parking ='S - ';
    private static final String mlcp_parking ='M - ';
    private static final String closed_parking ='C - ';
    private static final String other_parking ='OT - ';
    
    public BookingDetailsCSS2_0Controller()
    {
        initialMethod();
    }
    
    public void initialMethod() {
        
        lstBooking_detailView = new list<Booking_Details__c>();
        String userId=Userinfo.getUserid();  
        CRN = CreateQueryHelper.getCustomerCRN(userId);
        projectLocation = '';
        if(String.isNotBlank(CRN)) {
            lstBooking_detailView = [Select Id,CRN__c,Project__c,CLuster__c,Consideration_Value__c,
                                     Flat_ID__c,Flat_No__c,Flat_Type__c,Wing__c,Allotment_Date__c,
                                     Application_Date__c,Account__c,
                                     Account__r.Name,Co_Applicant__c
                                     from Booking_Details__c 
                                     where CRN__c =:CRN 
                                     limit 1]; 
              
            if(lstBooking_detailView .size()>0 && lstBooking_detailView[0].Project__c!=null) {
                
                list <Project_Name__c> ObjProject = new  list <Project_Name__c>();
                ObjProject = [Select Location__c
                              From Project_Name__c
                              where Name=:lstBooking_detailView[0].Project__c
                              limit 1];
                if(ObjProject.size()>0) {
                    projectLocation = ObjProject[0].Location__c;
                }
                
            }
            
            
         /*   List<Booking_Information__c> bookinginformationLst = [Select Id,
                                                                  CRN_Number_SAP__c, 
                                                                  Stilt_Parkings__c,
                                                                  Other_Parkings__c,
                                                                  Open_Parkings__c,
                                                                  MLCP_Parkings__c,
                                                                  Closed_Parkings__c
                                                                  From Booking_Information__c 
                                                                  where CRN_Number_SAP__c=:CRN 
                                                                  limit 1];          
            
            if(bookinginformationLst.size()>0) {
                Booking_Information__c bookinginformation_obj = new Booking_Information__c();
                bookinginformation_obj = bookinginformationLst[0];
                cust_parking = '';  
                //logic to show parking details in OP - value | S - value | M - value | C - value 
| OT - value format //
                if(bookinginformation_obj.Open_Parkings__c!=null || 
                   bookinginformation_obj.Stilt_Parkings__c!=null || 
                   bookinginformation_obj.Other_Parkings__c!=null ||
                   bookinginformation_obj.MLCP_Parkings__c!=null ||
                   bookinginformation_obj.Closed_Parkings__c!=null) {
                       
                       if(bookinginformation_obj.Open_Parkings__c!=null) {
                           cust_parking+= parkingInfo(open_parking,bookinginformation_obj.Open_Parkings__c);
                       }
                       if(bookinginformation_obj.Stilt_Parkings__c!=null) {
                           cust_parking+= parkingInfo(stilt_parking,bookinginformation_obj.Stilt_Parkings__c);
                       }
                       
                       if(bookinginformation_obj.MLCP_Parkings__c!=null) {
                           cust_parking+= parkingInfo(mlcp_parking,bookinginformation_obj.MLCP_Parkings__c);
                       }
                       if(bookinginformation_obj.Closed_Parkings__c!=null) {
                           cust_parking+= parkingInfo(closed_parking,bookinginformation_obj.Closed_Parkings__c);
                       }
                       
                       if(bookinginformation_obj.Other_Parkings__c!=null) {
                           cust_parking+= parkingInfo(other_parking,bookinginformation_obj.Other_Parkings__c);
                       } 
                   }
                else {
                    cust_parking = 'NA';
                }
                //remove last | from string
                if (cust_parking.length() > 0 && cust_parking.endsWith('| ')) {
                    cust_parking = cust_parking.substring(0, cust_parking.length()-2);
                }
            }    
            /* Google Analytics*/
            
            GoogleAnalyticsHelper.GetReportParameters(userId); 
            username = GoogleAnalyticsHelper.username;
            userProject =GoogleAnalyticsHelper.userProject;
            userSeqment = GoogleAnalyticsHelper.userSeqment;   
            userLastLogin= GoogleAnalyticsHelper.userLastLogin;   
            this.checkBackgroundImage();
            
        }
        else
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.CRNvalueNull));
        }
       
    }
 /*   public String parkingInfo(String parking_type, Decimal parkingValue) {
        String customerParking;
        customerParking = parking_type + parkingValue + pipe;
        return customerParking;
    }*/
    /* Function to determine if the Background image will be displayed project wise 
* or the Default image will be displayed. */
    
    public void checkBackgroundImage() {
        BackgroundImageHelper.populateBackgroundImgParam(CRN);
        isProjectWise = BackgroundImageHelper.isProjectWise;
        imageUrl = BackgroundImageHelper.imageUrl;
    } 
    
    
}