/**********************************************************************************
Name:  LoyaltyLeadUtilities
Copyright © 2012  Lodha Group
===================================================================================
===================================================================================
Purpose:
-------
utilities for Loyalty Referral page
===================================================================================
===================================================================================
History
-------
VERSION    AUTHOR                DATE             DETAIL              
1.0 -   CG Dev Team          25/06/2012      INITIAL DEVELOPMENT
**********************************************************************************/

public with sharing class LoyaltyLeadUtilities {
	
	
	public static boolean insertLead(LoyaltyLead aNewLead){
		Boolean isSuccess = false;		
		Lead aLead = new Lead();			
		if(aNewLead!=null){				
			aLead.FirstName = aNewLead.firstName;
			aLead.LastName = aNewLead.lastName;
			aLead.Mobile__c = aNewLead.Mobile;
			aLead.Project_Name__c = aNewLead.projectId;
			aLead.LeadSource = 'Referral';
			aLead.Country_O__c = aNewLead.Country;
			aLead.ISD_Code__c =aNewLead.CountryCode;	
			system.debug('HHHH'+aLead);		
			insert aLead;
			isSuccess= LodhaReferralDetailsUtilities.insertLeadReferralDetails(aLead.Id, aNewLead.LoyaltyId);	
		}
		
		return isSuccess;
	}
	
	
	@istest(seeAlldata=false)
	private static void test_inserLead(){
		//Create test data
		LoyaltyLead testCase1Lead = new LoyaltyLead();
		testCase1Lead.Country ='India';
		testCase1Lead.countryCode='0091';
		testCase1Lead.Mobile='9191919191';
		testCase1Lead.firstName = 'TestUser first';
		testCase1Lead.LastName = 'TestUser last';
		
		//Case 1:
		Boolean case1Lead = false;
		test.startTest();
			case1Lead= LoyaltyLeadUtilities.insertLead(testCase1Lead);
		test.stopTest();
		
		//Assert:
		system.assertEquals(case1Lead, true);	
		
	}
	
}