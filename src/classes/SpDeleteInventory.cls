// Created By Paragi


public class SpDeleteInventory{
public List<Flat__c> OfferDetails1 = new List<Flat__c>();
   
    public SPDeleteInventory(ApexPages.StandardController p){
    
    }
    
    public String getId(){
    String theId = ApexPages.currentPage().getParameters().get('id');
    return theId;
    }
    
    public PageReference redirectpage(){
        PageReference ref=new PageReference('/'+ getId());
           //  r.setRedirect(true);
        return ref;
    }
     
    public PageReference DelRecords(){
        OfferDetails1 =[Select id from Flat__c where Wing__r.Id = :getId()];
            for(Flat__c f: OfferDetails1)
            {
                f.Status__c = 'OPEN';
            }
            
            If(OfferDetails1.size()>0){
               update OfferDetails1;
               delete OfferDetails1;
             }
        return redirectpage();
    }
  
  
 

static testMethod void TestingDelete()
{
SpTestInsertions spTestInsertions = new SpTestInsertions();
        
        Account accountTest = new Account(recordtypeid =Schema.SObjectType.Account.getRecordTypeInfosByName().get('Booked Account').getRecordTypeId(),LastName ='Test Last Name',Mobile_Phone__c ='456872934');
        insert accountTest;
    
        Project_Name__c projectNameTest = spTestInsertions.createProjectName();
        insert projectNameTest;    
    
        Cluster__c clusterTest = spTestInsertions.createCluster(projectNameTest);
        insert clusterTest;
      
    
      //Stage__c stageTest = spTestInsertions.createStage();
     // insert stageTest;
    
       Wing__c wingTest = spTestInsertions.createWing(clusterTest);
        insert wingTest;
    
    
      Flat_Type__c flatTypeTest = spTestInsertions.createFlatType(wingTest);
      insert flatTypeTest;
    
      Stage_Details__c stageDetailsTest = spTestInsertions.createStageDetails(wingTest);
      insert stageDetailsTest;
        
      View_type_Assignment__c viewTypeAssignTest1 = new View_type_Assignment__c(Wing__c=wingTest.Id,Flat_Type__c=flatTypeTest.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('Flat Type Record').getRecordTypeId(),Pattern__c ='All', Column_Index__c = '1');
      insert viewTypeAssignTest1;
      
      View_type_Assignment__c viewTypeAssignTest2 = new View_type_Assignment__c(Wing__c=wingTest.Id,Flat_Type__c=flatTypeTest.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('Flat Type Record').getRecordTypeId(),Pattern__c ='All', Column_Index__c = '2');
      insert viewTypeAssignTest2;
    
      View_type_Assignment__c viewTypeAssignTest3 = new View_type_Assignment__c(Wing__c=wingTest.Id,Flat_Type__c=flatTypeTest.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('View Type Record').getRecordTypeId(),Pattern__c ='All',View__c='Sea View' , Column_Index__c = '1');
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
 
      Flat__c FlatTest = [select Id,Salable_Area__c from Flat__c Where Wing__c=:wingTest.Id limit 1]; 
    
        
        Opportunity opportunityTest = new Opportunity(Name='Test Opportunity',recordtypeid =Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Residential').getRecordTypeId(),Account = accountTest,CloseDate=System.now().date()+20,Project_Name__c = projectNameTest.id,StageName = 'Qualified',Servicing_Team__c='Presales',IsActive__c=true);
        insert opportunityTest; 
        
        
        
        Booking_Information__c bookingInformationTest= new Booking_Information__c(Name_Of_Opportunity__c=opportunityTest.id,Unique_booking_Id__c=FlatTest.id,Flat__c=FlatTest.id,Block_Detail__c='Test Block Details',Consideration_Actual_Rs__c=10000,Infrastructure_Incl_in_CV__c='Incl.in CV',Infrastructure2_Incl_in_CV__c='Incl.in CV',Club_Charges_Incl_in_CV__c='Incl.in CV',Infrastructure_Cost_Rs__c=100,Infrastructure_Cost_2_Rs__c=100,Club_Charges_Rs__c=100,Infrastructure_Cost_2Actual_Rs__c=100,Infrastructure_Cost_Actual_Rs__c=150,Club_charges_Actual_Rs__c=100,Base_Rate_Sq_ft_Actual_Rs__c=120,Floor_rise_Sq_ft_Actual_Rs__c=120,Premium_Sq_ft_Actual_Rs__c=120,Applicable_Waiver_Sq_ft_Actual_Rs__c=120,Total_Rate_Sq_ft_Actual_Rs__c=120,Flat_Cost_Actual_Rs__c=120,Applicable_Waiver_Sq_ft_Rs__c=100,Booking_Date__c=System.now().date());
        insert bookingInformationTest;

        PageReference ref = new PageReference('/apex/testDeleteInventory');
        Test.setCurrentPage(ref);
        ref.getParameters().put('id',wingTest.Id);

        SpDeleteInventory SpDeleteInventoryTest=new SpDeleteInventory(null);
        SpDeleteInventoryTest.DelRecords();


        List<Flat__c> checkDelete = [select Id from Flat__c where Wing__c =:wingTest.Id];
        System.assert(checkDelete.size()== 0);

}


}