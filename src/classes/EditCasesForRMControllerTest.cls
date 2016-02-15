/*
*        Description : Test Class for EditCasesForRMController
*
*        Version     Date          Author             Description
*        1.0         05/08/2014    Asmita(Eternus)    Intial Draft
*/

@isTest
private class EditCasesForRMControllerTest {
    
    static testMethod void EditCasesForRMTest() {
    
        List<CM_Tat_Calculation__c> listAllCmTatCalculation = new List<CM_Tat_Calculation__c>();
        List<Case> listAllCase = new List<Case>();
        
        ApexPages.StandardController sc;
        EditCasesForRMController objEditCase;
        
        String strL3aValue = 'Pick up to be arranged;Client will pay by self;Reasons;Payment will come from bank;In transit - courier;';
        strL3aValue = strL3aValue + 'Online payment not reflecting;Dropped at site;Handed over to Channel Partner';
        
        String strL3bValue = 'Arranging for a home loan;Beyond CC process/policy;CC Process deviation required;Demise in the family;';
        strL3bValue = strL3bValue + 'Due to possession timelines;Financial constraints;Finds competitor property attractive;';
        strL3bValue = strL3bValue + 'Inventory change required;Lack of Approvals;Management deviation required;Medical reasons;';
        strL3bValue = strL3bValue + 'Miscommunication at the time of sale;Payment deviation required;Product deviation required;';
        strL3bValue = strL3bValue + 'Product issue - client in disagreement;Self funding - needs more time;Approval;Lack of Approvals;';
        strL3bValue = strL3bValue + 'Inventory;Inventory change required;Loan eligibility;Location/Product;Offers;Payment schedule;';
        strL3bValue = strL3bValue + 'Possession timelines;Pricing;Vehicle slots;CSS or CES;Any other product;Already onboard;';
        strL3bValue = strL3bValue + 'Denial of site visit;Permitted for Site Visit;Rescheduled Site Visit;Banker site visit - allowed;';
        strL3bValue = strL3bValue + 'Customer contesting a clause;Confirm Time & place of Registration;Accepted - Date of payment & Amount;';
        strL3bValue = strL3bValue + 'Event Rejected Reason;Given another reference;Customer does not wish to be contacted;';
        strL3bValue = strL3bValue + 'Wants for self - Date of visit to site;Welcome Call reject;No Bank loan due to poor eligibility;';
        strL3bValue = strL3bValue + 'Client wants to read draft AFS at HO;Client wants draft agreement to be sent;';
        strL3bValue = strL3bValue + 'Request for delay in registration;Request for rescheduling of registration;';
        strL3bValue = strL3bValue + 'Request for rescheduling of registration;Welcome Call reject;Rejected - Reason;Rejected Reason;';
        strL3bValue = strL3bValue + 'Event Rejected Reason;Customer asked for more time to confirm;Pick up to be arranged;';
        strL3bValue = strL3bValue + 'Client will pay by self;Reasons;Payment will come from bank;Online payment not reflecting;';
        strL3bValue = strL3bValue + 'Dropped at site;Handed over to Channel Partner;In transit - courier';    
            
        
        // Creating Custom Setting Records for CM_TAT_Calculations called from CM_CaseTATCalculationand SMSNotificationError
    	List<CM_Tat_Calculation__c> listCmTatCalculation = EditCasesForRMControllerTest.getCmTatCalculationRecords(1,'Parent');
    	listAllCmTatCalculation.addAll(listCmTatCalculation);    	
    	listCmTatCalculation = EditCasesForRMControllerTest.getCmTatCalculationRecords(1,'Child');
    	listAllCmTatCalculation.addAll(listCmTatCalculation);   	
    	listCmTatCalculation = EditCasesForRMControllerTest.getCmTatCalculationRecords(1,'AIFTM');
    	listAllCmTatCalculation.addAll(listCmTatCalculation);   	
    	listCmTatCalculation = EditCasesForRMControllerTest.getCmTatCalculationRecords(1,'AISPOC');
    	listAllCmTatCalculation.addAll(listCmTatCalculation);
    	insert listAllCmTatCalculation;
        
        // Creating Account
        List<Account> listAccount = EditCasesForRMControllerTest.getAccountRecord(1);
        insert listAccount;
        
        // Creating Cases
        List<Case> caseList = EditCasesForRMControllerTest.getCaseRecords(1, 'Collections Related', strL3aValue, null, 'Single Request');
    	caseList[0].AccountId = listAccount[0].id;
    	listAllCase.addAll(caseList);
    	caseList = EditCasesForRMControllerTest.getCaseRecords(1, 'Collection Related', strL3aValue, null, 'Multiple Request');
    	caseList[0].AccountId = listAccount[0].id;
    	listAllCase.addAll(caseList);
    	insert listAllCase;

    	for(Integer i = 0; i < listAllCase.size(); i++){
    	    sc = new ApexPages.StandardController(listAllCase[i]);
    	    objEditCase = new EditCasesForRMController(sc);
            
    	    System.assertEquals('/'+ listAllCase[i].Id, objEditCase.save().getUrl());
    	    objEditCase.saveAndClose();
    	    System.assertEquals('/setup/ui/recordtypeselect.jsp?ent=Case&retURL=%2F' + listAllCase[i].Id + '&save_new_url=%2F500%2Fe%3FretURL%3D%252F' + listAllCase[i].Id, objEditCase.saveAndNew().getUrl());
    	    System.assertEquals('/'+ listAllCase[i].Id, objEditCase.Cancel().getUrl());
    	}
    	
    }
    
    static testMethod void EditCasesForRMTest1() {
    
        List<CM_Tat_Calculation__c> listAllCmTatCalculation = new List<CM_Tat_Calculation__c>();
        List<Case> listAllCase = new List<Case>();
        
        ApexPages.StandardController sc;
        EditCasesForRMController objEditCase;
        
        String strL3aValue = 'Pick up to be arranged;Client will pay by self;Reasons;Payment will come from bank;In transit - courier;';
        strL3aValue = strL3aValue + 'Online payment not reflecting;Dropped at site;Handed over to Channel Partner';
        
        String strL3bValue = 'Arranging for a home loan;Beyond CC process/policy;CC Process deviation required;Demise in the family;';
        strL3bValue = strL3bValue + 'Due to possession timelines;Financial constraints;Finds competitor property attractive;';
        strL3bValue = strL3bValue + 'Inventory change required;Lack of Approvals;Management deviation required;Medical reasons;';
        strL3bValue = strL3bValue + 'Miscommunication at the time of sale;Payment deviation required;Product deviation required;';
        strL3bValue = strL3bValue + 'Product issue - client in disagreement;Self funding - needs more time;Approval;Lack of Approvals;';
        strL3bValue = strL3bValue + 'Inventory;Inventory change required;Loan eligibility;Location/Product;Offers;Payment schedule;';
        strL3bValue = strL3bValue + 'Possession timelines;Pricing;Vehicle slots;CSS or CES;Any other product;Already onboard;';
        strL3bValue = strL3bValue + 'Denial of site visit;Permitted for Site Visit;Rescheduled Site Visit;Banker site visit - allowed;';
        strL3bValue = strL3bValue + 'Customer contesting a clause;Confirm Time & place of Registration;Accepted - Date of payment & Amount;';
        strL3bValue = strL3bValue + 'Event Rejected Reason;Given another reference;Customer does not wish to be contacted;';
        strL3bValue = strL3bValue + 'Wants for self - Date of visit to site;Welcome Call reject;No Bank loan due to poor eligibility;';
        strL3bValue = strL3bValue + 'Client wants to read draft AFS at HO;Client wants draft agreement to be sent;';
        strL3bValue = strL3bValue + 'Request for delay in registration;Request for rescheduling of registration;';
        strL3bValue = strL3bValue + 'Request for rescheduling of registration;Welcome Call reject;Rejected - Reason;Rejected Reason;';
        strL3bValue = strL3bValue + 'Event Rejected Reason;Customer asked for more time to confirm;Pick up to be arranged;';
        strL3bValue = strL3bValue + 'Client will pay by self;Reasons;Payment will come from bank;Online payment not reflecting;';
        strL3bValue = strL3bValue + 'Dropped at site;Handed over to Channel Partner;In transit - courier';    
            
        
        // Creating Custom Setting Records for CM_TAT_Calculations called from CM_CaseTATCalculationand SMSNotificationError
    	List<CM_Tat_Calculation__c> listCmTatCalculation = EditCasesForRMControllerTest.getCmTatCalculationRecords(1,'Parent');
    	listAllCmTatCalculation.addAll(listCmTatCalculation);    	
    	listCmTatCalculation = EditCasesForRMControllerTest.getCmTatCalculationRecords(1,'Child');
    	listAllCmTatCalculation.addAll(listCmTatCalculation);   	
    	listCmTatCalculation = EditCasesForRMControllerTest.getCmTatCalculationRecords(1,'AIFTM');
    	listAllCmTatCalculation.addAll(listCmTatCalculation);   	
    	listCmTatCalculation = EditCasesForRMControllerTest.getCmTatCalculationRecords(1,'AISPOC');
    	listAllCmTatCalculation.addAll(listCmTatCalculation);
    	insert listAllCmTatCalculation;
        
        // Creating Account
        List<Account> listAccount = EditCasesForRMControllerTest.getAccountRecord(1);
        insert listAccount;
        
        // Creating Cases
        List<Case> caseList = EditCasesForRMControllerTest.getCaseRecords(1, 'Collection Related', strL3aValue, null, 'Single Request');
    	caseList[0].AccountId = listAccount[0].id;
    	listAllCase.addAll(caseList);
    	caseList = EditCasesForRMControllerTest.getCaseRecords(1, 'Registration Related', null, strL3bValue, 'Single Request');
    	caseList[0].AccountId = listAccount[0].id;
    	listAllCase.addAll(caseList);
    	caseList = EditCasesForRMControllerTest.getCaseRecords(1, 'Registration Related', null, strL3bValue, 'Multiple Request');
    	caseList[0].AccountId = listAccount[0].id;
    	listAllCase.addAll(caseList);
    	caseList = EditCasesForRMControllerTest.getCaseRecords(1, 'Collection Related', strL3aValue, null, 'Multiple Request');
    	caseList[0].AccountId = listAccount[0].id;
    	listAllCase.addAll(caseList);
    	caseList = EditCasesForRMControllerTest.getCaseRecords(1, 'Collection Related', strL3aValue, null, 'Single Request');
    	caseList[0].AccountId = listAccount[0].id;
    	listAllCase.addAll(caseList);
    	insert listAllCase;
    	
    	for(Integer i = 0; i < listAllCase.size(); i++){
    	    sc = new ApexPages.StandardController(listAllCase[i]);
    	    objEditCase = new EditCasesForRMController(sc);
            
    	    System.assertEquals('/'+ listAllCase[i].Id, objEditCase.save().getUrl());
    	    objEditCase.saveAndClose();
    	    System.assertEquals('/setup/ui/recordtypeselect.jsp?ent=Case&retURL=%2F' + listAllCase[i].Id + '&save_new_url=%2F500%2Fe%3FretURL%3D%252F' + listAllCase[i].Id, objEditCase.saveAndNew().getUrl());
    	    System.assertEquals('/'+ listAllCase[i].Id, objEditCase.Cancel().getUrl());
    	    List<SelectOption> listOptions = objEditCase.getStatus();
    	    objEditCase.OnL2Change();
    	}
    	
    }
    
    static testMethod void EditCasesForRMTest2() {
    
        List<CM_Tat_Calculation__c> listAllCmTatCalculation = new List<CM_Tat_Calculation__c>();
        List<Case> listAllCase = new List<Case>();
        
        ApexPages.StandardController sc;
        EditCasesForRMController objEditCase;
        
        String strL3aValue = 'Pick up to be arranged;Client will pay by self;Reasons;Payment will come from bank;In transit - courier;';
        strL3aValue = strL3aValue + 'Online payment not reflecting;Dropped at site;Handed over to Channel Partner';
        
        String strL3bValue = 'Arranging for a home loan;Beyond CC process/policy;CC Process deviation required;Demise in the family;';
        strL3bValue = strL3bValue + 'Due to possession timelines;Financial constraints;Finds competitor property attractive;';
        strL3bValue = strL3bValue + 'Inventory change required;Lack of Approvals;Management deviation required;Medical reasons;';
        strL3bValue = strL3bValue + 'Miscommunication at the time of sale;Payment deviation required;Product deviation required;';
        strL3bValue = strL3bValue + 'Product issue - client in disagreement;Self funding - needs more time;Approval;Lack of Approvals;';
        strL3bValue = strL3bValue + 'Inventory;Inventory change required;Loan eligibility;Location/Product;Offers;Payment schedule;';
        strL3bValue = strL3bValue + 'Possession timelines;Pricing;Vehicle slots;CSS or CES;Any other product;Already onboard;';
        strL3bValue = strL3bValue + 'Denial of site visit;Permitted for Site Visit;Rescheduled Site Visit;Banker site visit - allowed;';
        strL3bValue = strL3bValue + 'Customer contesting a clause;Confirm Time & place of Registration;Accepted - Date of payment & Amount;';
        strL3bValue = strL3bValue + 'Event Rejected Reason;Given another reference;Customer does not wish to be contacted;';
        strL3bValue = strL3bValue + 'Wants for self - Date of visit to site;Welcome Call reject;No Bank loan due to poor eligibility;';
        strL3bValue = strL3bValue + 'Client wants to read draft AFS at HO;Client wants draft agreement to be sent;';
        strL3bValue = strL3bValue + 'Request for delay in registration;Request for rescheduling of registration;';
        strL3bValue = strL3bValue + 'Request for rescheduling of registration;Welcome Call reject;Rejected - Reason;Rejected Reason;';
        strL3bValue = strL3bValue + 'Event Rejected Reason;Customer asked for more time to confirm;Pick up to be arranged;';
        strL3bValue = strL3bValue + 'Client will pay by self;Reasons;Payment will come from bank;Online payment not reflecting;';
        strL3bValue = strL3bValue + 'Dropped at site;Handed over to Channel Partner;In transit - courier';    
            
        
        // Creating Custom Setting Records for CM_TAT_Calculations called from CM_CaseTATCalculationand SMSNotificationError
    	List<CM_Tat_Calculation__c> listCmTatCalculation = EditCasesForRMControllerTest.getCmTatCalculationRecords(1,'Parent');
    	listAllCmTatCalculation.addAll(listCmTatCalculation);    	
    	listCmTatCalculation = EditCasesForRMControllerTest.getCmTatCalculationRecords(1,'Child');
    	listAllCmTatCalculation.addAll(listCmTatCalculation);   	
    	listCmTatCalculation = EditCasesForRMControllerTest.getCmTatCalculationRecords(1,'AIFTM');
    	listAllCmTatCalculation.addAll(listCmTatCalculation);   	
    	listCmTatCalculation = EditCasesForRMControllerTest.getCmTatCalculationRecords(1,'AISPOC');
    	listAllCmTatCalculation.addAll(listCmTatCalculation);
    	insert listAllCmTatCalculation;
        
        // Creating Account
        List<Account> listAccount = EditCasesForRMControllerTest.getAccountRecord(1);
        insert listAccount;
        
        // Creating Cases
        /*List<Case> caseList = EditCasesForRMControllerTest.getCaseRecords(1, 'Collections Related', null, null, 'Single Request');
    	caseList[0].AccountId = listAccount[0].id;
    	listAllCase.addAll(caseList);
    	caseList = EditCasesForRMControllerTest.getCaseRecords(1, 'Registration Related', null, null, 'Multiple Request');
    	caseList[0].AccountId = listAccount[0].id;
    	listAllCase.addAll(caseList);
    	insert listAllCase;
    	
    	for(Integer i = 0; i < listAllCase.size(); i++){
    	    sc = new ApexPages.StandardController(listAllCase[i]);
    	    objEditCase = new EditCasesForRMController(sc);
            
    	    System.assertEquals('/'+ listAllCase[i].Id, objEditCase.save().getUrl());
    	    System.assertEquals('/' + listAllCase[i].Id + '/s?retURL=%2F' + listAllCase[i].Id, objEditCase.saveAndClose().getUrl());
    	    System.assertEquals('/setup/ui/recordtypeselect.jsp?ent=Case&retURL=%2F' + listAllCase[i].Id + '&save_new_url=%2F500%2Fe%3FretURL%3D%252F' + listAllCase[i].Id, objEditCase.saveAndNew().getUrl());
    	    System.assertEquals('/'+ listAllCase[i].Id, objEditCase.Cancel().getUrl());
    	}*/
    	
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
    public static List<Case> getCaseRecords(Integer pNumberOfRecords, String pStrL1Value, String pStrL3aValue, String pStrL3bValue, String pStrCaseType){
    	
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
            oCase.Request_for_L1__c = pStrL1Value;
            oCase.Request_for_L2__c = 'PTP';
            oCase.Request_for_L3_a__c = pStrL3aValue;            
            oCase.Request_for_L3__c = pStrL3bValue;
            oCase.CaseType__c = pStrCaseType;
            oCase.Cancel_Init_Arranging_for_a_home_loan__c = 'Lodha initiated';
            oCase.Cancel_Init_Beyond_CC_process_policy__c = 'Lodha initiated';
            oCase.Cancel_Init_CC_Process_deviation_require__c = 'Lodha initiated';
            oCase.Cancel_Init_Demise_In_Family__c = 'Lodha initiated';
            oCase.Cancel_Init_Due_to_possession_timelines__c = 'Lodha initiated';
            oCase.Cancel_Init_Financial_constraints__c = 'Lodha initiated';
            oCase.Cancel_Init_Finds_competitor_property_at__c = 'Lodha initiated';
            oCase.Cancel_Init_Inventory_change_required__c = 'Lodha initiated';
            oCase.Cancel_Init_Lack_of_Approvals__c = 'Lodha initiated';
            oCase.Cancel_Init_Management_deviation_require__c = 'Lodha initiated';
            oCase.Cancel_Init_Medical_reasons__c = 'Lodha initiated';
            oCase.Cancel_Init_Miscomm_at_sale_time__c = 'Lodha initiated';
            oCase.Cancel_Init_Payment_deviation_required__c = 'Lodha initiated';
            oCase.Cancel_Init_Product_deviation_required__c = 'Lodha initiated';	
            oCase.Cancel_Init_Product_issue_client_in_di__c = 'Lodha initiated';
            oCase.Cancel_Init_Self_funding_needs_more_ti__c = 'Lodha initiated';
            oCase.Investigation_required_Approvals__c = true;	
            oCase.Investigation_required_Inventory__c = true;
            oCase.Investigation_required_Loan_eligibility__c = true;
            oCase.Investigation_required_Location_Product__c = true;
            oCase.Investigation_required_Offers__c = true;
            oCase.Investigation_required_Payment_schedule__c = true;
            oCase.Investigation_required_Possession_timeli__c = true;
            oCase.Investigation_required_Pricing__c = true;
            oCase.Investigation_required_Vehicle_slots__c = true;
            oCase.Customer_response_CSS_or_CES__c = 'Agreed';
            oCase.Customer_response_Any_other_product__c = 'Agreed';
            oCase.Customer_response_Already_onboard__c = 'Agreed';
            oCase.Date_of_payment_Client_will_pay_by_self__c = System.now();
            oCase.Amount_Client_will_pay_by_self__c = 1000.00;
            oCase.Mode_of_payment_Client_will_pay_by_self__c = 'Cash';
            oCase.Site_Location_Dropped_at_site__c = 'test';
            oCase.Amount_Dropped_at_site__c = 1000.00;
            oCase.Date_Dropped_at_site__c = System.now();
            oCase.Name_Handed_over_to_Channel_Partner__c = 'test';
            oCase.Mobile_no_Handed_over_to_Channel_Partner__c = 'test';
            oCase.Amount_Handed_over_to_Channel_Partner__c = 1000.00;
            oCase.Date_Handed_over_to_Channel_Partner__c = System.now();
            oCase.AirwayBillNo_TrackingNo_in_transit_couri__c = 'test';
            oCase.PIT_Courier_company_name_In_transit_co__c = 'test';
            oCase.Date_In_transit_courier__c = System.now();
            oCase.Amount_In_transit_courier__c = 1000.00;
            oCase.UTR_Code_Online_payment_not_reflecting__c = 'test';
            oCase.Amount_Online_payment_not_reflecting__c = 1000.00;
            oCase.Date_Online_payment_not_reflecting__c = System.now();
            oCase.Bank_Name_Online_payment_not_reflecting__c = 'test';
            oCase.Bank_Name_Payment_will_come_from_bank__c = 'test';
            oCase.Amount_Payment_will_come_from_bank__c = 1000.00;
            oCase.Date_Payment_will_come_from_bank__c = System.now();
            oCase.Date_for_pick_up_to_be_arranged__c = System.now();
            oCase.Amount_for_pick_up_to_be_arranged__c = 1000.00;
            oCase.Reason_for_site_visit_denial__c = 'Eligible for visit but site not fit for inspection';
            oCase.Date_Permitted_for_Site_Visit__c = System.now();
            oCase.Date_Rescheduled_Site_Visit__c = System.now();
            oCase.Date_Banker_site_visit_allowed__c = System.now();
            oCase.Registration_Clause_contest_result__c = 'Wants more clarity';
            oCase.Date_Confirm_Time_place_of_Registratio__c = System.now();
            oCase.Date_Accepted_Date_of_payment_Amount__c = System.now();
            oCase.Amount_Accepted_Date_of_payment_Amount__c = 1000.00;
            oCase.Reasons__c = 'test';
            oCase.Name_Given_another_reference__c = 'test';
            oCase.Mobile_No_Given_another_reference__c = 'test';
            oCase.Customer_Wishes_To_Be_Contacted__c = true;
            oCase.Amount_Wants_for_self_Date_of_site_visit__c = 1000.00;
            oCase.Date_Wants_for_self_Date_of_visit_to_s__c = System.now();
            oCase.Cancel_Init_loan_not_getting_sanctioned__c = 'Lodha initiated';
            oCase.Date_Customer_wants_to_read_draft_agreem__c = System.now();
            oCase.Date_Customer_wants_draft_agreement_sent__c = System.now();
            oCase.Date_Request_for_delay_in_registration__c = System.now();
            oCase.Date_Request_for_rescheduling_the_regist__c = System.now();
            oCase.Reason_for_non_payment__c = 'Approved Deviation';
            oCase.Reason_for_Rejection_of_MyGain_Facility__c = 'Negative about the offer';
            oCase.Reason_for_welcome_call_rejection__c = 'Pricing';
            oCase.Reason_for_Rejection_of_Loyalty_Referr__c = 'Does not have funds';
            oCase.Reason_for_Customer_Care_Marketing_Event__c = 'Travelling so cannot visit';
            oCase.Date_Customer_has_asked_for_more_time_to__c = System.now();
            
            listOfCase.add(oCase);
            
        }// end of for
        
        return listOfCase;
    }// end of getCaseRecords`
    
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