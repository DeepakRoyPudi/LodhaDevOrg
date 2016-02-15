@isTest(SeeAllData=false)
public class SpBatchGenerateInventory_Test{
    testMethod static void SpBatchGenerateInventory_Test1(){
        Test.startTest();
        
        //test for 1 flat type assigned to all            
        Project_Name__c projectNameTest = new Project_Name__c(Name='Test Project Name', CRN_INIT__c= 'LCP', Project_Type__c = 'Test Casa',Record_Type__c='Test Residential');
        insert projectNameTest;    
        
        Cluster__c clusterTest = new Cluster__c(Name='Test Cluster',Project_Name__c = projectNameTest.Id);
        insert clusterTest;
        
        List<Wing__c> wingTestList = new List<Wing__c>(); 
        
        Wing__c wingTest = new Wing__c(Name='Test Wing',Cluster__c=clusterTest.Id,No_of_Floors__c=3,No_of_flats_floor__c=2);
        wingTestList.add(wingTest);
       
        insert wingTestList;
        
        
        SpTestInsertions sp1 = new SpTestInsertions();
        Flat_Type__c flatTypeTest = sp1.createFlatType(wingTest);
        insert flatTypeTest;
        
        List<View_type_Assignment__c> lstviewTypeAssignTest = new List<View_type_Assignment__c>();     
        View_type_Assignment__c viewTypeAssignTest1 = new View_type_Assignment__c(Wing__c=wingTest.Id,Flat_Type__c=flatTypeTest.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('Flat Type Record').getRecordTypeId(),Pattern__c ='All', Column_Index__c = '1');
        lstviewTypeAssignTest.add(viewTypeAssignTest1);
        
        View_type_Assignment__c viewTypeAssignTest2 = new View_type_Assignment__c(Wing__c=wingTest.Id,Flat_Type__c=flatTypeTest.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('Flat Type Record').getRecordTypeId(),Pattern__c ='All', Column_Index__c = '2');
        lstviewTypeAssignTest.add(viewTypeAssignTest2); 
        
        View_type_Assignment__c viewTypeAssignTest3 = new View_type_Assignment__c(Wing__c=wingTest.Id,Flat_Type__c=flatTypeTest.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('View Type Record').getRecordTypeId(),Pattern__c ='All',View__c='Sea View', Column_Index__c = '1');
        lstviewTypeAssignTest.add(viewTypeAssignTest3);
        
        View_type_Assignment__c viewTypeAssignTest4 = new View_type_Assignment__c(Wing__c=wingTest.Id,Flat_Type__c=flatTypeTest.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('View Type Record').getRecordTypeId(),Pattern__c ='All',View__c='Sea View', Column_Index__c = '2');
        lstviewTypeAssignTest.add(viewTypeAssignTest4);
        
        insert lstviewTypeAssignTest;
        
        List<Rate_Card__c> lstRateCard = new List<Rate_Card__c>();
        Rate_Card__c rateCardTest1 = new Rate_Card__c (Wing__c=wingTest.Id,recordtypeid=Schema.SObjectType.Rate_Card__c.getRecordTypeInfosByName().get('Premium View Rate Record').getRecordTypeId(),Flat_Type__c=flatTypeTest.Id,Premium_View__c='Sea View',View_Rate_Sq_Ft__c=20);
        lstRateCard.add(rateCardTest1);
        
        Rate_Card__c rateCardTest2 = new Rate_Card__c (Wing__c=wingTest.Id,recordtypeid=Schema.SObjectType.Rate_Card__c.getRecordTypeInfosByName().get('Floor Rise Rate').getRecordTypeId(),Flat_Type__c=flatTypeTest.Id,Floor_From__c=1,Floor_To__c=2,Floor_Rise_Sq_Ft__c=20);
        lstRateCard.add(rateCardTest2);
        
        insert lstRateCard;
       
       
        //execute batch class
        Database.BatchableContext BC;
        SpBatchGenerateInventory batchRP = new SpBatchGenerateInventory();
        //batchRP.start(BC);
        Database.executeBatch(batchRP);
        //batchRP.execute(BC, wingTestList);
        Test.stopTest();
    }   
      
    testMethod static void SpBatchGenerateInventory_Test2(){ 
    	Test.startTest(); 
	    // test for 2-flat types and assignment odd and even
	    Project_Name__c projectNameTest2 = new Project_Name__c(Name='Test Project Name 2',CRN_INIT__c= 'LCT' , Project_Type__c = 'Test Casa',Record_Type__c='Test Residential');
	    insert projectNameTest2;    
	    
	    Cluster__c clusterTest2 = new Cluster__c(Name='Test Cluster 2',Project_Name__c = projectNameTest2.Id);
	    insert clusterTest2;
	    
	    List<Wing__c> wingTestList2 = new List<Wing__c>(); 
	    Wing__c wingTest2 = new Wing__c(Name='Test Wing 2',Cluster__c=clusterTest2.Id,No_of_Floors__c=5,No_of_flats_floor__c=2);
	    wingTestList2.add(wingTest2);
	    
	    insert wingTestList2;
	    
	    SpTestInsertions sp2 = new SpTestInsertions();
	    Flat_Type__c flatTypeTest1 = sp2.createFlatType(wingTest2);
	    insert flatTypeTest1;
	    
	    
	    Flat_Type__c flatTypeTest2 = new Flat_Type__c (Name='2BHK',Wing__c=wingTest2.Id,Base_Rate_Sq_Ft__c=100,Carpet_Area__c=1500,Club_Charge_Rs__c=120,Infrastructure_Rs__c=100,Infrastructure_2_Rs__c=200,Salable_Area__c=1500,Token_Amount_Rs__c=50000);
	    insert flatTypeTest2;
	    
	    List<View_type_Assignment__c> lstviewTypeAssignTest = new List<View_type_Assignment__c>();
	        
	    View_type_Assignment__c viewTypeAssignTest5 = new View_type_Assignment__c(Wing__c=wingTest2.Id,Flat_Type__c=flatTypeTest1.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('Flat Type Record').getRecordTypeId(),Pattern__c ='Odd', Column_Index__c = '1');
	    lstviewTypeAssignTest.add(viewTypeAssignTest5);
	    
	    View_type_Assignment__c viewTypeAssignTest6 = new View_type_Assignment__c(Wing__c=wingTest2.Id,Flat_Type__c=flatTypeTest1.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('Flat Type Record').getRecordTypeId(),Pattern__c ='Even', Column_Index__c = '1');
	    lstviewTypeAssignTest.add(viewTypeAssignTest6);
	    
	    View_type_Assignment__c viewTypeAssignTest7 = new View_type_Assignment__c(Wing__c=wingTest2.Id,Flat_Type__c=flatTypeTest2.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('Flat Type Record').getRecordTypeId(),Pattern__c ='Odd', Column_Index__c = '2');
	    lstviewTypeAssignTest.add(viewTypeAssignTest7);
	    
	    View_type_Assignment__c viewTypeAssignTest7_1 = new View_type_Assignment__c(Wing__c=wingTest2.Id,Flat_Type__c=flatTypeTest2.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('Flat Type Record').getRecordTypeId(),Pattern__c ='Even', Column_Index__c = '2');
	    lstviewTypeAssignTest.add(viewTypeAssignTest7_1);
	    
	    View_type_Assignment__c viewTypeAssignTest8 = new View_type_Assignment__c(Wing__c=wingTest2.Id,Flat_Type__c=flatTypeTest1.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('View Type Record').getRecordTypeId(),Pattern__c ='Odd',View__c='Sea View', Column_Index__c = '1');
	    lstviewTypeAssignTest.add(viewTypeAssignTest8);
	    
	    View_type_Assignment__c viewTypeAssignTest9 = new View_type_Assignment__c(Wing__c=wingTest2.Id,Flat_Type__c=flatTypeTest1.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('View Type Record').getRecordTypeId(),Pattern__c ='Odd',View__c='Sea View', Column_Index__c = '2');
	    lstviewTypeAssignTest.add(viewTypeAssignTest9);
	    
	    View_type_Assignment__c viewTypeAssignTest10 = new View_type_Assignment__c(Wing__c=wingTest2.Id,Flat_Type__c=flatTypeTest2.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('View Type Record').getRecordTypeId(),Pattern__c ='Even',View__c='Garden View', Column_Index__c = '1');
	    lstviewTypeAssignTest.add(viewTypeAssignTest10);
	    
	    View_type_Assignment__c viewTypeAssignTest11 = new View_type_Assignment__c(Wing__c=wingTest2.Id,Flat_Type__c=flatTypeTest2.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('View Type Record').getRecordTypeId(),Pattern__c ='Even',View__c='Garden View', Column_Index__c = '2');
	    lstviewTypeAssignTest.add(viewTypeAssignTest11);
	    
	    insert lstviewTypeAssignTest;
	    
	    List<Rate_Card__c> lstRateCard = new List<Rate_Card__c>();
	    Rate_Card__c rateCardTest3 = new Rate_Card__c (Wing__c=wingTest2.Id,recordtypeid=Schema.SObjectType.Rate_Card__c.getRecordTypeInfosByName().get('Premium View Rate Record').getRecordTypeId(),Flat_Type__c=flatTypeTest1.Id,Premium_View__c='Sea View',View_Rate_Sq_Ft__c=20);
	    lstRateCard.add(rateCardTest3);
	    
	    Rate_Card__c rateCardTest4 = new Rate_Card__c (Wing__c=wingTest2.Id,recordtypeid=Schema.SObjectType.Rate_Card__c.getRecordTypeInfosByName().get('Premium View Rate Record').getRecordTypeId(),Flat_Type__c=flatTypeTest2.Id,Premium_View__c='Sea View',View_Rate_Sq_Ft__c=40);
	    lstRateCard.add(rateCardTest4);
	    
	    Rate_Card__c rateCardTest5 = new Rate_Card__c (Wing__c=wingTest2.Id,recordtypeid=Schema.SObjectType.Rate_Card__c.getRecordTypeInfosByName().get('Floor Rise Rate').getRecordTypeId(),Flat_Type__c=flatTypeTest1.Id,Floor_From__c=1,Floor_To__c=5,Floor_Rise_Sq_Ft__c=20);
	    lstRateCard.add(rateCardTest5);
	    
	    Rate_Card__c rateCardTest6 = new Rate_Card__c (Wing__c=wingTest2.Id,recordtypeid=Schema.SObjectType.Rate_Card__c.getRecordTypeInfosByName().get('Floor Rise Rate').getRecordTypeId(),Flat_Type__c=flatTypeTest2.Id,Floor_From__c=1,Floor_To__c=5,Floor_Rise_Sq_Ft__c=40);
	    lstRateCard.add(rateCardTest6);
	    
	    insert lstRateCard;
	    
	    
        //execute batch class
        Database.BatchableContext BC;
        SpBatchGenerateInventory batchRP = new SpBatchGenerateInventory();
        //batchRP.start(BC);
        Database.executeBatch(batchRP);
        //batchRP.execute(BC, wingTestList2);
        
        Test.stopTest();
    } 
    
    testMethod static void SpBatchGenerateInventory_Test3(){
    	Test.startTest();
	    // test  for 2-flat type and assignment with range
	    Project_Name__c projectNameTest3 = new Project_Name__c(Name='Test Project Name 3',CRN_INIT__c= 'LCF' ,Project_Type__c = 'Test Casa',Record_Type__c='Test Residential');
	    insert projectNameTest3;    
	    
	    Cluster__c clusterTest3 = new Cluster__c(Name='Test Cluster3',Project_Name__c = projectNameTest3.Id);
	    insert clusterTest3;
	    
	    List<Wing__c> wingTestList3 = new List<Wing__c>(); 
	    Wing__c wingTest3 = new Wing__c(Name='Test Wing 3',Cluster__c=clusterTest3.Id,No_of_Floors__c=5,No_of_flats_floor__c=2);
	    wingTestList3.add(wingTest3);
	    insert wingTestList3;
	    
	    SpTestInsertions sp3 = new SpTestInsertions();
	    Flat_Type__c flatTypeTest3 = sp3.createFlatType(wingTest3);
	    insert flatTypeTest3;
	     
	    List<View_type_Assignment__c> lstviewTypeAssignTest = new List<View_type_Assignment__c>();       
	    View_type_Assignment__c viewTypeAssignTest12 = new View_type_Assignment__c(Wing__c=wingTest3.Id,Flat_Type__c=flatTypeTest3.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('Flat Type Record').getRecordTypeId(),Pattern__c ='Range', From__c=1,To__c=5, Column_Index__c = '1');
	    lstviewTypeAssignTest.add(viewTypeAssignTest12);
	    
	    View_type_Assignment__c viewTypeAssignTest13 = new View_type_Assignment__c(Wing__c=wingTest3.Id,Flat_Type__c=flatTypeTest3.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('Flat Type Record').getRecordTypeId(),Pattern__c ='Range', From__c=1,To__c=5, Column_Index__c = '2');
	    lstviewTypeAssignTest.add(viewTypeAssignTest13);
	      
	    View_type_Assignment__c viewTypeAssignTest14 = new View_type_Assignment__c(Wing__c=wingTest3.Id,Flat_Type__c=flatTypeTest3.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('View Type Record').getRecordTypeId(),Pattern__c ='Range',From__c=1,To__c=5,View__c='Sea View', Column_Index__c = '1');
	    lstviewTypeAssignTest.add(viewTypeAssignTest14);
	    
	    View_type_Assignment__c viewTypeAssignTest15 = new View_type_Assignment__c(Wing__c=wingTest3.Id,Flat_Type__c=flatTypeTest3.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('View Type Record').getRecordTypeId(),Pattern__c ='Range',From__c=1,To__c=5,View__c='Sea View', Column_Index__c = '2');
	    lstviewTypeAssignTest.add(viewTypeAssignTest15);
	    
	    insert lstviewTypeAssignTest;
	    
	    List<Rate_Card__c> lstRateCard = new List<Rate_Card__c>();
	    
	    Rate_Card__c rateCardTest7 = new Rate_Card__c (Wing__c=wingTest3.Id,recordtypeid=Schema.SObjectType.Rate_Card__c.getRecordTypeInfosByName().get('Premium View Rate Record').getRecordTypeId(),Flat_Type__c=flatTypeTest3.Id,Premium_View__c='Sea View',View_Rate_Sq_Ft__c=20);
	    lstRateCard.add(rateCardTest7);
	    
	    Rate_Card__c rateCardTest8 = new Rate_Card__c (Wing__c=wingTest3.Id,recordtypeid=Schema.SObjectType.Rate_Card__c.getRecordTypeInfosByName().get('Floor Rise Rate').getRecordTypeId(),Flat_Type__c=flatTypeTest3.Id,Floor_From__c=1,Floor_To__c=5,Floor_Rise_Sq_Ft__c=20);
	    lstRateCard.add(rateCardTest8);
	 	
	 	insert lstRateCard;
	    
	    
        //execute batch class
        Database.BatchableContext BC;
        SpBatchGenerateInventory batchRP = new SpBatchGenerateInventory();
        //batchRP.start(BC);
        Database.executeBatch(batchRP);
        //batchRP.execute(BC, wingTestList3);
        Test.stopTest();
    } 
    
    testMethod static void SpBatchGenerateInventory_Test4(){
    	Test.startTest();
	    //test for 2 flat type with odd and  range combination adssignment
	    Project_Name__c projectNameTest4 = new Project_Name__c(Name='Test Project Name 4',CRN_INIT__c= 'LCY' ,Project_Type__c = 'Test Casa',Record_Type__c='Test Residential');
	    insert projectNameTest4;    
	    
	    Cluster__c clusterTest4 = new Cluster__c(Name='Test Cluster4',Project_Name__c = projectNameTest4.Id);
	    insert clusterTest4;
	    
	    List<Wing__c> wingTestList4 = new List<Wing__c>(); 
	    Wing__c wingTest4 = new Wing__c(Name='Test Wing 4',Cluster__c=clusterTest4.Id,No_of_Floors__c=10,Podium_Unit__c='Yes',No_of_flats_floor__c=2);
	    wingTestList4.add(wingTest4);
	    
	    insert wingTestList4;
	    
	    SpTestInsertions sp4 = new SpTestInsertions();
	    Flat_Type__c flatTypeTest4 = sp4.createFlatType(wingTest4);
	    insert flatTypeTest4;
	    
	    Flat_Type__c flatTypeTest5 = new Flat_Type__c (Name='2BHK',Wing__c=wingTest4.Id,Base_Rate_Sq_Ft__c=100,Carpet_Area__c=1500,Club_Charge_Rs__c=120,Infrastructure_Rs__c=100,Infrastructure_2_Rs__c=200,Salable_Area__c=1500,Token_Amount_Rs__c=50000);
	    insert flatTypeTest5;
	     
	    List<View_type_Assignment__c> lstviewTypeAssignTest = new List<View_type_Assignment__c>();       
	    View_type_Assignment__c viewTypeAssignTest16 = new View_type_Assignment__c(Wing__c=wingTest4.Id,Flat_Type__c=flatTypeTest4.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('Flat Type Record').getRecordTypeId(),Pattern__c ='Odd', Column_Index__c = '1');
	    lstviewTypeAssignTest.add(viewTypeAssignTest16);
	    
	    View_type_Assignment__c viewTypeAssignTest17 = new View_type_Assignment__c(Wing__c=wingTest4.Id,Flat_Type__c=flatTypeTest4.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('Flat Type Record').getRecordTypeId(),Pattern__c ='Even', Column_Index__c = '2');
	    lstviewTypeAssignTest.add(viewTypeAssignTest17);
	    
	    
	    View_type_Assignment__c viewTypeAssignTest18 = new View_type_Assignment__c(Wing__c=wingTest4.Id,Flat_Type__c=flatTypeTest5.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('Flat Type Record').getRecordTypeId(),Pattern__c ='Even', Column_Index__c = '1');
	    lstviewTypeAssignTest.add(viewTypeAssignTest18);
	    
	    View_type_Assignment__c viewTypeAssignTest19 = new View_type_Assignment__c(Wing__c=wingTest4.Id,Flat_Type__c=flatTypeTest5.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('Flat Type Record').getRecordTypeId(),Pattern__c ='Odd', Column_Index__c = '2');
	    lstviewTypeAssignTest.add(viewTypeAssignTest19);
	      
	    View_type_Assignment__c viewTypeAssignTest20 = new View_type_Assignment__c(Wing__c=wingTest4.Id,Flat_Type__c=flatTypeTest4.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('View Type Record').getRecordTypeId(),Pattern__c ='Odd',View__c='Garden View', Column_Index__c = '1');
	    lstviewTypeAssignTest.add(viewTypeAssignTest20);
	    
	    View_type_Assignment__c viewTypeAssignTest21 = new View_type_Assignment__c(Wing__c=wingTest4.Id,Flat_Type__c=flatTypeTest4.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('View Type Record').getRecordTypeId(),Pattern__c ='Even',View__c='Garden View', Column_Index__c = '2');
	    lstviewTypeAssignTest.add(viewTypeAssignTest21);
	    
	    View_type_Assignment__c viewTypeAssignTest22 = new View_type_Assignment__c(Wing__c=wingTest4.Id,Flat_Type__c=flatTypeTest5.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('View Type Record').getRecordTypeId(),Pattern__c ='Even', View__c='Sea View', Column_Index__c = '1');
	    lstviewTypeAssignTest.add(viewTypeAssignTest22);
	    
	    View_type_Assignment__c viewTypeAssignTest23 = new View_type_Assignment__c(Wing__c=wingTest4.Id,Flat_Type__c=flatTypeTest5.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('View Type Record').getRecordTypeId(),Pattern__c ='Odd', View__c='Sea View', Column_Index__c = '2');
	    lstviewTypeAssignTest.add(viewTypeAssignTest23);
		
		insert lstviewTypeAssignTest;
	    
	    List<Rate_Card__c> lstRateCard = new List<Rate_Card__c>();
	    Rate_Card__c rateCardTest9 = new Rate_Card__c (Wing__c=wingTest4.Id,recordtypeid=Schema.SObjectType.Rate_Card__c.getRecordTypeInfosByName().get('Premium View Rate Record').getRecordTypeId(),Flat_Type__c=flatTypeTest4.Id,Premium_View__c='Garden View',View_Rate_Sq_Ft__c=20);
	    lstRateCard.add(rateCardTest9);
	    
	    Rate_Card__c rateCardTest10 = new Rate_Card__c (Wing__c=wingTest4.Id,recordtypeid=Schema.SObjectType.Rate_Card__c.getRecordTypeInfosByName().get('Premium View Rate Record').getRecordTypeId(),Flat_Type__c=flatTypeTest5.Id,Premium_View__c='Sea View',View_Rate_Sq_Ft__c=220);
	    lstRateCard.add(rateCardTest10);
	    
	    Rate_Card__c rateCardTest11 = new Rate_Card__c (Wing__c=wingTest4.Id,recordtypeid=Schema.SObjectType.Rate_Card__c.getRecordTypeInfosByName().get('Floor Rise Rate').getRecordTypeId(),Flat_Type__c=flatTypeTest4.Id,Floor_From__c=1,Floor_To__c=10,Floor_Rise_Sq_Ft__c=20);
	    lstRateCard.add(rateCardTest11);
	    
	    Rate_Card__c rateCardTest12 = new Rate_Card__c (Wing__c=wingTest4.Id,recordtypeid=Schema.SObjectType.Rate_Card__c.getRecordTypeInfosByName().get('Floor Rise Rate').getRecordTypeId(),Flat_Type__c=flatTypeTest5.Id,Floor_From__c=1,Floor_To__c=10,Floor_Rise_Sq_Ft__c=240);
	    lstRateCard.add(rateCardTest12);
	 
	    insert lstRateCard;
	    
        //execute batch class
        Database.BatchableContext BC;
        SpBatchGenerateInventory batchRP = new SpBatchGenerateInventory();
        //batchRP.start(BC);
        Database.executeBatch(batchRP);
        //batchRP.execute(BC, wingTestList4);
        Test.stopTest();
    }
           
           
   
    testMethod static void SpBatchGenerateInventory_Test5(){
    	Test.startTest(); 
	    //test for  flat type with odd and even combination adssignment
	    Project_Name__c projectNameTest5 = new Project_Name__c(Name='Test Project Name 5',CRN_INIT__c= 'LCH',Project_Type__c = 'Test Casa',Record_Type__c='Test Residential');
	    insert projectNameTest5;    
	    
	    Cluster__c clusterTest5 = new Cluster__c(Name='Test Cluster5',Project_Name__c = projectNameTest5.Id);
	    insert clusterTest5;
	    
	    List<Wing__c> wingTestList5 = new List<Wing__c>(); 
	    Wing__c wingTest5 = new Wing__c(Name='Test Wing 5',Cluster__c=clusterTest5.Id,No_of_Floors__c=10,Podium_Unit__c='No',No_of_flats_floor__c=2);
	    wingTestList5.add(wingTest5);
	    
	    insert wingTestList5;
	    
	    SpTestInsertions sp5 = new SpTestInsertions();
	    Flat_Type__c flatTypeTest7 = sp5.createFlatType(wingTest5);
	    insert flatTypeTest7;
	    
	    Flat_Type__c flatTypeTest6 = new Flat_Type__c (Name='2BHK',Wing__c=wingTest5.Id,Base_Rate_Sq_Ft__c=1000,Carpet_Area__c=1500,Club_Charge_Rs__c=120,Infrastructure_Rs__c=100,Infrastructure_2_Rs__c=200,Salable_Area__c=1500,Token_Amount_Rs__c=50000);
	    insert flatTypeTest6;
	     
	    List<View_type_Assignment__c> lstviewTypeAssignTest = new List<View_type_Assignment__c>();       
	    View_type_Assignment__c viewTypeAssignTest24 = new View_type_Assignment__c(Wing__c=wingTest5.Id,Flat_Type__c=flatTypeTest7.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('Flat Type Record').getRecordTypeId(),Pattern__c ='Odd',From__c=1,To__c=10, Column_Index__c = '1');
	    lstviewTypeAssignTest.add(viewTypeAssignTest24);
	    
	    View_type_Assignment__c viewTypeAssignTest25 = new View_type_Assignment__c(Wing__c=wingTest5.Id,Flat_Type__c=flatTypeTest7.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('Flat Type Record').getRecordTypeId(),Pattern__c ='Even',From__c=1,To__c=10, Column_Index__c = '1');
	    lstviewTypeAssignTest.add(viewTypeAssignTest25);
	    
	    
	    View_type_Assignment__c viewTypeAssignTest26 = new View_type_Assignment__c(Wing__c=wingTest5.Id,Flat_Type__c=flatTypeTest6.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('Flat Type Record').getRecordTypeId(),Pattern__c ='Even', From__c=1,To__c=10, Column_Index__c = '2');
	    lstviewTypeAssignTest.add(viewTypeAssignTest26);
	    
	    View_type_Assignment__c viewTypeAssignTest27 = new View_type_Assignment__c(Wing__c=wingTest5.Id,Flat_Type__c=flatTypeTest6.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('Flat Type Record').getRecordTypeId(),Pattern__c ='Odd', From__c=1,To__c=10, Column_Index__c = '2');
	    lstviewTypeAssignTest.add(viewTypeAssignTest27);
	      
	    View_type_Assignment__c viewTypeAssignTest28 = new View_type_Assignment__c(Wing__c=wingTest5.Id,Flat_Type__c=flatTypeTest7.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('View Type Record').getRecordTypeId(),Pattern__c ='Odd',View__c='Garden View',From__c=1,To__c=10, Column_Index__c = '1');
	    lstviewTypeAssignTest.add(viewTypeAssignTest28);
	    
	    View_type_Assignment__c viewTypeAssignTest29 = new View_type_Assignment__c(Wing__c=wingTest5.Id,Flat_Type__c=flatTypeTest7.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('View Type Record').getRecordTypeId(),Pattern__c ='Even',View__c='Garden View',From__c=1,To__c=10, Column_Index__c = '1');
	    lstviewTypeAssignTest.add(viewTypeAssignTest29);
	    
	    View_type_Assignment__c viewTypeAssignTest30 = new View_type_Assignment__c(Wing__c=wingTest5.Id,Flat_Type__c=flatTypeTest6.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('View Type Record').getRecordTypeId(),Pattern__c ='Even', View__c='Sea View', From__c=1,To__c=10, Column_Index__c = '2');
	    lstviewTypeAssignTest.add(viewTypeAssignTest30);
	    
	    View_type_Assignment__c viewTypeAssignTest31 = new View_type_Assignment__c(Wing__c=wingTest5.Id,Flat_Type__c=flatTypeTest6.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('View Type Record').getRecordTypeId(),Pattern__c ='Odd', View__c='Sea View', From__c=1,To__c=10, Column_Index__c = '2');
	    lstviewTypeAssignTest.add(viewTypeAssignTest31);
		insert lstviewTypeAssignTest;
	    
	    List<Rate_Card__c> lstRateCard = new List<Rate_Card__c>();
	    Rate_Card__c rateCardTest13 = new Rate_Card__c (Wing__c=wingTest5.Id,recordtypeid=Schema.SObjectType.Rate_Card__c.getRecordTypeInfosByName().get('Premium View Rate Record').getRecordTypeId(),Flat_Type__c=flatTypeTest7.Id,Premium_View__c='Garden View',View_Rate_Sq_Ft__c=20);
	    lstRateCard.add(rateCardTest13);
	    
	    Rate_Card__c rateCardTest14 = new Rate_Card__c (Wing__c=wingTest5.Id,recordtypeid=Schema.SObjectType.Rate_Card__c.getRecordTypeInfosByName().get('Premium View Rate Record').getRecordTypeId(),Flat_Type__c=flatTypeTest6.Id,Premium_View__c='Sea View',View_Rate_Sq_Ft__c=220);
	    lstRateCard.add(rateCardTest14);
	    
	    Rate_Card__c rateCardTest15 = new Rate_Card__c (Wing__c=wingTest5.Id,recordtypeid=Schema.SObjectType.Rate_Card__c.getRecordTypeInfosByName().get('Floor Rise Rate').getRecordTypeId(),Flat_Type__c=flatTypeTest7.Id,Floor_From__c=1,Floor_To__c=10,Floor_Rise_Sq_Ft__c=20);
	    lstRateCard.add(rateCardTest15);
	    
	    Rate_Card__c rateCardTest16 = new Rate_Card__c (Wing__c=wingTest5.Id,recordtypeid=Schema.SObjectType.Rate_Card__c.getRecordTypeInfosByName().get('Floor Rise Rate').getRecordTypeId(),Flat_Type__c=flatTypeTest6.Id,Floor_From__c=1,Floor_To__c=10,Floor_Rise_Sq_Ft__c=240);
	    lstRateCard.add(rateCardTest16);
	    
	    insert lstRateCard;
 
    
        //execute batch class
        Database.BatchableContext BC;
        SpBatchGenerateInventory batchRP = new SpBatchGenerateInventory();
        //batchRP.start(BC);
        Database.executeBatch(batchRP);
        //batchRP.execute(BC, wingTestList5);
        Test.stopTest();
    }
    
     
    //Test method for ScheduleBatchResetPassword class
    /*
    testMethod static void test_ScheduleBatchProjectImage(){
        Test.startTest();  
        ScheduleBatchProjectImage scheduleReset = new ScheduleBatchProjectImage();
        String schedule = '0 0 23 * * ?';
        system.assert(system.schedule('Scheduled Reset', schedule, scheduleReset)!=null);
        Test.stopTest();
    }
    */
}