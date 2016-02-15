/*********************************************************************************
Name:  updateExternalProjectNameFiled()
Copyright © 2012  Lodha Group
======================================================
======================================================
Purpose:
-------
To updateExternalProjectNameFiled
======================================================
======================================================
History
-------
VERSION    AUTHOR                DATE             DETAIL              
1.0 -   CG Dev Team          10/02/2012      INITIAL DEVELOPMENT  
*********************************************************************************/ 


trigger updateExternalProjectNameField on Project_Name__c (before insert,before update) {

        if((trigger.isBefore && trigger.isinsert)||(trigger.isBefore && trigger.isupdate))
        {
        
                for(Project_Name__c projectname:trigger.new)
                  {
                    projectname.External_Project_Name__c=projectname.Name;
                        
                  }
        
        
        }

}