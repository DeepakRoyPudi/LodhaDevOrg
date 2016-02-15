/*
*    Description : Apex Controller for VF Page Site_sitehome The page is set as active site home page
*                  for Customer Portal
*
*    Version            Author                    Date                Description
*
*    1.0                Anonymous                 06/11/2012          Initial Draft
*    1.1                Siddharth(Eternus)        05/08/2014          Bug Fixing and code refactoring. Encountered lot of
*                                                                     discrepancies in the code. 
*                                                                     Performed Null Checks etc.
*    2.0                Siddharth(Eternus)        16/08/2014          Code changes/development to load the home page
*                                                                     banner based on Customer's Project
*/

public without sharing class PortalUserLastLoginController {
    
    public string strProjectImageName {get; set;}
    public Account acct;
    public User u;
    
    List<Project_Name__c> listProjectName = new List<Project_Name__c>();
    
    //Constructor
    public PortalUserLastLoginController() {
        
        strProjectImageName = '';
        system.debug('user Id: '+userinfo.getUserId());
        
        Id BookedAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Booked Account').getRecordTypeId();
        
        u = [SELECT Id, 
                    Name, 
                    LastLoginDate, 
                    username 
             from User 
             Where id =: userinfo.getUserId()];
        
        acct = [SELECT Id,
                       ispersonaccount,
                       Name,
                       project_name__c,
                       Last_Login__c 
                from Account 
                Where PersonEmail =: u.username AND 
                Recordtypeid =: BookedAccountRecordTypeId];
        
        //Siddharth 1.1        
        listProjectName = [select Name,
                                  project_type__c,
                                  Project_Image_Name__c        //Siddharth 2.0
                           from project_name__c 
                           where name =: acct.project_name__c];
        
        //If Project Name is Not Empty
        if(!listProjectName.isEmpty()){
            
            //Siddharth 2.0
            //Assigning the Project Image Name to the string. String would be referenced in the relative path 
            //of the static resource to retrieve the image
            strProjectImageName = listProjectName[0].Project_Image_Name__c;
        }
    }//Constructor
    
    public void doGetPortalUserInfo() {
        
        try{
            Account acct1 = new account(id = acct.id);
            acct1.Last_Login__c = u.LastLoginDate;
            update acct1;  
        }
        catch(Exception exp){
            system.debug('Exception : '+exp);
        }
    }  
    
    //Apex Method to redirect to Customer Portal Home Page
    public PageReference redirectHome(){
        
        PageReference objPgRefHome = new PageReference(Label.CustomerPortalHomePageUrl);
        return objPgRefHome;
        //return new PageReference('/apex/InMaintenance');
    }
}