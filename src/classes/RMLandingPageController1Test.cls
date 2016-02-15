/* 
Description:
test class for cover the RMLandingPage1 
controller class which is used in RM landing page Which opened from 
Pre landing page

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
public class RMLandingPageController1Test {

    public testmethod static void coverRMLandingPageController1() {

        String CRN_1 = '123456';
        string CRN_2 = '123457';

        //call method create data with user creation of account
        RMLandingPageController1Test.createDataForRMLandingPageController_1(CRN_1);
        //call method create data without user creation of account  
        RMLandingPageController1Test.createDataForRMLandingPageController_2(CRN_2);

        RMLandingPageController1Test.createColorCodeforPayments();


        Test.startTest();

        // Set mock callout class RestMockHttpResponseGenerator for the successfull response with my gain yes 
        Test.setMock(HttpCalloutMock.class, new RestMockHttpResponseGeneratorDataSet1());


        RestAPICalloutController rc1 = new RestAPICalloutController();

        System.assertNotEquals(null, rc1.parseCustomerInformationJSON('1210055'));

        // Set mock callout class RestMockHttpResponseGenerator for the successfull response with my gain value NO 
        Test.setMock(HttpCalloutMock.class, new RestMockHttpResponseGeneratorDataSet2());

        RestAPICalloutController rc2 = new RestAPICalloutController();

        System.assertNotEquals(null, rc2.parseCustomerInformationJSON('1210055'));

        // Set mock callout class RestMockHttpResponseGenerator for the unsuccessful response 
        Test.setMock(HttpCalloutMock.class, new RestMockHttpResponseGeneratorDataSet3());

        RestAPICalloutController rc3 = new RestAPICalloutController();
        system.debug(rc3.parseCustomerInformationJSON('1210055'));

        System.assertNotEquals(null, rc3.parseCustomerInformationJSON('1210055'));

        //schenario-1 where all type of data is avialable with user 
        PageReference pageRef_1 = new PageReference('/apex/RMLandingPage1?CRN=' + CRN_1);
        Test.setCurrentPage(pageRef_1);

        Test.setMock(HttpCalloutMock.class, new RestMockRMLandingPageDataSet());
        //  RestAPICalloutController rc1=new RestAPICalloutController ();


        RMLandingPageController1 rmcontr_1 = new RMLandingPageController1();
        if (rmcontr_1.account_obj != null) rmcontr_1.setWidgetSequence(rmcontr_1.account_obj);
        rmcontr_1.intializeAccount();
        rmcontr_1.gotoConstructionUpadatePage();

        //select and update order type of created projects
        list < project_name__c > prlist1 = [select id, OrderType__c from project_name__c];
        for (project_name__c pr: prlist1) {
            pr.OrderType__c = 'Custom';
        }
        update prlist1;
        if (rmcontr_1.account_obj != null) rmcontr_1.setWidgetSequence(rmcontr_1.account_obj);

        //select and update order type of created projects
        list < project_name__c > prlist2 = [select id, OrderType__c from project_name__c];
        for (project_name__c pr: prlist2) {
            pr.OrderType__c = 'Dynamic';
        }
        update prlist2;
        if (rmcontr_1.account_obj != null) rmcontr_1.setWidgetSequence(rmcontr_1.account_obj);

        //update again its original order type Default because it used in next page context
        list < project_name__c > prlist_orignal = [select id, OrderType__c from project_name__c];
        for (project_name__c pr: prlist_orignal) {
            pr.OrderType__c = 'Default';
        }
        update prlist_orignal;

        //schenario -2  where the user is not created for booked account
        PageReference pageRef_2 = new PageReference('/apex/RMLandingPage1?CRN=' + CRN_2);
        Test.setCurrentPage(pageRef_2);
        Test.setMock(HttpCalloutMock.class, new RestMockRMLandingPageDataSet());
        RMLandingPageController1 rmcontr_2 = new RMLandingPageController1();
        if (rmcontr_2.account_obj != null) rmcontr_2.setWidgetSequence(rmcontr_2.account_obj);

        //scenario -3  Test error condition that CRN no is not matched (Not found) with any existing account CRN
        PageReference pageRef_3 = new PageReference('/apex/RMLandingPage1?CRN=' + '455445445');
        Test.setCurrentPage(pageRef_3);
        Test.setMock(HttpCalloutMock.class, new RestMockRMLandingPageDataSet());
        RMLandingPageController1 rmcontr_3 = new RMLandingPageController1();
        
        //scenario -4  Test error condition that mobile no is empty
        PageReference pageRef_4 = new PageReference('/apex/RMLandingPage1?CRN=' + '');
        Test.setCurrentPage(pageRef_4);
        Test.setMock(HttpCalloutMock.class, new RestMockRMLandingPageDataSet());
        RMLandingPageController1 rmcontr_4 = new RMLandingPageController1();

        Test.stopTest();
    }
    //this method craete test data with user creation 
    public static void createDataForRMLandingPageController_1(string CRNparam) {
        //create project data and widget data
        List < Project_Name__c > projectList = RMLandingPageControllerTest.createProjectData();
        RMLandingPageControllerTest.createWidgetData();
        String AccoutnbookingCRN1 = CRNparam; //'1245845';
        Account a1 = new Account();
        a1.Primary_PAN_number__c = 'KLKL45127M';
        a1.AccountSource = 'Business Development';
        a1.CRN__c = AccoutnbookingCRN1;
        a1.lastname = 'testAccount1' + math.random();
        a1.recordtypeid = 
            Schema.SObjectType.Account.getRecordTypeInfosByName().get('Booked Account').getRecordTypeId();
        a1.Click_To_Call__c = '9856712345';
        a1.Preferred_Mode_of_Contact__c = 'Phone';
        a1.TDS_Related__c = 'Authorized Lodha to pay';
        a1.BillingCountry = 'India';
        a1.TRAI_DND__c = true;
        a1.Alternate_Designation__c = 'Manager';
        a1.Occupation_acc__c = 'Salaried';
        a1.Type_of_Home__c = '2 bhk';
        a1.Industry = 'IT Services';
        a1.Specify_Residences_owned_at_Lodha_group__c = '15';
        a1.Other_residences_owned_at_Lodha_Group_CC__c = 15;
        a1.Club_Membership__pc = 'cm';
        a1.Car_s_Owned__c = '5';
        a1.Assets_Owned_Homes__c = 15;
        a1.Current_Home_ownership__c = 'Owned';
        a1.Hobbies__c = 'Dancing';
        a1.Purpose_of_Purchase__c = 'Second Home';
        a1.Children_Names__c = 'aaa | bbbb';
        a1.Children_s_DOB__c = '12/01/1999 | 13/01/2001';
        a1.No_of_children__c = 2;
        a1.DOB_of_Spouse__c = date.newInstance(1970, 1, 1);
        a1.Spouse_Name__c = 'testspouce';
        a1.Anniversary_Date__c = date.newInstance(1997, 1, 1);
        a1.Age__c = 46;
        a1.Ethinicity__c = 'Bengali';
        a1.DOB_Of_Client__c = date.newInstance(1969, 1, 1);
        a1.PersonEmail = 'test@lodhauser.com';
        a1.Person_email_from_trigger__c = 'testuser@mylodhamail.com';
        a1.Co_Applicant__c = 'PURNIMA SAGAR SHAH';
        a1.project_name__c = projectList[0].name;
        insert a1;
        account a = [select id, project_name__c from account where id = : a1.id];
        system.assertEquals(a.id, a1.id);
        System.debug('***project_name__c::' + a1.project_name__c + '::' + a.project_name__c);

        System.debug('***accListTest::' + a1.id + ':: ' + a1.CRN__c);

        //query enable disable
        list < Project_Name__c > prjctName = [Select Id,
        Name,
        OrderType__c, (Select Id,
        Name,
        WidgetInfo__c,
        WidgetInfo__r.Name,
        isEnableForRM__c,
        isEnableForCustomer__c
        From EnableDisable_widgets__r)
        From Project_Name__c p where Name = : projectList[0].name];
        System.debug('SizeEnableDisable:::::' + prjctName[0].EnableDisable_widgets__r.size());
        if (prjctName.size() > 0 && prjctName[0].EnableDisable_widgets__r.size() > 0) {
            for (EnableDisable_widgets__c EDWidget: prjctName[0].EnableDisable_widgets__r) {
                System.debug(EDWidget.WidgetInfo__c + '::::WWWWW::::' + EDWidget);
            }
        }



        Booking_Details__c bd1 = new Booking_Details__c();
        bd1.Account__c = a1.id;
        bd1.CRN__c = a1.CRN__c;
        bd1.Allotment_Date__c = Date.Today();
        bd1.Consideration_Value__c = 123000000;
        bd1.Project_Name__c = projectList[0].id;
        bd1.project__c = 'ProjectTest1';
        //formula field bd1.CV_paid_New__c =
        bd1.Flat_ID__c = 'ABCD11000';

        insert bd1;
        Booking_Details__c bd = [select id from Booking_Details__c where id = : bd1.id];
        system.assertEquals(bd.id, bd1.id);

        Booking_Information__c bi1 = new Booking_Information__c();
        bi1.CRN_Number_SAP__c = a1.CRN__c;
        bi1.Stilt_Parkings__c = 1;
        bi1.Other_Parkings__c = 2;
        bi1.Open_Parkings__c = 1;
        bi1.MLCP_Parkings__c = 2;
        bi1.Closed_Parkings__c = 1;

        insert bi1;
        Booking_Information__c bi = [select id from Booking_Information__c where id = : bi1.id];
        system.assertEquals(bi.id, bi1.id);


        //create community user 
        Profile profl = [select id, name from profile where name = 
            'Custom Overage High Volume Customer Portal'
        Limit 1];

        contact c1 = [select id from contact where accountid = : a1.id limit 1];



        User usr = new User();
        usr.LastName = a1.lastname;
        usr.Alias = a1.LastName.subString(0, 8);
        usr.Email = 'testkapex@gmail.com';
        usr.Username = a1.LastName + '@force.com';
        // usr.CommunityNickname=Customer_contact[i].LastName;
        usr.UserPermissionsChatterAnswersUser = true;
        usr.IsActive = true;
        // usr.IsPortalEnabled=true;
        usr.TimeZoneSidKey = 'GMT';
        usr.LanguageLocaleKey = 'en_US';
        usr.profileID = profl.id;
        usr.contactID = c1.id;
        usr.LocaleSidKey = 'en_US';
        usr.EmailEncodingKey = 'ISO-8859-1';
        //usr.communityNickname=('Test'+Math.random()).subString(0,8);

        Insert usr;

        user u = [select id from user where id = : usr.id limit 1];
        system.assertEquals(u.id, usr.id);
        LoginPageCSS2_0Controller loginController = new LoginPageCSS2_0Controller();
        loginController.username = usr.Username;
        loginController.password = 'abcd@1234';
        System.debug(loginController.login());

        /*thera are already craeted trigger which update project name value on
         Account so we have to write trigger on Booking detail 
        so we have to again assign project name field on account then update it */   
        a1.project_name__c = projectList[0].name;
        update a1;
    }

    //this method craete test data with user creation 
    public static void createDataForRMLandingPageController_2(string CRNparam) {

        //create project data and widget data
        List < Project_Name__c > projectList = [select id, name, OrderType__c 
                    from project_name__c];
      
        //RMLandingPageControllerTest.createWidgetData();



        String AccoutnbookingCRN1 = CRNparam; //'1245845';
        Account a1 = new Account();
        a1.Primary_PAN_number__c = 'KLKL45127M';
        a1.AccountSource = 'Business Development';
        a1.CRN__c = AccoutnbookingCRN1;
        a1.lastname = 'testAccount1' + math.random();
        a1.recordtypeid = 
            Schema.SObjectType.Account.getRecordTypeInfosByName().get('Booked Account').getRecordTypeId();
        a1.Click_To_Call__c = '9856712346';
        a1.Preferred_Mode_of_Contact__c = 'Phone';
        a1.TDS_Related__c = 'Authorized Lodha to pay';
        a1.BillingCountry = 'India';
        a1.TRAI_DND__c = true;
        a1.Alternate_Designation__c = 'Manager';
        a1.Occupation_acc__c = 'Salaried';
        a1.Type_of_Home__c = '2 bhk';
        a1.Industry = 'IT Services';
        a1.Specify_Residences_owned_at_Lodha_group__c = '15';
        a1.Other_residences_owned_at_Lodha_Group_CC__c = 15;
        a1.Club_Membership__pc = 'cm';
        a1.Car_s_Owned__c = '5';
        a1.Assets_Owned_Homes__c = 15;
        a1.Current_Home_ownership__c = 'Owned';
        a1.Hobbies__c = 'Dancing';
        a1.Purpose_of_Purchase__c = 'Second Home';
        a1.Children_Names__c = 'aaa | bbbb';
        a1.Children_s_DOB__c = '12/01/1999 | 13/01/2001';
        a1.No_of_children__c = 2;
        a1.DOB_of_Spouse__c = date.newInstance(1970, 1, 1);
        a1.Spouse_Name__c = 'testspouce';
        a1.Anniversary_Date__c = date.newInstance(1997, 1, 1);
        a1.Age__c = 46;
        a1.Ethinicity__c = 'Bengali';
        a1.DOB_Of_Client__c = date.newInstance(1969, 1, 1);
        a1.PersonEmail = 'test@lodhauser.com';
        a1.Person_email_from_trigger__c = 'testuser@mylodhamail.com';
        a1.Co_Applicant__c = 'PURNIMA SAGAR SHAH';
        a1.project_name__c = projectList[0].name;
        insert a1;
        account a = [select id, project_name__c from account where id = : a1.id];
        system.assertEquals(a.id, a1.id);
        System.debug('***project_name__c::' + a1.project_name__c + '::' + a.project_name__c);

        System.debug('***accListTest::' + a1.id + ':: ' + a1.CRN__c);

        //query enable disable
        list < Project_Name__c > prjctName = [Select Id,
                                                Name,
                                                OrderType__c, (Select Id,
                                                Name,
                                                WidgetInfo__c,
                                                WidgetInfo__r.Name,
                                                isEnableForRM__c,
                                                isEnableForCustomer__c
                                                From EnableDisable_widgets__r)
                                                From Project_Name__c p where Name = : projectList[0].name];

        // map < Id, EnableDisable_widgets__c > enableDisableMap = new map < Id, EnableDisable_widgets__c > ();
        System.debug('SizeEnableDisable:::::' + prjctName[0].EnableDisable_widgets__r.size());
        if (prjctName.size() > 0 && prjctName[0].EnableDisable_widgets__r.size() > 0) {
            for (EnableDisable_widgets__c EDWidget: prjctName[0].EnableDisable_widgets__r) {
                System.debug(EDWidget.WidgetInfo__c + '::::WWWWW::::' + EDWidget);
            }
        }



        Booking_Details__c bd1 = new Booking_Details__c();
        bd1.Account__c = a1.id;
        bd1.CRN__c = a1.CRN__c;
        bd1.Allotment_Date__c = Date.Today();
        bd1.Consideration_Value__c = 123000000;
        bd1.Project_Name__c = projectList[0].id;
        bd1.project__c = 'ProjectTest1';
        //formula field bd1.CV_paid_New__c =
        bd1.Flat_ID__c = 'ABCD11000';

        insert bd1;
        Booking_Details__c bd = [select id from Booking_Details__c where id = : bd1.id];
        system.assertEquals(bd.id, bd1.id);

        Booking_Information__c bi1 = new Booking_Information__c();
        bi1.CRN_Number_SAP__c = a1.CRN__c;
        bi1.Stilt_Parkings__c = 1;
        bi1.Other_Parkings__c = 2;
        bi1.Open_Parkings__c = 1;
        bi1.MLCP_Parkings__c = 2;
        bi1.Closed_Parkings__c = 1;
        bi1.PAN_Number_of_Co_Applicant__c='AH165764';

        insert bi1;
        Booking_Information__c bi = [select id from Booking_Information__c where id = : bi1.id];
        system.assertEquals(bi.id, bi1.id);


        //create community user 
        Profile profl = [select id, name from profile where name = 
            'Custom Overage High Volume Customer Portal'
        Limit 1];

        contact c1 = [select id from contact where accountid = : a1.id limit 1];

        //thera are already craeted trigger which update project name value on Account so we have to write trigger on Booking detail 
        //so we have to again assign project name field on account then update it .   
        a1.project_name__c = projectList[0].name;
        update a1;
    }

    public static void createColorCodeforPayments() {
        List < PaymentsColorCodes__c > PaymentsColorCodes_List = new List < PaymentsColorCodes__c > ();
        PaymentsColorCodes__c PaymentsColorCode_obj1 = 
            new PaymentsColorCodes__c(name = 'PaymentRecievedAfterDue', Color_Code__c = 'Red', No_of_days__c = 0);
        PaymentsColorCodes__c PaymentsColorCode_obj2 = 
            new PaymentsColorCodes__c(name = 'PaymentRecievedBeforeDue', Color_Code__c = 'Green', No_of_days__c = 0);
        PaymentsColorCodes__c PaymentsColorCode_obj3 = 
            new PaymentsColorCodes__c(name = 'UpcomingPayments0daysLeft', Color_Code__c = 'Red', No_of_days__c = 0);
        PaymentsColorCodes__c PaymentsColorCode_obj4 = 
            new PaymentsColorCodes__c(name = 'UpcomingPayments3daysLeft', Color_Code__c = '#FF9721', No_of_days__c = -3);
        PaymentsColorCodes__c PaymentsColorCode_obj5 = 
            new PaymentsColorCodes__c(name = 'UpcomingPayments4daysLeft', Color_Code__c = 'Green', No_of_days__c = -4);

        PaymentsColorCodes_List.add(PaymentsColorCode_obj1);
        PaymentsColorCodes_List.add(PaymentsColorCode_obj2);
        PaymentsColorCodes_List.add(PaymentsColorCode_obj3);
        PaymentsColorCodes_List.add(PaymentsColorCode_obj4);
        PaymentsColorCodes_List.add(PaymentsColorCode_obj5);
        insert PaymentsColorCodes_List;
        system.debug('Custom Setting :::::::::::::' + PaymentsColorCodes_List);
    }

    public static list < Project_name__c > createProjectData() {

        list < Project_Name__c > plist = new list < Project_Name__c > ();

        Project_Name__c p1 = new Project_Name__c();
        p1.name = 'ProjectTest1';
        p1.Project_Type__c = 'Casa';
        p1.Record_Type__c = 'Residential';
        //p1.CurrencyIsoCode='INR - Indian Rupee';
        p1.Location__c = 'abc';
        p1.OrderType__c = 'Default';
        plist.add(p1);

        Project_Name__c p2 = new Project_Name__c();
        p2.name = 'ProjectTest2';
        p2.Project_Type__c = 'Casa';
        p2.Record_Type__c = 'Residential';
        //p2.CurrencyIsoCode='INR - Indian Rupee';
        p2.Location__c = 'abc';
        p2.OrderType__c = 'Default';
        plist.add(p2);

        Project_Name__c p3 = new Project_Name__c();
        p3.name = 'ProjectTest3';
        p3.Project_Type__c = 'Casa';
        p3.Record_Type__c = 'Residential';
        //p3.CurrencyIsoCode='INR - Indian Rupee';
        p3.Location__c = 'abc';
        p3.OrderType__c = 'Default';
        plist.add(p3);

        insert plist;
        
        System.assertEquals(plist.size(), [select id from project_name__c].size());
        return plist;
    }

    public static void createWidgetData() {

        //create list of widget info object 
        list < WidgetInfo__c > wlist1 = new list < WidgetInfo__c > ();

        //create objects of widgetinfo  and add to widget info list
        WidgetInfo__c w1 = new WidgetInfo__c();
        w1.name = 'Recent Activity';
        w1.Available_For__c = 'Both';
        wlist1.add(w1);

        WidgetInfo__c w2 = new WidgetInfo__c();
        w2.name = 'Booking Payments Transactions';
        w2.Available_For__c = 'RM';
        wlist1.add(w2);

        WidgetInfo__c w3 = new WidgetInfo__c();
        w3.name = 'Booking Details';
        w3.Available_For__c = 'CSS';
        wlist1.add(w3);

        //insert widget info list records 
        insert wlist1;
        System.assertEquals(wlist1.size(), [select id from WidgetInfo__c].size());

    }
}