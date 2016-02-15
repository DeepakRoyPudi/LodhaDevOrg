/* 
Description:
test class for cover the controller which is used in Rm side bar component 

 @Created by: Sudeep Dube
 @Created Date: 30/03/2015
 
 --------------------------------------------------------------------------------
 | Modified By      | Modified Date       | Version        | Description         |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------
*/

@isTest
public class RMRegistrationDetailControllerTest {
    static testmethod void testRMRegistrationDetailController() {

        //create test data for the custom setting which holds the name and respective URLs
        list < Customer360AndCSS2_0Links01__c > settingList = new list < Customer360AndCSS2_0Links01__c > ();
       
        Customer360AndCSS2_0Links01__c setting14 = 
            new Customer360AndCSS2_0Links01__c(name = 'RegistrationGuidelines', Links__c = 'www.google.com');
        

        settingList.add(setting14);
       

        //inserted the data into the custom setting object
        insert settingList;

        //below class is controller which used in RMSidebar Components 
        RMRegistrationDetailController rmlinks = new RMRegistrationDetailController();
        
        //for cover each method call it and compare its return values in assert for test validating
        System.assertNotEquals(rmlinks.getRegistrationLink(), null);
   
    
    }

    static testmethod void registrationPopupTest() {

        Account objAccount = new Account();
        objAccount.RecordTypeId = 
            Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        objAccount.Name = 'AAA';
        objAccount.Mobile_Phone__c = '8554884329';
        objAccount.CRN__c = '1251333';
        insert objAccount;

        Case caseObj = new Case();
        caseObj.RecordTypeId = 
            Schema.SObjectType.Case.getRecordTypeInfosByName().get('CM_Parent_Only').getRecordTypeId();
        caseObj.Interaction_Mode__c = 'CSS';
        caseObj.Nature_of_Request__c = 'Query';
        caseObj.Communication_Type__c = 'Inbound';
        caseObj.Date_Confirm_Time_place_of_Registratio__c = System.Today() + 10;
        caseObj.Date_Request_for_rescheduling_the_regist__c = System.Today() + 10;
        caseObj.AccountId = objAccount.Id;
        caseObj.Request_for_L1__c = 'Registration Related';
        caseObj.Request_for_L2__c = 'Scheduling (SDR already paid)';
        caseObj.Request_for_L3__c = 'Confirm Time & place of Registration';
        insert caseObj;

        String Click_To_Call_1 = '9856712345';

        Test.setMock(HttpCalloutMock.class, new RestMockHttpResponseGeneratorDataSet1());
        Test.startTest();
        RestAPICalloutController rc1 = new RestAPICalloutController();

        RestAPICalloutController.CustomerInformationWrapper RestAPICallout_wrapper_obj = 
            new RestAPICalloutController.CustomerInformationWrapper();
        RestAPICallout_wrapper_obj = rc1.parseCustomerInformationJSON('1210055');
        System.assertNotEquals(null, rc1.parseCustomerInformationJSON('1210055'));

        // Set mock callout class RestMockHttpResponseGenerator for the successfull response with my gain value NO 
        Test.setMock(HttpCalloutMock.class, new RestMockHttpResponseGeneratorDataSet2());

        RestAPICalloutController rc2 = new RestAPICalloutController();
        Test.stopTest();

        PageReference pageRef_1 = new PageReference('apex/RMRegistrationDetail?crn='+objAccount.CRN__c+'&charges=1254&stampDuty=4512&Date=12/08/2015&Status=on&challanDate=14/8/2014');
        Test.setCurrentPage(pageRef_1);

        RMRegistrationDetailController  rmlinksObject = new RMRegistrationDetailController();
        rmlinksObject.CRNval = objAccount.CRN__c;
        rmlinksObject.registration_charges = '1451';
        rmlinksObject.stamp_duty = '1251';
        rmlinksObject.registration_date = '10/02/2015';
        rmlinksObject.registration_status = 'on';
        rmlinksObject.registration_challan_date = '10/03/2015';
    
        rmlinksObject.getIntialMethod();
        rmlinksObject.toggleEdit();
        //rmlinksObject.account_obj.Owner.Email = 'abc@gmail.com';
        rmlinksObject.reSchedule_Date = System.Today() + 10;
        rmlinksObject.reSchedule_time = System.now().time();
        rmlinksObject.virtualcase.Stage_Date__c = System.Today() + 10;
        rmlinksObject.virtualTime = System.now().time();
        rmlinksObject.sendEmailToRM();

        System.assert(ApexPages.getMessages()[0].getDetail().contains(system.label.Registration_success_response));
       
        rmlinksObject.toggleEdit();
        //Error condition for null values in stage date and virtual time
        rmlinksObject.toggleEdit();
        rmlinksObject.reSchedule_Date = System.Today() + 10;
        rmlinksObject.reSchedule_time = System.now().time();
        rmlinksObject.virtualcase.Stage_Date__c = null;
        rmlinksObject.virtualTime = null;
        rmlinksObject.sendEmailToRM();
        System.assert(ApexPages.getMessages()[1].getDetail().contains(system.label.registration_date_validate));
        //Error condition for null value  virtual time
        rmlinksObject.reSchedule_Date = System.Today() + 10;
        rmlinksObject.reSchedule_time = System.now().time();
        rmlinksObject.virtualcase.Stage_Date__c = System.Today() + 10;
        rmlinksObject.virtualTime = null;
        rmlinksObject.sendEmailToRM();
        System.assert(ApexPages.getMessages()[2].getDetail().contains(system.label.registration_time_validation));
    }

    static testmethod void noRelatedCaseTest() {

        Account objAccount = new Account();
        objAccount.RecordTypeId = 
            Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        objAccount.Name = 'AAA';
        objAccount.Mobile_Phone__c = '8554884329';
        objAccount.CRN__c = '1251333';
        insert objAccount;

        Case caseObj = new Case();
        caseObj.RecordTypeId = 
            Schema.SObjectType.Case.getRecordTypeInfosByName().get('CM_Parent_Only').getRecordTypeId();
        caseObj.Interaction_Mode__c = 'CSS';
        caseObj.Nature_of_Request__c = 'Query';
        caseObj.Communication_Type__c = 'Inbound';
        caseObj.Date_Confirm_Time_place_of_Registratio__c = System.Today() + 10;
        caseObj.Date_Request_for_rescheduling_the_regist__c = System.Today() + 10;
        caseObj.AccountId = objAccount.Id;
        caseObj.Request_for_L1__c = 'Payment Related';
        caseObj.Request_for_L2__c = 'Payment info on portal';
        caseObj.Request_for_L3__c = 'Info not reflecting on portal';
        caseObj.Request_for_L3_a__c = 'Info not reflecting on portal';
        insert caseObj;

        String Click_To_Call_1 = '9856712345';

        Test.setMock(HttpCalloutMock.class, new RestMockHttpResponseGeneratorDataSet1());

        Test.startTest();
        RestAPICalloutController rc1 = new RestAPICalloutController();

        RestAPICalloutController.CustomerInformationWrapper RestAPICallout_wrapper_obj = 
            new RestAPICalloutController.CustomerInformationWrapper();
        RestAPICallout_wrapper_obj = rc1.parseCustomerInformationJSON('1210055');
        System.assertNotEquals(null, rc1.parseCustomerInformationJSON('1210055'));

        // Set mock callout class RestMockHttpResponseGenerator for the successfull response with my gain value NO 
        Test.setMock(HttpCalloutMock.class, new RestMockHttpResponseGeneratorDataSet2());

        RestAPICalloutController rc2 = new RestAPICalloutController();
        Test.stopTest();

        PageReference pageRef_1 = 
            new PageReference('apex/RMRegistrationDetail?crn='+objAccount.CRN__c+'&charges=1254&stampDuty=4512&Date=12/08/2015&Status=on&challanDate=14/8/2014');
        Test.setCurrentPage(pageRef_1);

        RMRegistrationDetailController rmlinksObject = 
            new RMRegistrationDetailController();

        rmlinksObject.CRNval =objAccount.CRN__c;
        rmlinksObject.registration_charges = '1451';
        rmlinksObject.stamp_duty = '1251';
        rmlinksObject.registration_date = '10/02/2015';
        rmlinksObject.registration_status = 'on';
        rmlinksObject.registration_challan_date = '10/03/2015';
        rmlinksObject.getIntialMethod();
       // rmlinksObject.intialMethod();
        rmlinksObject.toggleEdit();
        //rmlinksObject.account_obj.Owner.Email = 'abc@gmail.com';
        rmlinksObject.reSchedule_Date = System.Today() + 10;
        rmlinksObject.reSchedule_time = System.now().time();
        rmlinksObject.sendEmailToRM();
        System.assert(ApexPages.getMessages()[0].getDetail().contains(system.label.Registration_case_does_not_exist));
        
        rmlinksObject.toggleEdit();
    }
}