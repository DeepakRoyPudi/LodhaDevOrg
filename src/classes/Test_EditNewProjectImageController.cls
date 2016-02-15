@IsTest(seeAllData=false)
Private class Test_EditNewProjectImageController{
@IsTest
Private Static void EditNewProjectImageMethod(){
  
        
        Account a = new Account();
        a.RecordTypeId=[Select id from RecordType where SobjectType='Account' AND Name='Booked Account'].Id;
        a.FirstName='Test';
        a.LastName='Brduser';
        a.H_Mobile_No__c='4444411111';
        a.Mobile_Phone__c='4444411111';
        insert a;  

        Project_Name__c pname=new Project_Name__c();
        pname.name='Dummy Proj';
        pname.Project_Type__c='CASA';
        pname.Record_Type__c='Residential';
        pname.Isactive__c=true;
        pname.Allow_mobile_verification__c=true;
        pname.Allow_Call_Patching__c=true;
        pname.City__c='Mumbai';
        pname.Call_Patch_Category__c = 'Dummy Call';
        pname.Type_of_Accomodation__c = '1 BHK';
        insert pname;
        
        
        Project_Image__c pImg = new Project_Image__c();
        pImg.Project_Name__c = pname.id;
        pImg.Cluster__c = 'TestCluster';
        pImg.Wing__c = 'WingTest';   
        pImg.IsCommon__c=false;
        insert pImg; 
        
        Project_Image__c pImg1 = new Project_Image__c();
        pImg1.Project_Name__c = pname.id;
        pImg1.Cluster__c = '';
        pImg1.Wing__c = '';   
        pImg1.IsCommon__c=true;
        insert pImg1; 
        
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
        bookDetails1.CRN__c = 'TestCRN1';
        insert bookDetails1;
        
        ApexPages.StandardController controller = new ApexPages.StandardController(new Project_Image__c ());
        ApexPages.currentPage().getParameters().put('id',pImg.Id); 
        EditNewProjectImageController testImg = new EditNewProjectImageController(controller);
        testImg.projId =pname.Name;
        testImg.clusterId='test';
        testImg.wingId='test';
        testImg.getProjList();
        testImg.getClusterFilter();
        testImg.getWingFilter();
        testImg.myaction();
        testImg.save();
        testImg.cancel();
        
        ApexPages.StandardController controller1 = new ApexPages.StandardController(new Project_Image__c ());
        EditNewProjectImageController testImg1 = new EditNewProjectImageController(controller1);
        testImg1.projId =pname.Name;
        testImg1.clusterId='select';
        testImg1.getProjList();
        testImg1.getClusterFilter();
        testImg1.getWingFilter();
        testImg1.save();
        testImg1.cancel();
       
        
        ApexPages.currentPage().getParameters().put('id',pImg1.Id); 
        ApexPages.StandardController controller2 = new ApexPages.StandardController(new Project_Image__c ());
        EditNewProjectImageController testImg2 = new EditNewProjectImageController(controller2);
        testImg2.projId =pname.Name;
        testImg2.getProjList();
        testImg2.myaction();
        testImg2.save();
        testImg2.cancel();
        
        ApexPages.StandardController controller3 = new ApexPages.StandardController(new Project_Image__c ());
        EditNewProjectImageController testImg4= new EditNewProjectImageController(controller3);
        testImg4.projId ='select';
        testImg4.getProjList();
        testImg4.getClusterFilter();
        testImg4.getWingFilter();
        testImg4.save();
        testImg4.cancel();
        
        ApexPages.currentPage().getParameters().put('id',pImg.Id); 
        ApexPages.StandardController controller4 = new ApexPages.StandardController(new Project_Image__c ());
        EditNewProjectImageController testImg3= new EditNewProjectImageController(controller4);
        testImg3.projId =pname.Name;
        testImg3.clusterId='test';
        testImg3.wingId='select';
        testImg3.getProjList();
        testImg3.getClusterFilter();
        testImg3.getWingFilter();
        testImg3.save();
        testImg3.cancel();
        

        


}


}