@istest
public with sharing class UserTriggerTest {
	
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
	  public static WidgetInfo__c CreateWidInfo(){
	   list<WidgetInfo__c> widgetinfolist = new list<WidgetInfo__c>();
       	  WidgetInfo__c w= new WidgetInfo__c();
       	  w.Name= 'testWidget';
       	  w.Available_For__c='RM';
       	 
       	  
       	  /*WidgetInfo__c w1= new WidgetInfo__c();
       	  w1.Name= 'testWidget1';
       	  w1.Available_For__c='RM';
       	  widgetinfolist.add(w1);
       	  insert widgetinfolist;*/
		  return w;
	}
	public static Widget_Sequence__c CreateWidseq(user u,WidgetInfo__c w){
		Widget_Sequence__c wseq = new Widget_Sequence__c();
			 wseq.User__c=u.Id;
			 wseq.Sequence_ClickCount__c=0;
			 wseq.WidgetInfo__c=w.id; 
			 wseq.RecordTypeId=Schema.SObjectType.Widget_Sequence__c.getRecordTypeInfosByName().get('Dynamic').getRecordTypeId();
		return wseq;
	}
	 public static testMethod void UserTriggerTestInfo(){
		//Creating Account
		Account acc=UserTriggerTest.createAccount();
		insert acc;
		 system.debug('**acc**'+acc);
		
		//creating WidgetInfo
		WidgetInfo__c WidInf= UserTriggerTest.CreateWidInfo();
		insert WidInf;
		
		//creating user
		User user = UserTriggerTest.createUser(acc);
		insert user;
		
		system.debug('**user**'+user);
		
	 Test.startTest();
		
		system.debug('**user.Id**'+user.Id);
		
			Widget_Sequence__c wse = UserTriggerTest.CreateWidseq(user,WidInf);
			insert wse;
		 Widget_Sequence__c ws=[select User__c,
				 						Sequence_ClickCount__c,
				 						WidgetInfo__c,
				 						RecordTypeId 
				 				from Widget_Sequence__c 
				 				where  User__r.Id =: user.Id limit 1];
		 system.debug('**WS**'+ws);
		 system.assertEquals(ws.User__c, user.Id);  
		 system.assertEquals(ws.Sequence_ClickCount__c, 0);
		 system.assertEquals(ws.WidgetInfo__c,WidInf.Id);
		 system.assertEquals(ws.RecordTypeId, Schema.SObjectType.Widget_Sequence__c.getRecordTypeInfosByName().get('Dynamic').getRecordTypeId());
	 Test.stopTest();
		
	 }
	 public static testMethod void CreateMultipleRecs(){
	 	
	 	
	 	Account acc1=UserTriggerTest.createAccount();
		insert acc1;
	 	
	 	User user1 = UserTriggerTest.createUser(acc1);
		insert user1;
		system.debug('**user1**'+user1);
		
		WidgetInfo__c WidInf1= UserTriggerTest.CreateWidInfo();
		insert WidInf1;
		
	 	list<Widget_Sequence__c> widsequence = new list<Widget_Sequence__c>();
	 	Widget_Sequence__c wsrecs = new Widget_Sequence__c();{
	 	
	 		 wsrecs.User__c=user1.Id;
			 wsrecs.Sequence_ClickCount__c=0;
			 wsrecs.WidgetInfo__c=WidInf1.id; 
			 wsrecs.RecordTypeId=Schema.SObjectType.Widget_Sequence__c.getRecordTypeInfosByName().get('Dynamic').getRecordTypeId();
			 widsequence.add(wsrecs);
	 	}
	 	Widget_Sequence__c wsrecs1 = new Widget_Sequence__c();{
	 		 wsrecs1.User__c=user1.Id;
			 wsrecs1.Sequence_ClickCount__c=0;
			 wsrecs1.WidgetInfo__c=WidInf1.id; 
			 wsrecs1.RecordTypeId=Schema.SObjectType.Widget_Sequence__c.getRecordTypeInfosByName().get('Dynamic').getRecordTypeId();
			 widsequence.add(wsrecs1);
	 	}
	 	insert widsequence;
	 }
	
}