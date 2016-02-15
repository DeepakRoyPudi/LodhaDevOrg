@istest(seealldata=false)
Public class Test_SpOppBookingConnector{

static testMethod void SpOppBookingConnectorTesting(){

// For Inserting RecordType Name In Account object

    Schema.DescribeSObjectResult getRecordType=Schema.SObjectType.Account;
    Map<String,Schema.RecordTypeInfo> AccountRecordTypeInfo=getRecordType.getRecordTypeInfosByName();
    Id rtId=AccountRecordTypeInfo.get('Booked Account').getRecordTypeId(); 
    Account acc=new Account(LastName='TestingLast',Mobile_Phone__c='9930305236',recordtypeid=AccountRecordTypeInfo.get('Booked Account').getRecordTypeId());
    //Account acc=new Account(LastName='TestingLast',Mobile_Phone__c='9930305236',recordtypeid=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Booked Account').getRecordTypeId());
    insert acc;

    Project_Name__c testProject=new Project_Name__c(Name='Testing',CRN_INIT__c='LBV',isSP2__c=false,Project_Type__c='Commercial',Record_Type__c='Residential');
    insert testProject;

    Schema.DescribeSObjectResult getRecordType1=Schema.SObjectType.Opportunity;
    Map<String,Schema.RecordTypeInfo> OPPRecordTypeInfo=getRecordType1.getRecordTypeInfosByName();
    Id rtTd=OPPRecordTypeInfo.get('Residential').getRecordTypeId();
    
   // System.debug('*********rtTd*********'+rtTd);
    Date d=Date.Today();
   // System.debug('Project Name=='+testProject.id);
  //  System.debug('Account Name=='+acc.id);
   

    Cluster__c testCluster=new Cluster__c(Name='TestingCluster',Project_Name__c=testProject.id);
    insert testCluster;

    Wing__c testWing=new Wing__c(Name='TestingWing',Cluster__c=testCluster.id);
    insert testWing;

    Wing__c checkWing = [select Project__c from Wing__c where Id =: testWing.Id];
    System.assert(checkWing.Project__c == 'Testing');

   
    Flat_Type__c flatTypeTest = new Flat_Type__c (Name='1BHK',Wing__c=checkWing.Id,Base_Rate_Sq_Ft__c=100,Carpet_Area__c=1500,Club_Charge_Rs__c=120,Infrastructure_Rs__c=100,Infrastructure_2_Rs__c=200,Salable_Area__c=1500,Token_Amount_Rs__c=50000);
    insert flatTypeTest;
    
    View_type_Assignment__c viewTypeAssignTest1 = new View_type_Assignment__c(Wing__c=checkWing.Id,Flat_Type__c=flatTypeTest.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('Flat Type Record').getRecordTypeId(),Pattern__c ='All', Column_Index__c = '1');
    insert viewTypeAssignTest1;
    
    View_type_Assignment__c viewTypeAssignTest2 = new View_type_Assignment__c(Wing__c=checkWing.Id,Flat_Type__c=flatTypeTest.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('Flat Type Record').getRecordTypeId(),Pattern__c ='All', Column_Index__c = '2');
    insert viewTypeAssignTest2;
    
    View_type_Assignment__c viewTypeAssignTest3 = new View_type_Assignment__c(Wing__c=checkWing.Id,Flat_Type__c=flatTypeTest.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('View Type Record').getRecordTypeId(),Pattern__c ='All',View__c='Sea View', Column_Index__c = '1');
    insert viewTypeAssignTest3;
    
    View_type_Assignment__c viewTypeAssignTest4 = new View_type_Assignment__c(Wing__c=checkWing.Id,Flat_Type__c=flatTypeTest.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('View Type Record').getRecordTypeId(),Pattern__c ='All',View__c='Sea View', Column_Index__c = '2');
    insert viewTypeAssignTest4;
    
    Rate_Card__c rateCardTest1 = new Rate_Card__c (Wing__c=checkWing.Id,recordtypeid=Schema.SObjectType.Rate_Card__c.getRecordTypeInfosByName().get('Premium View Rate Record').getRecordTypeId(),Flat_Type__c=flatTypeTest.Id,Premium_View__c='Sea View',View_Rate_Sq_Ft__c=20);
    insert rateCardTest1;
    
    Rate_Card__c rateCardTest2 = new Rate_Card__c (Wing__c=checkWing.Id,recordtypeid=Schema.SObjectType.Rate_Card__c.getRecordTypeInfosByName().get('Floor Rise Rate').getRecordTypeId(),Flat_Type__c=flatTypeTest.Id,Floor_From__c=1,Floor_To__c=2,Floor_Rise_Sq_Ft__c=20);
    insert rateCardTest2;
    
    Flat__c flt = new Flat__c(Wing__c=checkWing.Id,Flat_No__c=1234,Flat_Type__c=flatTypeTest.id,Carpet_Area__c=234,Stage_Completed__c='3',Salable_Area__c=123,Floor__c=2,View__c='Sea View');
    insert flt;
     Opportunity opp=new Opportunity(Name='Test Opportunity',recordtypeid =Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Residential').getRecordTypeId(),Account = acc,CloseDate=System.now().date()+20,Project_Name__c = testProject.id,StageName = 'Qualified',Servicing_Team__c='Presales',IsActive__c=true,Carpet_Area__c=100);
    //Opportunity opp=new Opportunity(Name='test',Project_Name__c=testProject.id,StageName='Qualification',recordtypeid=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Residential').getRecordTypeId(),Accountid=acc.id,CloseDate=d);
    insert opp;
    
    System.debug('opp'+opp);
    
    ApexPages.StandardController stc = new ApexPages.StandardController(checkWing); 
    SpGenerateInventory testSpGenerateInventory = new SpGenerateInventory(stc);
    testSpGenerateInventory.generateInventory();
   
    Booking_Information__c bookingInformationTest= new Booking_Information__c(Booking_Status__c='BOOKED',Name_Of_Opportunity__c=opp.id,Unique_booking_Id__c=flt.id,flat__c=flt.id,Block_Detail__c='Test Block Details',Consideration_Actual_Rs__c=10000,Infrastructure_Incl_in_CV__c='Incl.in CV',Infrastructure2_Incl_in_CV__c='Incl.in CV',Club_Charges_Incl_in_CV__c='Incl.in CV',Infrastructure_Cost_Rs__c=100,Infrastructure_Cost_2_Rs__c=100,Club_Charges_Rs__c=100,Infrastructure_Cost_2Actual_Rs__c=100,Infrastructure_Cost_Actual_Rs__c=150,Club_charges_Actual_Rs__c=100,Base_Rate_Sq_ft_Actual_Rs__c=120,Floor_rise_Sq_ft_Actual_Rs__c=120,Premium_Sq_ft_Actual_Rs__c=120,Applicable_Waiver_Sq_ft_Actual_Rs__c=120,Total_Rate_Sq_ft_Actual_Rs__c=120,Flat_Cost_Actual_Rs__c=120,Applicable_Waiver_Sq_ft_Rs__c=100,Booking_Date__c=System.now().date());
    insert bookingInformationTest;

   

    Pagereference ref=new Pagereference('/apex/SpOppBookingConnectorTesting');
    Test.setCurrentPage(ref);
        ref.getParameters().put('oppid',opp.id);
        ref.getParameters().put('proj',testProject.Name);
        ref.getParameters().put('clusterid',testCluster.Name);
        ref.getParameters().put('wid',testWing.Name);
        ref.getParameters().put('flatno','1234');
        //ref.getParameters().put('flatno','');
        
    SpOppBookingConnector SpOppBookingConnectorTest=new SpOppBookingConnector (null);
    SpOppBookingConnectorTest.goToBooking();
    
    testProject.isSP2__c=true;
    update testProject;
    
    SpOppBookingConnectorTest.goToBooking();
    
    Pagereference ref1=new Pagereference('/apex/SpOppBookingConnectorTesting');
    Test.setCurrentPage(ref1);
        ref.getParameters().put('oppid',null);
        ref.getParameters().put('proj',testProject.Name);
        ref.getParameters().put('clusterid',testCluster.Name);
        ref.getParameters().put('wid',testWing.Name);
        ref.getParameters().put('flatno',null);
        //ref.getParameters().put('flatno','');
     
        
        // For Booking size is not equal to 1
     
   
        Pagereference ref2=new Pagereference('/apex/SpOppBookingConnectorTesting');
        Test.setCurrentPage(ref2);
        ref2.getParameters().put('oppid',null);
        ref2.getParameters().put('proj',testProject.Name);
        ref2.getParameters().put('clusterid',testCluster.Name);
        ref2.getParameters().put('wid',testWing.Name);
        ref2.getParameters().put('flatno',null);  
        
    SpOppBookingConnector SpOppBookingConnectorTest2=new SpOppBookingConnector(null);
    SpOppBookingConnectorTest2.goToBooking();


}

}