/*Description:
This class contains unit tests for validating the behavior of HomePageCSS2_0Controller class

 @Created by: Trupti Dhoka
 @Created Date: 6/05/2015
 
 --------------------------------------------------------------------------------
 | Modified By      | Modified Date       | Version        | Description         |
 --------------------------------------------------------------------------------
 |
 ----------------------------------------------------------------------------------------
 |
 ---------------------------------------------  -------------------------------------------
*/

@isTest

public class HomeCSS2_0ControllerTest {
    
    
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
        objAccount.Project_Name__c = 'New Cuffe Parade';
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
        
        //method for creating guest user for community
        private static User createGuestUser(Account a)
       {
            User objUser = new User();
            objUser.ProfileID = [Select Id From Profile Where Name = 'Customer_Portal Profile'].id;
            objUser.EmailEncodingKey = 'ISO-8859-1';
            objUser.LanguageLocaleKey = 'en_US';
            objUser.TimeZoneSidKey = 'America/New_York';
            objUser.LocaleSidKey = 'en_US';
            objUser.FirstName = 'first1';
            objUser.LastName = 'last1';
            objUser.Username = 'tes1t@appirio.com';
            objUser.CommunityNickname = 'test1User123';
            objUser.Alias = 't1';
            objUser.Email = 'no@email.com';
            objUser.IsActive = true;
            return objUser;
        }  
        
        //method for creating project name with Order type 'Custom'
        private static Project_Name__c  createProjectName()
        {
            Project_Name__c objprojectname = new Project_Name__c();
            objprojectname.Name = 'New Cuffe Parade';
            objprojectname.OrderType__c = 'Custom';
            objprojectname.Project_Type__c = 'Hi End / Luxury';
            objprojectname.Record_Type__c ='Residential';
            objprojectname.CSS_Background_Image_URL__c = 'https://c.cs7.content.force.com/servlet/servlet.FileDownload?file=00PM0000003RzGG';
            return objprojectname;
        }
        
        //method for creating project name with Order type 'Default'
        private static Project_Name__c  createProject_Default()
        {
            Project_Name__c objprojectname = new Project_Name__c();
            objprojectname.Name = 'New Cuffe Parade';
            objprojectname.OrderType__c = 'Default';
            objprojectname.Project_Type__c = 'Hi End / Luxury';
            objprojectname.Record_Type__c ='Residential';
            objprojectname.CSS_Background_Image_URL__c = 'https://c.cs7.content.force.com/servlet/servlet.FileDownload?file=00PM0000003RzGG';
            return objprojectname;
        }
        
        //method for creating project name with Order type 'Dynamic'
        private static Project_Name__c  createProjectName_dynamic()
        {
            Project_Name__c objprojectname = new Project_Name__c();
            objprojectname.Name = 'New Cuffe Parade';
            objprojectname.OrderType__c = 'Dynamic';
            objprojectname.Project_Type__c = 'Hi End / Luxury';
            objprojectname.Record_Type__c ='Residential';
            objprojectname.CSS_Background_Image_URL__c = 'https://c.cs7.content.force.com/servlet/servlet.FileDownload?file=00PM0000003RzGG';
            return objprojectname;
        }
        
        //method for creating widget sequence for CSS
        private static Widget_Sequence__c createWidgetSequence(user u,WidgetInfo__c w ,Project_Name__c p,Integer seq)
        {
            Widget_Sequence__c objsequence = new Widget_Sequence__c();
            objsequence.Project_Name__c = p.Id;
            objsequence.RecordTypeId = Schema.SObjectType.Widget_Sequence__c.getRecordTypeInfosByName().get('Default').getRecordTypeId();
            objsequence.Sequence_ClickCount__c = seq;
            objsequence.Sequence_for__c = 'CSS';
            objsequence.User__c = u.Id;
            objsequence.WidgetInfo__c = w.Id; 
            return objsequence;
        }
        
        //method for creating widgetinfo for crisp views
        private static  WidgetInfo__c createwidgetinformation(String name)
        {
            WidgetInfo__c objWidgetInfo = new WidgetInfo__c();
            objWidgetInfo.Available_For__c ='CSS';
            objWidgetInfo.Name = name;
            return objWidgetInfo;
        }
        
        static testMethod void positiveHometest() {
            //create account
            Account objAccount = createAccount();
            insert objAccount;
            
            //create user
            User u = createUser(objAccount);
            insert u;
            
            Project_Name__c projectname = createProjectName();
            insert projectname;
          
            WidgetInfo__c wid_info = createwidgetinformation('Recent Activity');
            insert wid_info;
            
            WidgetInfo__c wid_info1 = createwidgetinformation('Recent Docs');
            insert wid_info1;
            
            Widget_Sequence__c wid_sequence = createWidgetSequence(u,wid_info,projectname, 1);
            insert wid_sequence;
            
            Widget_Sequence__c wid_sequence1 = createWidgetSequence(u,wid_info1,projectname, 2);
            insert wid_sequence1;
            
            EnableDisable_widgets__c ED = new EnableDisable_widgets__c(isEnableForCustomer__c= true,
                                                                        Project_Name__c = projectname.Id,
                                                                        WidgetInfo__c = wid_info.Id);
                                                                        
            insert ED;
            
            EnableDisable_widgets__c ED1 = new EnableDisable_widgets__c(isEnableForCustomer__c= true,
                                                                        Project_Name__c = projectname.Id,
                                                                        WidgetInfo__c = wid_info1.Id);
            insert ED1;
                                                                        
            
            CSSBackgroundImageSetting__c projimage = new CSSBackgroundImageSetting__c(name='Project Wise',Project_Wise__c=true);
            insert projimage;
            HomeCSS2_0Controller homecontroller;
            system.runAs(u)
            {
            
                homecontroller = new HomeCSS2_0Controller ();
            }
                homecontroller.strProjectImageName =  'CB_Mailer';
                homecontroller.forwardToCustomAuthPage();
                homecontroller.checkBackgroundImage();
            
        }
        
        //Widget sequence with Dynamic record type
        static testMethod void positiveHometest_Dynamic() {
            //create account
            Account objAccount = createAccount();
            insert objAccount;
            
            //create user
            User u = createUser(objAccount);
            insert u;
            
            
            Project_Name__c projectname1 = createProjectName_dynamic();
            insert projectname1;
            
            WidgetInfo__c wid_info = createwidgetinformation('Recent Activity');
            insert wid_info;
            
            WidgetInfo__c wid_info1 = createwidgetinformation('Recent Docs');
            insert wid_info1;
            
            Widget_Sequence__c wid_sequence = createWidgetSequence(u,wid_info,projectname1, 1);
            insert wid_sequence;
            
            Widget_Sequence__c wid_sequence1 = createWidgetSequence(u,wid_info1,projectname1, 2);
            insert wid_sequence1;
            
            EnableDisable_widgets__c ED = new EnableDisable_widgets__c(isEnableForCustomer__c= true,
                                                                        Project_Name__c = projectname1.Id,
                                                                        WidgetInfo__c = wid_info.Id);
                                                                        
            insert ED;
            
            EnableDisable_widgets__c ED1 = new EnableDisable_widgets__c(isEnableForCustomer__c= true,
                                                                        Project_Name__c = projectname1.Id,
                                                                        WidgetInfo__c = wid_info1.Id);
            insert ED1;
                                                                        
            
            CSSBackgroundImageSetting__c projimage = new   CSSBackgroundImageSetting__c(name='Project Wise',Project_Wise__c=true);
            insert projimage;
            
            HomeCSS2_0Controller homecontroller;
            system.runAs(u)
            {
                homecontroller = new HomeCSS2_0Controller ();
            }
                homecontroller.strProjectImageName =  'CB_Mailer';
                homecontroller.forwardToCustomAuthPage();
                homecontroller.checkBackgroundImage();
               
           
        } 
        
        //Widget sequence with Default record type
        static testMethod void positiveHometest_Default() {
            
            //create account
            Account objAccount = createAccount();
            insert objAccount;
            
            //create user
            User u = createUser(objAccount);
            insert u;
            
            Project_Name__c projectname2 = createProject_Default();
            insert projectname2;
            
            WidgetInfo__c wid_info = createwidgetinformation('Recent Activity');
            insert wid_info;
            
            WidgetInfo__c wid_info1 = createwidgetinformation('Recent Docs');
            insert wid_info1;
            
            Widget_Sequence__c wid_sequence = createWidgetSequence(u,wid_info,projectname2, 1);
            insert wid_sequence;
            
            Widget_Sequence__c wid_sequence1 = createWidgetSequence(u,wid_info1,projectname2, 2);
            insert wid_sequence1;
            
            EnableDisable_widgets__c ED = new EnableDisable_widgets__c(isEnableForCustomer__c= true,
                                                                        Project_Name__c = projectname2.Id,
                                                                        WidgetInfo__c = wid_info.Id);
                                                                        
            insert ED;
            
            EnableDisable_widgets__c ED1 = new EnableDisable_widgets__c(isEnableForCustomer__c= true,
                                                                        Project_Name__c = projectname2.Id,
                                                                        WidgetInfo__c = wid_info1.Id);
            insert ED1;
                                                                        
            
            CSSBackgroundImageSetting__c projimage = new   CSSBackgroundImageSetting__c(name='Project Wise',Project_Wise__c=true);
            insert projimage;
            
            HomeCSS2_0Controller homecontroller;
            system.runAs(u)
            {
            
                homecontroller = new HomeCSS2_0Controller ();
            }
            homecontroller.strProjectImageName =  'CB_Mailer';
            homecontroller.forwardToCustomAuthPage();
            homecontroller.checkBackgroundImage();
             
        } 
        
        

}