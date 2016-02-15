/* 
Description : Test class for Mygain detailview  
 @Created by: Shruti Nikam
 @Created Date: 19/05/2015
 
 --------------------------------------------------------------------------------
 | Modified By      | Modified Date       | Version        | Description         |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------

*/
@isTest(seeAllData=false)
public class mygaincontrollerTest{

public testmethod static void MygainTestmethod(){

   
   
    // Set mock callout class RestMockHttpResponseGenerator for the successfull response with my gain yes 
        Test.setMock(HttpCalloutMock.class, new RestMockMygainDetailviewDataSet());
        
        mygaincontroller mygaincontroller_obj = new mygaincontroller();
        
        system.assertNotEquals(null,mygaincontroller_obj);
         
               
       
         
}

}