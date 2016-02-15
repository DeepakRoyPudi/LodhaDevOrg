/*
*        Description : Test Class for AttachmentRelatedListController
*
*        Version     Date          Author             Description
*        1.0         05/08/2014    Asmita(Eternus)    Intial Draft
*/

@isTest
private class AttachmentRelatedListControllerTest {

    static testMethod void AttachmentRelatedListTest() {
    	
    	ApexPages.StandardController sc;
        AttachmentRelatedListController objAttachmentRelatedList;
        
        List<CM_Tat_Calculation__c> listAllCmTatCalculation = new List<CM_Tat_Calculation__c>();
        
        // Creating Custom Setting Records for CM_TAT_Calculations called from CM_CaseTATCalculationand SMSNotificationError
    	List<CM_Tat_Calculation__c> listCmTatCalculation = CaseTriggerHandlerTest.getCmTatCalculationRecords(1,'Parent');
    	listAllCmTatCalculation.addAll(listCmTatCalculation);    	
    	listCmTatCalculation = CaseTriggerHandlerTest.getCmTatCalculationRecords(1,'Child');
    	listAllCmTatCalculation.addAll(listCmTatCalculation);   	
    	listCmTatCalculation = CaseTriggerHandlerTest.getCmTatCalculationRecords(1,'AIFTM');
    	listAllCmTatCalculation.addAll(listCmTatCalculation);   	
    	listCmTatCalculation = CaseTriggerHandlerTest.getCmTatCalculationRecords(1,'AISPOC');
    	listAllCmTatCalculation.addAll(listCmTatCalculation);
    	insert listAllCmTatCalculation;
    	
	    // Creating Account
        List<Account> listAccount = AttachmentRelatedListControllerTest.getAccountRecord(1);
        insert listAccount;
        
        // Creating Contact
        List<Contact> listContact = AttachmentRelatedListControllerTest.getContactRecords(1);
        listContact[0].AccountId = listAccount[0].Id;
        insert listContact;
        
        // Creating User Of Functional Team Lead Profile
        User objTestUser = AttachmentRelatedListControllerTest.getUserRecord('Functional Team Member');
        //objTestUser.ContactId = listContact[0].Id;
        insert objTestUser;
        
        // Creating Cases
        List<Case> listAllCase = AttachmentRelatedListControllerTest.getCaseRecords(1);
    	listAllCase[0].AccountId = listAccount[0].id;
    	insert listAllCase;
		
		// Creating Attachment
		List<Attachment> listAttachment = AttachmentRelatedListControllerTest.getAttachmentRecord(1);
        listAttachment[0].ParentId = listAllCase[0].Id;
        insert listAttachment;
        
        test.startTest();
        
            sc = new ApexPages.StandardController(listAllCase[0]);
            objAttachmentRelatedList = new AttachmentRelatedListController(sc);
            
            System.runAs(objTestUser){
            	
            	objAttachmentRelatedList.renderActionLinks();
            }

                objAttachmentRelatedList.toggleSort(); 
                System.debug('Attachment Id ::::: ' + listAttachment[0].Id);
                ApexPages.currentPage().getParameters().put('attachId', listAttachment[0].Id); 
                
                System.assertEquals('/' + listAttachment[0].Id, objAttachmentRelatedList.openAttachment().getUrl());
                System.assertEquals('/' + listAttachment[0].Id + '/e?retURL=%2F' + listAllCase[0].Id, objAttachmentRelatedList.editAttachment().getUrl());
                System.assertEquals(null, objAttachmentRelatedList.attachFile());
                System.assertEquals(null, objAttachmentRelatedList.viewFile());
                System.assertEquals(null, objAttachmentRelatedList.attachFile());
                objAttachmentRelatedList.listAttachment.add(listAttachment[0]);
                objAttachmentRelatedList.deleteAttachment();
        
                //searchName != '' && fromDate != null && toDate != null
                objAttachmentRelatedList.searchName = 'testFile*';
                objAttachmentRelatedList.objTask1.ActivityDate = System.today();
                objAttachmentRelatedList.objTask2.ActivityDate = System.today(); 
                System.assertEquals(null, objAttachmentRelatedList.searchByFilter());
        
                //searchName != '' && fromDate != null && toDate == null
                objAttachmentRelatedList.searchName = 'testFile*';
                objAttachmentRelatedList.objTask1.ActivityDate = System.today();
                objAttachmentRelatedList.objTask2.ActivityDate = null;
                System.assertEquals(null, objAttachmentRelatedList.searchByFilter());
        
                //searchName != '' && fromDate == null && toDate != null
                objAttachmentRelatedList.searchName = 'testFile*';
                objAttachmentRelatedList.objTask1.ActivityDate = null;
                objAttachmentRelatedList.objTask2.ActivityDate = System.today();
                System.assertEquals(null, objAttachmentRelatedList.searchByFilter());
        
                //searchName != '' && fromDate == null && toDate == null
                objAttachmentRelatedList.searchName = 'testFile*';
                objAttachmentRelatedList.objTask1.ActivityDate = null;
                objAttachmentRelatedList.objTask2.ActivityDate = null;
                System.assertEquals(null, objAttachmentRelatedList.searchByFilter());
        
                //searchName == '' && fromDate != null && toDate != null
                objAttachmentRelatedList.searchName = '';
                objAttachmentRelatedList.objTask1.ActivityDate = System.today();
                objAttachmentRelatedList.objTask2.ActivityDate = System.today();
                System.assertEquals(null, objAttachmentRelatedList.searchByFilter());
        
                //searchName == '' && fromDate == null && toDate != null
                objAttachmentRelatedList.searchName = '';
                objAttachmentRelatedList.objTask1.ActivityDate = null;
                objAttachmentRelatedList.objTask2.ActivityDate = System.today();
                System.assertEquals(null, objAttachmentRelatedList.searchByFilter());
        
                //searchName == '' && fromDate != null && toDate == null
                objAttachmentRelatedList.searchName = '';
                objAttachmentRelatedList.objTask1.ActivityDate = System.today();
                objAttachmentRelatedList.objTask2.ActivityDate = null;
                System.assertEquals(null, objAttachmentRelatedList.searchByFilter());
        test.stopTest();
	}
	
	    // Creating Account records
    public static List<Account> getAccountRecord(Integer pNumberOfRecords){
        
        Account oAcc = new Account();
        List<Account> listAccount = new List<Account>();
        
        for(Integer i = 0 ; i < pNumberOfRecords; i++){
            
            oAcc = new Account();
            oAcc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
            oAcc.Name = 'TestAccount';
            oAcc.Mobile_Phone__c = '9211111111';
            
            listAccount.add(oAcc);
        }
        
        return listAccount;
    }// end of getAccountRecords
    
     // Method to create cases
    public static List<Case> getCaseRecords(Integer pNumberOfRecords){
    	
        List<Case> listOfCase = new List<Case>();
        Case oCase = new Case();
        
        for(Integer i = 0; i < pNumberOfRecords; i++){
            
            // Cearting Complaint type Case
            oCase = new Case();
            oCase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CM_Parent_Only').getRecordTypeId();
            oCase.Interaction_Mode__c = 'Email';
            oCase.Communication_Type__c = 'Inbound';
            oCase.Nature_of_Request__c = 'Request';
            oCase.Case_Resolution__c = 'test';
            oCase.Case_Summary__c = 'test';
            oCase.Request_for_L1__c = 'Collections Related';
            oCase.Request_for_L2__c = 'PTP';
            oCase.Request_for_L3_a__c = 'Reasons';
            oCase.Request_for_L3__c = 'L3';
            oCase.Reason_for_non_payment__c = 'OC Awaited';
            
            listOfCase.add(oCase);
            
        }// end of for
        
        return listOfCase;
    }// end of getCaseRecords
    
    // Creating Attachments
    public static List<Attachment> getAttachmentRecord(Integer pNumberOfRecords){
    
	    Attachment oAttach = new Attachment();
	    List<Attachment> listAttachment = new List<Attachment>();
	
	    for(Integer i = 0; i < pNumberOfRecords; i++){
	    
		    oAttach = new Attachment();
		
		    oAttach.Name = 'testFile';
		    oAttach.Description = 'test description';
		    oAttach.Body = Blob.valueOf('Test File Contents');
		
		    listAttachment.add(oAttach);
        }
	
	    return listAttachment;
    }
    
    //creating Contact Record
    private static List<Contact> getContactRecords(Integer pNumberOfRecords){
    
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
    private static User getUserRecord(String pStrProfile){
    
        Profile customerProfile = [select Id
                                   from Profile
                                   where Name = :pStrProfile];
        
        User objTestUser = new User();
        objTestUser.Alias = 'standt';
        objTestUser.Email = 'standarduser@testorg.com'; 
        objTestUser.EmailEncodingKey = 'UTF-8';
        objTestUser.LastName = 'TestUser';
        objTestUser.FirstName = 'Testing';
        objTestUser.LanguageLocaleKey = 'en_US'; 
        objTestUser.LocaleSidKey = 'en_US';
        objTestUser.ProfileId = customerProfile.Id; 
        objTestUser.TimeZoneSidKey = 'America/Los_Angeles';
        objTestUser.UserName = 'TestUserstandarduser@testorg.com';
        objTestUser.IsActive = true;
        objTestUser.CommunityNickname = 'TestUser';
        
        return objTestUser;
    }
}