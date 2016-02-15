@isTest(SeeAllData=false)
public class TestBatchProjectImage{
    testMethod static void testBatchProjectImage(){
        Test.startTest();
        
        Account a = new Account();
        a.RecordTypeId=[Select id from RecordType where SobjectType='Account' AND Name='Booked Account'].Id;
        a.FirstName='Test';
        a.LastName='Brduser';
        a.H_Mobile_No__c='4444411111';
        a.Mobile_Phone__c='4444411111';
        a.CRN__c = '123789';
        insert a;   
        
        Account a1 = new Account();
        a1.RecordTypeId=[Select id from RecordType where SobjectType='Account' AND Name='Booked Account'].Id;
        a1.FirstName='Test1';
        a1.LastName='Brduser1';
        a1.H_Mobile_No__c='4444422222';
        a1.Mobile_Phone__c='4444422222';
        a1.CRN__C = '456789';
        insert a1;     
        
        
        List<Booking_Details__c> bdList = new List<Booking_Details__c>();
                
        Booking_Details__c bd = new Booking_Details__c();
        bd.Project__c='Casa Bella';
        bd.CLuster__c='ClusterA';
        bd.Wing__c ='wingA';
        bd.Flat_ID__c='Flat123';
        bd.Account__c = a.id;
        bd.CRN__c = '123789';
        bdList.add(bd);
        
        Booking_Details__c bd1 = new Booking_Details__c();
        bd1.Project__c='Casa Rio';
        bd1.CLuster__c='ClusterB';
        bd1.Wing__c ='wingB';
        bd1.Flat_ID__c='Flat456';
        bd1.Account__c = a1.id;
        bd1.CRN__c = '456789';
        bdList.add(bd1);
        
        insert bdList;
        
        List<Project_Name__c> pList = new List<Project_Name__c>(); 
        
        Project_Name__c p = new Project_Name__c();
        p.Name='Casa Bella';
        pList.add(p);
        
        Project_Name__c p1 = new Project_Name__c();
        p1.Name='Casa Rio';
        pList.add(p1);
       
        insert pList;
       
        //insert system admin user
        Id admId = [Select Id from Profile where Name =:'System Administrator' limit 1].id;
        User adm = [Select Id from User Where profileId =: admId AND isActive = true limit 1];
        
        system.Runas(adm){
            //execute batch class
            Database.BatchableContext BC;
            BatchProjectImage batchRP = new BatchProjectImage();
            batchRP.start(BC);
            Database.executeBatch(batchRP);
            batchRP.execute(BC, bdList);
        }
           
        Test.stopTest();
    }
    
     
    //Test method for ScheduleBatchResetPassword class
    testMethod static void test_ScheduleBatchProjectImage(){
        Test.startTest();  
        ScheduleBatchProjectImage scheduleReset = new ScheduleBatchProjectImage();
        String schedule = '0 0 23 * * ?';
        system.assert(system.schedule('Scheduled Reset', schedule, scheduleReset)!=null);
        Test.stopTest();
    }
    
}