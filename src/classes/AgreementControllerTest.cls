/*
*    Description :    Apex Test class for AgreementController
*/

@isTest(SeeAllData=false)
public class AgreementControllerTest {

    // Test Method to check if the Session Id gets generated for NON HEYDERABAD projects
    public static testMethod void enableViewAgreementNonHyderabadProject(){

        List<Account> listTestAccount = AgreementControllerTest.getAccountRecords(1);
        listTestAccount[0].OwnerId = Userinfo.getUserId();
        insert listTestAccount;
        
        List<Contact> listTestContact = AgreementControllerTest.getContactRecords(1);
        listTestContact[0].AccountId = listTestAccount[0].Id;
        insert listTestContact;
        
        User objTestUser = AgreementControllerTest.getUserRecord('Custom Overage High Volume Customer Portal', 'Testing');
        objTestUser.ContactId = listTestContact[0].Id;
        //insert objTestUser;
        
        List<Booking_Details__c> listTestBookingDetails = AgreementControllerTest.getBookingDetailsRecord(1);
        listTestBookingDetails[0].Account__c = listTestAccount[0].Id;
        listTestBookingDetails[0].CLuster__c = 'testCluster';
        insert listTestBookingDetails;
        
        List<BoxConfiguration__c> listTestBoxConfig = AgreementControllerTest.getBoxConfig(listTestBookingDetails[0].Project__c, 
                                                                                           listTestBookingDetails[0].CLuster__c,
                                                                                           'Mumbai');
        insert listTestBoxConfig;
        
        View_Agreement_CV_Limits__c oCVLimit = AgreementControllerTest.getCvLimit();
        insert oCVLimit;
        
        List<Demands__c> listTestDemands = AgreementControllerTest.getDemandRecord(1);
        listTestDemands[0].Flat_ID__c = listTestBookingDetails[0].Id;
        insert listTestDemands;
        
        update listTestBookingDetails;
        
        List<Project_Name__c> listTestProjectName = AgreementControllerTest.getProjectNameRecord(1);
        insert listTestProjectName;
        
        List<Cluster__c> listTestCluster = new List<Cluster__c>();
        
        test.startTest();
        AgreementController oAgreementController = new AgreementController();        
        System.runAs(objTestUser){

            oAgreementController.enableViewAgreementButton();
            System.assertEquals(oAgreementController.strDocumentId, '1234');
        }
        test.stopTest();
    }
    
    // Test Method to check if the Session Id gets generated for Hyderabad projects
    public static testMethod void enableViewAgreementHyderabadProject(){

        List<Account> listTestAccount = AgreementControllerTest.getAccountRecords(1);
        listTestAccount[0].OwnerId = Userinfo.getUserId();
        insert listTestAccount;
        
        List<Contact> listTestContact = AgreementControllerTest.getContactRecords(1);
        listTestContact[0].AccountId = listTestAccount[0].Id;
        insert listTestContact;
        
        User objTestUser = AgreementControllerTest.getUserRecord('Custom Overage High Volume Customer Portal', 'Testing');
        objTestUser.ContactId = listTestContact[0].Id;
        //insert objTestUser;
        
        List<Booking_Details__c> listTestBookingDetails = AgreementControllerTest.getBookingDetailsRecord(1);
        listTestBookingDetails[0].Account__c = listTestAccount[0].Id;
        listTestBookingDetails[0].CLuster__c = 'testCluster';
        insert listTestBookingDetails;
        
        List<BoxConfiguration__c> listTestBoxConfig = AgreementControllerTest.getBoxConfig(listTestBookingDetails[0].Project__c, 
                                                                                           listTestBookingDetails[0].CLuster__c,
                                                                                           'Hyderabad');
        insert listTestBoxConfig;
        
        View_Agreement_CV_Limits__c oCVLimit = AgreementControllerTest.getCvLimit();
        insert oCVLimit;
        
        List<Demands__c> listTestDemands = AgreementControllerTest.getDemandRecord(1);
        listTestDemands[0].Flat_ID__c = listTestBookingDetails[0].Id;
        insert listTestDemands;
        
        update listTestBookingDetails;
        
        List<Project_Name__c> listTestProjectName = AgreementControllerTest.getProjectNameRecord(1);
        insert listTestProjectName;
        
        List<Cluster__c> listTestCluster = new List<Cluster__c>();
        
        test.startTest();
        AgreementController oAgreementController = new AgreementController();        
        System.runAs(objTestUser){

            oAgreementController.enableViewAgreementButton();
            System.assertEquals(oAgreementController.strDocumentId, '1234');
        }
        test.stopTest();
    }
    
    //Method to create Test Account Record
    public static List<Account> getAccountRecords(Integer pNumberOfRecrods){
        
        List<Account> listTestAccount = new List<Account>();
        
        //List<RecordType> listRecType = [select id from RecordType where Name='Business Account' and sObjectType='Account'];
        List<RecordType> listRecType = [select id from RecordType where Name='Business Account' and sObjectType='Account'];
        
        for(Integer intIndex = 0; intIndex < pNumberOfRecrods; intIndex++){
        
            Account tempAccount = new Account();
            tempAccount.Name = 'testAccount';
            tempAccount.Count_of_View_Agreement__c = 0;
            //tempAccount.OwnerId = Userinfo.getUserId();
            tempAccount.RecordTypeId = listRecType[0].id;
            
            listTestAccount.add(tempAccount);
        }
        return listTestAccount;
    }
    
    //Method to create Test Contact Record
    public static List<Contact> getContactRecords(Integer pNumberOfRecords){
    
        List<Contact> listTestContact = new List<Contact>();
        
        for(Integer intIndex = 0; intIndex < pNumberOfRecords; intIndex++){
        
            Contact tempContact = new Contact();
            tempContact.FirstName = 'Test';
            tempContact.LastName = 'Test';
            
            listTestContact.add(tempContact);
        }
        return listTestContact;
    }
    
    //Method to create Test User Record for Customer Care Profile
    public static User getUserRecord(String pStrProfile, String pStrLastName){
    
        Profile customerProfile = [select Id
                                   from Profile
                                   where Name = :pStrProfile];
        
        User objTestUser = new User();
        objTestUser.Alias = 'standt';
        objTestUser.Email = 'standarduser@testorg.com'; 
        objTestUser.EmailEncodingKey = 'UTF-8';
        objTestUser.LastName = pStrLastName;
        objTestUser.FirstName = 'Testing';
        objTestUser.LanguageLocaleKey = 'en_US'; 
        objTestUser.LocaleSidKey = 'en_US';
        objTestUser.ProfileId = customerProfile.Id; 
        objTestUser.TimeZoneSidKey = 'America/Los_Angeles';
        objTestUser.UserName = pStrLastName + 'standarduser@testorg.com';
        objTestUser.IsActive = true;
        objTestUser.CommunityNickname = pStrLastName;
        
        return objTestUser;
    }
    
    //Method to create Test Record for Booking Details
    private static List<Booking_Details__c> getBookingDetailsRecord(Integer pNumberOfRecords){
    	
    	List<Booking_Details__c> listTestBookingDetail = new List<Booking_Details__c>();
    	Date dAllotmentDate = System.today();
        
        for(Integer intIndex = 0; intIndex < pNumberOfRecords; intIndex++){
        
            Booking_Details__c tempBookingDetail = new Booking_Details__c();
            tempBookingDetail.CRN__c = '112233';
            tempBookingDetail.Flat_ID__c = 'Test';
            tempBookingDetail.Allotment_Date__c = dAllotmentDate;
            tempBookingDetail.CLuster__c = 'testCluster';
            tempBookingDetail.Project__c = 'testProject';
            tempBookingDetail.Consideration_Value__c  = 1000000; 
            
            listTestBookingDetail.add(tempBookingDetail);
        }
        return listTestBookingDetail;
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
    
    //Method to create test record for Box Configuration
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
    
    //Method to create test record for View Agreement CV Limit custom setting
    private static View_Agreement_CV_Limits__c getCvLimit(){
        
        View_Agreement_CV_Limits__c oCvLimit = new View_Agreement_CV_Limits__c();
        oCvLimit.CV_Paid_Lower_Limit__c = 9.9;
        oCvLimit.CV_Paid_Upper_Limit__c = 35;
        return oCvLimit;
    }
}