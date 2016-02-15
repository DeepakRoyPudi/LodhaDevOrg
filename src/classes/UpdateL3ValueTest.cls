/*
*        Description : Test Class for UpdateL3Value Helper Called from Case Trigger
*
*        Version     Date          Author             Description
*        1.0         05/08/2014    Asmita(Eternus)    Intial Draft
*/

@isTest
private class UpdateL3ValueTest {

    static testMethod void replaceL3WithNullTest() {
        
        List<CM_Tat_Calculation__c> listAllCmTatCalculation = new List<CM_Tat_Calculation__c>();
        
        // Creating Custom Setting Records for CM_TAT_Calculations called from CM_CaseTATCalculationand SMSNotificationError
    	List<CM_Tat_Calculation__c> listCmTatCalculation = UpdateL3ValueTest.getCmTatCalculationRecords(1,'Parent');
    	listAllCmTatCalculation.addAll(listCmTatCalculation);    	
    	listCmTatCalculation = UpdateL3ValueTest.getCmTatCalculationRecords(1,'Child');
    	listAllCmTatCalculation.addAll(listCmTatCalculation);   	
    	listCmTatCalculation = UpdateL3ValueTest.getCmTatCalculationRecords(1,'AIFTM');
    	listAllCmTatCalculation.addAll(listCmTatCalculation);   	
    	listCmTatCalculation = UpdateL3ValueTest.getCmTatCalculationRecords(1,'AISPOC');
    	listAllCmTatCalculation.addAll(listCmTatCalculation);
    	insert listAllCmTatCalculation;
        
        // Creating Account
        List<Account> listAccount = UpdateL3ValueTest.getAccountRecord(1);
        insert listAccount;
        
        // Creating Cases
        List<Case> caseList = CaseTriggerHandlerTest.getCaseRecords(1);
    	caseList[0].AccountId = listAccount[0].id;
    	insert caseList;
    	
    	caseList[0].Nature_of_Request__c = 'Query';
    	update caseList;
    	
        caseList = [select id, Request_for_L3_a__c, Request_for_L3__c from Case where id = :caseList[0].Id];
        System.assertEquals(caseList[0].Request_for_L3_a__c, 'Reasons');
        System.assertEquals(caseList[0].Request_for_L3__c, null);
    }
    
    // Creating Account records
    public static List<Account> getAccountRecord(Integer pNumberOfRecords){
        
        Account oAcc = new Account();
        List<Account> listAccount = new List<Account>();
        
        for(Integer i = 0 ; i < pNumberOfRecords; i++){
            
            oAcc = new Account();
            oAcc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            oAcc.LastName = 'Test Trigger';
            oAcc.Mobile_Phone__c = '9211111111';
            
            listAccount.add(oAcc);
        }
        
        return listAccount;
    }// end of getAccountRecords
    
     // Method to create Complaint and Grievance type cases
    public static List<Case> getCaseRecords(Integer pNumberOfRecords){
    	
        List<Case> listOfCase = new List<Case>();
        Case oCase = new Case();
        
        for(Integer i = 0; i < pNumberOfRecords; i++){
            
            // Cearting Complaint type Case
            oCase = new Case();
            oCase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CM_Parent_Only').getRecordTypeId();
            oCase.Interaction_Mode__c = 'Email';
            oCase.Communication_Type__c = 'Inbound';
            oCase.Nature_of_Request__c = 'Request';
            oCase.Case_Resolution__c = 'test';
            oCase.Case_Summary__c = 'test';
            oCase.Request_for_L1__c = 'Collections Related';
            oCase.Request_for_L2__c = 'PTP';
            oCase.Request_for_L3_a__c = 'Reasons;L3';
            oCase.Request_for_L3__c = 'L3';
            
            listOfCase.add(oCase);
            
        }// end of for
        
        return listOfCase;
    }// end of getCaseRecords
    
    // Creating Records for Custom Setting- CM_TAT_Calculation
    public static List<CM_Tat_Calculation__c > getCmTatCalculationRecords(Integer pNumberOfRecords, String pStrSettingName){
        
        List<CM_Tat_Calculation__c > listCmTatCalculation = new List<CM_Tat_Calculation__c>();
        CM_Tat_Calculation__c  objCmTatCal = new CM_Tat_Calculation__c();
        
        for(Integer i = 0; i < pNumberOfRecords; i++){
            
            objCmTatCal = new CM_Tat_Calculation__c();
            objCmTatCal.Name = pStrSettingName;
            objCmTatCal.CaseType__c = pStrSettingName;
            objCmTatCal.Legal__c = 144.00;
            objCmTatCal.Non_Legal__c = 72.00;
            
            listCmTatCalculation.add(objCmTatCal);
        }// end of for
        
        return listCmTatCalculation;
    }
}