@isTest(SeeAllData=false)
private class TestProjectViewController {    
    static testMethod void myUnitTest() {     
  
    //  List<Booking_Payment_Transaction__c> testbookinglist;     
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
        
        Project_Name__c project=new Project_Name__c();
        project.Name='Test';
        project.Project_Type__c='Casa';
        insert project;
            
            
        Booking_Details__c bd = new Booking_Details__c();
        bd.Account__c = a.id;
        bd.Project__c = 'Test';
        bd.wing__c = 'Wing-A' ;
        bd.Plant__c = 'R007';
        bd.CRN__c = '098899';
        bd.Flat_ID__c = '123654789';
        bd.Cluster__c = 'ABC';        
        insert bd;
        
        System.runAs(u){        
        ProjectViewController obj = new ProjectViewController(); 
        obj.Cluster=bd.Cluster__c;
        obj.Wing=bd.wing__c; 
        obj.projectName = 'Test' ;
     }
         
}
}