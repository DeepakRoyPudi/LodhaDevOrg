/**********************************************************************************
Name:  LoyaltyInfoUtilities
Copyright © 2012  Lodha Group
===================================================================================
===================================================================================
Purpose:
-------
utilities for Loyalty Info page
===================================================================================
===================================================================================
History
-------
VERSION    AUTHOR                DATE             DETAIL              
1.0 -   CG Dev Team          25/06/2012      INITIAL DEVELOPMENT
**********************************************************************************/

public class LoyaltyInfoUtilities {


        public static list<LoyaltyReferral> getReferrals(){
            list<LoyaltyReferral> lstAllReferrals = new list<LoyaltyReferral>();
            
            try{
                ID accid = [Select id, Accountid from User where id = :UserInfo.getUserId()].accountid;
                
                    Id LoyaltyId= [Select a.Loyalty_Details__c From Account a where Id=:accid].Loyalty_Details__c;  
                    
                    list<ReferralDetails__c> lstReferrals= new list<ReferralDetails__c>();
                    if(LoyaltyId!=null){
                        
                        lstReferrals= [Select r.Project_Name__c, r.Opportunity_Phone__c, r.Account_Name__c, r.Status__c, r.Opportunity__c, r.Opportunity__r.Name, r.Loyalty_Detail__r.Loyalty_Id__c ,r.Lead__r.FirstName, r.Lead__r.LastName, r.Lead__r.Name, r.Lead__r.Mobile__c, r.Lead__r.Project_Name__r.Name, r.Lead__r.Country_O__c  From ReferralDetails__c r where r.Loyalty_Detail__c=:LoyaltyId];
                        
                        for(ReferralDetails__c aReferral : lstReferrals){

                            lstAllReferrals.add( new LoyaltyReferral(aReferral));
                            
                        }
                    }
                
            }
            catch(Exception ex){
                system.debug('LoyaltyInfoUtilities:getReferrals'+ex.getMessage());
                throw ex;
            }
             
            return lstAllReferrals;
        }
        
        
        public static list<LoyaltyDetails> getLoyaltyDetails(){
            
            list<LoyaltyDetails> lstLoyalty = new list<LoyaltyDetails>();
            
            try{
                
                ID accid = [Select id, Accountid from User where id = :UserInfo.getUserId()].accountid;
                
                Id LoyaltyId= [Select a.Loyalty_Details__c From Account a where Id=:accid].Loyalty_Details__c;      
                
                list<Loyalty_Detail__c> allLoyalty= [Select Id, loyalty_Id__c, Current_casa_ladder__c,Total_preferati_points__c, Total_number_of_referrals__c  From Loyalty_Detail__c where Id =:LoyaltyId];
                
                for(Loyalty_Detail__c aLoyalty: allLoyalty){                
                        lstLoyalty.add( new LoyaltyDetails(aLoyalty));                  
                }
            
            }
            catch(Exception ex){
                system.debug('LoyaltyInfoUtilities:getLoyaltyDetails'+ex.getMessage());
                throw ex;
            }
            return lstLoyalty;
        }
        
        
        /******************************************** TEST METHODS **********************************************/
        
        @istest(seeAlldata=false)
        
        private static void testLoyaltyInfoUtilities(){
            
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
                            Loyalty_Details__c = testLoyalty.Id
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
                    testReferrallst = LoyaltyInfoUtilities.getReferrals();
                    testlstLoyalty = LoyaltyInfoUtilities.getLoyaltyDetails();
                test.stopTest();
            }

            system.assertEquals(testReferrallst.size(),1);
        }
}