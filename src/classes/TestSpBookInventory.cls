@isTest(seeAllData=false)
Public Class TestSpBookInventory{

Public static Testmethod void SpBookInventoryTest(){

  SpTestInsertions spTestInsertions = new spTestInsertions();
  SpTestInsertions spTestInsertions1 = new spTestInsertions();
  SpTestInsertions sp1 = new SpTestInsertions();
  SpTestInsertions sp2 = new SpTestInsertions();

    List<Account> accountsList = new List<Account>();
    List<Project_Name__c> projectNameList = new List<Project_Name__c >();
    List<Cluster__c> clusterList = new List<Cluster__c>();
    List<Wing__c> wingsList = new List<Wing__C>();
    List<Flat_Type__c> flatTypeList = new List<Flat_Type__c>();
    List<Stage_Details__c> stageDetailsList = new List<Stage_Details__c>();
    List<View_type_Assignment__c> viewTypeList = new List<View_type_Assignment__c>();
    List<Rate_Card__c> rateCardList = new List<Rate_Card__c>();
    List<Opportunity> opportunityList = new List<Opportunity>();
    List<Booking_Information__c> bookingInfoList = new List<Booking_Information__c>();
    
    //test for corporate    
    
    
    
  
    Corporate_connection__c corporateConnectionTest = new Corporate_connection__c(Name = 'Test Corporate Connection',Applicable_Discount__c = 100);
    insert corporateConnectionTest;
     Corporate_connection__c corporateConnectionTest3 = new Corporate_connection__c(Name = 'Test Corporate Connection',Applicable_Discount__c = 100);
    insert corporateConnectionTest3;
     
    
   Account accountTest = new Account(CRN__c='CRN',recordtypeid =Schema.SObjectType.Account.getRecordTypeInfosByName().get('Booked Account').getRecordTypeId(),LastName ='Test Last Name',Mobile_Phone__c='1234567890');
  //  insert accountTest;
  accountsList.add(accountTest);
    
    Account accountTest1 = new Account(CRN__c='CRN1',LoyaltyID__c ='1234',recordtypeid =Schema.SObjectType.Account.getRecordTypeInfosByName().get('Booked Account').getRecordTypeId(),LastName ='Test Last Name',Mobile_Phone__c ='1234567890');
 
     accountsList.add(accountTest1);
     
      Account accountTest2 = new Account(LoyaltyID__c ='11256',recordtypeid =Schema.SObjectType.Account.getRecordTypeInfosByName().get('Booked Account').getRecordTypeId(),LastName ='Test Last Name',Mobile_Phone__c ='1234567890');
   
     accountsList.add(accountTest2);
 Test.startTest();
       insert accountsList;
           
    Project_Name__c projectNameTest = new Project_Name__c(Name='Project Name',CRN_INIT__c= 'LCY',Project_Type__c = 'Test Casa',Record_Type__c='Commercial and Retail',Project_Manager__c=UserInfo.getUserId(),Site_Incharge__c=UserInfo.getUserId(),Project_Incharge__c=UserInfo.getUserId(),DAM_Limit__c=120,Physically_Disabled_Discount__c=100);

    projectNameList.add(projectNameTest);
    
     Project_Name__c projectNameTest1 = spTestInsertions.createProjectName();
      projectNameList.add(projectNameTest1);

    
     Project_Name__c projectNameTest2 = new Project_Name__c(Name='Project Name2',CRN_INIT__c= 'LCU',Project_Type__c = 'Test Cap',Record_Type__c='Residential',Project_Manager__c=UserInfo.getUserId(),Site_Incharge__c=UserInfo.getUserId(),Project_Incharge__c=UserInfo.getUserId(),DAM_Limit__c=100,Special_Offer__c=300);

  projectNameList.add(projectNameTest2);
  
   Project_Name__c projectNameTest3 = new Project_Name__c(Name='Project Name3',CRN_INIT__c= 'LCE',Project_Type__c = 'Test Casa',Record_Type__c='Commercial and Retail',Project_Manager__c=UserInfo.getUserId(),Site_Incharge__c=UserInfo.getUserId(),Project_Incharge__c=UserInfo.getUserId(),DAM_Limit__c=120);
 
     projectNameList.add(projectNameTest3);
     
     Project_Name__c projectNameTest4 = new Project_Name__c(Name='Project Name4',CRN_INIT__c= 'LCR',Project_Type__c = 'Test Casario',Record_Type__c='Commercial and Retail',Project_Manager__c=UserInfo.getUserId(),Site_Incharge__c=UserInfo.getUserId(),Project_Incharge__c=UserInfo.getUserId(),DAM_Limit__c=120);
 
     projectNameList.add(projectNameTest4);
  
  insert projectNameList;
  
    
    Cluster__c clusterTest = new Cluster__c(Name='Test Cluster',Project_Name__c = projectNameTest.Id);
  
     clusterList.add(clusterTest); 
     
        Cluster__c clusterTest1 = spTestInsertions.createCluster(projectNameTest1);
      
         clusterList.add(clusterTest1); 
      
         Cluster__c clusterTest2 = new Cluster__c(Name='Test Cluster2',Project_Name__c = projectNameTest2.Id);
      
       clusterList.add(clusterTest2); 
       
       
    
    Cluster__c clusterTest3 = new Cluster__c(Name='Test Cluster3',Project_Name__c = projectNameTest3.Id);
 
   clusterList.add(clusterTest3); 
   
   insert clusterList;
   

       
    Wing__c wingTest = new Wing__c(Name='Test Wing',Cluster__c=clusterTest.Id,No_of_Floors__c=3,No_of_flats_floor__c=2);
  wingTest.Project_Incharge_Relationship_Manager__c = projectNameTest.Project_Manager__c;
   wingsList.add(wingTest);
   
       
    
        Wing__c wingTest1 = spTestInsertions.createWing(clusterTest1);
     wingTest1.Project_Incharge_Relationship_Manager__c = projectNameTest1.Project_Manager__c;
     wingsList.add(wingTest1);
    
        Wing__c wingTest2 = new Wing__c(Name='Test Wing2',Cluster__c=clusterTest2.Id,No_of_Floors__c=7,No_of_flats_floor__c=2);
      wingTest2.Project_Incharge_Relationship_Manager__c = projectNameTest2.Project_Manager__c;
      wingsList.add(wingTest2);
      
          
    Wing__c wingTest3 = new Wing__c(Name='Test Wing3',Cluster__c=clusterTest3.Id,No_of_Floors__c=3,No_of_flats_floor__c=2);
    wingTest3.Project_Incharge_Relationship_Manager__c = projectNameTest3.Project_Manager__c;
      wingsList.add(wingTest3);
      
             
    Wing__c wingTest4 = new Wing__c(Name='Test Wing4',Cluster__c=clusterTest.Id,No_of_Floors__c=5,No_of_flats_floor__c=2);
    wingTest4.Project_Incharge_Relationship_Manager__c = projectNameTest4.Project_Manager__c;
      wingsList.add(wingTest4);
    
    insert wingsList;
   
    Flat_Type__c flatTypeTest = sp1.createFlatType(wingTest);
  
  flatTypeList.add(flatTypeTest);

 Flat_Type__c flatTypeTest1 = spTestInsertions.createFlatType(wingTest1);

 flatTypeList.add(flatTypeTest1);

 Flat_Type__c flatTypeTest2 = spTestInsertions1.createFlatType(wingTest2);
      
    flatTypeList.add(flatTypeTest2);

 Flat_Type__c flatTypeTest3 = sp2.createFlatType(wingTest3);

  flatTypeList.add(flatTypeTest3);
  
  Flat_Type__c flatTypeTest4 = sp2.createFlatType(wingTest4);
 
  flatTypeList.add(flatTypeTest4);
    
 insert flatTypeList;
    
    Stage_Details__c stageDetailsTest = sp1.createStageDetails(wingTest);
 
  stageDetailsList.add(stageDetailsTest);


      Stage_Details__c stageDetailsTest1 = spTestInsertions.createStageDetails(wingTest1);
  
stageDetailsList.add(stageDetailsTest1);

         Stage_Details__c stageDetailsTest2 = spTestInsertions1.createStageDetails(wingTest2);
  
stageDetailsList.add(stageDetailsTest2);

Stage_Details__c stageDetailsTest3 = sp2.createStageDetails(wingTest3);
  
    stageDetailsList.add(stageDetailsTest3);
    
    insert stageDetailsList;
        
    View_type_Assignment__c viewTypeAssignTest1 = new View_type_Assignment__c(Wing__c=wingTest.Id,Flat_Type__c=flatTypeTest.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('Flat Type Record').getRecordTypeId(),Pattern__c ='All',  Column_Index__c = '1');

   viewTypeList.add(viewTypeAssignTest1);
    
    View_type_Assignment__c viewTypeAssignTest2 = new View_type_Assignment__c(Wing__c=wingTest.Id,Flat_Type__c=flatTypeTest.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('Flat Type Record').getRecordTypeId(),Pattern__c ='All',  Column_Index__c = '2');

   viewTypeList.add(viewTypeAssignTest2);
   
    View_type_Assignment__c viewTypeAssignTest3 = new View_type_Assignment__c(Wing__c=wingTest.Id,Flat_Type__c=flatTypeTest.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('View Type Record').getRecordTypeId(),Pattern__c ='All',View__c='Sea View', Column_Index__c = '1');
  
     viewTypeList.add(viewTypeAssignTest3);
     
     View_type_Assignment__c viewTypeAssignTest4 = new View_type_Assignment__c(Wing__c=wingTest.Id,Flat_Type__c=flatTypeTest.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('View Type Record').getRecordTypeId(),Pattern__c ='All',View__c='Sea View', Column_Index__c = '2');
  
     viewTypeList.add(viewTypeAssignTest4);

   
      View_type_Assignment__c viewTypeAssignTest5 = new View_type_Assignment__c(Wing__c=wingTest1.Id,Flat_Type__c=flatTypeTest1.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('Flat Type Record').getRecordTypeId(),Pattern__c ='All', Column_Index__c = '1');
 
  viewTypeList.add(viewTypeAssignTest5);
  
  View_type_Assignment__c viewTypeAssignTest6 = new View_type_Assignment__c(Wing__c=wingTest1.Id,Flat_Type__c=flatTypeTest1.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('Flat Type Record').getRecordTypeId(),Pattern__c ='All', Column_Index__c = '2');
 
  viewTypeList.add(viewTypeAssignTest6);
    
      View_type_Assignment__c viewTypeAssignTest7 = new View_type_Assignment__c(Wing__c=wingTest1.Id,Flat_Type__c=flatTypeTest1.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('View Type Record').getRecordTypeId(),Pattern__c ='All',View__c='Sea View', Column_Index__c = '1');
 
  viewTypeList.add(viewTypeAssignTest7);
  
  View_type_Assignment__c viewTypeAssignTest8 = new View_type_Assignment__c(Wing__c=wingTest1.Id,Flat_Type__c=flatTypeTest1.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('View Type Record').getRecordTypeId(),Pattern__c ='All',View__c='Sea View', Column_Index__c = '2');
 
  viewTypeList.add(viewTypeAssignTest8);
    

 View_type_Assignment__c viewTypeAssignTest9 = new View_type_Assignment__c(Wing__c=wingTest2.Id,Flat_Type__c=flatTypeTest2.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('Flat Type Record').getRecordTypeId(),Pattern__c ='All', Column_Index__c = '1');
  
 viewTypeList.add(viewTypeAssignTest9);
 
  View_type_Assignment__c viewTypeAssignTest10 = new View_type_Assignment__c(Wing__c=wingTest2.Id,Flat_Type__c=flatTypeTest2.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('Flat Type Record').getRecordTypeId(),Pattern__c ='All', Column_Index__c = '2');
  
 viewTypeList.add(viewTypeAssignTest10);
    
        View_type_Assignment__c viewTypeAssignTest11 = new View_type_Assignment__c(Wing__c=wingTest2.Id,Flat_Type__c=flatTypeTest2.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('View Type Record').getRecordTypeId(),Pattern__c ='All',View__c='GardenView', Column_Index__c = '1');
    
     viewTypeList.add(viewTypeAssignTest11);
     
     View_type_Assignment__c viewTypeAssignTest12 = new View_type_Assignment__c(Wing__c=wingTest2.Id,Flat_Type__c=flatTypeTest2.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('View Type Record').getRecordTypeId(),Pattern__c ='All',View__c='GardenView', Column_Index__c = '2');
    
     viewTypeList.add(viewTypeAssignTest12);

     
    View_type_Assignment__c viewTypeAssignTest13 = new View_type_Assignment__c(Wing__c=wingTest3.Id,Flat_Type__c=flatTypeTest3.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('Flat Type Record').getRecordTypeId(),Pattern__c ='All', Column_Index__c = '1');

 viewTypeList.add(viewTypeAssignTest13);
 
 View_type_Assignment__c viewTypeAssignTest14 = new View_type_Assignment__c(Wing__c=wingTest3.Id,Flat_Type__c=flatTypeTest3.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('Flat Type Record').getRecordTypeId(),Pattern__c ='All', Column_Index__c = '2');

 viewTypeList.add(viewTypeAssignTest14);
    
    View_type_Assignment__c viewTypeAssignTest15 = new View_type_Assignment__c(Wing__c=wingTest3.Id,Flat_Type__c=flatTypeTest3.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('View Type Record').getRecordTypeId(),Pattern__c ='All',View__c='Sea View', Column_Index__c = '1');

 viewTypeList.add(viewTypeAssignTest15); 
 
 View_type_Assignment__c viewTypeAssignTest16 = new View_type_Assignment__c(Wing__c=wingTest3.Id,Flat_Type__c=flatTypeTest3.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('View Type Record').getRecordTypeId(),Pattern__c ='All',View__c='Sea View', Column_Index__c = '2');

 viewTypeList.add(viewTypeAssignTest16);   
 
  View_type_Assignment__c viewTypeAssignTest17 = new View_type_Assignment__c(Wing__c=wingTest4.Id,Flat_Type__c=flatTypeTest4.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('Flat Type Record').getRecordTypeId(),Pattern__c ='All', Column_Index__c = '1');
 
 viewTypeList.add(viewTypeAssignTest17);
 
 View_type_Assignment__c viewTypeAssignTest18 = new View_type_Assignment__c(Wing__c=wingTest4.Id,Flat_Type__c=flatTypeTest4.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('Flat Type Record').getRecordTypeId(),Pattern__c ='All', Column_Index__c = '2');
 
 viewTypeList.add(viewTypeAssignTest18);
    
    View_type_Assignment__c viewTypeAssignTest19 = new View_type_Assignment__c(Wing__c=wingTest4.Id,Flat_Type__c=flatTypeTest4.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('View Type Record').getRecordTypeId(),Pattern__c ='All',View__c='Sea View', Column_Index__c = '1');

 viewTypeList.add(viewTypeAssignTest19);    


View_type_Assignment__c viewTypeAssignTest20 = new View_type_Assignment__c(Wing__c=wingTest4.Id,Flat_Type__c=flatTypeTest4.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('View Type Record').getRecordTypeId(),Pattern__c ='All',View__c='Sea View', Column_Index__c = '2');

 viewTypeList.add(viewTypeAssignTest20);    

 insert viewTypeList;

    
    Rate_Card__c rateCardTest1 = new Rate_Card__c (Wing__c=wingTest.Id,recordtypeid=Schema.SObjectType.Rate_Card__c.getRecordTypeInfosByName().get('Premium View Rate Record').getRecordTypeId(),Flat_Type__c=flatTypeTest.Id,Premium_View__c='Sea View',View_Rate_Sq_Ft__c=20);

  rateCardList.add(rateCardTest1);
    
    Rate_Card__c rateCardTest2 = new Rate_Card__c (Wing__c=wingTest.Id,recordtypeid=Schema.SObjectType.Rate_Card__c.getRecordTypeInfosByName().get('Floor Rise Rate').getRecordTypeId(),Flat_Type__c=flatTypeTest.Id,Floor_From__c=1,Floor_To__c=2,Floor_Rise_Sq_Ft__c=20);
 
 rateCardList.add(rateCardTest2);

  
      Rate_Card__c rateCardTest3 = new Rate_Card__c (Wing__c=wingTest1.Id,recordtypeid=Schema.SObjectType.Rate_Card__c.getRecordTypeInfosByName().get('Premium View Rate Record').getRecordTypeId(),Flat_Type__c=flatTypeTest1.Id,Premium_View__c='Sea View',View_Rate_Sq_Ft__c=20);
  
rateCardList.add(rateCardTest3);

    
      Rate_Card__c rateCardTest4 = new Rate_Card__c (Wing__c=wingTest1.Id,recordtypeid=Schema.SObjectType.Rate_Card__c.getRecordTypeInfosByName().get('Floor Rise Rate').getRecordTypeId(),Flat_Type__c=flatTypeTest1.Id,Floor_From__c=1,Floor_To__c=2,Floor_Rise_Sq_Ft__c=20);

rateCardList.add(rateCardTest4);

  Rate_Card__c rateCardTest5 = new Rate_Card__c (Wing__c=wingTest2.Id,recordtypeid=Schema.SObjectType.Rate_Card__c.getRecordTypeInfosByName().get('Premium View Rate Record').getRecordTypeId(),Flat_Type__c=flatTypeTest2.Id,Premium_View__c='Sea View',View_Rate_Sq_Ft__c=20);

rateCardList.add(rateCardTest5);

    
        Rate_Card__c rateCardTest6 = new Rate_Card__c (Wing__c=wingTest2.Id,recordtypeid=Schema.SObjectType.Rate_Card__c.getRecordTypeInfosByName().get('Floor Rise Rate').getRecordTypeId(),Flat_Type__c=flatTypeTest2.Id,Floor_From__c=1,Floor_To__c=2,Floor_Rise_Sq_Ft__c=20);
 
    rateCardList.add(rateCardTest6);

 Rate_Card__c rateCardTest7 = new Rate_Card__c (Wing__c=wingTest3.Id,recordtypeid=Schema.SObjectType.Rate_Card__c.getRecordTypeInfosByName().get('Premium View Rate Record').getRecordTypeId(),Flat_Type__c=flatTypeTest3.Id,Premium_View__c='Sea View',View_Rate_Sq_Ft__c=20);


    rateCardList.add(rateCardTest7);
    
    Rate_Card__c rateCardTest8 = new Rate_Card__c (Wing__c=wingTest3.Id,recordtypeid=Schema.SObjectType.Rate_Card__c.getRecordTypeInfosByName().get('Floor Rise Rate').getRecordTypeId(),Flat_Type__c=flatTypeTest3.Id,Floor_From__c=1,Floor_To__c=2,Floor_Rise_Sq_Ft__c=20);

    
    rateCardList.add(rateCardTest8);
    
     Rate_Card__c rateCardTest9 = new Rate_Card__c (Wing__c=wingTest4.Id,recordtypeid=Schema.SObjectType.Rate_Card__c.getRecordTypeInfosByName().get('Premium View Rate Record').getRecordTypeId(),Flat_Type__c=flatTypeTest4.Id,Premium_View__c='Sea View',View_Rate_Sq_Ft__c=20);
 

    rateCardList.add(rateCardTest9);
    
    Rate_Card__c rateCardTest10 = new Rate_Card__c (Wing__c=wingTest4.Id,recordtypeid=Schema.SObjectType.Rate_Card__c.getRecordTypeInfosByName().get('Floor Rise Rate').getRecordTypeId(),Flat_Type__c=flatTypeTest4.Id,Floor_From__c=1,Floor_To__c=2,Floor_Rise_Sq_Ft__c=20);

    
    rateCardList.add(rateCardTest10);
    
 
   insert rateCardList;
 
    
    Opportunity opportunityTestNew = new Opportunity(Name='Test Opportunity',recordtypeid =Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Commercial and Retail').getRecordTypeId(),Account = accountTest,CloseDate=System.now().date()+20,Project_Name__c = projectNameTest.id,StageName = 'Qualified',Servicing_Team__c='Presales',Name_of_PSC__c='Amarjyot Kaur',IsActive__c=true,Walk_in_Source__c='Newspaper',LoyaltyID__c='LoyaltyID',Visit_Form_No__c='V19857678',Date_of_Visit__c=System.now().date());
  
   opportunityList.add(opportunityTestNew);

 
        
     Opportunity opportunityTest1 = new Opportunity(Name='NEw Opportunity',recordtypeid =Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Residential').getRecordTypeId(),Account = accountTest1,CloseDate=System.now().date()+20,Project_Name__c = projectNameTest1.id,StageName = 'Qualified',Servicing_Team__c='Presales',IsActive__c=true);
 
          opportunityList.add(opportunityTest1);


   
       Channel_Partner__c channelPartnerTest = new Channel_Partner__c(Name ='Channel Partner Test',REAP_ID__c='ReapId12'); 
       insert channelPartnerTest; 
        
       Opportunity opp = new Opportunity(Name='Opportunity1',recordtypeid =Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Residential').getRecordTypeId(),Account = accountTest2 ,CloseDate=System.now().date()+20,Project_Name__c = projectNameTest2.id,StageName = 'Qualification',Servicing_Team__c='Presales',IsActive__c=true);
      
         opportunityList.add(opp);


     
   
    Opportunity opportunityTestNew3 = new Opportunity(Name='Test Opportunity for blocking3',recordtypeid =Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Commercial and Retail').getRecordTypeId(),Account = accountTest,CloseDate=System.now().date()+20,Project_Name__c = projectNameTest3.id,StageName = 'Qualified',Servicing_Team__c='Presales',Name_of_PSC__c='Amarjyot Kaur',IsActive__c=true,Walk_in_Source__c='Newspaper',LoyaltyID__c='LoyaltyID123',Visit_Form_No__c='V0000077',Date_of_Visit__c=System.now().date());
   
    opportunityList.add(opportunityTestNew3);
    
     
    Opportunity opportunityTestNew4 = new Opportunity(Name='Test Opportunity4',recordtypeid =Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Commercial and Retail').getRecordTypeId(),Account = accountTest,CloseDate=System.now().date()+20,Project_Name__c = projectNameTest.id,StageName = 'Qualified',Servicing_Team__c='Presales',Name_of_PSC__c='Amarjyot Kaur',IsActive__c=true,Walk_in_Source__c='Newspaper',LoyaltyID__c='LoyaltyID',Date_of_Visit__c=System.now().date());
   opportunityList.add(opportunityTestNew4);
    
     Opportunity opportunityTestNew5 = new Opportunity(Name='Test Opportunity5',recordtypeid =Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Residential').getRecordTypeId(),Account = accountTest1,CloseDate=System.now().date()+20,Project_Name__c = projectNameTest.id,StageName = 'Qualified',Servicing_Team__c='Presales',Name_of_PSC__c='Amarjyot Kaur',IsActive__c=true);
   opportunityList.add(opportunityTestNew5);
   
    ApexPages.StandardController stc = new ApexPages.StandardController(wingTest); 
    SpGenerateInventory testSpGenerateInventory = new SpGenerateInventory(stc);
    testSpGenerateInventory.generateInventory();
 
    Flat__c f = [select Id,Salable_Area__c from Flat__c Where Wing__c=:wingTest.Id limit 1]; 
    
     ApexPages.StandardController stc1 = new ApexPages.StandardController(wingTest1); 
    SpGenerateInventory testSpGenerateInventory1 = new SpGenerateInventory(stc1);
    testSpGenerateInventory1.generateInventory();
 
    Flat__c FlatTest1 = [select Id,Salable_Area__c from Flat__c Where Wing__c=:wingTest1.Id limit 1]; 
    
    
       ApexPages.StandardController stc2 = new ApexPages.StandardController(wingTest2); 
       SpGenerateInventory testSpGenerateInventory2 = new SpGenerateInventory(stc2);
       testSpGenerateInventory2.generateInventory();
 
       Flat__c Flat2 = [select Id,Salable_Area__c from Flat__c Where Wing__c=:wingTest2.Id limit 1]; 
       
        ApexPages.StandardController stc3 = new ApexPages.StandardController(wingTest3); 
    SpGenerateInventory testSpGenerateInventory3 = new SpGenerateInventory(stc3);
    testSpGenerateInventory3.generateInventory();
 
    Flat__c f3 = [select Id,Salable_Area__c from Flat__c Where Wing__c=:wingTest3.Id limit 1]; 
    
     ApexPages.StandardController stc4 = new ApexPages.StandardController(wingTest4); 
    SpGenerateInventory testSpGenerateInventory4 = new SpGenerateInventory(stc4);
    testSpGenerateInventory4.generateInventory();
    
    Flat__c f4 = [select Id,Salable_Area__c from Flat__c Where Wing__c=:wingTest4.Id limit 1];
    
    
    Flat__c f5 = new Flat__c(Flat_No__c=1001,Wing__c=wingTest3.Id,View__c='Sea View', Total_Rate_Sq_Ft_Rs__c=100, Token_Amount_Rs__c=10000,Status__c='OPEN', Salable_Area__c=110, Premium_Sq_Ft_Rs__c=120,
                   Infrastructure_Incl_in_CV__c='Incl.in CV', Infrastructure_Cost_Rs__c=100, Infrastructure_Cost2_Rs__c=100, Infrastructure2_Incl_in_CV__c='Incl.in CV',
                   Floor__c=5, Floor_Rise_Sq_Ft_Rs__c=100, Flat_Type__c=flatTypeTest3.Id,
                   DAM_Offer_Sq_Ft_Rs__c=100, Consideration_Rs__c=100, Club_Charges_Rs__c=100, Club_Charges_Incl_in_CV__c='Incl.in CV', Carpet_Area__c=100, Base_Rate_Sq_Ft_Rs__c=100,
                   Applicable_Waiver_Sq_Ft_Rs__c=100, Amount_Due_Rs__c=5000);
    insert f5;
    
    
    
    
   insert   opportunityList ;
   
    
      Booking_Information__c bookingInformationTest= new Booking_Information__c(Name_Of_Opportunity__c=opportunityTestNew.id,Unique_booking_Id__c=f.id,flat__c=f.id,Booking_Status__c='BOOKING',Block_Detail__c='Test Block Details',Consideration_Actual_Rs__c=10000,Infrastructure_Incl_in_CV__c='Incl.in CV',Infrastructure2_Incl_in_CV__c='Incl.in CV',Club_Charges_Incl_in_CV__c='Incl.in CV',Infrastructure_Cost_Rs__c=100,Infrastructure_Cost_2_Rs__c=100,Club_Charges_Rs__c=100,Infrastructure_Cost_2Actual_Rs__c=100,Name_of_Applicant__c='Test Opportunity',Infrastructure_Cost_Actual_Rs__c=150,Club_charges_Actual_Rs__c=100,Base_Rate_Sq_ft_Actual_Rs__c=120,Floor_rise_Sq_ft_Actual_Rs__c=120,Premium_Sq_ft_Actual_Rs__c=120,Applicable_Waiver_Sq_ft_Actual_Rs__c=120,Total_Rate_Sq_ft_Actual_Rs__c=120,Flat_Cost_Actual_Rs__c=120,Applicable_Waiver_Sq_ft_Rs__c=100,Booking_Date__c=System.now().date(),DAM_Offer_Sq_ft_Actual_Rs__c=20,Selected_discount_type__c ='DAM',Corporate_connection__c=corporateConnectionTest.Id,CRN__c= 'CRN',Booking_By__c= 'News Paper',Customer_Type__c= 'Corporate',Sales_Person__c=UserInfo.getUserId(),Total__c = 1050000,Contact_Nos__c='1234567890',Total_Rate_Sq_ft_Rs__c=1500,Date_of_First_Visit__c=System.now().date());
  bookingInfoList.add(bookingInformationTest);


    
     Booking_Information__c bookingInformationTest1= new Booking_Information__c(Referral_CRN__c=accountTest1.CRN__C,Selected_discount_type__c ='SCUD',Booking_By__c = 'referral',Customer_Type__c= 'Employee',Name_Of_Opportunity__c=opportunityTest1.id,Unique_booking_Id__c=FlatTest1.id,Flat__c=FlatTest1.id,Block_Detail__c='Test Block Details',Consideration_Actual_Rs__c=10000,Infrastructure_Incl_in_CV__c='Incl.in CV',Infrastructure2_Incl_in_CV__c='Incl.in CV',Club_Charges_Incl_in_CV__c='Incl.in CV',Infrastructure_Cost_Rs__c=100,Infrastructure_Cost_2_Rs__c=100,Club_Charges_Rs__c=100,Infrastructure_Cost_2Actual_Rs__c=100,Infrastructure_Cost_Actual_Rs__c=150,Club_charges_Actual_Rs__c=100,Base_Rate_Sq_ft_Actual_Rs__c=120,Floor_rise_Sq_ft_Actual_Rs__c=120,Premium_Sq_ft_Actual_Rs__c=120,Applicable_Waiver_Sq_ft_Actual_Rs__c=120,Total_Rate_Sq_ft_Actual_Rs__c=120,Flat_Cost_Actual_Rs__c=120,Applicable_Waiver_Sq_ft_Rs__c=100,Booking_Date__c=System.now().date());
     bookingInfoList.add(bookingInformationTest1);



 Booking_Information__c bookingInformationTest2= new Booking_Information__c(Name_Of_Opportunity__c=opp.Id,Selected_discount_type__c ='Sp_offer',Customer_Type__c= 'Employee',Unique_booking_Id__c=Flat2.id,Flat__c=Flat2.id,Block_Detail__c='Checking Details',Consideration_Actual_Rs__c=10000,Infrastructure_Incl_in_CV__c='Incl.in CV',Infrastructure2_Incl_in_CV__c='Incl.in CV',Club_Charges_Incl_in_CV__c='Incl.in CV',Infrastructure_Cost_Rs__c=100,Infrastructure_Cost_2_Rs__c=100,Club_Charges_Rs__c=100,Infrastructure_Cost_2Actual_Rs__c=100,Infrastructure_Cost_Actual_Rs__c=150,Club_charges_Actual_Rs__c=100,Base_Rate_Sq_ft_Actual_Rs__c=120,Floor_rise_Sq_ft_Actual_Rs__c=120,Premium_Sq_ft_Actual_Rs__c=120,Applicable_Waiver_Sq_ft_Actual_Rs__c=120,Total_Rate_Sq_ft_Actual_Rs__c=120,Flat_Cost_Actual_Rs__c=120,Applicable_Waiver_Sq_ft_Rs__c=100,Booking_Date__c=System.now().date()-2,DAM_Offer_Sq_ft_Actual_Rs__c=100,Total_Rate_Sq_ft_Rs__c=120);
        bookingInfoList.add(bookingInformationTest2);

 
    Booking_Information__c bookingInformationTest3= new Booking_Information__c(Name_Of_Opportunity__c=opportunityTestNew3.id,Unique_booking_Id__c=f3.id,flat__c=f3.id,Booking_Status__c='BLOCKED',Consideration_Actual_Rs__c=10000,Infrastructure_Incl_in_CV__c='Incl.in CV',Infrastructure2_Incl_in_CV__c='Incl.in CV',Club_Charges_Incl_in_CV__c='Incl.in CV',Infrastructure_Cost_Rs__c=100,Infrastructure_Cost_2_Rs__c=100,Club_Charges_Rs__c=100,Infrastructure_Cost_2Actual_Rs__c=100,Name_of_Applicant__c='Test Opportunity for blocking',Infrastructure_Cost_Actual_Rs__c=150,Club_charges_Actual_Rs__c=100,Base_Rate_Sq_ft_Actual_Rs__c=120,Floor_rise_Sq_ft_Actual_Rs__c=120,Premium_Sq_ft_Actual_Rs__c=120,Applicable_Waiver_Sq_ft_Actual_Rs__c=120,Total_Rate_Sq_ft_Actual_Rs__c=120,Flat_Cost_Actual_Rs__c=120,Applicable_Waiver_Sq_ft_Rs__c=100,Booking_Date__c=System.now().date(),DAM_Offer_Sq_ft_Actual_Rs__c=20,Selected_discount_type__c ='DAM',Corporate_connection__c=corporateConnectionTest3.Id,CRN__c= null,Booking_By__c= 'News Paper',Customer_Type__c= 'Corporate',Sales_Person__c=UserInfo.getUserId(),Total__c = 150000,Contact_Nos__c='1234567890',Total_Rate_Sq_ft_Rs__c=1500,Date_of_First_Visit__c=System.now().date(),Block_Date__c=System.now().date(),Block_Detail__c='Tesing Blocking',Block_For__c=opportunityTestNew3.Id,Block_For_Days__c=10,Block_Sales_Person__c=UserInfo.getUserId());
    bookingInfoList.add(bookingInformationTest3);

    
    Booking_Information__c bookingInformationTest4= new Booking_Information__c(Confirmation_Remark__c='Cancel Booking',Cancel_Confirm_Date__c=System.now().date(),Name_Of_Opportunity__c=opportunityTestNew4.id,Unique_booking_Id__c=f4.id,flat__c=f4.id,Booking_Status__c='CANCELLATION',Block_Detail__c='Block Details',Consideration_Actual_Rs__c=10000,Infrastructure_Incl_in_CV__c='Incl.in CV',Infrastructure2_Incl_in_CV__c='Incl.in CV',Club_Charges_Incl_in_CV__c='Incl.in CV',Infrastructure_Cost_Rs__c=100,Infrastructure_Cost_2_Rs__c=100,Club_Charges_Rs__c=100,Infrastructure_Cost_2Actual_Rs__c=100,Name_of_Applicant__c='Test Opportunity',Infrastructure_Cost_Actual_Rs__c=150,Club_charges_Actual_Rs__c=100,Base_Rate_Sq_ft_Actual_Rs__c=120,Floor_rise_Sq_ft_Actual_Rs__c=120,Premium_Sq_ft_Actual_Rs__c=120,Applicable_Waiver_Sq_ft_Actual_Rs__c=120,Total_Rate_Sq_ft_Actual_Rs__c=120,Flat_Cost_Actual_Rs__c=120,Applicable_Waiver_Sq_ft_Rs__c=100,Booking_Date__c=System.now().date(),DAM_Offer_Sq_ft_Actual_Rs__c=20,Selected_discount_type__c ='DAM',Corporate_connection__c=corporateConnectionTest.Id,CRN__c= null,Booking_By__c= 'News Paper',Customer_Type__c= 'Physically challenged',Sales_Person__c=UserInfo.getUserId(),Total__c = 150000,Contact_Nos__c='1234567890',Total_Rate_Sq_ft_Rs__c=1500,Date_of_First_Visit__c=System.now().date());
  bookingInfoList.add(bookingInformationTest4);
   
   Booking_Information__c bookingInformationTest5= new Booking_Information__c(Confirmation_Remark__c='Cancel Booking',Cancel_Confirm_Date__c=System.now().date(),Name_Of_Opportunity__c=opportunityTestNew4.id,Unique_booking_Id__c=f4.id,flat__c=f4.id,Booking_Status__c='CANCELLATION',Block_Detail__c='Block Details',Consideration_Actual_Rs__c=10000,Infrastructure_Incl_in_CV__c='Incl.in CV',Infrastructure2_Incl_in_CV__c='Incl.in CV',Club_Charges_Incl_in_CV__c='Incl.in CV',Infrastructure_Cost_Rs__c=100,Infrastructure_Cost_2_Rs__c=100,Club_Charges_Rs__c=100,Infrastructure_Cost_2Actual_Rs__c=100,Name_of_Applicant__c='Test Opportunity',Infrastructure_Cost_Actual_Rs__c=150,Club_charges_Actual_Rs__c=100,Base_Rate_Sq_ft_Actual_Rs__c=120,Floor_rise_Sq_ft_Actual_Rs__c=120,Premium_Sq_ft_Actual_Rs__c=120,Applicable_Waiver_Sq_ft_Actual_Rs__c=120,Total_Rate_Sq_ft_Actual_Rs__c=120,Flat_Cost_Actual_Rs__c=120,Applicable_Waiver_Sq_ft_Rs__c=100,Booking_Date__c=System.now().date(),DAM_Offer_Sq_ft_Actual_Rs__c=20,Selected_discount_type__c ='DAM',Corporate_connection__c=corporateConnectionTest.Id,CRN__c= null,Booking_By__c= 'News Paper',Customer_Type__c= 'None',Sales_Person__c=UserInfo.getUserId(),Total__c = 150000,Contact_Nos__c='1234567890',Total_Rate_Sq_ft_Rs__c=1500,Date_of_First_Visit__c=System.now().date());
  bookingInfoList.add(bookingInformationTest5);
    
  insert  bookingInfoList;
  
  Corporate_connection__c corp = new Corporate_connection__c(Applicable_Discount__c = 20, Name='test corp connection', Project__c = projectNameTest.id);
   insert corp; 
  Test.stopTest();
    //test for booking.
    
    PageReference ref = new PageReference('/apex/testBookInventory');
    Test.setCurrentPage(ref);
    ref.getParameters().put('fid',f.Id);
    ref.getParameters().put('oppid',opportunityTestNew.Id);
    
    
    // normal booking
    SpBookInventory spbook  = new SpBookInventory();   
    spbook.booking.Booking_Status__c = 'BOOKING';
    spbook.updateStatus();
    spbook.save();
    spbook.booking.Name_of_Applicant__c = 'Test Opportunity';
    spbook.booking.Loyalty_Id__c = '123456789';
    spbook.booking.Visitor_Form_No__c = 'V12345678';
    spbook.booking.Date_of_First_Visit__c = System.now().date();
    spbook.booking.Contact_Nos__c = '1234567890';
    spbook.booking.CRN__c = 'CRN';
    spbook.booking.Booking_Date__c =System.now().date();
    spbook.updateStatus();
    spbook.getCorpSelectionList();
    spbook.flat_Id  = f.id;
    spbook.corpToggleDisplay();
    // spbook.inititeSCUD();
    spbook.open_scud_window();   
    spbook.adjust_dam_amt();
    spbook.calc_offer_amt();
    spbook.inf_consideration_amt();
    spbook.inf2_consideration_amt();
    spbook.clb_consideration_amt();
    spbook.cal_token_amt();
    spbook.cal_infra_cost();   
    spbook.updateStatus();    
    spbook.getCrnNumber('LCP');    
    spbook.save();
    spbook.createfametask();

    //cehck for transiton error
    spbook.booking.Booking_Status__c = 'OPEN';
    spbook.updateStatus();
    spbook.save();
   
    spbook.generate_payment_plan();
    spbook.generate_bdf_form();  
    spbook.bookinglist.clear();
    
    
   //test for referral
   
    PageReference ref1 = new PageReference('/apex/testBookInventory');
    Test.setCurrentPage(ref1);
    ref1.getParameters().put('fid',FlatTest1.Id);
    ref1.getParameters().put('oppid',opportunityTest1.Id);    
    SpBookInventory spbook1  = new SpBookInventory();

    
    spbook1.flat_Id  = FlatTest1.id;
    // spbook1.inititeSCUD();
    spbook1.toggledisplay();
    spbook1.open_scud_window();
    spbook1.bookinglist.clear();
    
     
     //check for Sp_offer
     
     
    
       PageReference ref2 = new PageReference('/apex/testBookInventory');
       Test.setCurrentPage(ref2);
       ref2.getParameters().put('fid',Flat2.Id);
       ref2.getParameters().put('oppid',opp.Id);
    
       SpBookInventory spbook2  = new SpBookInventory();
   
      //spbook2.getStatusSelectionList();
      spbook2.flat_Id  = Flat2.id;
      // spbook2.inititeSCUD();
      spbook2.toggledisplay();
      spbook2.corpToggleDisplay();
      spbook2.open_scud_window();
      spbook2.booking.Selected_discount_type__c = 'Sp_Offer';
      spbook2.booking.Total_Rate_Sq_ft_Actual_Rs__c = 200;
      spbook2.calc_offer_amt();
      
          spbook2.bookinglist.clear();
      
      //BLOCK booking
      
     
   
    
    PageReference ref3 = new PageReference('/apex/testBookInventory');
    Test.setCurrentPage(ref3);
    ref3.getParameters().put('fid',f3.Id);
    ref3.getParameters().put('oppid',opportunityTestNew3.Id);
    
    SpBookInventory spbook3  = new SpBookInventory();
    
    
    spbook3.booking.Name_of_Applicant__c = 'Test Opportunity for blocking3';
    spbook3.booking.Loyalty_Id__c = 'L23456789';
    spbook3.booking.Visitor_Form_No__c = 'V77777777';
    spbook3.booking.Date_of_First_Visit__c = System.now().date();
    spbook3.booking.Contact_Nos__c = '1234567890';
    
      
    //spbook3.getStatusSelectionList();
    spbook3.flat_Id  = f3.id;
    spbook3.corpToggleDisplay();
    // spbook3.inititeSCUD();
    spbook3.open_scud_window();    
    spbook3.adjust_dam_amt();
    spbook3.calc_offer_amt();
    spbook3.inf_consideration_amt();
    spbook3.inf2_consideration_amt();
    spbook3.clb_consideration_amt();
    spbook3.cal_token_amt();
    spbook3.cal_token_amt();
    spbook3.cal_infra_cost();
   
    spbook3.booking.Booking_Status__c = 'BLOCKED';
    spbook3.updateStatus();
    spbook3.save();
    
    spbook3.generate_payment_plan();
    spbook3.generate_bdf_form();
    
    spbook3.bookinglist.clear();
 
      spbook3.booking.Booking_Status__c = 'BOOKING';
      spbook3.booking.Booking_By__c = 'Channel Partner';
      spbook3.toggledisplay(); 
      spbook3.booking.Booking_By__c = 'Email';
      spbook3.toggledisplay();
      spbook3.booking.Customer_Type__c = 'Armed Forces Personnel';
      spbook3.corpToggleDisplay();
      spbook3.booking.Customer_Type__c = 'Corporate';
      spbook3.booking.Corporate_connection__c = corp.id;
      spbook3.calc_corp_discount();
      spbook3.updateStatus();
      spbook3.save();
      spbook3.booking.Booking_Status__c = 'SCUD';
      spbook3.booking.Selected_discount_type__c= 'SCUD';
      spbook3.updateStatus();
      spbook3.calc_offer_amt();
      spbook3.adjust_dam_amt();
      spbook3.save();
      spbook3.booking.Booking_Status__c = 'SOLD';
      spbook3.updateStatus();
      spbook3.save();
       
      
     //test for cancellation.
      
    PageReference ref4 = new PageReference('/apex/testBookInventory');
    Test.setCurrentPage(ref4);
    ref4.getParameters().put('fid',f4.Id);
    ref4.getParameters().put('oppid',opportunityTestNew4.Id);
    
    SpBookInventory spbook4  = new SpBookInventory();
    //spbook4.getStatusSelectionList();
    spbook4.flat_Id  = f4.id;
    spbook4.corpToggleDisplay();
    // spbook4.inititeSCUD();
    spbook4.open_scud_window();
    spbook4.booking.Booking_Status__c = 'CANCELLATION';
    spbook4.updateStatus();
    spbook4.save();
    spbook4.bookinglist.clear();
  
  //Empty bookinglist.
  
    PageReference ref5 = new PageReference('/apex/testBookInventory');
    Test.setCurrentPage(ref5);
    ref5.getParameters().put('fid',f5.Id);
    ref5.getParameters().put('oppid',opportunityTestNew5.Id);   
    SpBookInventory spbook5  = new SpBookInventory();
    spbook5.updateStatus();
    spbook5.save();
    spbook5.booking.Booking_Status__c = 'BOOKING';    
    spbook5.updateStatus();
    spbook5.save();
    spbook5.booking.Booking_Status__c = 'BOOKING';    
    spbook5.updateStatus();
    spbook5.booking.Booking_By__c = 'Channel Partner' ;
    spbook3.toggledisplay();
    spbook5.booking.Reap_Id__c = null;
    spbook5.save();
 }
 
 }