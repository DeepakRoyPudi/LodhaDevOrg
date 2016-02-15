/* 
Description: Test Class For ProfileInformationCSS2_0Controller
@Created by: Aditi Mulmule
@Created Date:  

--------------------------------------------------------------------------------
| Modified By      | Modified Date       | Version        | Description         |
--------------------------------------------------------------------------------
|Aditi Mulmule             7/07/2015        1.2           1.Updated Test class for
Validation Rule Scenarios
and Age Formula Test
---------------------------------------------------------------------------------
*/
@isTest(seeAllData=false)
private class ProfileInformationCSS2_0ControllerTest {
    // method to test constructor
    static testMethod void constructorTest() {
        //create account
        Account objAccount = CreateAccount();
        insert objAccount;
        
        Account insertedAccountwithcontact=[Select Id, Owner.Name,
                                            Name,
                                            (select id from contacts ) 
                                            From account 
                                            Where id=:objAccount.id];
        Id conid = insertedAccountwithcontact.contacts[0].id ;
        
        //create new account and related contact to cover wrapper class contact birth date field accessibility
        Account objAccount1 = new Account();
        objAccount1.RecordTypeId = 
            Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        objAccount1.Name ='AAA';
        objAccount1.Mobile_Phone__c ='8554884329';
        insert objAccount1;
        
        Despatch__c desObj = new Despatch__c();
        
        
        //create user
        User objUser = createUser(conid);
        insert objUser;
        bookingInfo(objAccount.CRN__c);
        system.runAs(objUser){
            // Set mock callout class RestMockHttpResponseGenerator for the successfull response 
          /*  Test.setMock(HttpCalloutMock.class, new RestMockHttpResponseGeneratorDataSet1());
            Test.startTest();
            RestAPICalloutController rc1=new RestAPICalloutController ();
            RestAPICalloutController.CustomerInformationWrapper RestAPICallout_wrapper_obj =
                new  RestAPICalloutController.CustomerInformationWrapper();
            RestAPICallout_wrapper_obj = rc1.parseCustomerInformationJSON('1251333');    
            System.assertNotEquals(null,rc1.parseCustomerInformationJSON('1251333')); 
            
            Test.stopTest(); */
            PageReference pageRef = Page.ProfileInformationCSS2_0; 
            ProfileInformationCSS2_0Controller ProfileInfoObject = new ProfileInformationCSS2_0Controller();
            
            system.Test.setCurrentPage(pageRef);
            ProfileInfoObject.userId = objUser.Id;
            ProfileInfoObject.getProfileInfo();
        }
        
        
    }
    
    //method to test edit,save and cancel actions for each section on page
    static testMethod void editSaveTestEachSection() {
        //create account
        Account objAccount = CreateAccount();
        objAccount.DOB_Of_Client__c = null;
        insert objAccount;
        //query on accoun t to get related contact id
        Account insertedAccountwithcontact=[Select Id,
                                            Name,
                                            (select id from contacts ) 
                                            From account 
                                            Where id=:objAccount.id];
        Id conid = insertedAccountwithcontact.contacts[0].id ;
        
        //create user
        User objUser = createUser(conid);
        insert objUser;
        bookingInfo(objAccount.CRN__c);
        // system.runAs(objUser){
        
      /*  Test.setMock(HttpCalloutMock.class, new RestMockHttpResponseGeneratorDataSet1());
        Test.startTest();
        RestAPICalloutController rc1=new RestAPICalloutController ();
        RestAPICalloutController.CustomerInformationWrapper RestAPICallout_wrapper_obj =
            new  RestAPICalloutController.CustomerInformationWrapper();
        RestAPICallout_wrapper_obj = rc1.parseCustomerInformationJSON('1210055');    
        System.assertNotEquals(null,rc1.parseCustomerInformationJSON('1210055')); 
        // Set mock callout class RestMockHttpResponseGenerator for the successfull response with my gain value NO 
        Test.setMock(HttpCalloutMock.class, new RestMockHttpResponseGeneratorDataSet2());  
        RestAPICalloutController rc2=new RestAPICalloutController ();
        Test.stopTest(); */
        PageReference pageRef = Page.ProfileInformationCSS2_0; 
        //Create Controller Instance
        
        ProfileInformationCSS2_0Controller ProfileInfoObject ;
        system.runAs(objUser){
            ProfileInfoObject = new ProfileInformationCSS2_0Controller();
        }
        
        ProfileInfoObject.userId = objUser.Id;
        ProfileInfoObject.CRN = objAccount.CRN__c;
        ProfileInfoObject.getProfileInfo();
        //Edit Communication Details Section
        ProfileInfoObject.editComm();
        ProfileInfoObject.cancelCom();
        ProfileInfoObject.editComm();
        ProfileInfoObject.account_objComm.TRAI_DND__c=true;
        ProfileInfoObject.saveComm();
        
        //Edit Personal Details Section
        ProfileInfoObject.editPerson();
        ProfileInfoObject.cancelPersn();
        ProfileInfoObject.editPerson();
        ProfileInfoObject.account_objPersn.Age__c = 27;
        ProfileInfoObject.account_objPersn.Car_s_Owned__c = ' 5';
        ProfileInfoObject.account_objPersn.Hobbies__c = ' Reading,Music';
        ProfileInfoObject.savePersn();
        
        //Edit Family Details
        ProfileInfoObject.editFamily();
        ProfileInfoObject.cancelFamily();
        ProfileInfoObject.editFamily();
        ProfileInfoObject.account_objFamily.Marital_Status__c =' None';
        ProfileInfoObject.account_objFamily.Spouse_Name__c =' neha';
        ProfileInfoObject.saveFamily();
        
        ProfileInfoObject.editFamily();
        ProfileInfoObject.no_of_children = '0';
        system.currentPageReference().getParameters().put('firstParam',ProfileInfoObject.no_of_children);
        ProfileInfoObject.ChildPopup();
        ProfileInfoObject.AddRow();
        ProfileInfoObject.AddRow();
        ProfileInfoObject.AddRow();
        ProfileInfoObject.AddRow();
        
        ProfileInfoObject.profileWrapList[0].NameOfChild = ' Shruti';
        ProfileInfoObject.profileWrapList[0].desObj.Despatch_Date__c = date.newInstance(2015, 05, 05);
        ProfileInfoObject.profileWrapList[1].NameOfChild = ' ABc';
        ProfileInfoObject.profileWrapList[1].desObj.Despatch_Date__c = date.newInstance(2015, 05, 06);
        ProfileInfoObject.profileWrapList[2].NameOfChild = ' XYZ';
        ProfileInfoObject.profileWrapList[2].desObj.Despatch_Date__c = date.newInstance(2015, 05, 07);
        ProfileInfoObject.profileWrapList[3].NameOfChild = ' qqq';
        ProfileInfoObject.profileWrapList[3].desObj.Despatch_Date__c = date.newInstance(2015, 05, 08);
        ProfileInfoObject.saveChildDetails();
        ProfileInfoObject.AddRow();
        ProfileInfoObject.saveFamily();
        
        ProfileInfoObject.editFamily();
        
        //Edit Registration Details
        ProfileInfoObject.editRes();
        ProfileInfoObject.account_objRes.Current_Home_ownership__c = 'Owned';
        ProfileInfoObject.account_objRes.Specify_Residences_owned_at_Lodha_group__c = 'Goldern Hill';
        ProfileInfoObject.saveRes();
        ProfileInfoObject.cancelRes();
        
        list<Account> accObj = new list<Account>();                
        accObj = [Select ID,CRN__c, Spouse_Name__c,
                  Age__c,
                  Marital_Status__c,
                  Car_s_Owned__c ,
                  Hobbies__c,
                  Current_Home_ownership__c,
                  Specify_Residences_owned_at_Lodha_group__c 
                  From Account 
                  Where CRN__c=:objAccount.CRN__c 
                  limit 1];
        
        
        system.assertEquals('None', accObj[0].Marital_Status__c);

        system.assertEquals('5', accObj[0].Car_s_Owned__c);
        system.assertEquals('Reading,Music', accObj[0].Hobbies__c);
        system.assertEquals('Owned', accObj[0].Current_Home_ownership__c);
        system.assertEquals('Goldern Hill', accObj[0].Specify_Residences_owned_at_Lodha_group__c);
        system.assertEquals(27,accObj[0].Age__c);
        system.assertEquals('neha',accObj[0].Spouse_Name__c); 

        
    }
    // method to test no. of children popup functionlity
    static testMethod void noOfChildrenPopUpFunctionalityTest() {
        //create account
        Account objAccount = CreateAccount();
        insert objAccount;
        //query on account to get related contact id
        Account insertedAccountwithcontact=[Select Id,
                                            Name,
                                            (select id from contacts ) 
                                            From account 
                                            Where id=:objAccount.id];
        Id conid = insertedAccountwithcontact.contacts[0].id ;
        
        //create user
        User objUser = createUser(conid);
        insert objUser;
        
        bookingInfo(objAccount.CRN__c);
        
        
       /* Test.setMock(HttpCalloutMock.class, new RestMockHttpResponseGeneratorDataSet1());
        Test.startTest();
        RestAPICalloutController rc1=new RestAPICalloutController ();
        RestAPICalloutController.CustomerInformationWrapper RestAPICallout_wrapper_obj = 
            new  RestAPICalloutController.CustomerInformationWrapper();
        RestAPICallout_wrapper_obj = rc1.parseCustomerInformationJSON('1210055');    
        System.assertNotEquals(null,rc1.parseCustomerInformationJSON('1210055')); 
        // Set mock callout class RestMockHttpResponseGenerator for the successfull response with my gain value NO 
        Test.setMock(HttpCalloutMock.class, new RestMockHttpResponseGeneratorDataSet2());  
        RestAPICalloutController rc2=new RestAPICalloutController ();
        Test.stopTest(); */
        //Create Controller Instance and PageReferrance
        PageReference pageRef = Page.ProfileInformationCSS2_0; 
        ProfileInformationCSS2_0Controller ProfileInfoObject ;
        system.runAs(objUser){
            ProfileInfoObject = new ProfileInformationCSS2_0Controller();
        }
        system.Test.setCurrentPage(pageRef);
        ProfileInfoObject.editFamily();
        ProfileInfoObject.no_of_children = '0';
        system.currentPageReference().getParameters().put('firstParam',
                                                          ProfileInfoObject.no_of_children);
        ProfileInfoObject.ChildPopup();
        
        ProfileInfoObject.AddRow();
        ProfileInfoObject.profileWrapList[0].NameOfChild = 'tanuja';
        ProfileInfoObject.profileWrapList[0].desObj.Despatch_Date__c = date.newInstance(2015, 05, 05);
        
        ProfileInfoObject.saveChildDetails();
        ProfileInfoObject.saveFamily();
        
        ProfileInfoObject.editFamily();
        ProfileInfoObject.no_of_children = '1';
        system.currentPageReference().getParameters().put('firstParam',
                                                          ProfileInfoObject.no_of_children);
        ProfileInfoObject.ChildPopup();
        
        ProfileInfoObject.AddRow();
        ProfileInfoObject.profileWrapList[1].NameOfChild = ' Shruti';
        ProfileInfoObject.profileWrapList[1].desObj.Despatch_Date__c = date.newInstance(2015, 05, 05);
        
        ProfileInfoObject.saveChildDetails();
        ProfileInfoObject.saveFamily();
        
        
        ProfileInfoObject.no_of_children = '2';
        system.currentPageReference().getParameters().put('firstParam',
                                                          ProfileInfoObject.no_of_children);
        ProfileInfoObject.ChildPopup();
        //error condition for not more than 5 records can be added
        ProfileInfoObject.AddRow();
        ProfileInfoObject.AddRow();
        ProfileInfoObject.AddRow();
        ProfileInfoObject.AddRow();
        ProfileInfoObject.AddRow();
        ProfileInfoObject.AddRow();
        //error conditions for blank fields
        ProfileInfoObject.profileWrapList[1].NameOfChild = '';
        ProfileInfoObject.profileWrapList[1].desObj.Despatch_Date__c = date.newInstance(2015, 05, 05);
        ProfileInfoObject.profileWrapList[2].NameOfChild = ' tanuja';
        ProfileInfoObject.profileWrapList[2].desObj.Despatch_Date__c = null;
        ProfileInfoObject.saveChildDetails();
        // ProfileInfoObject.save();
        system.assertEquals(1,ProfileInfoObject.account_obj.No_of_children__c);
        ProfileInfoObject.editFamily();
        ProfileInfoObject.no_of_children = '1';
        system.currentPageReference().getParameters().put('firstParam',
                                                          ProfileInfoObject.no_of_children);
        ProfileInfoObject.profileWrapList[1].NameOfChild = 'adi';
        ProfileInfoObject.profileWrapList[1].desObj.Despatch_Date__c = date.newInstance(2014, 04, 07);
        ProfileInfoObject.profileWrapList[2].NameOfChild = 'Shruti';
        ProfileInfoObject.profileWrapList[2].desObj.Despatch_Date__c = date.newInstance(2015, 05, 05);
        ProfileInfoObject.saveChildDetails();
        ProfileInfoObject.saveFamily();
        
        system.assertEquals(3,ProfileInfoObject.account_objFamily.No_of_children__c);
        
        Account accObj = new Account();                
        accObj = [Select Children_s_DOB__c,
                  Children_Names__c
                  From Account 
                  Where CRN__c =:objAccount.CRN__c 
                  limit 1];
        system.assertEquals('tanuja | adi | Shruti',accObj.Children_Names__c);
       // system.assertEquals('atul',accObj.Children_Names__c);
       // system.assertEquals(3,ProfileInfoObject.account_objFamily.No_of_children__c); 
        //system.assertEquals(2,ProfileInfoObject.account_objFamily.No_of_children__c); 
        
        ProfileInfoObject.profileWrapList[0].NameOfChild = '';
        ProfileInfoObject.profileWrapList[0].desObj.Despatch_Date__c = null;
        ProfileInfoObject.profileWrapList[1].NameOfChild = '';
        ProfileInfoObject.profileWrapList[1].desObj.Despatch_Date__c = null;
        ProfileInfoObject.profileWrapList[2].NameOfChild = '';
        ProfileInfoObject.profileWrapList[2].desObj.Despatch_Date__c = null;
        ProfileInfoObject.saveChildDetails();
        
        ProfileInfoObject.saveFamily();
        system.assertEquals(0,ProfileInfoObject.account_objFamily.No_of_children__c);
        
    }
    //cover catch block for field value beyond specified limit
    static testMethod void negativeTest() {
        //create account
        Account objAccount = CreateAccount();
        insert objAccount;
        //query on account to get related contact id
        Account insertedAccountwithcontact=[Select Id,
                                            Name,
                                            (select id from contacts ) 
                                            From account 
                                            Where id=:objAccount.id];
        Id conid = insertedAccountwithcontact.contacts[0].id ;
        //create user
        User objUser = createUser(conid);
        insert objUser;
        
        bookingInfo(objAccount.CRN__c);
       /* Test.setMock(HttpCalloutMock.class, new RestMockHttpResponseGeneratorDataSet1());
        Test.startTest();
        RestAPICalloutController rc1=new RestAPICalloutController ();
        RestAPICalloutController.CustomerInformationWrapper RestAPICallout_wrapper_obj =
            new  RestAPICalloutController.CustomerInformationWrapper();
        RestAPICallout_wrapper_obj = rc1.parseCustomerInformationJSON('1210055');    
        System.assertNotEquals(null,rc1.parseCustomerInformationJSON('1210055')); 
        
        // Set mock callout class RestMockHttpResponseGenerator for the successfull response with my gain value NO 
        Test.setMock(HttpCalloutMock.class, new RestMockHttpResponseGeneratorDataSet2());  
        RestAPICalloutController rc2=new RestAPICalloutController ();
        Test.stopTest(); */
        //Create Instance of Controller and Page Referrance
        PageReference pageRef = Page.ProfileInformationCSS2_0; 
        ProfileInformationCSS2_0Controller ProfileInfoObject ;
        system.runAs(objUser){
            ProfileInfoObject = new ProfileInformationCSS2_0Controller();
        }
        system.Test.setCurrentPage(pageRef);
        ProfileInfoObject.userId = objUser.Id;
        ProfileInfoObject.editPerson();
        //cover catch block-value is put above actual limit
        ProfileInfoObject.account_objPersn.Hobbies__c='Reading, Listening Music,Drawing';
        ProfileInfoObject.savePersn();
        
        
    }
    // method to test when crn is null
    static testMethod void CRNTest() {
        
        Account objAccount = CreateAccount();
        objAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Booked Account').getRecordTypeId();
        objAccount.LastName = 'Account 3';
        objAccount.CRN__c=null;                      
        insert objAccount;
        
        //query on account to get related contact id
        Account insertedAccountwithcontact=[Select Id,
                                            Name,
                                            (select id from contacts ) 
                                            From account 
                                            Where id=:objAccount.Id];
        Id conid = insertedAccountwithcontact.contacts[0].Id ;
        //create user
        User objUser = createUser(conid);
        insert objUser;
        
        bookingInfo(objAccount.CRN__c);
     /*   Test.setMock(HttpCalloutMock.class, new RestMockHttpResponseGeneratorDataSet1());
        Test.startTest();
        RestAPICalloutController rc1=new RestAPICalloutController ();
        
        RestAPICalloutController.CustomerInformationWrapper RestAPICallout_wrapper_obj = 
            new  RestAPICalloutController.CustomerInformationWrapper();
        RestAPICallout_wrapper_obj = rc1.parseCustomerInformationJSON('1210055');    
        System.assertNotEquals(null,rc1.parseCustomerInformationJSON('1210055')); 
        
        // Set mock callout class RestMockHttpResponseGenerator for the successfull response with my gain value NO 
        Test.setMock(HttpCalloutMock.class, new RestMockHttpResponseGeneratorDataSet2());  
        
        RestAPICalloutController rc2=new RestAPICalloutController ();
        Test.stopTest();*/
        //Create Instance of Controller and Page Referrance
        PageReference pageRef = Page.ProfileInformationCSS2_0; 
        ProfileInformationCSS2_0Controller ProfileInfoObject ;
        system.runAs(objUser){
            ProfileInfoObject = new ProfileInformationCSS2_0Controller();
        }
        system.Test.setCurrentPage(pageRef);
        
        ProfileInfoObject.userId = objUser.Id;
        system.assertEquals(null,ProfileInfoObject.CRN);
        System.assert(ApexPages.getMessages()[0].getDetail().contains(system.label.CRNvalueNull));
        
        ProfileInfoObject.getProfileInfo();
        
        
    }
    //cover no.of Residences Validation Rule Scenarios
    static testMethod void NoOfResidencesValidationTest() {
        
        Account objAccount = CreateAccount();
        insert objAccount;
        
        //query on account to get related contact id
        Account insertedAccountwithcontact=[Select Id,
                                            Name,
                                            (select id from contacts ) 
                                            From account 
                                            Where id=:objAccount.Id];
        Id conid = insertedAccountwithcontact.contacts[0].Id ;
        //create user
        User objUser = createUser(conid);
        insert objUser;
        
         bookingInfo(objAccount.CRN__c);
        
       /* Test.setMock(HttpCalloutMock.class, new RestMockHttpResponseGeneratorDataSet1());
        Test.startTest();
        RestAPICalloutController rc1=new RestAPICalloutController ();
        
        RestAPICalloutController.CustomerInformationWrapper RestAPICallout_wrapper_obj = 
            new  RestAPICalloutController.CustomerInformationWrapper();
        RestAPICallout_wrapper_obj = rc1.parseCustomerInformationJSON('1210055');    
        System.assertNotEquals(null,rc1.parseCustomerInformationJSON('1210055')); 
        
        // Set mock callout class RestMockHttpResponseGenerator for the successfull response with my gain value NO 
        Test.setMock(HttpCalloutMock.class, new RestMockHttpResponseGeneratorDataSet2());  
        
        RestAPICalloutController rc2=new RestAPICalloutController ();
        Test.stopTest(); */
        //Create Instance of Controller and Page Referrance
        PageReference pageRef = Page.ProfileInformationCSS2_0; 
        ProfileInformationCSS2_0Controller ProfileInfoObject ;
        system.runAs(objUser){
            ProfileInfoObject = new ProfileInformationCSS2_0Controller();
        }
        system.Test.setCurrentPage(pageRef);
        
        //check whether validation rule gets applied when Assets_Owned_Homes__c<=Other_residences_owned_at_Lodha_Group_CC__c
        ProfileInfoObject.editRes();
        ProfileInfoObject.account_objRes.Assets_Owned_Homes__c = 2;
        ProfileInfoObject.account_objRes.Other_residences_owned_at_Lodha_Group_CC__c = 5;
        ProfileInfoObject.saveRes();
        //check acceptance of input when Assets_Owned_Homes__c = null
        ProfileInfoObject.editRes();
        ProfileInfoObject.account_objRes.Assets_Owned_Homes__c = null;
        ProfileInfoObject.account_objRes.Other_residences_owned_at_Lodha_Group_CC__c = 5;
        ProfileInfoObject.saveRes();
        system.assertEquals(false,ProfileInfoObject.isEditResidential);
        
        //check acceptance of input when Other_residences_owned_at_Lodha_Group_CC__c = null
        ProfileInfoObject.editRes();
        ProfileInfoObject.account_objRes.Assets_Owned_Homes__c = 2;
        ProfileInfoObject.account_objRes.Other_residences_owned_at_Lodha_Group_CC__c = null;
        ProfileInfoObject.saveRes();
        system.assertEquals(false,ProfileInfoObject.isEditResidential);
        
        
    }
    
    static testMethod void AgeFormulaTest() {
        
        Account objAccount = CreateAccount();
        insert objAccount;
        
        //query on account to get related contact id
        Account insertedAccountwithcontact=[Select Id,
                                            Name,
                                            (select id from contacts ) 
                                            From account 
                                            Where id=:objAccount.Id];
        Id conid = insertedAccountwithcontact.contacts[0].Id ;
        //create user
        User objUser = createUser(conid);
        insert objUser;
        
        bookingInfo(objAccount.CRN__c);
        
        /*Test.setMock(HttpCalloutMock.class, new RestMockHttpResponseGeneratorDataSet1());
        Test.startTest();
        RestAPICalloutController rc1=new RestAPICalloutController ();
        
        RestAPICalloutController.CustomerInformationWrapper RestAPICallout_wrapper_obj = 
            new  RestAPICalloutController.CustomerInformationWrapper();
        RestAPICallout_wrapper_obj = rc1.parseCustomerInformationJSON('1210055');    
        System.assertNotEquals(null,rc1.parseCustomerInformationJSON('1210055')); 
        
        // Set mock callout class RestMockHttpResponseGenerator for the successfull response with my gain value NO 
        Test.setMock(HttpCalloutMock.class, new RestMockHttpResponseGeneratorDataSet2());  
        
        RestAPICalloutController rc2=new RestAPICalloutController ();
        Test.stopTest();*/
        //Create Instance of Controller and Page Referrance
        PageReference pageRef = Page.ProfileInformationCSS2_0; 
        ProfileInformationCSS2_0Controller ProfileInfoObject ;
        system.runAs(objUser){
            ProfileInfoObject = new ProfileInformationCSS2_0Controller();
        }
        system.Test.setCurrentPage(pageRef);
        //cover age = 0 when date of client is more than current year and value goes negative
        ProfileInfoObject.editPerson();
//        ProfileInfoObject.account_objPersn.DOB_Of_Client__c = Date.newInstance(2017 ,10 ,20);
           ProfileInfoObject.account_objPersn.DOB_Of_Client__c = date.today();
        ProfileInfoObject.savePersn();
        system.assertEquals(0,ProfileInfoObject.Age);
        //cover age = 0 when date of client is null 
        ProfileInfoObject.editPerson();
        ProfileInfoObject.account_objPersn.DOB_Of_Client__c = null;
        ProfileInfoObject.savePersn();
        system.assertEquals(0,ProfileInfoObject.Age);
        
    }
    
    
    // method to create account
    private static Account CreateAccount() {
        
        Account objAccount = new Account();
        objAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Booked Account').getRecordTypeId();
        objAccount.LastName = 'Account 2';
        objAccount.CRN__c='1251333';
        objAccount.PersonEmail = 'abc@gmail.com';
        objAccount.Click_To_Call__c = '8554884329'; 
        objAccount.Primary_PAN_number__c='ASC21056';
        objAccount.Preferred_Mode_of_Contact__c = 'Phone';
        objAccount.BillingStreet = 'DP road';
        objAccount.BillingState = 'Maharashtra';
        objAccount.BillingCountry='India';
        objAccount.BillingCity = 'Pune';
        objAccount.TRAI_DND__c = false;
        objAccount.Co_Applicant__c = 'Sandip Shah';
        objAccount.DOB_Of_Client__c = Date.newInstance(1980 , 10 ,20);
        objAccount.Marital_Status__c = 'Married';
        objAccount.Person_email_from_trigger__c = 'xyz@gmail.com';
        objAccount.Current_Home_ownership__c = 'Rented';
        objAccount.Assets_Owned_Homes__c = 4;
        objAccount.Car_s_Owned__c = '4';
        objAccount.Club_Membership__pc = 'yes';
        objAccount.Other_residences_owned_at_Lodha_Group_CC__c = 2;
        objAccount.Specify_Residences_owned_at_Lodha_group__c = 'Goldern Park';
        objAccount.Ethinicity__c='Marathi';
        objAccount.Age__c = 23;
        objAccount.Anniversary_Date__c =Date.newInstance(1980 , 10 ,20);
        objAccount.Spouse_Name__c ='kiran';
        objAccount.DOB_of_Spouse__c = Date.newInstance(1980 , 10 ,20);
        objAccount.No_of_children__c = 1;
        objAccount.Children_s_DOB__c = ' 10/5/2015';
        objAccount.Children_Names__c =' atul';
        objAccount.Purpose_of_Purchase__c = 'Personal Use';
        objAccount.Hobbies__c = 'Reading';
        objAccount.Type_of_Home__c = '1.5 bhk';
        objAccount.Occupation_acc__c = 'Salaried';
        objAccount.Industry = 'Textile';
        objAccount.Alternate_Designation__c = 'Designation1';
        objAccount.Project_Name__c ='New Project';
        return objAccount;
    }
    //method to create user
    private static User createUser(ID conid) {
        
        User objUser = new User();
        objUser.ProfileID = [Select Id
                             From Profile
                             Where Name='Custom Overage High Volume Customer Portal'].id;
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
        objUser.ContactId = conid;   
        return objUser;
        
    }
    private static void  bookingInfo(String CRN){
    
        Booking_Information__c objBooking_Information =  new Booking_Information__c();
        objBooking_Information.CRN_Number_SAP__c = CRN;
        objBooking_Information.PAN_Number_of_Co_Applicant__c ='AOVPS1160A';
        insert objBooking_Information;
    }
    
}