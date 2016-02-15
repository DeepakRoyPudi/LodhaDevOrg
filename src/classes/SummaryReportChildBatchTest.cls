/*
*    Description: Test class for Summary report child batch class.
*    
*    Version       Date            Name             Description
*	 1.0           07/07/2014      Asmita Bubane    Initial Draft
*/

// System assumes that the cases created on one day prior so as to get the Case data


@isTest(seealldata = true)
public class SummaryReportChildBatchTest {

    static testMethod void summaryReportEmailTest() {
    	
    	Database.Querylocator qryLocator;
    	Database.Batchablecontext bc;
    	
    	Case oCase = new Case();
    	List<Case> listCase = new List<Case>();
    	List<Case> listAllCase = new List<Case>();
        Set<String> setProjectName = new Set<String>();
        List<String> listProjectName = new List<String>();    	
    	
    	// Creating an Account record, passing number of records to create and the Project Name
    	/*List<Account> listAccount = SummaryReportChildBatchTest.getAccountRecords(1, 'CASA BELLA');
    	listAccount[0].CRN__c = '4444444';
    	insert listAccount;
    	
    	// Creating Complaint and grievance type of cases for CASA BELLA project
    	List<case> caseList = SummaryReportChildBatchTest.getCaseRecords(1, 'Complaint');
    	caseList[0].Needs_approval_from_director__c = 'NO';
    	caseList[0].Date_of_Complaint__c = System.now().addDays(-1);
    	caseList[0].AccountId = listAccount[0].id;
    	caseList[0].RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CM_Parent_Only').getRecordTypeId();
    	insert caseList;
    	listAllCase.addAll(caseList);
    	
    	caseList = SummaryReportChildBatchTest.getCaseRecords(1, 'Grievance');
    	caseList[0].Date_of_Grievance__c = System.now().addDays(-1);
    	caseList[0].AccountId = listAccount[0].id;
    	caseList[0].RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CM_Parent_Only').getRecordTypeId();
    	insert caseList;
    	listAllCase.addAll(caseList);
    	
    	// Creating account record with another project
    	listAccount = SummaryReportChildBatchTest.getAccountRecords(1, 'CASA BELLA GOLD');
    	listAccount[0].CRN__c = '5555555';
    	insert listAccount;
    	
    	// Creating Complaint and grievance type of cases for CASA BELLA GOLD project
    	caseList = SummaryReportChildBatchTest.getCaseRecords(1, 'Complaint');
    	caseList[0].Needs_approval_from_director__c = 'NO';
    	caseList[0].Date_of_Complaint__c = System.now().addDays(-1);
    	caseList[0].AccountId = listAccount[0].id;
    	caseList[0].RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CM_Parent_Only').getRecordTypeId();
    	insert caseList;
    	listAllCase.addAll(caseList);
    	
    	caseList = SummaryReportChildBatchTest.getCaseRecords(1, 'Grievance');
    	caseList[0].Date_of_Grievance__c = System.now().addDays(-1);
    	caseList[0].AccountId = listAccount[0].id;
    	caseList[0].RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CM_Parent_Only').getRecordTypeId();
    	insert caseList;
    	listAllCase.addAll(caseList);*/
    	
    	// Assigning Account to the Cases
    	for(Case objCase : [select caseNumber, CreatedDate, Nature_of_Request__c, Request_for_L1__c, Request_for_L2__c, Request_for_L3_a__c, Request_for_L3__c, Status, TL_EmailId__c, Owner_EmailId__c, TL__c, PIC_EmailId__c,Remaining_Hours__c, Owner.name, createdBy.email, Date_of_Complaint__c, Date_of_Grievance__c, Interaction_Mode__c, Priority, Case_Summary__c, Case_Resolution__c, Dependency_on_Internal_functions__c,Project_Name_CM__c, account.Id from Case where (Nature_of_Request__c ='Grievance' or ( Nature_of_Request__c ='Complaint' and Needs_approval_from_director__c = 'NO')) AND ( Request_for_L1__c != '' AND Request_for_L2__c != '' )]){
            
            setProjectName.add(objCase.Project_Name_CM__c);  	 
    	}
    	
    	listProjectName.addAll(setProjectName);
    	
    	SummaryReportChildBatch oSummaryReport = new SummaryReportChildBatch(listProjectName,0);
    	qryLocator = oSummaryReport.start(bc);
    	
    	Database.Querylocatoriterator qryLocatorIterator = qryLocator.iterator();
    	while(qryLocatorIterator.hasNext()){
    		
    		oCase = (Case)qryLocatorIterator.next();
    	    listCase.add(oCase);
    	    
    	}// end of while
    	
    	oSummaryReport.execute(bc, listCase);
    	oSummaryReport.finish(bc);
    	
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
            
            listOfCase.add(oCase);
            
        }// end of for
        
        return listOfCase;
    }
}