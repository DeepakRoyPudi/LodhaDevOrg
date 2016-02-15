/* test class for payments web service 
 @Created by: Shruti Nikam
 @Created Date: 7/5/2015
 
 --------------------------------------------------------------------------------
 | Modified By      | Modified Date       | Version        | Description         |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------

*/
@isTest(seeAllData=false)
public class RestAPIPaymentTest{

    public testmethod static void calloutpayTestmethod(){ 
      

               
        
        createColorCodeCustomSetting();      
        String AccoutnbookingCRN1='1400780';
        Account a1 =new Account();
        a1.Primary_PAN_number__c='KLKL45127M';
        a1.AccountSource='Business Development';
        a1.CRN__c=AccoutnbookingCRN1;
        a1.lastname='testAccount1'+math.random();
        a1.recordtypeid = 
            Schema.SObjectType.Account.getRecordTypeInfosByName().get('Booked Account').getRecordTypeId();
        a1.Click_To_Call__c='4542156258';
        a1.Preferred_Mode_of_Contact__c='Phone';
        a1.TDS_Related__c='Authorized Lodha to pay';
        a1.BillingCountry='India';
        a1.TRAI_DND__c=true;
        a1.Alternate_Designation__c='Manager';
        a1.Occupation_acc__c='Salaried';
        a1.Type_of_Home__c='2 bhk';
        a1.Industry='IT Services';
        a1.Car_s_Owned__c='5';
        a1.Current_Home_ownership__c='Owned';
        a1.Hobbies__c='Dancing';
        a1.Purpose_of_Purchase__c='Second Home';
        a1.Children_Names__c='aaa | bbbb';
        a1.Children_s_DOB__c='12/01/1999 | 13/01/2001';
        a1.No_of_children__c=2;
        a1.DOB_of_Spouse__c= date.newInstance(1970, 1, 1);
        a1.Spouse_Name__c='testspouce';
        a1.Anniversary_Date__c= date.newInstance(1997, 1, 1);
        a1.Age__c=46;
        a1.Ethinicity__c='Bengali';
        a1.DOB_Of_Client__c= date.newInstance(1969, 1, 1);
        a1.PersonEmail='test@lodhauser.com';
        a1.Person_email_from_trigger__c='testuser@mylodhamail.com';
        a1.Co_Applicant__c='PURNIMA SAGAR SHAH';
        insert a1;
               
        Booking_Details__c bd1=new Booking_Details__c ();
        bd1.Account__c=a1.id;
        bd1.CRN__c=a1.CRN__c;
        bd1.Allotment_Date__c=Date.Today();
        bd1.Consideration_Value__c=123000000;
        bd1.Flat_ID__c='ABCD11000';
        insert bd1;
               
        Test.startTest();
               
           /*Set mock callout class RestMockHttpResponseGenerator
           for the successfull response with my gain yes */
           Test.setMock(HttpCalloutMock.class, new RestMockpaymentDataSet());      
           RestAPICalloutPayment rc1=new RestAPICalloutPayment('1400780');
           
           /* Set mock callout class RestMockHttpResponseGenerator
           for the successfull response with status code 500 */
           Test.setMock(HttpCalloutMock.class, new RestMockpaymentDataSet1());
           RestAPICalloutPayment rc2=new RestAPICalloutPayment('1400780');
       
        Test.stopTest();
        System.assertNotEquals(0,rc1.paymentInfoList.size()); 
        System.assertEquals(0,rc2.paymentInfoList.size());  
    }
    private static void createColorCodeCustomSetting() {
        // creating custom setting used in payments     
        List<PaymentsColorCodes__c> PaymentsColorCodes_List = new List<PaymentsColorCodes__c>();
        PaymentsColorCodes__c PaymentsColorCode_obj1 = new PaymentsColorCodes__c(name='PaymentRecievedAfterDue',Color_Code__c='Red',No_of_days__c=0);
        PaymentsColorCodes__c PaymentsColorCode_obj2 = new PaymentsColorCodes__c(name='PaymentRecievedBeforeDue',Color_Code__c='Green',No_of_days__c=0);
        PaymentsColorCodes__c PaymentsColorCode_obj3 = new PaymentsColorCodes__c(name='UpcomingPayments0daysLeft',Color_Code__c='Red',No_of_days__c=0);
        PaymentsColorCodes__c PaymentsColorCode_obj4 = new PaymentsColorCodes__c(name='UpcomingPayments3daysLeft',Color_Code__c='#FF9721',No_of_days__c=-3);
        PaymentsColorCodes__c PaymentsColorCode_obj5 = new PaymentsColorCodes__c(name='UpcomingPayments4daysLeft',Color_Code__c='Green',No_of_days__c=-4);
           
        PaymentsColorCodes_List.add(PaymentsColorCode_obj1);
        PaymentsColorCodes_List.add(PaymentsColorCode_obj2);
        PaymentsColorCodes_List.add(PaymentsColorCode_obj3);
        PaymentsColorCodes_List.add(PaymentsColorCode_obj4);
        PaymentsColorCodes_List.add(PaymentsColorCode_obj5);
        insert PaymentsColorCodes_List; 
           
        List<Payments_backgroundColorCode__c> Payments_backgroundColorCode_list = 
                new List<Payments_backgroundColorCode__c>();
        Payments_backgroundColorCode__c Payments_backgroundColorCode_obj1 = 
                new Payments_backgroundColorCode__c(name='Milestones_Paid',ColorCode__c='#D8FACF');
        Payments_backgroundColorCode__c Payments_backgroundColorCode_obj2 = 
                new Payments_backgroundColorCode__c(name='Milestones_Outstanding',ColorCode__c='#FCC7C7');
        Payments_backgroundColorCode__c Payments_backgroundColorCode_obj3 = 
                new Payments_backgroundColorCode__c(name='Milestones_Upcoming',ColorCode__c='#ECECEC');
               
        Payments_backgroundColorCode_list.add(Payments_backgroundColorCode_obj1);
        Payments_backgroundColorCode_list.add(Payments_backgroundColorCode_obj2);
        Payments_backgroundColorCode_list.add(Payments_backgroundColorCode_obj3);
         insert Payments_backgroundColorCode_list;
      }
      
      
}