@isTest(seealldata=true)

Public class Test_SpWelcomeCallExtension{

Public static Booking_Information__c Book;
Public static Booking_Information__c Book1;
Public static flat__c flat;
Public static Welcome_Call_Details__c welcomecalldetails;
Public static FAME_By_Sales__c famebysales;
Public static FAME__c fame;
Public static Task welcomecalltask;

Public static void Test_SpWelcomeCallExtension(){
    Book=[SELECT Address1__c,Flat__r.Status__c,Address2__c,Address3__c,Applicable_Waiver_Sq_ft_Actual_Rs__c,Applicable_Waiver_Sq_ft_Rs__c,Application_Date__c,Approval_sought__c,Approver_s_name__c,Base_Rate_Sq_ft_Actual_Rs__c,Base_Rate_Sq_ft_Rs__c,Block_Date__c,Block_Detail__c,Block_For_Days__c,Block_For_Minutes__c,Block_For__c,Block_Period__c,Block_Sales_Person_Email__c,Block_Sales_Person__c,Booking_By__c,Booking_Date__c,Booking_Remark__c,Booking_Status__c,Cancellation_Date__c,Cancellation_Type__c,Cancel_Confirm_Date__c,Cash_Rs__c,Cheque_Details__c,Cheque_Rs__c,City_of_Co_applicant__c,City__c,Club_charges_Actual_Rs__c,Club_charges_Incl_in_CV__c,Club_charges_Rs__c,COAPPLICANT_RELATIONSHIP__c,Confirmation_Date__c,Confirmation_Remark__c,Confirm_Date__c,Consideration_Actual_Rs__c,Consideration_Rs__c,Contact_Nos__c,Corporate_connection__c,Country_of_Applicant__c,Country_of_Co_applicant__c,CreatedById,CreatedDate,Credit_Card_Details__c,Credit_Card_Rs__c,CRN_Number_SAP__c,CRN__c,CurrencyIsoCode,Customer_Type__c,Name_Of_Opportunity__r.Project__r.name,DAM_Offer_Sq_ft_Actual_Rs__c,DAM_Offer_Sq_ft_Rs__c,Date_of_First_Visit__c,DifferenceBasePrice__c,DifferenceTotalRate__c,Email__c,Flat_Cost_Actual_Rs__c,Flat_Cost_Rs__c,Flat__c,Floor_rise_Sq_ft_Actual_Rs__c,Floor_rise_Sq_ft_Rs__c,Has_retention_efforts_been_carried_out__c,has_the_customer_initiated_deed_of_cance__c,Id,InActive__c,Infrastructure2_Incl_in_CV__c,Infrastructure_Cost_2Actual_Rs__c,Infrastructure_Cost_2_Rs__c,Infrastructure_Cost_Actual_Rs__c,Infrastructure_Cost_Rs__c,Infrastructure_Incl_in_CV__c,IsDeleted,isSP2__c,Is_the_customer_registered__c,LastActivityDate,LastModifiedById,LastModifiedDate,Loyalty_Id__c,Loyalty_Source_Id__c,Name,Name_of_Applicant__c,Name_Of_Opportunity__c,Oasys_Flat_Code__c,Other_Details__c,Other_Rs__c,OwnerId,PAN_Number_of_Applicant__c,PAN_Number_of_Co_Applicant__c,Parking_Nos_2W__c,Parking_Nos_4w__c,Parking_Type__c,Pincode__c,Premium_Sq_ft_Actual_Rs__c,Premium_Sq_ft_Rs__c,Project_Hidden__c,Project_Type_Hidden__c,Reap_ID_New__c,Reap_Id__c,Reason_for_Cancellation__c,Reason_for_Discount__c,Referral_CRN__c,Related_Comments__c,Remarks__c,Result_of_retention_efforts__c,SALESORDER_NO__c,Sales_Person__c,Sales_Strategist_Hidden__c,Sales_Strategist__c,SCUD_Follow_up_comments__c,SCUD_Related_Comments__c,Secondary_Applicant__c,Selected_discount_type__c,Site_Incharge_hidden__c,Site_Incharge__c,SO_Creation_Date_time__c,SO_Status__c,Submit_Date__c,SystemModstamp,Title_of_Applicant__c,Title_of_Co_Applicant__c,TobeBasePrice__c,Total_Actual_Base_Rate__c,Total_Base_Rate__c,Total_Rate_Sq_ft_Actual_Rs__c,Total_Rate_Sq_ft_Rs__c,Total__c,Unique_booking_Id__c,Visitor_Form_No__c FROM Booking_Information__c WHERE Booking_Status__c='SOLD' AND Name_Of_Opportunity__c != null AND Name_Of_Opportunity__r.stagename!='Closed Lost' limit 1];
    Book.Booking_Status__c='BOOKING';
    update Book;
    
    flat=[select id,Status__c,ProjectName__c,Oasys_Flat_code__c from flat__c where Oasys_Flat_code__c=:Book.Oasys_Flat_code__c];
    flat.Status__c='BOOKING';
    update flat;
    
    String uniqueKey = 'FAME' + flat.Flat_no_text__c + string.valueof(book.Id);
    
    famebysales = new FAME_By_Sales__c(Sales_Manager_User__c=Userinfo.getuserId(),Booking_Information__c=Book.Id,FAME_Status__c='Accept',Unique_key__c = uniqueKey);
    insert famebysales;
    
    fame = new FAME__c(Channel_Partner_Name__c=null,Channel_Partner_Name_NA__c=true,Booking_Information__c=Book.Id,FAME_Status__c='Accept',Unique_key__c = uniqueKey);
    insert fame;
    
    welcomecalldetails = new Welcome_Call_Details__c(Booking_Information__c=Book.Id,IsSubmitted_By_PI__c=false,IsSubmitted_By_RM__c=false);
    insert welcomecalldetails;
    
    system.debug('@@@@@@@@@@@@@Fame'+fame);  
    system.debug('@@@@@@@@@@@@@Famebysales'+famebysales);         
    
    welcomecalltask= new Task(Description = 'Welcomecall Initiated',RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Welcome Call Task').getRecordTypeId(),Priority = 'Normal', Status = 'Under Action by Me', Subject = 'Welcomecall Initiated - ' + book.Oasys_Flat_Code__c,IsReminderSet = true,ReminderDateTime = System.now()+6,ActivityDate = date.today()+7,OwnerId = userinfo.getuserid(),WhatId =  welcomecalldetails.Id,Welcome_Call_Checklist_Page_URL__c='test');
    insert welcomecalltask;
}

Public Testmethod static void Test_SpWelcomeCallExtension_one(){ 
   
    Test_SpWelcomeCallExtension.Test_SpWelcomeCallExtension();
    
    PageReference ref = new PageReference('/apex/Spwelcomecalldetails');
    ref.getParameters().put('booking',Book.Id);
    Test.setCurrentPage(ref);    
    ApexPages.currentPage().getHeaders().put('Host', 'testWelcomecalldetails');
    
    ApexPages.StandardController controller=new ApexPages.StandardController(welcomecalldetails);
    SpWelcomeCallExtension Spwelcomecall=new SpWelcomeCallExtension (controller);  
    
    Spwelcomecall.welcomecall.IsSubmitted_By_RM__c =true;
    Spwelcomecall.hold();
    
    Spwelcomecall.welcomecall.IsSubmitted_By_RM__c =false;
    Spwelcomecall.hold();
    
    Spwelcomecall.welcomecall.Telephone_Number__c='3333';
    Spwelcomecall.hold();
    
    Spwelcomecall.submit();
    
    Spwelcomecall.welcomecall.Expected_Date_of_start_of_fit_outs__c=date.today();
    Spwelcomecall.submit();
    
    Spwelcomecall.welcomecall.Primary_Applicant_s_Name__c ='test';
    Spwelcomecall.welcomecall.Telephone_Number__c ='333333';
    Spwelcomecall.welcomecall.Email_address__c ='test@gmail.com';
    Spwelcomecall.welcomecall.Title_of_Applicant__c='Mr.';
    Spwelcomecall.welcomecall.Address_Line_1__c='test';
    Spwelcomecall.welcomecall.Address_Line_2__c='test';
    Spwelcomecall.welcomecall.Address_Line_3__c='test';
    Spwelcomecall.welcomecall.City_of_Applicant__c='test';
    Spwelcomecall.welcomecall.Pin_code__c='333445';
    Spwelcomecall.welcomecall.Country_of_Applicant__c='test';
    Spwelcomecall.welcomecall.Address_Line_3__c='test';
    Spwelcomecall.welcomecall.Address_Line_3__c='test';    
    Spwelcomecall.submit();
    
    Spwelcomecall.welcomecall.Co_Applicant_s_Name__c  ='test';
    Spwelcomecall.welcomecall.Country_of_Co_applicant__c='4444333333';
    Spwelcomecall.welcomecall.City_of_Co_applicant__c='test@gmail.com';
    Spwelcomecall.welcomecall.Title_of_Co_Applicant__c='Mr.';
    Spwelcomecall.welcomecall.Relationship_of_Co_Applicant_New__c   ='test';   
    Spwelcomecall.submit();
    
    Spwelcomecall.welcomecall.Telephone_Number__c ='4534545656';    
    Spwelcomecall.submit();
    
}
}