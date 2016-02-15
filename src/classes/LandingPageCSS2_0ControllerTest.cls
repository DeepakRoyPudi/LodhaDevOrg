/* 
Description - This class contains unit tests for validating the 
 *               behavior of LandingPageCSS2_0Controller class

 @Created by: Trupti Dhoka
 @Created Date: 6/05/2015
 
 --------------------------------------------------------------------------------
 | Modified By      | Modified Date       | Version        | Description         |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------
*/


@isTest
public class LandingPageCSS2_0ControllerTest {
    
        //method for creating account
        private static Account createAccount(){
            Account objAccount = new Account();
            objAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Booked Account').getRecordTypeId();
            objAccount.FirstName = 'Test1';
            objAccount.LastName = 'Account1';
            objAccount.CRN__c = '154215';
            objAccount.H_Mobile_No__c = '1234560789';
            objAccount.Mobile_Phone__c = '21241222';
            objAccount.Co_Applicant__c = 'test';
            objAccount.DOB_Of_Client__c = date.today() -60;
            objAccount.Anniversary_Date__c = date.today() - 120;
            objAccount.DOB_of_Spouse__c = date.today();
            objAccount.No_of_children__c = 2;
            objAccount.Assets_Owned_Homes__c = 3;
            objAccount.Car_s_Owned__c ='BMW';
            objAccount.Other_residences_owned_at_Lodha_Group_CC__c = 2;
            objAccount.TRAI_DND__c = true;
            return objAccount;
      } 
      //method for creating community user
       private static User createUser(Account a)
       {
            User objUser = new User();
            contact c=[select id from contact where accountid=:a.id limit 1];
            objUser.ProfileID = [Select Id From Profile Where Name = 'Custom Overage High Volume Customer Portal'].id;
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
            objUser.ContactId = c.id;
            return objUser;
        }  
        
        private static Booking_Details__c CreateBooking(Account a)
        {
            Booking_Details__c ObjBooking = new Booking_Details__c ();
            ObjBooking.CRN__c = '154215';
            ObjBooking.Flat_ID__c = 'R5210A0304M0';
            ObjBooking.Account__c = a.id;
            ObjBooking.Project__c = 'Lakeshore Greens';
            ObjBooking.Allotment_Date__c = system.today();
            return ObjBooking;
        }
        
        private static Project_Name__c createProjectName()
        {
            Project_Name__c objProject = new Project_Name__c();
            objProject.Name = 'Lakeshore Greens';
            objProject.Project_Type__c = ' Hi End / Luxury';
            objProject.Record_Type__c = 'Residential';
            //objProject.CurrencyIsoCode = 'INR - Indian Rupee';
            return objProject ;
        }
       
        static testMethod void landingpagetest() {
            
        //create booked a/c
        Account objAccount = createAccount();
        insert objAccount;
        
        //create related booking detail
        Booking_Details__c  Objbooking = CreateBooking(objAccount);
        insert Objbooking ;
        
        //create Project name
        Project_Name__c objProject = createProjectName();
        insert objProject;
        
        //create community user
        User u = createUser(objAccount);
        insert u;
        
        //create custom links for landing page.
        Customer360AndCSS2_0Links01__c WelcomeGuide= new Customer360AndCSS2_0Links01__c(name='WelcomeGuide',Links__c='www.google.com');
        insert WelcomeGuide;
        
        Customer360AndCSS2_0Links01__c Faqs =new   Customer360AndCSS2_0Links01__c(name='FAQs',Links__c='www.google.com');
        insert Faqs;
        
        Customer360AndCSS2_0Links01__c ServiceOfferings= new   Customer360AndCSS2_0Links01__c(name='ServiceOfferings',Links__c='www.google.com');
        insert ServiceOfferings;
        
        Customer360AndCSS2_0Links01__c Myinbox= new   Customer360AndCSS2_0Links01__c(name='MyMailbox',Links__c='www.google.com');
        insert Myinbox;
        
        Customer360AndCSS2_0Links01__c DetailsOfPossessionProcess=  new   Customer360AndCSS2_0Links01__c(name='DetailsOfPossessionProcess',Links__c='www.google.com');
        insert  DetailsOfPossessionProcess; 
        
            LandingPageCSS2_0Controller landingpagecontroler;
        system.runAs(u)
        {
            landingpagecontroler = new LandingPageCSS2_0Controller();
        }
            test.StartTest(); 
	        RMCSS2_0CustomSettingLinkController customlinkcontroller = new RMCSS2_0CustomSettingLinkController();
	        String WelcomeGuide1 = customlinkcontroller.getWelcomeGuide();
	        String faqs1 = customlinkcontroller.getFaqs();
	        String serviceofferings1 = customlinkcontroller.getServiceOfferings();
	        String inbox1 = customlinkcontroller.getMyinbox();
	        String possesion1 = customlinkcontroller.getDetailsOfPossessionProcess();
	        landingpagecontroler.init();
	        landingpagecontroler.redirect_ProfileInfoPage();
	        test.StopTest();
	        System.assertEquals(WelcomeGuide1,'http://www.google.com');  
	        System.assertEquals(faqs1,'http://www.google.com');
	        System.assertEquals(serviceofferings1,'http://www.google.com');
	        System.assertEquals(inbox1,'http://www.google.com');
	        System.assertEquals(possesion1,'http://www.google.com');
            
        }
    
       
}