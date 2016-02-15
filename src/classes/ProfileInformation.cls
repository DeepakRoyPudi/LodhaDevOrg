/**********************************************************************************
Name:  ProfileInformation 
Copyright © 2013  Lodha Group
===================================================================================
===================================================================================
Purpose:
-------
Custom Settings for all the Profiles  
===================================================================================
===================================================================================
History
-------
VERSION    AUTHOR                DATE             DETAIL      
1.2 -   Deepak pudi          09/16/2014      INITIAL DEVELOPMENT
**********************************************************************************/

public with sharing class ProfileInformation {
   
     public static Map<Id, Profile> ProfileAccess() {
        Map<String,Attachment_BTR_Profilelist__c> allProfiles = Attachment_BTR_Profilelist__c.getAll();
        Set<String> setProfileName = new Set<String>();
		 
        for(Attachment_BTR_Profilelist__c BTR:allProfiles.values() ){
        setProfileName.add(BTR.Profile_Name__c) ;
	   	 }
	    System.debug('@@##@@##'+setProfileName);
        Map<Id, Profile> mapProfile = new Map<Id, Profile>([Select id,name from Profile  Where Name IN: setProfileName]);
		
       return mapProfile; 
		                                               
 } 
   
/* public static list<Profile> ProfileNoAccess(){
 set<string> setNoAccessProfileName = new set<String> ([Select id,name from Profile  Where Name IN: setProfileName]);
 list<Profile> listProfileNo = [select id, name from Profile where Name IN :  setNoAccessProfileName ];
 return listProfileNo;
 } */
  
}