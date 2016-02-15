/*
*    Description :   TestClass for ProfileInformation 
*                    
*
*    Version                Author                Date                Description
*
*    1.0                 Deepak Pudi(Eternus)    25/09/2014          Initial Draft
*/

@istest(seeAllData=False)
public with sharing class ProfileInformationTest {
	static testmethod void profileInformation(){
	    Attachment_BTR_Profilelist__c objBTRProfile = New Attachment_BTR_Profilelist__c ();
	    objBTRProfile.Name = 'SA';
	    objBTRProfile.Profile_Name__c = 'System Administrator';
	    insert objBTRProfile;
	    
	    //ProfileInformation  objProfileInformation = new ProfileInformation ();
	    ProfileInformation.ProfileAccess();
	    System.assertEquals('System Administrator', [Select Id ,Profile_Name__c  from Attachment_BTR_Profilelist__c Where Name = 'SA'].Profile_Name__c);
	}
}