@isTest

Public class Test_SpSOCreationCheckList{

Public static Booking_Information__c oBookInfo;
Public static flat__c oFlat;
Public static Welcome_Call_Details__c welcomecalldetails;
Public static Welcome_Call_CheckList__c welcomecallchecklist;
Public static SOCreation__c SoChecklist;
Public static FAME_By_Sales__c famebysales;
Public static FAME__c fame;
Public static Task SOtask;
Public static Task welcomeEmailtask;

Public static void Test_SpSOCreationCheckList(){
	Account oAcc = new Account(RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId(), LastName = 'Test Account');
	insert oAcc;
	
	Project_Name__c oProjName = new Project_Name__c(Project_Type__c = 'Casa', Record_Type__c = 'Residential', Name = 'Test Project 1', CRN_INIT__c = '100');
	insert oProjName;
	
	Opportunity oOpp = new Opportunity(Name = 'Test Opporunity', StageName = 'Closed Lost', CloseDate = System.today(), AccountId = oAcc.Id, Project_Name__c = oProjName.Id);
	insert oOpp;
	
	Cluster__c oCluster = new Cluster__c(Project_Name__c = oProjName.Id, Name = 'Test Cluster 1');
	insert oCluster;
	
	Wing__c oWing = new Wing__c(Cluster__c = oCluster.Id, Name = 'Test Wing 1');
	insert oWing;
	
	Flat_Type__c oFlatType = new Flat_Type__c(Wing__c = oWing.Id, Name = 'Test Flat Type 1');
	insert oFlatType;
	
	oFlat = new Flat__c(Wing__c = oWing.Id, Flat_Type__c = oFlatType.Id, Flat_No__c = 101, Oasys_Flat_code__c = 'Test Project 1 Test Cluster 1 Test Wing 1 101', status__c = 'OPEN');
	insert oFlat;
	
	oBookInfo = new Booking_Information__c(Address1__c = 'test 1', Flat__c = oFlat.Id, Address2__c = 'test 2', Address3__c = 'Test 3', Applicable_Waiver_Sq_ft_Actual_Rs__c = 200, Applicable_Waiver_Sq_ft_Rs__c = 200, Application_Date__c = System.today(), Approval_sought__c = 'Yes', Approver_s_name__c = 'Test Name 1', Base_Rate_Sq_ft_Actual_Rs__c = 10000, Base_Rate_Sq_ft_Rs__c = 10000, Block_Date__c = System.today(), Block_Detail__c = 'test', Block_For_Days__c = 12, Block_For_Minutes__c = 3, Block_For__c = oOpp.Id, Block_Period__c = 'Test block 1', Block_Sales_Person_Email__c = 'test@test.com', Booking_By__c = 'Direct', Booking_Date__c = System.today(), Booking_Remark__c = 'Test', Booking_Status__c = 'BOOKED', Cancellation_Date__c = System.today(), Cancellation_Type__c = 'Lodha Initiated', Cancel_Confirm_Date__c = System.today(), Cash_Rs__c = 1000, Cheque_Details__c = 'test', Cheque_Rs__c = 1000, City_of_Co_applicant__c = 'test', City__c = 'test', Club_charges_Actual_Rs__c = 1000, Club_charges_Incl_in_CV__c = '1000', Club_charges_Rs__c = 1000, COAPPLICANT_RELATIONSHIP__c = 'Brother', Confirmation_Date__c = System.today(), Confirmation_Remark__c = 'test', Confirm_Date__c = System.today(), Consideration_Actual_Rs__c = 1000, Consideration_Rs__c = 1000, Contact_Nos__c = 'test', Country_of_Applicant__c = 'test', Country_of_Co_applicant__c = 'test', Credit_Card_Details__c = 'test', Credit_Card_Rs__c = 1000, Customer_Type__c = 'General', Name_Of_Opportunity__c = oOpp.Id, DAM_Offer_Sq_ft_Actual_Rs__c = 1000, DAM_Offer_Sq_ft_Rs__c = 1000, Date_of_First_Visit__c = System.today(),Email__c = 'test@test.com', Flat_Cost_Actual_Rs__c = 1000, Flat_Cost_Rs__c = 1000, Floor_rise_Sq_ft_Actual_Rs__c = 100, Floor_rise_Sq_ft_Rs__c = 100, Has_retention_efforts_been_carried_out__c = 'Yes', has_the_customer_initiated_deed_of_cance__c = 'Yes', InActive__c = false, Infrastructure2_Incl_in_CV__c = 'Excl.in CV', Infrastructure_Cost_2Actual_Rs__c = 1000, Infrastructure_Cost_2_Rs__c = 1000, Infrastructure_Cost_Actual_Rs__c = 1000, Infrastructure_Cost_Rs__c = 1000, Infrastructure_Incl_in_CV__c = 'Excl.in CV', Is_the_customer_registered__c = 'Yes', Loyalty_Id__c = '111111111', Loyalty_Source_Id__c = '111111111', Name_of_Applicant__c = 'test', Oasys_Flat_Code__c = 'Test Project 1 Test Cluster 1 Test Wing 1 101', Project_Hidden__c = 'Test Project 1', Total_Rate_Sq_ft_Actual_Rs__c = 1000, Total_Rate_Sq_ft_Rs__c = 1000, Premium_Sq_ft_Actual_Rs__c = 1000); /*Other_Details__c,Other_Rs__c,OwnerId,PAN_Number_of_Applicant__c,PAN_Number_of_Co_Applicant__c,Parking_Nos_2W__c,Parking_Nos_4w__c,Parking_Type__c,Pincode__c,Premium_Sq_ft_Rs__c,Project_Hidden__c,Project_Type_Hidden__c,Reap_ID_New__c,Reap_Id__c,Reason_for_Cancellation__c,Reason_for_Discount__c,Referral_CRN__c,Related_Comments__c,Remarks__c,Result_of_retention_efforts__c,SALESORDER_NO__c,Sales_Person__c,Sales_Strategist_Hidden__c,Sales_Strategist__c,SCUD_Follow_up_comments__c,SCUD_Related_Comments__c,Secondary_Applicant__c,Selected_discount_type__c,Site_Incharge_hidden__c,Site_Incharge__c,SO_Creation_Date_time__c,SO_Status__c,Submit_Date__c,SystemModstamp,Title_of_Applicant__c,Title_of_Co_Applicant__c,TobeBasePrice__c,Total_Actual_Base_Rate__c,Total_Base_Rate__c,Total__c,Unique_Booking_Id__c,Visitor_Form_No__c*/
	insert oBookInfo;
	
	System.debug('Project :::: ' + oBookInfo.Project_Hidden__c);
    
    String uniqueKey = 'FAME' + oFlat.Flat_no_text__c + string.valueof(oBookInfo.Id);
    
    famebysales = new FAME_By_Sales__c(Sales_Manager_User__c=Userinfo.getuserId(),Booking_Information__c=oBookInfo.Id,FAME_Status__c='Accept',Unique_key__c = uniqueKey);
    insert famebysales;
    
    fame = new FAME__c(Channel_Partner_Name__c=null,Channel_Partner_Name_NA__c=true,Booking_Information__c=oBookInfo.Id,FAME_Status__c='Accept',Unique_key__c = uniqueKey);
    insert fame;
    
    welcomecalldetails = new Welcome_Call_Details__c(Booking_Information__c=oBookInfo.Id,IsSubmitted_By_PI__c=false,IsSubmitted_By_RM__c=false);
    insert welcomecalldetails;
    
    welcomecallchecklist= new Welcome_Call_CheckList__c (Introduction_to_LFC__c='Correct',Booking_Information__c=oBookInfo.Id,Welcome_Call_Status__c='Accept');
    insert welcomecallchecklist;      
    
    SoChecklist= new SOCreation__c(Booking_Information__c=oBookInfo.Id,SO_Status__c='', Applicant_Name__c = 'test', Project__c = 'Test Project 1', Cluster__c = 'Test Cluster 1', Flat_No__c = '101', Application_Date__c = System.today(), Rate_Details_Basic__c = 10000, Rate_Details_Floor_Rise__c = 100, Rate_Details_Premium__c = 1000, Rate_Details_Infrastructure__c = 1000, Total_Consideration__c = 1000);
    insert SoChecklist;   
    
    SOtask= new Task(Description = 'Welcomecall Initiated',RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('SO Creation Task').getRecordTypeId(),Priority = 'Normal', Status = 'Under Action by Me', Subject = 'Welcomecall Initiated - ' + oBookInfo.Oasys_Flat_Code__c,IsReminderSet = true,ReminderDateTime = System.now()+6,ActivityDate = date.today()+7,OwnerId = userinfo.getuserid(),WhatId = SoChecklist.Id);
    insert SOtask;   
}

	Public Testmethod static void Test_SpSOCreationCheckList_one(){ 
      test.startTest();
          Test_SpSOCreationCheckList.Test_SpSOCreationCheckList();
	      PageReference ref = new PageReference('/apex/SpWelcomeCallCheckList');
	      ref.getParameters().put('bookingid',oBookInfo.Id);
	      Test.setCurrentPage(ref);    
	      ApexPages.currentPage().getHeaders().put('Host', 'testWelcomecalldetails');
	    
	      ApexPages.StandardController controller=new ApexPages.StandardController(SoChecklist);
	      SpSOCreationCheckList SpSOChecklist=new SpSOCreationCheckList(controller); 
	      SpSOChecklist.submit();
	    
	    system.debug('@@@@@@@@oBookInfo.Name_Of_Opportunity__c'+oBookInfo.Name_Of_Opportunity__c);    
	    opportunity o=[select id,Project_Name__c from opportunity where id=:oBookInfo.Name_Of_Opportunity__c];    
	    system.debug('@@@@@@@@oBookInfo.Name_Of_Opportunity__r.Project__c'+o.Project_Name__c);    
	    project_name__c proj=[select id,name,Sap_mapper__c from project_name__c where id=:o.Project_Name__c];
	    proj.Sap_mapper__c =Userinfo.getuserid();
	    update proj;
	        
	    test.stopTest();

	    SOCreation__c SO=new SOCreation__c (Booking_Information__c=oBookInfo.id,issubmitted__c=true,Welcome_Email_Task_Completed_Date__c=date.today());
	    insert SO;
	    
	    welcomeEmailtask= new Task(Description = 'WelcomeEmailTask Initiated',RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Welcome Email Task').getRecordTypeId(),Priority = 'Normal', Status = 'Under Action by Me', Subject = 'Welcomecall Initiated - ' + oBookInfo.Oasys_Flat_Code__c,IsReminderSet = true,ReminderDateTime = System.now()+6,ActivityDate = date.today()+7,OwnerId = userinfo.getuserid(),WhatId =oBookInfo.id,Booking_id__c=oBookInfo.id);
	    insert welcomeEmailtask;
	    
	    Profile customerProfile = [select Id
                                   from Profile
                                   where Name = 'Customer Care'];
	    
	    // Creating User Of Functional Team Lead Profile
        User objTestUser = new User(Alias = 'standt', Email = 'standarduser@testorg.com', EmailEncodingKey = 'UTF-8', LastName = 'TestUser', FirstName = 'Testing', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = customerProfile.Id, TimeZoneSidKey = 'America/Los_Angeles', UserName = 'TestUserstandarduser@testorg.com', IsActive = true, CommunityNickname = 'TestUser');
        insert objTestUser;
        
	    sp_2_email_user_config__c custSetting = new sp_2_email_user_config__c(Name = 'LFC_bank_funding_email', User_Id__c = objTestUser.Id);
	    insert custSetting;  
	    welcomeEmailtask.status='Completed';
	    update welcomeEmailtask;
	}
	
	Public Testmethod static void Test_SpSOCreationCheckList_DirectSourcedetail(){
	    Test_SpSOCreationCheckList.Test_SpSOCreationCheckList();
	    PageReference ref = new PageReference('/apex/SpWelcomeCallCheckList');
	    ref.getParameters().put('bookingid',oBookInfo.Id);
	    Test.setCurrentPage(ref);    
	    ApexPages.currentPage().getHeaders().put('Host', 'testWelcomecalldetails');
	    system.debug('@@@@@@@@oBookInfo.Name_Of_Opportunity__c'+oBookInfo.Name_Of_Opportunity__c);    
	    opportunity o=[select id,Project_Name__c from opportunity where id=:oBookInfo.Name_Of_Opportunity__c];    
	    system.debug('@@@@@@@@oBookInfo.Name_Of_Opportunity__r.Project__c'+o.Project_Name__c);    
	    project_name__c proj=[select id,name,Sap_mapper__c from project_name__c where id=:o.Project_Name__c];
	    proj.Sap_mapper__c =Userinfo.getuserid();
	    update proj;
	    SoChecklist.Source_Details_By_Page__c='Direct';
	    Update SoChecklist;     
	    ApexPages.StandardController controller=new ApexPages.StandardController(SoChecklist);
	    SpSOCreationCheckList SpSOChecklist1 = new SpSOCreationCheckList(controller); 
	    SpSOChecklist1.submit();
	}
	Public Testmethod static void Test_SpSOCreationCheckList_CRBSourcedetail(){
	    Test_SpSOCreationCheckList.Test_SpSOCreationCheckList();
	    PageReference ref = new PageReference('/apex/SpWelcomeCallCheckList');
	    ref.getParameters().put('bookingid',oBookInfo.Id);
	    Test.setCurrentPage(ref);    
	    ApexPages.currentPage().getHeaders().put('Host', 'testWelcomecalldetails');
	    system.debug('@@@@@@@@oBookInfo.Name_Of_Opportunity__c'+oBookInfo.Name_Of_Opportunity__c);    
	    opportunity o=[select id,Project_Name__c from opportunity where id=:oBookInfo.Name_Of_Opportunity__c];    
	    system.debug('@@@@@@@@oBookInfo.Name_Of_Opportunity__r.Project__c'+o.Project_Name__c);    
	    project_name__c proj=[select id,name,Sap_mapper__c from project_name__c where id=:o.Project_Name__c];
	    proj.Sap_mapper__c =Userinfo.getuserid();
	    update proj;
	    oBookInfo.Booking_By__c = 'referral';
	    update oBookInfo;
	    SoChecklist.Source_Details_By_Page__c='CRB';
	    Update SoChecklist;     
	    ApexPages.StandardController controller=new ApexPages.StandardController(SoChecklist);
	    SpSOCreationCheckList SpSOChecklist1 = new SpSOCreationCheckList(controller); 
	    SpSOChecklist1.submit();
	}  
	Public Testmethod static void Test_SpSOCreationCheckList_BrokerSourcedetail(){
	    Test_SpSOCreationCheckList.Test_SpSOCreationCheckList();
	    PageReference ref = new PageReference('/apex/SpWelcomeCallCheckList');
	    ref.getParameters().put('bookingid',oBookInfo.Id);
	    Test.setCurrentPage(ref);    
	    ApexPages.currentPage().getHeaders().put('Host', 'testWelcomecalldetails');
	    system.debug('@@@@@@@@oBookInfo.Name_Of_Opportunity__c'+oBookInfo.Name_Of_Opportunity__c);    
	    opportunity o=[select id,Project_Name__c from opportunity where id=:oBookInfo.Name_Of_Opportunity__c];    
	    system.debug('@@@@@@@@oBookInfo.Name_Of_Opportunity__r.Project__c'+o.Project_Name__c);    
	    project_name__c proj=[select id,name,Sap_mapper__c from project_name__c where id=:o.Project_Name__c];
	    proj.Sap_mapper__c =Userinfo.getuserid();
	    update proj;
	    SoChecklist.Source_Details_By_Page__c='Broker';
	    Update SoChecklist;     
	    oBookInfo.Booking_By__c = 'Channel Partner';
	    update oBookInfo;
	    ApexPages.StandardController controller=new ApexPages.StandardController(SoChecklist);
	    SpSOCreationCheckList SpSOChecklist1 = new SpSOCreationCheckList(controller); 
	    SpSOChecklist1.submit();
	}  
	Public Testmethod static void Test_SpSOCreationCheckList_SelfReferralSourcedetail(){
	    Test_SpSOCreationCheckList.Test_SpSOCreationCheckList();
	    PageReference ref = new PageReference('/apex/SpWelcomeCallCheckList');
	    ref.getParameters().put('bookingid',oBookInfo.Id);
	    Test.setCurrentPage(ref);    
	    ApexPages.currentPage().getHeaders().put('Host', 'testWelcomecalldetails');
	    system.debug('@@@@@@@@oBookInfo.Name_Of_Opportunity__c'+oBookInfo.Name_Of_Opportunity__c);    
	    opportunity o=[select id,Project_Name__c from opportunity where id=:oBookInfo.Name_Of_Opportunity__c];    
	    system.debug('@@@@@@@@oBookInfo.Name_Of_Opportunity__r.Project__c'+o.Project_Name__c);    
	    project_name__c proj=[select id,name,Sap_mapper__c from project_name__c where id=:o.Project_Name__c];
	    proj.Sap_mapper__c =Userinfo.getuserid();
	    update proj;
	    SoChecklist.Source_Details_By_Page__c='Self-Referral';
	    Update SoChecklist;     
	    oBookInfo.Booking_By__c = 'self-referral';
	    update oBookInfo;
	    ApexPages.StandardController controller=new ApexPages.StandardController(SoChecklist);
	    SpSOCreationCheckList SpSOChecklist1 = new SpSOCreationCheckList(controller); 
	    SpSOChecklist1.submit();
	}  
	Public Testmethod static void Test_SpSOCreationCheckList_OtherSourcedetail(){
	    Test_SpSOCreationCheckList.Test_SpSOCreationCheckList();
	    PageReference ref = new PageReference('/apex/SpWelcomeCallCheckList');
	    ref.getParameters().put('bookingid',oBookInfo.Id);
	    Test.setCurrentPage(ref);    
	    ApexPages.currentPage().getHeaders().put('Host', 'testWelcomecalldetails');
	    ApexPages.StandardController controller=new ApexPages.StandardController(SoChecklist);
	    SpSOCreationCheckList SpSOChecklist5 = new SpSOCreationCheckList(controller); 
	    system.debug('@@@@@@@@oBookInfo.Name_Of_Opportunity__c'+oBookInfo.Name_Of_Opportunity__c);    
	    opportunity o=[select id,Project_Name__c from opportunity where id=:oBookInfo.Name_Of_Opportunity__c];    
	    system.debug('@@@@@@@@oBookInfo.Name_Of_Opportunity__r.Project__c'+o.Project_Name__c);    
	    project_name__c proj=[select id,name,Sap_mapper__c from project_name__c where id=:o.Project_Name__c];
	    proj.Sap_mapper__c =Userinfo.getuserid();
	    update proj;
	    SoChecklist.Source_Details_By_Page__c='Others';
	    Update SoChecklist;     
	    oBookInfo.Booking_By__c = '';
	    update oBookInfo;
	    //SpSOCreationCheckList SpSOChecklist5=new SpSOCreationCheckList(controller); 
	    SpSOChecklist5.SOCreation.Applicant_Name__c = SpSOChecklist5.booking.Name_of_Applicant__c;
	    SpSOChecklist5.SOCreation.Project__c = SpSOChecklist5.booking.Flat__r.Wing__r.Cluster__r.Project_Name__r.Name;
    	SpSOChecklist5.SOCreation.Cluster__c= SpSOChecklist5.booking.Flat__r.Wing__r.Cluster__r.Name+SpSOChecklist5.booking.Flat__r.Wing__r.Name;
	    SpSOChecklist5.SOCreation.Flat_No__c = string.valueOf(SpSOChecklist5.flat.Flat_No__c);
	    SpSOChecklist5.SOCreation.Rate_Details_Basic__c = SpSOChecklist5.booking.Base_Rate_Sq_ft_Actual_Rs__c;
    	SpSOChecklist5.SOCreation.Rate_Details_Floor_Rise__c = SpSOChecklist5.booking.Floor_rise_Sq_ft_Actual_Rs__c;
	    SpSOChecklist5.SOCreation.Rate_Details_Discount__c = SpSOChecklist5.booking.Total_Rate_Sq_ft_Rs__c-SpSOChecklist5.booking.Total_Rate_Sq_ft_Actual_Rs__c;
	    SpSOChecklist5.SOCreation.Rate_Details_Premium__c= SpSOChecklist5.booking.Premium_Sq_ft_Actual_Rs__c;
	    SpSOChecklist5.SOCreation.Rate_Details_Infrastructure__c = SpSOChecklist5.booking.Infrastructure_Cost_Actual_Rs__c;
	    SpSOChecklist5.SOCreation.Total_Consideration__c = SpSOChecklist5.booking.Consideration_Actual_Rs__c;
	    SpSOChecklist5.SOCreation.Application_Date__c = SpSOChecklist5.booking.Application_Date__c;
	    SpSOChecklist5.SourceCorrect=true;
	    
	    SpSOChecklist5.send_email('subject','body',userinfo.getuserId());
	    SpSOChecklist5.send_email1('subject','body','ToAddressEmail');    
	    
	    SpSOChecklist5.submit();
	}  
}