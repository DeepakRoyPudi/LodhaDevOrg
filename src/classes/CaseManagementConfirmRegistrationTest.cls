/*
*        Description : Test class Case Trigger Handler
*
*        Version     Date          Author             Description
*        1.0         19/11/2014    Anupam Agrawal     Test code.
*/

@isTest
private class CaseManagementConfirmRegistrationTest 
{
    static testMethod void myUnitTest() 
    {
    	// Insert custom setting record.
    	Trigger_Execution__c  objTriggerExecution = new Trigger_Execution__c(Name = 'CaseManagementConfirmRegistration', execute__c = true);
		insert objTriggerExecution;
    	
    	List<Holiday_Information__c> lstHolidayInformation = new List<Holiday_Information__c>();
    	
    	lstHolidayInformation.add(new Holiday_Information__c(Name='Holiday 1', Holiday_Date__c = System.today() + 2, Active__c = true));
    																
    	lstHolidayInformation.add(new Holiday_Information__c(Name='Holiday 2', Holiday_Date__c = System.today() + 7, Active__c = true));
    																
    	insert lstHolidayInformation;	
    	
    	Account objAcc = new Account();
        objAcc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        objAcc.LastName = 'Test Trigger';
        objAcc.Mobile_Phone__c = '9211111111';	
        
        insert objAcc;	
        
        List<Case> lstCase = CaseManagementConfirmRegistrationTest.getCaseRecords(20);
    	lstCase[0].AccountId = objAcc.id;
        try
        {
        	insert lstCase;
        }
        catch(Exception e)
        {
        	Boolean expectedExceptionThrown =  e.getMessage().contains('Registration Date cannot be less than') ? true : false;
			System.AssertEquals(expectedExceptionThrown, true);
        }
    	
    	CaseManagementConfirmRegistration obj = new CaseManagementConfirmRegistration();
    	DateTime registrationDate = obj.getCorrectRegistrationDate();
    	List<Case> lstCase2 = CaseManagementConfirmRegistrationTest.getCaseRecords(1);
    	lstCase2[0].AccountId = objAcc.id;
    	lstCase2[0].Date_Confirm_Time_place_of_Registratio__c = registrationDate;
    	insert lstCase2;
    	
    	try
    	{	
    		lstCase2[0].Date_Confirm_Time_place_of_Registratio__c = DateTime.now() + 1;
    		update lstCase2;
    	}
    	catch(Exception e)
    	{
    		Boolean expectedExceptionThrown =  e.getMessage().contains('Registration Date cannot be less than') ? true : false;
			System.AssertEquals(expectedExceptionThrown, true);
    	}
    	
    }
    
    // Method to create Complaint and Grievance type cases
    public static List<Case> getCaseRecords(Integer numberOfRecords){
    	
        List<Case> listOfCase = new List<Case>();
        Case objCase = new Case();
        
        for(Integer i = 0; i < numberOfRecords; i++){
            
            // Cearting Complaint type Case
            objCase = new Case();
            objCase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CM_Parent_Only').getRecordTypeId();
            objCase.Interaction_Mode__c = 'Email';
            objCase.Communication_Type__c = 'Inbound';
            objCase.Nature_of_Request__c = 'Request';
            objCase.Case_Resolution__c = 'test';
            objCase.Case_Summary__c = 'test';
            objCase.Request_for_L1__c = 'Registration Related';
            objCase.Request_for_L2__c = 'Scheduling (SDR already paid)';
            objCase.Request_for_L3_a__c = 'Reasons;L3';
            objCase.Request_for_L3__c = 'Confirm Time & place of Registration';
            objCase.Date_Confirm_Time_place_of_Registratio__c = DateTime.now() + i;
            listOfCase.add(objCase);
            
        }// end of for
        
        return listOfCase;
    }// end of getCaseRecords
}