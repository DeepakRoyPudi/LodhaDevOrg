@isTest
public class Test_CM_EmailSender{
    public static testMethod  void testEmailSender(){
        test.startTest();
        
        CM_EmailSender emailSender = new CM_EmailSender();
        //emailSender.query='Select CreatedDate, Project_Formula__c, Flat_Details__c, Booking_status__c, CRN__c, Interaction_Mode__c, Nature_of_Request__c, Request_for_L1__c, Request_for_L2__c, Request_for_L3_a__c, Request_for_L3__c, Latest_Comment__c, Case_Summary__c, Case_Resolution__c, Status, account.name, TAT__c,CRN__r.CRN__c, CRN__r.CV_paid__c, CRN__r.CLuster__c, account.CRN__c, TL_EmailId__c, Owner_EmailId__c, TL__c from case where Nature_of_Request__c =\'Complaint\' ';
        //ID batchprocessid = Database.executeBatch(emailSender);
           
        Database.BatchableContext bc;
        emailSender.start(bc);
        
        id RTId = [Select id from RecordType where Name = 'Booked Account'].id; 
        
        Account a = new Account(FirstName = 'testingFirstacc',
        LastNAme = 'testingLastacc',
        Recordtypeid = RTId ,     
        PersonMobilePhone = '1234567890',
       PersonEmail = 'testing@test.com',
       CRN__c='12345'
       );
        insert a; 
                
        Case c1 = new Case(account=a, communication_type__c = 'inbound', interaction_mode__c='Email', Nature_of_Request__c='Complaint');
        Case c2 = new Case(account=a, communication_type__c = 'inbound', interaction_mode__c='Email', Nature_of_Request__c='Complaint');
        Case c3 = new Case(account=a, communication_type__c = 'inbound', interaction_mode__c='Email', Nature_of_Request__c='Complaint');
        Case c4 = new Case(account=a, communication_type__c = 'inbound', interaction_mode__c='Email', Nature_of_Request__c='Complaint');
        Case c5 = new Case(account=a, communication_type__c = 'inbound', interaction_mode__c='Email', Nature_of_Request__c='Complaint');

        
        List<Case> caseList = [Select CreatedDate, Project_Formula__c, Flat_Details__c, Booking_status__c, CRN__c, Interaction_Mode__c, Nature_of_Request__c, Request_for_L1__c, Request_for_L2__c, Request_for_L3_a__c, Request_for_L3__c, Latest_Comment__c, Case_Summary__c, Case_Resolution__c, Status, account.name, TAT__c,CRN__r.CRN__c, CRN__r.CV_paid__c, CRN__r.CLuster__c, account.CRN__c, TL_EmailId__c, Owner_EmailId__c, TL__c from case where Nature_of_Request__c ='Complaint' ];
        
        List<Case> caseList1 = new List<Case>();
        caseList1.add(c1);
        caseList1.add(c2);
        caseList1.add(c3);
        caseList1.add(c4);
        caseList1.add(c5);

        emailSender.execute(bc, caseList1); 
      
        emailSender.finish(bc);
        test.stopTest();
    }
    
/*     public static testMethod void testEmailSender1(){
        test.starttest();
    
        EmailSenderScheduler e = new EmailSenderScheduler();
        String chron = '0 0 15 * * ?';        
        system.schedule('Test Sched', chron, e);
    
        test.stopTest();
    } */
    
  }