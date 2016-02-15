/*
*    Description: Controller to Edit the Cases for RM Users and the set the required page layout.
*    
*    Version       Date            Name             Description
*    1.0           26/06/2014      Asmita           Initial Draft
*    1.1           04/07/2014      Asmita           Modifying the code to render Additional Values depending on Request For L3(a)/ L3(b)
*    1.2           24/09/2014      Asmita(Eternus)  Modified the code for rendering custom section for closing the case.
*    1.3           25/09/2014      Asmita(Eternus)  Modified the code to resolve IT HD 49453
*    1.4           26/09/2014      Asmita(Eternus)  Modified saveAndClose method to render the Close Case Section.
*    1.6           25/11/2014      Anupam Agrawal   Additional section rendering
*    2.0 -  Deepakpudi            12/12/2014     IT HD 63252 Reason For Rejection.
*/

public class EditCasesForRMController {
    
    //Properties
    
    public List<Case> listCase{get; set;}
    // rendering variables when L1 is selected
    public boolean isL3a{get;set;}
    public boolean isL3b{get;set;}
    // rendering variables when Request for L3(a)/ L(b) is selected
    public boolean isArranging_for_a_home_loan{get;set;}
    public boolean isBeyond_CC_process_policy{get;set;}
    public boolean isCC_Process_deviation_required{get;set;}
    public boolean isDemise_in_the_family{get;set;}
    public boolean isDue_to_possession_timelines{get;set;}
    public boolean isFinancial_constraints{get;set;}
    public boolean isFinds_competitor_property_attractive{get;set;}
    public boolean isInventory_change_required{get;set;}
    public boolean isLack_of_Approvals{get;set;}
    public boolean isManagement_deviation_required{get;set;}
    public boolean isMedical_reasons{get;set;}
    public boolean isMiscommunication_at_the_time_of_sale{get;set;}
    public boolean isPayment_deviation_required{get;set;}
    public boolean isProduct_deviation_required{get;set;}
    public boolean isProduct_issue_client_in_disagreement{get;set;}
    public boolean isSelf_funding_needs_more_time{get;set;}
    public boolean isApprovals{get;set;}
    public boolean isInventory{get;set;}
    public boolean isLoan_eligibility{get;set;}
    public boolean isLocation_Product{get;set;}
    public boolean isOffers{get;set;}
    public boolean isPayment_schedule{get;set;}
    public boolean isPossession_timelines{get;set;}
    public boolean isPricing{get;set;}
    public boolean isVehicle_slots{get;set;}
    public boolean isCSS_or_CES{get;set;}
    public boolean isAny_other_product{get;set;}
    public boolean isAlready_onboard{get;set;}
    public boolean isClient_will_pay_by_self{get;set;}
    public boolean isDropped_at_site{get;set;}
    public boolean isHanded_over_to_Channel_Partner{get;set;}
    public boolean isIn_transit_courier{get;set;}
    public boolean isOnline_payment_not_reflecting{get;set;}
    public boolean isPayment_will_come_from_bank{get;set;}
    public boolean isPick_up_to_be_arranged{get;set;}
    public boolean isReasons{get;set;}
    public boolean isDenial_of_site_visit{get;set;}
    public boolean isPermitted_for_Site_Visit{get;set;}
    public boolean isRescheduled_Site_Visit{get;set;}
    public boolean isBanker_site_visit_allowed{get;set;}
    public boolean isCustomer_contesting_a_clause{get;set;}
    public boolean isConfirm_Time_place_of_Registration{get;set;}
    public boolean isAccepted_Date_of_payment_Amount{get;set;}
    public boolean isRejected_Reason{get;set;}
    public boolean isGiven_another_reference{get;set;}
    public boolean isCustomer_does_not_wish_to_be_contacted{get;set;}
    public boolean isWants_for_self_Date_of_visit_to_site{get;set;}
    public boolean isWelcome_Call_reject{get;set;}
    public boolean isNo_Bank_loan_due_to_poor_eligibility{get;set;}
    public boolean isClient_wants_to_read_draft_AFS_at_HO{get;set;}
    public boolean isClient_wants_draft_agreement_to_be_sent{get;set;}
    public boolean isRequest_for_delay_in_registration{get;set;}
    public boolean isRequest_for_rescheduling_of_registration{get;set;}
    
    public boolean isReasonForNonPayment{get;set;}
    public boolean isReasonForRejectionOfMyGainFacility{get;set;}
    public boolean isReasonForRejectionOfLoyaltyReferrals{get;set;}
    public boolean isReasonForRejectionOfCustomerCareMarketingEvent{get;set;}
    public boolean isWelcomeCallReject{get;set;}
    public boolean isCustomer_asked_for_more_time_to_confirm{get;set;}
    
    public boolean isMultiple{get; set;}
    public boolean blnRenderCaseCloseSection {get; set;}
    public boolean blnEditCaseSection {get; set;}
    public boolean blnSaveAndCloseDisabled {get; set;}
    public String closeStatusType{get;set;}
    public boolean isaccepted_DateOfInvitation_Dateof_visit{get;set;}
    
    // 1.5 Asmita
    public boolean isWants_More_Info_from_Sales {get; set;}
    public boolean isCall_Back_Later {get; set;}
    
    //Siddharth 1.5
    public boolean isCampaign {get; set;}   
    
    // Variable
    public Id caseId;
    String strCaseType = '';
    
    // Static Variables  
    private static final String STRMULTIPLEREQUEST = 'Multiple Request';
    private static final String STRSAVEANDCLOSEURL = '/s?retURL=%2F';
    private static final String STRSAVEANDNEWURL1 = '/setup/ui/recordtypeselect.jsp?ent=Case&retURL=%2F';
    private static final String STRSAVEANDNEWURL2 = '&save_new_url=%2F500%2Fe%3FretURL%3D%252F';
    
    public String strInitialRequestForL3a;
    public String strInitialRequestForL3b;
    
    // Constructor
    public EditCasesForRMController(ApexPages.StandardController controller){
        
        blnEditCaseSection = true;
        listCase = new List<Case>();
        isMultiple = false; 
        blnRenderCaseCloseSection = false;
        blnSaveAndCloseDisabled = false;
        strInitialRequestForL3a = '';
        strInitialRequestForL3b = '';
        
        caseId = controller.getId();
        
        if(!String.isBlank(caseId))
        {
            getCaseRecords(caseId);
            if(!listCase.isempty()){
                if(listCase[0].CaseType__c != null){
                    // if case is of Multiple Request type
                     if(listCase[0].CaseType__c.equalsIgnoreCase(STRMULTIPLEREQUEST)){
                         isMultiple = true;
                     }
                     else{
                         isMultiple = false;
                         init();
                         onL1Change();
                         onChange();
                     }
                }
                // 1.3 Asmita
                if(listCase[0].Request_for_L3_a__c != null || !String.isBlank(listCase[0].Request_for_L3_a__c)){
                    if(listCase[0].Request_for_L3_a__c.contains('L3'))
                        listCase[0].Request_for_L3_a__c = listCase[0].Request_for_L3_a__c.replace('L3',''); 
                    strInitialRequestForL3a = listCase[0].Request_for_L3_a__c;
                } 
                if(listCase[0].Request_for_L3__c != null || !String.isBlank(listCase[0].Request_for_L3__c)){
                    if(listCase[0].Request_for_L3__c.contains('L3'))
                        listCase[0].Request_for_L3__c = listCase[0].Request_for_L3__c.replace('L3','');
                    strInitialRequestForL3b = listCase[0].Request_for_L3__c;  
                } 
            }
        }
    }// End Of Constructor


    // Method to get the Case Record to Edit
    public void getCaseRecords(Id caseId){
        
        System.debug('Case list id '+caseId);
        listCase = [select id, 
                           CaseType__c,
                           CaseNumber, 
                           Account.Name, 
                           Opportunity__r.Name, 
                           Interaction_Mode__c,
                           Communication_Type__c,
                           Nature_Of_Request__c,
                           CM_TAT__c,
                           Remaining_Hours__c,
                           Related_Booking__r.Name,
                           Date_of_Grievance__c,
                           Date_of_Complaint__c,
                           Needs_approval_from_director__c,
                           ParentCaseType__c,
                           Initial_Remarks__c,
                           Status,
                           Priority,
                           Owner.Name,
                           IsMoved__c,
                           Follow_Up__c,
                           Remarks__c,
                           Case_Summary__c,
                           Case_Resolution__c,
                           Escalated_To_Name__c,
                           Latest_Comment__c,
                           Escalated_To__c,
                           Description,
                           Origin,
                           Subject,
                           Contact.Name,
                           Dependency_on_Internal_functions__c,
                           Request_for_L1__c,
                           Request_for_L2__c,
                           Request_for_L3_a__c,
                           Request_for_L3__c,
                           Cancel_Init_Lack_of_Approvals__c,
                           Cancel_Init_Management_deviation_require__c,
                           Cancel_Init_CC_Process_deviation_require__c,
                           Cancel_Init_Medical_reasons__c,
                           Cancel_Init_Demise_In_Family__c,
                           Cancel_Init_Miscomm_at_sale_time__c,
                           Cancel_Init_Due_to_possession_timelines__c,
                           Cancel_Init_loan_not_getting_sanctioned__c,
                           Cancel_Init_Financial_constraints__c,
                           Cancel_Init_Payment_deviation_required__c,
                           Cancel_Init_Finds_competitor_property_at__c,
                           Cancel_Init_Product_issue_client_in_di__c,
                           Cancel_Init_Inventory_change_required__c,
                           Cancel_Init_Self_funding_needs_more_ti__c,
                           Date_for_pick_up_to_be_arranged__c,
                           Amount_for_pick_up_to_be_arranged__c,
                           Date_of_payment_Client_will_pay_by_self__c,
                           Amount_Client_will_pay_by_self__c,
                           Mode_of_payment_Client_will_pay_by_self__c,
                           Bank_Name_Payment_will_come_from_bank__c,
                           Amount_Payment_will_come_from_bank__c,
                           Date_Payment_will_come_from_bank__c,
                           AirwayBillNo_TrackingNo_in_transit_couri__c,
                           PIT_Courier_company_name_In_transit_co__c,
                           Amount_Handed_over_to_Channel_Partner__c,
                           Reason_for_non_payment__c,
                           Date_In_transit_courier__c,
                           Amount_In_transit_courier__c,
                           UTR_Code_Online_payment_not_reflecting__c,
                           Amount_Online_payment_not_reflecting__c,
                           Date_Online_payment_not_reflecting__c,
                           Bank_Name_Online_payment_not_reflecting__c,
                           Site_Location_Dropped_at_site__c,
                           Amount_Dropped_at_site__c,
                           Date_Dropped_at_site__c,
                           Name_Handed_over_to_Channel_Partner__c,
                           Mobile_no_Handed_over_to_Channel_Partner__c,
                           Date_Handed_over_to_Channel_Partner__c,
                           Customer_response_CSS_or_CES__c,
                           Customer_response_Already_onboard__c,
                           Customer_response_Any_other_product__c,
                           Investigation_required_Pricing__c,
                           Investigation_required_Payment_schedule__c,
                           Investigation_required_Inventory__c,
                           Investigation_required_Approvals__c,
                           Investigation_required_Vehicle_slots__c,
                           Investigation_required_Possession_timeli__c,
                           Investigation_required_Location_Product__c,
                           Investigation_required_Loan_eligibility__c,
                           Investigation_required_Offers__c,
                           Reason_for_site_visit_denial__c,
                           Date_Permitted_for_Site_Visit__c,
                           Date_Rescheduled_Site_Visit__c,
                           Registration_Clause_contest_result__c,
                           Date_Customer_wants_to_read_draft_agreem__c,
                           Date_Customer_wants_draft_agreement_sent__c,
                           Date_Confirm_Time_place_of_Registratio__c,
                           Date_Request_for_delay_in_registration__c,
                           Date_Request_for_rescheduling_the_regist__c,
                           Date_Accepted_Date_of_payment_Amount__c,
                           Amount_Accepted_Date_of_payment_Amount__c,
                           Name_Given_another_reference__c,
                           Mobile_No_Given_another_reference__c,
                           Reason_for_Rejection_of_Loyalty_Referr__c,
                           Date_Accepted_the_invitation_Date_of_vi__c,
                           Customer_Wishes_To_Be_Contacted__c,
                           Amount_Wants_for_self_Date_of_site_visit__c,
                           Date_Wants_for_self_Date_of_visit_to_s__c,
                           Reason_for_Rejection_of_MyGain_Facility__c,
                           Reason_for_Customer_Care_Marketing_Event__c,
                           Date_Customer_has_asked_for_more_time_to__c,
                           Reason_for_welcome_call_rejection__c,
                           Cancel_Init_Product_deviation_required__c, 
                           Date_Banker_site_visit_allowed__c,
                           Cancel_Init_Arranging_for_a_home_loan__c,
                           Cancel_Init_Beyond_CC_process_policy__c,
                           Account.IsPersonAccount,
                           Date_of_Call__c,Campaign__c 
                    from Case
                    where id = :caseId];
    }
    
    
    // Action Item for Save Button
    public PageReference save(){
        try{
            if(!listCase.isEmpty()){
                listCase[0].Status = closeStatusType != null ? closeStatusType : listCase[0].Status;
                update listCase[0];
            }
        
            PageReference pgRef = new PageReference('/'+ caseId);
            return pgRef;
        }
        catch(Exception objExp){
           System.debug('Exception ::::: ' + objExp);
           ApexPages.addMessages(objExp);
        }
        return null;
    }
    
    
    // Action method for Save & Close Button
    /*public PageReference saveAndClose(){
    
        PageReference pgRef = new PageReference('/' + caseId + STRSAVEANDCLOSEURL + caseId);
        return pgRef;
    }*/
    // 1.2 Asmita
    public void saveAndClose(){
        // 1.3 Asmita
       blnRenderCaseCloseSection = true;
       blnSaveAndCloseDisabled = true;
    }
    
    public List<SelectOption> getStatus() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','-- None --')); 
        options.add(new SelectOption('Closed Satisfied','Closed Satisfied')); 
        options.add(new SelectOption('Closed UnSatisfied','Closed UnSatisfied')); 
        return options; 
    }
    
    // Action method for Save & New Button
    public PageReference saveAndNew(){
        save();
        PageReference pgRef = new PageReference(STRSAVEANDNEWURL1 + caseId + STRSAVEANDNEWURL2 + caseId);
        return pgRef;
    }
    
    
    // Action method for Cancel Button
    public PageReference cancel(){
        
        PageReference pgRef = new PageReference('/'+ caseId);
        return pgRef;
    }// end of cancel
    
    
    // init method to initialize the variables
    public void init(){
        
        initL3RerenderMethod();
        initRerenderMethod();

    }// end of init
    
    
    // Initialising L3a/ L3b so as to render on page depending on the L1 Value.
    public void initL3RerenderMethod(){
        isL3a = false;
        isL3b = false;    
    }// end of initL3RerenderMethod
    
    
    // On L1 Change set either L3(a) or L3(b)
    public void onL1Change(){
        // 1.3 Asmita 
        if(listCase[0].Request_for_L1__c == 'Collections Related' || listCase[0].Request_for_L1__c == 'Collections Related - SDR' || listCase[0].Request_for_L1__c == 'Document Related' || listCase[0].Request_for_L1__c == 'Legal case' || listCase[0].Request_for_L1__c == 'Customer Service' || listCase[0].Request_for_L1__c == 'DND' || listCase[0].Request_for_L1__c == 'Legal Notice' || listCase[0].Request_for_L1__c == 'Police Complaint' || listCase[0].Request_for_L1__c == 'Payment Related' || listCase[0].Request_for_L1__c == 'Updation of info on systems'){
            isL3a = true; 
            isL3b = false;
        }
        if(listCase[0].Request_for_L1__c != 'Collections Related' && listCase[0].Request_for_L1__c != 'Collections Related - SDR' && listCase[0].Request_for_L1__c != 'Document Related' && listCase[0].Request_for_L1__c != 'Legal case' && listCase[0].Request_for_L1__c != 'Customer Service' && listCase[0].Request_for_L1__c != 'DND' && listCase[0].Request_for_L1__c != 'Legal Notice' && listCase[0].Request_for_L1__c != 'Police Complaint' && listCase[0].Request_for_L1__c != 'Payment Related' && listCase[0].Request_for_L1__c != 'Updation of info on systems'){
            isL3b = true; 
            isL3a = false; 
        }
        
        //Siddharth 1.5
        this.InitRerenderMethod();        
    }// end of onL1Change
    
    
    // Initializing the Additional Values which are depending on Request for L3(a)/ L3(b)
    public void initRerenderMethod(){
        isaccepted_DateOfInvitation_Dateof_visit = false;
        isArranging_for_a_home_loan = false;
        isBeyond_CC_process_policy = false;
        isCC_Process_deviation_required = false;
        isDemise_in_the_family = false;
        isDue_to_possession_timelines = false;
        isFinancial_constraints = false;
        isFinds_competitor_property_attractive = false;
        isInventory_change_required = false;
        isLack_of_Approvals = false;
        isManagement_deviation_required = false;
        isMedical_reasons = false;
        isMiscommunication_at_the_time_of_sale = false;
        isPayment_deviation_required = false;
        isProduct_deviation_required = false;
        isProduct_issue_client_in_disagreement = false;
        isSelf_funding_needs_more_time = false;
        isApprovals = false;
        isInventory = false;
        isLoan_eligibility = false;
        isLocation_Product = false;
        isClient_will_pay_by_self = false;
        isOffers = false;
        isPayment_schedule = false;
        isPossession_timelines = false;
        isPricing = false;
        isVehicle_slots = false;
        isCSS_or_CES = false;
        isAny_other_product = false;
        isAlready_onboard = false;
        isDropped_at_site = false;
        isHanded_over_to_Channel_Partner = false;
        
        isIn_transit_courier = false;
        isOnline_payment_not_reflecting = false;
        isPayment_will_come_from_bank = false;
        isPick_up_to_be_arranged = false;
        isClient_will_pay_by_self =false;
        isReasons = false;
        isDenial_of_site_visit = false;
        isPermitted_for_Site_Visit = false;
        isRescheduled_Site_Visit = false;
        isBanker_site_visit_allowed = false;
        isCustomer_contesting_a_clause = false;
        isConfirm_Time_place_of_Registration = false;
        isAccepted_Date_of_payment_Amount = false;
        isRejected_Reason = false;
        isGiven_another_reference = false;
        isCustomer_does_not_wish_to_be_contacted = false;
        isWants_for_self_Date_of_visit_to_site = false;
        isWelcome_Call_reject = false;
        isNo_Bank_loan_due_to_poor_eligibility = false;
        isClient_wants_to_read_draft_AFS_at_HO = false;
        isClient_wants_draft_agreement_to_be_sent = false;
        isRequest_for_delay_in_registration = false;
        isRequest_for_rescheduling_of_registration = false;
        
        isReasonForNonPayment = false;
        isReasonForRejectionOfMyGainFacility = false;
        isReasonForRejectionOfLoyaltyReferrals= false;
        isReasonForRejectionOfCustomerCareMarketingEvent= false;
        isWelcomeCallReject = false;
        
        isCustomer_asked_for_more_time_to_confirm = false;
        
        // 1.5 Asmita
        isCall_Back_Later = false;
        isWants_More_Info_from_Sales = false;
        
        //Siddharth 1.5
        isCampaign = false;
    }
    private Boolean isFirstTime ;
    // 1.4 Asmita
    public void onChange(){
        
        /****Start Changes: Anupam 1.7***/
        listCase[0].Request_For_L3_a__c = ApexPages.currentPage().getParameters().containsKey('L3Avalues') ?
                                            ApexPages.currentPage().getParameters().get('L3Avalues') :
                                            listCase[0].Request_For_L3_a__c; 
        listCase[0].Request_For_L3__c = ApexPages.currentPage().getParameters().containsKey('L3Bvalues') ?
                                        ApexPages.currentPage().getParameters().get('L3Bvalues'):
                                        listCase[0].Request_For_L3__c;
        isFirstTime = ApexPages.currentPage().getParameters().containsKey('L2A') || ApexPages.currentPage().getParameters().containsKey('L2B');
        if(!Test.isRunningTest() && isFirstTime)    
        {                           
            isL3a = ApexPages.currentPage().getParameters().containsKey('L2A');
            isL3b = ApexPages.currentPage().getParameters().containsKey('L2B');
        }
        /****End Changes: Anupam 1.7***/
        
        if(isL3a)
            listCase[0].Request_For_L3__c = null;
        else if(isL3b)
            listCase[0].Request_For_L3_a__c = null;
         
        if( listCase[0].Request_for_L3_a__c != null){
            system.debug('Request For L3 (a) :::: ' + listCase[0].Request_For_L3_a__c);
            InitRerenderMethod();
            
            isPick_up_to_be_arranged = listCase[0].Request_for_L3_a__c.contains('Pick up to be arranged') ? true : false; 
            isClient_will_pay_by_self = listCase[0].Request_for_L3_a__c.contains('Client will pay by self') ? true : false;
            isPayment_will_come_from_bank = listCase[0].Request_for_L3_a__c.contains('Payment will come from bank') ? true : false; 
            isOnline_payment_not_reflecting = listCase[0].Request_for_L3_a__c.contains('Online payment not reflecting') ? true : false; 
            isDropped_at_site = listCase[0].Request_for_L3_a__c.contains('Dropped at site') ? true : false; 
            isHanded_over_to_Channel_Partner = listCase[0].Request_for_L3_a__c.contains('Handed over to Channel Partner') ? true : false;
            //isHanded_over_to_Channel_Partner = listCase[0].Request_for_L3_a__c.contains('Handed over to Channel Partner') ? true : false;
            isReasonForNonPayment = listCase[0].Request_for_L3_a__c.contains('Reasons for non pymnt(CV, ST, Interest)') || listCase[0].Request_for_L3_a__c.contains('Reasons for non pymnt(SDR Payments)') ? true : false;
            isIn_transit_courier = listCase[0].Request_for_L3_a__c.contains('In transit - courier') ? true : false; 
        }
        else if(listCase[0].Request_for_L3__c != null){
            
            system.debug('Request For L3 :::: ' + listCase[0].Request_for_L3__c);
            InitRerenderMethod();
            
            isWelcomeCallReject = listCase[0].Request_for_L3__c.contains('Welcome Call reject') ? true : false;
            isCustomer_asked_for_more_time_to_confirm = listCase[0].Request_for_L3__c.contains('Customer asked for more time to confirm') ? true : false;
            isCustomer_contesting_a_clause = listCase[0].Request_for_L3__c.contains('Customer contesting a clause') ? true : false;
            isClient_wants_to_read_draft_AFS_at_HO = listCase[0].Request_for_L3__c.contains('Client wants to read draft AFS at HO') ? true : false;
            isClient_wants_draft_agreement_to_be_sent = listCase[0].Request_for_L3__c.contains('Client wants draft agreement to be sent') ? true : false;
            isConfirm_Time_place_of_Registration = listCase[0].Request_for_L3__c.contains('Confirm Time & place of Registration') ? true : false;
            isRequest_for_delay_in_registration = listCase[0].Request_for_L3__c.contains('Request for delay in registration') ? true : false;
            isRequest_for_rescheduling_of_registration = listCase[0].Request_for_L3__c.contains('Request for rescheduling of registration') ? true : false;
            //isPick_up_to_be_arranged = listCase[0].Request_for_L3__c.contains('Pick up to be arranged') ? true : false;
            //isClient_will_pay_by_self = listCase[0].Request_for_L3__c.contains('Client will pay by self') ? true : false;
            //isPayment_will_come_from_bank = listCase[0].Request_for_L3__c.contains('Payment will come from bank') ? true : false; 
            //isOnline_payment_not_reflecting = listCase[0].Request_for_L3__c.contains('Online payment not reflecting') ? true : false; 
            //isDropped_at_site = listCase[0].Request_for_L3__c.contains('Dropped at site') ? true : false; 
            //isHanded_over_to_Channel_Partner = listCase[0].Request_for_L3__c.contains('Handed over to Channel Partner') ? true : false; 
            //isIn_transit_courier = listCase[0].Request_for_L3__c.contains('In transit - courier') ? true : false; 
            isCSS_or_CES = listCase[0].Request_for_L3__c.contains('CSS or CES') ? true : false; 
            isAny_other_product = listCase[0].Request_for_L3__c.contains('Any other product') ? true : false; 
            isAlready_onboard = listCase[0].Request_for_L3__c.contains('Already onboard') ? true : false; 
            isDemise_in_the_family = listCase[0].Request_for_L3__c.contains('Demise in the family') ? true : false;
            isFinancial_constraints = listCase[0].Request_for_L3__c.contains('Financial constraints') ? true : false;
            isFinds_competitor_property_attractive = listCase[0].Request_for_L3__c.contains('Finds competitor property attractive') ? true : false;
            isLack_of_Approvals = listCase[0].Request_for_L3__c.contains('Lack of Approvals') ? true : false;
            isMedical_reasons = listCase[0].Request_for_L3__c.contains('Medical reasons') ? true : false;
            isNo_Bank_loan_due_to_poor_eligibility = listCase[0].Request_for_L3__c.contains('No Bank loan due to poor eligibility') ? true : false;
            isMiscommunication_at_the_time_of_sale = listCase[0].Request_for_L3__c.contains('Miscommunication at the time of sale') ? true : false;
            isBeyond_CC_process_policy = listCase[0].Request_for_L3__c.contains('Beyond CC process/policy') ? true : false; 
            isProduct_deviation_required = listCase[0].Request_for_L3__c.contains('Product deviation required') ? true : false;
            isProduct_issue_client_in_disagreement = listCase[0].Request_for_L3__c.contains('Product issue - client in disagreement') ? true : false;
            isInventory_change_required = listCase[0].Request_for_L3__c.contains('Inventory change required') ? true : false; 
            isCC_Process_deviation_required = listCase[0].Request_for_L3__c.contains('CC Process deviation required') ? true : false; 
            isManagement_deviation_required = listCase[0].Request_for_L3__c.contains('Management deviation required') ? true : false; 
            isSelf_funding_needs_more_time = listCase[0].Request_for_L3__c.contains('Self funding - needs more time') ? true : false;
            isArranging_for_a_home_loan = listCase[0].Request_for_L3__c.contains('Arranging for a home loan') ? true : false;
            isProduct_issue_client_in_disagreement = listCase[0].Request_for_L3__c.contains('Product issue - client in disagreement') ? true : false;
            isPricing = listCase[0].Request_for_L3__c.contains('Pricing') ? true : false;
            isPayment_schedule = listCase[0].Request_for_L3__c.contains('Payment schedule') ? true : false;
            
            //isVehicle_slots = listCase[0].Request_for_L3__c.contains('Vehicle Slots') && !listCase[0].Request_for_L1__c.equalsIgnoreCase('Possessions Related') ? true : false;
            //isApprovals = listCase[0].Request_for_L3__c.contains('Approval') && !listCase[0].Request_for_L3__c.contains('Lack of Approvals') && !listCase[0].Request_for_L3__c.contains('Statutory Compliance (OC / Approvals)') ? true : false;
            
            //Anupam 1.7
            String strL2Value = ApexPages.currentPage().getParameters().get('L2B') ;
            if(!ApexPages.currentPage().getParameters().containsKey('L2B'))
                strL2Value = listCase[0].Request_for_L2__c;
            isVehicle_slots = !strL2Value.contains('Post-possession') && listCase[0].Request_for_L3__c.contains('Vehicle Slots'); 
            //Anupam 1.7
            isApprovals = !listCase[0].Request_for_L3__c.contains('Statutory Compliance (OC / Approvals)') && listCase[0].Request_for_L3__c.contains('Approval') && !listCase[0].Request_for_L3__c.contains('Lack of Approvals') ? true : false;
            
            isInventory = listCase[0].Request_for_L3__c.contains('Inventory') && !listCase[0].Request_for_L3__c.contains('Inventory change required') ? true : false;
            isLoan_eligibility = listCase[0].Request_for_L3__c.contains('Loan eligibility') ? true : false;
            isOffers = listCase[0].Request_for_L3__c.contains('Offers') ? true : false; 
            isPossession_timelines = listCase[0].Request_for_L3__c.contains('Possession Timelines') ? true : false;
            isLocation_Product = listCase[0].Request_for_L3__c.contains('Location/Product') ? true : false; 
            isCall_Back_Later = listCase[0].Request_for_L3__c.contains('Call Back Later') ? true : false;
            isWants_More_Info_from_Sales = listCase[0].Request_for_L3__c.contains('Wants More Info From Sales') ? true : false;
            //isReasonForNonPayment = listCase[0].Request_for_L3__c.contains('Reasons for non pymnt(SDR Payments)') ? true : false;
            isDue_to_possession_timelines = listCase[0].Request_for_L3__c.contains('Due to possession timelines') ? true : false; 
            isPayment_deviation_required = listCase[0].Request_for_L3__c.contains('Payment deviation required') ? true : false; 
            
            //Siddharth 1.5
            //isCampaign = listCase[0].Request_for_L2__c.equalsIgnoreCase('Loyalty campaign/Referrals - Pre launch') && (listCase[0].Request_for_L3__c.contains('Wants for self - Date of visit to site') || listCase[0].Request_for_L3__c.contains('Rejected - Reason') || listCase[0].Request_for_L3__c.contains('Wants more time to confirm') || listCase[0].Request_for_L3__c.contains('Given another reference') || listCase[0].Request_for_L3__c.contains('Customer does not wish to be contacted') || listCase[0].Request_for_L3__c.contains('Call Back Later') || listCase[0].Request_for_L3__c.contains('Wants More Info From Sales')) ? true : false;
            //Anupam 1.7
            isCampaign = strL2Value.equalsIgnoreCase('Loyalty campaign/Referrals - Pre launch') && (listCase[0].Request_for_L3__c.contains('Wants for self - Date of visit to site') || listCase[0].Request_for_L3__c.contains('Rejected - Reason') || listCase[0].Request_for_L3__c.contains('Wants more time to confirm') || listCase[0].Request_for_L3__c.contains('Given another reference') || listCase[0].Request_for_L3__c.contains('Customer does not wish to be contacted') || listCase[0].Request_for_L3__c.contains('Call Back Later') || listCase[0].Request_for_L3__c.contains('Wants More Info From Sales')) ? true : false;
            /****Start Changes: Anupam 1.6***/
            isaccepted_DateOfInvitation_Dateof_visit = listCase[0].Request_for_L3__c.contains('Accepted the invitation- Date of visit');
            
            //isReasonForRejectionOfLoyaltyReferrals= casecreate.Request_for_L3__c.contains('Rejected - Reason'); 

           // isReasonForRejectionOfMyGainFacility = listCase[0].Request_for_L3__c.contains('Rejected - Reason') || 
                                                  // listCase[0].Request_for_L3__c.contains('Event Rejected Reason');
             /* 2.0 -  Deepakpudi */                                      
            isReasonForRejectionOfMyGainFacility =  strL2Value.contains('MyGain facility/ADF facility/Amnesty/Dollar product/Home loan interest offer')
                                                 &&(listCase[0].Request_for_L3__c.contains('Rejected - Reason') || 
                          							listCase[0].Request_for_L3__c.contains('Event Rejected Reason'));
            isReasonForRejectionOfLoyaltyReferrals = (strL2Value.contains('Loyalty campaign/Referrals - Pre launch')||
 													  strL2Value.contains('Loyalty campaign/Referrals - Post launch')||
													  strL2Value.contains('Loyalty campaign/Referrals - Post possession'))
												   &&(listCase[0].Request_for_L3__c.contains('Rejected - Reason') || 
                                					 listCase[0].Request_for_L3__c.contains('Event Rejected Reason')); 
            isReasonForRejectionOfCustomerCareMarketingEvent = (strL2Value.contains('Customer Care event')||strL2Value.contains('Marketing event'))
		   													&& (listCase[0].Request_for_L3__c.contains('Rejected - Reason') || 
               													listCase[0].Request_for_L3__c.contains('Event Rejected Reason'));                                      
            
            isGiven_another_reference = listCase[0].Request_for_L3__c.contains('Given another reference');       
            isCustomer_does_not_wish_to_be_contacted = listCase[0].Request_for_L3__c.contains('Customer does not wish to be contacted');
            isWants_for_self_Date_of_visit_to_site = listCase[0].Request_for_L3__c.contains('Wants for self - Date of visit to site');  
            isAccepted_Date_of_payment_Amount = listCase[0].Request_for_L3__c.contains('Accepted - Date of payment & Amount');     
            /****End Changes Anupam: 1.6***/            
        }
        else{
            InitRerenderMethod();
        }
    }

    //Siddharth 1.5
    public void OnL2Change(){
        this.InitRerenderMethod();
    }        
}