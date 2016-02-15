/*Description:
This test tests the functionality of ConstructionUpdatesCSS2_0 Component
@Created by: Aditi Mulmule.
@Created Date:  17/04/2015
 
 --------------------------------------------------------------------------------
 | Modified By      | Modified Date       | Version        | Description         |
 --------------------------------------------------------------------------------
    Trupti Dhoka    6/07/2014      1.1          added reusable method for 
                              record creation
 --------------------------------------------------------------------------------
   Trupti Dhoka        23/07/2015          1.2             updated class for common aminities
*/

@isTest(seeAllData=false)
private class RMConstructionUpdatesControllerTest {

  //method for creating account with project
  private static Account createAccount(){
        Account objAccount = new Account();
        objAccount.RecordTypeId = 
        Schema.SObjectType.Account.getRecordTypeInfosByName().get('Booked Account').getRecordTypeId();
        objAccount.FirstName = 'Test1';
        objAccount.LastName = 'Account1';
        objAccount.CRN__c = '154215';
        objAccount.H_Mobile_No__c = '1234560789';
        objAccount.Mobile_Phone__c = '21241222';
        objAccount.Co_Applicant__c = 'test';
        objAccount.Project_Name__c = 'New Project';
        return objAccount;
  } 

    //create a/c with no project
   private static Account createAccount1(){
        Account objAccount = new Account();
        objAccount.RecordTypeId = 
        Schema.SObjectType.Account.getRecordTypeInfosByName().get('Booked Account').getRecordTypeId();
        objAccount.FirstName = 'Test1';
        objAccount.LastName = 'Account1';
        objAccount.CRN__c = '154215';
        objAccount.H_Mobile_No__c = '1234560789';
        objAccount.Mobile_Phone__c = '21241222';
        objAccount.Co_Applicant__c = 'test';
        return objAccount;
  } 
     private static Booking_Details__c CreateBooking(Account a)
    {
        Booking_Details__c ObjBooking = new Booking_Details__c ();
        ObjBooking.CRN__c = '154215';
        ObjBooking.Flat_ID__c = 'R5210A0304M0';
        ObjBooking.Account__c = a.id;
        ObjBooking.Project__c = 'New Project';
        ObjBooking.Allotment_Date__c = system.today();
        ObjBooking.Wing__c = 'WING A';
        ObjBooking.CLuster__c ='LODHA ESTRELLA';
        return ObjBooking;
    }
 
    //create project name with all videos 
  private static Project_Name__c createProjectName() {
    Project_Name__c objProject = new Project_Name__c();
        objProject.Name = 'New Project';
        objProject.CSS_Background_Image_URL__c ='https://c.cs7.content.force.com/servlet/servlet.FileDownload?file=00PM0000003RzGG';
        objProject.Project_video1__c='https://www.youtube.com/embed/lUU9q8GYUk8';
        objProject.Project_video2__c='https://www.youtube.com/embed/lUU9q8GYUk8';
        objProject.Project_video3__c='https://www.youtube.com/embed/lUU9q8GYUk8';
        objProject.Project_video4__c='https://www.youtube.com/embed/lUU9q8GYUk8';
        objProject.Project_video5__c='https://www.youtube.com/embed/lUU9q8GYUk8';
        objProject.Project_video6__c='https://www.youtube.com/embed/lUU9q8GYUk8';
        objProject.Project_Type__c ='Casa';
        objProject.Record_Type__c = 'Residential';
    return objProject ;
  }

  //create project name with no videos
  private static Project_Name__c createProjectName1() {
    Project_Name__c objProject = new Project_Name__c();
        objProject.Name = 'New Project';
        objProject.CSS_Background_Image_URL__c ='https://c.cs7.content.force.com/servlet/servlet.FileDownload?file=00PM0000003RzGG';
        objProject.Record_Type__c = 'Residential';
        objProject.Project_video1__c=null;
        objProject.Project_video2__c=null;
        objProject.Project_video3__c=null;
        objProject.Project_video4__c=null;
        objProject.Project_video5__c=null;
        objProject.Project_video6__c=null;
    return objProject ;
  }

  private static Project_Image__c createProjectImage(Project_Name__c p) {
    Project_Image__c objProjectImage = new  Project_Image__c();
        objProjectImage.Project_View__c ='<img alt="User-added image" src="/css/servlet/rtaImage?eid=a0xM0000004glhX&amp;feoid=00ND0000005fgkY&amp;refid=0EMM00000008hzc" style="height: 319px; width: 500px;"></img>';
    objProjectImage.IsActive__c = true;
        objProjectImage.Project_Name__c = p.Id;
        objProjectImage.Wing__c = 'WING A';
        objProjectImage.Cluster__c = 'LODHA ESTRELLA';
        objProjectImage.IsCommon__c = false;
        return objProjectImage;

  }
    
    
    private static Project_Image__c createCommonEminitiesImage(Project_Name__c p) {
        Project_Image__c objProjectImage = new  Project_Image__c();
        objProjectImage.Project_View__c ='<img alt="User-added image" src="<img alt="User-added image" src="/css/servlet/rtaImage?eid=a0xM0000004glhX&amp;feoid=00ND0000005fgkY&amp;refid=0EMM00000008hzc" style="height: 319px; width: 500px;"></img>';
        objProjectImage.IsActive__c = true;
        objProjectImage.Project_Name__c = p.Id;
        objProjectImage.Wing__c = 'WING A';
        objProjectImage.Cluster__c = 'LODHA ESTRELLA';
        objProjectImage.IsCommon__c = true;
        return objProjectImage;

    }
  //method covers scenario where booked a/c have project
  static testMethod void PositiveTest(){

    Account objAccount = createAccount();
        insert objAccount;

    /*  
    //create user
        User objUser = createUser(objAccount);
        insert objUser;
    */    
        Booking_Details__c Objbooking = CreateBooking(objAccount);
        insert Objbooking;
        
    Project_Name__c objProject = createProjectName();
        insert objProject;

    Project_Image__c objImage = createProjectImage(objProject);
    insert objImage;
        
        Project_Image__c objImage1 = createCommonEminitiesImage(objProject);
        insert objImage1;
        
    Test.StartTest();
    
     PageReference pageRef_1 = new PageReference('/apex/RMConstructionUpadate?CRN=' + objAccount.CRN__c);
     Test.setCurrentPage(pageRef_1);
     
     RMConstructionUpdatesController ConstructionObj = new RMConstructionUpdatesController();
     RMConstructionUpdatesController.Construction_items const_item = new RMConstructionUpdatesController.Construction_items();
     RMConstructionUpdatesController.Construction_videos const_video = new RMConstructionUpdatesController.Construction_videos();
      ConstructionObj.checkBackgroundImage()   ;    
    
    Test.stopTest();
    //checks if account 'project name' record is present in project name
    System.assertEquals(objAccount.Project_Name__c ,objProject.Name );
    //check if wing and cluster of project image and booking details are same
    System.assertEquals(objImage.Wing__c,Objbooking.Wing__c);
    System.assertEquals(objImage.Cluster__c,Objbooking.CLuster__c);
        //check if video related fields are not empty have same values
    System.assertEquals(objProject.Project_video1__c,'https://www.youtube.com/embed/lUU9q8GYUk8');
    System.assertEquals(objProject.Project_video2__c,'https://www.youtube.com/embed/lUU9q8GYUk8');
    System.assertEquals(objProject.Project_video3__c,'https://www.youtube.com/embed/lUU9q8GYUk8');
    System.assertEquals(objProject.Project_video4__c,'https://www.youtube.com/embed/lUU9q8GYUk8');
    System.assertEquals(objProject.Project_video5__c,'https://www.youtube.com/embed/lUU9q8GYUk8');
    System.assertEquals(objProject.Project_video6__c,'https://www.youtube.com/embed/lUU9q8GYUk8');
     
  }
  
  //this test method covers scenario where booked a/c associated project have no videos
    static testMethod void NegativeTest(){

    Account objAccount = createAccount();
        insert objAccount;

       
        Project_Name__c objProject = createProjectName1();
        insert objProject;
        
        Project_Image__c objImage = createProjectImage(objProject);
        insert objImage;

        test.StartTest();
        PageReference pageRef_1 = new PageReference('/apex/RMConstructionUpadate?CRN=' + objAccount.CRN__c);
        Test.setCurrentPage(pageRef_1);
            RMConstructionUpdatesController ConstructionObj = new RMConstructionUpdatesController();
            RMConstructionUpdatesController.Construction_items const_item = new RMConstructionUpdatesController.Construction_items();
            RMConstructionUpdatesController.Construction_videos const_video = new RMConstructionUpdatesController.Construction_videos();
           
       
        test.stopTest();
        //check if video related fields are empty
        System.assertEquals(null, objProject.Project_video1__c);
        System.assertEquals(null, objProject.Project_video2__c);
        System.assertEquals(null, objProject.Project_video3__c);
        System.assertEquals(null, objProject.Project_video4__c);
        System.assertEquals(null, objProject.Project_video5__c);
        System.assertEquals(null, objProject.Project_video6__c);  

  }
}