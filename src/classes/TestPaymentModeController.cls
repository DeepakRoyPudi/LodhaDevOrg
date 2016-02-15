@istest(seealldata = false)
    Private class TestPaymentModeController{
    private static testmethod void testPaymentModeController(){
        List<Booking_Payment_Transaction__c> testbookinglist;
        id RTId = [Select id from RecordType where Name = 'Booked Account'].id;
        
        Account a = new Account(FirstName = 'testFirstacc',
                                LastNAme = 'testLastacc',
                                Recordtypeid = RTId,
                                Status__c = 'Created',
                                PersonMobilePhone = '1234567890',
                                PersonEmail = 'testtest@test.com',
                                CRN__c = '098899',
                                Personal_Email__pc = 'testtest1@test.com',
                                Project_Name__c = 'Casa Bella Gold'
                                );
        insert a;
        
        Contact c = [Select id from Contact where AccountId =: a.Id];
        
                
        id ProfId = [Select id from Profile where Name = 'Custom Overage High Volume Customer Portal'].id;
        
       // id uId = [Select id,accountid from User where profileId =: ProfId LIMIT 1].id;
        
          
        
        Payment_Mode__c pm = new Payment_Mode__c();
        pm.Name = 'TestMode';
        pm.Plant__c = 'R007';
        insert pm;
     
       
        User u = new User();
        u.LastName = 'testLastacc';
        u.Alias = 'tuser';
        u.Email = 'testtest@test.com';
        u.ContactId = c.Id;
        u.Username = 'testtest123@test.com';
        u.CommunityNickname = 'Testuser';
        u.ProfileId = ProfId;
        //u.TimeZoneSidKey = 'Asia/Calcutta';
        u.TimeZoneSidKey = 'Asia/Kolkata';
        u.LocaleSidKey = 'en_IE_EURO';
        u.EmailEncodingKey = 'ISO-8859-1';
        u.LanguageLocaleKey = 'en_US';
        u.IsActive = true;
        insert u;
        
        Booking_Details__c bd = new Booking_Details__c();
        bd.Account__c = a.id;
        bd.Project__c = 'Casa Bella Gold';
        bd.Plant__c = 'R007';
        bd.CRN__c = '098899';
        bd.Flat_ID__c = '123654789';
        insert bd;
        
        
        
       System.runAs(u)
       {
        
        PageReference pageRef=new PageReference('/apex/PaymentModes');
        Test.setcurrentpage(pageRef);
        PaymentModeController pmc = new PaymentModeController ();
        pmc.init();
        pmc.getBookingdata();
        testbookinglist = pmc.getTransactionList();
        pmc.getheaders();
        
        //standard errors
        //pmc.booking_tran = new Booking_Payment_Transaction__c();
        pmc.booking_tran.CRN__c = '120897';
        pmc.booking_tran.Cluster__c = 'ABC';
        pmc.booking_tran.Flat__c = '333';
        pmc.booking_tran.Project_Name__c = 'Casa Bella Gold';
        pmc.booking_tran.Wing__c= 'Wing-A' ;
        pmc.booking_tran.Booking__c = bd.id;
        pmc.booking_tran.Type_of_Transaction_del__c='RTGS';
        pmc.booking_tran.Amount_Transferred__c = 1200;
        pmc.booking_tran.Transaction_Date__c = system.Today();
        pmc.booking_tran.UTR_Code__c = '333333';
        pmc.booking_tran.Bank_Account_Holders_Name__c='test';
        pmc.booking_tran.Remitted_to_Account__c = 'Test1';
        //pmc.booking_tran.Uniqueness__c='120897_333333_1200.00_7.2.2014';
        pmc.paymentsave();  
        
        PaymentModeController pmc1 = new PaymentModeController ();
        pmc1.booking_tran.CRN__c = '120897';
        pmc1.booking_tran.Cluster__c = 'ABC';
        pmc1.booking_tran.Flat__c = '333';
        pmc1.booking_tran.Project_Name__c = 'Casa Bella Gold';
        pmc1.booking_tran.Wing__c= 'Wing-A' ;
        pmc1.booking_tran.Booking__c = bd.id;
        pmc1.booking_tran.Type_of_Transaction_del__c='RTGS';
        pmc1.booking_tran.Amount_Transferred__c = 1200;
        pmc1.booking_tran.Transaction_Date__c = system.Today();
        pmc1.booking_tran.UTR_Code__c = '333333333333333333';
        pmc1.booking_tran.Bank_Account_Holders_Name__c='test';
        pmc1.booking_tran.Remitted_to_Account__c = 'Test1';
        //pmc1.booking_tran.Uniqueness__c='120897_333333333333333333_1200.00_7.2.2014';
        pmc1.paymentsave(); 
            
            
        PaymentModeController pmc2 = new PaymentModeController ();
        pmc2.booking_tran.CRN__c = '120897';
        pmc2.booking_tran.Cluster__c = 'ABC';
        pmc2.booking_tran.Flat__c = '333';
        pmc2.booking_tran.Project_Name__c = 'Casa Bella Gold';
        pmc2.booking_tran.Wing__c= 'Wing-A' ;
        pmc2.booking_tran.Booking__c = bd.id;
        pmc2.booking_tran.Type_of_Transaction_del__c='RTGS';
        pmc2.booking_tran.Amount_Transferred__c = 1200;
        pmc2.booking_tran.Transaction_Date__c = system.Today();
        pmc2.booking_tran.UTR_Code__c = '333333333333333333';
        pmc2.booking_tran.Bank_Account_Holders_Name__c='test';
        pmc2.booking_tran.Remitted_to_Account__c = 'Test1';
        //pmc2.booking_tran.Uniqueness__c='120897_333333333333333333_1200.00_7.2.2014';
        pmc2.paymentsave(); 
        //please Fix me: trying simulate duplicate error   
        
        Booking_Payment_Transaction__c tran = new Booking_Payment_Transaction__c();
        tran.CRN__c = '120897';
        tran.Cluster__c = 'ABC';
        tran.Flat__c = '333';
        tran.Project_Name__c = 'Casa Bella Gold';
        tran.Wing__c= 'Wing-A' ;
        tran.Booking__c = bd.id;
        tran.Type_of_Transaction_del__c='NEFT';
        tran.UTR_Code__c = '11111111111';
        tran.Amount_Transferred__c = 1200;
        tran.Bank_Account_Holders_Name__c='test';
        tran.Bank_Name__c= 'DFCF';
        tran.Transaction_Date__c = system.Today();
        tran.Remitted_to_Account__c = 'Test2';
        //tran.Uniqueness__c = '120897_11111111111_1200.00_7.2.2014';
        insert tran;
             

       
       }       
       
       PaymentModeController pmc = new PaymentModeController ();
       pmc.init();
       
       
        
    }
    }