/* Version              Created By       Created Date       Description
 *
 *  Initial Draft       Madan           04/04/2015       This class contains unit tests for validating
 *														  the behavior of 
 *														  RecentActivityDetailRMController class
 */
@isTest
private class RecentActivityDetailRMControllerTest{

    static testMethod void recentActivityDetailWithCasesTest(){
        // creating user
        User objUser=RecentActivityDetailRMControllerTest.createUser();
        insert objUser;
        
        // creating test data for SAPBookingIDAgentMapping_del__c object
        SAPBookingIDAgentMapping_del__c objSAPBookingIDAgentMapping_del = new SAPBookingIDAgentMapping_del__c();
        objSAPBookingIDAgentMapping_del.Booking_ID__c='BK144521'; 
        objSAPBookingIDAgentMapping_del.Agent_Name__c=objUser.id;
        objSAPBookingIDAgentMapping_del.Wing__c='A';
        objSAPBookingIDAgentMapping_del.Project_Name__c='XYZ';
        objSAPBookingIDAgentMapping_del.Flat_No__c='4';
        insert objSAPBookingIDAgentMapping_del;
        
        Account objAccount = RecentActivityDetailRMControllerTest.createAccount();
        insert objAccount;
        
        List<Case> lstCase1 = new List<Case>();
        for(Integer i = 0; i < 11; i++){
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
        
        PageReference Pageref=Page.RecentActivityDetailRM;
        system.test.setCurrentPageReference(Pageref);
        ApexPages.CurrentPage().getparameters().put('CRN',objAccount.CRN__c);
        ApexPages.CurrentPage().getparameters().put('frm',objAccount.LastName);
        
        
        RecentActivityDetailRMController objRecentActivityDetailRMController = new RecentActivityDetailRMController();

        Test.startTest();
        system.assertEquals(10,objRecentActivityDetailRMController.caseList.size()); 
        objRecentActivityDetailRMController.toggleSortSMS();
        objRecentActivityDetailRMController.FirstPage();
        system.assertEquals(0,objRecentActivityDetailRMController.OffsetSize);
        
        system.assertEquals(true,objRecentActivityDetailRMController.getprev());
        
        objRecentActivityDetailRMController.next();
        system.assertEquals(10,objRecentActivityDetailRMController.OffsetSize);
        
        objRecentActivityDetailRMController.previous();
        system.assertEquals(0,objRecentActivityDetailRMController.OffsetSize);

        objRecentActivityDetailRMController.LastPage();
        system.assertEquals(10,objRecentActivityDetailRMController.OffsetSize);
        system.assertEquals(true,objRecentActivityDetailRMController.getnxt());
        
        objRecentActivityDetailRMController.getRecordNos();
        
        Test.stopTest();
    }
    
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
        return objUser;
    } 
}