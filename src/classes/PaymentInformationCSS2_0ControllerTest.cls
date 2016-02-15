/* 
Description - This class contains unit tests for validating the 
 *         behavior of PaymentInformationCSS2_0Controller class

 @Created by: Trupti Dhoka
 @Created Date: 18/may/2015
 
 ----------------------------------------------------------------------------------------------
 | Modified By      | Modified Date       | Version        | Description         |
 ----------------------------------------------------------------------------------------------
 |Trupti D              8/07/15                 1.1          added test method for 
                                                             totalvirtualcal_clearValues Method    
 ----------------------------------------------------------------------------------------------
 |Shruti Nikam          18/01/2016              2.0          Added asserts and updated code with 
                                                             virtual cal test methods 
 ----------------------------------------------------------------------------------------------
*/
@isTest
public with sharing class PaymentInformationCSS2_0ControllerTest {

    static TestMethod void Positivepaymenttest() {
        //create account
        Account objAccount = createAccount();
        insert objAccount;

        //create project name
        Project_Name__c projectname = createProjectName();
        insert projectname;

        //Create Booking and Demand
        Booking_Details__c bookingDetail = new Booking_Details__c(Account__c = objAccount.Id, 
                                                                  CRN__c =objAccount.CRN__c,
                                                                  Allotment_Date__c = system.today(),
                                                                  Flat_ID__c = '345345',
                                                                  Consideration_Value__c = 100);
        insert bookingDetail;

        Payment_Milestone__c paymentMilestone = addPaymentMilestone();
        insert paymentMilestone;

        List<Demands__c> demandList =  addDemands(paymentMilestone, bookingDetail.id);
        insert demandList;

        //create user
        User u = createUser(objAccount);
        insert u;

        CSSBackgroundImageSetting__c projimage = new CSSBackgroundImageSetting__c(name='Project Wise',
                                                                                  Project_Wise__c=true);
        insert projimage;

        // creating custom setting used in payments     
        List<PaymentsColorCodes__c> PaymentsColorCodes_List = addColorCode();
        insert PaymentsColorCodes_List; 

        List<Payments_backgroundColorCode__c> Payments_backgroundColorCode_List = addBackgroundColorCode();
        insert Payments_backgroundColorCode_List;

        CSS2_0TabEnableDisableSetting__c tabEnableDisableSetting = new CSS2_0TabEnableDisableSetting__c(name='Disable Account Ledger');
        insert tabEnableDisableSetting;

        //insert custom setting for intrest rate
        VirtualInterestCalculator_InterestRate__c objIntrest= creteIntrestRate();
        insert objIntrest;

        List<Service_Tax_Detail__c> serviceTaxList = addServiceTax(bookingDetail.id, objAccount.Id);
        insert serviceTaxList;

        System.runAs(u) {
            Test.startTest();
                // Set mock callout class RestMockCollectionDataSet() for the successfull response      
                Test.setMock(HttpCalloutMock.class, new RestMockPaymentsReceivedRMDataSet());  

                //invoke constructor to claculate collection index  
                PaymentInformationCSS2_0Controller PaymentsObj = new PaymentInformationCSS2_0Controller ();
                PaymentInformationCSS2_0Controller PaymentsObj1 = new PaymentInformationCSS2_0Controller ();
                PaymentInformationCSS2_0Controller PaymentsObj2 = new PaymentInformationCSS2_0Controller ();

                PaymentsObj.checkBackgroundImage();

                //Test for duedate and despatch date values
                PaymentsObj.virtualInterest_obj.outstandingamt =10000;
                PaymentsObj.InterestAmount();

                apexpages.currentpage().getparameters().put('dueDate','Thu Feb 12 00:00:00 GMT 2014');
                apexpages.currentpage().getparameters().put('amt',String.valueOf(250000));
                PaymentsObj.autoPopulateMyGainVar();

                PaymentsObj2.acc.Despatch_Date__c = system.today() - 66;
                PaymentsObj2.virtualInterest_obj.outstandingamt =6546546;
                PaymentsObj2.InterestAmount();

                apexpages.currentpage().getparameters().put('dueDate',String.valueOf(system.today() - 57));
                apexpages.currentpage().getparameters().put('amt',String.valueOf(6546546));
                PaymentsObj2.autoPopulateMyGainVar();

                //Test for duedate and despatch date values
                PaymentsObj1.acc.Despatch_Date__c = null;
                PaymentsObj1.virtualInterest_obj.duedate = null;
                PaymentsObj1.InterestAmount();

                 //Test for duedate and despatch date values
                PaymentsObj1.acc.Despatch_Date__c = system.today();
                PaymentsObj1.virtualInterest_obj.duedate = system.today() + 57;
                PaymentsObj1.virtualInterest_obj.outstandingamt =6546546;
                PaymentsObj1.InterestAmount();

                PaymentsObj1.acc.Despatch_Date__c = NULL;
                PaymentsObj1.virtualInterest_obj.duedate = NULL;
                PaymentsObj1.InterestAmount();

                /*dueDate and amt are ''*/
                apexpages.currentpage().getparameters().put('dueDate','');
                apexpages.currentpage().getparameters().put('amt','');
                PaymentsObj1.autoPopulateMyGainVar();

                apexpages.currentpage().getparameters().put('dueDate','');
                apexpages.currentpage().getparameters().put('amt',String.valueOf(250000));
                PaymentsObj1.autoPopulateMyGainVar();

                PaymentsObj1.receiveddate.Despatch_Date__c=system.today();
                PaymentsObj1.calculateTotal_VirtualInterest();

                PaymentsObj1.receiveddate.Despatch_Date__c=null;
                PaymentsObj1.calculateTotal_VirtualInterest();
                PaymentsObj1.totalvirtualcal_clearValues();

                PaymentsObj1.clearValues();
                PaymentsObj.PaymentMode();

            Test.stopTest();
            system.assertEquals('58027',PaymentsObj.virtualInterest_obj.totalamt);
            system.assertEquals('0',PaymentsObj2.virtualInterest_obj.totalamt);
        }
    } 

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
    private static User createUser(Account a) {
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

    private static Project_Name__c  createProjectName() {
        Project_Name__c objprojectname = new Project_Name__c();
        objprojectname.Name = 'New Cuffe Parade';
        objprojectname.OrderType__c = 'Custom';
        objprojectname.Project_Type__c = 'Hi End / Luxury';
        objprojectname.Record_Type__c ='Residential';
        objprojectname.CSS_Background_Image_URL__c = 'https://c.cs7.content.force.com/servlet/servlet.FileDownload?file=00PM0000003RzGG';
        return objprojectname;
    }

    private static Payment_Milestone__c addPaymentMilestone() {
        List<Payment_Milestone__c> Payment_MilestoneList = new List<Payment_Milestone__c>();
        Payment_Milestone__c paymentMilestone = new Payment_Milestone__c(Name = 'Slab 4',
                                                                    Milestone_Ranking__c = 243,
                                                                    Milestone_Usage_No__c = '87324',
                                                                    Type__c = 'Time bound Milestones');
        return paymentMilestone;
    }

    private static List<Demands__c> addDemands(Payment_Milestone__c paymentMilestone , id bookingDetail){
        List<Demands__c> demandList = new List<Demands__c>();
        Demands__c demand = new Demands__c(Flat_ID__c = bookingDetail, ExternalID__c = '21312',
                                            Payment_Milestone__c = paymentMilestone.Id,
                                            Billing_Date__c = system.today(),Demand_amount__c  = 100,
                                            Amount_received__c = 100);

        Demands__c demand1 = new Demands__c(Flat_ID__c = bookingDetail, ExternalID__c = '12231312',
                                            Payment_Milestone__c = paymentMilestone.Id,
                                            Billing_Date__c = system.today(),Demand_amount__c = 213,
                                            Amount_received__c = 0);

        Demands__c demand2 = new Demands__c(Flat_ID__c = bookingDetail, ExternalID__c = '213241312',
                                            Payment_Milestone__c = paymentMilestone.Id,
                                            Billing_Date__c = system.today());

        Demands__c demand3 = new Demands__c(Flat_ID__c = bookingDetail, ExternalID__c = '2132342112');
        demandList.add(demand);
        demandList.add(demand1);
        demandList.add(demand2);
        demandList.add(demand3);

        return demandList;
    } 

    private static VirtualInterestCalculator_InterestRate__c creteIntrestRate() {
        VirtualInterestCalculator_InterestRate__c 
        Obj_virualIntrest = new VirtualInterestCalculator_InterestRate__c();
        Obj_virualIntrest.Name = 'Interest';
        Obj_virualIntrest.Interest_Rate__c = 12;
        return Obj_virualIntrest;
    }

    private static List<PaymentsColorCodes__c> addColorCode() {
        List<PaymentsColorCodes__c> PaymentsColorCodes_List = new List<PaymentsColorCodes__c>();
        PaymentsColorCodes__c PaymentsColorCode_obj1 = 
            new PaymentsColorCodes__c(name='PaymentRecievedAfterDue',Color_Code__c='Red',No_of_days__c=0);
        PaymentsColorCodes__c PaymentsColorCode_obj2 = 
            new PaymentsColorCodes__c(name='PaymentRecievedBeforeDue',Color_Code__c='Green',No_of_days__c=0);
        PaymentsColorCodes__c PaymentsColorCode_obj3 = 
            new PaymentsColorCodes__c(name='UpcomingPayments0daysLeft',Color_Code__c='Red',No_of_days__c=0);
        PaymentsColorCodes__c PaymentsColorCode_obj4 = 
            new PaymentsColorCodes__c(name='UpcomingPayments3daysLeft',Color_Code__c='#FF9721',No_of_days__c=-3);
        PaymentsColorCodes__c PaymentsColorCode_obj5 = 
            new PaymentsColorCodes__c(name='UpcomingPayments4daysLeft',Color_Code__c='Green',No_of_days__c=-4);

        PaymentsColorCodes_List.add(PaymentsColorCode_obj1);
        PaymentsColorCodes_List.add(PaymentsColorCode_obj2);
        PaymentsColorCodes_List.add(PaymentsColorCode_obj3);
        PaymentsColorCodes_List.add(PaymentsColorCode_obj4);
        PaymentsColorCodes_List.add(PaymentsColorCode_obj5);
        return PaymentsColorCodes_List;
    } 
	
    private static List<Payments_backgroundColorCode__c> addBackgroundColorCode(){
        List<Payments_backgroundColorCode__c> Payments_backgroundColorCode_List = new List<Payments_backgroundColorCode__c>();
        Payments_backgroundColorCode__c Payments_backgroundColorCode_obj1 = new 
            Payments_backgroundColorCode__c(name='Milestones_Paid',ColorCode__c = 'Red');
        Payments_backgroundColorCode__c Payments_backgroundColorCode_obj2 = 
            new Payments_backgroundColorCode__c(name='Milestones_Outstanding',ColorCode__c = 'Green');
        Payments_backgroundColorCode__c Payments_backgroundColorCode_obj3 = 
            new Payments_backgroundColorCode__c(name='Milestones_Upcoming',ColorCode__c = '#FF9721');

        Payments_backgroundColorCode_List.add(Payments_backgroundColorCode_obj1);
        Payments_backgroundColorCode_List.add(Payments_backgroundColorCode_obj2);
        Payments_backgroundColorCode_List.add(Payments_backgroundColorCode_obj3);
        return Payments_backgroundColorCode_List;
    }

    private static List<Service_Tax_Detail__c> addServiceTax(Id bookingDetail, Id accountId) {
        List<Service_Tax_Detail__c> serviceTaxList =new List<Service_Tax_Detail__c>();
        Service_Tax_Detail__c Service_Tax_DetailObj1 = new Service_Tax_Detail__c();
        Service_Tax_DetailObj1.Pref_location_Service_Tax__c = 100.00;
        Service_Tax_DetailObj1.Const_Service_tax_Amount__c = 100.00;
        Service_Tax_DetailObj1.Taxable_Service_Tax_Amount__c = 100.00;
        Service_Tax_DetailObj1.ST_on_Construction_Serv__c = 100.00;
        Service_Tax_DetailObj1.ST_on_Preferential_Location__c = 100.00;
        Service_Tax_DetailObj1.Total_ST_Payable__c = 100.00;
        Service_Tax_DetailObj1.Payment_Received__c = 100.00;
        Service_Tax_DetailObj1.External_ID__c = '334534';
        Service_Tax_DetailObj1.Flat_ID__c = bookingDetail;
        Service_Tax_DetailObj1.Account__c =accountId;

	    Service_Tax_Detail__c Service_Tax_DetailObj2 = new Service_Tax_Detail__c();
        Service_Tax_DetailObj2.Pref_location_Service_Tax__c = 120.00;
        Service_Tax_DetailObj2.Const_Service_tax_Amount__c = 1050.00;
        Service_Tax_DetailObj2.Taxable_Service_Tax_Amount__c = 100.00;
        Service_Tax_DetailObj2.ST_on_Construction_Serv__c = 100.00;
        Service_Tax_DetailObj2.ST_on_Preferential_Location__c = 100.00;
        Service_Tax_DetailObj2.Total_ST_Payable__c = 100.00;
        Service_Tax_DetailObj2.Payment_Received__c = 100.00;
        Service_Tax_DetailObj2.External_ID__c = '334535';
        Service_Tax_DetailObj2.Flat_ID__c = bookingDetail;
        Service_Tax_DetailObj2.Account__c =accountId;

        serviceTaxList.add(Service_Tax_DetailObj1);
        serviceTaxList.add(Service_Tax_DetailObj2);
        return serviceTaxList;
    }
}