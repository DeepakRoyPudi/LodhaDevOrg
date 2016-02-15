public with sharing class ScudEmailTemplateController{
  
    public double discountGiven {get; set;}
    public decimal discountOriginalCV {get; set;}
    public decimal booking_token_amt{get; set;}
    public decimal token_amt{get; set;}
    public id ScudId{get; set;}
    public date bookingdate{get; set;}
    public SCUD_Information__c scudInformation {get; set;}

    public List<Stage_Payment_Details__c> getSI()
    {
        booking_token_amt = 0;    
        token_amt = 0;
        bookingdate = null;
        discountGiven = 0;
        discountOriginalCV = 0;
        scudInformation = new SCUD_Information__c();
        scudInformation = [Select Id, SCUD_Status__c, AccountOccupation__c, AccountCompany__c, NPV_Difference__c, Cluster__c, Accountdesignation__c,AccountCorrespondence__c,OpportunityWalkinSource__c, Sales_Strategist_Comments__c,
                            Booking_Information__r.Name_of_Applicant__c, Booking_Information__r.Site_Incharge_hidden__c, Booking_Information__r.Consideration_Actual_Rs__c,Booking_Information__r.Sales_Person__c, Booking_Information__r.Owner.FirstName, Booking_Information__r.Owner.LastName,
                            Original_NPV__c, New_NPV__c, Booking_Information__c, Booking_Information__r.Base_Rate_Sq_ft_Actual_Rs__c,
                            Booking_Information__r.TobeBasePrice__c,Booking_Information__r.DifferenceBasePrice__c,Booking_Information__r.Floor_rise_Sq_ft_Rs__c,
                            Booking_Information__r.Floor_rise_Sq_ft_Actual_Rs__c,Booking_Information__r.Premium_Sq_ft_Rs__c,
                            Booking_Information__r.Premium_Sq_ft_Actual_Rs__c,Booking_Information__r.Total_Base_Rate__c,Booking_Information__r.Sales_Strategist_Hidden__c,
                            Booking_Information__r.Total_Actual_Base_Rate__c,Booking_Information__r.DifferenceTotalRate__c,Booking_Information__r.Sales_Person__r.Name,
                            Booking_Information__r.Booking_Date__c,Booking_Information__r.Cheque_Details__c,Booking_Information__r.SCUD_Follow_up_comments__c,
                            Wing__c, Booking_Information__r.Flat__r.Wing__r.Project_Incharge_Relationship_Manager__r.FirstName, Booking_Information__r.Flat__r.Wing__r.Project_Incharge_Relationship_Manager__r.LastName, 
                            Booking_Information__r.Name_Of_Opportunity__r.Project_Name__r.Project_Incharge__r.FirstName, Booking_Information__r.Name_Of_Opportunity__r.Project_Name__r.Project_Incharge__r.LastName, 
                            Project__c,Flat_Number__c,Flat_Type__c,Saleable_Area__c, Booking_Information__r.SCUD_Related_Comments__c,(Select Comments From ProcessSteps order by SystemModstamp desc limit 1) From SCUD_Information__c Where Id =: ScudId];
        system.debug('scudInformation:' + scudInformation);
        List<Stage_Payment_Details__c> SPDList = [Select Id, CV__c, Name, Current_Date_Excepted__c, Payment_Slab__c, Current_Amount__c, Requested_Payment_Slab__c, Actual_Completion_Date__c,
                                    Requested_Date_Expected__c, Requested_Amount__c, Booking_Information__r.Booking_Date__c,
                                    Booking_Information__r.Base_Rate_Sq_ft_Rs__c, Booking_Information__r.Flat__r.Token_Amount_Rs__c,
                                    Booking_Information__r.Consideration_Rs__c, Booking_Information__r.Consideration_Actual_Rs__c, 
                                    Booking_Information__r.Flat__r.Salable_Area__c, Booking_Information__r.Total__c
                                    From Stage_Payment_Details__c Where Booking_Information__c = : scudInformation.Booking_Information__c order by CreatedDate ASC];
        
        decimal totalRequestedAmount = 0;
        for(Stage_Payment_Details__c SPD:SPDList){
            totalRequestedAmount += SPD.Requested_Amount__c;
        }
        booking_token_amt = SPDList[0].Booking_Information__r.Total__c;    
        token_amt = SPDList[0].Booking_Information__r.Flat__r.Token_Amount_Rs__c;
        bookingdate = SPDList[0].Booking_Information__r.Booking_Date__c;
        discountGiven = (scudInformation.New_NPV__c-scudInformation.Original_NPV__c) / SPDList[0].Booking_Information__r.Flat__r.Salable_Area__c;
        discountOriginalCV = (scudInformation.New_NPV__c-scudInformation.Original_NPV__c)/totalRequestedAmount;
        return SPDList;
    }
    

  
   /*
    
    static testMethod void testScudEmailTemplateController(){
    
    SpTestInsertions spTestInsertions = new SpTestInsertions();

         Account accountTest = new Account(recordtypeid =Schema.SObjectType.Account.getRecordTypeInfosByName().get('Booked Account').getRecordTypeId(),LastName ='Test Last Name',Mobile_Phone__c ='456872934');
        insert accountTest;
    
        Project_Name__c projectNameTest = spTestInsertions.createProjectName();
        insert projectNameTest;    
    
        Cluster__c clusterTest = spTestInsertions.createCluster(projectNameTest);
        insert clusterTest;
      
    
        // Stage__c stageTest = spTestInsertions.createStage();
       //  insert stageTest;
    
        Wing__c wingTest = spTestInsertions.createWing(clusterTest);
        insert wingTest;
    
    
        Flat_Type__c flatTypeTest = spTestInsertions.createFlatType(wingTest);
       insert flatTypeTest;
    
        Stage_Details__c stageDetailsTest = spTestInsertions.createStageDetails(wingTest);
        insert stageDetailsTest;
        
       View_type_Assignment__c viewTypeAssignTest1 = new View_type_Assignment__c(Wing__c=wingTest.Id,Flat_Type__c=flatTypeTest.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('Flat Type Record').getRecordTypeId(),Pattern__c ='All');
       insert viewTypeAssignTest1;
    
       View_type_Assignment__c viewTypeAssignTest2 = new View_type_Assignment__c(Wing__c=wingTest.Id,Flat_Type__c=flatTypeTest.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('View Type Record').getRecordTypeId(),Pattern__c ='All',View__c='Sea View');
       insert viewTypeAssignTest2;
    
       Rate_Card__c rateCardTest1 = new Rate_Card__c (Wing__c=wingTest.Id,recordtypeid=Schema.SObjectType.Rate_Card__c.getRecordTypeInfosByName().get('Premium View Rate Record').getRecordTypeId(),Flat_Type__c=flatTypeTest.Id,Premium_View__c='Sea View',View_Rate_Sq_Ft__c=20);
       insert rateCardTest1;
    
      Rate_Card__c rateCardTest2 = new Rate_Card__c (Wing__c=wingTest.Id,recordtypeid=Schema.SObjectType.Rate_Card__c.getRecordTypeInfosByName().get('Floor Rise Rate').getRecordTypeId(),Flat_Type__c=flatTypeTest.Id,Floor_From__c=1,Floor_To__c=2,Floor_Rise_Sq_Ft__c=20);
      insert rateCardTest2;
    
    
     ApexPages.StandardController stc = new ApexPages.StandardController(wingTest); 
     SpGenerateInventory testSpGenerateInventory = new SpGenerateInventory(stc);
     testSpGenerateInventory.generateInventory();
 
     Flat__c FlatTest = [select Id,Salable_Area__c from Flat__c Where Wing__c=:wingTest.Id limit 1]; 
      
        
        Opportunity opportunityTest = new Opportunity(Name='Test Opportunity',recordtypeid =Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Residential').getRecordTypeId(),Account = accountTest,CloseDate=System.now().date()+20,Project_Name__c = projectNameTest.id,StageName = 'Qualified',Servicing_Team__c='Presales',IsActive__c=true);
        insert opportunityTest; 
        
        Booking_Information__c bookingInformationTest= new Booking_Information__c(Name_Of_Opportunity__c=opportunityTest.id,Unique_booking_Id__c=FlatTest.id,Flat__c=FlatTest.id,Block_Detail__c='Test Block Details',Consideration_Actual_Rs__c=10000,Consideration_Rs__c=10000,Infrastructure_Incl_in_CV__c='Incl.in CV',Infrastructure2_Incl_in_CV__c='Incl.in CV',Club_Charges_Incl_in_CV__c='Incl.in CV',Infrastructure_Cost_Rs__c=100,Infrastructure_Cost_2_Rs__c=100,Club_Charges_Rs__c=100,Infrastructure_Cost_2Actual_Rs__c=100,Infrastructure_Cost_Actual_Rs__c=150,Club_charges_Actual_Rs__c=100,Base_Rate_Sq_ft_Actual_Rs__c=120,Floor_rise_Sq_ft_Actual_Rs__c=120,Premium_Sq_ft_Actual_Rs__c=120,Applicable_Waiver_Sq_ft_Actual_Rs__c=120,Total_Rate_Sq_ft_Actual_Rs__c=120,Flat_Cost_Actual_Rs__c=120,Applicable_Waiver_Sq_ft_Rs__c=100,Booking_Date__c=System.now().date(),Base_Rate_Sq_ft_Rs__c=1000);
        insert bookingInformationTest;
        
        
        Stage_Payment_Details__c stagePaymentDetailsTest12 = new Stage_Payment_Details__c(Name='Stage Payment Details Test4',Booking_Information__c=bookingInformationTest.Id,Current_Date_Excepted__c=System.now().date()+1,Actual_Completion_Date__c = null, Requested_Date_Expected__c=null,Payment_Slab__c=3,Requested_Amount__c=0);
        insert stagePaymentDetailsTest12;        
        Stage_Payment_Details__c stagePaymentDetailsTest13 = new Stage_Payment_Details__c(Name='Stage Payment Details Test5',Booking_Information__c=bookingInformationTest.Id,Current_Date_Excepted__c=System.now().date()+3,Actual_Completion_Date__c = null, Requested_Date_Expected__c=null,Payment_Slab__c=3,Requested_Amount__c=0);
        insert stagePaymentDetailsTest13;
        Stage_Payment_Details__c stagePaymentDetailsTest14 = new Stage_Payment_Details__c(Name='Stage Payment Details Test6',Booking_Information__c=bookingInformationTest.Id,Current_Date_Excepted__c=System.now().date()+5,Actual_Completion_Date__c = null, Requested_Date_Expected__c=null,Payment_Slab__c=3,Requested_Amount__c=0);
        insert stagePaymentDetailsTest14;
        Stage_Payment_Details__c stagePaymentDetailsTest15 = new Stage_Payment_Details__c(Name='Stage Payment Details Test7',Booking_Information__c=bookingInformationTest.Id,Current_Date_Excepted__c=System.now().date()+5,Actual_Completion_Date__c = null, Requested_Date_Expected__c=null,Payment_Slab__c=3,Requested_Amount__c=0);
        insert stagePaymentDetailsTest15;
        
        PageReference ref3=new PageReference('/apex/TestSpScudApproval');
        Test.setCurrentPage(ref3);
        
        ref3.getParameters().put('bid',bookingInformationTest.id);
        
        ScudEmailTemplateController ScudEmailTemplateControllerTest3=new ScudEmailTemplateController();
      
        ScudEmailTemplateControllerTest3.CalculateNPV();
        ScudEmailTemplateControllerTest3.Submit();
        
        List<Stage_Payment_Details__c> dellist = [select Id from Stage_Payment_Details__c where Booking_Information__c=:bookingInformationTest.Id];
        delete dellist;
        
        Stage_Payment_Details__c stagePaymentDetailsTest = new Stage_Payment_Details__c(Name='Stage Payment Details Test',Booking_Information__c=bookingInformationTest.Id,Current_Date_Excepted__c=System.now().date()+1,Actual_Completion_Date__c = System.now().date() + 3, Requested_Date_Expected__c=null,Payment_Slab__c=3,Requested_Amount__c=0);
        insert stagePaymentDetailsTest;        
        Stage_Payment_Details__c stagePaymentDetailsTest1 = new Stage_Payment_Details__c(Name='Stage Payment Details Test1',Booking_Information__c=bookingInformationTest.Id,Current_Date_Excepted__c=System.now().date()+3,Actual_Completion_Date__c = System.now().date() + 5, Requested_Date_Expected__c=null,Payment_Slab__c=3,Requested_Amount__c=0);
        insert stagePaymentDetailsTest1;
        Stage_Payment_Details__c stagePaymentDetailsTest2 = new Stage_Payment_Details__c(Name='Stage Payment Details Test2',Booking_Information__c=bookingInformationTest.Id,Current_Date_Excepted__c=System.now().date()+5,Actual_Completion_Date__c = System.now().date() + 7, Requested_Date_Expected__c=null,Payment_Slab__c=3,Requested_Amount__c=0);
        insert stagePaymentDetailsTest2;
        Stage_Payment_Details__c stagePaymentDetailsTest3 = new Stage_Payment_Details__c(Name='Stage Payment Details Test3',Booking_Information__c=bookingInformationTest.Id,Current_Date_Excepted__c=System.now().date()+5,Actual_Completion_Date__c = null, Requested_Date_Expected__c=null,Payment_Slab__c=3,Requested_Amount__c=0);
        insert stagePaymentDetailsTest3;
        
        PageReference ref=new PageReference('/apex/TestSpScudApproval');
        Test.setCurrentPage(ref);
        
        ref.getParameters().put('bid',bookingInformationTest.id);
        
        ScudEmailTemplateController ScudEmailTemplateControllerTest=new ScudEmailTemplateController();
      
        ScudEmailTemplateControllerTest.CalculateNPV();
        ScudEmailTemplateControllerTest.Submit();
        
        
        Stage_Payment_Details__c stagePaymentDetailsTest4 = new Stage_Payment_Details__c(Name='Stage Payment Details Test4',Booking_Information__c=bookingInformationTest.Id,Current_Date_Excepted__c=System.now().date()+1,Actual_Completion_Date__c = System.now().date()+3, Requested_Date_Expected__c=null,Payment_Slab__c=3,Requested_Amount__c=0);
        insert stagePaymentDetailsTest4;        
        Stage_Payment_Details__c stagePaymentDetailsTest5 = new Stage_Payment_Details__c(Name='Stage Payment Details Test5',Booking_Information__c=bookingInformationTest.Id,Current_Date_Excepted__c=System.now().date()+3,Actual_Completion_Date__c = System.now().date()+6, Requested_Date_Expected__c=null,Payment_Slab__c=3,Requested_Amount__c=0);
        insert stagePaymentDetailsTest5;
        Stage_Payment_Details__c stagePaymentDetailsTest6 = new Stage_Payment_Details__c(Name='Stage Payment Details Test6',Booking_Information__c=bookingInformationTest.Id,Current_Date_Excepted__c=System.now().date()+5,Actual_Completion_Date__c =System.now().date()+7, Requested_Date_Expected__c=null,Payment_Slab__c=3,Requested_Amount__c=0);
        insert stagePaymentDetailsTest6;
        Stage_Payment_Details__c stagePaymentDetailsTest7 = new Stage_Payment_Details__c(Name='Stage Payment Details Test7',Booking_Information__c=bookingInformationTest.Id,Current_Date_Excepted__c=System.now().date()+5,Actual_Completion_Date__c = System.now().date()+7, Requested_Date_Expected__c=null,Payment_Slab__c=3,Requested_Amount__c=0);
        insert stagePaymentDetailsTest7;
        Stage_Payment_Details__c stagePaymentDetailsTest8 = new Stage_Payment_Details__c(Name='Stage Payment Details Test8',Booking_Information__c=bookingInformationTest.Id,Current_Date_Excepted__c=System.now().date()+7,Actual_Completion_Date__c = System.now().date()+8, Requested_Date_Expected__c=null,Payment_Slab__c=3,Requested_Amount__c=0);
        insert stagePaymentDetailsTest8;        
        Stage_Payment_Details__c stagePaymentDetailsTest9 = new Stage_Payment_Details__c(Name='Stage Payment Details Test9',Booking_Information__c=bookingInformationTest.Id,Current_Date_Excepted__c=System.now().date()+7,Actual_Completion_Date__c = null, Requested_Date_Expected__c=null,Payment_Slab__c=3,Requested_Amount__c=0);
        insert stagePaymentDetailsTest9;
        Stage_Payment_Details__c stagePaymentDetailsTest10 = new Stage_Payment_Details__c(Name='Stage Payment Details Test10',Booking_Information__c=bookingInformationTest.Id,Current_Date_Excepted__c=System.now().date()+9,Actual_Completion_Date__c =null, Requested_Date_Expected__c=null,Payment_Slab__c=3,Requested_Amount__c=0);
        insert stagePaymentDetailsTest10;
        Stage_Payment_Details__c stagePaymentDetailsTest11 = new Stage_Payment_Details__c(Name='Stage Payment Details Test11',Booking_Information__c=bookingInformationTest.Id,Current_Date_Excepted__c=System.now().date()+10,Actual_Completion_Date__c = null, Requested_Date_Expected__c=null,Payment_Slab__c=3,Requested_Amount__c=0);
        insert stagePaymentDetailsTest11;
        
        PageReference ref2=new PageReference('/apex/TestSpScudApproval');
        Test.setCurrentPage(ref2);
        
        ref2.getParameters().put('bid',bookingInformationTest.id);
        
        ScudEmailTemplateController ScudEmailTemplateControllerTest2=new ScudEmailTemplateController();
      
        ScudEmailTemplateControllerTest2.CalculateNPV();
        ScudEmailTemplateControllerTest2.Submit();
        
        
        
        
    
    } */
}