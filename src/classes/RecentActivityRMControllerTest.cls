/* Version  		Created By   	 Created Date       Description
 *
 * 	Initial Draft		Madan          26/03/2015       Test Class for RecentActivityRMController
 *
 */
 
@isTest(SeeAllData = false)
private class RecentActivityRMControllerTest {
	
     // For one Account with many cases test method 
     static testMethod void testRecentActivityWithCases(){
     	// creating user
        User objUser=RecentActivityRMControllerTest.createUser();
        insert objUser;
        
     	// creating test data for SAPBookingIDAgentMapping_del__c object
        SAPBookingIDAgentMapping_del__c objSAPBookingIDAgentMapping_del = new SAPBookingIDAgentMapping_del__c();
        objSAPBookingIDAgentMapping_del.Booking_ID__c='BK144521'; 
        objSAPBookingIDAgentMapping_del.Agent_Name__c=objUser.id;
        objSAPBookingIDAgentMapping_del.Wing__c='A';
        objSAPBookingIDAgentMapping_del.Project_Name__c='XYZ';
        objSAPBookingIDAgentMapping_del.Flat_No__c='4';
        insert objSAPBookingIDAgentMapping_del;
        
        //creating account
        Account objAccount = RecentActivityRMControllerTest.createAccount();
        insert objAccount;
        
        List<Case> lstCase1 = new List<Case>();
        for(Integer i = 0; i < 10; i++){
          Case objCase = new Case();
          objCase.AccountId = objAccount.Id;
          objCase.Project__c='XY';
          objCase.Buildings_Name__c='z';
          objCase.Wing__c='A';
          objCase.Flat_No__c = '4';
          objCase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Other Cases').getRecordTypeId();
          objCase.Status='New';
          lstCase1.add(objCase);
          }
          insert lstCase1;
          
        // initializung controller class
        RecentActivityRMController objRecentActivityRMController = new RecentActivityRMController();
        objRecentActivityRMController.CustomerCRN=objAccount.CRN__c;
        objRecentActivityRMController.noOfRecords=5;
        objRecentActivityRMController.lstCase=lstCase1 ;
        
        
        Test.startTest();
           System.assertEquals(10,objRecentActivityRMController.lstCase.size());
        Test.stopTest();
     }
     // test data for Account object
      private static Account createAccount(){
        Account objAccount = new Account();
        objAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        objAccount.FirstName='Test1 ';
        objAccount.LastName='Account1';
        objAccount.CRN__c='154215';
        objAccount.H_Mobile_No__c='1234560789';
        objAccount.Mobile_Phone__c='21241222';
        objAccount.Co_Applicant__c='test';
        return objAccount;
      }  
      private static User createUser(){
        Profile objProfile = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User objUser = new User(Alias = 'standt', Email='testUserNew@test.com', 
        EmailEncodingKey='UTF-8', LastName='Tester', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = objProfile.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='amarjanuka@test.com');
       // insert objUser;
        return objUser;
      } 
      
    static testMethod void testRecentActivityWithNoCase(){ 
    	Account objAccount = RecentActivityRMControllerTest.createAccount();
        insert objAccount;
        
        RecentActivityRMController objRecentActivityRMController = new RecentActivityRMController();
        objRecentActivityRMController.CustomerCRN=objAccount.CRN__c;
        objRecentActivityRMController.noOfRecords=4;
        List<Case> lstCase2 = new List<Case>();
        objRecentActivityRMController.lstCase=Null;
        Test.startTest();
           System.assertEquals(0,objRecentActivityRMController.lstCase.size());
        Test.stopTest();
        
    } 
}