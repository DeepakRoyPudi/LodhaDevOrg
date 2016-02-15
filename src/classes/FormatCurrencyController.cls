/* 
Description: 
the controller is used in component FormatCurrencyComponent 
this controller convert String  format according to required format 
required format is like : 100,000.00 in local user currency

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

public class FormatCurrencyController{
    //the date variable is input by attribute from FormatDateComponent 
    public String CurrencyValue { get; set; }
   
    //the return values of the method will be printed by FormatDateComponent 
    public Double getCurrencyZoneValue() {
        if( String.isNotBlank(CurrencyValue) ) {
            
             
            Double d=Double.valueOf(CurrencyValue );
            
            if(d==0.0){
                return 0;
            }
            else{
                return (Double.valueOf(CurrencyValue)) ;
            } 
        }
        return 0;
    }
}