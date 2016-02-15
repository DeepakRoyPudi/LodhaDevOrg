/* Version              Created By       Created Date       Description
 *
 *  Initial Draft       Sneha P.         19/05/2015       Test Class for CreateQueryHelper
 ---------------------------------------------------------------------------------------------- 
    1.1                 Trupti D         13/07/2015       updated test class with reusable 
                                                            record creation methods 
 ---------------------------------------------------------------------------------------------- 
 */
@isTest
private class CreateQueryHelperTest {
     
     static testMethod void positiveTest() {
        
       account a = createAccount();
       insert a;
       
       User u = createUser(a);
       insert u;
       
       list<Case> clist = CreateCaseobj(a,10);
       insert clist;
       
       //create doc records
       list<Documents__c> docList = createDoc(a,11);
       insert doclist;
        
         //create list of SMs
       list<SMS_History__c> smslist = createSMS(a , 6);
       insert smslist;
       
         //create list of SMs
       list<Despatch__c> dispatchlist = createDispatch(a,6);
       insert dispatchlist;
       
        
       CreateQueryHelper helpercontroller = new CreateQueryHelper();
       CreateQueryHelper.getCustomerCRN(u.Id);
       
       test.StartTest(); 
	        //Recent Activity Crisp & Detail view - RM & CSS2_0
	        CreateQueryHelper.getRecords('Case','Id ','where Account.CRN__c = \'154215\'', 
	                                               CreateQueryHelper.RecentActivityCrispCSS, 
	                                              'Order by CreatedDate DESC','LIMIT '+5);
	        CreateQueryHelper.getRecords('Case','Id ','where Account.CRN__c = \'154215\'', 
	                                               CreateQueryHelper.RecentActivityDetailCSS , 
	                                              'Order by CreatedDate DESC','LIMIT '+5);                                      
	                                              
	          //Doc crisp & detail view -RM and CSS 2.0
	        CreateQueryHelper.getRecords('Documents__c','Id ','where Account__r.CRN__c = \'154215\'', 
	                                               CreateQueryHelper.RecentDocsCrispRM, 
	                                              'Order by CreatedDate DESC','LIMIT '+5);
	        
	        //Doc crisp & detail view -RM and CSS 2.0
	        CreateQueryHelper.getRecords('Documents__c','Id ','where Account__r.CRN__c = \'154215\'', 
	                                               CreateQueryHelper.RecentDocsCrispRM, 
	                                              'Order by CreatedDate DESC','LIMIT '+5);
	                                              
	        CreateQueryHelper.getRecords('Documents__c','Id ','where Account__r.CRN__c = \'154215\'', 
	                                               CreateQueryHelper.RecentDocsDetailRM, 
	                                              'Order by CreatedDate DESC','LIMIT '+5);
	        
	        CreateQueryHelper.getRecords('Documents__c','Id ','where Account__r.CRN__c = \'154215\'', 
	                                               CreateQueryHelper.RecentDocumentCrispCSS , 
	                                              'Order by CreatedDate DESC','LIMIT '+5);
	                                              
	        CreateQueryHelper.getRecords('Documents__c','Id ','where Account__r.CRN__c = \'154215\'', 
	                                               CreateQueryHelper.RecentDocumentDetailCSS , 
	                                              'Order by CreatedDate DESC','LIMIT '+5);
	        
	                                              
	        //For SMS Crisp
	        CreateQueryHelper.getRecords('SMS_History__c','Id ','where Account__r.CRN__c = \'154215\'', 
	                                               CreateQueryHelper.RecentSMSCrispRM, 
	                                              'Order by CreatedDate DESC','LIMIT '+5);
	                                              
	        CreateQueryHelper.getRecords('SMS_History__c','Id ','where Account__r.CRN__c = \'154215\'', 
	                                               CreateQueryHelper.RecentSMSDetailRM, 
	                                              'Order by CreatedDate DESC','LIMIT '+5);
	                                              
	                                                 
	        CreateQueryHelper.getRecords('SMS_History__c','Id ','where Account__r.CRN__c = \'154215\'', 
	                                               CreateQueryHelper.RecentSMSCrispCSS , 
	                                              'Order by CreatedDate DESC','LIMIT '+5);
	        
	                                                 
	        CreateQueryHelper.getRecords('SMS_History__c','Id ','where Account__r.CRN__c = \'154215\'', 
	                                               CreateQueryHelper.RecentSMSDetailCSS , 
	                                              'Order by CreatedDate DESC','LIMIT '+5);
	        //For Dispatch crisp & Detail view
	        
	                                                 
	        CreateQueryHelper.getRecords('Despatch__c','Id ','where Account__r.CRN__c = \'154215\'', 
	                                               CreateQueryHelper.RecentDispatchCrispCSS , 
	                                              'Order by CreatedDate DESC','LIMIT '+5);
	                                                 
	        CreateQueryHelper.getRecords('Despatch__c','Id ','where Account__r.CRN__c = \'154215\'', 
	                                               CreateQueryHelper.RecentDespatchDetailCSS , 
	                                              'Order by CreatedDate DESC','LIMIT '+5);
	        
	         CreateQueryHelper.getRecords('Despatch__c','Id ','where Account__r.CRN__c = \'154215\'', 
	                                               CreateQueryHelper.RecentDispatchCrispRM , 
	                                              'Order by CreatedDate DESC','LIMIT '+5);
	                                                 
	        CreateQueryHelper.getRecords('Despatch__c','Id ','where Account__r.CRN__c = \'154215\'', 
	                                               CreateQueryHelper.RecentDispatchDetailRM , 
	                                              'Order by CreatedDate DESC','LIMIT '+5);
	         
	         
	        //For BPT
	        CreateQueryHelper.getRecords('Booking_Payment_Transaction__c' ,
	                                            'Id','where CRN__c =  \'154215\'', 
	                                            CreateQueryHelper.BookingPaymnetsTransDetailRM , 
	                                           'Order by CreatedDate DESC','LIMIT '+5);    
	        
	        CreateQueryHelper.getRecords('Booking_Payment_Transaction__c' ,
	                                            'Id','where CRN__c =  \'154215\'', 
	                                            CreateQueryHelper.BookingPaymnetsTransCrispRM , 
	                                           'Order by CreatedDate DESC','LIMIT '+5);   
	          
	       //For Recent Activity                                 
	       CreateQueryHelper.getRecords('Case' ,
	                                        'Id','where Account.CRN__c  = \'154215\'', 
	                                        CreateQueryHelper.RecentActivityCrispRM , 
	                                       'Order by CreatedDate DESC','LIMIT '+5);    
	        
	        CreateQueryHelper.getRecords('Case','Id','where Account.CRN__c = \'154215\'', 
	                                            CreateQueryHelper.RecentActivityDetailRM , 
	                                           'Order by CreatedDate DESC','LIMIT '+5);    
                                           
       test.stopTest();
     }  
     
     // Method to create test data for Account object
    private static Account createAccount(){
        Account objAccount = new Account();
        objAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Booked Account').getRecordTypeId();
        objAccount.FirstName='Test1 ';
        objAccount.LastName='Account1';
        objAccount.CRN__c='154215';
        objAccount.H_Mobile_No__c='1234560789';
        objAccount.Mobile_Phone__c='21241222';
        objAccount.Co_Applicant__c='test';
        return objAccount;
      } 
       //method for creating community user
       private static User createUser(Account a)
       {
            User objUser = new User();
            contact c=[select id from contact where accountid=:a.id limit 1];
            objUser.ProfileID = [Select Id From Profile Where Name = 'Custom Overage High Volume Customer Portal'].id;
            objUser.EmailEncodingKey = 'ISO-8859-1';
            objUser.LanguageLocaleKey = 'en_US';
            objUser.TimeZoneSidKey = 'America/New_York';
            objUser.LocaleSidKey = 'en_US';
            objUser.FirstName = 'first';
            objUser.LastName = 'last';
            objUser.Username = 'test@appirio.com';
            objUser.CommunityNickname = 'testUser123';
            objUser.Alias = 't1';
            objUser.Email = 'no@email.com';
            objUser.IsActive = true;
            objUser.ContactId = c.id;
            return objUser;
        }
        
         private static list < Case > CreateCaseobj (Account a, Integer no) {
             List<Case> lstCase = new List<Case>();
            for(Integer i = 0; i < no; i++)
            {
               lstCase.add(new Case(
                AccountId = a.Id,
                Interaction_Mode__c = 'Email',
                Communication_Type__c = 'Inbound',
                Nature_of_Request__c = 'Query',
                Request_for_L1__c = 'Brokerage related',
                Request_for_L2__c = 'Brokerage related',
                Request_for_L3_a__c = 'Customer not contactable',
                Request_for_L3__c = 'CP is awaiting brokerage',
                Case_Summary__c = 'test',
                Case_Resolution__c = 'test',
                Date_of_Complaint__c = system.today(),
                RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CM_Parent_Only').getRecordTypeId(),
                Status='New'));
                    
            }
                return lstCase;
        }  
        
        
          //method for creating list of Documents
        private static list<Documents__c> createDoc(Account acc , Integer noOfRecd) {
            list<Documents__c> docList = new list<Documents__c>();

            for(Integer i=0 ; i < noOfRecd ; i++ ) {
                docList.add(new Documents__c(Account__c = acc.Id, 
                                            CRN__c = acc.CRN__c,Name='Document1'+i,
                                            Document_Category__c='Allotment Process',
                                            Date_of_Generation__c = DATETIME.now(),
                                            Version__c = '1'));
            }
            
            return docList;
        }

        //method for creating list of SMS
        private static list<SMS_History__c> createSMS(Account acc , Integer noOfRecd) {
            list<SMS_History__c> smsList = new list<SMS_History__c>();

            for(Integer i=0 ; i < noOfRecd ; i++ ) {
                smsList.add(new SMS_History__c(Account__c = acc.Id, CRN__c = acc.CRN__c,
                                                Mobile_Number__c = '1234567'+i,
                                                SMS_Text__c = 'Test SMS',
                                                Status__c = 'Sent',
                                                Created_Date__c = DATETIME.now(),
                                                SMS_Type__c = 'Sent'));
            }

            return smsList;
        }
        
        //method for creating list of Dispatch
        
        private static list<Despatch__c> createDispatch(Account acc , Integer noOfRecd) {
            list<Despatch__c> dispatchList = new list<Despatch__c>();

            for(Integer i=0 ; i < noOfRecd ; i++ ) {
                dispatchList.add(new Despatch__c(Account__c = acc.Id, 
                                                Despatch_Date__c = system.today() + i,
                                                Waybill_No__c = '3454554'+i,
                                                Courier_Name__c = 'Test',
                                                Contents__c = 'Test',
                                                Last_Delivery_Status__c = 'Sent'
                                                ));
            }

            return dispatchList;
        }
        
    
}