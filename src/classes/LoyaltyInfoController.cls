/**********************************************************************************
Name:  LoyaltyInfoController
Copyright © 2012  Lodha Group
===================================================================================
===================================================================================
Purpose:
-------
Controller For Loyalty Info page 
===================================================================================
===================================================================================
History
-------
VERSION    AUTHOR                DATE             DETAIL              
1.0 -   CG Dev Team          25/06/2012      INITIAL DEVELOPMENT
**********************************************************************************/


global with sharing class LoyaltyInfoController {
    
    public String tempSessionId{get;set;}    
    public transient list<LoyaltyReferral> allReferrals {get; set;}
    public transient list<LoyaltyDetails> allLoyaltyDetails {get; set;}
    public static string tabId {get; set;}
    
    public string url{get; set;}
    public string action_param{get; set;}
    public string button{get; set;}
    
 
    public  LoyaltyInfoController(){
        try{
            tempSessionId = UserInfo.getSessionId();
            //Load the Loyalty and lead referral list
            getAllReferrals();
            getLoyaltyDetails();        
            tabId=ApexPages.currentPage().getParameters().get('sfdc.tabName') ;  
            
        } catch(Exception ex){
            system.debug('Error on Lodaing LoyaltyInfo Constructor'+ex.getmessage());
        }
        
    }
    
       
    private void getLoyaltyDetails(){
        
            allLoyaltyDetails= LoyaltyInfoUtilities.getLoyaltyDetails();
        
    } 
    
    private void getAllReferrals(){
    
            allReferrals= LoyaltyInfoUtilities.getReferrals();      
        
    }


    @RemoteAction
    global static void activityTracker(String url, String action, String button_name){
      System.debug('@@ Action == '+action+'@@ button Name ='+button_name);  
      SessionTrackController.addsessiondetails(url, action, button_name);
    }
    
    public void referTracker()
    {
       System.debug('@@ Action == '+action_param+'@@ button Name ='+button);
       SessionTrackController.addsessiondetails(url, action_param, button);
    }
    
    
    
    @istest(seeAlldata=false)
    private static void testactivityTracker(){
       test.startTest();
       LoyaltyInfoController.activityTracker('https://cs8.salesforce.com' , 'Button click', 'Refer a Friend');
       test.stopTest();
    }
    
    @istest(seeAlldata=false)
        
        private static void testLoyaltyInfoController(){
            
            //test data
            //Create test data
            Lead testLead = new Lead();
            testLead.FirstName = 'firstName';
            testLead.LastName ='lastName';
            testLead.Mobile__c = '9191919191';      
            testLead.LeadSource = 'Referral';
            testLead.Country_O__c = 'India';
            testLead.ISD_Code__c ='0091';   
            insert testLead;
            Loyalty_Detail__c testLoyalty= new Loyalty_Detail__c();
            testLoyalty.Name ='test';
            testLoyalty.Loyalty_Id__c = 'testLoyalty';
            insert testLoyalty;
            
            Id ProfileId=[Select Id, Name, UserLicense.LicenseDefinitionKey From Profile Where Name = 'Custom Overage High Volume Customer Portal'].Id;
            
            id RTId = [Select id from RecordType where Name = 'Booked Account'].id;
            Account lAccount = new Account(FirstName = 'testFirstacc',
                            LastNAme = 'testLastacc',
                            Recordtypeid = RTId,
                            Status__c = 'Created',
                            PersonMobilePhone = '9324567888',
                            PersonEmail = 'ltest@test.com',
                            CRN__c = '898980',
                            Personal_Email__pc = 'ltest@test.com',
                            Loyalty_Details__c = testLoyalty.Id,
                            LoyaltyID__c = 'testLoyalty'
                            );
            insert lAccount;
        
            Id lContact = [Select id  from Contact where Accountid =: lAccount.Id].Id;
             
            User testUser= new User(Alias='TESTUSER',Email='TEST.USER@TEST.TEST',
                    EmailEncodingKey='UTF-8',FirstName='First_TEST',LastName='TEST_LAST_NAME', LanguageLocaleKey='en_US',
                    LocaleSidKey='en_GB',ProfileId=ProfileId, timezonesidkey='Europe/London',Title='TEST TITLE',
                    username='TEST.USER@TEST.TEST', contactid=lContact);
            insert testUser;        
            
            id testLoyaltyId = testLoyalty.Id;
            
            ReferralDetails__c testReferral= new ReferralDetails__c();                  
            testReferral.Loyalty_Detail__c = testLoyalty.Id ;
            testReferral.Lead__c = testLead.Id;
            testReferral.Status__c = 'Lead Created'; 
            insert testReferral;        
            
            //Case 1:
            list<LoyaltyReferral> testReferrallst = new list<LoyaltyReferral>();
            
            //Case 2:
            list<LoyaltyDetails> testlstLoyalty = new list<LoyaltyDetails>();
            system.runAs(testUser){
                test.startTest();        
                    LoyaltyInfoController LIC = new LoyaltyInfoController();
                test.stopTest();
            }

        }
}