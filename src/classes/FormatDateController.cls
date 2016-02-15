/* 
Description: 
the controller is used in component FormatDateComponent 
this controller convert date format according to required format 
required format is like : 10 Jul 2012 

 @Created by: Sudeep Dube
 @Created Date: 17/06/2015
 
 --------------------------------------------------------------------------------
 | Modified By      | Modified Date       | Version        | Description         |
 --------------------------------------------------------------------------------
 |
  
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------

*/

public class FormatDateController {
    //the date variable is input by attribute from FormatDateComponent 
    public DateTime dateValue { get; set; }
   
    //the return values of the method will be printed by FormatDateComponent 
    public String getDateZoneValue() {
        if( dateValue != null ) {
            String FormatDT = dateValue.format('dd MMM yyy' );
               
            return FormatDT ;
        }
        return null;
    }
}