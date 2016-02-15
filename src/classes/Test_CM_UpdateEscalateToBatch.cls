@isTest(SeeAllData=true)
    public class  Test_CM_UpdateEscalateToBatch{
       /* public static testMethod  void testUpdateEscalateToBatch (){
            test.startTest();
            
           // id RTId = [Select id from RecordType where Name = 'Booked Account'].id; 
           // id recTypeParentOnlyId =   [SELECT Id,Name FROM RecordType WHERE Name = 'CM_Parent_Only'].id;
            
            // Account a = new Account(FirstName = 'testingFirstacc',
            // LastNAme = 'testingLastacc',
            // Recordtypeid = RTId ,     
            // PersonMobilePhone = '1234567890',
            // PersonEmail = 'testing@test.com'
            // );
           //insert a;
           
       // Profile p = [SELECT Id FROM Profile WHERE Name = 'Customer Care'];
      //  User u1 = new User();
       // u1.Email = 'email1@email.com';
       // u1.Alias = 'Alias2';
       // u1.TimeZoneSidKey = 'America/New_York';
       // u1.LocaleSidKey = 'ca';
       // u1.EmailEncodingKey = 'UTF-8';
      //  u1.ProfileId = p.id;
      //  u1.LanguageLocaleKey = 'en_US';
      //  u1.FirstName = 'firstname1';
      //  u1.LastName = 'lastname1';
      //  u1.username= 'username1@first.com';
       // insert u1; 
        
      Case  c = new Case(Status= 'Active',IsEscalated= true, Communication_Type__c='Inbound',Initial_Remarks__c='testing',Interaction_Mode__c='Email',Nature_of_Request__c='Request',Request_for_L1__c='a',Request_for_L2__c='b',Request_for_L3_a__c='c',Request_for_L3__c='d');
       // c.account=a;
       
        insert c;
       
      
        //System.runAs(u1){ 
            
       CM_UpdateEscalateToBatch obj=new  CM_UpdateEscalateToBatch(); 
      database.executebatch(obj );
       //obj.finish();
       
       //}
         
        
   }   */
   
   
   public static testMethod void testEmailSenderScheduler(){
        test.startTest();
        
        CM_UpdateEscalateToBatch obj = new CM_UpdateEscalateToBatch();
        //c.query= 'Select CaseNumber,Status,IsEscalated,IsClosed,IsDuplicate__c, BusinessHoursId,ClosedDate,CreatedDate,CM_TAT__c from Case Where IsClosed = false and IsDuplicate__c = false and IsEscalated = false';
        Database.BatchableContext bc;
        obj.start(bc);
        List<Case> caseList = [Select CaseNumber,Status,IsEscalated,IsClosed,IsDuplicate__c, BusinessHoursId,ClosedDate,CreatedDate,CM_TAT__c,Escalated_To__c from Case Where IsClosed = false and IsDuplicate__c = false and IsEscalated = true limit 99];
        obj.execute(bc, caseList); 
        obj .finish(bc); 
        
        test.stopTest();  
   }
        
   
      
  }