/*@Created by: Deepak Pudi 
     @Created Date: 11/4/2015 -->
 
 -- ------------------------------------------------------------------------------
 | Modified By      | Modified Date       | Version        | Description         |
 --------------------------------------------------------------------------------
 |Deepak Pudi           21/4/2015            1.0           ProfileInfo Report test Class
 --------------------------------------------------------------------------------
 |
 ------------------------------------------------------------------------------ --*/
@isTest(SeeAllData = false)
private class ProfileInfoTest {

    static testMethod void ProfileInfo() {


        //Test data for Account.
        List < Account > accounts = new List < Account > ();
        Account acc = new Account();
        acc.CRN__c = '1234567';
        acc.Name = 'testroy';
        acc.Co_Applicant__c = 'Roy';
        acc.LoyaltyID__c = '65437289';
        acc.Legal_Alert__c = True;
        acc.Collection_Index__c = 10.00;
        acc.CIP__c = TRUE;
        acc.Preferred_mode_of_Contact__c = 'Phone';
        // acc. Owner.name='David';
        acc.Client_Type__c = 'NRI';
        acc.Ethinicity__c = 'South Indian Hindu';
        acc.Age__c = 20;
        acc.Marital_Status__c = 'Unmarried';
        acc.No_of_children__c = 5;
        acc.Project_Name__c = 'New Cuffe Parade';
        acc.Purpose_of_Purchase__c = 'Investment';
        acc.Industry = 'Aluminium';
        accounts.add(acc);

        Account acc1 = new Account();
        acc1.CRN__c = '1134567';
        acc1.Name = 'testroy1';
        acc1.Co_Applicant__c = 'Roy1';
        acc1.LoyaltyID__c = '65407289';
        acc1.Legal_Alert__c = True;
        acc1.Collection_Index__c = 10.00;
        acc1.CIP__c = TRUE;
        acc1.Preferred_mode_of_Contact__c = 'Phone';
        // acc. Owner.name='David';
        acc1.Client_Type__c = 'NRI';
        acc1.Ethinicity__c = 'South Indian Hindu';
        acc1.Age__c = 20;
        acc1.Marital_Status__c = 'Unmarried';
        acc1.No_of_children__c = 5;
        acc1.Project_Name__c = 'New Cuffe Parade';
        acc1.Purpose_of_Purchase__c = 'Investment';
        acc1.Industry = 'Aluminium';
        accounts.add(acc1);

        Account acc2 = new Account();
        acc2.CRN__c = '12352567';
        acc2.Name = 'testroy2';
        acc2.Co_Applicant__c = 'Roy2';
        acc2.LoyaltyID__c = '64537289';
        acc2.Legal_Alert__c = True;
        acc2.Collection_Index__c = 10.00;
        acc2.CIP__c = TRUE;
        acc2.Preferred_mode_of_Contact__c = 'Phone';
        // acc. Owner.name='David';
        acc2.Client_Type__c = 'NRI';
        acc2.Ethinicity__c = 'South Indian Hindu';
        acc2.Age__c = 20;
        acc2.Marital_Status__c = 'Unmarried';
        acc2.No_of_children__c = 5;
        acc2.Project_Name__c = 'New Cuffe Parade';
        acc2.Purpose_of_Purchase__c = 'Investment';
        acc2.Industry = 'Aluminium';
        accounts.add(acc2);

        Account acc3 = new Account();
        acc3.CRN__c = '178654567';
        acc3.Name = 'testroy3';
        acc3.Co_Applicant__c = 'Roy3';
        acc3.LoyaltyID__c = '6543783489';
        acc3.Legal_Alert__c = True;
        acc3.Collection_Index__c = 10.00;
        acc3.CIP__c = TRUE;
        acc3.Preferred_mode_of_Contact__c = 'Phone';
        // acc. Owner.name='David';
        acc3.Client_Type__c = 'NRI';
        acc3.Ethinicity__c = 'South Indian Hindu';
        acc3.Age__c = 20;
        acc3.Marital_Status__c = 'Unmarried';
        acc3.No_of_children__c = 5;
        acc3.Project_Name__c = 'New Cuffe Parade';
        acc3.Purpose_of_Purchase__c = 'Investment';
        acc3.Industry = 'Aluminium';
        accounts.add(acc3);
        insert accounts;
        list < Booking_Details__c > bdList = new list < Booking_Details__c > ();



        //for first accout booking details 
        Booking_Details__c bd1 = new Booking_Details__c();
        bd1.Account__c = accounts[0].id;
        bd1.CRN__c = accounts[0].CRN__c;
        bd1.Allotment_Date__c = Date.Today();
        bd1.Consideration_Value__c = 123000000;
        //formula field bd1.CV_paid_New__c =
        bd1.Flat_ID__c = 'ABCD11000';

        bdlist.add(bd1);

        //for Second accout booking details 
        Booking_Details__c bd2 = new Booking_Details__c();
        bd2.Account__c = accounts[1].id;
        bd2.CRN__c = accounts[1].CRN__c;
        bd2.Allotment_Date__c = Date.Today();
        bd2.Consideration_Value__c = 123000000;
        //formula field bd1.CV_paid_New__c =
        bd2.Flat_ID__c = 'ABCD12000';

        bdlist.add(bd2);

        //for third accout booking details 
        Booking_Details__c bd3 = new Booking_Details__c();
        bd3.Account__c = accounts[2].id;
        bd3.CRN__c = accounts[2].CRN__c;
        bd3.Allotment_Date__c = Date.Today();
        bd3.Consideration_Value__c = 123000000;
        //formula field bd1.CV_paid_New__c =
        bd3.Flat_ID__c = 'ABCD13000';


        bdlist.add(bd3);


        insert bdlist;
        //End Of booking Details creattion

        User objUser = ProfileInfoTest.createUser();
        insert objUser;


        SAPBookingIDAgentMapping_del__c objSAPBookingIDAgentMapping_del = new SAPBookingIDAgentMapping_del__c();
        objSAPBookingIDAgentMapping_del.Booking_ID__c = 'BK144521';
        objSAPBookingIDAgentMapping_del.Agent_Name__c = objUser.id;
        objSAPBookingIDAgentMapping_del.Wing__c = 'A';
        objSAPBookingIDAgentMapping_del.Project_Name__c = 'XYZ';
        objSAPBookingIDAgentMapping_del.Flat_No__c = '4';
        insert objSAPBookingIDAgentMapping_del;

        // insert Account
        Map < Integer, Case > caseMap = new Map < Integer, Case > ();
        Account objAccount = ProfileInfoTest.createAccount();
        insert objAccount;


        List < Case > lstCase1 = new List < Case > ();
        for (Integer i = 0; i < 11; i++) {
            Case objCase = new Case();
            objCase.AccountId = objAccount.Id;
            objCase.Project__c = 'XY';
            objCase.Buildings_Name__c = 'z';
            objCase.Wing__c = 'A';
            objCase.Flat_No__c = '4';
            objCase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Other Cases').getRecordTypeId();
            objCase.Status = 'New';

            objCase.Nature_of_Request__c = 'Complaint';
            objCase.Communication_Type__c = 'Outbound';
            objCase.Interaction_Mode__c = 'Email';
            objCase.Needs_approval_from_director__c = 'NO';
            objCase.Needs_approval_from_director__c = 'NO';
            objCase.Request_for_L1__c = 'Cancellation Related';
            objCase.Request_for_L2__c = 'Procedural information';
            objCase.Request_for_L3_a__c = 'Customer not contactable';
            objCase.Request_for_L3__c = 'Loan foreclosure';
            objCase.Case_Summary__c = 'testrooo';
            objCase.Case_Resolution__c = 'testooo';
            objCase.Date_of_Complaint__c = date.today();
            caseMap.put(i, objCase);
            lstCase1.add(objCase);
        }
        insert lstCase1;

        Test.startTest();
        ProfileInfoController PInfo = new ProfileInfoController ();
        PInfo.RMServiceIndex();
        PInfo.getmAccounts();
        PInfo.RMloyaltypt();
        PInfo.ExportToCSV();

        Test.stopTest();

    }
   /*Create User*/
    private static User createUser() {
        Profile objProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
        User objUser = new User(Alias = 'standt', Email = 'testUserNew@test.com',
            EmailEncodingKey = 'UTF-8', LastName = 'Tester', LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US', ProfileId = objProfile.Id,
            TimeZoneSidKey = 'America/Los_Angeles', UserName = 'amarjanuka@test.com');
        return objUser;
    }
    /*Create Account*/
    private static Account createAccount() {
        Account objAccount = new Account();
        objAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        objAccount.FirstName = 'Test1 ';
        objAccount.LastName = 'Account1';
        objAccount.CRN__c = '154215';
        objAccount.H_Mobile_No__c = '1234560789';
        objAccount.Mobile_Phone__c = '21241222';
        objAccount.Co_Applicant__c = 'test';
        return objAccount;



    }
   /*Rm Loyaltypoints*/
    public testmethod static void CoverRMLoyaltyPoint() {

        String PanNo = 'NNHSP6592M';
        //call data factory method which create account booking detail and demands in booking details 
        RMLoyaltyPointTest.createAccountForLoyaltyPoint(PanNo);

        // call for test 
        RMLoyaltyPoint rml1 = new RMLoyaltyPoint();
        RMLoyaltyPoint rml2 = new RMLoyaltyPoint(PanNo);
        System.assertNotEquals(rml2.Loyalty_Points_customer_specific, null);
        System.assertEquals(rml2.BookingSpecificLoyaties.size(), 3);
    }

    public static void createAccountForLoyaltyPoint(String panno) {

        //create Account and add to list and Insert
        list < Account > acclist = new list < Account > ();

        String AccoutnbookingCRN1 = '1245845';
        Account a1 = new Account();
        a1.Primary_PAN_number__c = panno;
        a1.AccountSource = 'Business Development';
        a1.CRN__c = AccoutnbookingCRN1;
        a1.lastname = 'testAccount1';
        a1.recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Booked Account').getRecordTypeId();
        acclist.add(a1);

        String AccoutnbookingCRN2 = '1245846';
        Account a2 = new Account();
        a2.Primary_PAN_number__c = panno;
        a2.AccountSource = 'Email';
        a2.CRN__c = AccoutnbookingCRN2;
        a2.lastname = 'testAccount2';
        a2.recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Booked Account').getRecordTypeId();
        acclist.add(a2);

        String AccoutnbookingCRN3 = '1245847';
        Account a3 = new Account();
        a3.Primary_PAN_number__c = panno;
        a3.AccountSource = 'Email';
        a3.CRN__c = AccoutnbookingCRN3;
        a3.lastname = 'testAccount2';
        a3.recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Booked Account').getRecordTypeId();
        acclist.add(a3);

        insert acclist;
        //End create Account and add to list and Insert 

        //Create Booking details of Account which have created above.   only one account contain only one booking details so only one record created of booking in account related 
        list < Booking_Details__c > bdList = new list < Booking_Details__c > ();

        //for first accout booking details 
        Booking_Details__c bd1 = new Booking_Details__c();
        bd1.Account__c = acclist[0].id;
        bd1.CRN__c = acclist[0].CRN__c;
        bd1.Allotment_Date__c = Date.Today();
        bd1.Consideration_Value__c = 123000000;
        //formula field bd1.CV_paid_New__c =
        bd1.Flat_ID__c = 'ABCD11000';

        bdlist.add(bd1);

        //for Second accout booking details 
        Booking_Details__c bd2 = new Booking_Details__c();
        bd2.Account__c = acclist[1].id;
        bd2.CRN__c = acclist[1].CRN__c;
        bd2.Allotment_Date__c = Date.Today();
        bd2.Consideration_Value__c = 123000000;
        //formula field bd1.CV_paid_New__c =
        bd2.Flat_ID__c = 'ABCD12000';

        bdlist.add(bd2);

        //for third accout booking details 
        Booking_Details__c bd3 = new Booking_Details__c();
        bd3.Account__c = acclist[2].id;
        bd3.CRN__c = acclist[2].CRN__c;
        bd3.Allotment_Date__c = Date.Today();
        bd3.Consideration_Value__c = 123000000;
        //formula field bd1.CV_paid_New__c =
        bd3.Flat_ID__c = 'ABCD13000';


        bdlist.add(bd3);


        insert bdlist;
        //End Of booking Details creattion


        //Start of Creating Demmands in booking Details Child ,Demand is child object of booking Details.
        List < Demands__c > demList = new List < Demands__c > ();

        //for first booking details  Demand
        Demands__c demand1 = new Demands__c();
        demand1.Flat_ID__c = bdlist[0].id;
        demand1.ExternalID__c = 'D1ABCD110001';
        demand1.Demand_amount__c = 50000;
        demList.add(demand1);

        //for first booking details  Demand   
        Demands__c demand2 = new Demands__c();
        demand2.Flat_ID__c = bdlist[0].id;
        demand2.ExternalID__c = 'D1ABCD110002';
        demand2.Demand_amount__c = 50000;
        demList.add(demand2);


        //for Second booking details  Demand   
        Demands__c demand3 = new Demands__c();
        demand3.Flat_ID__c = bdlist[1].id;
        demand3.ExternalID__c = 'D1ABCD120001';
        demand3.Demand_amount__c = 50000;
        demList.add(demand3);

        //for Second booking details  Demand      
        Demands__c demand4 = new Demands__c();
        demand4.Flat_ID__c = bdlist[1].id;
        demand4.ExternalID__c = 'D1ABCD120002';
        demand4.Demand_amount__c = 50000;
        demList.add(demand4);

        //for Third booking details  Demand   
        Demands__c demand5 = new Demands__c();
        demand5.Flat_ID__c = bdlist[2].id;
        demand5.ExternalID__c = 'D1ABCD130001';
        demand5.Demand_amount__c = 50000;
        demList.add(demand5);

        //for Third booking details  Demand        
        Demands__c demand6 = new Demands__c();
        demand6.Flat_ID__c = bdlist[2].id;
        demand6.ExternalID__c = 'D1ABCD130002';
        demand6.Demand_amount__c = 50000;
        demList.add(demand6);

        insert demList;

        list < Account > acctest = [select id from Account];
        list < Booking_Details__c > bdtest = [select id from Booking_Details__c];
        list < Demands__c > demtest = [select id from Demands__c];
        System.assertEquals(acctest.size(), 3);
        System.assertEquals(bdtest.size(), 3);
        System.assertEquals(demtest.size(), 6);

    }
    public testmethod static void CoverRMServiceIndex() {

        String crn = 'NNHSP6592M';
        //call data factory method which create accounts cases 
        RMServiceIndexTest.createAccountForServiceIndex(crn);

        // call for test 
        RMServiceIndex rmI1 = new RMServiceIndex();
        RMServiceIndex rmI2 = new RMServiceIndex(crn);

        System.assertNotEquals(rmI2.service_index_CustomerSpecific, null);
        System.assertEquals(rmI2.service_index_BookingSpecific.size(), 3);


        String crn2 = 'MNHSP6592N';
        //call data factory method which create accounts and 0 cases (case not created in account) 
        RMServiceIndexTest.createAccountWithoutCasesForServiceIndex(crn2);
        RMServiceIndex rmI3 = new RMServiceIndex();
        RMServiceIndex rmI4 = new RMServiceIndex(crn2);
        System.assertEquals(rmI4.service_index_CustomerSpecific, 100);
        System.assertEquals(rmI4.service_index_BookingSpecific.size(), 3);
    }

    public static void createAccountForServiceIndex(String crn) {




        //create Account and add to list and Insert
        list < Account > acclist = new list < Account > ();

        String AccoutnbookingCRN1 = '1245845';
        Account a1 = new Account();
        a1.CRN__c = crn;
        a1.AccountSource = 'Business Development';
        a1.CRN__c = AccoutnbookingCRN1;
        a1.lastname = 'testAccount1';
        a1.recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Booked Account').getRecordTypeId();
        acclist.add(a1);

        String AccoutnbookingCRN2 = '1245846';
        Account a2 = new Account();
        a2.CRN__c = crn;
        a2.AccountSource = 'Email';
        a2.CRN__c = AccoutnbookingCRN2;
        a2.lastname = 'testAccount2';
        a2.recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Booked Account').getRecordTypeId();
        acclist.add(a2);

        String AccoutnbookingCRN3 = '1245847';
        Account a3 = new Account();
        a3.CRN__c = crn;
        a3.AccountSource = 'Email';
        a3.CRN__c = AccoutnbookingCRN3;
        a3.lastname = 'testAccount2';
        a3.recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Booked Account').getRecordTypeId();
        acclist.add(a3);

        insert acclist;
        //End create Account and add to list and Insert 

        //Create Cases of the above inserted Accounts which have created above. 
        list < Case > caseList = new list < Case > ();

        list < string > Nature_request_list = new list < string > {
            'Complaint', 'Grievance', 'Request', 'Query'
        };
        list < string > status_list = new list < string > {
            'Closed Satisfied', 'Closed UnSatisfied', 'New ', 'Open'
        };

        for (account a: acclist) {
            for (string nature: Nature_request_list) {
                for (string status: status_list) {
                    Case c1 = new Case();
                    c1.AccountID = a.id;
                    c1.Interaction_Mode__c = 'Email';
                    c1.Communication_Type__c = 'Outbound';
                    c1.Nature_of_Request__c = nature;
                    c1.Status = status;
                    c1.recordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CSS Cases').getRecordTypeId();
                    c1.Case_Resolution__c = 'testResolution';
                    c1.Case_Summary__c = 'testSummary';
                    c1.Date_of_Complaint__c = Date.Today();
                    caseList.add(c1);
                }
              for (string status: status_list) {
                    Case c11 = new Case();
                    c11.AccountID = a.id;
                    c11.Interaction_Mode__c = 'Email';
                    c11.Communication_Type__c = 'Outbound';
                    c11.Nature_of_Request__c = nature;
                    c11.Status = status;
                    c11.recordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CSS Cases').getRecordTypeId();
                    c11.Case_Resolution__c = 'testResolution';
                    c11.Case_Summary__c = 'testSummary';
                    c11.Date_of_Complaint__c = Date.Today();
                    caseList.add(c11);   
            }
        }
        insert caselist;
    
}}


    public static void createAccountWithoutCasesForServiceIndex(String crn) {



        //create Account and add to list and Insert
        list < Account > acclist = new list < Account > ();

        String AccoutnbookingCRN1 = '1345845';
        Account a1 = new Account();

        a1.AccountSource = 'Business Development';
        a1.CRN__c = AccoutnbookingCRN1;
        a1.lastname = 'testAccount1';
        a1.recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Booked Account').getRecordTypeId();
        acclist.add(a1);

        String AccoutnbookingCRN2 = '1345846';
        Account a2 = new Account();

        a2.AccountSource = 'Email';
        a2.CRN__c = AccoutnbookingCRN2;
        a2.lastname = 'testAccount2';
        a2.recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Booked Account').getRecordTypeId();
        acclist.add(a2);

        String AccoutnbookingCRN3 = '1345847';
        Account a3 = new Account();

        a3.AccountSource = 'Email';
        a3.CRN__c = AccoutnbookingCRN3;
        a3.lastname = 'testAccount2';
        a3.recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Booked Account').getRecordTypeId();
        acclist.add(a3);

        insert acclist;
        //End create Account and add to list and Insert 


    }
}