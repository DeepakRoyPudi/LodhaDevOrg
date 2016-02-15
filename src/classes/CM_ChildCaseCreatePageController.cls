/**********************************************************************************
Name:  CM_ChildCaseCreatePageController 
Copyright © 2013  Lodha Group
===================================================================================
===================================================================================
Purpose:
-------
Controller For CM_ChildCaseCreatePage VF page 
===================================================================================
===================================================================================
History
-------
VERSION    AUTHOR                DATE             DETAIL              
1.0 -   CG Dev Team          13/11/2013      INITIAL DEVELOPMENT
1.1 -   Asmita               06/10/2014      IT HD - 45471 - L1,L2,L3 Refactoring
1.3 -   Anupam Agrawal       25/11/2014      Additional section rendering
1.4 -   Siddharth Birari     02/12/2014      Code Fix for Registration Changes
                                             Added 'return null' in catch blocks
2.0 -  Deepakpudi            12/12/2014     IT HD 63252 Reason For Rejection.                                            
**********************************************************************************/
public class CM_ChildCaseCreatePageController {
    
    public boolean secChild{get;set;}
    public boolean secCtype1{get;set;}
    public boolean secCtype2{get;set;}
    
    public Case caseCreate{get;set;}
    public Case parentCase{get;set;}
    public Id userId{get;set;}
    public Id caseId{get;set;}
    public String parentId{get;set;}
    public String sparentId{get;set;}
    public String accntId{get;set;}
    public String pType{get;set;}
    public Id recTypeActionItemId{get;set;}
    public Id recTypeChildCaseId{get;set;}
    
    
    //For Welcome call Oppty
    public String opptyId {get;set;}
    public boolean IsforOppty{get;set;}
    public string flatNo{get; set;}
    
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
    
    public boolean isReasonForRejectionOfCustomerCareMarketingEvent{get;set;}
    public boolean isReasonForRejectionOfLoyaltyReferrals{get;set;}
    public boolean isReasonForNonPayment{get;set;}
    public boolean isReasonForRejectionOfMyGainFacility {get;set;}
    public boolean isWelcomeCallReject{get;set;}
    
    // 1.1 Asmita
    public boolean isWants_More_Info_from_Sales {get; set;}
    public boolean isCall_Back_Later {get; set;}
    public boolean isCustomer_asked_for_more_time_to_confirm{get;set;}
    public boolean isaccepted_DateOfInvitation_Dateof_visit{get;set;}
    public boolean isReasonForNonPaymentSdr{get;set;}
    
    public boolean isL3a{get;set;}
    public boolean isL3b{get;set;}

    //Siddharth 1.2
    public boolean isCampaign {get; set;}

    public String subCaseType{get;set;}
    public List<Queue_Configuration__c> spocQueue{get;set;}
    public List<Queue_Configuration__c> ftQueue{get;set;}
    public Id spocQueueId{get;set;}
    public Id ftQueueId{get;set;}
    
    
    public CM_ChildCaseCreatePageController (ApexPages.StandardController controller) {
        
        InitMethod();
        caseCreate = new Case();
        
        userId = [select id from user where id=:userinfo.getuserid()].id;
        caseId = ApexPages.currentPage().getParameters().get('caseId');
        parentId = ApexPages.currentPage().getParameters().get('ParentId');
        sparentId = ApexPages.currentPage().getParameters().get('ParentId');
        accntId = ApexPages.currentPage().getParameters().get('acctId');
        
        //For Welcome call Oppty
        opptyId = ApexPages.currentPage().getParameters().get('oppId');
        
        pType = ApexPages.currentPage().getParameters().get('ptype');   
        
        //for Welcome call Oppty
        if(accntId != null && accntId !=''){
            caseCreate.AccountId = accntId;
            IsforOppty=false;
        }        
        if(opptyId != null && opptyId !=''){
            caseCreate.Opportunity__c = opptyId;           
            IsforOppty=true;
        }
        
        caseCreate.OwnerId = userId; 
        
        //parentCase = [SELECT AccountId,Communication_Type__c,Interaction_Mode__c,Nature_of_Request__c,Priority, Request_for_L1__c, Request_for_L2__c FROM Case WHERE Id = :parentId];
        
        /*changed to load summary and resolution fromm parent */
        if(parentId != null && parentId != ''){
            
            parentCase = [SELECT AccountId,Related_Booking__c,Related_Booking__r.Oasys_Flat_Code__c,Communication_Type__c,Interaction_Mode__c,Nature_of_Request__c,Priority, Request_for_L1__c, Request_for_L2__c,Request_for_L3_a__c,Request_for_L3__c, Case_Summary__c, Case_Resolution__c, date_of_complaint__c, Date_of_Grievance__c, Needs_approval_from_director__c FROM Case WHERE Id = :parentId];
            
            caseCreate.Communication_Type__c = parentCase.Communication_Type__c;
            caseCreate.Interaction_Mode__c = parentCase.Interaction_Mode__c;
            caseCreate.Nature_of_Request__c = parentCase.Nature_of_Request__c;
            caseCreate.Priority = parentCase.Priority;
            
        
            if(pType != 'Multiple Request'){
                caseCreate.Request_for_L1__c = parentCase.Request_for_L1__c;
                caseCreate.Request_for_L2__c = parentCase.Request_for_L2__c;
                OnL1Change();
            }
            caseCreate.Case_Summary__c = parentCase.Case_Summary__c;
            caseCreate.Case_Resolution__c = parentCase.Case_Resolution__c;
            
            caseCreate.date_of_complaint__c = parentCase.date_of_complaint__c;
            caseCreate.date_of_grievance__c = parentCase.date_of_grievance__c;
            caseCreate.Needs_approval_from_director__c = parentCase.Needs_approval_from_director__c;
            
            //for welcome call on oppty
            if(parentCase.Related_Booking__c != null ){
                caseCreate.Related_Booking__c=parentCase.Related_Booking__c;
                flatNo=parentCase.Related_Booking__r.Oasys_Flat_Code__c;
            }
        }
        
        recTypeActionItemId = [SELECT Id,Name FROM RecordType WHERE Name = 'CM_Action_Item' LIMIT 1].Id;        
        recTypeChildCaseId = [SELECT Id,Name FROM RecordType WHERE Name = 'CM_Child_Case' LIMIT 1].Id;
        
    }
    
    public void InitMethod(){
        
        secChild = true;
        secCtype1 = false;
        secCtype2 = false;
        InitRerenderMethod(); //AKG
        InitL3RerenderMethod();
    
    }
    
    public void InitL3RerenderMethod(){
        isL3a = false;
        isL3b = false;    
    }
    
    public void OnL1Change(){
    
        casecreate.Request_for_L2__c = null;
        casecreate.Request_For_L3_a__c = null;
        casecreate.Request_For_L3__c = null;
    
        InitL3RerenderMethod();    
    
        // 1.1 Asmita
        if(caseCreate.Request_for_L1__c == 'Collections Related' || caseCreate.Request_for_L1__c == 'Collections Related - SDR' || caseCreate.Request_for_L1__c == 'Document Related' || caseCreate.Request_for_L1__c == 'Legal case' || caseCreate.Request_for_L1__c == 'Customer Service' || caseCreate.Request_for_L1__c == 'DND' || caseCreate.Request_for_L1__c == 'Legal Notice' || caseCreate.Request_for_L1__c == 'Police Complaint' || caseCreate.Request_for_L1__c == 'Payment Related' || caseCreate.Request_for_L1__c == 'Updation of info on systems'){
            isL3a = true; 
            isL3b = false;
        }
        if(caseCreate.Request_for_L1__c != 'Collections Related' && caseCreate.Request_for_L1__c != 'Collections Related - SDR' && caseCreate.Request_for_L1__c != 'Document Related' && caseCreate.Request_for_L1__c != 'Legal case' && caseCreate.Request_for_L1__c != 'Customer Service' && caseCreate.Request_for_L1__c != 'DND' && caseCreate.Request_for_L1__c != 'Legal Notice' && caseCreate.Request_for_L1__c != 'Police Complaint' && caseCreate.Request_for_L1__c != 'Payment Related' && caseCreate.Request_for_L1__c != 'Updation of info on systems'){
            isL3b = true; 
            isL3a = false; 
        }
        //Siddharth 1.2
        this.InitRerenderMethod();        
    }
    
    public void InitRerenderMethod(){
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
        isOffers = false;
        isPayment_schedule = false;
        isClient_will_pay_by_self = false;

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
        isWelcomeCallReject = false;
        isNo_Bank_loan_due_to_poor_eligibility = false;
        isClient_wants_to_read_draft_AFS_at_HO = false;
        isClient_wants_draft_agreement_to_be_sent = false;
        isRequest_for_delay_in_registration = false;
        isRequest_for_rescheduling_of_registration = false;

        isReasonForRejectionOfCustomerCareMarketingEvent = false;
        isReasonForRejectionOfLoyaltyReferrals= false;
        isReasonForNonPayment= false;
        isReasonForRejectionOfMyGainFacility = false;
        // 1.1 Asmita
        isCall_Back_Later = false;
        isWants_More_Info_from_Sales = false;
        isCustomer_asked_for_more_time_to_confirm = false;
        isaccepted_DateOfInvitation_Dateof_visit = false;
        isReasonForNonPaymentSdr = false;
        
        //Siddharth 1.2
        isCampaign = false;        
    }
    
    // 1.1 Asmita
    public void onChange(){
      
      /****Start Changes: Anupam 1.7***/
      if(!Test.isRunningTest())
      {
        isL3a = ApexPages.currentPage().getParameters().containsKey('L2A');
        isL3b = ApexPages.currentPage().getParameters().containsKey('L2B');
      }
      
      casecreate.Request_For_L3_a__c = ApexPages.currentPage().getParameters().containsKey('L3Avalues') ?
                        ApexPages.currentPage().getParameters().get('L3Avalues') :
                        casecreate.Request_For_L3_a__c; 
      casecreate.Request_For_L3__c = ApexPages.currentPage().getParameters().containsKey('L3Bvalues') ?
                       ApexPages.currentPage().getParameters().get('L3Bvalues'):
                       casecreate.Request_For_L3__c;
       
      System.debug('--------before--isL3a------------------'+isL3a);  
      System.debug('--------before--isL3b------------------'+isL3b);                
      //isL3a = casecreate.Request_For_L3_a__c != null;
      //isL3b = casecreate.Request_For_L3__c != null;
      
      System.debug('--------after--isL3a------------------'+(casecreate.Request_For_L3_a__c != null));  
      System.debug('--------after--isL3b------------------'+(casecreate.Request_For_L3__c != null));  
      /****End Changes: Anupam 1.7***/
      
      
      
      if(isL3a)
        casecreate.Request_For_L3__c = null;
        else if(isL3b)
          casecreate.Request_For_L3_a__c = null;
      System.debug('-------casecreate.Request_For_L3__c-----------------'+casecreate.Request_For_L3__c);  
      if(!String.isBlank(casecreate.Request_For_L3_a__c) && casecreate.Request_for_L3_a__c != null){
          InitRerenderMethod();
          
          isPick_up_to_be_arranged = casecreate.Request_for_L3_a__c.contains('Pick up to be arranged') ? true : false; 
          isClient_will_pay_by_self = casecreate.Request_for_L3_a__c.contains('Client will pay by self') ? true : false;
          isPayment_will_come_from_bank = casecreate.Request_for_L3_a__c.contains('Payment will come from bank') ? true : false; 
          isOnline_payment_not_reflecting = casecreate.Request_for_L3_a__c.contains('Online payment not reflecting') ? true : false; 
          isDropped_at_site = casecreate.Request_for_L3_a__c.contains('Dropped at site') ? true : false; 
          isHanded_over_to_Channel_Partner = casecreate.Request_for_L3_a__c.contains('Handed over to Channel Partner') ? true : false;
          //isHanded_over_to_Channel_Partner = casecreate.Request_for_L3_a__c.contains('Handed over to Channel Partner') ? true : false;
          isReasonForNonPayment = casecreate.Request_for_L3_a__c.contains('Reasons for non pymnt(CV, ST, Interest)') || casecreate.Request_for_L3_a__c.contains('Reasons for non pymnt(SDR Payments)') ? true : false;
          //isReasonForNonPaymentSdr = casecreate.Request_for_L3_a__c.contains('Reasons for non pymnt(SDR Payments)') ? true : false;
          isIn_transit_courier = casecreate.Request_for_L3_a__c.contains('In transit - courier') ? true : false; 
      }
      else if(!String.isBlank(casecreate.Request_For_L3__c) && casecreate.Request_for_L3__c != null){
          InitRerenderMethod();
          
          isWelcomeCallReject = casecreate.Request_for_L3__c.contains('Welcome Call reject') ? true : false;
          isCustomer_asked_for_more_time_to_confirm = casecreate.Request_for_L3__c.contains('Customer asked for more time to confirm') ? true : false;
          isCustomer_contesting_a_clause = casecreate.Request_for_L3__c.contains('Customer contesting a clause') ? true : false;
          isClient_wants_to_read_draft_AFS_at_HO = casecreate.Request_for_L3__c.contains('Client wants to read draft AFS at HO') ? true : false;
          isClient_wants_draft_agreement_to_be_sent = casecreate.Request_for_L3__c.contains('Client wants draft agreement to be sent') ? true : false;
          isConfirm_Time_place_of_Registration = casecreate.Request_for_L3__c.contains('Confirm Time & place of Registration') ? true : false;
          isRequest_for_delay_in_registration = casecreate.Request_for_L3__c.contains('Request for delay in registration') ? true : false;
          isRequest_for_rescheduling_of_registration = casecreate.Request_for_L3__c.contains('Request for rescheduling of registration') ? true : false;
          //isPick_up_to_be_arranged = casecreate.Request_for_L3__c.contains('Pick up to be arranged') ? true : false;
          //isClient_will_pay_by_self = casecreate.Request_for_L3__c.contains('Client will pay by self') ? true : false;
          //isPayment_will_come_from_bank = casecreate.Request_for_L3__c.contains('Payment will come from bank') ? true : false; 
            //isOnline_payment_not_reflecting = casecreate.Request_for_L3__c.contains('Online payment not reflecting') ? true : false; 
            //isDropped_at_site = casecreate.Request_for_L3__c.contains('Dropped at site') ? true : false; 
            //isHanded_over_to_Channel_Partner = casecreate.Request_for_L3__c.contains('Handed over to Channel Partner') ? true : false; 
            //isIn_transit_courier = casecreate.Request_for_L3__c.contains('In transit - courier') ? true : false; 
            isCSS_or_CES = casecreate.Request_for_L3__c.contains('CSS or CES') ? true : false; 
            isAny_other_product = casecreate.Request_for_L3__c.contains('Any other product') ? true : false; 
            isAlready_onboard = casecreate.Request_for_L3__c.contains('Already onboard') ? true : false; 
            isDemise_in_the_family = casecreate.Request_for_L3__c.contains('Demise in the family') ? true : false;
            isFinancial_constraints = casecreate.Request_for_L3__c.contains('Financial constraints') ? true : false;
            isFinds_competitor_property_attractive = casecreate.Request_for_L3__c.contains('Finds competitor property attractive') ? true : false;
            isLack_of_Approvals = casecreate.Request_for_L3__c.contains('Lack of Approvals') ? true : false;
            isMedical_reasons = casecreate.Request_for_L3__c.contains('Medical reasons') ? true : false;
            isNo_Bank_loan_due_to_poor_eligibility = casecreate.Request_for_L3__c.contains('No Bank loan due to poor eligibility') ? true : false;
            isMiscommunication_at_the_time_of_sale = casecreate.Request_for_L3__c.contains('Miscommunication at the time of sale') ? true : false;
            isBeyond_CC_process_policy = casecreate.Request_for_L3__c.contains('Beyond CC process/policy') ? true : false; 
            isProduct_deviation_required = casecreate.Request_for_L3__c.contains('Product deviation required') ? true : false;
            isProduct_issue_client_in_disagreement = casecreate.Request_for_L3__c.contains('Product issue - client in disagreement') ? true : false;
            isInventory_change_required = casecreate.Request_for_L3__c.contains('Inventory change required') ? true : false; 
            isCC_Process_deviation_required = casecreate.Request_for_L3__c.contains('CC Process deviation required') ? true : false; 
            isManagement_deviation_required = casecreate.Request_for_L3__c.contains('Management deviation required') ? true : false; 
            isSelf_funding_needs_more_time = casecreate.Request_for_L3__c.contains('Self funding - needs more time') ? true : false;
            isArranging_for_a_home_loan = casecreate.Request_for_L3__c.contains('Arranging for a home loan') ? true : false;
            isProduct_issue_client_in_disagreement = casecreate.Request_for_L3__c.contains('Product issue - client in disagreement') ? true : false;
            isPricing = casecreate.Request_for_L3__c.contains('Pricing') ? true : false;
            isPayment_schedule = casecreate.Request_for_L3__c.contains('Payment schedule') ? true : false;
            
            //isVehicle_slots = casecreate.Request_for_L3__c.contains('Vehicle Slots') && !casecreate.Request_for_L1__c.equalsIgnoreCase('Possessions Related') ? true : false;
            //isApprovals = casecreate.Request_for_L3__c.contains('Approval') && !casecreate.Request_for_L3__c.contains('Lack of Approvals') && !casecreate.Request_for_L3__c.contains('Statutory Compliance (OC / Approvals)') ? true : false;
            //Anupam 1.7
            String strL2Value = ApexPages.currentPage().getParameters().get('L2B') ;
            if(!ApexPages.currentPage().getParameters().containsKey('L2B'))
              strL2Value = casecreate.Request_for_L2__c;
            isVehicle_slots = !strL2Value.contains('Post-possession') && casecreate.Request_for_L3__c.contains('Vehicle Slots'); 
            //Anupam 1.7
            isApprovals = !casecreate.Request_for_L3__c.contains('Statutory Compliance (OC / Approvals)') && casecreate.Request_for_L3__c.contains('Approval') && !casecreate.Request_for_L3__c.contains('Lack of Approvals') ? true : false;
            
            isInventory = casecreate.Request_for_L3__c.contains('Inventory') && !casecreate.Request_for_L3__c.contains('Inventory change required') ? true : false;
            isLoan_eligibility = casecreate.Request_for_L3__c.contains('Loan eligibility') ? true : false;
            isOffers = casecreate.Request_for_L3__c.contains('Offers') ? true : false; 
            isPossession_timelines = casecreate.Request_for_L3__c.contains('Possession Timelines') ? true : false;
            isLocation_Product = casecreate.Request_for_L3__c.contains('Location/Product') ? true : false; 
            isCall_Back_Later = casecreate.Request_for_L3__c.contains('Call Back Later') ? true : false;
            isWants_More_Info_from_Sales = casecreate.Request_for_L3__c.contains('Wants More Info From Sales') ? true : false;
            //isReasonForNonPayment = casecreate.Request_for_L3__c.contains('Reasons for non pymnt(SDR Payments)') ? true : false;
            isDue_to_possession_timelines = casecreate.Request_for_L3__c.contains('Due to possession timelines') ? true : false; 
            isPayment_deviation_required = casecreate.Request_for_L3__c.contains('Payment deviation required') ? true : false;
            
            //Siddharth 1.2
            isCampaign = strL2Value.equalsIgnoreCase('Loyalty campaign/Referrals - Pre launch') && (casecreate.Request_for_L3__c.contains('Wants for self - Date of visit to site') || casecreate.Request_for_L3__c.contains('Rejected - Reason') || casecreate.Request_for_L3__c.contains('Wants more time to confirm') || casecreate.Request_for_L3__c.contains('Given another reference') || casecreate.Request_for_L3__c.contains('Customer does not wish to be contacted') || casecreate.Request_for_L3__c.contains('Call Back Later') || casecreate.Request_for_L3__c.contains('Wants More Info From Sales')) ? true : false;
      
        /****Start Changes: Anupam 1.3***/
            isaccepted_DateOfInvitation_Dateof_visit = casecreate.Request_for_L3__c.contains('Accepted the invitation- Date of visit');
      
            //isReasonForRejectionOfLoyaltyReferrals= casecreate.Request_for_L3__c.contains('Rejected - Reason'); 

           // isReasonForRejectionOfMyGainFacility = casecreate.Request_for_L3__c.contains('Rejected - Reason') || 
                                                  // casecreate.Request_for_L3__c.contains('Event Rejected Reason');
                                                  
             /* 2.0 -  Deepakpudi */                                      
            isReasonForRejectionOfMyGainFacility =  strL2Value.contains('MyGain facility/ADF facility/Amnesty/Dollar product/Home loan interest offer')
                                                 &&(casecreate.Request_for_L3__c.contains('Rejected - Reason') || 
                          							casecreate.Request_for_L3__c.contains('Event Rejected Reason'));
            isReasonForRejectionOfLoyaltyReferrals = (strL2Value.contains('Loyalty campaign/Referrals - Pre launch')||
 													  strL2Value.contains('Loyalty campaign/Referrals - Post launch')||
													  strL2Value.contains('Loyalty campaign/Referrals - Post possession'))
												   &&(casecreate.Request_for_L3__c.contains('Rejected - Reason') || 
                                					 casecreate.Request_for_L3__c.contains('Event Rejected Reason')); 
            isReasonForRejectionOfCustomerCareMarketingEvent = (strL2Value.contains('Customer Care event')||strL2Value.contains('Marketing event'))
		   													&& (casecreate.Request_for_L3__c.contains('Rejected - Reason') || 
               													casecreate.Request_for_L3__c.contains('Event Rejected Reason'));
            isGiven_another_reference = casecreate.Request_for_L3__c.contains('Given another reference');       
            isCustomer_does_not_wish_to_be_contacted = casecreate.Request_for_L3__c.contains('Customer does not wish to be contacted');
            isWants_for_self_Date_of_visit_to_site = casecreate.Request_for_L3__c.contains('Wants for self - Date of visit to site');  
            isAccepted_Date_of_payment_Amount = casecreate.Request_for_L3__c.contains('Accepted - Date of payment & Amount');     
            /****End Changes Anupam: 1.3***/
      }
      else{
          InitRerenderMethod();
      }
    }
    
    public void Back(){
        InitMethod();  
    }
    
    public void ChildCase(){
    
        if(subCaseType == 'Action Item'){
            secChild = false;
            secCtype1 = true;
            secCtype2 = false;
        }else if(subCaseType == 'Child Case'){
            secChild = false;
            secCtype1 = false;
            secCtype2 = true;
        }
    
    }
    
    public List<SelectOption> getccTypes() {
        List<SelectOption> options = new List<SelectOption>(); 
        
        if(pType == 'Multiple Request'){
            //options.add(new SelectOption('Action Item','Create Action Item')); 
            options.add(new SelectOption('Child Case','Create Child Case')); 
        }else{
            options.add(new SelectOption('Action Item','Create Action Item')); 
        }
        return options; 
    }
    
    public List<SelectOption> getsQueue() {
        
        //spocQueue = [SELECT Id, Name, QueueId__c FROM Queue_Configuration__c WHERE Queue_Type__c = 'SPOC'];
        
        spocQueue = [SELECT Id, Name, QueueId__c FROM Queue_Configuration__c];
        
        List<SelectOption> options = new List<SelectOption>(); 
        
        for(Queue_Configuration__c sq : spocQueue){
            if((sq.QueueId__c != null || sq.QueueId__c != null) && (sq.Name != null || sq.Name != null)) {  
                options.add(new SelectOption(sq.QueueId__c,sq.Name)); 
            }
        }
        return options;
    }
    
    public List<SelectOption> getfQueue() {
        
        ftQueue = [SELECT Id, Name, QueueId__c FROM Queue_Configuration__c WHERE Queue_Type__c = 'FT'];
        List<SelectOption> options = new List<SelectOption>(); 
        
        for(Queue_Configuration__c fq : ftQueue){
            if((fq.QueueId__c != null || fq.QueueId__c != null) && (fq.Name != null || fq.Name != null)) {  
                options.add(new SelectOption(fq.QueueId__c,fq.Name)); 
            }
        }
        return options;
    }
    
    public pageReference SaveActionItem(){
        
        try {
            
            if(subCaseType == 'Action Item'){
                
                caseCreate.SubCaseType__c = 'Action Item';    
                
            }else{
                caseCreate.SubCaseType__c = 'Child Case';
            }
            
            caseCreate.CaseType__c = 'Action Item';
            caseCreate.ParentId = parentId;
            caseCreate.OwnerId = spocQueueId;
            caseCreate.RecordTypeId = recTypeActionItemId;
                    
                    
            
            Insert caseCreate;
            
            pageReference pageRef = new pageReference('/'+parentId);        
            return pageRef;

        
        } catch(Exception e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
            ApexPages.addMessages(e);
        }
        
        //pageReference pageRef = new pageReference('/'+parentId);        
        //return pageRef;
        return null;
        
    }
    
    public pageReference SaveChildCase(){
        
        try {
        
            if(subCaseType == 'Action Item'){
                
                caseCreate.SubCaseType__c = 'Action Item';    
                
            }else{
                caseCreate.SubCaseType__c = 'Child Case';
            }
            
            caseCreate.CaseType__c = 'Child Case';
            caseCreate.ParentId = parentId;
            caseCreate.OwnerId = ftQueueId;
            caseCreate.RecordTypeId = recTypeChildCaseId;
            
            Insert caseCreate;
            
            pageReference pageRef = new pageReference('/'+parentId);        
            return pageRef;

            
        } catch(Exception e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
             ApexPages.addMessages(e);
        }
        
        //pageReference pageRef = new pageReference('/'+parentId);        
        //return pageRef;
        
        return null;
    }
    
    public pageReference CreateSubCase(){
        
        try {
        
            if(subCaseType == 'Action Item'){
                
                caseCreate.SubCaseType__c = 'Action Item';
                caseCreate.CaseType__c = 'Action Item'; 
                caseCreate.OwnerId = spocQueueId;
                caseCreate.RecordTypeId = recTypeActionItemId;   
                
            }else{
                caseCreate.SubCaseType__c = 'Child Case';
                caseCreate.CaseType__c = 'Child Case';
                caseCreate.OwnerId = ftQueueId;
                caseCreate.RecordTypeId = recTypeChildCaseId;
            }
            
            caseCreate.ParentId = parentId;
            Insert caseCreate;
            
        } catch(Exception e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
            ApexPages.addMessages(e);
            return null;    //Siddharth 1.4
        }
        
        PageReference pageRef = ApexPages.currentPage();
        System.debug('@@@@@@@@@@@@@@@@@@@@@' + pageRef);
        pageRef.setRedirect(true);
        return pageRef;
         
    }    
    
    public pageReference CancelReq(){
        
        if(sparentId != null && sparentId != ''){
            pageReference pageRef = new pageReference('/'+sparentId); 
            return pageRef;       
        }else{
            InitMethod();
            return null;
        }
        
    }
   
    //Siddharth 1.2
    public void OnL2Change(){
        this.InitRerenderMethod();
    }    
}