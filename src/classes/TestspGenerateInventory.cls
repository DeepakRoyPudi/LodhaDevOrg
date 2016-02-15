@istest(seealldata=false)
Public class TestspGenerateInventory{

Public static testMethod void spGenerateInventoryTest(){   
   
    //test for 1 flat type assigned to all            
    Project_Name__c projectNameTest = new Project_Name__c(Name='Test Project Name', CRN_INIT__c= 'LCP', Project_Type__c = 'Test Casa',Record_Type__c='Test Residential');
    insert projectNameTest;    
    
    Cluster__c clusterTest = new Cluster__c(Name='Test Cluster',Project_Name__c = projectNameTest.Id);
    insert clusterTest;
       
    Wing__c wingTest = new Wing__c(Name='Test Wing',Cluster__c=clusterTest.Id,No_of_Floors__c=3,No_of_flats_floor__c=2);
    insert wingTest;
    
    SpTestInsertions sp1 = new SpTestInsertions();
    Flat_Type__c flatTypeTest = sp1.createFlatType(wingTest);
    insert flatTypeTest;
        
    View_type_Assignment__c viewTypeAssignTest1 = new View_type_Assignment__c(Wing__c=wingTest.Id,Flat_Type__c=flatTypeTest.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('Flat Type Record').getRecordTypeId(),Pattern__c ='All', Column_Index__c = '1');
    insert viewTypeAssignTest1;
    
    View_type_Assignment__c viewTypeAssignTest2 = new View_type_Assignment__c(Wing__c=wingTest.Id,Flat_Type__c=flatTypeTest.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('Flat Type Record').getRecordTypeId(),Pattern__c ='All', Column_Index__c = '2');
    insert viewTypeAssignTest2;
    
    View_type_Assignment__c viewTypeAssignTest3 = new View_type_Assignment__c(Wing__c=wingTest.Id,Flat_Type__c=flatTypeTest.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('View Type Record').getRecordTypeId(),Pattern__c ='All',View__c='Sea View', Column_Index__c = '1');
    insert viewTypeAssignTest3;
    
    View_type_Assignment__c viewTypeAssignTest4 = new View_type_Assignment__c(Wing__c=wingTest.Id,Flat_Type__c=flatTypeTest.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('View Type Record').getRecordTypeId(),Pattern__c ='All',View__c='Sea View', Column_Index__c = '2');
    insert viewTypeAssignTest4;
    
    Rate_Card__c rateCardTest1 = new Rate_Card__c (Wing__c=wingTest.Id,recordtypeid=Schema.SObjectType.Rate_Card__c.getRecordTypeInfosByName().get('Premium View Rate Record').getRecordTypeId(),Flat_Type__c=flatTypeTest.Id,Premium_View__c='Sea View',View_Rate_Sq_Ft__c=20);
    insert rateCardTest1;
    
    Rate_Card__c rateCardTest2 = new Rate_Card__c (Wing__c=wingTest.Id,recordtypeid=Schema.SObjectType.Rate_Card__c.getRecordTypeInfosByName().get('Floor Rise Rate').getRecordTypeId(),Flat_Type__c=flatTypeTest.Id,Floor_From__c=1,Floor_To__c=2,Floor_Rise_Sq_Ft__c=20);
    insert rateCardTest2;
    
    
    ApexPages.StandardController stc = new ApexPages.StandardController(wingTest); 
    SpGenerateInventory testSpGenerateInventory = new SpGenerateInventory(stc);
    testSpGenerateInventory.generateInventory();
    
    
    
    // test for 2-flat types and assignment odd and even
    Project_Name__c projectNameTest2 = new Project_Name__c(Name='Test Project Name 2',CRN_INIT__c= 'LCT' , Project_Type__c = 'Test Casa',Record_Type__c='Test Residential');
    insert projectNameTest2;    
    
    Cluster__c clusterTest2 = new Cluster__c(Name='Test Cluster 2',Project_Name__c = projectNameTest2.Id);
    insert clusterTest2;
       
    Wing__c wingTest2 = new Wing__c(Name='Test Wing 2',Cluster__c=clusterTest2.Id,No_of_Floors__c=5,No_of_flats_floor__c=2);
    insert wingTest2;
    
    SpTestInsertions sp2 = new SpTestInsertions();
    Flat_Type__c flatTypeTest1 = sp2.createFlatType(wingTest2);
    insert flatTypeTest1;
    
    
    Flat_Type__c flatTypeTest2 = new Flat_Type__c (Name='2BHK',Wing__c=wingTest2.Id,Base_Rate_Sq_Ft__c=100,Carpet_Area__c=1500,Club_Charge_Rs__c=120,Infrastructure_Rs__c=100,Infrastructure_2_Rs__c=200,Salable_Area__c=1500,Token_Amount_Rs__c=50000);
    insert flatTypeTest2;
        
    View_type_Assignment__c viewTypeAssignTest5 = new View_type_Assignment__c(Wing__c=wingTest2.Id,Flat_Type__c=flatTypeTest1.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('Flat Type Record').getRecordTypeId(),Pattern__c ='Odd', Column_Index__c = '1');
    insert viewTypeAssignTest5;
    
    View_type_Assignment__c viewTypeAssignTest6 = new View_type_Assignment__c(Wing__c=wingTest2.Id,Flat_Type__c=flatTypeTest1.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('Flat Type Record').getRecordTypeId(),Pattern__c ='Even', Column_Index__c = '1');
    insert viewTypeAssignTest6;
    
    View_type_Assignment__c viewTypeAssignTest7 = new View_type_Assignment__c(Wing__c=wingTest2.Id,Flat_Type__c=flatTypeTest2.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('Flat Type Record').getRecordTypeId(),Pattern__c ='Even', Column_Index__c = '2');
    insert viewTypeAssignTest7;
    
    View_type_Assignment__c viewTypeAssignTest8 = new View_type_Assignment__c(Wing__c=wingTest2.Id,Flat_Type__c=flatTypeTest2.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('Flat Type Record').getRecordTypeId(),Pattern__c ='Odd', Column_Index__c = '2');
    insert viewTypeAssignTest8;
    
    View_type_Assignment__c viewTypeAssignTest9 = new View_type_Assignment__c(Wing__c=wingTest2.Id,Flat_Type__c=flatTypeTest1.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('View Type Record').getRecordTypeId(),Pattern__c ='Odd',View__c='Sea View', Column_Index__c = '1');
    insert viewTypeAssignTest9;
    
    View_type_Assignment__c viewTypeAssignTest10 = new View_type_Assignment__c(Wing__c=wingTest2.Id,Flat_Type__c=flatTypeTest1.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('View Type Record').getRecordTypeId(),Pattern__c ='Even',View__c='Sea View', Column_Index__c = '1');
    insert viewTypeAssignTest10;
    
    View_type_Assignment__c viewTypeAssignTest11 = new View_type_Assignment__c(Wing__c=wingTest2.Id,Flat_Type__c=flatTypeTest2.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('View Type Record').getRecordTypeId(),Pattern__c ='Even',View__c='Garden View', Column_Index__c = '2');
    insert viewTypeAssignTest11;
    
    View_type_Assignment__c viewTypeAssignTest12 = new View_type_Assignment__c(Wing__c=wingTest2.Id,Flat_Type__c=flatTypeTest2.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('View Type Record').getRecordTypeId(),Pattern__c ='Odd',View__c='Garden View', Column_Index__c = '2');
    insert viewTypeAssignTest12;
    
    Rate_Card__c rateCardTest3 = new Rate_Card__c (Wing__c=wingTest2.Id,recordtypeid=Schema.SObjectType.Rate_Card__c.getRecordTypeInfosByName().get('Premium View Rate Record').getRecordTypeId(),Flat_Type__c=flatTypeTest1.Id,Premium_View__c='Sea View',View_Rate_Sq_Ft__c=20);
    insert rateCardTest3;
    
    Rate_Card__c rateCardTest4 = new Rate_Card__c (Wing__c=wingTest2.Id,recordtypeid=Schema.SObjectType.Rate_Card__c.getRecordTypeInfosByName().get('Premium View Rate Record').getRecordTypeId(),Flat_Type__c=flatTypeTest2.Id,Premium_View__c='Sea View',View_Rate_Sq_Ft__c=40);
    insert rateCardTest4;
    
    Rate_Card__c rateCardTest5 = new Rate_Card__c (Wing__c=wingTest2.Id,recordtypeid=Schema.SObjectType.Rate_Card__c.getRecordTypeInfosByName().get('Floor Rise Rate').getRecordTypeId(),Flat_Type__c=flatTypeTest1.Id,Floor_From__c=1,Floor_To__c=5,Floor_Rise_Sq_Ft__c=20);
    insert rateCardTest5;
    
    Rate_Card__c rateCardTest6 = new Rate_Card__c (Wing__c=wingTest2.Id,recordtypeid=Schema.SObjectType.Rate_Card__c.getRecordTypeInfosByName().get('Floor Rise Rate').getRecordTypeId(),Flat_Type__c=flatTypeTest2.Id,Floor_From__c=1,Floor_To__c=5,Floor_Rise_Sq_Ft__c=40);
    insert rateCardTest6;
    
    
    ApexPages.StandardController stc2 = new ApexPages.StandardController(wingTest2); 
    SpGenerateInventory testSpGenerateInventory2 = new SpGenerateInventory(stc2);
    testSpGenerateInventory2.generateInventory();   
    
    
    // test  for 2-flat type and assignment with range
    Project_Name__c projectNameTest3 = new Project_Name__c(Name='Test Project Name 3',CRN_INIT__c= 'LCF' ,Project_Type__c = 'Test Casa',Record_Type__c='Test Residential');
    insert projectNameTest3;    
    
    Cluster__c clusterTest3 = new Cluster__c(Name='Test Cluster3',Project_Name__c = projectNameTest3.Id);
    insert clusterTest3;
       
    Wing__c wingTest3 = new Wing__c(Name='Test Wing 3',Cluster__c=clusterTest3.Id,No_of_Floors__c=5,No_of_flats_floor__c=2);
    insert wingTest3;
    
    SpTestInsertions sp3 = new SpTestInsertions();
    Flat_Type__c flatTypeTest3 = sp3.createFlatType(wingTest3);
    insert flatTypeTest3;
            
    View_type_Assignment__c viewTypeAssignTest13 = new View_type_Assignment__c(Wing__c=wingTest3.Id,Flat_Type__c=flatTypeTest3.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('Flat Type Record').getRecordTypeId(),Pattern__c ='Range', From__c=1,To__c=5, Column_Index__c= '1');
    insert viewTypeAssignTest13;
    
    View_type_Assignment__c viewTypeAssignTest14 = new View_type_Assignment__c(Wing__c=wingTest3.Id,Flat_Type__c=flatTypeTest3.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('Flat Type Record').getRecordTypeId(),Pattern__c ='Range', From__c=1,To__c=5, Column_Index__c= '2');
    insert viewTypeAssignTest14;
      
    View_type_Assignment__c viewTypeAssignTest15 = new View_type_Assignment__c(Wing__c=wingTest3.Id,Flat_Type__c=flatTypeTest3.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('View Type Record').getRecordTypeId(),Pattern__c ='Range',From__c=1,To__c=5,View__c='Sea View', Column_Index__c='1');
    insert viewTypeAssignTest15;
    
    View_type_Assignment__c viewTypeAssignTest16 = new View_type_Assignment__c(Wing__c=wingTest3.Id,Flat_Type__c=flatTypeTest3.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('View Type Record').getRecordTypeId(),Pattern__c ='Range',From__c=1,To__c=5,View__c='Sea View', Column_Index__c='2');
    insert viewTypeAssignTest16;
    
    Rate_Card__c rateCardTest7 = new Rate_Card__c (Wing__c=wingTest3.Id,recordtypeid=Schema.SObjectType.Rate_Card__c.getRecordTypeInfosByName().get('Premium View Rate Record').getRecordTypeId(),Flat_Type__c=flatTypeTest3.Id,Premium_View__c='Sea View',View_Rate_Sq_Ft__c=20);
    insert rateCardTest7;
    
    Rate_Card__c rateCardTest8 = new Rate_Card__c (Wing__c=wingTest3.Id,recordtypeid=Schema.SObjectType.Rate_Card__c.getRecordTypeInfosByName().get('Floor Rise Rate').getRecordTypeId(),Flat_Type__c=flatTypeTest3.Id,Floor_From__c=1,Floor_To__c=5,Floor_Rise_Sq_Ft__c=20);
    insert rateCardTest8;
 
    
    ApexPages.StandardController stc3 = new ApexPages.StandardController(wingTest3); 
    SpGenerateInventory testSpGenerateInventory3 = new SpGenerateInventory(stc3);
    testSpGenerateInventory3.generateInventory();
    
  
    //test for 2 flat type with odd and  range combination adssignment
    Project_Name__c projectNameTest4 = new Project_Name__c(Name='Test Project Name 4',CRN_INIT__c= 'LCY' ,Project_Type__c = 'Test Casa',Record_Type__c='Test Residential');
    insert projectNameTest4;    
    
    Cluster__c clusterTest4 = new Cluster__c(Name='Test Cluster4',Project_Name__c = projectNameTest4.Id);
    insert clusterTest4;
       
    Wing__c wingTest4 = new Wing__c(Name='Test Wing 4',Cluster__c=clusterTest4.Id,No_of_Floors__c=10,Podium_Unit__c='Yes',No_of_flats_floor__c=2);
    insert wingTest4;
    
    SpTestInsertions sp4 = new SpTestInsertions();
    Flat_Type__c flatTypeTest4 = sp4.createFlatType(wingTest4);
    insert flatTypeTest4;
    
    Flat_Type__c flatTypeTest5 = new Flat_Type__c (Name='2BHK',Wing__c=wingTest4.Id,Base_Rate_Sq_Ft__c=100,Carpet_Area__c=1500,Club_Charge_Rs__c=120,Infrastructure_Rs__c=100,Infrastructure_2_Rs__c=200,Salable_Area__c=1500,Token_Amount_Rs__c=50000);
    insert flatTypeTest5;
            
    View_type_Assignment__c viewTypeAssignTest17 = new View_type_Assignment__c(Wing__c=wingTest4.Id,Flat_Type__c=flatTypeTest4.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('Flat Type Record').getRecordTypeId(),Pattern__c ='Odd' , From__c=0,To__c=10, Column_Index__c = '1');
    insert viewTypeAssignTest17;
    
    View_type_Assignment__c viewTypeAssignTest18 = new View_type_Assignment__c(Wing__c=wingTest4.Id,Flat_Type__c=flatTypeTest4.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('Flat Type Record').getRecordTypeId(),Pattern__c ='Even' , From__c=0,To__c=10, Column_Index__c = '1');
    insert viewTypeAssignTest18;
    
    
    View_type_Assignment__c viewTypeAssignTest19 = new View_type_Assignment__c(Wing__c=wingTest4.Id,Flat_Type__c=flatTypeTest5.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('Flat Type Record').getRecordTypeId(),Pattern__c ='Even', From__c=0,To__c=10, Column_Index__c = '2');
    insert viewTypeAssignTest19;
    
     View_type_Assignment__c viewTypeAssignTest20 = new View_type_Assignment__c(Wing__c=wingTest4.Id,Flat_Type__c=flatTypeTest5.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('Flat Type Record').getRecordTypeId(),Pattern__c ='Odd', From__c=0,To__c=10, Column_Index__c = '2');
    insert viewTypeAssignTest20;
      
    View_type_Assignment__c viewTypeAssignTest21 = new View_type_Assignment__c(Wing__c=wingTest4.Id,Flat_Type__c=flatTypeTest4.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('View Type Record').getRecordTypeId(),Pattern__c ='Odd',View__c='Garden View', From__c=0,To__c=10, Column_Index__c = '1');
    insert viewTypeAssignTest21;
    
    View_type_Assignment__c viewTypeAssignTest22 = new View_type_Assignment__c(Wing__c=wingTest4.Id,Flat_Type__c=flatTypeTest4.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('View Type Record').getRecordTypeId(),Pattern__c ='Even',View__c='Garden View', From__c=0,To__c=10, Column_Index__c = '1');
    insert viewTypeAssignTest22;
    
    View_type_Assignment__c viewTypeAssignTest23 = new View_type_Assignment__c(Wing__c=wingTest4.Id,Flat_Type__c=flatTypeTest5.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('View Type Record').getRecordTypeId(),Pattern__c ='Odd', View__c='Sea View', From__c=0,To__c=10, Column_Index__c = '2');
    insert viewTypeAssignTest23;
    
    View_type_Assignment__c viewTypeAssignTest24 = new View_type_Assignment__c(Wing__c=wingTest4.Id,Flat_Type__c=flatTypeTest5.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('View Type Record').getRecordTypeId(),Pattern__c ='Even', View__c='Sea View', From__c=0,To__c=10, Column_Index__c = '2');
    insert viewTypeAssignTest24;

    
    Rate_Card__c rateCardTest9 = new Rate_Card__c (Wing__c=wingTest4.Id,recordtypeid=Schema.SObjectType.Rate_Card__c.getRecordTypeInfosByName().get('Premium View Rate Record').getRecordTypeId(),Flat_Type__c=flatTypeTest4.Id,Premium_View__c='Garden View',View_Rate_Sq_Ft__c=20);
    insert rateCardTest9;
    
    Rate_Card__c rateCardTest10 = new Rate_Card__c (Wing__c=wingTest4.Id,recordtypeid=Schema.SObjectType.Rate_Card__c.getRecordTypeInfosByName().get('Premium View Rate Record').getRecordTypeId(),Flat_Type__c=flatTypeTest5.Id,Premium_View__c='Sea View',View_Rate_Sq_Ft__c=220);
    insert rateCardTest10;
    
    Rate_Card__c rateCardTest11 = new Rate_Card__c (Wing__c=wingTest4.Id,recordtypeid=Schema.SObjectType.Rate_Card__c.getRecordTypeInfosByName().get('Floor Rise Rate').getRecordTypeId(),Flat_Type__c=flatTypeTest4.Id,Floor_From__c=1,Floor_To__c=10,Floor_Rise_Sq_Ft__c=20);
    insert rateCardTest11;
    
    Rate_Card__c rateCardTest12 = new Rate_Card__c (Wing__c=wingTest4.Id,recordtypeid=Schema.SObjectType.Rate_Card__c.getRecordTypeInfosByName().get('Floor Rise Rate').getRecordTypeId(),Flat_Type__c=flatTypeTest5.Id,Floor_From__c=1,Floor_To__c=10,Floor_Rise_Sq_Ft__c=240);
    insert rateCardTest12;
 
    
    ApexPages.StandardController stc4 = new ApexPages.StandardController(wingTest4); 
    SpGenerateInventory testSpGenerateInventory4 = new SpGenerateInventory(stc4);
    testSpGenerateInventory4.generateInventory();
           
           
   
      
   /* //test for  flat type with odd and even combination adssignment
    Project_Name__c projectNameTest5 = new Project_Name__c(Name='Test Project Name 5',CRN_INIT__c= 'LCH',Project_Type__c = 'Test Casa',Record_Type__c='Test Residential');
    insert projectNameTest5;    
    
    Cluster__c clusterTest5 = new Cluster__c(Name='Test Cluster5',Project_Name__c = projectNameTest5.Id);
    insert clusterTest5;
       
    Wing__c wingTest5 = new Wing__c(Name='Test Wing 5',Cluster__c=clusterTest5.Id,No_of_Floors__c=10,Podium_Unit__c='No',No_of_flats_floor__c=2);
    insert wingTest5;
    
    SpTestInsertions sp5 = new SpTestInsertions();
    Flat_Type__c flatTypeTest7 = sp5.createFlatType(wingTest5);
    insert flatTypeTest7;
    
    Flat_Type__c flatTypeTest6 = new Flat_Type__c (Name='2BHK',Wing__c=wingTest5.Id,Base_Rate_Sq_Ft__c=1000,Carpet_Area__c=1500,Club_Charge_Rs__c=120,Infrastructure_Rs__c=100,Infrastructure_2_Rs__c=200,Salable_Area__c=1500,Token_Amount_Rs__c=50000);
    insert flatTypeTest6;
            
    View_type_Assignment__c viewTypeAssignTest13 = new View_type_Assignment__c(Wing__c=wingTest5.Id,Flat_Type__c=flatTypeTest7.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('Flat Type Record').getRecordTypeId(),Pattern__c ='Odd',From__c=1,To__c=10);
    insert viewTypeAssignTest13;
    
    
    View_type_Assignment__c viewTypeAssignTest14 = new View_type_Assignment__c(Wing__c=wingTest5.Id,Flat_Type__c=flatTypeTest6.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('Flat Type Record').getRecordTypeId(),Pattern__c ='Even', From__c=1,To__c=10);
    insert viewTypeAssignTest14;
      
    View_type_Assignment__c viewTypeAssignTest15 = new View_type_Assignment__c(Wing__c=wingTest5.Id,Flat_Type__c=flatTypeTest7.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('View Type Record').getRecordTypeId(),Pattern__c ='Odd',View__c='Garden View',From__c=1,To__c=10);
    insert viewTypeAssignTest15;
    
    View_type_Assignment__c viewTypeAssignTest16 = new View_type_Assignment__c(Wing__c=wingTest5.Id,Flat_Type__c=flatTypeTest6.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('View Type Record').getRecordTypeId(),Pattern__c ='Even', View__c='Sea View', From__c=1,To__c=10);
    insert viewTypeAssignTest16;

    
    Rate_Card__c rateCardTest13 = new Rate_Card__c (Wing__c=wingTest5.Id,recordtypeid=Schema.SObjectType.Rate_Card__c.getRecordTypeInfosByName().get('Premium View Rate Record').getRecordTypeId(),Flat_Type__c=flatTypeTest7.Id,Premium_View__c='Garden View',View_Rate_Sq_Ft__c=20);
    insert rateCardTest13;
    
    Rate_Card__c rateCardTest14 = new Rate_Card__c (Wing__c=wingTest5.Id,recordtypeid=Schema.SObjectType.Rate_Card__c.getRecordTypeInfosByName().get('Premium View Rate Record').getRecordTypeId(),Flat_Type__c=flatTypeTest6.Id,Premium_View__c='Sea View',View_Rate_Sq_Ft__c=220);
    insert rateCardTest14;
    
    Rate_Card__c rateCardTest15 = new Rate_Card__c (Wing__c=wingTest5.Id,recordtypeid=Schema.SObjectType.Rate_Card__c.getRecordTypeInfosByName().get('Floor Rise Rate').getRecordTypeId(),Flat_Type__c=flatTypeTest7.Id,Floor_From__c=1,Floor_To__c=10,Floor_Rise_Sq_Ft__c=20);
    insert rateCardTest15;
    
    Rate_Card__c rateCardTest16 = new Rate_Card__c (Wing__c=wingTest5.Id,recordtypeid=Schema.SObjectType.Rate_Card__c.getRecordTypeInfosByName().get('Floor Rise Rate').getRecordTypeId(),Flat_Type__c=flatTypeTest6.Id,Floor_From__c=1,Floor_To__c=10,Floor_Rise_Sq_Ft__c=240);
    insert rateCardTest16;
 
    
    ApexPages.StandardController stc5 = new ApexPages.StandardController(wingTest5); 
    SpGenerateInventory testSpGenerateInventory5 = new SpGenerateInventory(stc5);
    testSpGenerateInventory5.generateInventory();
    
           */
 }
 
}