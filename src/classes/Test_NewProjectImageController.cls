@isTest
public class Test_NewProjectImageController{

static testmethod void testProjectImage(){
 
        Account a = new Account();
        a.RecordTypeId=[Select id from RecordType where SobjectType='Account' AND Name='Booked Account'].Id;
        a.FirstName='Test';
        a.LastName='Brduser';
        a.H_Mobile_No__c='4444411111';
        a.Mobile_Phone__c='4444411111';
        insert a;            
               
        Project_Name__c pname=new Project_Name__c();
        pname.name='LODHA SUPREMUS II';
        pname.Project_Type__c='CASA';
        pname.Record_Type__c='Residential';
        pname.Isactive__c=true;
        pname.Allow_mobile_verification__c=true;
        pname.Allow_Call_Patching__c=true;
        pname.City__c='Mumbai';
        pname.Call_Patch_Category__c = 'Dummy Call';
        pname.Type_of_Accomodation__c = '1 BHK';
        insert pname;
    
        Booking_Details__c bookDetails = new Booking_Details__c();
        bookDetails.Flat_ID__c='Flat123';
        bookDetails.Project__c=pname.name;
        bookDetails.CLuster__c='TestCluster';
        bookDetails.Wing__c='WingTest';
        bookDetails.Account__c = a.id;
        bookDetails.CRN__c = 'TestCRN';
        insert bookDetails;
        
        Booking_Details__c bookDetails1 = new Booking_Details__c();
        bookDetails1.Flat_ID__c='Flat123';
        bookDetails1.Project__c=pname.name;
        bookDetails1.CLuster__c='TestCluster';
        bookDetails1.Wing__c='WingTest';
        bookDetails1.Account__c = a.id;
        bookDetails1.CRN__c = 'testcrn2';
        insert bookDetails1;
        
        Project_Image__c pImg = new Project_Image__c();
        pImg.Project_Name__c = pname.id;
        pImg.Cluster__c = 'TestCluster';
        pImg.Wing__c = 'WingTest';   
        //pImg.Project_Combination__c = bookDetails.Project__c+ bookDetails.CLuster__c+ bookDetails.Wing__c;    
        insert pImg;
        
        Project_Image__c pImg1 = new Project_Image__c();
        pImg1.Project_Name__c = pname.id;
        pImg1.Cluster__c = '';
        pImg1.Wing__c = '';
        pImg1.IsCommon__c =true;   
        //pImg.Project_Combination__c = bookDetails.Project__c+ bookDetails.CLuster__c+ bookDetails.Wing__c;    
        insert pImg1;
        
        ApexPages.StandardController controller = new ApexPages.StandardController(new Project_Image__c ());
        NewProjectImageController testImg = new NewProjectImageController(controller);
        testImg.projId= pname.name;  
        testImg.getProjList();  
        testImg.clusterId = 'TestCluster';
        testImg.IsCommon =false;
        testImg.getClusterFilter();
        testImg.getWingFilter();

        testImg.wingId = 'WingTest';
          
        testImg.save();
        testImg.cancel();
        
        ApexPages.StandardController controller1 = new ApexPages.StandardController(new Project_Image__c ());
        NewProjectImageController  testImg1 = new NewProjectImageController(controller1);
        testImg1.projId= pname.name;  
        testImg1.clusterId = 'Select';
        testImg1.wingId = 'Select';
        testImg1.IsCommon =true;
        testImg1.getClusterFilter();
        testImg1.getWingFilter();
        testImg1.getProjList();
        testImg1.save();
        testImg1.cancel();
        
        ApexPages.StandardController controller2 = new ApexPages.StandardController(new Project_Image__c ());
        NewProjectImageController   testImg2 = new NewProjectImageController(controller2);
        testImg2.projId= pname.name;  
        testImg2.clusterId = 'Select';
        testImg2.IsCommon =false;
        testImg2.getClusterFilter();
        testImg2.getWingFilter();
        testImg2.getProjList();
        testImg2.save();
        testImg2.cancel();
        
        ApexPages.StandardController controller3 = new ApexPages.StandardController(new Project_Image__c ());
        NewProjectImageController   testImg3 = new NewProjectImageController(controller3);
        testImg3.projId= pname.name; 
        testImg2.clusterId = 'testcluster'; 
        testImg3.wingId = 'Select';
        testImg3.IsCommon =false;
        testImg3.getClusterFilter();
        testImg3.getWingFilter();
        testImg3.getProjList();
        testImg3.save();
        testImg3.cancel();
        
        ApexPages.StandardController controller4 = new ApexPages.StandardController(new Project_Image__c ());
        NewProjectImageController   testImg4 = new NewProjectImageController(controller4);
        testImg4.Iscommon=true;
        testImg4.myaction(); 
        
        ApexPages.StandardController controller5 = new ApexPages.StandardController(new Project_Image__c ());
        NewProjectImageController   testImg5 = new NewProjectImageController(controller5);
        testImg5.Iscommon=false;
        testImg5.myaction(); 
        
        ApexPages.currentPage().getParameters().put('id',pImg.id);
        ApexPages.StandardController controller6 = new ApexPages.StandardController(new Project_Image__c ());
        NewProjectImageController   testImg6 = new NewProjectImageController(controller6);
        testImg6.projId= pname.name; 
        testImg6.clusterId = 'testcluster'; 
        testImg6.wingId = 'testwing';
        testImg6.IsCommon =false;
        testImg6.getClusterFilter();
        testImg6.getWingFilter();
        testImg6.getProjList();
        testImg6.save();
        testImg6.cancel();
        
        ApexPages.StandardController controller7 = new ApexPages.StandardController(new Project_Image__c ());
        NewProjectImageController   testImg7 = new NewProjectImageController(controller7);
        testImg7.projId= 'select'; 
        testImg7.Iscommon=false;
        testImg7.getClusterFilter();
        testImg7.getWingFilter();
        testImg7.getProjList();
        testImg7.save();
        testImg7.cancel();
        
        ApexPages.StandardController controller8 = new ApexPages.StandardController(new Project_Image__c ());
        ApexPages.currentPage().getParameters().put('id',pImg1.id);
        NewProjectImageController   testImg8 = new NewProjectImageController(controller8);


    } 

}