/* Class for Payment Information Detail View 
   @Created by: Trupti Dhoka
   @Created Date: 07/01/2015
   
   -------------------------------------------------------------------------------------
   | Modified By      | Modified Date       | Version        | Description         |
   -------------------------------------------------------------------------------------
   |Trupti Dhoka       18/03/2015                1.1            Initial Draft
   --------------------------------------------------------------------------------------
   
*/

//To be confirmed with vimal & pankhil

public class PaymentDemandDetailsCSS2_0 {

    //Get logged in customer's CRN
    public static String Cust_CRN   {get;set;}
    public String userId;
   
    
    
    //Constructor
    public PaymentDemandDetailsCSS2_0()
    {
        init();
    }
    
    public void init(){
        try
        {
           userId=Userinfo.getUserid();
           Cust_CRN= CreateQueryHelper.getCustomerCRN(userId);
        }
        catch(Exception e)
        {
            system.debug(e);
        }
    }
}