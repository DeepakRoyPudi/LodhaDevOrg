/* 
Description: 
the controller is used in component FormatDateComponent 
this controller convert date format according to required format 
required format is like : 21 Jul 2012 

 @Created by: Sudeep Dube
 @Created Date: 21/09/2015
 
 --------------------------------------------------------------------------------
 | Modified By      | Modified Date       | Version        | Description         |
 --------------------------------------------------------------------------------
 |
  
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------

*/

public class FormatDateColumnController {
    //the date variable is input by attribute from FormatDateComponent 
    public DateTime dateValue { get; set; }
   
    //the return values of the method will be printed by FormatDateComponent 
    public String getDateZoneValue() {
        if( dateValue != null ) {
            String FormatDT = dateValue.format('yyyy/MM/dd' );
               
            return FormatDT ;
        }
        return null;
    }
}