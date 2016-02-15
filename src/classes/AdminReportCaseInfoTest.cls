/*@Created by: Deepak Pudi 
     @Created Date: 15/4/2015 -->
 
 -- ------------------------------------------------------------------------------
 | Modified By      | Modified Date       | Version        | Description         |
 --------------------------------------------------------------------------------
 |Deepak Pudi           21/4/2015             1.0           Test Class for CaseInfoController
 --------------------------------------------------------------------------------
 |
 ------------------------------------------------------------------------------ --*/
@isTest
public with sharing class AdminReportCaseInfoTest {
   /*This Method Creates test data for User,Account and Case*/
    static testMethod void caseInfo(){
  
          User objUser=AdminReportCaseInfoTest.createUser();
        insert objUser;
         
        
         SAPBookingIDAgentMapping_del__c objSAPBookingIDAgentMapping_del = new SAPBookingIDAgentMapping_del__c();
        objSAPBookingIDAgentMapping_del.Booking_ID__c='BK144521'; 
        objSAPBookingIDAgentMapping_del.Agent_Name__c=objUser.id;
        objSAPBookingIDAgentMapping_del.Wing__c='A';
        objSAPBookingIDAgentMapping_del.Project_Name__c='XYZ';
        objSAPBookingIDAgentMapping_del.Flat_No__c='4';
        insert objSAPBookingIDAgentMapping_del;
        
        // insert Account
        Map<Integer,Case> caseMap = new Map<Integer,Case>();
          Account objAccount = AdminReportCaseInfoTest.createAccount();
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
          objCase.Status='Open';
          
          objCase.Nature_of_Request__c='Complaint';
          objCase.Communication_Type__c = 'Outbound';
          objCase.Interaction_Mode__c = 'Email';
          objCase.Needs_approval_from_director__c = 'NO';
          
          objCase.Request_for_L1__c='Cancellation Related';
          objCase.Request_for_L2__c='Procedural information';
          objCase.Request_for_L3_a__c='Customer not contactable';
          objCase.Request_for_L3__c='Loan foreclosure';
          objCase.Case_Summary__c='testrooo';
          objCase.Case_Resolution__c='testooo';
          objCase.Date_of_Complaint__c=date.today();
          caseMap.put(i,objCase);
          lstCase1.add(objCase);
          }
          for(Integer i = 0; i < 11; i++){
          Case objCase2 = new Case();
          objCase2.AccountId = objAccount.Id;
          objCase2.Project__c='XY';
          objCase2.Buildings_Name__c='z';
          objCase2.Wing__c='A';
          objCase2.Flat_No__c = '4';
          objCase2.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Other Cases').getRecordTypeId();
          objCase2.Status='New';
          
          objCase2.Nature_of_Request__c='Grievance';
          objCase2.Communication_Type__c = 'Inbound';
          objCase2.Interaction_Mode__c = 'Email';
          objCase2.Needs_approval_from_director__c = 'YES';
          
          objCase2.Request_for_L1__c='Cancellation Related';
          objCase2.Request_for_L2__c='Procedural information';
          objCase2.Request_for_L3_a__c='Customer not contactable';
          objCase2.Request_for_L3__c='Loan foreclosure';
          objCase2.Case_Summary__c='testrooo';
          objCase2.Case_Resolution__c='testooo';
          objCase2.Date_of_Complaint__c=date.today();
          caseMap.put(i,objCase2);
          lstCase1.add(objCase2);
          }
           for(Integer i = 0; i < 11; i++){
          Case objCase3 = new Case();
          objCase3.AccountId = objAccount.Id;
          objCase3.Project__c='XY';
          objCase3.Buildings_Name__c='z';
          objCase3.Wing__c='A';
          objCase3.Flat_No__c = '4';
          objCase3.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Other Cases').getRecordTypeId();
          objCase3.Status='New';
          
          objCase3.Nature_of_Request__c='Grievance';
          objCase3.Communication_Type__c = 'Outbound';
          objCase3.Interaction_Mode__c = 'Call';
          objCase3.Needs_approval_from_director__c = 'YES';
          
          objCase3.Request_for_L1__c='Cancellation Related';
          objCase3.Request_for_L2__c='Procedural information';
          objCase3.Request_for_L3_a__c='Customer not contactable';
          objCase3.Request_for_L3__c='Loan foreclosure';
          objCase3.Case_Summary__c='testrooo';
          objCase3.Case_Resolution__c='testooo';
          objCase3.Date_of_Complaint__c=date.today();
          caseMap.put(i,objCase3);
          lstCase1.add(objCase3);
          }
          
         
          for(Integer i = 0; i < 11; i++){
          Case objCase1 = new Case();
          objCase1.AccountId = objAccount.Id;
          objCase1.Project__c='XY';
          objCase1.Buildings_Name__c='z';
          objCase1.Wing__c='A';
          objCase1.Flat_No__c = '4';
          objCase1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Other Cases').getRecordTypeId();
          objCase1.Status='New';
          
          objCase1.Nature_of_Request__c='Grievance';
          objCase1.Communication_Type__c = 'Inbound';
          objCase1.Interaction_Mode__c = 'Call';
          objCase1.Needs_approval_from_director__c = 'YES';
          
          objCase1.Request_for_L1__c='Cancellation Related';
          objCase1.Request_for_L2__c='Procedural information';
          objCase1.Request_for_L3_a__c='Customer not contactable';
          objCase1.Request_for_L3__c='Loan foreclosure';
          objCase1.Case_Summary__c='testrooo';
          objCase1.Case_Resolution__c='testooo';
          objCase1.Date_of_Complaint__c=date.today();
          caseMap.put(i,objCase1);
          lstCase1.add(objCase1);
          }
          insert lstCase1;
        
        
        Test.startTest();
            AdminReportCaseInfoController CaseReport = new AdminReportCaseInfoController();
            
            CaseReport.caseRecordDisplay(date.today(),date.today());
            CaseReport.ExportToCSV();
            CaseReport.searchByFilter();
            
        Test.stopTest();
    }
    /*Creates User*/
    private static User createUser(){
        Profile objProfile = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User objUser = new User(Alias = 'standt', Email='testUserNew@test.com', 
        EmailEncodingKey='UTF-8', LastName='Tester', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = objProfile.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='amarjanuka@test.com');
        return objUser;
    } 
    
      /*Creates Account*/
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
      
     /*Meathod to Cover Error Msg*/
      private static testMethod void errorMsg(){
          List<Apexpages.Message> msgs = ApexPages.getMessages();
            boolean b = false;
            for(Apexpages.Message msg:msgs){
                if (msg.getDetail().contains(' From Date should be less than or equal to To Date.')) b = true;
            }
            //system.assert(b);
       }

}