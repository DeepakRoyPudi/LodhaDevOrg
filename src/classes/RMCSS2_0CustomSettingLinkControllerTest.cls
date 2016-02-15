/* 
Description:
test class for cover the controller which is used in Rm side bar component 

 @Created by: Sudeep Dube
 @Created Date: 30/03/2015
 
 --------------------------------------------------------------------------------
 | Modified By      | Modified Date       | Version        | Description         |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------
*/

@isTest
public class RMCSS2_0CustomSettingLinkControllerTest {
    static testmethod void testRMCSS2_0CustomSettingLinkController() {

        //create test data for the custom setting which holds the name and respective URLs
        list < Customer360AndCSS2_0Links01__c > settingList = new list < Customer360AndCSS2_0Links01__c > ();
        Customer360AndCSS2_0Links01__c setting1 = 
            new Customer360AndCSS2_0Links01__c(name = 'CDI_Info', Links__c = 'www.google.com');
        Customer360AndCSS2_0Links01__c setting2 = 
            new Customer360AndCSS2_0Links01__c(name = 'CircularsAndNotifications', Links__c = 'www.google.com');
        Customer360AndCSS2_0Links01__c setting3 = 
            new Customer360AndCSS2_0Links01__c(name = 'DocumentTemplates', Links__c = 'www.google.com');
        Customer360AndCSS2_0Links01__c setting4 = 
            new Customer360AndCSS2_0Links01__c(name = 'PolicyAndProcessDoc', Links__c = 'www.google.com');
        Customer360AndCSS2_0Links01__c setting5 = 
            new Customer360AndCSS2_0Links01__c(name = 'ProductFeatures', Links__c = 'www.google.com');
        Customer360AndCSS2_0Links01__c setting6 = 
            new Customer360AndCSS2_0Links01__c(name = 'ProjectPage', Links__c = 'www.google.com');
        Customer360AndCSS2_0Links01__c setting7 = 
            new Customer360AndCSS2_0Links01__c(name = 'Responses', Links__c = 'www.google.com');
        Customer360AndCSS2_0Links01__c setting8 = 
            new Customer360AndCSS2_0Links01__c(name = 'UniversalStandard', Links__c = 'www.google.com');
        Customer360AndCSS2_0Links01__c setting9 = 
            new Customer360AndCSS2_0Links01__c(name = 'WelcomeGuide', Links__c = 'www.google.com');
        Customer360AndCSS2_0Links01__c setting10 = 
            new Customer360AndCSS2_0Links01__c(name = 'FAQs', Links__c = 'www.google.com');
        Customer360AndCSS2_0Links01__c setting11 = 
            new Customer360AndCSS2_0Links01__c(name = 'ServiceOfferings', Links__c = 'www.google.com');
        Customer360AndCSS2_0Links01__c setting12 = 
            new Customer360AndCSS2_0Links01__c(name = 'DetailsOfPossessionProcess', Links__c = 'www.google.com');
        Customer360AndCSS2_0Links01__c setting13 = 
            new Customer360AndCSS2_0Links01__c(name = 'MyMailbox', Links__c = 'www.google.com');
        Customer360AndCSS2_0Links01__c setting14 = 
            new Customer360AndCSS2_0Links01__c(name = 'RegistrationGuidelines', Links__c = 'www.google.com');
        

        settingList.add(setting1);
        settingList.add(setting2);
        settingList.add(setting3);
        settingList.add(setting4);
        settingList.add(setting5);
        settingList.add(setting6);
        settingList.add(setting7);
        settingList.add(setting8);
        settingList.add(setting9);
        settingList.add(setting10);
        settingList.add(setting11);
        settingList.add(setting12);
        settingList.add(setting13);
        settingList.add(setting14);
       

        //inserted the data into the custom setting object
        insert settingList;

        //below class is controller which used in RMSidebar Components 
        RMCSS2_0CustomSettingLinkController rmlinks = new RMCSS2_0CustomSettingLinkController();
        
        //for cover each method call it and compare its return values in assert for test validating
        System.assertNotEquals(rmlinks.getCDIInfo(), null);
        System.assertNotEquals(rmlinks.getCDIInfo(), '');
        System.assertNotEquals(rmlinks.getCirculars_and_Notifications(), null);
        System.assertNotEquals(rmlinks.getCirculars_and_Notifications(), '');
        System.assertNotEquals(rmlinks.getDocument_Templates(), null);
        System.assertNotEquals(rmlinks.getPolicy_and_Process_Doc(), null);
        System.assertNotEquals(rmlinks.getProduct_Features(), null);
        System.assertNotEquals(rmlinks.getProject_Page(), null);
        System.assertNotEquals(rmlinks.getUniversal_Standard(), null);
        System.assertNotEquals(rmlinks.getWelcomeGuide(), null);
        System.assertNotEquals(rmlinks.getFaqs(), null);
        System.assertNotEquals(rmlinks.getServiceOfferings(), null);
        System.assertNotEquals(rmlinks.getDetailsOfPossessionProcess(), null);
        System.assertNotEquals(rmlinks.getMyinbox(), null);
        System.assertNotEquals(rmlinks.getRegistrationLink(), null);
   
    
    }

   
}