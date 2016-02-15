/* 
Description : Controller for UpcomingDuePayments
 @Created by: Sneha P.
 @Created Date: 16-03-15
 
 --------------------------------------------------------------------------------
 | Modified By      | Modified Date       | Version        | Description         |
 --------------------------------------------------------------------------------
 |Shruti Nikam      | 26-03-15            | 1.0            |Created records      |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------

*/


public with sharing class UpcomingDuePaymentsRMController {

    //Get the CRN from 
    public String CustomerCRN {get;set;}

    public Integer NoOfRecords {get;set;}


    // object for payments web service 
    public RestAPICalloutPayment RestAPICalloutPayment_obj {get;set;}

    public UpcomingDuePaymentsRMController() {
  
    }
   
   public String getPreIntialize(){
         //CustomerCRN = RMLandingPageController.CRN;
        // initialisation of payments web service object 
        RestAPICalloutPayment_obj = new RestAPICalloutPayment(CustomerCRN);
      return '';
   }
    


}