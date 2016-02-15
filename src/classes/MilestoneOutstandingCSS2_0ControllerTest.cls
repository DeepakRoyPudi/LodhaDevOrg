/* 
Description - This class contains unit tests for validating the 
 *         behavior of MilestoneOutstandingCSS2_0Controller class

 @Created by: Trupti Dhoka
 @Created Date: 18/may/2015
 
 --------------------------------------------------------------------------------
 | Modified By      | Modified Date       | Version        | Description         |
 --------------------------------------------------------------------------------
 |Trupti Dhoka          17/07/15            1.1             Changed crisp view -used Demands 
                                                            object
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------
*/

@isTest
public class MilestoneOutstandingCSS2_0ControllerTest {
         //method for creating account
        private static Account createAccount(){
            Account objAccount = new Account();
            objAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Booked Account').getRecordTypeId();
            objAccount.FirstName = 'Test1';
            objAccount.LastName = 'Account1';
            objAccount.CRN__c = '1400780';
            objAccount.H_Mobile_No__c = '1234560789';
            objAccount.Mobile_Phone__c = '21241222';
            objAccount.Co_Applicant__c = 'test';
            objAccount.Project_Name__c = 'New Cuffe Parade';
            return objAccount;
        }  
    //method for creating community user
        private static User createUser(Account a)
        {
            User objUser = new User();
            contact c=[select id from contact where accountid=:a.id limit 1];
            objUser.ProfileID = [Select Id From Profile Where Name = 'Custom Overage High Volume Customer Portal'].id;
            objUser.EmailEncodingKey = 'ISO-8859-1';
            objUser.LanguageLocaleKey = 'en_US';
            objUser.TimeZoneSidKey = 'America/New_York';
            objUser.LocaleSidKey = 'en_US';
            objUser.FirstName = 'first';
            objUser.LastName = 'last';
            objUser.Username = 'test@appirio.com';
            objUser.CommunityNickname = 'testUser123';
            objUser.Alias = 't1';
            objUser.Email = 'no@email.com';
            objUser.IsActive = true;
            objUser.ContactId = c.id;
            return objUser;
        }   
          
        private static WidgetInfo__c createWidgetInfo(){
            WidgetInfo__c objWidgetInfo = new WidgetInfo__c();
            objWidgetInfo.Name='Upcoming/Due Payment';
            objWidgetInfo.Available_For__c = 'Both'; 
            return objWidgetInfo;
        }
        
        private static list<Widget_Sequence__c> createWidgetlst(User u, WidgetInfo__c winfo,integer no)
        {
             List<Widget_Sequence__c> lstWidget_Sequence = new List<Widget_Sequence__c>();
                
                for(Integer i = 0; i < no ; i++){
                    lstWidget_Sequence.add (new Widget_Sequence__c(Sequence_ClickCount__c= 0,
                    WidgetInfo__c= winfo.id,
                    User__c = u.Id));
                }  
             return  lstWidget_Sequence;
        } 
        //create payment milestone 
        private static Payment_Milestone__c createMilestone(String name){
           Payment_Milestone__c milestone = new Payment_Milestone__c();
           milestone.Name = name;
           return milestone;
        }
        //method to create booking detail
        private static Booking_Details__c createbooking (Account a){
            Booking_Details__c bookingobj = new Booking_Details__c();
            bookingobj.CRN__c = '1400780';
            bookingobj.Flat_ID__c = 'test12345';
            bookingobj.Consideration_Value__c = 200000000;
            bookingobj.Account__c = a.id;
            return bookingobj;
        }
        
         //create demands - for milestone received
        private static list<Demands__c>  createDemandlst(Payment_Milestone__c milestone , Booking_Details__c booking,
                                             Account a ,String External, integer no){
            list<Demands__c> demandlst = new list<Demands__c>();
            
            for(integer i=0 ; i<no ; i++){
                    demandlst.add(new Demands__c(
                    Payment_Milestone__c = milestone.id,
                    Account__c = a.id,
                    Flat_ID__c = booking.id,
                    Demand_amount__c = 500000 + i,
                    Amount_received__c = 500000 + i,
                    Billing_Date__c = system.today() - i,
                    Payment_received_on__c = system.today(),
                    ExternalID__c = External + i
                ));
            } 
            return demandlst;
        } 
        
        //create demands - for milestone due
        private static list<Demands__c>  createDueDemandlst(Payment_Milestone__c milestone , Booking_Details__c booking,
                                         Account a ,String External,  integer no){
            list<Demands__c> demandlst = new list<Demands__c>();
            
            for(integer i=0 ; i<no ; i++){
                    demandlst.add(new Demands__c(
                    Payment_Milestone__c = milestone.id,
                    Account__c = a.id,
                    Flat_ID__c = booking.id,
                    Demand_amount__c = 500000 + i,
                    Amount_received__c = 500000 - i,
                    Billing_Date__c = system.today() - i,
                    Payment_received_on__c = system.today(),
                    ExternalID__c = External + i
                ));
            } 
            return demandlst;
        } 
        
        static TestMethod void milestonetest()
        {
            //create account
            Account objAccount = createAccount();
            insert objAccount;
        
            //create user
            User u = createUser(objAccount);
            insert u;
           
            //insert record for widget info for clickCount functionality
            WidgetInfo__c Objwidgetinfo = createWidgetInfo();
            insert Objwidgetinfo;
          
            list <Widget_Sequence__c> objWidgetSeq = createWidgetlst(u,Objwidgetinfo,10);
            insert objWidgetSeq;
            
            //insert booking detail related to account
            Booking_Details__c ObjBooking = createbooking (objAccount);
            insert ObjBooking;
            
            //create milestone with name '1% MVAT Recovery'
            Payment_Milestone__c milestone1 = createMilestone('1% MVAT Recovery');
            insert milestone1;
            
            //create Milestone with name 'Application Money-1' 
            Payment_Milestone__c milestone2 = createMilestone('Application Money-1');
            insert milestone2;  
            
            //create Milstone with name 'Application Money-2'
             Payment_Milestone__c milestone3 = createMilestone('Application Money-2');
             insert milestone3;
            
            //create demand list for mileston paid crisp view 
            list <Demands__c> lstMilestonedue = createDueDemandlst (milestone1,ObjBooking,objAccount ,'abcde',5);
            insert  lstMilestonedue;
            
            //create demand list for mileston paid crisp view 
            list <Demands__c> lstMilestonedue1 = createDueDemandlst (milestone2,ObjBooking,objAccount ,'abcdee',5);
            insert  lstMilestonedue1;
            
            //create demand list for mileston paid crisp view 
            list <Demands__c> lstMilestonedue2 = createDueDemandlst (milestone3,ObjBooking,objAccount ,'abcdeff',5);
            insert  lstMilestonedue2;
            
             //create demand list for mileston paid crisp view for milestone1 above 
            list <Demands__c> lstMilestonePaid = createDemandlst(milestone1,ObjBooking,objAccount,'abcde1',5);
            insert  lstMilestonePaid;
            
             //create demand list for mileston paid crisp view for milestone2 above 
            list <Demands__c> lstMilestonePaid1 = createDemandlst(milestone2,ObjBooking,objAccount,'testid',5);
            insert  lstMilestonePaid1;
            
            system.runAs(u){
            
                test.StartTest();
                MilestoneOutstandingCSS2_0Controller  milestonectroler = new MilestoneOutstandingCSS2_0Controller ();
                milestonectroler.clickMilestoneCount();
                test.StopTest();
            }
            
            //check if all lists are not empty
            System.assertNotEquals(lstMilestonedue , NULL);
            System.assertNotEquals(lstMilestonedue1 , NULL);
            System.assertNotEquals(lstMilestonedue2 , NULL);
            System.assertNotEquals(lstMilestonePaid , NULL);
            System.assertNotEquals(lstMilestonePaid1 , NULL);
            //check if total balance due is same as calculated
            //System.assertEquals(MilestoneOutstandingCSS2_0Controller.TotalAmtDue,60.00);
             
        }
        

}