/*@Created by: Deepak Pudi 
     @Created Date:   6/5/2015  --
 
 <!-- ------------------------------------------------------------------------------
 | Modified By      | Modified Date       | Version        | Description         |
 --------------------------------------------------------------------------------
  |Deepak Pudi            27/5/2015              1.1         Changes for code to improve code coverage
 --------------------------------------------------------------------------------
 |
 ------------------------------------------------------------------------------ -->*/
@isTest
public with sharing class projectNameTriggerTest {
    public static testMethod void  projectname(){
        Account acc=projectNameTriggerTest.createAccount();
        insert acc;
        
        user user = projectNameTriggerTest.createUser(acc);
        insert user;
        
         map < string, integer > CustomSequenceMap = new map < string, integer > (); 
         CustomSequenceMap=null;
         
        //ProjectNametrigger Pnametrigger = new ProjectNametrigger();
        //Pnametrigger.map1 = CustomSequenceMap;
        WidgetInfo__c widInfo =projectNameTriggerTest.CreateRmWidInfo();
        insert widInfo;
        
        WidgetInfo__c widInfo1 =projectNameTriggerTest.CreateCSSWidInfo();
        insert widInfo1;

        WidgetInfo__c widInfo2 =projectNameTriggerTest.CreateBothWidInfo();
        insert widInfo2;
        
        Project_Name__c PNmae =projectNameTriggerTest.createProject();
        insert PNmae;
    }
    public static testMethod void  projectname1(){
    
        Account acc=projectNameTriggerTest.createAccount();
        insert acc;
        
        user user = projectNameTriggerTest.createUser(acc);
        insert user;
        
         
    }
    
    private static Account createAccount(){
        Account objAccount = new Account();
        objAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Booked Account').getRecordTypeId();
        objAccount.FirstName = 'Test1';
        objAccount.LastName = 'Account1';
        objAccount.CRN__c = '154215';
        objAccount.H_Mobile_No__c = '1234560789';
        objAccount.Mobile_Phone__c = '21241222';
        objAccount.Co_Applicant__c = 'test';
        return objAccount;
      }
      private static Project_Name__c createProject(){
        Project_Name__c projectname = new Project_Name__c();
        projectname.Name='TestProject';
        projectname.Project_Type__c='Aspirational';
        projectname.Record_Type__c='Residential';
        projectname.CurrencyIsoCode='INR';
        return projectname;
      }
      
        private static User createUser(Account a)
       {
       list<profile> pf = [Select Id From Profile Where Name = 'Custom Overage High Volume Customer Portal' limit 1];
       system.debug('**pf**'+pf);
        
        
        User objUser = new User();
        contact c=[select id from contact where accountid=:a.id limit 1];
       /* objUser.ProfileID = [Select Id From Profile Where Name = 'Custom Overage High Volume Customer Portal'].id;*/
         objUser.ProfileID = pf[0].id;
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
        //objUser.AccountId=a.id;

        return objUser;
        
      }  
      
       public static WidgetInfo__c CreateRmWidInfo(){
       list<WidgetInfo__c> widgetinfolist = new list<WidgetInfo__c>();
          WidgetInfo__c w= new WidgetInfo__c();
          w.Name= 'testWidget';
          w.Available_For__c='RM';                
              return w;
    }
    
     public static WidgetInfo__c CreateCSSWidInfo(){
       list<WidgetInfo__c> widgetinfolist = new list<WidgetInfo__c>();
          WidgetInfo__c w= new WidgetInfo__c();
          w.Name= 'testWidget1';
          w.Available_For__c='CSS';               
              return w;
    }
    
     public static WidgetInfo__c CreateBothWidInfo(){
       list<WidgetInfo__c> widgetinfolist = new list<WidgetInfo__c>();
          WidgetInfo__c w= new WidgetInfo__c();
          w.Name= 'testWidget2';
          w.Available_For__c='Both';              
              return w;
    }
    
    public static testMethod void  CreateWidseq(){
        
        
        Account acc1=projectNameTriggerTest.createAccount();
        insert acc1;
        
        Project_Name__c PNmae1 =projectNameTriggerTest.createProject();
        insert PNmae1;
        
        user user1 = projectNameTriggerTest.createUser(acc1);
        insert user1;
        
        WidgetInfo__c widInfo5 =projectNameTriggerTest.CreateBothWidInfo();
        insert widInfo5;
        
        Widget_Sequence__c Wseq = new Widget_Sequence__c();
            Wseq.Project_Name__c=PNmae1.id;
            Wseq.Sequence_ClickCount__c=0;
            Wseq.Sequence_for__c='RM';
            Wseq.User__c=user1.id;
            Wseq.WidgetInfo__c=widInfo5.id;
            insert Wseq;
            
        
        
    }
      
 
}