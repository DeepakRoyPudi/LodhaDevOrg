/*
*    Description : Test Class for SchedulerBatchCountCommunicationPoint
*
*    Version                    Date                    Author                        Description
*    1.0                        12/08/2014              Anupam Agrawal            	Initial Draft
*/


@isTest
private class BatchCountCommunicationPointTest 
{
    static testMethod void myUnitTest() 
    {
    	
    	
    	Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    	List<Account> lstAccount = new List<Account>();
    	for(Integer i=0 ; i< 200; i++)
    	{
	        Account objAcc = new Account();
	        objAcc.RecordTypeId = recordTypeId;
	        objAcc.LastName = 'Test Account Rec';
	        objAcc.Mobile_Phone__c = '9111111111';
	        objAcc.Possession_Type__c = 'Ready to Move In';
	        objAcc.Type_of_Accommodation_Required__c = '3 BHK';
	        lstAccount.add(objAcc);
    	}
        insert lstAccount;
        
        List<Opportunity> lstOpportunity = new List<Opportunity>();
        for(Integer i=0 ; i<100; i++)
    	{
	        Opportunity oOpp = new Opportunity();
	        oOpp.Name = 'Test Opporunity Trigger' + i;
	        oOpp.StageName = 'Qualification';
	        oOpp.Servicing_Team__c = 'Presales';
	        oOpp.Expected_Close_Date__c = System.today();
	        oOpp.CloseDate = System.today();
	        oOpp.Possession_desired_in__c = 'Ready to Move In';
	        oOpp.Type_of_Accomodation__c = '5 BHK';
	        oOpp.AccountId = lstAccount[0].Id;
	        oOpp.IsActive__c = true;
	        lstOpportunity.add(oOPP);
	        
	        Opportunity objOpp = new Opportunity();
	        objOpp.Name = 'Test Opporunity Trigger ' + i;
	        objOpp.StageName = 'Qualification';
	        objOpp.Servicing_Team__c = 'Presales';
	        objOpp.Expected_Close_Date__c = System.today();
	        objOpp.CloseDate = System.today();
	        objOpp.Possession_desired_in__c = 'Ready to Move In';
	        objOpp.Type_of_Accomodation__c = '5 BHK';
	        objOpp.AccountId = lstAccount[0].Id;
	        objOpp.IsActive__c = true;
        	lstOpportunity.add(objOpp);
    	}
    	insert lstOpportunity;
    	
    	Project_Name__c objProjectName = new Project_Name__c();
        objProjectName.Name = 'Test Project';
        objProjectName.Project_Type__c = 'Test';
        objProjectName.Record_Type__c = 'Test Record type';
        objProjectName.CRN_INIT__c = 'abc';
        insert objProjectName;
    	
    	List<Call_Attempts__c> lstCA = new List<Call_Attempts__c>();
    	for(Integer i=0 ; i< 2; i++)
    	{
    	    	
    		Call_Attempts__c objCA = new Call_Attempts__c();
    		objCA.Project_name__c = objProjectName.Id;
    		objCA.Call_Type__c = 'Email';
    		objCA.Call_Attempt_Status__c = 'Done';
    		objCA.Attempted_By__c = 'Sales';
    		objCA.Call_Attempted_by__c = 'Amit Koli';
    		objCA.Opportunity__c = lstOpportunity[i].Id;
    		lstCA.add(objCA);
    		
    		Call_Attempts__c objCA1 = new Call_Attempts__c();
    		objCA1.Project_name__c = objProjectName.Id;
    		objCA1.Call_Type__c = 'Email';
    		objCA1.Call_Attempt_Status__c = 'Done';
    		objCA1.Attempted_By__c = 'Sales';
    		objCA1.Call_Attempted_by__c = 'Amit Koli';
            objCA1.Opportunity__c = lstOpportunity[i].Id;
    		lstCA.add(objCA1);
    	}
        
        insert lstCA;
        
        Test.startTest();
        SchedulerBatchCountCommunicationPoint objSchedule = new SchedulerBatchCountCommunicationPoint();
        SchedulableContext sc;
       	objSchedule.execute(sc);
       	Test.stopTest();
       	
        System.assertEquals([Select communication_points_in_a_last_6_month__c from account where Id=:lstAccount[0].Id].communication_points_in_a_last_6_month__c,4);
    }
}