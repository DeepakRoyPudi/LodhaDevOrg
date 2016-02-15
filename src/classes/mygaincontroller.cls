/* 
Description : Controller class for Mygain 
 @Created by: Shruti Nikam
 @Created Date: 5/5/2015
 
 --------------------------------------------------------------------------------
 | Modified By      | Modified Date       | Version        | Description         |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------

*/
public class mygaincontroller {
    public string mygainCRN { get;set;}

    // web service object to fetch data 
    public RestAPICalloutController RestAPICalloutController_obj;
    public RestAPICalloutController.CustomerInformationWrapper RestAPICallout_wrapper_obj  { get;set;}
    //for my gain data [both basic detail and complete details of mygain, these are are two list]
    public RestAPICalloutMygain rcMygain  {get;set;}

    // constructor 
    public mygaincontroller() {

        // fetch crn from URL
        mygainCRN = ApexPages.currentPage().getParameters().get('mygainCRN');

        // web service object initialisation 
        RestAPICalloutController_obj = new RestAPICalloutController();
        RestAPICallout_wrapper_obj = new RestAPICalloutController.CustomerInformationWrapper();
        RestAPICallout_wrapper_obj = RestAPICalloutController_obj.parseCustomerInformationJSON(mygainCRN);

        //if mygain availd
        if (RestAPICallout_wrapper_obj.my_gain_customer) {

            // mygain web service object initialisation          
            rcMygain = new RestAPICalloutMygain(mygainCRN);
        }
    }


}