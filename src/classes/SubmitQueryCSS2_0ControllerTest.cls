@isTest
/*<!-- Test class for SubmitQueryCSS2_0Controller 
@Created by: Trupti Dhoka
@Created Date: 04/03/2015

--------------------------------------------------------------------------------
| Modified By      | Modified Date       | Version        | Description         |
--------------------------------------------------------------------------------
|Aditi Mulmule      08/07/2015               1.1           1.Updated Test class for
                                                            new functionality of
                                                            case creation and inclusion of
                                                            Related to picklist with
                                                            all error conditions asserted
                                                           2.CRN null test scenario
---------------------------------------------------------------------------------------------

-->*/
public class SubmitQueryCSS2_0ControllerTest {
 // Test method to check case creation on submiting query
 static testmethod void submitTest() {
        // Create account
         Account objAccount = createAccount();
        insert objAccount;
        // Query account to get contact id of related account
        Account insertedAccountwithcontact=[Select Id,
                                               Name,
                                               (select id from contacts ) 
                                        From account 
                                        Where id=:objAccount.id];
        Id conid = insertedAccountwithcontact.contacts[0].id ;
     
        // Create user
        User objUser = createUser(conid);
        insert objUser;
        system.runAs(objUser){
               PageReference pageRef = Page.HomeCSS2_0; 
               SubmitQueryCSS2_0Controller queryObj = new SubmitQueryCSS2_0Controller();
               system.Test.setCurrentPage(pageRef);
               //Both fields selected
               system.test.startTest();
               queryObj.case_obj.Description ='Test Case creation';
               queryObj.case_obj.Request_for_L1__c ='Cancellation Related';
               queryObj.account_obj.Owner.Email='aaa@gmail.com'; 
               queryObj.submitQuery();
               // Assert whether popup for query submitted is displayed
               system.assertEquals(true,queryObj.displayPopup);
               queryObj.closePopup();
               system.test.stopTest();
               // Assert whether popup for query submitted is closed
               system.assertEquals(false,queryObj.displayPopup);
               Case caseObject = [Select Id, Interaction_Mode__c,
                                         Communication_Type__c,
                                         Status,
                                         Nature_of_Request__c,
                                         Request_for_L2__c,
                                         Request_for_L3_a__c,
                                         Request_for_L3__c
                                  from  Case
                                  where AccountId=:objAccount.Id];
               // Asserting values of case created as expected                  
               system.assertEquals('CSS',caseObject.Interaction_Mode__c);
               system.assertEquals('Inbound',caseObject.Communication_Type__c);
               system.assertEquals('Open',caseObject.Status);
               system.assertEquals('Query',caseObject.Nature_of_Request__c);
               system.assertEquals('L2',caseObject.Request_for_L2__c);
               system.assertEquals('L3',caseObject.Request_for_L3_a__c);
               system.assertEquals('L3',caseObject.Request_for_L3__c);
        }
 }      
 // Test method for checking error thrown for mandatory description and Related to fields
 static testmethod void errorConditionTest() {
        // Create account
         Account objAccount = createAccount();
        insert objAccount;
        // Query account to get contact id of related account
        Account insertedAccountwithcontact=[Select Id,
                                               Name,
                                               (select id from contacts ) 
                                        From account 
                                        Where id=:objAccount.id];
        Id conid = insertedAccountwithcontact.contacts[0].id ;
     
        // Create user
        User objUser = createUser(conid);
        insert objUser;
        system.runAs(objUser){
               PageReference pageRef = Page.HomeCSS2_0; 
               SubmitQueryCSS2_0Controller queryObj = new SubmitQueryCSS2_0Controller();
               system.Test.setCurrentPage(pageRef);
               system.test.startTest();
               // Both fields selected
               queryObj.case_obj.Description ='Test Case creation';
               queryObj.case_obj.Request_for_L1__c ='Cancellation Related';
               queryObj.account_obj.Owner.Email='aaa@gmail.com'; 
               queryObj.submitQuery();
               system.assertEquals(system.label.SubmitAQuerySuccessMessage,queryObj.response);
               queryObj.closePopup();
               // Description is null
               queryObj.case_obj.Description =null;
               queryObj.case_obj.Request_for_L1__c ='Cancellation Related';
               queryObj.account_obj.Owner.Email='aaa@gmail.com'; 
               queryObj.submitQuery();
               system.assert(ApexPages.getMessages()[0].getDetail().contains(system.label.SubmitAQueryDescriptionError));
               // Request for L1 is null
               queryObj.case_obj.Description ='Test Case creation';
               queryObj.case_obj.Request_for_L1__c =null;
               queryObj.account_obj.Owner.Email='aaa@gmail.com'; 
               queryObj.submitQuery();
               system.assert(ApexPages.getMessages()[1].getDetail().contains(system.label.SubmitAQueryBroadlyRelatedTo));
               // Description and Request for L1 both are null
               queryObj.case_obj.Description = null;
               queryObj.case_obj.Request_for_L1__c = null;
               queryObj.account_obj.Owner.Email='aaa@gmail.com'; 
               queryObj.submitQuery();
               system.assert(ApexPages.getMessages()[2].getDetail().contains(system.label.SubmitAQueryRelatedToAndDescriptionError));
               system.test.stopTest();
         }
 
 } 
 // Test menthod to check functionality on page other than home page
 static testmethod void pageOtherthanHome() {
        // Create account
         Account objAccount = createAccount();
        insert objAccount;
        // Query account to get contact id of related account
        Account insertedAccountwithcontact=[Select Id,
                                               Name,
                                               (select id from contacts ) 
                                        From account 
                                        Where id=:objAccount.id];
        Id conid = insertedAccountwithcontact.contacts[0].id ;
     
        // Create user
        User objUser = createUser(conid);
        insert objUser;
        system.runAs(objUser){
               PageReference pageRef = Page.BookingDetailsCSS2_0; 
               SubmitQueryCSS2_0Controller queryObj = new SubmitQueryCSS2_0Controller();
               system.Test.setCurrentPage(pageRef);
               // Both fields selected
               system.test.startTest();
               queryObj.case_obj.Description ='Test Case creation';
               queryObj.case_obj.Request_for_L1__c ='Cancellation Related';
               queryObj.account_obj.Owner.Email='aaa@gmail.com'; 
               queryObj.submitQuery();
               System.assertEquals(system.label.SubmitAQuerySuccessMessage,queryObj.response);
               queryObj.closePopup();
               system.test.stopTest();
        }
 }  
 // Test method to check error for CRN value null      
  static testmethod void CRNTest() {
 
        Account objAccount = createAccount();
        objAccount.CRN__c = null;
        insert objAccount;
        // Query account to get contact id of related account
        Account insertedAccountwithcontact=[Select Id,
                                               Name,
                                               (select id from contacts ) 
                                        From account 
                                        Where id=:objAccount.id];
        Id conid = insertedAccountwithcontact.contacts[0].id ;
     
        // Create user
        User objUser = createUser(conid);
        insert objUser;
        system.runAs(objUser){
               SubmitQueryCSS2_0Controller queryObj = new SubmitQueryCSS2_0Controller();
               // Assert apex msg for null CRN
               system.test.startTest();
               System.assert(ApexPages.getMessages()[0].getDetail().contains(system.label.CRNvalueNull));
               system.test.stopTest();
 
        }
 
  }
    // Method to create Account
    private static Account createAccount() {
        Account objAccount = new Account();
        objAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Booked Account').getRecordTypeId();
        objAccount.LastName = 'Account 2';
        objAccount.CRN__c='1251333';
        return objAccount;
     }
    // Method to create user
    private static User createUser(Id contactId ) {
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
}