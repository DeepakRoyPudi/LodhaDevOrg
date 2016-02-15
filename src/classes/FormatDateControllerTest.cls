/* 
Description:
test class for cover the FormatDateController class which is used in FormatDateComponent

 @Created by: Sudeep Dube
 @Created Date: 24/06/2015
 
 --------------------------------------------------------------------------------
 | Modified By      | Modified Date       | Version        | Description         |
 --------------------------------------------------------------------------------
 |Sudeep Dube         21/09/2015            1.1             Add FormatColumnController test Coverage   
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------
*/

@isTest(SeeAllData = false)

public class FormatDateControllerTest {

 public testmethod static void testFormatDateController(){

   //format controller which used in FormatDateComponent
   FormatDateController formatContr = new FormatDateController ();
             formatContr.dateValue=System.now();
             System.assertNotEquals(formatContr.getDateZoneValue(),null);       
                      
             
             
             formatContr.dateValue=null;       
             System.assertEquals(formatContr.getDateZoneValue(),null); 
             
  //format Date Column controller which used in FormatDateColumnComponent           
  FormatDateColumnController formatContrColumn=new FormatDateColumnController();
                      formatContrColumn.dateValue=System.now();
                      System.assertNotEquals(formatContrColumn.getDateZoneValue(),null); 
             
             formatContrColumn.dateValue=null;       
             System.assertEquals(formatContrColumn.getDateZoneValue(),null);          
                      
} 

}