/*
*    Description: Test class for Summary report batch class handler.
*    
*    Version       Date            Name             Description
*	 1.0           07/07/2014      Asmita Bubane    Initial Draft
*    1.1           07/08/2014      Siddharth        Commented the code that sends Email
*/

@isTest(seealldata = true)
private class SummaryReportBatchHandlerTest {

    static testMethod void testSendEmail() {
        
        List<Case> listAllCase = new List<Case>();
    	
    	for(Case oCase : [select caseNumber, CreatedDate, Nature_of_Request__c, Request_for_L1__c, Request_for_L2__c, Request_for_L3_a__c, Request_for_L3__c, Status, TL_EmailId__c, Owner_EmailId__c, TL__c, PIC_EmailId__c,Remaining_Hours__c, Owner.name, createdBy.email, Date_of_Complaint__c, Date_of_Grievance__c, Interaction_Mode__c, Priority, Case_Summary__c, Case_Resolution__c, Dependency_on_Internal_functions__c,Project_Name_CM__c, account.Id from Case where parent.Id != null limit 100]){
    		listAllCase.add(oCase);
    	}
    	
    	Test.startTest();
    	    SummaryReportBatchHandler oBatchHandler = new SummaryReportBatchHandler();
    	    //Siddharth 1.1 07/08/2014
		    oBatchHandler.sendSummaryReportEmail(listAllCase, 'THE PARK');
		Test.stopTest();
    }
    
    // Method to create Account Record.
    public static List<Account> getAccountRecords(Integer pNumberOfRecords, String pStrProjName){
        
        List<Account> listAccount = new List<Account>();
        Account oAccount = new Account();
        
        // Getting Booked Account Record Type Id
        Id idBookedAccountRecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Booked Account').getRecordTypeId();
        
        for(Integer i = 0; i < pNumberOfRecords; i++){
        	
            oAccount = new Account();
            oAccount.LastName = 'testAccount';
            oAccount.Project_Name__c = pStrProjName;
            
            listAccount.add(oAccount);
        }// end of for
        
        return listAccount;
    }// end of getAccountRecords()
    
    // Creating Booking Details Record 
    public static List<Booking_Details__c> getBookingDetailRecords(Integer pNumberOfRecords){
       
        Booking_Details__c oBooking = new Booking_Details__c();
        List<Booking_Details__c> listBookingDetails = new List<Booking_Details__c>();
        
        for(Integer i = 0; i < pNumberOfRecords; i++){
            oBooking.Registration_Status__c = 'Registered';
            oBooking.CLuster__c = 'Viera';
            oBooking.Wing__c = 'A';
            oBooking.Flat_No__c = '201';
            oBooking.Application_Date__c = System.today();
            oBooking.Consideration_Value__c = 1000;
            oBooking.Flat_ID__c = '00123';
            oBooking.CRN__c = '444444';
            oBooking.Allotment_Date__c = System.today();
            
            listBookingDetails.add(oBooking);
        }       
        
        return listBookingDetails;
    }
    
    // Method to create Complaint and Grievance type cases
    public static List<Case> getCaseRecords(Integer pNumberOfRecords, String pStrCaseType){
    	
        List<Case> listOfCase = new List<Case>();
        Case oCase = new Case();
        
        for(Integer i = 0; i < pNumberOfRecords; i++){
            
            // Cearting Complaint type Case
            oCase = new Case();
            oCase.Interaction_Mode__c = 'Email';
            oCase.Communication_Type__c = 'Inbound';
            oCase.Nature_of_Request__c = pStrCaseType;
            oCase.Case_Resolution__c = 'test';
            oCase.Case_Summary__c = 'test';
            oCase.Request_for_L1__c = 'Collections Related';
            oCase.Request_for_L2__c = 'PTP';
            oCase.Request_for_L3_a__c = 'Reasons';
            oCase.Reason_for_non_payment__c = 'Approved Deviation';
            oCase.Status = 'Open';
            oCase.Priority = 'Medium';
            
            listOfCase.add(oCase);
            
        }// end of for
        
        return listOfCase;
    }
    
    // Method to create Custom setting
    public static List<CM_Tat_Calculation__c> getCustSettingRec(List<String> pListSettingName){
        
        CM_Tat_Calculation__c oSetting = new CM_Tat_Calculation__c();
        List<CM_Tat_Calculation__c> listSetting = new List<CM_Tat_Calculation__c>();
        
        for(String strSettingName : pListSettingName){
            
            oSetting = new CM_Tat_Calculation__c();
            oSetting.Name = strSettingName;
            oSetting.CaseType__c = strSettingName;
            
            listSetting.add(oSetting);
        }
        
        return listSetting;
    }
    
    // Creating custom setting for Email Ids
    public static List<CM_Reporting_EmailIds__c> getEmailIdSettingRec(String pStrName, String pStrEmail, String pStrToCcBcc){
        
        CM_Reporting_EmailIds__c oSetting = new CM_Reporting_EmailIds__c();
        List<CM_Reporting_EmailIds__c> listSetting = new list<CM_Reporting_EmailIds__c>();
        
        oSetting.Name = pStrName;
        oSetting.Email_Id__c = pStrEmail;
        oSetting.To_CC_Bcc__c = pStrToCcBcc;
        oSetting.Report_Type__c = 'Summary';
        
        listSetting.add(oSetting);
        
        return listSetting;
    }
}