@isTest
Private class TestAdminViewController{
    
    static testmethod void  MyTestmethod(){    
        id RTId = [Select id from RecordType where Name = 'Booked Account'].id;      
        Account a = new Account(FirstName = 'testFirstacc',
                                LastNAme = 'testLastacc',
                                Recordtypeid = RTId,
                                Status__c = 'Created',
                                PersonMobilePhone = '1234567890',
                                PersonEmail = 'testtest@test.com',
                                CRN__c = '098899',
                                Personal_Email__pc = 'testtest1@test.com',
                                Project_Name__c = 'CASA RIO'
                                );
        insert a;
        
        Booking_Details__c bd = new Booking_Details__c();
        bd.Account__c = a.id;
        bd.Project__c = 'CASA RIO';
        bd.wing__c = 'WingA' ;
        bd.Plant__c = 'R007';
        bd.CRN__c = '098899';
        bd.Flat_ID__c = '123654789';
        bd.Cluster__c = 'ABC';        
        insert bd;
        
        Project_Name__c project=new Project_Name__c();
        project.Name='CASA RIO';
        project.Project_Type__c='Casa';
        insert project;
        
        Project_Image__c aa=new Project_Image__c ();
        aa.Cluster__c='ABC';
        aa.Project_Name__c=project.id;
        aa.Wing__c='WingA';        
        aa.IsActive__c=true;
        insert aa;
    
        AdminViewController testclass = new AdminViewController();          
        List<Booking_Details__c> booklst=[select id,Project__c,Cluster__c,Wing__c,Account__c,Account__r.Status__c  from Booking_Details__c Where Project__c != NULL AND Cluster__c != NULL AND Wing__c != NULL AND Account__c != NULL AND Account__r.Status__c != 'Cancelled']; 
        testclass.getProjList();
        testclass.projId='CASA RIO';
        system.assertequals(testclass.projId,booklst[0].Project__c);  
        testclass.getClusterFilter();
        testclass.clusterId='ABC';        
        testclass.getWingFilter();   
        testclass.wingId='WingA';   
        testclass.search();
        
        testclass.clusterId='Select'; 
        testclass.wingId='Select';  
        testclass.search();

    }

}