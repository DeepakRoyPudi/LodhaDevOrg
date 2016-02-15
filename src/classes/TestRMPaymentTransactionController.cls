@Istest(seealldata=false)
Public class TestRMPaymentTransactionController{
  
    static testmethod void testTransactionController(){
    
        Profile objProfile = [SELECT Id FROM Profile WHERE Name='Accounts Admin']; 
        
        User objUser = TestRMPaymentTransactionController.createUser(objProfile);
        insert objUser;
        
        Account objAccount = TestRMPaymentTransactionController.createAccount();
        insert objAccount;
    
        
        Booking_Details__c bd = TestRMPaymentTransactionController.createBookingDetail(objAccount);
        insert bd;
        
        Test.startTest();
        ApexPages.StandardController controller = new ApexPages.StandardController(new Booking_Payment_Transaction__c());
        
        RMPaymentTransactionController objRMPTC1 = new RMPaymentTransactionController(controller); 
        objRMPTC1.fetch();
        
        Apexpages.currentpage().getParameters().put('CRN', '1234');
        RMPaymentTransactionController objRMPTC2 = new RMPaymentTransactionController(controller);
        
        Apexpages.currentpage().getParameters().put('CRN', objAccount.CRN__c);
        System.runAs(objUser){
            RMPaymentTransactionController objRMPTC = new RMPaymentTransactionController(controller);  
        }
        RMPaymentTransactionController objRMPTC3 = new RMPaymentTransactionController(controller);
        objRMPTC3.addAttachment();
        
        objRMPTC3.bpt.Type_of_Transaction_del__c='RTGS';
        objRMPTC3.bpt.UTR_Code__c='12345678911111111';  
        objRMPTC3.bpt.Bank_Account_Holders_Name__c='Test';
        objRMPTC3.bpt.Amount_Transferred__c=1200;
        objRMPTC3.bpt.Remitted_to_Account__c='test';
        objRMPTC3.bpt.Transaction_Date__c= date.newinstance(2013,5,2);
        objRMPTC3.bpt.Bank_Name__c='Andhra Bank';
        
        objRMPTC3.addAttachment();
        
        objRMPTC3.bpt.UTR_Code__c = null;
        objRMPTC3.addAttachment();
        
        objRMPTC3.bpt.Type_of_Transaction_del__c = 'Direct Cheque';
        objRMPTC3.bpt.UTR_Code__c='123456';
        objRMPTC3.bpt.MT940__c = NULL;
        objRMPTC3.bptSave();
        
        objRMPTC3.bpt.Type_of_Transaction_del__c = 'RTGS';
        objRMPTC3.bpt.UTR_Code__c='12345';
        objRMPTC3.bptSave();
        
        objRMPTC3.bpt.Type_of_Transaction_del__c = 'Direct Cheque';
        objRMPTC3.bpt.UTR_Code__c='123456';
        objRMPTC3.bpt.MT940__c = 'Yes';
        objRMPTC3.lstAttachment = TestRMPaymentTransactionController.createAttachment(5);
        objRMPTC3.bptSave();
        System.assertEquals(objRMPTC3.bpt.Id, objRMPTC3.lstAttachment[0].parentId);
        Test.stopTest();
        
        /*RMPaymentTransactionController trans2 = new RMPaymentTransactionController(controller);  
        
        trans2.crn = '121212';
        trans2.fetch();
        trans2.bpt.Type_of_Transaction_del__c='NEFT';
        trans2.bpt.UTR_Code__c='12345';  
        trans2.bpt.Bank_Account_Holders_Name__c='Test';
        trans2.bpt.Amount_Transferred__c=1200;
        trans2.bpt.Remitted_to_Account__c='test';
        trans2.bpt.Transaction_Date__c= date.newinstance(2013,5,2);
        trans2.bpt.Bank_Name__c='Andhra Bank';
        trans2.bptSave();
        
        ApexPages.StandardController controller3 = new ApexPages.StandardController(new Booking_Payment_Transaction__c()); 
        RMPaymentTransactionController trans3 = new RMPaymentTransactionController(controller);  
        
        trans3.crn = '121212';
        trans3.fetch();
        trans3.bpt.Type_of_Transaction_del__c='NEFT';
        trans3.bpt.UTR_Code__c='12345678911111111';  
        trans3.bpt.Bank_Account_Holders_Name__c='Test';
        trans3.bpt.Amount_Transferred__c=1200;
        trans3.bpt.Remitted_to_Account__c='test';
        trans3.bpt.Transaction_Date__c= date.newinstance(2013,5,2);
        trans3.bpt.Bank_Name__c='Andhra Bank';
        trans3.bptSave();
        
        ApexPages.StandardController controller6 = new ApexPages.StandardController(new Booking_Payment_Transaction__c()); 
        RMPaymentTransactionController trans6 = new RMPaymentTransactionController(controller);  
        
        trans6.crn = '121212';
        trans6.fetch();
        trans6.bpt.Type_of_Transaction_del__c='RTGS';
        trans6.bpt.UTR_Code__c='12345678911111111';  
        trans6.bpt.Bank_Account_Holders_Name__c='Test';
        trans6.bpt.Amount_Transferred__c = 1200;
        trans6.bpt.Remitted_to_Account__c = 'test';
        trans6.bpt.Transaction_Date__c = date.newinstance(2013,5,2);
        trans6.bpt.Bank_Name__c = 'Andhra Bank';
        trans6.bptSave();
        
        PageReference pgRef = new PageReference('/apex/RM_Payment_Transaction?CRN=121212');
        Test.setCurrentPage(pgRef); //Set the page for Test Method
        ApexPages.StandardController controller4 = new ApexPages.StandardController(new Booking_Payment_Transaction__c());         
        RMPaymentTransactionController trans4 = new RMPaymentTransactionController(controller); 

        PageReference pgRef1 = new PageReference('/apex/RM_Payment_Transaction?CRN=121211');
        Test.setCurrentPage(pgRef1); //Set the page for Test Method
        ApexPages.StandardController controller5 = new ApexPages.StandardController(new Booking_Payment_Transaction__c());         
        RMPaymentTransactionController trans5 = new RMPaymentTransactionController(controller); */
    }
    
    private static User createUser(Profile objProfile){
        return new User(Alias = 'newUser', Email='newuser@testorg.com', 
                           EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = objProfile.Id, 
                           TimeZoneSidKey='America/Los_Angeles', UserName='T3user@testorg.com');
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
    private static List<Attachment> createAttachment(Integer recordCount){
         List<Attachment> lstAttachment = new List<Attachment>();
        
         for(Integer i = 1 ; i <= 200 ; i++)
         {
             Attachment objAttachment = new Attachment();
             objAttachment.Name = 'Test Attachment';
             objAttachment.Body = Blob.valueOf('Test Data');
             lstAttachment.add(objAttachment);
         }
         return lstAttachment;
     }
}