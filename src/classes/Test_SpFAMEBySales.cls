@isTest(seealldata=true)

Public class Test_SpFAMEBySales{

Public static Booking_Information__c Book;
Public static Booking_Information__c Book1;
Public static flat__c flat;
Public static FAME_By_Sales__c fame;
Public static Task fametask;

Public static void Test_SpFAMEBySales(){
    Book=[SELECT Address1__c,Flat__r.Status__c,Address2__c,Address3__c,Applicable_Waiver_Sq_ft_Actual_Rs__c,Applicable_Waiver_Sq_ft_Rs__c,Application_Date__c,Approval_sought__c,Approver_s_name__c,Base_Rate_Sq_ft_Actual_Rs__c,Base_Rate_Sq_ft_Rs__c,Block_Date__c,Block_Detail__c,Block_For_Days__c,Block_For_Minutes__c,Block_For__c,Block_Period__c,Block_Sales_Person_Email__c,Block_Sales_Person__c,Booking_By__c,Booking_Date__c,Booking_Remark__c,Booking_Status__c,Cancellation_Date__c,Cancellation_Type__c,Cancel_Confirm_Date__c,Cash_Rs__c,Cheque_Details__c,Cheque_Rs__c,City_of_Co_applicant__c,City__c,Club_charges_Actual_Rs__c,Club_charges_Incl_in_CV__c,Club_charges_Rs__c,COAPPLICANT_RELATIONSHIP__c,Confirmation_Date__c,Confirmation_Remark__c,Confirm_Date__c,Consideration_Actual_Rs__c,Consideration_Rs__c,Contact_Nos__c,Corporate_connection__c,Country_of_Applicant__c,Country_of_Co_applicant__c,CreatedById,CreatedDate,Credit_Card_Details__c,Credit_Card_Rs__c,CRN_Number_SAP__c,CRN__c,CurrencyIsoCode,Customer_Type__c,Name_Of_Opportunity__r.Project__r.name,DAM_Offer_Sq_ft_Actual_Rs__c,DAM_Offer_Sq_ft_Rs__c,Date_of_First_Visit__c,DifferenceBasePrice__c,DifferenceTotalRate__c,Email__c,Flat_Cost_Actual_Rs__c,Flat_Cost_Rs__c,Flat__c,Floor_rise_Sq_ft_Actual_Rs__c,Floor_rise_Sq_ft_Rs__c,Has_retention_efforts_been_carried_out__c,has_the_customer_initiated_deed_of_cance__c,Id,InActive__c,Infrastructure2_Incl_in_CV__c,Infrastructure_Cost_2Actual_Rs__c,Infrastructure_Cost_2_Rs__c,Infrastructure_Cost_Actual_Rs__c,Infrastructure_Cost_Rs__c,Infrastructure_Incl_in_CV__c,IsDeleted,isSP2__c,Is_the_customer_registered__c,LastActivityDate,LastModifiedById,LastModifiedDate,Loyalty_Id__c,Loyalty_Source_Id__c,Name,Name_of_Applicant__c,Name_Of_Opportunity__c,Oasys_Flat_Code__c,Other_Details__c,Other_Rs__c,OwnerId,PAN_Number_of_Applicant__c,PAN_Number_of_Co_Applicant__c,Parking_Nos_2W__c,Parking_Nos_4w__c,Parking_Type__c,Pincode__c,Premium_Sq_ft_Actual_Rs__c,Premium_Sq_ft_Rs__c,Project_Hidden__c,Project_Type_Hidden__c,Reap_ID_New__c,Reap_Id__c,Reason_for_Cancellation__c,Reason_for_Discount__c,Referral_CRN__c,Related_Comments__c,Remarks__c,Result_of_retention_efforts__c,SALESORDER_NO__c,Sales_Person__c,Sales_Strategist_Hidden__c,Sales_Strategist__c,SCUD_Follow_up_comments__c,SCUD_Related_Comments__c,Secondary_Applicant__c,Selected_discount_type__c,Site_Incharge_hidden__c,Site_Incharge__c,SO_Creation_Date_time__c,SO_Status__c,Submit_Date__c,SystemModstamp,Title_of_Applicant__c,Title_of_Co_Applicant__c,TobeBasePrice__c,Total_Actual_Base_Rate__c,Total_Base_Rate__c,Total_Rate_Sq_ft_Actual_Rs__c,Total_Rate_Sq_ft_Rs__c,Total__c,Unique_booking_Id__c,Visitor_Form_No__c FROM Booking_Information__c WHERE Booking_Status__c='SOLD' AND Name_Of_Opportunity__c != null AND Name_Of_Opportunity__r.stagename!='Closed Lost' limit 1];
    Book.Booking_Status__c='BOOKING';
    update Book;
    
    flat=[select id,Status__c,ProjectName__c,Oasys_Flat_code__c from flat__c where Oasys_Flat_code__c=:Book.Oasys_Flat_code__c];
    flat.Status__c='BOOKING';
    update flat;
    
    String uniqueKey = 'FAME' + flat.Flat_no_text__c + string.valueof(book.Id);
    
    fame= new FAME_By_Sales__c(Booking_Information__c=Book.Id,FAME_Status__c='Accept',Unique_key__c = uniqueKey);
    insert fame;
    
    system.debug('@@@@@@@@@@@@@Fame'+fame);
    
    fametask= new Task(Description = 'FAMEbysales Initiated',RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Fame Task').getRecordTypeId(),Priority = 'Normal', Status = 'Under Action by Me', Subject = 'FAME Initiated - ' + book.Oasys_Flat_Code__c,IsReminderSet = true,ReminderDateTime = System.now()+6,ActivityDate = date.today()+7,OwnerId = userinfo.getuserid(),WhatId =  fame.Id,FAME_CHECKLIST_Page_URL__c ='TestUrl');
    insert fametask;
}

Public Testmethod static void Test_SpFAMEBySales_one(){    
    Test_SpFAMEBySales.Test_SpFAMEBySales();
    PageReference ref = new PageReference('/apex/SpFAMEApproval');
    Test.setCurrentPage(ref);
    ref.getParameters().put('booking',Book.Id);
    ApexPages.currentPage().getHeaders().put('Host', 'testFAME');
    
    ApexPages.StandardController controller=new ApexPages.StandardController(fame);
    SpFAMEBySales SpFame=new  SpFAMEBySales(controller);    
    SpFame.fame.FAME_Status__c='';
    SpFame.hold();
    SpFame.save();
    
    
    Book1=[SELECT Address1__c,Flat__r.Status__c,Address2__c,Address3__c,Applicable_Waiver_Sq_ft_Actual_Rs__c,Applicable_Waiver_Sq_ft_Rs__c,Application_Date__c,Approval_sought__c,Approver_s_name__c,Base_Rate_Sq_ft_Actual_Rs__c,Base_Rate_Sq_ft_Rs__c,Block_Date__c,Block_Detail__c,Block_For_Days__c,Block_For_Minutes__c,Block_For__c,Block_Period__c,Block_Sales_Person_Email__c,Block_Sales_Person__c,Booking_By__c,Booking_Date__c,Booking_Remark__c,Booking_Status__c,Cancellation_Date__c,Cancellation_Type__c,Cancel_Confirm_Date__c,Cash_Rs__c,Cheque_Details__c,Cheque_Rs__c,City_of_Co_applicant__c,City__c,Club_charges_Actual_Rs__c,Club_charges_Incl_in_CV__c,Club_charges_Rs__c,COAPPLICANT_RELATIONSHIP__c,Confirmation_Date__c,Confirmation_Remark__c,Confirm_Date__c,Consideration_Actual_Rs__c,Consideration_Rs__c,Contact_Nos__c,Corporate_connection__c,Country_of_Applicant__c,Country_of_Co_applicant__c,CreatedById,CreatedDate,Credit_Card_Details__c,Credit_Card_Rs__c,CRN_Number_SAP__c,CRN__c,CurrencyIsoCode,Customer_Type__c,Name_Of_Opportunity__r.Project__r.name,DAM_Offer_Sq_ft_Actual_Rs__c,DAM_Offer_Sq_ft_Rs__c,Date_of_First_Visit__c,DifferenceBasePrice__c,DifferenceTotalRate__c,Email__c,Flat_Cost_Actual_Rs__c,Flat_Cost_Rs__c,Flat__c,Floor_rise_Sq_ft_Actual_Rs__c,Floor_rise_Sq_ft_Rs__c,Has_retention_efforts_been_carried_out__c,has_the_customer_initiated_deed_of_cance__c,Id,InActive__c,Infrastructure2_Incl_in_CV__c,Infrastructure_Cost_2Actual_Rs__c,Infrastructure_Cost_2_Rs__c,Infrastructure_Cost_Actual_Rs__c,Infrastructure_Cost_Rs__c,Infrastructure_Incl_in_CV__c,IsDeleted,isSP2__c,Is_the_customer_registered__c,LastActivityDate,LastModifiedById,LastModifiedDate,Loyalty_Id__c,Loyalty_Source_Id__c,Name,Name_of_Applicant__c,Name_Of_Opportunity__c,Oasys_Flat_Code__c,Other_Details__c,Other_Rs__c,OwnerId,PAN_Number_of_Applicant__c,PAN_Number_of_Co_Applicant__c,Parking_Nos_2W__c,Parking_Nos_4w__c,Parking_Type__c,Pincode__c,Premium_Sq_ft_Actual_Rs__c,Premium_Sq_ft_Rs__c,Project_Hidden__c,Project_Type_Hidden__c,Reap_ID_New__c,Reap_Id__c,Reason_for_Cancellation__c,Reason_for_Discount__c,Referral_CRN__c,Related_Comments__c,Remarks__c,Result_of_retention_efforts__c,SALESORDER_NO__c,Sales_Person__c,Sales_Strategist_Hidden__c,Sales_Strategist__c,SCUD_Follow_up_comments__c,SCUD_Related_Comments__c,Secondary_Applicant__c,Selected_discount_type__c,Site_Incharge_hidden__c,Site_Incharge__c,SO_Creation_Date_time__c,SO_Status__c,Submit_Date__c,SystemModstamp,Title_of_Applicant__c,Title_of_Co_Applicant__c,TobeBasePrice__c,Total_Actual_Base_Rate__c,Total_Base_Rate__c,Total_Rate_Sq_ft_Actual_Rs__c,Total_Rate_Sq_ft_Rs__c,Total__c,Unique_booking_Id__c,Visitor_Form_No__c FROM Booking_Information__c WHERE id=:fame.Booking_Information__c];
        
    if(Book1.Booking_By__c =='referral' || Book1.Booking_By__c =='self-referral'){
        Book1.Booking_By__c=null;
    }
    else{

    }
    
    if(Book1.Customer_Type__c=='Corporate'){
        Book1.Customer_Type__c =null;
    }
    else{
        Book1.Customer_Type__c='Corporate';
    }
    
    If( book1.Selected_discount_type__c != 'DAM' && book1.Selected_discount_type__c != 'SCUD'){
        Book1.Selected_discount_type__c='DAM';
    }
    else{
        
    }  
    
    Update Book1; 
      
    ref.getParameters().put('booking',Book1.Id);
    ApexPages.currentPage().getHeaders().put('Host', 'testFAME');    
    ApexPages.StandardController controller1=new ApexPages.StandardController(fame);
    SpFAMEBySales SpFame1=new SpFAMEBySales(controller1); 
    SpFame1.fame.FAME_Status__c='FAME submission';    
    SpFame1.save();  
    
    SpFame1.fame.FAME_Status__c='FAME submission';    
    SpFame1.fame.Applicant_Co_applicant_names__c =true;    
    SpFame1.fame.Inventory_not_booked_in_other_name__c =true;  
    SpFame1.fame.Booking_date_and_consideration_value__c =true;    
    SpFame1.fame.Rates_offered_wrt_applicable_price_sheet__c =true;    
    SpFame1.fame.Flat_number_typolology__c =true;    
    SpFame1.fame.Current_status_of_const_relevant_field__c =true;    
    SpFame1.fame.Booking_amount_cheque_details_Name__c =true;    
    SpFame1.fame.Sign_at_all_places_according_to_photo_id__c =true; 
    SpFame1.fame.CRN_and_date_of_application__c =true;  
    SpFame1.fame.Pricesheet_attached_signed_by_applicnt__c =true;  
    SpFame1.fame.Preferati_original_form_Card__c =true;  
    SpFame1.fame.Customer_s_ID_proof__c=true;  
    SpFame1.fame.overwriting_cancellation_white_ink_NA__c =true;  
    SpFame1.fame.Overwriting_Cancellation_White_ink_sign__c =true;  
    SpFame1.fame.Project_Type_CASA_Commercial_and_NA__c =true;  
    SpFame1.fame.Deal_Closure_Form_original_photocopy__c =true;  
    SpFame1.fame.Capture_of_Channel_Partner_Reap_ID__c =false;  
    SpFame1.fame.Reap_ID_NA__c =true;  
    SpFame1.fame.Capture_of_Channel_Partner_name__c =false;  
    SpFame1.fame.Channel_Partner_Name_NA__c =true;  
    SpFame1.fame.Booked_BY_Channel_Partner_NA__c =true;  
    SpFame1.fame.Booked_BY_Channel_Partner_NA_02__c =true;  
    SpFame1.fame.Booked_BY_Channel_Partner_NA_03__c =true;  
    SpFame1.fame.Booked_BY_Channel_Partner_NA_04__c =true;      
    
    SpFame1.save();  
    
    fame=[select id,name,FAME_Status__c from fame_by_sales__c where id=:SpFame1.fame.id];
    fame.FAME_Status__c='';
    update fame;
    
}
}