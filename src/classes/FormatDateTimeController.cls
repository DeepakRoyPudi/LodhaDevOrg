/* 
Description: 
the controller is used in component FormatDateTimeComponent 
this controller convert datetime format according to required format 
required format is like : 10 Jul 2012 10:10 Am 

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

public class FormatDateTimeController {
    //the date time variable is input by attribute from FormatDateTimeComponent 
    public DateTime dateTimeValue { get; set; }
   
    //the return values of the method will be printed by FormatDateTimeComponent 
    public String getTimeZoneValue() {
        if( dateTimeValue != null ) {
            String FormatDT = dateTimeValue.format('dd MMM yyyy hh:mm a' );
               
            return FormatDT ;
        }
        return null;
    }
}