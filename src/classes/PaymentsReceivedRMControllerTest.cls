/* 
Description :Test class for payments 
 @Created by: Shruti Nikam
 @Created Date: 13/05/2015
 
 --------------------------------------------------------------------------------
 | Modified By      | Modified Date       | Version        | Description         |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------

*/
@isTest
public class PaymentsReceivedRMControllerTest {

    public testmethod static void cPaymentsReceivedRMTestmethod() {
           //cREATE DATA FOR CUSTOM SETTING 
           createColorCodeCustomSetting();
           //cREATE DATA FOR CUSTOM SETTING
           createrRemindersCustomSetting();
           //insert custom setting for intrest rate
           VirtualInterestCalculator_InterestRate__c objIntrest= creteIntrestRate();
           insert objIntrest;
           
            Test.startTest();
            // Set mock callout class RestMockCollectionDataSet() for the successfull response      
            Test.setMock(HttpCalloutMock.class, new RestMockPaymentsReceivedRMDataSet());  
            
            //invoke constructor to of controller   
            PaymentsReceivedRMController PaymentsObj = new PaymentsReceivedRMController();
            PaymentsObj.PARAM_CRN = '1400780';
            PaymentsObj.NoOfRecords = 3;
            PaymentsObj.getPreIntialization();
            
                
                //Test for duedate and despatch date values
                PaymentsObj.acc.PersonBirthdate = system.today();
                PaymentsObj.virtualInterest_obj.duedate = system.today();
                PaymentsObj.virtualInterest_obj.outstandingamt =10000;
                PaymentsObj.InterestAmount();
                
                 //Test for duedate and despatch date values
                PaymentsObj.acc.PersonBirthdate = null;
                PaymentsObj.virtualInterest_obj.duedate = null;
                PaymentsObj.InterestAmount();
                
                 //Test for duedate and despatch date values
                PaymentsObj.acc.PersonBirthdate = system.today() - 66;
                PaymentsObj.virtualInterest_obj.duedate = system.today() - 57;
                PaymentsObj.virtualInterest_obj.outstandingamt =6546546;
                PaymentsObj.InterestAmount();
                
                PaymentsObj.acc.PersonBirthdate = NULL;
                PaymentsObj.virtualInterest_obj.duedate = NULL;
                PaymentsObj.InterestAmount();
                
                 
                apexpages.currentpage().getparameters().put('dueDate','12 Feb 2014');
                apexpages.currentpage().getparameters().put('amt',String.valueOf(250000));
                PaymentsObj.autoPopulateMyGainVar();
                
                /*dueDate and amt are ''*/
                apexpages.currentpage().getparameters().put('dueDate','');
                apexpages.currentpage().getparameters().put('amt','');
                PaymentsObj.autoPopulateMyGainVar();
                
                apexpages.currentpage().getparameters().put('dueDate','');
                apexpages.currentpage().getparameters().put('amt',String.valueOf(250000));
                PaymentsObj.autoPopulateMyGainVar();
               
                PaymentsObj.receiveddate.PersonBirthdate=system.today();
                PaymentsObj.calculateTotal_VirtualInterest();
                
                PaymentsObj.receiveddate.PersonBirthdate=null;
                PaymentsObj.calculateTotal_VirtualInterest();
                PaymentsObj.totalvirtualcal_clearValues();
               
               
                PaymentsObj.clearValues();
                
                 // Set mock callout class RestMockCollectionDataSet() for the successfull response      
                Test.setMock(HttpCalloutMock.class, new RestMockPaymentsReceivedRMDataSet1());  
            
               //invoke constructor to of controller   
                PaymentsReceivedRMController PaymentsObj1 = new PaymentsReceivedRMController();
                PaymentsObj1.getPreIntialization();
                system.assertNotEquals(null,PaymentsObj1);
                
                 // Set mock callout class RestMockCollectionDataSet() for the successfull response      
                Test.setMock(HttpCalloutMock.class, new RestMockPaymentsReceivedRMDataSet2());  
            
               //invoke constructor to of controller   
                PaymentsReceivedRMController PaymentsObj2 = new PaymentsReceivedRMController();
                PaymentsObj2.getPreIntialization();
                 system.assertNotEquals(null,PaymentsObj2);
                
                 // Set mock callout class RestMockCollectionDataSet() for the successfull response      
                Test.setMock(HttpCalloutMock.class, new RestMockPaymentsReceivedRMDataSet3());  
            
               //invoke constructor to of controller   
                PaymentsReceivedRMController PaymentsObj3 = new PaymentsReceivedRMController();
                PaymentsObj3.getPreIntialization();
                 system.assertNotEquals(null,PaymentsObj3);
                
                  // Set mock callout class RestMockCollectionDataSet() for the successfull response      
                Test.setMock(HttpCalloutMock.class, new RestMockPaymentsReceivedRMDataSet4());  
            
               //invoke constructor to of controller   
                PaymentsReceivedRMController PaymentsObj4 = new PaymentsReceivedRMController();
                PaymentsObj4.getPreIntialization();
                system.assertNotEquals(null,PaymentsObj4);
                
                
            Test.stopTest();
    


    }

      private static VirtualInterestCalculator_InterestRate__c creteIntrestRate() {
       VirtualInterestCalculator_InterestRate__c 
           Obj_virualIntrest = new VirtualInterestCalculator_InterestRate__c();
           Obj_virualIntrest.Name = 'Interest';
           Obj_virualIntrest.Interest_Rate__c = 12;
           return Obj_virualIntrest;
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
      }
      
      private static void createrRemindersCustomSetting() {
          List<Reminder_no_of_days__c> Reminder_no_of_days_list = new List<Reminder_no_of_days__c>();
           Reminder_no_of_days__c Reminder_no_of_days_obj1 = new Reminder_no_of_days__c(name='afteroneday',No_of_days__c=1,Letter_issue_days__c=3);
           Reminder_no_of_days__c Reminder_no_of_days_obj2 = new Reminder_no_of_days__c(name='afterfivedays',No_of_days__c=5,Letter_issue_days__c=7);
           Reminder_no_of_days__c Reminder_no_of_days_obj3 = new Reminder_no_of_days__c(name='after12days',No_of_days__c=12,Letter_issue_days__c=14);
           
           Reminder_no_of_days_list.add(Reminder_no_of_days_obj1);
           Reminder_no_of_days_list.add(Reminder_no_of_days_obj2);
           Reminder_no_of_days_list.add(Reminder_no_of_days_obj3);
           insert Reminder_no_of_days_list;
      }
       
       





}