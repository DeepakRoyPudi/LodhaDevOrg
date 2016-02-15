@isTest
Public class TestSpSearchInventoryController{

Public static testMethod void SpSearchInventoryControllerTest(){
    
    SpTestInsertions spTestInsertions = new SpTestInsertions();
    
     Account accountTest = new Account(recordtypeid =Schema.SObjectType.Account.getRecordTypeInfosByName().get('Booked Account').getRecordTypeId(),LastName ='Test Last Name',Mobile_Phone__c ='456872934');
     insert accountTest;
    
     Project_Name__c projectNameTest = spTestInsertions.createProjectName();
     insert projectNameTest;    
    
     Cluster__c clusterTest = spTestInsertions.createCluster(projectNameTest);
     insert clusterTest;
      
    
   //   Stage__c stageTest = spTestInsertions.createStage();
   //   insert stageTest;
    
      Wing__c wingTest = spTestInsertions.createWing(clusterTest);
      insert wingTest;
      
       Wing__c wingTest1 = spTestInsertions.createWing(clusterTest);
      insert wingTest1;
    
    
      Flat_Type__c flatTypeTest = spTestInsertions.createFlatType(wingTest);
      insert flatTypeTest;
      
      Flat_Type__c flatTypeTest1 = spTestInsertions.createFlatType(wingTest1);
      insert flatTypeTest1;
    
      Stage_Details__c stageDetailsTest = spTestInsertions.createStageDetails(wingTest);
      insert stageDetailsTest;
      
      Stage_Details__c stageDetailsTest1 = spTestInsertions.createStageDetails(wingTest1);
      insert stageDetailsTest1;
        
      View_type_Assignment__c viewTypeAssignTest1 = new View_type_Assignment__c(Wing__c=wingTest.Id,Flat_Type__c=flatTypeTest.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('Flat Type Record').getRecordTypeId(),Pattern__c ='All',  Column_Index__c = '1');
      insert viewTypeAssignTest1;
      
      View_type_Assignment__c viewTypeAssignTest2 = new View_type_Assignment__c(Wing__c=wingTest.Id,Flat_Type__c=flatTypeTest.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('Flat Type Record').getRecordTypeId(),Pattern__c ='All',  Column_Index__c = '2');
      insert viewTypeAssignTest2;
    
      View_type_Assignment__c viewTypeAssignTest3 = new View_type_Assignment__c(Wing__c=wingTest.Id,Flat_Type__c=flatTypeTest.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('View Type Record').getRecordTypeId(),Pattern__c ='All',View__c='Sea View',  Column_Index__c = '1');
      insert viewTypeAssignTest3;
      
      View_type_Assignment__c viewTypeAssignTest4 = new View_type_Assignment__c(Wing__c=wingTest.Id,Flat_Type__c=flatTypeTest.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('View Type Record').getRecordTypeId(),Pattern__c ='All',View__c='Sea View',  Column_Index__c = '2');
      insert viewTypeAssignTest4;
      
      View_type_Assignment__c viewTypeAssignTest5 = new View_type_Assignment__c(Wing__c=wingTest1.Id,Flat_Type__c=flatTypeTest1.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('Flat Type Record').getRecordTypeId(),Pattern__c ='All',  Column_Index__c = '1');
      insert viewTypeAssignTest5;
      
      View_type_Assignment__c viewTypeAssignTest6 = new View_type_Assignment__c(Wing__c=wingTest1.Id,Flat_Type__c=flatTypeTest1.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('Flat Type Record').getRecordTypeId(),Pattern__c ='All',  Column_Index__c = '2');
      insert viewTypeAssignTest6;
      
       View_type_Assignment__c viewTypeAssignTest7 = new View_type_Assignment__c(Wing__c=wingTest1.Id,Flat_Type__c=flatTypeTest1.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('View Type Record').getRecordTypeId(),Pattern__c ='All',View__c='Garden View',  Column_Index__c = '1');
      insert viewTypeAssignTest7;
      
      
       View_type_Assignment__c viewTypeAssignTest8 = new View_type_Assignment__c(Wing__c=wingTest1.Id,Flat_Type__c=flatTypeTest1.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('View Type Record').getRecordTypeId(),Pattern__c ='All',View__c='Garden View',  Column_Index__c = '2');
      insert viewTypeAssignTest8;
    
      Rate_Card__c rateCardTest1 = new Rate_Card__c (Wing__c=wingTest.Id,recordtypeid=Schema.SObjectType.Rate_Card__c.getRecordTypeInfosByName().get('Premium View Rate Record').getRecordTypeId(),Flat_Type__c=flatTypeTest.Id,Premium_View__c='Sea View',View_Rate_Sq_Ft__c=20);
      insert rateCardTest1;
    
      Rate_Card__c rateCardTest2 = new Rate_Card__c (Wing__c=wingTest.Id,recordtypeid=Schema.SObjectType.Rate_Card__c.getRecordTypeInfosByName().get('Floor Rise Rate').getRecordTypeId(),Flat_Type__c=flatTypeTest.Id,Floor_From__c=1,Floor_To__c=2,Floor_Rise_Sq_Ft__c=20);
      insert rateCardTest2;
      
      Rate_Card__c rateCardTest3 = new Rate_Card__c (Wing__c=wingTest1.Id,recordtypeid=Schema.SObjectType.Rate_Card__c.getRecordTypeInfosByName().get('Premium View Rate Record').getRecordTypeId(),Flat_Type__c=flatTypeTest1.Id,Premium_View__c='Garden View',View_Rate_Sq_Ft__c=20);
      insert rateCardTest3;
      
      Rate_Card__c rateCardTest4 = new Rate_Card__c (Wing__c=wingTest1.Id,recordtypeid=Schema.SObjectType.Rate_Card__c.getRecordTypeInfosByName().get('Floor Rise Rate').getRecordTypeId(),Flat_Type__c=flatTypeTest1.Id,Floor_From__c=1,Floor_To__c=2,Floor_Rise_Sq_Ft__c=20);
      insert rateCardTest4;
    
    
    /*ApexPages.StandardController stc = new ApexPages.StandardController(wingTest); 
    SpGenerateInventory testSpGenerateInventory = new SpGenerateInventory(stc);
    testSpGenerateInventory.generateInventory();
 
    Flat__c FlatTest = [select Id,Salable_Area__c from Flat__c Where Wing__c=:wingTest.Id limit 1]; */
    
    Flat__c FlatTest = new Flat__c(Flat_No__c=101,Flat_Type__c = flatTypeTest.Id,View__c='Sea View',Wing__c =wingTest.Id,Status__c='BOOKING',Consideration_Rs__c=6);
    insert FlatTest;
    
    Flat__c FlatTest1 = new Flat__c(Flat_No__c=101,Flat_Type__c = flatTypeTest1.Id,View__c='Garden View',Wing__c =wingTest1.Id,Status__c='BLOCKED',Consideration_Rs__c=6);
    insert FlatTest1;
        
    Opportunity opportunityTest = new Opportunity(Name='Test Opportunity',recordtypeid =Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Residential').getRecordTypeId(),Account = accountTest,CloseDate=System.now().date()+20,Project_Name__c = projectNameTest.id,StageName = 'Qualified',Servicing_Team__c='Presales',IsActive__c=true);
    insert opportunityTest; 
   
    Booking_Information__c bookingInformationTest= new Booking_Information__c(Parking_Nos_4w__c=10,Name_Of_Opportunity__c=opportunityTest.id,Unique_booking_Id__c=FlatTest.id,Flat__c=FlatTest.id,Block_Detail__c='Test Block Details',Consideration_Actual_Rs__c=10000,Infrastructure_Incl_in_CV__c='Incl.in CV',Infrastructure2_Incl_in_CV__c='Incl.in CV',Club_Charges_Incl_in_CV__c='Incl.in CV',Infrastructure_Cost_Rs__c=100,Infrastructure_Cost_2_Rs__c=100,Club_Charges_Rs__c=100,Infrastructure_Cost_2Actual_Rs__c=100,Infrastructure_Cost_Actual_Rs__c=150,Club_charges_Actual_Rs__c=100,Base_Rate_Sq_ft_Actual_Rs__c=120,Floor_rise_Sq_ft_Actual_Rs__c=120,Premium_Sq_ft_Actual_Rs__c=120,Applicable_Waiver_Sq_ft_Actual_Rs__c=120,Total_Rate_Sq_ft_Actual_Rs__c=120,Flat_Cost_Actual_Rs__c=120,Applicable_Waiver_Sq_ft_Rs__c=100,Booking_Date__c=System.now().date());
    insert bookingInformationTest;
    Test.startTest();
    PageReference ref = new PageReference('/apex/SpSearchInventoryController');
    Test.setCurrentPage(ref);
    ref.getParameters().put('proj','Test Project Name');
    ref.getParameters().put('oppid',opportunityTest.id);
    
     //when no project is selected.
     SpSearchInventoryController sp7 = new SpSearchInventoryController(); 
     sp7.selectedProjID=null; 
     sp7.doSearch();

     // normal search
    SpSearchInventoryController sp = new SpSearchInventoryController();  
   sp.getProjectsSelectionList(); 
    sp.getClusterSelectionList(); 
    sp.getWingsSelectionList();
    sp.getFlatTypeSelectionList();
    sp.getFlatStatusSelectionList();
    sp.getViewSelectionList();   
    sp.selectedProjID=projectNameTest.Id;
    sp.updateList();
    sp.selectedclsuterID=clusterTest.Id; 
    sp.selectedwingID=wingTest.Id;
    sp.selectedflattypeID = flatTypeTest.Id;
    sp.selectedviewvalue = 'Sea View';  
    sp.selectedflatstatus ='BOOKING';   
    sp.value_from = 0;
    sp.value_to =10;
    sp.updateList();
    sp.doSearch();
    
    
     // normal search with selection different.
    SpSearchInventoryController sp9 = new SpSearchInventoryController();  
    sp9.getProjectsSelectionList(); 
    sp9.getClusterSelectionList(); 
    sp9.getWingsSelectionList();
    sp9.getFlatTypeSelectionList();
    sp9.getFlatStatusSelectionList();
    sp9.getViewSelectionList();   
    sp9.selectedProjID=projectNameTest.Id;
    sp9.updateList();
    sp9.selectedclsuterID=clusterTest.Id; 
    sp9.selectedwingID=wingTest1.Id;
    sp9.selectedflattypeID = flatTypeTest.Id;
    sp9.selectedviewvalue = 'Sea View';  
    sp9.selectedflatstatus ='BOOKING';   
    sp9.value_from = 0;
    sp9.value_to =0;
    sp9.floor_no_from =0;
    sp9.floor_no_to =0;
    sp9.updateList();
    sp9.doSearch();
    
    
    
    //floor range search and flat no last digit
    SpSearchInventoryController sp2 = new SpSearchInventoryController();
    sp2.proj = 'Test Project Name';
    sp2.opp_id = opportunityTest.id;
    sp2.selectedProjID=projectNameTest.Id;
    sp2.value_from = 2;
    sp2.value_to =10;
    sp2.flat_no_option='last_digit';
    sp2.flat_no = '05';
    sp2.doSearch();
    
    //flat no & status
    SpSearchInventoryController sp3 = new SpSearchInventoryController();
    sp3.proj = 'Test Project Name';
    sp3.opp_id = opportunityTest.id;
    sp3.selectedProjID=projectNameTest.Id;
    sp3.flat_no_option='exact_no';
    sp3.flat_no = '202';
    sp3.selectedflatstatus ='OPEN';
    sp3.doSearch();
    
    //Cv value
    SpSearchInventoryController sp4 = new SpSearchInventoryController();
    sp4.proj = 'Test Project Name';
    sp4.opp_id = opportunityTest.id;
    sp4.selectedProjID=projectNameTest.Id;
    sp4.selectedflatstatus ='OPEN';
    sp4.value_from = 150000;
    sp4.value_to = 200000;
    sp4.doSearch();
    
    // Cluster selection
    SpSearchInventoryController sp5 = new SpSearchInventoryController();
    sp5.getProjectsSelectionList();
    sp5.selectedProjID=projectNameTest.Id;
    sp5.getClusterSelectionList(); 
    sp5.selectedclsuterID=clusterTest.Id; 
    sp5.doSearch();
    
     
    // Cluster and Wing selection
    SpSearchInventoryController sp6 = new SpSearchInventoryController();
    sp6.getProjectsSelectionList();
    sp6.selectedProjID=projectNameTest.Id;
    sp6.getClusterSelectionList(); 
    sp6.selectedclsuterID=clusterTest.Id; 
    sp6.getWingsSelectionList();
    sp6.selectedwingID=wingTest.Id;
    sp6.doSearch();
    
    // proj id nd opp id is null.
    
    PageReference ref1 = new PageReference('/apex/SpSearchInventoryController');
    Test.setCurrentPage(ref1);
    ref1.getParameters().put('proj',null);
    ref1.getParameters().put('oppid',null);
    SpSearchInventoryController sp8 = new SpSearchInventoryController(); 
       
   
}   
}