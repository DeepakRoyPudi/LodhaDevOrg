/* 
Description:
test class for cover the FormatDateTimeController class which is used in FormatDateTimeComponent

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

public class FormatDateTimeControllerTest {

 public testmethod static void testFormatDateTimeController(){

   FormatDateTimeController formatContr = new FormatDateTimeController();
             formatContr.dateTimeValue=System.now();
             System.assertNotEquals(formatContr.getTimeZoneValue(),null);       
                      
             
             
             formatContr.dateTimeValue=null;       
             System.assertEquals(formatContr.getTimeZoneValue(),null); 
} 

}