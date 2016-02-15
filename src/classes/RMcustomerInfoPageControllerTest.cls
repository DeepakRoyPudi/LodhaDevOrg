/* 
Description:
Test class for RMcustomerinfoController class for visusalforce page RMcustomerinfopage 
1.It describes Profile Information of Logged In user
2.Edit Functionality for Each Section is Provided except Information Registered With Lodha
@Created by: Aditi Mulmule
@Created Date: 25/05/2015

--------------------------------------------------------------------------------
| Modified By      | Modified Date       | Version        | Description         |
--------------------------------------------------------------------------------
|Aditi Mulmule       25/05/2015           Initial Draft
--------------------------------------------------------------------------------
|
--------------------------------------------------------------------------------
|Shruti Nikam        25/05/2015            1.2             Derived account using 
CRN
--------------------------------------------------------------------------------
*/
@isTest(SeeAllData = false)
private class RMcustomerInfoPageControllerTest {
    
    static testMethod void ConstructorTest() {
        Account objAccount = CreateAccount();
        
        insert objAccount;
        bookingInfo(objAccount.CRN__c);
        String CRN='1251333';
        // for contact birthdate field
        Account objAccount1 = new Account();
        objAccount1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        objAccount1.Name ='AAA';
        objAccount1.Mobile_Phone__c ='8554884329';
        insert objAccount1;
        
        Despatch__c desObj = new Despatch__c();
        
        PageReference pageRef_1 = new PageReference('/apex/RMcustomerInfoPage?CRN='+CRN);
        Test.setCurrentPage(pageRef_1);
        
        try{
            Test.setMock(HttpCalloutMock.class, new RestMockHttpResponseGeneratorDataSet1());
            Test.startTest();
            RestAPICalloutController rc1=new RestAPICalloutController ();
            RestAPICalloutController.CustomerInformationWrapper RestAPICallout_wrapper_obj = new  RestAPICalloutController.CustomerInformationWrapper();
            RestAPICallout_wrapper_obj = rc1.parseCustomerInformationJSON('1251333');    
            System.assertNotEquals(null,rc1.parseCustomerInformationJSON('1251333')); 
            
            // Set mock callout class RestMockHttpResponseGenerator for the successfull response with my gain value NO 
            Test.setMock(HttpCalloutMock.class, new RestMockHttpResponseGeneratorDataSet2());  
            RestAPICalloutController rc2=new RestAPICalloutController ();
            Test.stopTest();
            RMcustomerInfoPageController ProfileInfoObject = new RMcustomerInfoPageController();
            ProfileInfoObject.getProfileInfo();
            
            
            
        }
        catch(Exception e){
            
        }
        
        
        
    }
    static testMethod void editSaveTestEachSection() {
        Account objAccount = CreateAccount();
        insert objAccount;
        
        bookingInfo(objAccount.CRN__c);
        String CRN='1251333';
        PageReference pageRef_1 = new PageReference('/apex/RMcustomerInfoPage?CRN='+CRN);
        Test.setCurrentPage(pageRef_1);
        try{
            Test.setMock(HttpCalloutMock.class, new RestMockHttpResponseGeneratorDataSet1());
            Test.startTest();
            RestAPICalloutController rc1=new RestAPICalloutController ();
            RestAPICalloutController.CustomerInformationWrapper RestAPICallout_wrapper_obj = new  RestAPICalloutController.CustomerInformationWrapper();
            RestAPICallout_wrapper_obj = rc1.parseCustomerInformationJSON('1210055');    
            System.assertNotEquals(null,rc1.parseCustomerInformationJSON('1210055')); 
            // Set mock callout class RestMockHttpResponseGenerator for the successfull response with my gain value NO 
            Test.setMock(HttpCalloutMock.class, new RestMockHttpResponseGeneratorDataSet2());  
            RestAPICalloutController rc2=new RestAPICalloutController ();
            Test.stopTest();
            RMcustomerInfoPageController ProfileInfoObject = new RMcustomerInfoPageController();
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
            Account accObj = new Account();                
            accObj = [Select Spouse_Name__c,Age__c,Marital_Status__c,TRAI_DND__c,Car_s_Owned__c ,Hobbies__c,Current_Home_ownership__c,Specify_Residences_owned_at_Lodha_group__c from Account Where CRN__c =:objAccount.CRN__c limit 1];
            //system.assertEquals(true,accObj.TRAI_DND__c);
            //system.assertEquals('None', accObj.Marital_Status__c);
            //system.assertEquals('5', accObj.Car_s_Owned__c);
            //system.assertEquals('Reading,Music', accObj.Hobbies__c);
            //system.assertEquals('Owned', accObj.Current_Home_ownership__c);
            //system.assertEquals('Goldern Hill', accObj.Specify_Residences_owned_at_Lodha_group__c);
            //system.assertEquals(27,accObj.Age__c);
            //system.assertEquals('neha',accObj.Spouse_Name__c); 
            
        }
        catch(Exception e){
            
        }
        
        
    }
    
    static testMethod void noOfChildrenPopUpFunctionalityTest() {
        Account objAccount = CreateAccount();
        insert objAccount;
        
        bookingInfo(objAccount.CRN__c);
        String CRN='1251333';
        PageReference pageRef_1 = new PageReference('/apex/RMcustomerInfoPage?CRN='+CRN);
        Test.setCurrentPage(pageRef_1);
        try{
            Test.setMock(HttpCalloutMock.class, new RestMockHttpResponseGeneratorDataSet1());
            Test.startTest();
            RestAPICalloutController rc1=new RestAPICalloutController ();
            RestAPICalloutController.CustomerInformationWrapper RestAPICallout_wrapper_obj = new  RestAPICalloutController.CustomerInformationWrapper();
            RestAPICallout_wrapper_obj = rc1.parseCustomerInformationJSON('1210055');    
            System.assertNotEquals(null,rc1.parseCustomerInformationJSON('1210055')); 
            // Set mock callout class RestMockHttpResponseGenerator for the successfull response with my gain value NO 
            Test.setMock(HttpCalloutMock.class, new RestMockHttpResponseGeneratorDataSet2());  
            RestAPICalloutController rc2=new RestAPICalloutController ();
            Test.stopTest();
            //Registration Link From Custom Setting
            PageReference pageRef = Page.RMcustomerInfoPage; 
            RMcustomerInfoPageController ProfileInfoObject = new RMcustomerInfoPageController();
            ProfileInfoObject.editFamily();
            ProfileInfoObject.no_of_children = '0';
            system.currentPageReference().getParameters().put('firstParam',ProfileInfoObject.no_of_children);
            ProfileInfoObject.ChildPopup();
            
            ProfileInfoObject.AddRow();
            ProfileInfoObject.profileWrapList[0].NameOfChild = ' tanuja';
            ProfileInfoObject.profileWrapList[0].desObj.Despatch_Date__c = date.newInstance(2015, 05, 05);
            
            ProfileInfoObject.saveChildDetails();
            ProfileInfoObject.saveFamily();
            
            ProfileInfoObject.editFamily();
            ProfileInfoObject.no_of_children = '1';
            system.currentPageReference().getParameters().put('firstParam',ProfileInfoObject.no_of_children);
            ProfileInfoObject.ChildPopup();
            
            ProfileInfoObject.AddRow();
            ProfileInfoObject.profileWrapList[1].NameOfChild = ' Shruti';
            ProfileInfoObject.profileWrapList[1].desObj.Despatch_Date__c = date.newInstance(2015, 05, 05);
            
            ProfileInfoObject.saveChildDetails();
            ProfileInfoObject.saveFamily();
            
            
            ProfileInfoObject.no_of_children = '2';
            system.currentPageReference().getParameters().put('firstParam',ProfileInfoObject.no_of_children);
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
            system.currentPageReference().getParameters().put('firstParam',ProfileInfoObject.no_of_children);
            ProfileInfoObject.profileWrapList[1].NameOfChild = ' adi';
            ProfileInfoObject.profileWrapList[1].desObj.Despatch_Date__c = date.newInstance(2015, 05, 05);
            ProfileInfoObject.profileWrapList[2].NameOfChild = ' Shruti';
            ProfileInfoObject.profileWrapList[2].desObj.Despatch_Date__c = date.newInstance(2015, 05, 05);
            ProfileInfoObject.saveChildDetails();
            ProfileInfoObject.saveFamily();
            
            system.assertEquals(3,ProfileInfoObject.account_objFamily.No_of_children__c);
            
            Account accObj = new Account();                
            accObj = [Select Children_s_DOB__c,Children_Names__c from Account Where CRN__c =:objAccount.CRN__c limit 1];
            // system.assertEquals('tanuja | adi | Shruti',accObj.Children_Names__c);
            // system.assertEquals('5/5/2015 | 5/5/2015',accObj.Children_s_DOB__c);
            system.assertEquals(3,ProfileInfoObject.account_objFamily.No_of_children__c);
            
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
        
        catch(Exception e)
        {
            
        }
        
    }
    
    static testMethod void NegativeTest() {
        Account objAccount = CreateAccount();
        insert objAccount;
        
        bookingInfo(objAccount.CRN__c);
        String CRN='1251333';
        PageReference pageRef_1 = new PageReference('/apex/RMcustomerInfoPage?CRN='+CRN);
        Test.setCurrentPage(pageRef_1);
        try{
            Test.setMock(HttpCalloutMock.class, new RestMockHttpResponseGeneratorDataSet1());
            Test.startTest();
            RestAPICalloutController rc1=new RestAPICalloutController ();
            RestAPICalloutController.CustomerInformationWrapper RestAPICallout_wrapper_obj = new  RestAPICalloutController.CustomerInformationWrapper();
            RestAPICallout_wrapper_obj = rc1.parseCustomerInformationJSON('1210055');    
            System.assertNotEquals(null,rc1.parseCustomerInformationJSON('1210055')); 
            
            // Set mock callout class RestMockHttpResponseGenerator for the successfull response with my gain value NO 
            Test.setMock(HttpCalloutMock.class, new RestMockHttpResponseGeneratorDataSet2());  
            RestAPICalloutController rc2=new RestAPICalloutController ();
            Test.stopTest();
            //Registration Link From Custom Setting
            RMcustomerInfoPageController ProfileInfoObject = new RMcustomerInfoPageController();
            ProfileInfoObject.getProfileInfo();
            ProfileInfoObject.editPerson();
            //cover catch block-value is put above actual limit
            ProfileInfoObject.account_objPersn.Hobbies__c='Reading, Listening Music,Drawing';
            ProfileInfoObject.savePersn();
            
        }
        catch(Exception e){
            
        }
        
        
    }
    
    static testMethod void CRNTest() {
        
        String CRN='1251333';
        PageReference pageRef_1 = new PageReference('/apex/RMcustomerInfoPage?CRN='+CRN);
        Test.setCurrentPage(pageRef_1);
        try{
            Test.setMock(HttpCalloutMock.class, new RestMockHttpResponseGeneratorDataSet1());
            Test.startTest();
            RestAPICalloutController rc1=new RestAPICalloutController ();
            
            RestAPICalloutController.CustomerInformationWrapper RestAPICallout_wrapper_obj = new  RestAPICalloutController.CustomerInformationWrapper();
            RestAPICallout_wrapper_obj = rc1.parseCustomerInformationJSON('1210055');    
            System.assertNotEquals(null,rc1.parseCustomerInformationJSON('1210055')); 
            
            // Set mock callout class RestMockHttpResponseGenerator for the successfull response with my gain value NO 
            Test.setMock(HttpCalloutMock.class, new RestMockHttpResponseGeneratorDataSet2());  
            
            RestAPICalloutController rc2=new RestAPICalloutController ();
            Test.stopTest();
            //Registration Link From Custom Setting
            RMcustomerInfoPageController ProfileInfoObject = new RMcustomerInfoPageController();
            ProfileInfoObject.getProfileInfo();
            
        }
        catch(Exception e){
            
        }
        
        
    }
    
    //cover no.of Residences Validation Rule Scenarios
    static testMethod void NoOfResidencesValidationTest() {
        Account objAccount = CreateAccount();
        insert objAccount;
        
        bookingInfo(objAccount.CRN__c);
        
        String CRN='1251333';
        PageReference pageRef_1 = new PageReference('/apex/RMcustomerInfoPage?CRN='+CRN);
        Test.setCurrentPage(pageRef_1);
        
        Test.setMock(HttpCalloutMock.class, new RestMockHttpResponseGeneratorDataSet1());
        Test.startTest();
        RestAPICalloutController rc1=new RestAPICalloutController ();
        RestAPICalloutController.CustomerInformationWrapper RestAPICallout_wrapper_obj = new  RestAPICalloutController.CustomerInformationWrapper();
        RestAPICallout_wrapper_obj = rc1.parseCustomerInformationJSON('1210055');    
        System.assertNotEquals(null,rc1.parseCustomerInformationJSON('1210055')); 
        
        // Set mock callout class RestMockHttpResponseGenerator for the successfull response with my gain value NO 
        Test.setMock(HttpCalloutMock.class, new RestMockHttpResponseGeneratorDataSet2());  
        RestAPICalloutController rc2=new RestAPICalloutController ();
        Test.stopTest();
        //Registration Link From Custom Setting
        RMcustomerInfoPageController ProfileInfoObject = new RMcustomerInfoPageController();
        //ystem.Test.setCurrentPage(pageRef);
        
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
        
        bookingInfo(objAccount.CRN__c);
        
        String CRN='1251333';
        PageReference pageRef_1 = new PageReference('/apex/RMcustomerInfoPage?CRN='+CRN);
        Test.setCurrentPage(pageRef_1);
        
        Test.setMock(HttpCalloutMock.class, new RestMockHttpResponseGeneratorDataSet1());
        Test.startTest();
        RestAPICalloutController rc1=new RestAPICalloutController ();
        RestAPICalloutController.CustomerInformationWrapper RestAPICallout_wrapper_obj = new  RestAPICalloutController.CustomerInformationWrapper();
        RestAPICallout_wrapper_obj = rc1.parseCustomerInformationJSON('1210055');    
        System.assertNotEquals(null,rc1.parseCustomerInformationJSON('1210055')); 
        
        // Set mock callout class RestMockHttpResponseGenerator for the successfull response with my gain value NO 
        Test.setMock(HttpCalloutMock.class, new RestMockHttpResponseGeneratorDataSet2());  
        RestAPICalloutController rc2=new RestAPICalloutController ();
        Test.stopTest();
        //Registration Link From Custom Setting
        RMcustomerInfoPageController ProfileInfoObject = new RMcustomerInfoPageController();
        //cover age = 0 when date of client is more than current year and value goes negative
        ProfileInfoObject.editPerson();
        //ProfileInfoObject.account_objPersn.DOB_Of_Client__c = Date.newInstance(2017 ,10 ,20);
        ProfileInfoObject.account_objPersn.DOB_Of_Client__c = Date.today();
        ProfileInfoObject.savePersn();
        system.assertEquals(0,ProfileInfoObject.Age);
        //cover age = 0 when date of client is null 
        ProfileInfoObject.editPerson();
        ProfileInfoObject.account_objPersn.DOB_Of_Client__c = null;
        ProfileInfoObject.savePersn();
        system.assertEquals(0,ProfileInfoObject.Age);
    }
    
    
    
    private static Account CreateAccount() {
        
        Account objAccount = new Account();
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
        objAccount.Assets_Owned_Homes__c = 15;
        objAccount.Car_s_Owned__c = '4';
        objAccount.Club_Membership__pc = 'yes';
        objAccount.Other_residences_owned_at_Lodha_Group_CC__c = 15;
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
    private static void  bookingInfo(String CRN){
    
        Booking_Information__c objBooking_Information =  new Booking_Information__c();
        objBooking_Information.CRN_Number_SAP__c = CRN;
        objBooking_Information.PAN_Number_of_Co_Applicant__c ='AOVPS1160A';
        insert objBooking_Information;
    }
    
}