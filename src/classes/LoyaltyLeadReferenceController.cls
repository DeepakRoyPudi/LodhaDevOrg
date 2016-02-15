/**********************************************************************************
Name:  LoyaltyLeadReferenceController
Copyright © 2012  Lodha Group
===================================================================================
===================================================================================
Purpose:
-------
This is controller for Loyalty referral page
===================================================================================
===================================================================================
History
-------
VERSION    AUTHOR                DATE             DETAIL              
1.0 -   CG Dev Team          25/06/2012      INITIAL DEVELOPMENT
**********************************************************************************/

global with sharing class LoyaltyLeadReferenceController {
    
    public LoyaltyLead referLead {get; set;}
    public String country {get;set;}
    public static string tabId {get; set;}
    public string url{get; set;}
    public string action_param{get; set;}
    public string button{get; set;}

    public LoyaltyLeadReferenceController(){
                referLead=new LoyaltyLead();
        this.referLead.country='India'; 
        try{
                tabId=ApexPages.currentPage().getParameters().get('sfdc.tabName') ;  
        } catch(Exception ex){
                
        }
    }

    //populate the project list
    
    public list<selectOption> getProjects(){
        
        
                List<SelectOption> projectLst = new List<SelectOption>();
                
            Map<Id,project_name__c> projectlistmap= new Map<Id,project_name__c>([select id,Name,Record_Type__c,Project_Type__c from Project_name__c
            
            where name!='Lodha Bellezza' AND name!='Unknown Project' AND name!='Generic' AND Isactive__c=true order by Name]);    
  
           projectLst.add(new SelectOption('Select Project','Select Project'));
                for(project_name__c project:projectlistmap.values()){     
              projectLst.add(new SelectOption(project.Id,project.Name));
           }       
           return projectLst;
        
    }
    
    
    public pagereference insertLead(){
        
        //get the Current User Loyalty Id and update in Lead referral       
        try {
                ID accid = [Select id, Accountid from User where id = :UserInfo.getUserId()].accountid;
        
                ID loyaltyId = [Select id,Loyalty_Details__r.Id from Account where id = :accid LIMIT 1 ].Loyalty_Details__r.Id;
                system.debug('Test'+loyaltyId+ 'input data'+referLead);
                if(loyaltyId!=null) {
                     referLead.loyaltyId = loyaltyId;
                }
                Boolean status = LoyaltyLeadUtilities.insertLead(referLead);
        }
        catch(exception ex){
            
            system.debug('Test Result'+ex.getmessage());
            
        }
        
        return null;
    }
    
    @RemoteAction
    global static void referingTracker(String url, String action, String button_name){
      System.debug('@@ Action == '+action+'@@ button Name ='+button_name);
      SessionTrackController.addsessiondetails(url, action, button_name);
    }
    
    public void referTracker()
    {
       System.debug('@@ Action == '+action_param+'@@ button Name ='+button);
       SessionTrackController.addsessiondetails(url, action_param, button);
    }
    
    /******************************* TEST METHODS *************************************/
    
    @istest(seeAlldata=false)
    private static void test_referingTracker(){
       test.startTest();
       LoyaltyLeadReferenceController.referingTracker('https://cs8.salesforce.com' , 'Refer a Friend - Submit', 'Refer a Friend - Save');
       test.stopTest();
    }
    
    @istest(seeAlldata=false)
    
    private static void test_getProjects(){
         //test data
         Project_name__c[] pjts1= new  Project_name__c[] 
                  {
                   new Project_name__c(Name='test1'),  new Project_name__c(Name='test2')
                  };
                  Insert pjts1;
                  list<selectOption> testProjectlst= new list<selectOption>();
                  
                  test.startTest();
                          //Case 1:
                          LoyaltyLeadReferenceController testCase1 = new LoyaltyLeadReferenceController();
                          testProjectlst = testCase1.getProjects();
                  test.stopTest();
                  
                //case 1: Assert
                
                system.assertEquals(testProjectlst.size(),3);
                
    }
    
    @istest(seeAlldata=false)
    
    private static void test_insertLead(){
        //Test Data
        LoyaltyLead testCase1Lead = new LoyaltyLead();
                testCase1Lead.Country ='India';
                testCase1Lead.countryCode='0091';
                testCase1Lead.Mobile='9191919191';
                testCase1Lead.firstName = 'TestUser first';
                testCase1Lead.LastName = 'TestUser last';
                
                test.startTest();
                        //case 1:
                         LoyaltyLeadReferenceController testCase1 = new LoyaltyLeadReferenceController();
                         testCase1.referLead = testCase1Lead;
                         testCase1.insertLead();
                test.stopTest();
                system.assertEquals(testCase1.referLead.firstName,testCase1Lead.firstName);
        
    }
    

}