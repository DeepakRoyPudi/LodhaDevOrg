/* 
Description:
test class for cover the RMpreLandingPageController
controller class which is used in RM Pre landing page Which opened 
Which consist functionality that, when user enter CRN it open the customer 
360 Rm landing page 

 @Created by: Sudeep Dube
 @Created Date: 16/07/2015
 
 --------------------------------------------------------------------------------
 | Modified By      | Modified Date       | Version        | Description         |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------
*/
@isTest(seeAllData = false)
public class RMpreLandingPageControllerTest{

//Scenario -where Account and Booking available 
public testmethod static void coverRMpreLandingPageController() {

 String CRN_1 = '123456';
 
 RMpreLandingPageControllerTest.createAccountandBookingDetail(CRN_1);
 RMpreLandingPageController controller1=new RMpreLandingPageController();
 controller1.CRN=CRN_1;
 controller1.gotoCustomer360();

}

//Scenario When Account Exist But Booking not exist for the same account
public testmethod static void coverErrorBookingNotExist() {

 String CRN_1 = '123457';
 
 RMpreLandingPageControllerTest.createAccountWithoutBookingDetail(CRN_1);
 RMpreLandingPageController controller1=new RMpreLandingPageController();
 controller1.CRN=CRN_1;
 controller1.gotoCustomer360();


}

//when CRN is empty (controller variable)
//Scenario When Account Exist But Booking not exist for the same account
public testmethod static void coverEmptyCRNError() {
 
 RMpreLandingPageController controller1=new RMpreLandingPageController();

 controller1.gotoCustomer360();
 
 
}

//when CRN is not empty (controller variable)
//Scenario When Account Exist But Etered CRN for Account not Exist
public testmethod static void coverErrorAccountNotExist() {

 String CRN_1 = '123458';
 
 RMpreLandingPageControllerTest.createAccountWithoutBookingDetail(CRN_1);
 RMpreLandingPageController controller1=new RMpreLandingPageController();
 controller1.CRN='9854842';
 controller1.gotoCustomer360();


}


 public static void createAccountandBookingDetail(String CRN){
   
   //create Account for parameter CRN 
   String AccoutnbookingCRN1 =CRN;
        Account a1 = new Account();
        a1.Primary_PAN_number__c = 'BB67584521M';
        a1.AccountSource = 'Business Development';
        a1.CRN__c = AccoutnbookingCRN1;
        a1.lastname = 'testAccount1';
        a1.recordtypeid = 
            Schema.SObjectType.Account.getRecordTypeInfosByName().get('Booked Account').getRecordTypeId();
        insert a1;
     
     //Create booking Detail for above created Account
        Booking_Details__c bd1 = new Booking_Details__c();
        bd1.Account__c = a1.id;
        bd1.CRN__c = a1.CRN__c;
        bd1.Allotment_Date__c = Date.Today();
        bd1.Consideration_Value__c = 123000000;
        bd1.Flat_ID__c = 'ABCD11000';   
        insert bd1; 
 }
 
 public static void createAccountWithoutBookingDetail(String CRN){
   
   //create Account for parameter CRN 
   String AccoutnbookingCRN1 =CRN;
        Account a1 = new Account();
        a1.Primary_PAN_number__c = 'BB67584521M';
        a1.AccountSource = 'Business Development';
        a1.CRN__c = AccoutnbookingCRN1;
        a1.lastname = 'testAccount1';
        a1.recordtypeid = 
            Schema.SObjectType.Account.getRecordTypeInfosByName().get('Booked Account').getRecordTypeId();
        insert a1;
     
    
 }
 
 
}