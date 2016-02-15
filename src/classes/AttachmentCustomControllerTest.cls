@isTest
private class AttachmentCustomControllerTest {

    static testMethod void testAttachmentCustomController() {
        
        Profile objProfile = [SELECT Id FROM Profile WHERE Name='Accounts Admin']; 
        User objUser = new User(Alias = 'newUser', Email='newuser@testorg.com', 
                               EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                               LocaleSidKey='en_US', ProfileId = objProfile.Id, 
                               TimeZoneSidKey='America/Los_Angeles', UserName='T1user@testorg.com');
        insert objUser;
        
        Account objAccount = AttachmentCustomControllerTest.createAccount();
        insert objAccount;
        
        Booking_Details__c bd = AttachmentCustomControllerTest.createBookingDetail(objAccount);
        insert bd;
        
        Booking_Payment_Transaction__c bpt = AttachmentCustomControllerTest.createBTR(bd);
        insert bpt;
        
        List<Attachment> lstAttachment = AttachmentCustomControllerTest.createAttachment(bpt, 5);
        insert lstAttachment;
        
        Apexpages.currentpage().getParameters().put('id', bpt.Id);
        ApexPages.StandardController controller = new ApexPages.StandardController(bpt); 
        
        
        Test.startTest();
        attachmentCustomController objACC;
        System.runAs(objUser){
            objACC = new attachmentCustomController(controller);
            objACC.attchId = lstAttachment[0].Id;
            objACC.editmethod();
            objACC.viewmethod();
        }
        objACC.deletemethod();
        System.assertEquals([Select Id from Attachment where Id =: objACC.attchId].size(), 0);
        bpt.Status__c = 'Approved';
        update bpt;
        objACC.attchId = lstAttachment[1].Id;
        objACC.deletemethod();
        Test.stopTest();
    }
    
    private static Account createAccount(){
        Account objAccount = new Account();
        objAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        objAccount.FirstName='Test ';
        objAccount.LastName='Account';
        objAccount.CRN__c='121212';
        objAccount.H_Mobile_No__c='4444411111';
        objAccount.Mobile_Phone__c='4444411111';
        objAccount.Co_Applicant__c='test';
        return objAccount;
    }
    
    private static Booking_Details__c createBookingDetail(Account objAccount){
        Booking_Details__c bd = new Booking_Details__c();
        bd.Account__c = objAccount.Id;
        bd.CRN__c = '121212';
        bd.Flat_ID__c ='147147';
        bd.Allotment_Date__c = System.today();
        bd.Project__c = 'Test';
        bd.Cluster__c = 'Clust';
        bd.wing__c = 'Wng';
        return bd;
    }
    
     private static Booking_Payment_Transaction__c createBTR(Booking_Details__c objBD){
        Booking_Payment_Transaction__c bpt = new Booking_Payment_Transaction__c();
        bpt.Booking__c = objBD.Id;
        bpt.Type_of_Transaction_del__c = 'NEFT';
        bpt.UTR_Code__c = 'NEW12345678';
        bpt.Bank_Name__c = 'Citibank N.A.';
        bpt.Amount_Transferred__c = 1000;
        bpt.Remitted_to_Account__c = '1000';
        bpt.Transaction_Date__c = System.today();
        bpt.Bank_Account_Holders_Name__c = 'Test';
        return bpt;
     }
     
     private static List<Attachment> createAttachment(Booking_Payment_Transaction__c objBTR, Integer recordCount){
         List<Attachment> lstAttachment = new List<Attachment>();
        
         for(Integer i = 1 ; i <= 200 ; i++)
         {
             Attachment objAttachment = new Attachment();
             objAttachment.ParentId = objBTR.Id;
             objAttachment.Name = 'Test Attachment';
             objAttachment.Body = Blob.valueOf('Test Data');
             lstAttachment.add(objAttachment);
         }
         return lstAttachment;
     }
}