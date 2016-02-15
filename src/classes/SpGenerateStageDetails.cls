public class SpGenerateStageDetails{

   public List<Stage_Details__c> stgDetList {get; set;}
   public List<Stage_Details__c> stgDetListEdit {get; set;}
   Decimal estimate;
   public static boolean editMode{set; get;}
   private ApexPages.StandardController std;
   public Id wid{set; get;}
   
   public decimal short_excess{get; set;}
   public decimal total{get; set;}
   
   public decimal b_short_excess{get; set;}
   public decimal b_total{get; set;}
   
   
  public SpGenerateStageDetails(ApexPages.StandardController stdController) {
    std = stdController;
    wid = ApexPages.currentPage().getParameters().get('wid');
    stgDetListEdit = new List<Stage_Details__c>();
   
    stgDetList = [select Id, Wing__c, Name, Actual_Completion_Date__c, Expected_Completion_Date__c, Description__c, Slab__c
                       from Stage_Details__c where Wing__c =:wid Order By CreatedDate ASC];
                        

    editMode = false;
    stgcalculate();
  
  }
   
  public PageReference goBack(){
    PageReference redirect = new PageReference('/' + wid); 
    redirect.setRedirect(true);
    return redirect;
  }
  
 
  
  // public Getter to provide table headers 
 public string[] getheaders() { return new string [] 
  {'StageNo','Description','Slab%','Credit Days', 'Interest Rate P.A.','Completed On' } ; }
  
  
  //save stages
  public pagereference saveStageDetails(){
      update stgDetList;
      stgcalculate();
      return null;
  }

  
  public void stgcalculate() {
    Decimal k = 0;
    for(Stage_Details__c  stgd: stgDetList) {
        if(stgd.Slab__c != null){
            k = k + stgd.Slab__c;
        }
    }
    total = k;
    short_excess = 100-k;
  }
  
  


//test classes

static testMethod void testSpGenerateStageDetails(){

    SpTestInsertions spTestInsertions = new SpTestInsertions();

    Project_Name__c projectNameTest = spTestInsertions.createProjectName();
    insert projectNameTest;    
    
    Cluster__c clusterTest = spTestInsertions.createCluster(projectNameTest);
    insert clusterTest;
    
   
    Wing__c wingTest = spTestInsertions.createWing(clusterTest);
    insert wingTest;
    
    Stage_Details__c stageDetailsTest =  spTestInsertions.createStageDetails(wingTest);
    insert stageDetailsTest;
    
   // Booking_Stage_Details__c bookingStageDetailsTest = spTestInsertions.createBookingStageDetails(wingTest);
    //insert bookingStageDetailsTest;
    
    PageReference ref = new PageReference('/apex/spGenerateStageDetails');
    Test.setCurrentPage(ref);
    ref.getParameters().put('wid',wingTest.Id);
    
    SpGenerateStageDetails spGenerateStageDetailsTest = new SpGenerateStageDetails(null);
    
    spGenerateStageDetailsTest.saveStageDetails();
   // spGenerateStageDetailsTest.saveBookingStageDetails();
    
    Stage_Details__c checkStageDetails = [select Name from Stage_Details__c where Wing__c =:wingTest.Id];
    System.assert(checkStageDetails.Name == 'Test Stage Details');
    
    
    spGenerateStageDetailsTest.goBack();
    spGenerateStageDetailsTest.getheaders();
    
    
    
   
    
}

}