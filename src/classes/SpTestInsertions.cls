//Created by Apurva Patel.
public class SpTestInsertions{

   
    //removed field Company__c='Test Lodha' as I want to delete it from object 
    //Pratik A.
    public Project_Name__c createProjectName(){
     Project_Name__c projectNameTest = new Project_Name__c(Name='Test Project Name',CRN_INIT__c= 'LCP', Project_Type__c = 'Test Casa',Record_Type__c='Residential',Project_Manager__c=UserInfo.getUserId(),Site_Incharge__c=UserInfo.getUserId(),Project_Incharge__c=UserInfo.getUserId(),DAM_Limit__c=120);
      return  projectNameTest;
            
    }
    
    public Cluster__c createCluster(Project_Name__c projectNameTest){
        Cluster__c clusterTest = new Cluster__c(Name='Test Cluster',Project_Name__c = projectNameTest.Id);
        return clusterTest;
    }
    
  /*  public Stage__c createStage(){
        Stage__c stageTest = new Stage__c(Name='Test Stage',No_of_Stages__c=2);
        return stageTest;
    }*/
    
    public  Wing__c createWing(Cluster__c clusterTest){
         Wing__c wingTest = new Wing__c(Name='Test Wing',Cluster__c=clusterTest.Id,No_of_Floors__c=3,No_of_flats_floor__c=2,Proposed_Completion__c=System.now().date()+20);
         return wingTest;
    }
    
    public Stage_Details__c createStageDetails(Wing__c wingTest){
         Stage_Details__c stageDetailsTest = new Stage_Details__c(Name='Test Stage Details',Wing__c=wingTest.Id,Slab__c=10,Expected_Completion_Date__c=System.now().date()+20);
         return stageDetailsTest;
    }
    
   /* public Booking_Stage_Details__c createBookingStageDetails(Wing__c wingTest,Stage__c stageTest){
        Booking_Stage_Details__c bookingStageDetailsTest =  new Booking_Stage_Details__c(Name='Test Booking Stage Details',Stage__c=stageTest.Id,Wing__c=wingTest.Id,Short_Excess__c=10,Booking_Slab__c=2);
        return bookingStageDetailsTest;
    }*/
    
   /* public Flat__c createFlat(Wing__c wingTest){
        Flat__c flatTest=new Flat__c(Flat_No__c=2,Wing__c=wingTest.Id);
        return flatTest;
    }*/
    
    public Flat_Type__c createFlatType(Wing__c wingTest){
        Flat_Type__c flatTypeTest = new Flat_Type__c (Name='1BHK',Wing__c=wingTest.Id,Base_Rate_Sq_Ft__c=100,Carpet_Area__c=1500,Club_Charge_Rs__c=120,Infrastructure_Rs__c=100,Infrastructure_2_Rs__c=200,Salable_Area__c=1500,Token_Amount_Rs__c=50000);
        return flatTypeTest;
    }
    
    /*public View_type_Assignment__c createViewTypeAssign(Wing__c wingTest,Flat_Type__c flatTypeTest){
        View_type_Assignment__c viewTypeAssignTest = new View_type_Assignment__c(Wing__c=wingTest.Id,Flat_Type__c=flatTypeTest.Id,Pattern__c ='All',View__c='Sea View',From__c=1,To__c=2);
        return viewTypeAssignTest;
    }
    
    public Rate_Card__c createRateCard(Wing__c wingTest,Flat_Type__c flatTypeTest){
        Rate_Card__c rateCardTest = new Rate_Card__c (Wing__c=wingTest.Id,Flat_Type__c=flatTypeTest.Id,Floor_From__c=1,Floor_To__c=2,Premium_View__c='Sea View');
        return rateCardTest;
        
    }*/
    
    
    
    
    
    
    
    
}