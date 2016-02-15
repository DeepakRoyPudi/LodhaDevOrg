/* 
Description: Test Class For BookingDetailsCSS2_0Controller
@Created by: Madan Khadka
@Created Date:

--------------------------------------------------------------------------------
| Modified By      | Modified Date       | Version        | Description         |
--------------------------------------------------------------------------------
| Aditi Mulmule      07/07/2015
---------------------------------------------------------------------------------
*/
@isTest
private class BookingDetailsCSS2_0ControllerTest {
    // BookingDetailsCSS2OpenParking() method is for open Parking
    static testMethod void BookingDetailsCSS2OpenParking() {
        //create Account
        Account objAccount = createAccount();
        insert objAccount;
        //create contact
        Contact objContact = createContact(objAccount.Id);
        insert objContact;
        //create user
        User objUser = createUser(objContact.Id);
        insert objUser;
        //insert project
        Project_Name__c ObjProject = createProjectName();
        insert ObjProject;
        //create booking
        Booking_Details__c objBooking_Details = createBookingObject(objAccount.CRN__c,objAccount.Id);
        insert objBooking_Details;
        //insert booking information
        Booking_Information__c objBooking_Information =  new Booking_Information__c();
        objBooking_Information.CRN_Number_SAP__c = objAccount.CRN__c;
        objBooking_Information.Open_Parkings__c=4;
        insert objBooking_Information;
        
        PageReference pageRef = Page.BookingDetailsCSS2_0;  
        system.Test.setCurrentPage(pageRef);
        
        system.runas(objUser){
            BookingDetailsCSS2_0Controller objBookingDetailsCSS2_0Controller = new BookingDetailsCSS2_0Controller();
            objBookingDetailsCSS2_0Controller.CRN = objAccount.CRN__c;
            BookingDetailsCSS2_0Controller.username = objAccount.Name;
            //query booking info
            List<Booking_Information__c> lstBookingInformation =[Select CRN_Number_SAP__c, 
                                                                        Stilt_Parkings__c,
                                                                        Other_Parkings__c,
                                                                        Open_Parkings__c,
                                                                        MLCP_Parkings__c,
                                                                        Closed_Parkings__c
                                                                 from Booking_Information__c 
                                                                 where CRN_Number_SAP__c=:objAccount.CRN__c
                                                                 Limit 1];
            //query booking details
            Booking_Details__c objBooking = [Select Project__c, 
                                                    Flat_ID__c,
                                                    Flat_No__c,
                                                    Wing__c,
                                                    Allotment_Date__c,
                                                    Application_Date__c
                                             from Booking_Details__c 
                                             where CRN__c =:objAccount.CRN__c
                                             limit 1];
           //query project name                                  
           Project_Name__c  ObjProject1 = [Select Location__c
                                          From Project_Name__c
                                          where Name=:objBooking.Project__c
                                          limit 1];        
                                                     
                                            
            Test.startTest();
            //assert all in inserted values
            System.assertEquals(4,lstBookingInformation[0].Open_Parkings__c);
            System.assertEquals('Lodha',objBooking.Project__c);
            System.assertEquals('14231515',objBooking.Flat_ID__c);
            System.assertEquals('31',objBooking.Flat_No__c);
            System.assertEquals('New Wing',objBooking.Wing__c);
            System.assertEquals(System.Today()-10,objBooking.Allotment_Date__c); 
            System.assertEquals(System.Today(),objBooking.Application_Date__c);
            System.assertEquals(ObjProject1.Location__c,objBookingDetailsCSS2_0Controller.projectLocation);
          
            test.stopTest();
        }
    }
    
    // BookingDetailsCSS2Stilt_Parkings() method is for Stilt Parking
    static testMethod void BookingDetailsCSS2Stilt_Parkings() {
        //create Account
        Account objAccount = createAccount();
        insert objAccount;
        //create contact
        Contact objContact = createContact(objAccount.Id);
        insert objContact;
        //create user
        User objUser = createUser(objContact.Id);
        insert objUser;
        
        //insert project
        Project_Name__c ObjProject = createProjectName();
        insert ObjProject;
        //create booking
        Booking_Details__c objBooking_Details = createBookingObject(objAccount.CRN__c,objAccount.Id);
        insert objBooking_Details;
        
        //insert booking
        Booking_Information__c objBooking_Information =  new Booking_Information__c();
        objBooking_Information.CRN_Number_SAP__c = objAccount.CRN__c;
        objBooking_Information.Stilt_Parkings__c=10;
        
        insert  objBooking_Information;
        
        PageReference pageRef = Page.BookingDetailsCSS2_0;  
        system.Test.setCurrentPage(pageRef);
        
        system.runas(objUser){
            BookingDetailsCSS2_0Controller objBookingDetailsCSS2_0Controller = new BookingDetailsCSS2_0Controller();
            objBookingDetailsCSS2_0Controller.CRN = objAccount.CRN__c;
            BookingDetailsCSS2_0Controller.username = objAccount.Name;
            //query booking info to assert stilt parkings
            List<Booking_Information__c> lstBookingInformation =[Select Stilt_Parkings__c
                                                                 from Booking_Information__c 
                                                                 where CRN_Number_SAP__c=:objAccount.CRN__c 
                                                                 Limit 1];
            Test.startTest();
            System.assertEquals(10,lstBookingInformation[0].Stilt_Parkings__c);
            test.stopTest();
        }
    }
    
    // BookingDetailsCSS2Other_Parkings() method is for Other Parking
    static testMethod void BookingDetailsCSS2Other_Parkings() {
        Account objAccount = createAccount();
        insert objAccount;
         //create contact
        Contact objContact = createContact(objAccount.Id);
        insert objContact;
        //create user
        User objUser = createUser(objContact.Id);
        insert objUser;
        
        //create project
        Project_Name__c ObjProject = createProjectName();
        insert ObjProject;
        //create booking
        Booking_Details__c objBooking_Details = createBookingObject(objAccount.CRN__c,objAccount.Id);
        insert objBooking_Details;
        //insert booking info
        Booking_Information__c objBooking_Information =  new Booking_Information__c();
        objBooking_Information.CRN_Number_SAP__c = objAccount.CRN__c;
        objBooking_Information.Other_Parkings__c=5;
        insert objBooking_Information;
        
        PageReference pageRef = Page.BookingDetailsCSS2_0;  
        system.Test.setCurrentPage(pageRef);
        
        system.runas(objUser){
            BookingDetailsCSS2_0Controller objBookingDetailsCSS2_0Controller = new BookingDetailsCSS2_0Controller();
            objBookingDetailsCSS2_0Controller.CRN = objAccount.CRN__c;
            BookingDetailsCSS2_0Controller.username = objAccount.Name;
            //query booking info for asserting other parking
            List<Booking_Information__c> lstBookingInformation =[Select  Other_Parkings__c
                                                                 from Booking_Information__c 
                                                                 where CRN_Number_SAP__c=:objAccount.CRN__c 
                                                                 Limit 1];
            Test.startTest();
            System.assertEquals(5,lstBookingInformation[0].Other_Parkings__c);
            test.stopTest();
        }
    }
    
    // BookingDetailsCSS2MLCP_Parkings() method is for MLCP Parking
    static testMethod void BookingDetailsCSS2MLCP_Parkings() {
         //create Account
        Account objAccount = createAccount();
        insert objAccount;
          //create contact
        Contact objContact = createContact(objAccount.Id);
        insert objContact;
        //create user
        User objUser = createUser(objContact.Id);
        insert objUser;
        //insert project
        Project_Name__c ObjProject = createProjectName();
        insert ObjProject;
        //create booking
        Booking_Details__c objBooking_Details = createBookingObject(objAccount.CRN__c,objAccount.Id);
        
        insert objBooking_Details;
        //insert booking info
        Booking_Information__c objBooking_Information =  new Booking_Information__c();
        objBooking_Information.CRN_Number_SAP__c = objAccount.CRN__c;
        objBooking_Information.MLCP_Parkings__c=8;
        insert objBooking_Information;
        
        PageReference pageRef = Page.BookingDetailsCSS2_0;  
        system.Test.setCurrentPage(pageRef);
        
        system.runas(objUser){
            BookingDetailsCSS2_0Controller objBookingDetailsCSS2_0Controller = new BookingDetailsCSS2_0Controller();
            objBookingDetailsCSS2_0Controller .CRN = objAccount.CRN__c;
            BookingDetailsCSS2_0Controller.username = objAccount.Name;
            //query booking info to assert mlcp parkings
            List<Booking_Information__c> lstBookingInformation =[Select MLCP_Parkings__c
                                                                 from Booking_Information__c 
                                                                 where CRN_Number_SAP__c=:objAccount.CRN__c
                                                                 Limit 1];
            Test.startTest();
            System.assertEquals(8,lstBookingInformation[0].MLCP_Parkings__c);
            test.stopTest();
        }
        
    }
    
    // BookingDetailsCSS2Closed_Parkings() method is for Closed Parking
    static testMethod void BookingDetailsCSS2Closed_Parkings() {
         //create Account
        Account objAccount = createAccount();
        insert objAccount;
         //create contact 
        Contact objContact = createContact(objAccount.Id);
        insert objContact;
        //insert user
        User objUser = createUser(objContact.Id);
        insert objUser;
        
        //insert project
        Project_Name__c ObjProject = createProjectName();
        insert ObjProject;
        //insert booking
        Booking_Details__c objBooking_Details =  createBookingObject(objAccount.CRN__c,objAccount.Id);
        
        insert objBooking_Details;
        //insert booking info
        Booking_Information__c objBooking_Information =  new Booking_Information__c();
        objBooking_Information.CRN_Number_SAP__c = objAccount.CRN__c;
        objBooking_Information.Closed_Parkings__c=7;
        insert objBooking_Information;
        
        
        PageReference pageRef = Page.BookingDetailsCSS2_0;  
        system.Test.setCurrentPage(pageRef);
        
        system.runas(objUser){
            BookingDetailsCSS2_0Controller objBookingDetailsCSS2_0Controller = new BookingDetailsCSS2_0Controller();
            objBookingDetailsCSS2_0Controller.CRN = objAccount.CRN__c;
            BookingDetailsCSS2_0Controller.username = objAccount.Name;
            //query booking to assert closed parkings
            List<Booking_Information__c> lstBookingInformation =[Select Closed_Parkings__c
                                                                 from Booking_Information__c 
                                                                 where CRN_Number_SAP__c=:objAccount.CRN__c 
                                                                 Limit 1];
            Test.startTest();
            System.assertEquals(7,lstBookingInformation[0].Closed_Parkings__c);
            test.stopTest();
        }
    }
    // BookingDetailsCSS2_NAParkings() is for Naparking
    static testMethod void BookingDetailsCSS2_NAParkings() {
         //create Account
        Account objAccount = createAccount();
        insert objAccount;
          //create contact
        Contact objContact = createContact(objAccount.Id);
        insert objContact;
        //create user
        User objUser = createUser(objContact.Id);
        insert objUser;
        //create project
        Project_Name__c ObjProject = createProjectName();
        insert ObjProject;
        //insert booking
        Booking_Details__c objBooking_Details =  new Booking_Details__c();
        objBooking_Details.CRN__c=objAccount.CRN__c;
        objBooking_Details.Account__c = objAccount.id;
        objBooking_Details.Project__c='Lodha';
        objBooking_Details.Flat_ID__c = '14231515';
        objBooking_Details.Flat_No__c = '31';
        insert objBooking_Details;
        //insert booking info
        Booking_Information__c objBooking_Information =  new Booking_Information__c();
        objBooking_Information.CRN_Number_SAP__c = objAccount.CRN__c;
        insert objBooking_Information;
        PageReference pageRef = Page.BookingDetailsCSS2_0;  
        system.Test.setCurrentPage(pageRef);
        
        system.runas(objUser){
            BookingDetailsCSS2_0Controller objBookingDetailsCSS2_0Controller = new BookingDetailsCSS2_0Controller();
            objBookingDetailsCSS2_0Controller.CRN = objAccount.CRN__c;
            BookingDetailsCSS2_0Controller.username = objAccount.Name;
            //assert booking info for CRN number Sap
            List<Booking_Information__c> lstBookingInformation =[Select CRN_Number_SAP__c
                                                                 from Booking_Information__c 
                                                                 where CRN_Number_SAP__c=:objAccount.CRN__c 
                                                                 Limit 1];
            Test.startTest();
            System.assertEquals('154215',lstBookingInformation[0].CRN_Number_SAP__c);
            test.stopTest();
        }
    }
    //negative test for null values in booking object
     static testMethod void NegativeTest() {
        //create Account
        Account objAccount = createAccount();
        insert objAccount;
          //create contact
        Contact objContact = createContact(objAccount.Id);
        insert objContact;
        //create user
        User objUser = createUser(objContact.Id);
        insert objUser;
        
        //create project name
        Project_Name__c ObjProject = createProjectName();
        insert ObjProject;
        
        //insert booking for null checks
        Booking_Details__c objBooking_Details =  new Booking_Details__c();
        objBooking_Details.CRN__c = objAccount.CRN__c;
        objBooking_Details.Account__c = objAccount.Id;
        objBooking_Details.Project__c=null;
        objBooking_Details.Flat_ID__c = '12345';
        objBooking_Details.Flat_No__c = null;
        objBooking_Details.Wing__c =null;
        objBooking_Details.Allotment_Date__c = System.Today()-10;
        objBooking_Details.Application_Date__c =  null;
        insert objBooking_Details;
        
        //create booking info
        Booking_Information__c objBooking_Information =  new Booking_Information__c();
        objBooking_Information.CRN_Number_SAP__c = objAccount.CRN__c;
        objBooking_Information.Closed_Parkings__c=7;
        insert objBooking_Information;
        
        
        PageReference pageRef = Page.BookingDetailsCSS2_0;  
        system.Test.setCurrentPage(pageRef);
        
        system.runas(objUser){
            BookingDetailsCSS2_0Controller objBookingDetailsCSS2_0Controller = new BookingDetailsCSS2_0Controller();
            objBookingDetailsCSS2_0Controller.CRN = objAccount.CRN__c;
            BookingDetailsCSS2_0Controller.username = objAccount.Name;
           
            //query booking details to assert null booking values                                                   
            Booking_Details__c objBooking = [Select Project__c, 
                                                    Flat_ID__c,
                                                    Flat_No__c,
                                                    Wing__c,
                                                    Allotment_Date__c,
                                                    Application_Date__c,
                                                    Co_Applicant__c
                                             from Booking_Details__c 
                                             where CRN__c =:objAccount.CRN__c
                                             limit 1];
            Test.startTest();
            System.assertEquals(null,objBooking.Project__c);
            System.assertEquals('12345',objBooking.Flat_ID__c);
            System.assertEquals(null,objBooking.Flat_No__c);
            System.assertEquals(null,objBooking.Wing__c);
            System.assertEquals(System.Today()-10,objBooking.Allotment_Date__c); 
            System.assertEquals(null,objBooking.Application_Date__c);
         
            test.stopTest();
        }
    }
    
    //method to create account
    private static Account createAccount() {
        Account objAccount = new Account();
        objAccount.CRN__c='154215';
        objAccount.Name='Madan';
        objAccount.Project_Name__c = 'Xyz';
        return objAccount;
    }
    //method to create contact
    private static Contact createContact(Id accId){
        Contact objContact = new Contact();
        objContact.LastName='Alias';
        objContact.AccountId= accId;
        return objContact;
    }
    //method to create User
    private static User createUser(Id contactId ){
        User objUser = new User();
        objUser.ProfileID = [Select Id 
                             From Profile
                             Where Name='Custom Overage High Volume Customer Portal'].id;
        objUser.EmailEncodingKey = 'ISO-8859-1';
        objUser.LanguageLocaleKey = 'en_US';
        objUser.TimeZoneSidKey = 'America/New_York';
        objUser.LocaleSidKey = 'en_US';
        objUser.FirstName = 'first';
        objUser.LastName = 'last';
        objUser.Username = 'test@appirio.com';   
        objUser.CommunityNickname = 'testUser123';
        objUser.Alias = 't1';
        objUser.Email = 'no@email.com';
        objUser.IsActive = true;
        objUser.ContactId = contactId;
        return objUser;
    }
    //method to create Project Object
    private static Project_Name__c createProjectName() {
        Project_Name__c objProject = new Project_Name__c();
        objProject.Name = 'Lodha';
        objProject.CSS_Background_Image_URL__c ='https://c.cs7.content.force.com/servlet/servlet.FileDownload?file=00PM0000003RzGG';
        objProject.Record_Type__c = 'Residential';
        objProject.Location__c = 'Palava';
        return objProject ;
    }
    
    //menthod to create a booking
    private static Booking_Details__c createBookingObject(String CRN,Id accId) {
        Booking_Details__c objBooking_Details =  new Booking_Details__c();
        objBooking_Details.CRN__c = CRN;
        objBooking_Details.Account__c = accId;
        objBooking_Details.Project__c='Lodha';
        objBooking_Details.Flat_ID__c = '14231515';
        objBooking_Details.Flat_No__c = '31';
        objBooking_Details.Wing__c ='New Wing';
        objBooking_Details.Allotment_Date__c = System.Today()-10;
        objBooking_Details.Application_Date__c =  System.Today();
        return objBooking_Details;
    }
    
    
}