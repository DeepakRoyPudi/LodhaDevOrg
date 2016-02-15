/*@Created by: Deepak Pudi 
     @Created Date:18/6/2015 -->
 
 -- ------------------------------------------------------------------------------
 | Modified By      | Modified Date       | Version        | Description         |
 --------------------------------------------------------------------------------
 |Deepak Pudi            19/6/2015           1.0           PaymentModesCSS2_0Controller
 --------------------------------------------------------------------------------
 |
 ------------------------------------------------------------------------------ --*/
@istest(seeAllData=False)
private class PaymentModesCSS2_0ControllerTest{
  
  
   private static testmethod void PaymentModeControllerTest(){
  	Account Acc = createAccount();
   	insert Acc;
   
   	Booking_Details__c BD = CreateBookingDetails(Acc);
   	insert BD;
   
   	 Payment_Mode__c PM = createPaymentModes();
   	 insert PM;
   
   	 Booking_Payment_Transaction__c BPT =createBPT(BD);
   	 insert BPT;
    User u = createUser(Acc);
    insert u;
    
    system.runAs(u){
   	 test.startTest();
   	 PaymentModesCSS2_0Controller PMcss = new  PaymentModesCSS2_0Controller(); 
   	 
   	 	PMcss.typeoftransaction ='RTGS';
	     PMcss.getBookingdata();
	     PMcss.init();
	     PMcss.getOldTransactionTypes();
	     PMcss.getTransactionList();
	     PMcss.getheaders();
	     PMcss.PaymentInfo();
	     PMcss.paymentsave();
     
     test.stopTest();
    }
   }
   
   /* private static testmethod void PaymentModeControllernegativeTest(){
   	Account Acc1 = createAccount();
   			insert Acc1;
   
   	Booking_Details__c BD1 = CreateBookingDetails(Acc1);
   			insert BD1;
   
   	 Payment_Mode__c PM1 = createPaymentModes();
   			 insert PM1;
   
   	 Booking_Payment_Transaction__c BPT1 =createBPT1(BD1);
   	 		insert BPT1;
    User u1 = createUser(Acc1);
    		insert u1;
    	 system.runAs(u1){
   	 test.startTest();
   	 PaymentModesCSS2_0Controller PMcss1 = new  PaymentModesCSS2_0Controller(); 
   	 
   	 	//PMcss.typeoftransaction ='RTGS';
	     PMcss1.getBookingdata();
	     PMcss1.init();
	     PMcss1.getOldTransactionTypes();
	     PMcss1.getTransactionList();
	     PMcss1.getheaders();
	     PMcss1.PaymentInfo();
	     PMcss1.paymentsave();
     
     test.stopTest();
   	
    	 }
   
   }*/
   
    private static Account createAccount(){
        Account objAccount = new Account();
        objAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Booked Account').getRecordTypeId();
        objAccount.FirstName = 'Test1';
        objAccount.LastName = 'Account1';
        objAccount.CRN__c = '154215';
        objAccount.H_Mobile_No__c = '1234560789';
        objAccount.Mobile_Phone__c = '21241222';
        objAccount.Co_Applicant__c = 'test';
        objAccount.Project_Name__c = 'New Cuffe Parade';
        return objAccount;
      } 
      
    
       private static Booking_Details__c CreateBookingDetails(Account objAccount){
        
        Booking_Details__c bd = new Booking_Details__c();
        bd.Account__c = objAccount.id;
        bd.Project__c = 'New Cuffe Parade';
        bd.Plant__c = 'R007';
        bd.CRN__c = '098899';
        bd.Flat_ID__c = '123654789';
        return bd;
      }
      
      private static Payment_Mode__c createPaymentModes(){
      Payment_Mode__c pm = new Payment_Mode__c();
        pm.Name = 'TestMode';
        pm.Plant__c = 'R007';
        return pm;
        }
        
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
        
        private static Booking_Payment_Transaction__c createBPT(Booking_Details__c b){
       
        Booking_Payment_Transaction__c tran = new Booking_Payment_Transaction__c();
        tran.CRN__c = '120897';
        tran.Cluster__c = 'ABC';
        tran.Flat__c = '333';
        tran.Project_Name__c = 'Casa Bella Gold';
        tran.Wing__c= 'Wing-A' ;
        tran.Booking__c = b.id;
        tran.Type_of_Transaction_del__c='NEFT';
        tran.UTR_Code__c = '11111111111';
        tran.Amount_Transferred__c = 1200;
        tran.Bank_Account_Holders_Name__c='test';
        tran.Bank_Name__c= 'DFCF';
        tran.Transaction_Date__c = system.Today();
        tran.Remitted_to_Account__c = 'Test2';
       	return tran;
        
        }
        
         private static Booking_Payment_Transaction__c createBPT1(Booking_Details__c b){
       
        Booking_Payment_Transaction__c tran1 = new Booking_Payment_Transaction__c();
        tran1.CRN__c = '120807';
        tran1.Cluster__c = 'ABC';
        tran1.Flat__c = '333';
        tran1.Project_Name__c = 'Casa Bella Gold';
        tran1.Wing__c= 'Wing-A' ;
        tran1.Booking__c = b.id;
       // tran.Type_of_Transaction_del__c='NEFT';
        tran1.UTR_Code__c = '11111111110';
        tran1.Amount_Transferred__c = 1200;
        tran1.Bank_Account_Holders_Name__c='test';
        tran1.Bank_Name__c= 'DFCF';
        tran1.Transaction_Date__c = system.Today();
        tran1.Remitted_to_Account__c = 'Test2';
       	return tran1;
        
        }

}