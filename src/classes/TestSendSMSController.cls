@istest(seeAlldata=false)
Private class TestSendSMSController{ 

   testmethod static void test_sendSMS(){
    
        // Create test data
        test.startTest();
        Account acc = new Account(Name = 'Test SMS Account', Mobile_Phone__c = '8892100077', Email_acc__c = 'test@test.com');    
        insert acc;
    
        Project_Name__c p = new Project_Name__c(Name = 'Test Project', Contact_Center_No__c = '8892103311', Project_Type__c = 'Casa', Record_Type__c = 'Residential', Send_SMS__c = True, Thank_You_Sms__c = True, Non_Contactable_Sms__c = True, Visit_Confirmed_Sms__c = True, Date_Time__c = True, Thank_You_Sms_Template__c = 'Thank You', Non_Contactable_Sms_Template__c = 'Non Contactable', Visit_Confirmed_Sms_Template__c = 'Visit Confirmed' );
        insert p;
    
        Opportunity a = new Opportunity(Name='Test', Send_Non_Contactable_SMS__c = true, AccountId = acc.id, StageName = 'Qualification', CloseDate = date.today(), Project_Name__c = p.Id);
        insert a;
    
        Call_Attempts__c ca = new Call_Attempts__c(Opportunity__c = a.id, Project_name__c = p.id, Attempted_By__c = 'CED', Call_Attempted_by__c = 'Celina George', Call_Type__c = 'Inbound Call', Call_Status__c = 'Call Completed', Call_Attempt_Status__c = 'Booking Done', Reason_for_Inbound_Call__c = 'Click to call');
        insert ca;
      
        ApexPages.StandardController controller = new ApexPages.StandardController(a); 
        SendSMSController bsExt = new SendSMSController(controller);
        bsExt.smsType = 'Thank You';
        bsExt.smsTemplate();
        bsExt.scheduleDate();
        bsExt.stopSms= true;
        bsExt.sendSMS();    
    
        Call_Attempts__c ca1 = new Call_Attempts__c(Opportunity__c = a.id,  Project_name__c = p.id, Attempted_By__c = 'CED', Call_Attempted_by__c = 'Celina George', Call_Type__c = 'Inbound Call', Call_Status__c = 'Call InCompleted', Call_Attempt_Status__c = 'Booking Done', Reason_for_Inbound_Call__c = 'Click to call');
        insert ca1;
       
        ApexPages.StandardController controller1 = new ApexPages.StandardController(a); 
        SendSMSController bsExt1 = new SendSMSController(controller1);
        bsExt1.smsType = 'Non-Contactable';
        bsExt1.smsTemplate();
        bsExt1.scheduleDate();    
    
        Call_Attempts__c ca2 = new Call_Attempts__c(Opportunity__c = a.id, Call_Attempt_Status__c = 'Visit Confirmed', Project_name__c = p.id, Attempted_By__c = 'CED', Call_Attempted_by__c = 'Celina George', Call_Type__c = 'Outbound Call', Call_Status__c = 'Call Incomplete', Next_Action_Date__c = Date.today()+1, Proposed_Date_of_Visit__c = system.now()+1, Reason_for_Inbound_Call__c = 'Click to call');
        insert ca2;
    
        ApexPages.StandardController controller2 = new ApexPages.StandardController(a); 
        SendSMSController bsExt2 = new SendSMSController(controller2);
        bsExt2.smsType = 'Visit Confirmed';
        bsExt2.smsTemplate();
        bsExt2.scheduleDate();     
         
        test.stoptest();
    
    }
}