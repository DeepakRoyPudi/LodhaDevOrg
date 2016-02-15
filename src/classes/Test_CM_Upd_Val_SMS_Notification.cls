@isTest(SeeAllData=true)
public class  Test_CM_Upd_Val_SMS_Notification {
    public static testMethod  void testUpdValSMSNotification (){

       // List<case> a=[SELECT Id, Communication_Type__c ,Queue_Id__c,OwnerId,TL_Emailid__c,CreatedById,AccountId,Account.Name,CreatedBy.name,caseNumber,Mobile_Phone__c, OldOwnerId__c, Status, BusinessHoursId, RecordTypeId, Request_for_L1__c, Queue_Name__c, CreatedDate, Remaining_Hours__c, CM_TAT__c, ParentId FROM Case];
        test.startTest();
        Profile p = [Select id from Profile where Name = 'Customer Care'];

        User u = new User();
        u.LastName = 'TestUser';
        u.Alias = 'tuser';
        u.Email = 'test@test.in';
        u.Username = 'abc_123@test.com';
        u.CommunityNickname = 'Testuser';
        u.ProfileId = p.Id;
        u.TimeZoneSidKey = 'Asia/Kolkata';
        u.LocaleSidKey = 'en_IE_EURO';
        u.EmailEncodingKey = 'ISO-8859-1';
        u.LanguageLocaleKey = 'en_US';
        u.IsActive = true;
        insert u;

        
        System.runAs(u){ 
            List <Case> caselist = new List<Case>();
                for(integer i = 0; i<1; i++){
                Case c = new Case(
                    //origin = 'Web',
                    First_Name__c = 'testFirst'+'i',
                    Last_Name__c = 'testLast'+'i', 
                    Mobile__c = '1234567891',
                    Project__c = 'CASA Rio',
                    Buildings_Name__c = 'MARINA',
                    Wing__c = 'd',
                    Flat_No__c = '202',
                    Interaction_Mode__c='Call',
                    Communication_Type__c='Inbound',
                    Status='Working',
                    Nature_of_Request__c='Request',
                    Request_for_L1__c='Document Related',
                    Request_for_L2__c='Customer wants original document',
                    Request_for_L3_a__c='NOC',
                    Request_for_L3__c=''
                    //Ownerid = u.ID
                ); 
                caselist.add(c);
            }
            insert caselist;


        CM_Upd_Val_SMS_Notification cObj = new  CM_Upd_Val_SMS_Notification();
        cObj.stopSms=true;

       /* Account a = new Account();
        a.FirstName='Test';
        a.LastName='Brduser Test';
        insert a;*/
       
       /* Case c = new Case();
        c.accountId=(String)a.Id;
       // c.RecordTypeid=[Select id from RecordType where SobjectType='Case' AND Name='CSS Cases'].Id;
        c.origin = 'Web';
        c.First_Name__c = 'testFirst';
        c.Last_Name__c = 'testLast';
        c.Mobile__c = '1234567891';
        c.Project__c='Casa';
        c.Buildings_Name__c='Building1';
        c.Wing__c='east';
        c.Flat_No__c = '202';
        c.Status='New';
        c.Loan_Stages__c='ADF';
        //c.Manager__c='Dilip Sheth1';
        //c.ADF__c='Yes';
        c.communication_type__c = 'outbound';
        c.interaction_mode__c='Email';
        c.Nature_of_Request__c='Complaint';
        c.Case_Summary__c='Test';
        c.Case_Resolution__c='Test';
        c.Request_for_L1__c='Document Related';
        c.Request_for_L2__c='Customer wants original document';
        c.Request_for_L3_a__c='ROC';
        insert c; */
        
        /* Case c1 = new Case(origin = 'Web',  First_Name__c = 'testFirst'+'i',
                               Last_Name__c = 'testLast'+'i', 
                               Mobile__c = '1234567891',
                               Project__c = 'CASA Rio',
                               Buildings_Name__c = 'MARINA',
                               Wing__c = 'd',
                               Flat_No__c = '202',
                               Ownerid = u.ID,
                               account=acc, communication_type__c = 'outbound', 
                        interaction_mode__c='Email', Nature_of_Request__c='Complaint',
                        Case_Summary__c='Test', Case_Resolution__c='Test',
                        Request_for_L1__c='Document Related', 
                        Request_for_L2__c='Customer wants original document', 
                        Request_for_L3_a__c='ROC'); */
      //  insert c1;


        /* 
        cObj.sendCaseCreationSMSAfterInsert(a);
        cObj.sendCaseClosureSMSAfterInsertOrUpdate(a);
        cObj.updateEscalatedToEmail(a); */
        
       // List<Case> clist = new List<Case>();
       // cList.add(c);
        
        cObj.sendCaseCreationSMSAfterInsert(caselist);
        cObj.sendCaseClosureSMSAfterInsertOrUpdate(caselist);
        cObj.updateEscalatedToEmail(caselist);
        
        //cObj.orgQueueName(a);
}
         test.stopTest();
        
    }
}