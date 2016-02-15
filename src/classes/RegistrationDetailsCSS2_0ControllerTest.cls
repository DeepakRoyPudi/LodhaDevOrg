/* 
Description: Test Class ForRegistrationDetailsCSS2_0Controller
@Created by: Aditi Mulmule
@Created Date: 

--------------------------------------------------------------------------------
| Modified By      | Modified Date       | Version        | Description         |
--------------------------------------------------------------------------------
|Aditi Mulmule        23/06/2015
---------------------------------------------------------------------------------
|Aditi Mulmule        07/07/2015                          1.Added Test methods for
draft link functionality

---------------------------------------------------------------------------------
*/
@isTest(seeAllData=false)
public class RegistrationDetailsCSS2_0ControllerTest{ 
    //method to test controller
    static testmethod void controllerTest() {
        //create account
        Account objAccount = createAccount();
        insert objAccount;
        //query account to get contact id of related account
        
        Account insertedAccountwithcontact=[Select Id,
                                            Name,
                                            (select id from contacts ) 
                                            From account 
                                            Where id=:objAccount.id];
        Id conid = insertedAccountwithcontact.contacts[0].id ;
        
        Case caseObj = new Case();
        caseObj.RecordTypeId  = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CM_Parent_Only').getRecordTypeId();
        caseObj.Interaction_Mode__c= 'CSS';
        caseObj.Nature_of_Request__c= 'Query';
        caseObj.Communication_Type__c = 'Inbound';
        caseObj.Date_Confirm_Time_place_of_Registratio__c = System.Today()+10;
        caseObj.Date_Request_for_rescheduling_the_regist__c =System.Today()+10; 
        caseObj.AccountId = insertedAccountwithcontact.Id;
        caseObj.Request_for_L1__c='Registration Related';
        caseObj.Request_for_L2__c='Scheduling (SDR already paid)';
        caseObj.Request_for_L3__c ='Confirm Time & place of Registration';
        
        
        //create user
        User objUser = createUser(conid);
        insert objUser;
        
        //insert values for Registration Link and Draft Aggreement Link in Custom Setting
        Customer360AndCSS2_0Links01__c setting1 = 
            new Customer360AndCSS2_0Links01__c(name='RegistrationGuidelines',Links__c='www.google.com');
        insert setting1;
        Customer360AndCSS2_0Links01__c setting2 = 
            new Customer360AndCSS2_0Links01__c(name='DraftAgreementLink',Links__c='www.google.com');
        insert setting2;
   
        
        //Registration Link and Draft Agreement Link From Custom Setting
        String regLink;
        //String draftLink;
        RMCSS2_0CustomSettingLinkController csslinks=new RMCSS2_0CustomSettingLinkController();
        regLink = csslinks.getRegistrationLink();
        //draftLink = csslinks.getDemanddraftLink();
        PageReference pageRef = Page.RegistrationDetailsCSS2_0; 
        system.Test.setCurrentPage(pageRef);
        
        
        RegistrationDetailsCSS2_0Controller RegistrationDetailsObject;
        system.runAs(objUser){
            
            insert caseObj;
            
            System.assertEquals([select id from case].size(),1); 
            
            Test.setMock(HttpCalloutMock.class, new RestMockHttpResponseGeneratorDataSet1());
            Test.startTest();
            RestAPICalloutController rc1=new RestAPICalloutController ();
            RestAPICalloutController.CustomerInformationWrapper RestAPICallout_wrapper_obj =
            new  RestAPICalloutController.CustomerInformationWrapper();
            RestAPICallout_wrapper_obj = rc1.parseCustomerInformationJSON('1251333');    
            System.assertNotEquals(null,rc1.parseCustomerInformationJSON('1251333')); 
        
        // Set mock callout class RestMockHttpResponseGenerator for the successfull response with my gain value NO 
           Test.setMock(HttpCalloutMock.class, new RestMockHttpResponseGeneratorDataSet2());  
           RestAPICalloutController rc2=new RestAPICalloutController ();
           Test.stopTest(); 
            
            RegistrationDetailsObject = new RegistrationDetailsCSS2_0Controller();
        }
        
        RegistrationDetailsObject.userId = objUser.Id;
        
        RegistrationDetailsObject.account_obj.Owner.Email='abc@gmail.com';
        
       // RegistrationDetailsObject.toggleEdit();
      /*  RegistrationDetailsObject.reSchedule_Date = '24/06/2015';
        RegistrationDetailsObject.reSchedule_time = '03:59 PM';
        RegistrationDetailsObject.virtualcase.Stage_Date__c=System.Today()+10;
        RegistrationDetailsObject.virtualTime=System.now().time(); */
       // RegistrationDetailsObject.sendEmailToRM();
        
      /*  System.assertNotEquals(null,RegistrationDetailsObject.response); 
        System.assertEquals(System.Label.Registration_success_response,RegistrationDetailsObject.response); 
       // RegistrationDetailsObject.toggleEdit(); */
        
        //Error condition for null values in stage date and virtual time
     /*   RegistrationDetailsObject.reSchedule_Date = '21/06/2015';
        RegistrationDetailsObject.reSchedule_time = '03:59 PM';
        RegistrationDetailsObject.virtualcase.Stage_Date__c=null;
        RegistrationDetailsObject.virtualTime=null; */
      //  RegistrationDetailsObject.sendEmailToRM();
    //    System.assert(ApexPages.getMessages()[0].getDetail().contains(system.label.registration_date_validate));
        
        //Error condition for null value  virtual time
      /*  RegistrationDetailsObject.toggleEdit();
        RegistrationDetailsObject.reSchedule_Date = '21/06/2015';
        RegistrationDetailsObject.reSchedule_time = '03:59 PM';
        RegistrationDetailsObject.virtualcase.Stage_Date__c=System.Today()+10;
        RegistrationDetailsObject.virtualTime=null; */
      //  RegistrationDetailsObject.sendEmailToRM();
   //     System.assert(ApexPages.getMessages()[1].getDetail().contains(system.label.registration_time_validation));
       // RegistrationDetailsObject.closePopup();
    //    System.assertEquals(regLink,'http://www.google.com'); 
        //System.assertEquals(draftLink,'http://www.google.com'); 
        
    
    }    
    
    //method to test when there is no related case existing
    static testmethod void noRelatedCaseTest() {
        //create account
        Account objAccount = createAccount();
        insert objAccount;
        //query account to get contact id of related account
        
        Account insertedAccountwithcontact=[Select Id,
                                            Name,
                                            (select id from contacts ) 
                                            From account 
                                            Where id=:objAccount.Id];
        Id conid = insertedAccountwithcontact.contacts[0].Id ;
        
        Case caseObj = new Case();
        caseObj.RecordTypeId  = 
            Schema.SObjectType.Case.getRecordTypeInfosByName().get('CM_Parent_Only').getRecordTypeId();
        caseObj.Interaction_Mode__c= 'CSS';
        caseObj.Nature_of_Request__c= 'Query';
        caseObj.Communication_Type__c = 'Inbound';
        caseObj.Date_Confirm_Time_place_of_Registratio__c = System.Today()+10;
        caseObj.Date_Request_for_rescheduling_the_regist__c =System.Today()+10; 
        caseObj.AccountId = insertedAccountwithcontact.Id;
        caseObj.Request_for_L1__c='Payment Related';
        caseObj.Request_for_L2__c='Payment info on portal';
        caseObj.Request_for_L3__c ='Info not reflecting on portal'; 
        caseObj.Request_for_L3_a__c = 'Info not reflecting on portal';
        
        //create user
        User objUser = createUser(conid);
        insert objUser;
        
        
        //insert values for Registration Link and Draft Aggreement Link in Custom Setting
        Customer360AndCSS2_0Links01__c setting1 =
            new Customer360AndCSS2_0Links01__c(name='RegistrationGuidelines',Links__c='www.google.com');
        insert setting1;
        Customer360AndCSS2_0Links01__c setting2 = 
            new Customer360AndCSS2_0Links01__c(name='DraftAgreementLink',Links__c='www.google.com');
        insert setting2;
        
        //Registration Link and Draft Agreement Link From Custom Setting
        String regLink;
        //String draftLink;
        RMCSS2_0CustomSettingLinkController csslinks=new RMCSS2_0CustomSettingLinkController();
        regLink = csslinks.getRegistrationLink();
        //draftLink = csslinks.getDemanddraftLink();
        PageReference pageRef = Page.RegistrationDetailsCSS2_0; 
        system.Test.setCurrentPage(pageRef);
        
        
        RegistrationDetailsCSS2_0Controller RegistrationDetailsObject;
        system.runAs(objUser){
            
            insert caseObj;
            
            System.assertEquals([select id from case].size(),1); 
            
            //Test.setMock(HttpCalloutMock.class, new RestMockHttpResponseGeneratorDataSet1());
            Test.setMock(HttpCalloutMock.class, new RestMockHttpResponseGeneratorDataSet1());
            Test.startTest();
            RestAPICalloutController rc1=new RestAPICalloutController ();
            RestAPICalloutController.CustomerInformationWrapper RestAPICallout_wrapper_obj =
            new  RestAPICalloutController.CustomerInformationWrapper();
            RestAPICallout_wrapper_obj = rc1.parseCustomerInformationJSON('1251333');    
            System.assertNotEquals(null,rc1.parseCustomerInformationJSON('1251333')); 
        
        // Set mock callout class RestMockHttpResponseGenerator for the successfull response with my gain value NO 
           Test.setMock(HttpCalloutMock.class, new RestMockHttpResponseGeneratorDataSet2());  
           RestAPICalloutController rc2=new RestAPICalloutController ();
           Test.stopTest();
            
            RegistrationDetailsObject = new RegistrationDetailsCSS2_0Controller();
        }
        RegistrationDetailsObject.userId = objUser.Id;
        RegistrationDetailsObject.account_obj.Owner.Email='abc@gmail.com';
     //   RegistrationDetailsObject.sendEmailToRM();
  //      System.assert(ApexPages.getMessages()[0].getDetail().contains(system.label.Registration_case_does_not_exist));
    //    RegistrationDetailsObject.toggleEdit(); 
    //    RegistrationDetailsObject.closePopup();
        
        System.assertEquals(regLink,'http://www.google.com'); 
        //System.assertEquals(draftLink,'http://www.google.com'); 
    }    
    // cv paid in between 9% and 35%
    static testmethod void draftLinkTestLinkVisible() {
        
        Account objAccount = createAccount();
        insert objAccount;
        //query account to get contact id of related account
        
        Account insertedAccountwithcontact=[Select Id,
                                            Name,
                                            (select id from contacts ) 
                                            From account 
                                            Where id=:objAccount.id];
        Id accId = insertedAccountwithcontact.Id;                              
        Id conid = insertedAccountwithcontact.contacts[0].id ;
        
        Case caseObj = createCase(accId);
        
        Booking_Details__c objBooking_Details = createBookingObj(objAccount.CRN__c,objAccount.Id);
        objBooking_Details.Consideration_Value__c = 71510000.00;
        insert objBooking_Details;
        
        Demands__c demand1 = new Demands__c();
        demand1.Flat_ID__c = objBooking_Details.id;
        demand1.ExternalID__c = 'D1ABCD110001';
        demand1.Demand_amount__c = 60000;
        demand1.Amount_received__c = 25000000.00;
        insert demand1;
        
        Booking_Details__c obj = [Select CV_paid__c from Booking_Details__c where id=:objBooking_Details.id];
        
        
        BoxConfiguration__c settingbox =
            new BoxConfiguration__c(name='190',
                                    Box_Agreement_Url__c='https://app.box.com/shared/static/zfnzentqeokvwmir6h1e.pdf',
                                    Cluster_Name__c='Dioro',
                                    Is_Available__c=true,
                                    Legal_Name__c='NCP - elisium and dioro',
                                    Project_Location__c='Wadala',
                                    Project_Name__c='NEW CUFFE PARADE');
        insert settingbox;
        
        
        View_Agreement_CV_Limits__c  setting_view = new View_Agreement_CV_Limits__c(CV_Paid_Lower_Limit__c=5.00,CV_Paid_Upper_Limit__c=35.00);
        insert setting_view;
        
        
        //create user
        User objUser = createUser(conid);
        insert objUser;
        
        //insert values for Registration Link and Draft Aggreement Link in Custom Setting
        Customer360AndCSS2_0Links01__c setting1 = 
            new Customer360AndCSS2_0Links01__c(name='RegistrationGuidelines',Links__c='www.google.com');
        insert setting1;
        Customer360AndCSS2_0Links01__c setting2 = 
            new Customer360AndCSS2_0Links01__c(name='DraftAgreementLink',Links__c='www.google.com');
        insert setting2;
        
        //Registration Link and Draft Agreement Link From Custom Setting
        String regLink;
        //String draftLink;
        RMCSS2_0CustomSettingLinkController csslinks=new RMCSS2_0CustomSettingLinkController();
        regLink = csslinks.getRegistrationLink();
        //draftLink = csslinks.getDemanddraftLink();
        PageReference pageRef = Page.RegistrationDetailsCSS2_0; 
        
        
        system.Test.setCurrentPage(pageRef);
        
        RegistrationDetailsCSS2_0Controller RegistrationDetailsObject;
        system.runAs(objUser){
             Test.setMock(HttpCalloutMock.class, new RestMockHttpResponseGeneratorDataSet1());
             Test.startTest();
             RestAPICalloutController rc1=new RestAPICalloutController ();
             RestAPICalloutController.CustomerInformationWrapper RestAPICallout_wrapper_obj =
             new  RestAPICalloutController.CustomerInformationWrapper();
             RestAPICallout_wrapper_obj = rc1.parseCustomerInformationJSON('1251333');    
             System.assertNotEquals(null,rc1.parseCustomerInformationJSON('1251333')); 
        
        // Set mock callout class RestMockHttpResponseGenerator for the successfull response with my gain value NO 
            Test.setMock(HttpCalloutMock.class, new RestMockHttpResponseGeneratorDataSet2());  
            RestAPICalloutController rc2=new RestAPICalloutController ();
            Test.stopTest();
            RegistrationDetailsObject = new RegistrationDetailsCSS2_0Controller();
            insert caseObj;
            
            System.assertEquals([select id from case].size(),1); 
        }
        
        //     RegistrationDetailsCSS2_0Controller.STRHYDERABAD = 'Hyderabad';
        RegistrationDetailsObject.enableViewAgreementButton();
        RegistrationDetailsObject.strDocumentId = 'adyuip';
        RegistrationDetailsObject.strAgreementUrl ='http://www.google.com';
        RegistrationDetailsObject.viewAgreement();
        
        
        RegistrationDetailsObject.account_obj.Owner.Email='abc@gmail.com';
      //  RegistrationDetailsObject.toggleEdit();
    //    RegistrationDetailsObject.reSchedule_Date = '24/06/2015';
    //    RegistrationDetailsObject.reSchedule_time = '03:59 PM';
        //RegistrationDetailsObject.virtualcase.Stage_Date__c=System.Today()+10;
    //    RegistrationDetailsObject.virtualTime=System.now().time();
        //RegistrationDetailsObject.sendEmailToRM();
       // RegistrationDetailsObject.closePopup();
        System.assertEquals(regLink,'http://www.google.com'); 
        //System.assertEquals(draftLink,'http://www.google.com'); 
        
     
    }  
    static testmethod void draftLinkTestMessageVisible() {
        
        Account objAccount = createAccount();
        insert objAccount;
        //query account to get contact id of related account
        
        Account insertedAccountwithcontact=[Select Id,
                                            Name,
                                            (select id from contacts ) 
                                            From account 
                                            Where id=:objAccount.id];
        Id accId = insertedAccountwithcontact.Id;                              
        Id conid = insertedAccountwithcontact.contacts[0].id ;
        
        Case caseObj = createCase(accId);
        
        Booking_Details__c objBooking_Details = createBookingObj(objAccount.CRN__c,objAccount.Id);
        objBooking_Details.Consideration_Value__c = 7151000000.00;
        insert objBooking_Details;
        
        Demands__c demand1 = new Demands__c();
        demand1.Flat_ID__c = objBooking_Details.id;
        demand1.ExternalID__c = 'D1ABCD110001';
        demand1.Demand_amount__c = 60000;
        demand1.Amount_received__c = 2500.00;
        insert demand1;
        
        Booking_Details__c obj = [Select CV_paid__c from Booking_Details__c where id=:objBooking_Details.id];
        
        BoxConfiguration__c settingbox =
            new BoxConfiguration__c(name='190',
                                    Box_Agreement_Url__c='https://app.box.com/shared/static/zfnzentqeokvwmir6h1e.pdf',
                                    Cluster_Name__c='Dioro',
                                    Is_Available__c=true,
                                    Legal_Name__c='NCP - elisium and dioro',
                                    Project_Location__c='Wadala',
                                    Project_Name__c='NEW CUFFE PARADE');
        insert settingbox;
        
        
        View_Agreement_CV_Limits__c  setting_view = new View_Agreement_CV_Limits__c(CV_Paid_Lower_Limit__c=5.00,CV_Paid_Upper_Limit__c=35.00);
        insert setting_view;
        
        
        //create user
        User objUser = createUser(conid);
        insert objUser;
        
        //insert values for Registration Link and Draft Aggreement Link in Custom Setting
        Customer360AndCSS2_0Links01__c setting1 = 
            new Customer360AndCSS2_0Links01__c(name='RegistrationGuidelines',Links__c='www.google.com');
        insert setting1;
        Customer360AndCSS2_0Links01__c setting2 = 
            new Customer360AndCSS2_0Links01__c(name='DraftAgreementLink',Links__c='www.google.com');
        insert setting2;
        
        //system.runAs(objUser){
        
        
        Test.setMock(HttpCalloutMock.class, new RestMockHttpResponseGeneratorDataSet1());
        Test.startTest();
        RestAPICalloutController rc1=new RestAPICalloutController ();
        RestAPICalloutController.CustomerInformationWrapper RestAPICallout_wrapper_obj =
            new  RestAPICalloutController.CustomerInformationWrapper();
        RestAPICallout_wrapper_obj = rc1.parseCustomerInformationJSON('1251333');    
        System.assertNotEquals(null,rc1.parseCustomerInformationJSON('1251333')); 
        
        // Set mock callout class RestMockHttpResponseGenerator for the successfull response with my gain value NO 
        Test.setMock(HttpCalloutMock.class, new RestMockHttpResponseGeneratorDataSet2());  
        RestAPICalloutController rc2=new RestAPICalloutController ();
        Test.stopTest();
        
        //Registration Link and Draft Agreement Link From Custom Setting
        String regLink;
        //String draftLink;
        RMCSS2_0CustomSettingLinkController csslinks=new RMCSS2_0CustomSettingLinkController();
        regLink = csslinks.getRegistrationLink();
        //draftLink = csslinks.getDemanddraftLink();
        PageReference pageRef = Page.RegistrationDetailsCSS2_0; 
        
        
        system.Test.setCurrentPage(pageRef);
        
        RegistrationDetailsCSS2_0Controller RegistrationDetailsObject;
        
        System.runAs(objUser){
            RegistrationDetailsObject = new RegistrationDetailsCSS2_0Controller();
            insert caseObj;
            
            System.assertEquals([select id from case].size(),1); 
        }
        
        RegistrationDetailsObject.enableViewAgreementButton();
        RegistrationDetailsObject.strDocumentId = 'adyuip';
        RegistrationDetailsObject.strAgreementUrl ='http://www.google.com';
        RegistrationDetailsObject.viewAgreement();
        
        System.assertEquals(true,RegistrationDetailsObject.ShowMessage); 
        
        RegistrationDetailsObject.account_obj.Owner.Email='abc@gmail.com';
      //  RegistrationDetailsObject.toggleEdit();
     //   RegistrationDetailsObject.reSchedule_Date = '24/06/2015';
      //  RegistrationDetailsObject.reSchedule_time = '03:59 PM';
      //  RegistrationDetailsObject.sendEmailToRM();
     //   RegistrationDetailsObject.closePopup();
        System.assertEquals(regLink,'http://www.google.com'); 
        //System.assertEquals(draftLink,'http://www.google.com'); 
    }
    
    public static testmethod void draftLinkTestNothingVisible() {
        
        Account objAccount = createAccount();
        insert objAccount;
        //query account to get contact id of related account
        
        Account insertedAccountwithcontact=[Select Id,
                                            Name,
                                            (select id from contacts ) 
                                            From account 
                                            Where id=:objAccount.id];
        Id accId = insertedAccountwithcontact.Id;                              
        Id conid = insertedAccountwithcontact.contacts[0].id ;
        
        Case caseObj = createCase(accId);
        
        Booking_Details__c objBooking_Details = createBookingObj(objAccount.CRN__c,objAccount.Id);
        objBooking_Details.Consideration_Value__c = 71510000.00;
        insert objBooking_Details;
        
        Demands__c demand1 = new Demands__c();
        demand1.Flat_ID__c = objBooking_Details.id;
        demand1.ExternalID__c = 'D1ABCD110001';
        demand1.Demand_amount__c = 60000;
        demand1.Amount_received__c = 2500000000.00;
        insert demand1;
        
        Booking_Details__c obj = [Select CV_paid__c from Booking_Details__c where id=:objBooking_Details.id];
        
        BoxConfiguration__c settingbox =
            new BoxConfiguration__c(name='190',
                                    Box_Agreement_Url__c='https://app.box.com/shared/static/zfnzentqeokvwmir6h1e.pdf',
                                    Cluster_Name__c='Dioro',
                                    Is_Available__c=true,
                                    Legal_Name__c='NCP - elisium and dioro',
                                    Project_Location__c='Wadala',
                                    Project_Name__c='NEW CUFFE PARADE');
        insert settingbox;
        
        
        View_Agreement_CV_Limits__c  setting_view = new View_Agreement_CV_Limits__c(CV_Paid_Lower_Limit__c=5.00,CV_Paid_Upper_Limit__c=35.00);
        insert setting_view;
        
        
        //create user
        User objUser = createUser(conid);
        insert objUser;
        
        //insert values for Registration Link and Draft Aggreement Link in Custom Setting
        Customer360AndCSS2_0Links01__c setting1 = 
            new Customer360AndCSS2_0Links01__c(name='RegistrationGuidelines',Links__c='www.google.com');
        insert setting1;
        Customer360AndCSS2_0Links01__c setting2 = 
            new Customer360AndCSS2_0Links01__c(name='DraftAgreementLink',Links__c='www.google.com');
        insert setting2;
        
        //system.runAs(objUser){
        
        
        Test.setMock(HttpCalloutMock.class, new RestMockHttpResponseGeneratorDataSet1());
        Test.startTest();
        RestAPICalloutController rc1=new RestAPICalloutController ();
        RestAPICalloutController.CustomerInformationWrapper RestAPICallout_wrapper_obj =
            new  RestAPICalloutController.CustomerInformationWrapper();
        RestAPICallout_wrapper_obj = rc1.parseCustomerInformationJSON('1251333');    
        System.assertNotEquals(null,rc1.parseCustomerInformationJSON('1251333')); 
        
        // Set mock callout class RestMockHttpResponseGenerator for the successfull response with my gain value NO 
        Test.setMock(HttpCalloutMock.class, new RestMockHttpResponseGeneratorDataSet2());  
        RestAPICalloutController rc2=new RestAPICalloutController ();
        Test.stopTest();
        
        //Registration Link and Draft Agreement Link From Custom Setting
        String regLink;
        //String draftLink;
        RMCSS2_0CustomSettingLinkController csslinks=new RMCSS2_0CustomSettingLinkController();
        regLink = csslinks.getRegistrationLink();
        //draftLink = csslinks.getDemanddraftLink();
        PageReference pageRef = Page.RegistrationDetailsCSS2_0; 
        
        
        system.Test.setCurrentPage(pageRef);
        
        RegistrationDetailsCSS2_0Controller RegistrationDetailsObject;
        
        System.runAs(objUser){
            insert caseObj;
            
            System.assertEquals([select id from case].size(),1); 
            
            RegistrationDetailsObject = new RegistrationDetailsCSS2_0Controller();
        }
        
        RegistrationDetailsObject.enableViewAgreementButton();
        RegistrationDetailsObject.strDocumentId = 'adyuip';
        RegistrationDetailsObject.strAgreementUrl ='http://www.google.com';
        RegistrationDetailsObject.viewAgreement();
        
        System.assertEquals(false,RegistrationDetailsObject.ShowMessage); 
        
        RegistrationDetailsObject.account_obj.Owner.Email='abc@gmail.com';
      //  RegistrationDetailsObject.toggleEdit();
      //  RegistrationDetailsObject.reSchedule_Date = '24/06/2015';
      //  RegistrationDetailsObject.reSchedule_time = '03:59 PM';
        //RegistrationDetailsObject.virtualcase.Stage_Date__c=System.Today()+10;
      //  RegistrationDetailsObject.virtualTime=System.now().time();
      //  RegistrationDetailsObject.sendEmailToRM();
       // RegistrationDetailsObject.closePopup();
        System.assertEquals(regLink,'http://www.google.com'); 
        //System.assertEquals(draftLink,'http://www.google.com'); 
        
    }
    
    public static testMethod void enableViewAgreementNonHyderabadProject(){
        
        Account objAccount = createAccount();
        insert objAccount;
        
        Contact conObj = new Contact();
        conObj.FirstName = 'Test';
        conObj.LastName = 'Test';
        insert conObj;
        Account insertedAccountwithcontact=[Select Id,
                                            Name,
                                            (select id from contacts ) 
                                            From account 
                                            Where id=:objAccount.id];
        Id accId = insertedAccountwithcontact.Id;                              
        Id conid = insertedAccountwithcontact.contacts[0].id ;
        
        
        User objUser = createUser(conid);
        
        insert objUser;
        
        Date dAllotmentDate = System.today();
        Booking_Details__c ObjBookingDetail = new Booking_Details__c();
        ObjBookingDetail.CRN__c = '112233';
        ObjBookingDetail.Flat_ID__c = 'Test';
        ObjBookingDetail.Allotment_Date__c = dAllotmentDate;
        ObjBookingDetail.CLuster__c = 'testCluster';
        ObjBookingDetail.Project__c = 'testProject';
        ObjBookingDetail.Consideration_Value__c  = 1000000; 
        ObjBookingDetail.Account__c = objAccount.Id;
        insert ObjBookingDetail;
        
        List<BoxConfiguration__c> listTestBoxConfig= RegistrationDetailsCSS2_0ControllerTest.getBoxConfig(ObjBookingDetail.Project__c, 
                                                                                                          ObjBookingDetail.CLuster__c,
                                                                                                          'Mumbai');
        insert listTestBoxConfig;
        
        View_Agreement_CV_Limits__c oCVLimit = RegistrationDetailsCSS2_0ControllerTest.getCvLimit();
        insert oCVLimit;
        
        List<Demands__c> listTestDemands = RegistrationDetailsCSS2_0ControllerTest.getDemandRecord(1);
        listTestDemands[0].Flat_ID__c = ObjBookingDetail.Id;
        insert listTestDemands;
        
        update ObjBookingDetail;
        
        List<Project_Name__c> listTestProjectName = RegistrationDetailsCSS2_0ControllerTest.getProjectNameRecord(1);
        insert listTestProjectName;
        
        List<Cluster__c> listTestCluster = new List<Cluster__c>();
        
        test.startTest();
        
        //System.runAs(objUser){
        Test.setMock(HttpCalloutMock.class, new RestMockHttpResponseGeneratorDataSet1());
        
        // Test.startTest();
        RestAPICalloutController rc1=new RestAPICalloutController ();
        
        RestAPICalloutController.CustomerInformationWrapper RestAPICallout_wrapper_obj = 
            new  RestAPICalloutController.CustomerInformationWrapper();
        RestAPICallout_wrapper_obj = rc1.parseCustomerInformationJSON('1210055');    
        System.assertNotEquals(null,rc1.parseCustomerInformationJSON('1210055')); 
        
        // Set mock callout class RestMockHttpResponseGenerator for the successfull response with my gain value NO 
        Test.setMock(HttpCalloutMock.class, new RestMockHttpResponseGeneratorDataSet2());  
        
        RestAPICalloutController rc2=new RestAPICalloutController ();
     
        RegistrationDetailsCSS2_0Controller RegistrationDetailsObject;    
        
        System.runAs(objUser){
            RegistrationDetailsObject = new RegistrationDetailsCSS2_0Controller();   
        }
        
        RegistrationDetailsObject.enableViewAgreementButton();
        System.assertEquals(RegistrationDetailsObject.strDocumentId, '1234');
        test.stopTest();
    }
    
    public static testMethod void enableViewAgreementHyderabadProject(){
        
        Account objAccount = createAccount();
        insert objAccount;
        
        Contact conObj = new Contact();
        conObj.FirstName = 'Test';
        conObj.LastName = 'Test';
        insert conObj;
        Account insertedAccountwithcontact=[Select Id,
                                            Name,
                                            (select id from contacts ) 
                                            From account 
                                            Where id=:objAccount.id];
        Id accId = insertedAccountwithcontact.Id;                              
        Id conid = insertedAccountwithcontact.contacts[0].id ;
        
        
        User objUser = createUser(conid);
        
        insert objUser;
        
        Date dAllotmentDate = System.today();
        Booking_Details__c ObjBookingDetail = new Booking_Details__c();
        ObjBookingDetail.CRN__c = '112233';
        ObjBookingDetail.Flat_ID__c = 'Test';
        ObjBookingDetail.Allotment_Date__c = dAllotmentDate;
        ObjBookingDetail.CLuster__c = 'testCluster';
        ObjBookingDetail.Project__c = 'testProject';
        ObjBookingDetail.Consideration_Value__c  = 1000000; 
        ObjBookingDetail.Account__c = objAccount.Id;
        insert ObjBookingDetail;
        
        List<BoxConfiguration__c> listTestBoxConfig= RegistrationDetailsCSS2_0ControllerTest.getBoxConfig(ObjBookingDetail.Project__c, 
                                                                                                          ObjBookingDetail.CLuster__c,
                                                                                                          'Hyderabad');
        insert listTestBoxConfig;
        
        View_Agreement_CV_Limits__c oCVLimit = RegistrationDetailsCSS2_0ControllerTest.getCvLimit();
        insert oCVLimit;
        
        List<Demands__c> listTestDemands = RegistrationDetailsCSS2_0ControllerTest.getDemandRecord(1);
        listTestDemands[0].Flat_ID__c = ObjBookingDetail.Id;
        insert listTestDemands;
        
        update ObjBookingDetail;
        
        List<Project_Name__c> listTestProjectName = RegistrationDetailsCSS2_0ControllerTest.getProjectNameRecord(1);
        insert listTestProjectName;
        
        List<Cluster__c> listTestCluster = new List<Cluster__c>();
        
        test.startTest();
        
        ///System.runAs(objUser){
        Test.setMock(HttpCalloutMock.class, new RestMockHttpResponseGeneratorDataSet1());
        
        // Test.startTest();
        RestAPICalloutController rc1=new RestAPICalloutController ();
        
        RestAPICalloutController.CustomerInformationWrapper RestAPICallout_wrapper_obj = 
            new  RestAPICalloutController.CustomerInformationWrapper();
        RestAPICallout_wrapper_obj = rc1.parseCustomerInformationJSON('1210055');    
        System.assertNotEquals(null,rc1.parseCustomerInformationJSON('1210055')); 
        
        // Set mock callout class RestMockHttpResponseGenerator for the successfull response with my gain value NO 
        Test.setMock(HttpCalloutMock.class, new RestMockHttpResponseGeneratorDataSet2());  
        
        RestAPICalloutController rc2=new RestAPICalloutController ();
        RegistrationDetailsCSS2_0Controller RegistrationDetailsObject;
        System.runAs(objUser){ 
            RegistrationDetailsObject = new RegistrationDetailsCSS2_0Controller();
        }   
        RegistrationDetailsObject.enableViewAgreementButton();
        System.assertEquals(RegistrationDetailsObject.strDocumentId, '1234');
        test.stopTest();
    }
    
    
    
    
    private static List<BoxConfiguration__c> getBoxConfig(String pStrProjectName, 
                                                          String pStrClusterName, 
                                                          String pStrProjectLocation){
                                                              
                                                              List<BoxConfiguration__c> listBoxConfig = new List<BoxConfiguration__c>();
                                                              
                                                              BoxConfiguration__c objBoxConfig = new BoxConfiguration__c();
                                                              objBoxConfig.Name = 'testBoxConfig';
                                                              objBoxConfig.Cluster_Name__c = pStrClusterName;
                                                              objBoxConfig.Project_Name__c = pStrProjectName;
                                                              objBoxConfig.Is_Available__c = true;
                                                              objBoxConfig.Box_Agreement_Url__c = 'test.com';
                                                              objBoxConfig.Project_Location__c = pStrProjectLocation;
                                                              
                                                              listBoxConfig.add(objBoxConfig);
                                                              return listBoxConfig;
   }
    
    private static View_Agreement_CV_Limits__c getCvLimit(){
        
        View_Agreement_CV_Limits__c oCvLimit = new View_Agreement_CV_Limits__c();
        oCvLimit.CV_Paid_Lower_Limit__c = 9.9;
        oCvLimit.CV_Paid_Upper_Limit__c = 35;
        return oCvLimit;
    }
    
    //Method to create Test Record for Demand
    private static List<Demands__c> getDemandRecord(Integer pNumberOfRecords){
        
        List<Demands__c> listTestDemand = new List<Demands__c>();
        
        for(Integer intIndex = 0; intIndex < pNumberOfRecords; intIndex++){
            
            Demands__c tempDemand = new Demands__c();
            tempDemand.ExternalID__c = 'A12345';
            tempDemand.Amount_received__c = 100000;
            
            listTestDemand.add(tempDemand);
        }
        return listTestDemand;
    }
    
    //Method to create Test Record for Project Name
    private static List<Project_Name__c> getProjectNameRecord(Integer pNumberOfRecords){
        
        List<Project_Name__c> listTestProjectName = new List<Project_Name__c>();
        
        for(Integer intIndex = 0; intIndex < pNumberOfRecords; intIndex++){
            
            Project_Name__c tempProjectName = new Project_Name__c();
            tempProjectName.Name = 'testProject';
            tempProjectName.Project_Type__c = 'Casa';
            tempProjectName.Record_Type__c = 'Residential';
            tempProjectName.CRN_INIT__c = '123';
            tempProjectName.Is_Available__c = true;
            tempProjectName.Box_Agreement_Url__c = 'https://box.com';
            
            listTestProjectName.add(tempProjectName);
        }
        return listTestProjectName;
    }
    
    //Method to create Test Record for Cluster
    private static List<Cluster__c> getClusterRecord(Integer pNumberOfRecords){
        
        List<Cluster__c> listTestCluster = new List<Cluster__c>();
        
        for(Integer intIndex = 0; intIndex < pNumberOfRecords; intIndex++){
            
            Cluster__c tempCluster = new Cluster__c();
            tempCluster.Name = 'testCluster';
            tempCluster.Is_Available__c = true;
            tempCluster.Box_Agreement_Url__c = 'https://box.com';
            
            listTestCluster.add(tempCluster);
        }
        return listTestCluster;
    }  
    //method to create Account
    private static Account createAccount() {
        Account objAccount = new Account();
        objAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Booked Account').getRecordTypeId();
        objAccount.LastName = 'Account 2';
        objAccount.CRN__c='1251333';
        return objAccount;
    }
    //method to create user
    private static User createUser(Id contactId )
    {
        User objUser = new User();
        objUser.ProfileID = [Select Id
                             From Profile
                             Where Name='Custom Overage High Volume Customer Portal'].Id;
        objUser.EmailEncodingKey = 'ISO-8859-1';
        objUser.LanguageLocaleKey = 'en_US';
        objUser.TimeZoneSidKey = 'America/New_York';
        objUser.LocaleSidKey = 'en_US';
        objUser.FirstName = 'first';
        objUser.LastName = 'last';
        objUser.Username = 'lodha@test.com';   
        objUser.CommunityNickname = 'testUser123';
        objUser.Alias = 't1';
        objUser.Email = 'no@email.com';
        objUser.IsActive = true;
        objUser.ContactId = contactId; 
        
        return objUser;
        
    }
    //method to create Case
    private static Case createCase(Id accId) {
        Case caseObj = new Case();
        caseObj.RecordTypeId  = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CM_Parent_Only').getRecordTypeId();
        caseObj.Interaction_Mode__c= 'CSS';
        caseObj.Nature_of_Request__c= 'Query';
        caseObj.Communication_Type__c = 'Inbound';
        caseObj.Date_Confirm_Time_place_of_Registratio__c = System.Today()+10;
        caseObj.Date_Request_for_rescheduling_the_regist__c =System.Today()+10; 
        caseObj.AccountId = accId;
        caseObj.Request_for_L1__c='Registration Related';
        caseObj.Request_for_L2__c='Scheduling (SDR already paid)';
        caseObj.Request_for_L3__c ='Confirm Time & place of Registration';
        return caseObj;
    }
    
    //method to create Booking Details Object
    private static Booking_Details__c createBookingObj(String CRN,Id accId) {
        Booking_Details__c objBooking_Details =  new Booking_Details__c();
        objBooking_Details.CRN__c= CRN;
        objBooking_Details.Account__c = accId;
        objBooking_Details.Registered_Date__c = System.Today()-10;
        objBooking_Details.Status__c='Active';
        objBooking_Details.Rs_100_Agreement_Date__c=System.Today()-9;
        objBooking_Details.CLuster__c='Lodha Estrella';
        objBooking_Details.Project__c='New Cuffe Parade';
        objBooking_Details.Flat_ID__c = '14231515';
        objBooking_Details.Flat_No__c = '31';
        return objBooking_Details;
    }
    
}