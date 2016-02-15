/**
/*<!--  -->
<!--    Version      - 1.0   -->
<!--    Created By   - Trupti D. -->
<!--    Created Date - 30/03/2015 -->

<!--    Description  - Test Class for Crisp view of Recent activity -->*/
@isTest
private class RecentActivityCSSControllerTest {
    
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
        objAccount.Assets_Owned_Homes__c = 15; 
        objAccount.Other_residences_owned_at_Lodha_Group_CC__c  = 15;
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
    private static WidgetInfo__c ObjWidgetInfo()
    {
        WidgetInfo__c objWidgetInfo = new WidgetInfo__c();
        objWidgetInfo.Name='Recent Activity';
        objWidgetInfo.Available_For__c = 'Both'; 
        return objWidgetInfo;
    }  
    private static SAPBookingIDAgentMapping_del__c createObjSapbooking(User u)
    {
        SAPBookingIDAgentMapping_del__c objSAPBookingIDAgentMapping_del = new SAPBookingIDAgentMapping_del__c();
        objSAPBookingIDAgentMapping_del.Booking_ID__c='BK144521'; 
        objSAPBookingIDAgentMapping_del.Agent_Name__c=u.id;
        objSAPBookingIDAgentMapping_del.Wing__c='A';
        objSAPBookingIDAgentMapping_del.Project_Name__c='XYZ';
        objSAPBookingIDAgentMapping_del.Flat_No__c='4';
        return objSAPBookingIDAgentMapping_del;
    }
    static testMethod void recentActivityCSSWithoutCase() {
        
        Account objAccount = createAccount();
        insert objAccount;
        
        User objUser = createUser(objAccount);
        insert objUser;
        
        RecentActivityCSSController objRecentActivityCSSController = new RecentActivityCSSController();
        objRecentActivityCSSController.Customer_CRN = objAccount.CRN__c;
        Test.startTest();
      //  System.assertEquals(0,objRecentActivityCSSController.lstCase_crispView.size());
        Test.stopTest();
        objRecentActivityCSSController.clickCount();
        
    }
    
    static testMethod void recentActivityCSSWithCase() 
    {

        Account objAccount = createAccount();
        insert objAccount;
        
        User objUser = createUser(objAccount);
        insert objUser;
        
        WidgetInfo__c objWidget = ObjWidgetInfo();
        insert objWidget;

        SAPBookingIDAgentMapping_del__c objSapbooking = createObjSapbooking(objUser); 
        insert objSapbooking; 

        List<Widget_Sequence__c> lstWidget_Sequence = new List<Widget_Sequence__c>();
        for(Integer i = 0; i < 10; i++){
             Widget_Sequence__c objWidget_Sequence = new Widget_Sequence__c();
             objWidget_Sequence.Sequence_ClickCount__c= 0;
             objWidget_Sequence.WidgetInfo__c=objWidget.id;
             objWidget_Sequence.User__c = objUser.Id ;
             lstWidget_Sequence.add(objWidget_Sequence);
         } 
        insert lstWidget_Sequence;
            
        //create 3 list records with Related_to.length>59
         List<Case> lstCase = new List<Case>();
            for(Integer i = 0; i < 11; i++){
                Case objCase = new Case();
                objCase.AccountId = objAccount.Id;
                objCase.Project__c='XY';
                objCase.Buildings_Name__c='z';
                objCase.Wing__c='A';
                objCase.Communication_Type__c ='Inbound';
                objCase.Interaction_Mode__c ='CSS';
                objCase.Nature_of_Request__c = 'Query';
                objCase.Flat_No__c = '4';
                objCase.Request_for_L1__c = 'Schemes/Initiatives/Events/Campaigns';
                objCase.Request_for_L2__c = 'MyGain facility/ADF facility/Amnesty/Dollar product/Home loan interest offer';
                objCase.Request_for_L3_a__c = 'Customer not contactable';
                objCase.Request_for_L3__c = 'Call Back Later';
                objCase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CM_Parent_Only').getRecordTypeId();
                objCase.Status='New';
                lstCase.add(objCase);
            }
            insert lstCase;
            system.runAS(objUser){
                RecentActivityCSSController objRecentActivityCSSController = new RecentActivityCSSController();
                objRecentActivityCSSController.Customer_CRN = objAccount.CRN__c;
                Test.startTest();
               // System.assertNotEquals(null,objRecentActivityCSSController.lstCase_crispView.size());
                objRecentActivityCSSController.clickCount();
                Test.stopTest();
            }
            
    }
    
    /*This method tests the length of relatedTo field in 0 and 2 case record*/
    static testMethod void recentActivityCSSWithotherCase() {
        
        //create accounts
        Account objAccount = createAccount();
        insert objAccount;
        
        //create community user
        User objUser = createUser(objAccount);
        insert objUser;
        
        system.runAS(objUser){
        //create 3 list records with Related_to.length>59
        List<Case> lstCase1 = new List<Case>();
         
            Case objCase = new Case();
            objCase.AccountId = objAccount.Id;
            objCase.Project__c='XY';
            objCase.Buildings_Name__c='z';
            objCase.Wing__c='A';
            objCase.Flat_No__c = '4';
            objCase.Interaction_Mode__c ='CSS';
            objCase.Communication_Type__c ='Inbound';
            objCase.Nature_of_Request__c = 'Query';
            objCase.Status = 'Open';
            objCase.Request_for_L1__c = 'Schemes/Initiatives/Events/Campaigns';
            objCase.Request_for_L2__c = 'MyGain facility/ADF facility/Amnesty/Dollar product/Home loan interest offer';
            objCase.Request_for_L3_a__c = 'Customer not contactable';
            objCase.Request_for_L3__c = 'Call Back Later';
            objCase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CM_Parent_Only').getRecordTypeId();
            objCase.Status='New';
            insert objCase;
           
           Case objCase1 = new Case();
            objCase1.AccountId = objAccount.Id;
            objCase1.Project__c='XY';
            objCase1.Buildings_Name__c='z';
            objCase1.Wing__c='A';
            objCase1.Flat_No__c = '4';
            objCase1.Interaction_Mode__c ='CSS';
            objCase1.Communication_Type__c ='Inbound';
            objCase1.Nature_of_Request__c = 'Query';
            objCase1.Status = 'Open';
            objCase1.Request_for_L1__c = 'Brokerage related';
            objCase1.Request_for_L2__c = 'Greeting';
            objCase1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CM_Parent_Only').getRecordTypeId();
            objCase1.Status='New';
            insert objCase1;
          
            Case objCase3 = new Case();
            objCase3.AccountId = objAccount.Id;
            objCase3.Project__c='XY';
            objCase3.Buildings_Name__c='z';
            objCase3.Wing__c='A';
            objCase3.Flat_No__c = '4';
            objCase3.Interaction_Mode__c ='CSS';
            objCase3.Communication_Type__c ='Inbound';
            objCase3.Nature_of_Request__c = 'Query';
            objCase3.Status = 'Open';
            objCase3.Request_for_L1__c = 'Schemes/Initiatives/Events/Campaigns';
            objCase3.Request_for_L2__c = 'MyGain facility/ADF facility/Amnesty/Dollar product/Home loan interest offer';
            objCase3.Request_for_L3_a__c = 'Customer not contactable';
            objCase3.Request_for_L3__c = 'Call Back Later';
            objCase3.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CM_Parent_Only').getRecordTypeId();
            objCase3.Status='New';
            insert objCase3;
            
           RecentActivityCSSController objRecentActivityCSSController = new RecentActivityCSSController();
           objRecentActivityCSSController.Customer_CRN = objAccount.CRN__c;
           Test.startTest();
        //   System.assertNotEquals(null,objRecentActivityCSSController.lstCase_crispView.size());
           objRecentActivityCSSController.clickCount();
           Test.stopTest();
        }

    }

  
 }