@isTest
private class Test_CallRatingUpdaterBatch {

    	static testMethod void testCallRatingUpdate() {
 
		Project_Name__c pn1=new Project_Name__c(name='Lodha Aria');
    	Project_Name__c pn2=new Project_Name__c(name='Lodha Primero');
    	Project_Name__c pn3=new Project_Name__c(name='Lodha Bellissimo');
    	list <Project_Name__c> lstPN = new list <Project_Name__c> ();
		lstPN.add(pn1);
		lstPN.add(pn2);
		lstPN.add(pn3);
		insert lstPN;	
		
		Account acc = new account(Name='test');
    	insert acc;

		Opportunity o = new Opportunity(Name = 'Test Opp', AccountId = acc.Id, CloseDate = System.Today(), Project_Name__c = pn3.id, StageName = 'Open', No_Show__c = True);
		insert o;
	    
		Call_Attempts__c ca3 = new Call_Attempts__c (Opportunity__c = o.Id, Project_Name__c = pn3.id, Project_Interested__c='Lodha Primero', Mobile__c='1983675486', Attempted_By__c='CEO', Call_Attempted_by__c='test', Call_Attempt_Status__c='Visit Done', Call_Type__c='Outbound');
		insert ca3;
		
		Call_Attempts__c ca4 = new Call_Attempts__c (Opportunity__c = o.Id, Project_Name__c = pn3.id, Project_Interested__c='Lodha Primero', Mobile__c='1983675486', Attempted_By__c='CEO', Call_Attempted_by__c='test', Call_Attempt_Status__c='Lost', Call_Type__c='Outbound');
		insert ca4;

		Test.StartTest();
        	CallRatingUpdaterBatch obj = new CallRatingUpdaterBatch();
        	obj.queryOpp = 'select o.Id, o.Call_Rating__c, o.Last_Call_Date_New__c, o.Follow_Up_Date_New__c , o.Call_Proposed_Date_of_Visit_New__c, o.Last_Call_Description_New__c, o.Last_Call_Attempted_by_New__c, o.Last_Attempted_By_New__c, o.Last_Call_Attempt_Status_New__c, (Select Id, Name, Call_Attempt_Status__c, Attempted_By__c, Call_Attempted_by__c, Call_Date__c, Description__c, Proposed_Date_of_Visit__c , Next_Action_Date__c From R00NR0000000VhoWMAS__r order by CreatedDate desc) From Opportunity o LIMIT 100';
			ID batchId = Database.executeBatch(obj);
		Test.StopTest();
      }
}