/*<!--  -->
<!--    Version      - 1.0   -->
<!--    Created By   - Trupti D. -->
<!--    Created Date - 1/05/2015 -->

<!--    Description  - Test Class for Detail view of Recent activity -->*/


@isTest
private class RecentActivityDetail_CSSControllerTest {
    
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
        
        private static SAPBookingIDAgentMapping_del__c objSapBooking(user u){
            SAPBookingIDAgentMapping_del__c objSAPBookingIDAgentMapping_del = new SAPBookingIDAgentMapping_del__c();
            objSAPBookingIDAgentMapping_del.Booking_ID__c='BK144521'; 
            objSAPBookingIDAgentMapping_del.Agent_Name__c=u.id;
            objSAPBookingIDAgentMapping_del.Wing__c='A';
            objSAPBookingIDAgentMapping_del.Project_Name__c='XYZ';
            objSAPBookingIDAgentMapping_del.Flat_No__c='4';
            return objSAPBookingIDAgentMapping_del;
        } 
        
        
        static testMethod void recentActivityDetail_CSSWithNoCaseTest() {
      
            // creating user
            Account objAccount1 = RecentActivityDetail_CSSControllerTest.createAccount();
            insert objAccount1;
            
            
            User objUser=RecentActivityDetail_CSSControllerTest.createUser(objAccount1);
            insert objUser;
            
            List<Case> lstCase1 = new List<Case>();
            Map<Integer,Case> caseMap = new Map<Integer,Case>();
        
            system.runAS(objUser){
                RecentActivityDetail_CSSController objRecentActivityDetail_CSSController = new RecentActivityDetail_CSSController();
                objRecentActivityDetail_CSSController.Customer_CRN = objAccount1.CRN__c;
                objRecentActivityDetail_CSSController.caseList = Null; 
               
                objRecentActivityDetail_CSSController.caseMap = Null;
                objRecentActivityDetail_CSSController.sortDir='ASC';
                objRecentActivityDetail_CSSController.sortField='CreatedDate';
                
                Test.startTest();
                
                System.assertEquals(10,objRecentActivityDetail_CSSController.caseList.size());
                System.assertEquals(0,objRecentActivityDetail_CSSController.caseMap.size());
                objRecentActivityDetail_CSSController.toggleSortSMS();
               
                objRecentActivityDetail_CSSController.FirstPage();
                System.assertEquals(0,objRecentActivityDetail_CSSController.OffsetSize);
                
                objRecentActivityDetail_CSSController.previous();
                System.assertEquals(-10,objRecentActivityDetail_CSSController.OffsetSize);
                
                objRecentActivityDetail_CSSController.next();
                System.assertEquals(0,objRecentActivityDetail_CSSController.OffsetSize);
                
                objRecentActivityDetail_CSSController.LastPage();
                System.assertEquals(-10,objRecentActivityDetail_CSSController.OffsetSize);
                 
                System.assertEquals(false,objRecentActivityDetail_CSSController.getprev());
                System.assertEquals(true,objRecentActivityDetail_CSSController.getnxt());
                
                Test.stopTest();
            }
    }
    
    static testMethod void recentActivityDetail_CSSWithCasesTest() 
    {
      
        // creating user
        Account objAccount1 = RecentActivityDetail_CSSControllerTest.createAccount();
        insert objAccount1;
       
        User objUser=RecentActivityDetail_CSSControllerTest.createUser(objAccount1);
        insert objUser;
        
        SAPBookingIDAgentMapping_del__c objSAPBookingIDAgentMapping_del = objSapBooking(objUser);
        insert objSAPBookingIDAgentMapping_del;
        
        system.runAS(objUser){
            Map<Integer,Case> caseMap = new Map<Integer,Case>(); 
           
            List<Case> lstCase = new List<Case>();
            for(Integer i = 0; i < 11; i++){
                    Case objCase = new Case();
                    objCase.AccountId = objAccount1.Id;
                    objCase.Project__c='XY';
                    objCase.Buildings_Name__c='z';
                    objCase.Wing__c='A';
                    objCase.Flat_No__c = '4';
                    objCase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Other Cases').getRecordTypeId();
                    objCase.Status='New';
                    caseMap.put(i,objCase);
                    lstCase.add(objCase);
                }
                insert lstCase;
            
            RecentActivityDetail_CSSController objRecentActivityDetail_CSSController = new RecentActivityDetail_CSSController();
            objRecentActivityDetail_CSSController.Customer_CRN = objAccount1.CRN__c;
            objRecentActivityDetail_CSSController.caseList=lstCase;
            objRecentActivityDetail_CSSController.caseMap =caseMap;
            objRecentActivityDetail_CSSController.sortDir='ASC';
            objRecentActivityDetail_CSSController.sortField='CreatedDate';
            
            Test.startTest();
            System.assertEquals(10,objRecentActivityDetail_CSSController.caseList.size());
            objRecentActivityDetail_CSSController.toggleSortSMS();
            System.assertEquals(11,objRecentActivityDetail_CSSController.caseMap.size());
            
            objRecentActivityDetail_CSSController.FirstPage();
            System.assertEquals(0,objRecentActivityDetail_CSSController.OffsetSize);
            
            objRecentActivityDetail_CSSController.previous();
            System.assertEquals(-10,objRecentActivityDetail_CSSController.OffsetSize);
            
            objRecentActivityDetail_CSSController.next();
            System.assertEquals(0,objRecentActivityDetail_CSSController.OffsetSize);
            
            objRecentActivityDetail_CSSController.LastPage();
            System.assertEquals(10,objRecentActivityDetail_CSSController.OffsetSize);
             
            System.assertEquals(false,objRecentActivityDetail_CSSController.getprev());
            System.assertEquals(true,objRecentActivityDetail_CSSController.getnxt());
            
            Test.stopTest();
        }
        
    }
}