/* 
Description:
test class for cover the FormatCurrencyController class which is used in FormatCurrencyComponent

 @Created by: Sudeep Dube
 @Created Date: 24/06/2015
 
 --------------------------------------------------------------------------------
 | Modified By      | Modified Date       | Version        | Description         |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------
*/

@isTest(SeeAllData = false)

public class FormatCurrencyControllerTest{

 public testmethod static void testFormatCurrencyController(){

   FormatCurrencyController   formatContr = new FormatCurrencyController();
             formatContr.CurrencyValue='12345.55';
             System.assertNotEquals(formatContr.getCurrencyZoneValue(),null);       
                      
             formatContr.CurrencyValue='12345.00';
             System.assertNotEquals(formatContr.getCurrencyZoneValue(),null);    
             
             formatContr.CurrencyValue='';       
             System.assertEquals(formatContr.getCurrencyZoneValue(),0.00); 
             
             formatContr.CurrencyValue='0';       
             System.assertEquals(formatContr.getCurrencyZoneValue(),0.0); 
} 

}