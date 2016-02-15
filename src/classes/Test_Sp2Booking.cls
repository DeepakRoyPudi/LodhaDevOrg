@isTest(seealldata=true)
Public class Test_Sp2Booking{

Public Testmethod static void Test_Sp2Booking(){

//Project_Name__c Proj=[select id,name,accomodationMap__c,Account_No__c,Allow_Call_Patching__c,Allow_mobile_verification__c,Armed_Personnel_Discount__c,Banker__c,Call_Patch_Category__c,City__c,Company_Name__c,Contact_Nos__c,CRN_INIT__c,DAM_Limit__c,Designation__c,E_Brochure_Links__c,E_Brochure_Phone_No__c,Email_Body__c,Email_Id__c,Employee_Discount__c,External_Project_Name__c,Hold__c,Isactive__c,IsSp2__c,leadSourceMap__c,Location__c,Loyalty_Type__c,Max_Block_Days__c,Non_Contactable_Sms__c,Non_Contactable_Sms_Template__c,Old_Project_Name__c,Date__c,Physically_Disabled_Discount__c,Pincode__c,Project_Address__c,ProjectImage__c,Project_Incharge__c,Project_Manager__c,Project_Type__c,Proposed_Completion__c,Record_Type__c,Sales_Strategist__c,Sap_Mapper__c,Send_SMS__c,Contact_Center_No__c,Site_Incharge__c,Special_Offer__c,Thank_You_Sms__c,Thank_You_Sms_Template__c,Type_of_Accomodation__c,Valid_Files__c,Visit_Confirmed_Sms__c,Visit_Confirmed_Sms_Template__c,Zone__c from Project_Name__c where name='Lodha Grandezza'];
//Proj.isSP2__c=true;
//update Proj;

Booking_Information__c Book=[SELECT Address1__c,Flat__r.Status__c,Address2__c,Address3__c,Applicable_Waiver_Sq_ft_Actual_Rs__c,Applicable_Waiver_Sq_ft_Rs__c,Application_Date__c,Approval_sought__c,Approver_s_name__c,Base_Rate_Sq_ft_Actual_Rs__c,Base_Rate_Sq_ft_Rs__c,Block_Date__c,Block_Detail__c,Block_For_Days__c,Block_For_Minutes__c,Block_For__c,Block_Period__c,Block_Sales_Person_Email__c,Block_Sales_Person__c,Booking_By__c,Booking_Date__c,Booking_Remark__c,Booking_Status__c,Cancellation_Date__c,Cancellation_Type__c,Cancel_Confirm_Date__c,Cash_Rs__c,Cheque_Details__c,Cheque_Rs__c,City_of_Co_applicant__c,City__c,Club_charges_Actual_Rs__c,Club_charges_Incl_in_CV__c,Club_charges_Rs__c,COAPPLICANT_RELATIONSHIP__c,Confirmation_Date__c,Confirmation_Remark__c,Confirm_Date__c,Consideration_Actual_Rs__c,Consideration_Rs__c,Contact_Nos__c,Corporate_connection__c,Country_of_Applicant__c,Country_of_Co_applicant__c,CreatedById,CreatedDate,Credit_Card_Details__c,Credit_Card_Rs__c,CRN_Number_SAP__c,CRN__c,CurrencyIsoCode,Customer_Type__c,Name_Of_Opportunity__r.Project__r.name,DAM_Offer_Sq_ft_Actual_Rs__c,DAM_Offer_Sq_ft_Rs__c,Date_of_First_Visit__c,DifferenceBasePrice__c,DifferenceTotalRate__c,Email__c,Flat_Cost_Actual_Rs__c,Flat_Cost_Rs__c,Flat__c,Floor_rise_Sq_ft_Actual_Rs__c,Floor_rise_Sq_ft_Rs__c,Has_retention_efforts_been_carried_out__c,has_the_customer_initiated_deed_of_cance__c,Id,InActive__c,Infrastructure2_Incl_in_CV__c,Infrastructure_Cost_2Actual_Rs__c,Infrastructure_Cost_2_Rs__c,Infrastructure_Cost_Actual_Rs__c,Infrastructure_Cost_Rs__c,Infrastructure_Incl_in_CV__c,IsDeleted,isSP2__c,Is_the_customer_registered__c,LastActivityDate,LastModifiedById,LastModifiedDate,Loyalty_Id__c,Loyalty_Source_Id__c,Name,Name_of_Applicant__c,Name_Of_Opportunity__c,Oasys_Flat_Code__c,Other_Details__c,Other_Rs__c,OwnerId,PAN_Number_of_Applicant__c,PAN_Number_of_Co_Applicant__c,Parking_Nos_2W__c,Parking_Nos_4w__c,Parking_Type__c,Pincode__c,Premium_Sq_ft_Actual_Rs__c,Premium_Sq_ft_Rs__c,Project_Hidden__c,Project_Type_Hidden__c,Reap_ID_New__c,Reap_Id__c,Reason_for_Cancellation__c,Reason_for_Discount__c,Referral_CRN__c,Related_Comments__c,Remarks__c,Result_of_retention_efforts__c,SALESORDER_NO__c,Sales_Person__c,Sales_Strategist_Hidden__c,Sales_Strategist__c,SCUD_Follow_up_comments__c,SCUD_Related_Comments__c,Secondary_Applicant__c,Selected_discount_type__c,Site_Incharge_hidden__c,Site_Incharge__c,SO_Creation_Date_time__c,SO_Status__c,Submit_Date__c,SystemModstamp,Title_of_Applicant__c,Title_of_Co_Applicant__c,TobeBasePrice__c,Total_Actual_Base_Rate__c,Total_Base_Rate__c,Total_Rate_Sq_ft_Actual_Rs__c,Total_Rate_Sq_ft_Rs__c,Total__c,Unique_booking_Id__c,Visitor_Form_No__c FROM Booking_Information__c WHERE Booking_Status__c='SOLD' AND Name_Of_Opportunity__c != null AND Name_Of_Opportunity__r.stagename!='Closed Lost' limit 1];
Book.Booking_Status__c='OPEN';
update Book;

system.debug('!!!!!!!!!!book'+Book);
Project_Name__c Proj=[select id,name,accomodationMap__c,Account_No__c,Allow_Call_Patching__c,Allow_mobile_verification__c,Armed_Personnel_Discount__c,Banker__c,Call_Patch_Category__c,City__c,Company_Name__c,Contact_Nos__c,CRN_INIT__c,DAM_Limit__c,Designation__c,E_Brochure_Links__c,E_Brochure_Phone_No__c,Email_Body__c,Email_Id__c,Employee_Discount__c,External_Project_Name__c,Hold__c,Isactive__c,IsSp2__c,leadSourceMap__c,Location__c,Loyalty_Type__c,Max_Block_Days__c,Non_Contactable_Sms__c,Non_Contactable_Sms_Template__c,Old_Project_Name__c,Date__c,Physically_Disabled_Discount__c,Pincode__c,Project_Address__c,ProjectImage__c,Project_Incharge__c,Project_Manager__c,Project_Type__c,Proposed_Completion__c,Record_Type__c,Sales_Strategist__c,Sap_Mapper__c,Send_SMS__c,Contact_Center_No__c,Site_Incharge__c,Special_Offer__c,Thank_You_Sms__c,Thank_You_Sms_Template__c,Type_of_Accomodation__c,Valid_Files__c,Visit_Confirmed_Sms__c,Visit_Confirmed_Sms_Template__c,Zone__c from Project_Name__c where name=:Book.Project_Hidden__c];
Proj.isSP2__c=true;
update Proj;

PageReference ref = new PageReference('/apex/SpBookInventory');
Test.setCurrentPage(ref);
ref.getParameters().put('fid',Book.Unique_booking_Id__c);
ref.getParameters().put('oppid',Book.Name_Of_Opportunity__c);    
Sp2Booking spbook = new Sp2Booking();
spbook.toggledisplay();

spbook.booking.Booking_By__c = 'Channel Partner';
spbook.toggledisplay();

spbook.booking.Booking_By__c = 'referral';
spbook.toggledisplay();

spbook.corpToggleDisplay();

spbook.booking.Customer_Type__c='Corporate';
spbook.corpToggleDisplay();

spbook.booking.Customer_Type__c='Armed Forces Personnel';
spbook.corpToggleDisplay();

spbook.booking.Customer_Type__c='Employee';
spbook.corpToggleDisplay();

spbook.booking.Customer_Type__c='Physically challenged';
spbook.corpToggleDisplay();

spbook.adjust_dam_amt();
spbook.calc_offer_amt();
spbook.calc_corp_discount();
spbook.get_access_permission_type();
spbook.getCorpSelectionList();


spbook.booking.Selected_discount_type__c = 'DAM';
spbook.booking.DAM_Offer_Sq_ft_Actual_Rs__c=spbook.projdet.DAM_Limit__c+100;
spbook.adjust_dam_amt();
spbook.calc_offer_amt();

spbook.booking.Selected_discount_type__c = 'Sp_offer';
spbook.booking.DAM_Offer_Sq_ft_Actual_Rs__c=spbook.projdet.DAM_Limit__c+100;
spbook.adjust_dam_amt();
spbook.calc_offer_amt();

spbook.booking.Selected_discount_type__c = 'SCUD';
spbook.booking.DAM_Offer_Sq_ft_Actual_Rs__c=spbook.projdet.DAM_Limit__c+100;
spbook.adjust_dam_amt();
spbook.calc_offer_amt();


spbook.booking.Booking_Status__c='BOOKED';
spbook.save();

spbook.beforestatus='BOOKED';
spbook.booking.Booking_Status__c='OPEN';
spbook.save();

spbook.beforestatus='WELCOME CALL PENDING';
spbook.booking.Booking_Status__c='OPEN';
spbook.save();

spbook.beforestatus='WELCOME CALL REJECT';
spbook.booking.Booking_Status__c='OPEN';
spbook.save();

spbook.beforestatus='BOOKING';
spbook.booking.Booking_Status__c='OPEN';
spbook.save();

spbook.beforestatus='CANCELLATION';
spbook.booking.Booking_Status__c='BOOKED';
spbook.save();

spbook.beforestatus='SCUD';
spbook.booking.Booking_Status__c='OPEN';
spbook.save();

spbook.beforestatus='SOLD';
spbook.booking.Booking_Status__c='BOOKED';
spbook.save();

spbook.beforestatus='SCUD REJECT';
spbook.booking.Booking_Status__c='BOOKED';
spbook.save();

spbook.beforestatus='FAME RETURN';
spbook.booking.Booking_Status__c='BOOKED';
spbook.save();

spbook.beforestatus='BLOCKED';
spbook.booking.Booking_Status__c='SOLD';
spbook.save();

spbook.beforestatus='BOOKING';
spbook.booking.Booking_Status__c='CANCELLATION';
spbook.booking.Cancel_Confirm_Date__c=null;
spbook.booking.Reason_for_Cancellation__c=null; 
//spbook.save();


spbook.beforestatus='BOOKING';
spbook.booking.Booking_Status__c='BOOKED';
spbook.booking.Visitor_Form_No__c='dddd';
spbook.save();

spbook.beforestatus='BOOKING';
spbook.booking.Booking_Status__c='BOOKED';
spbook.booking.Visitor_Form_No__c='dddd22222';
spbook.booking.Loyalty_Id__c='dddd';
spbook.save();

spbook.beforestatus='BOOKING';
spbook.booking.Booking_Status__c='BOOKED';
spbook.booking.Visitor_Form_No__c='dddd22222';
spbook.booking.Loyalty_Id__c='1111';
spbook.save();

spbook.beforestatus='BOOKING';
spbook.booking.Booking_Status__c='BOOKED';
spbook.booking.Visitor_Form_No__c='dddd22222';
spbook.booking.Loyalty_Id__c='012345678';
spbook.save();

spbook.beforestatus='BOOKING';
spbook.booking.Booking_Status__c='BOOKED';
spbook.booking.Visitor_Form_No__c='dddd22222';
spbook.booking.Loyalty_Id__c='100233333';
spbook.save();

spbook.beforestatus='OPEN';
spbook.booking.Booking_Status__c='BLOCKED';
spbook.booking.Booking_Status__c='BLOCKED';
spbook.updatestatus();
spbook.save();

spbook.beforestatus='BLOCKED';
spbook.booking.Booking_Status__c='BOOKING';
spbook.booking.Booking_Status__c='BOOKING';
spbook.updatestatus();

spbook.booking.Name_of_Applicant__c=null;
spbook.save();

spbook.beforestatus='BLOCKED';
spbook.booking.Name_of_Applicant__c='test';
spbook.booking.Contact_Nos__c='1111111111';
spbook.booking.Booking_Date__c=date.today();
spbook.booking.Booking_By__c='Channel Partner';
spbook.booking.Visitor_Form_No__c='222222222';
spbook.booking.Customer_Type__c='test';
spbook.booking.Date_of_First_Visit__c=date.today();
spbook.booking.Sales_Person__c=UserInfo.getUserId();
spbook.booking.Loyalty_Id__c='100100000';
spbook.booking.Total__c =3333;
spbook.booking.CRN__c='test';

spbook.rep_id_display_visible=true;
spbook.booking.Booking_By__c = 'Channel Partner';
spbook.booking.Booking_Status__c='BOOKING';
spbook.save();

spbook.beforestatus='BLOCKED';
spbook.ref_crn_display_visible=true;
spbook.booking.Booking_By__c = 'referral';
spbook.booking.Referral_CRN__c = null;
spbook.booking.Booking_Status__c='BOOKING';
spbook.save();


spbook.beforestatus='BLOCKED';
spbook.ref_crn_display_visible=false;
spbook.booking.Cheque_Rs__c=222;
spbook.booking.Cheque_Details__c = null;
spbook.booking.Booking_Status__c='BOOKING';
spbook.save();

spbook.beforestatus='BLOCKED';
spbook.booking.Cheque_Rs__c=0;
spbook.booking.Other_Rs__c=22;
spbook.booking.Other_Details__c = null;
spbook.booking.Booking_Status__c='BOOKING';
spbook.save();


spbook.beforestatus='BLOCKED';
spbook.booking.Other_Rs__c=0;
spbook.booking.Credit_Card_Rs__c=33;
spbook.booking.Credit_Card_Details__c = null;
spbook.booking.Booking_Status__c='BOOKING';
spbook.save();


spbook.beforestatus='BLOCKED';
spbook.booking.Booking_Status__c='BOOKING';
spbook.booking.Credit_Card_Rs__c=0;
spbook.booking.CRN__c=null;
spbook.booking.Total__c=spbook.token_amt-1;
spbook.updatestatus();
spbook.save();

Test.starttest();

spbook.beforestatus='BLOCKED';
spbook.booking.Booking_Status__c='BOOKING';
spbook.booking.Total__c=spbook.token_amt+331;
spbook.booking.Selected_discount_type__c='';
spbook.updatestatus();
spbook.save();

opportunity opp=[SELECT AccountId,Welcome_Call_Return_Date__c,Welcome_Call_Return_Remarks__c  FROM Opportunity WHERE id=:spbook.booking.Name_Of_Opportunity__c];
opp.Welcome_Call_Return_Date__c=date.today();
opp.Welcome_Call_Return_Remarks__c ='Test';
update opp;

spbook.beforestatus='BOOKING';
spbook.booking.Booking_Status__c='BOOKED';
spbook.updatestatus();
spbook.save();


spbook.beforestatus='BOOKED';
spbook.booking.SALESORDER_NO__c=null;
spbook.booking.CRN_Number_SAP__c=null;
spbook.booking.Booking_Status__c='SOLD';
spbook.updatestatus();
spbook.save();

spbook.booking.Infrastructure_Incl_in_CV__c='Incl.in CV';
spbook.inf_consideration_amt();

spbook.booking.Infrastructure_Incl_in_CV__c='Excl.in CV';
spbook.inf_consideration_amt();

spbook.booking.Infrastructure2_Incl_in_CV__c='Incl.in CV';
spbook.inf2_consideration_amt();

spbook.booking.Infrastructure2_Incl_in_CV__c='Excl.in CV';
spbook.inf2_consideration_amt();

spbook.booking.Club_charges_Incl_in_CV__c='Incl.in CV';
spbook.clb_consideration_amt();

spbook.booking.Club_charges_Incl_in_CV__c='Excl.in CV';
spbook.clb_consideration_amt();

spbook.booking.Booking_Status__c='BOOKING';
spbook.cal_token_amt();

spbook.booking.Cash_Rs__c=null;
spbook.booking.Cheque_Rs__c =null;
spbook.booking.Other_Rs__c =null;
spbook.booking.Credit_Card_Rs__c =null;
spbook.cal_token_amt();

spbook.booking.Infrastructure_Incl_in_CV__c='Incl.in CV';
spbook.booking.Club_charges_Incl_in_CV__c='Incl.in CV';
spbook.booking.Infrastructure2_Incl_in_CV__c='Incl.in CV';
spbook.cal_infra_cost();




flat__c flat=[select id,Status__c,ProjectName__c,Oasys_Flat_code__c from flat__c where Oasys_Flat_code__c=:Book.Oasys_Flat_code__c];
flat.Status__c='BOOKING';
update flat;

PageReference ref1 = new PageReference('/apex/SpBookInventory');
Test.setCurrentPage(ref1);
ref1.getParameters().put('fid',Book.Unique_booking_Id__c);
ref1.getParameters().put('oppid',Book.Name_Of_Opportunity__c);  

Sp2Booking spbook2 = new Sp2Booking();


spbook2.beforestatus='BOOKING';
spbook2.booking.Booking_Status__c='CANCELLATION';
spbook2.booking.Reason_for_Cancellation__c=null;
spbook2.updatestatus();

spbook2.beforestatus='BOOKING';
spbook2.booking.Cancel_Confirm_Date__c = date.today();
spbook2.booking.Cancellation_date__c= date.today();
spbook2.booking.Reason_for_Cancellation__c='Test'; 
spbook2.booking.Confirmation_Remark__c ='Test';
spbook2.booking.Booking_Status__c='CANCELLATION';
spbook2.updatestatus();
spbook2.save();

spbook2.booking.Booking_Status__c='BOOKING';
spbook2.generate_payment_plan();
spbook2.generate_bdf_form();
spbook2.open_scud_window();

Test.stoptest();

ref.getParameters().put('proj',Proj.name);
Sp2Booking spbook1 = new Sp2Booking();



}


}