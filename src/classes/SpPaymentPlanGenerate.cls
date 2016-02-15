public class SpPaymentPlanGenerate{

public Flat__c flat{get;set;}
public Decimal token_amt{get;set;}
public List<Stage_Details__c> stgdet{get;set;}
public List<Flat__c> flatdet{get;set;}

public String desc1{get; set;}
public decimal instal_1{get; set;}

public String desc2{get; set;}
public decimal instal_2{get; set;}

public Id wid {get;set;} 
public Id fid {get;set;} 
public Decimal cost{get;set;}
public Decimal sum{get;set;}
public Decimal due_amt{get;set;}

public String cluster_name{get;set;}
public String wing_name{get;set;}
public String flat_no{get;set;}
public String project{get;set;}
public String payment_status{get;set;}
public String today{get;set;}

public boolean display_booking_payment_block{get;set;}

public SpPaymentPlanGenerate(ApexPages.StandardController controller) {
  display_booking_payment_block = false;
  cost = Decimal.ValueOf(ApexPages.currentPage().getParameters().get('cost'));
  wid = ApexPages.currentPage().getParameters().get('wid');
  fid = ApexPages.currentPage().getParameters().get('fid');
  stgdet = [select Name,Actual_Completion_Date__c,Description__c,Slab__c,Wing__c, Amount__c, due_status__c from Stage_Details__c where Wing__c =:wid Order By CreatedDate ASC ];
  
  decimal k;
  decimal check = 0;
  sum = 0;
  due_amt = 0;
  for(Stage_Details__c s: stgdet) {
    k = (cost * s.Slab__c)/100;
    s.Amount__c = math.round(k);
    sum = sum + s.Amount__c;
    
    //calculate and mark total due
    if(s.Actual_Completion_Date__c != null) {
      check = check + 1;
      s.due_status__c = 'Due';
      due_amt = due_amt + s.Amount__c;
    }
  }
  
  flat = [Select Id, Name, Wing__r.name,Flat_Type__r.Name,Wing__c, Wing__r.Project__c, Wing__r.Company__c, 
          Wing__r.Cluster_hidden__c,View__c, Total_Rate_Sq_Ft_Rs__c, Token_Amount_Rs__c,Status__c, 
          Stage_Completed__c, Salable_Area__c, Premium_Sq_Ft_Rs__c, Infrastructure_Incl_in_CV__c, 
          Infrastructure_Cost_Rs__c, Infrastructure_Cost2_Rs__c, Infrastructure2_Incl_in_CV__c, 
          Floor__c, Floor_Rise_Sq_Ft_Rs__c, Flat_Type__c, Flat_No__c, Flat_Cost_Rs__c, 
          DAM_Offer_Sq_Ft_Rs__c, Consideration_Rs__c, Club_Charges_Rs__c, Club_Charges_Incl_in_CV__c, 
          Carpet_Area__c, Base_Rate_Sq_Ft_Rs__c, Applicable_Waiver_Sq_Ft_Rs__c, Amount_Due_Rs__c From Flat__c 
          Where Id =:Fid];
  
  token_amt = flat.Token_Amount_Rs__c;
  cluster_name = flat.Wing__r.Cluster_hidden__c;
  wing_name = flat.Wing__r.name;
  flat_no = String.valueOf(flat.Flat_No__c);
  project = flat.Wing__r.Project__c;
  
  datetime today_date;
  today_date = datetime.now();
  today = today_date.format();
  
  decimal twenty_per_cv = (20*cost)/100;
  if(due_amt <= twenty_per_cv) {
    desc1 = '1st Installment';
    instal_1 =  math.round(((9.9*cost)/100) - token_amt); 
    
    desc2 = '2nd Installment';
    instal_2 =  math.round((10*cost)/100); 
    display_booking_payment_block = true;
  }
  else {
    desc1 = '1st Installment';
    instal_1 =  math.round(((19.9*cost)/100) - token_amt); 
    
    desc2 = '2nd Installment';
    instal_2 =  math.round(due_amt - instal_1);
    display_booking_payment_block = true;
  }
  
  
} 

public string[] getheaders() { return new string [] 
  {'Stage#','Description','Slab%', 'Amount(Rs.)',''} ; 
}

public string[] getbookingheaders() { return new string [] 
  {'Description', 'Amount(Rs.)'} ; 
}



static testMethod void testPaymentPlan(){
        
        SpTestInsertions spTestInsertions = new SpTestInsertions();
        
        Account accountTest = new Account(recordtypeid =Schema.SObjectType.Account.getRecordTypeInfosByName().get('Booked Account').getRecordTypeId(),LastName ='Test Last Name',Mobile_Phone__c ='456872934');
        insert accountTest;
        
        Project_Name__c projectNameTest = spTestInsertions.createProjectName();
        insert projectNameTest;    
    
        Cluster__c clusterTest = spTestInsertions.createCluster(projectNameTest);
        insert clusterTest;
    
    
        Wing__c wingTest = spTestInsertions.createWing(clusterTest);
        insert wingTest;
        
        Flat_Type__c flatTypeTest = spTestInsertions.createFlatType(wingTest);
        insert flatTypeTest;
       
        Stage_Details__c stageDetailsTest = spTestInsertions.createStageDetails(wingTest);
        insert stageDetailsTest;
        
        //Test scenario when Actual_Completion_Date__c in StageDetails is null
        Stage_Details__c stageDetailsTest1 = new Stage_Details__c(Name='Test Stage Details',Wing__c=wingTest.Id,Slab__c=10,Actual_Completion_Date__c=System.now().date()+20);
        insert stageDetailsTest1;
        
        View_type_Assignment__c viewTypeAssignTest1 = new View_type_Assignment__c(Wing__c=wingTest.Id,Flat_Type__c=flatTypeTest.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('Flat Type Record').getRecordTypeId(),Pattern__c ='All',Column_Index__c = '1');
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
 
        Flat__c FlatTest = [select Id,Salable_Area__c from Flat__c Where Wing__c=:wingTest.Id limit 1]; 
    
        
        Opportunity opportunityTest = new Opportunity(Name='Test Opportunity',recordtypeid =Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Residential').getRecordTypeId(),Account = accountTest,CloseDate=System.now().date()+20,Project_Name__c = projectNameTest.id,StageName = 'Qualified',Servicing_Team__c='Presales',IsActive__c=true);
        insert opportunityTest; 
        
        
        Booking_Information__c bookingInformationTest= new Booking_Information__c(Name_Of_Opportunity__c=opportunityTest.id,Unique_booking_Id__c=FlatTest.id,Flat__c=FlatTest.id,Block_Detail__c='Test Block Details',Consideration_Actual_Rs__c=10000,Infrastructure_Incl_in_CV__c='Incl.in CV',Infrastructure2_Incl_in_CV__c='Incl.in CV',Club_Charges_Incl_in_CV__c='Incl.in CV',Infrastructure_Cost_Rs__c=100,Infrastructure_Cost_2_Rs__c=100,Club_Charges_Rs__c=100,Infrastructure_Cost_2Actual_Rs__c=100,Infrastructure_Cost_Actual_Rs__c=150,Club_charges_Actual_Rs__c=100,Base_Rate_Sq_ft_Actual_Rs__c=120,Floor_rise_Sq_ft_Actual_Rs__c=120,Premium_Sq_ft_Actual_Rs__c=120,Applicable_Waiver_Sq_ft_Actual_Rs__c=120,Total_Rate_Sq_ft_Actual_Rs__c=120,Flat_Cost_Actual_Rs__c=120,Applicable_Waiver_Sq_ft_Rs__c=100,Booking_Date__c=System.now().date());
        insert bookingInformationTest;
        
        PageReference ref=new PageReference('/apex/TestSpPaymentPlanGenerate');
        Test.setCurrentPage(ref);
  
        ref.getParameters().put('wid',wingTest.id);
        ref.getParameters().put('fid',FlatTest.id);
        ref.getParameters().put('cost',String.ValueOf(bookingInformationTest.Consideration_Actual_Rs__c));
        
        SpPaymentPlanGenerate testSpPaymentPlanGenerate=new SpPaymentPlanGenerate(null);
        
        Stage_Details__c stageDetailsTest2 = new Stage_Details__c(Name='Test Stage Details',Wing__c=wingTest.Id,Slab__c=30,Actual_Completion_Date__c=System.now().date()+20);
        insert stageDetailsTest2;
        
        SpPaymentPlanGenerate testSpPaymentPlanGenerate1=new SpPaymentPlanGenerate(null);
        
        testSpPaymentPlanGenerate.getheaders();
        testSpPaymentPlanGenerate.getbookingheaders();
}

}