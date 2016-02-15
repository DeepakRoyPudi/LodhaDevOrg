@isTest(seealldata=true)

Public class Test_CancellationController{

Public static Booking_Information__c Book;
Public static flat__c flat;
Public static Welcome_Call_Details__c welcomecalldetails;
Public static Welcome_Call_CheckList__c welcomecallchecklist;
Public static SOCreation__c SoChecklist;
Public static FAME_By_Sales__c famebysales;
Public static FAME__c fame;
Public static Task SOtask;
Public static Task welcomeEmailtask;
Public static account BAccount;
Public static account BAccount1;
Public static account BAccount2;

Public static void Test_CancellationController(){
    Book=[SELECT Address1__c,Flat__r.Status__c,Flat__r.Wing__r.Name,Address2__c,Flat__r.Wing__r.Cluster__r.Name,Flat__r.Wing__r.Cluster__r.Project_Name__r.Name,Address3__c,Applicable_Waiver_Sq_ft_Actual_Rs__c,Applicable_Waiver_Sq_ft_Rs__c,Application_Date__c,Approval_sought__c,Approver_s_name__c,Base_Rate_Sq_ft_Actual_Rs__c,Base_Rate_Sq_ft_Rs__c,Block_Date__c,Block_Detail__c,Block_For_Days__c,Block_For_Minutes__c,Block_For__c,Block_Period__c,Block_Sales_Person_Email__c,Block_Sales_Person__c,Booking_By__c,Booking_Date__c,Booking_Remark__c,Booking_Status__c,Cancellation_Date__c,Cancellation_Type__c,Cancel_Confirm_Date__c,Cash_Rs__c,Cheque_Details__c,Cheque_Rs__c,City_of_Co_applicant__c,City__c,Club_charges_Actual_Rs__c,Club_charges_Incl_in_CV__c,Club_charges_Rs__c,COAPPLICANT_RELATIONSHIP__c,Confirmation_Date__c,Confirmation_Remark__c,Confirm_Date__c,Consideration_Actual_Rs__c,Consideration_Rs__c,Contact_Nos__c,Corporate_connection__c,Country_of_Applicant__c,Country_of_Co_applicant__c,CreatedById,CreatedDate,Credit_Card_Details__c,Credit_Card_Rs__c,CRN_Number_SAP__c,CRN__c,CurrencyIsoCode,Customer_Type__c,Name_Of_Opportunity__r.Project__c,DAM_Offer_Sq_ft_Actual_Rs__c,DAM_Offer_Sq_ft_Rs__c,Date_of_First_Visit__c,DifferenceBasePrice__c,DifferenceTotalRate__c,Email__c,Flat_Cost_Actual_Rs__c,Flat_Cost_Rs__c,Flat__c,Floor_rise_Sq_ft_Actual_Rs__c,Floor_rise_Sq_ft_Rs__c,Has_retention_efforts_been_carried_out__c,has_the_customer_initiated_deed_of_cance__c,Id,InActive__c,Infrastructure2_Incl_in_CV__c,Infrastructure_Cost_2Actual_Rs__c,Infrastructure_Cost_2_Rs__c,Infrastructure_Cost_Actual_Rs__c,Infrastructure_Cost_Rs__c,Infrastructure_Incl_in_CV__c,IsDeleted,isSP2__c,Is_the_customer_registered__c,LastActivityDate,LastModifiedById,LastModifiedDate,Loyalty_Id__c,Loyalty_Source_Id__c,Name,Name_of_Applicant__c,Name_Of_Opportunity__c,Oasys_Flat_Code__c,Other_Details__c,Other_Rs__c,OwnerId,PAN_Number_of_Applicant__c,PAN_Number_of_Co_Applicant__c,Parking_Nos_2W__c,Parking_Nos_4w__c,Parking_Type__c,Pincode__c,Premium_Sq_ft_Actual_Rs__c,Premium_Sq_ft_Rs__c,Project_Hidden__c,Project_Type_Hidden__c,Reap_ID_New__c,Reap_Id__c,Reason_for_Cancellation__c,Reason_for_Discount__c,Referral_CRN__c,Related_Comments__c,Remarks__c,Result_of_retention_efforts__c,SALESORDER_NO__c,Sales_Person__c,Sales_Strategist_Hidden__c,Sales_Strategist__c,SCUD_Follow_up_comments__c,SCUD_Related_Comments__c,Secondary_Applicant__c,Selected_discount_type__c,Site_Incharge_hidden__c,Site_Incharge__c,SO_Creation_Date_time__c,SO_Status__c,Submit_Date__c,SystemModstamp,Title_of_Applicant__c,Title_of_Co_Applicant__c,TobeBasePrice__c,Total_Actual_Base_Rate__c,Total_Base_Rate__c,Total_Rate_Sq_ft_Actual_Rs__c,Total_Rate_Sq_ft_Rs__c,Total__c,Unique_booking_Id__c,Visitor_Form_No__c FROM Booking_Information__c WHERE Booking_Status__c='SOLD' AND Name_Of_Opportunity__c != null AND Name_Of_Opportunity__r.stagename!='Closed Lost' limit 1];  
           
    
    BAccount=[select id,lastname,status__c,CRN__c,ispersonaccount,IsJodi__c,Jodi_Account__c,Jodi_Flat__c,Jodi_Indicator__c from account where recordtype.name='Booked Account' AND status__c='Active' AND CRN__c != '' AND isjodi__c=false limit 1];

    system.debug('@@@@@BAccount'+BAccount.CRN__c);
    
    Book.CRN_Number_SAP__c=BAccount.CRN__c;
    update Book;
    
    system.debug('@@@@@@@Book'+Book.CRN_Number_SAP__c);
    
    BAccount1=[select id,lastname,status__c,CRN__c,ispersonaccount,IsJodi__c,Jodi_Account__c,Jodi_Flat__c,Jodi_Indicator__c from account where recordtype.name='Booked Account' AND status__c='Active' AND CRN__c != '' AND isjodi__c=false limit 1];
    BAccount1.IsJodi__c=true;
    update BAccount1;
    system.debug('@@@@@BAccount1'+BAccount1.CRN__c);
    
    BAccount2=[select id,lastname,status__c,CRN__c,ispersonaccount,IsJodi__c,Jodi_Account__c,Jodi_Flat__c,Jodi_Indicator__c from account where recordtype.name='Booked Account' AND status__c='Active' AND CRN__c != '' AND isjodi__c=false limit 1];
    BAccount2.IsJodi__c=true;
    BAccount2.Jodi_Account__c=BAccount1.id;
    BAccount2.Jodi_Flat__c=true;
    update BAccount2;
    system.debug('@@@@@BAccount2'+BAccount2.CRN__c);
    
    flat=[select id,Status__c,ProjectName__c,Flat_no_text__c ,Oasys_Flat_code__c from flat__c where Oasys_Flat_code__c=:Book.Oasys_Flat_code__c];
    
    String uniqueKey = 'FAME' + flat.Flat_no_text__c + string.valueof(book.Id);
    
    famebysales = new FAME_By_Sales__c(Sales_Manager_User__c=Userinfo.getuserId(),Booking_Information__c=Book.Id,FAME_Status__c='Accept',Unique_key__c = uniqueKey);
    insert famebysales;
    
    fame = new FAME__c(Channel_Partner_Name__c=null,Channel_Partner_Name_NA__c=true,Booking_Information__c=Book.Id,FAME_Status__c='Accept',Unique_key__c = uniqueKey);
    insert fame;
    
    welcomecalldetails = new Welcome_Call_Details__c(Booking_Information__c=Book.Id,IsSubmitted_By_PI__c=false,IsSubmitted_By_RM__c=false);
    insert welcomecalldetails;
    
    welcomecallchecklist= new Welcome_Call_CheckList__c (Introduction_to_LFC__c='Correct',Booking_Information__c=Book.Id,Welcome_Call_Status__c='Accept');
    insert welcomecallchecklist;      
    
    SoChecklist= new SOCreation__c(Booking_Information__c=Book.Id,SO_Status__c='Accept',issubmitted__c=true);
    insert SoChecklist;   
    
    SOtask= new Task(Description = 'Welcomecall Initiated',RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('SO Creation Task').getRecordTypeId(),Priority = 'Normal', Status = 'Under Action by Me', Subject = 'Welcomecall Initiated - ' + book.Oasys_Flat_Code__c,IsReminderSet = true,ReminderDateTime = System.now()+6,ActivityDate = date.today()+7,OwnerId = userinfo.getuserid(),WhatId = SoChecklist.Id);
    insert SOtask;   
}

Public Testmethod static void Test_CancellationController_one(){ 
   
    Test_CancellationController.Test_CancellationController();
    
    PageReference ref = new PageReference('/apex/CancellationPage');
    ref.getParameters().put('bookingid',Book.Id);
    Test.setCurrentPage(ref);    
    ApexPages.currentPage().getHeaders().put('Host', 'testWelcomecalldetails');
    CancellationController Cancel=new CancellationController(); 
    
    Cancel.renderRemarks();
    
    Cancel.booking.Result_of_retention_efforts__c = 'Positive';
    Cancel.booking.Approval_sought__c ='Yes';
    Cancel.renderRemarks();
    Cancel.Confirm();
    
    Cancel.booking.Cancellation_Type__c ='Lodha';
    Cancel.booking.Is_the_customer_registered__c ='No';
    Cancel.booking.has_the_customer_initiated_deed_of_cance__c='No';
    Cancel.booking.Has_retention_efforts_been_carried_out__c ='No';
    Cancel.booking.Confirmation_Remark__c='Test';
    Cancel.booking.Result_of_retention_efforts__c ='Negative';
    Cancel.booking.Cancel_Confirm_Date__c=date.today();
    Cancel.booking.Approval_sought__c ='No';
    Cancel.booking.Reason_for_Cancellation__c ='Test';
    Cancel.renderRemarks();
    Cancel.Confirm();
    Cancel.send_email1('subject','body','ToAddressEmail@gmail.com');
    
    Book.CRN_Number_SAP__c=BAccount1.CRN__c;
    update Book;
    
    PageReference ref1 = new PageReference('/apex/CancellationPage');
    ref1.getParameters().put('bookingid',Book.Id);
    Test.setCurrentPage(ref1);    
    ApexPages.currentPage().getHeaders().put('Host', 'testWelcomecalldetails');
    
    CancellationController Cancel1=new CancellationController(); 
    Cancel1.booking.Cancellation_Type__c ='Lodha';
    Cancel1.booking.Is_the_customer_registered__c ='No';
    Cancel1.booking.has_the_customer_initiated_deed_of_cance__c='No';
    Cancel1.booking.Has_retention_efforts_been_carried_out__c ='No';
    Cancel1.booking.Confirmation_Remark__c='Test';
    Cancel1.booking.Result_of_retention_efforts__c ='Negative';
    Cancel1.booking.Cancel_Confirm_Date__c=date.today();
    Cancel1.booking.Approval_sought__c ='No';
    Cancel1.booking.Reason_for_Cancellation__c ='Test';
    Cancel1.renderRemarks();
    Cancel1.Confirm();
    
    
    
}
}