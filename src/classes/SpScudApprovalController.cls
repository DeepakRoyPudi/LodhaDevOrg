public with sharing class SpScudApprovalController {

    public List<Stage_Payment_Details__c> stagePaymentDetails {get; set;}
    public Stage_Payment_Details__c stagePaymentDet {get; set;}
    public SCUD_Information__c scudInformation {get; set;}
    public boolean displayPricing {get; set;}
    public boolean displayConstruct {get; set;}
    public boolean displayOthers {get; set;}
    public boolean displayPage {get; set;}
    public Double differenceInCV {get; set;}
    public double discountGiven {get; set;}
    public boolean displaySubmit {get; set;}
    public string booking_date{get; set;}
    public decimal booking_token_amt{get; set;}
    public decimal token_amt{get; set;}
    public decimal current_total_sum{get; set;}
    public decimal req_total_sum{get; set;}
    public decimal orginal_CV{get; set;}
    public decimal actual_CV{get; set;}
    public String address1;
    public String address2;
    public decimal first_install{get; set;}
    public decimal second_install{get; set;}
    public decimal due_sum{get; set;} 
    public String test{get; set;} 
    Id BookingId;
    Id Sm_id;
    public Opportunity  opp;
    
    Public SpScudApprovalController()
    {
        try{
            scudInformation = new SCUD_Information__c();
            displayPage = true;
            displayPricing = false;
            displayConstruct = false;
            displayOthers = false;
            displaySubmit = false;
            differenceInCV = 0;
            discountGiven = 0;
            BookingId = ApexPages.currentPage().getParameters().get('bid');
            stagePaymentDetails = [Select Id, CV__c, Name, Booking_Information__r.Sales_Person__r.Name, Current_Date_Excepted__c, Payment_Slab__c, Current_Amount__c, Requested_Payment_Slab__c, Actual_Completion_Date__c,
                                    Requested_Date_Expected__c, Requested_Amount__c, Booking_Information__c, Booking_Information__r.OwnerId, Booking_Information__r.Booking_Date__c, Booking_Information__r.Booking_By__c,
                                    Booking_Information__r.Block_For__r.name, Booking_Information__r.Owner.Name, Booking_Information__r.Base_Rate_Sq_ft_Rs__c, Booking_Information__r.Flat__r.Token_Amount_Rs__c,
                                    Booking_Information__r.CreatedBy.Email, Booking_Information__r.Sales_Person__r.Email,Booking_Information__r.Consideration_Rs__c, Booking_Information__r.Consideration_Actual_Rs__c, 
                                    Booking_Information__r.Sales_Person__r.Id, Booking_Information__r.Flat__r.Salable_Area__c, Booking_Information__r.Name_of_Applicant__c,Booking_Information__r.Address3__c,
                                    Booking_Information__r.Name_Of_Opportunity__r.Project_Name__r.Sales_Strategist__r.Id,Booking_Information__r.City__c,Booking_Information__r.Address1__c,Booking_Information__r.Address2__c,
                                    Booking_Information__r.Name_Of_Opportunity__r.Project_Name__r.Site_Incharge__r.Email, Booking_Information__r.Name_Of_Opportunity__r.Project_Name__r.Site_Incharge__r.Id, 
                                    Booking_Information__r.Name_Of_Opportunity__r.Project_Name__r.Sales_Strategist__r.Name,Booking_Information__r.Total__c,Booking_Information__r.Pincode__c
                                    From Stage_Payment_Details__c Where Booking_Information__c = : BookingId order by CreatedDate ASC];
                                    
          //fetching total token amount paid and booking date
          booking_date = stagePaymentDetails[0].Booking_Information__r.Booking_Date__c.day() + '/' + stagePaymentDetails[0].Booking_Information__r.Booking_Date__c.month() + '/' + stagePaymentDetails[0].Booking_Information__r.Booking_Date__c.year();
           //booking_date = date.parse(String.valueof(stagePaymentDetails[0].Booking_Information__r.Booking_Date__c));
          
          booking_token_amt = stagePaymentDetails[0].Booking_Information__r.Total__c;    
          token_amt = stagePaymentDetails[0].Booking_Information__r.Flat__r.Token_Amount_Rs__c;
          orginal_CV = stagePaymentDetails[0].Booking_Information__r.Consideration_Rs__c;
          actual_CV = stagePaymentDetails[0].CV__c;
          integer k = 0;
          due_sum = 0;
          
          //Added for calculating due amount
          for(Stage_Payment_Details__c spd : stagePaymentDetails )  {
            if(spd.Actual_Completion_Date__c != null) {
              due_sum = due_sum + spd.Current_Amount__c;      
              k =  k +1;              
            }
          }
          
          first_install = 0;
          second_install = 0;
           
          if(due_sum > (stagePaymentDetails[0].CV__c * 0.199) ) {    
            first_install = (stagePaymentDetails[0].CV__c * 0.199) - token_amt;
            second_install = (due_sum - token_amt) - first_install;   
          }
          else if(due_sum <= (stagePaymentDetails[0].CV__c * 0.199)) {
            first_install = (stagePaymentDetails[0].CV__c * 0.099) - token_amt;
            second_install = (stagePaymentDetails[0].CV__c * 0.1);           
          }
          
         
          //deducting standard token amount from 1st installment
          stagePaymentDetails[0].Current_Amount__c= stagePaymentDetails[0].Current_Amount__c - token_amt;          
          
          
          
          integer j = 0;
          decimal sum = 0;
           decimal sum2 = 0;
          //manipulating the dates for some stages complted
          if(due_sum > 0) {
              system.debug('Entered not zero');
            for(Stage_Payment_Details__c spd : stagePaymentDetails) {
              if(spd.Actual_Completion_Date__c != null) {
                sum = sum + spd.Current_Amount__c;      
                if(sum <= first_install) {
                  spd.Current_Date_Excepted__c = date.valueof(stagePaymentDetails[0].Booking_Information__r.Booking_Date__c).addDays(20);
                }
                else {
                  spd.Current_Date_Excepted__c = date.valueof(stagePaymentDetails[0].Booking_Information__r.Booking_Date__c).addDays(41);
                }
                j = j +1;
              }                     
            }
          }
          //manipulating the dates all stages construction remaining
    
          if(due_sum == 0) { 
              system.debug('Entered zero');
              system.debug('first_install:' + first_install);
              system.debug('second_install:' + second_install);
              system.debug('CV:' + stagePaymentDetails[0].CV__c);
            for(Stage_Payment_Details__c spd : stagePaymentDetails) {
              system.debug('spd.Current_Amount__c:' + spd.Current_Amount__c);
              sum = sum + spd.Current_Amount__c; 
              test = String.valueof(spd.Current_Amount__c);     
              if(sum <= first_install) {
                //test = 'inside if';
                spd.Current_Date_Excepted__c = date.valueof(stagePaymentDetails[0].Booking_Information__r.Booking_Date__c).addDays(20);
              }
              else {
                sum2 = sum2 + spd.Current_Amount__c;
                if(sum2 <= second_install) {
                  spd.Current_Date_Excepted__c = date.valueof(stagePaymentDetails[0].Booking_Information__r.Booking_Date__c).addDays(41);
                }
              }                
              j = j +1;                                
            }
          }
          
         
         
          //check if any expected falls before booking date + 41
          for(integer m= j; m<=(stagePaymentDetails.size()-1); m++) {
            if(stagePaymentDetails[m].Current_Date_Excepted__c < date.valueof(stagePaymentDetails[0].Booking_Information__r.Booking_Date__c).addDays(41)) {
              stagePaymentDetails[m].Current_Date_Excepted__c = date.valueof(stagePaymentDetails[0].Booking_Information__r.Booking_Date__c).addDays(41);
            }            
          }          
          
          
          
          // deducting paid total token amount from requested 1st installment amount.
          decimal temp_var = (stagePaymentDetails[0].CV__c * (stagePaymentDetails[0].Payment_Slab__c / 100)) - booking_token_amt;           
          decimal prec = 2;
          stagePaymentDetails[0].Requested_Amount__c = temp_var.setScale(2, RoundingMode.HALF_UP);
          
          //current = requested by default for first time
          for(Stage_Payment_Details__c spd : stagePaymentDetails ) {
            if(spd.Requested_Amount__c == 0 || spd.Requested_Amount__c == null) {
              spd.Requested_Amount__c = spd.Current_Amount__c;
            }
            if(spd.Requested_Date_Expected__c == null) {
              spd.Requested_Date_Expected__c = spd.Current_Date_Excepted__c;
            }
          }
          
          
                                                       
          current_total_sum = 0;
          req_total_sum = 0;
          
          for(Stage_Payment_Details__c spd : stagePaymentDetails ) {
            current_total_sum   = current_total_sum  + spd.Current_Amount__c;
            req_total_sum  = req_total_sum  + spd.Requested_Amount__c;
          }
          
          current_total_sum = current_total_sum + token_amt;    
          req_total_sum = req_total_sum + booking_token_amt;
          
          opp  = [Select Account.Address1_R_cont__pc, Account.Address2_R_cont__pc, Account.Address3_R_cont__pc, 
                         Account.City_cont__pc,
                         Account.Pincode_R_cont__pc, Account.Lead_Company_Name_cont__pc, Account.Occupation_acc__c, 
                  Account.Designation__pc, 
                  Account.Preferred_Correspondence_Address__c, Walk_in_Source__c from Opportunity where id = :stagePaymentDetails[0].Booking_Information__r.Name_Of_Opportunity__c]; 
        }
        Catch(exception e){
             ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, e.getMessage()));
        }
    }

    public PageReference CalculateNPV() {
        double newNPV = 0;
        double oldNPV = 0;
        decimal rate = 13;
        req_total_sum = 0;
        decimal CV = 0;
        displaySubmit = False;
        rate = 1 + rate.divide(100, 8);
        double doublerate = rate.setScale(4);
        //Date startDate = stagePaymentDetails[0].Current_Date_Excepted__c;
        
        Date startDate = date.newinstance(stagePaymentDetails[0].Booking_Information__r.Booking_Date__c.Year(), stagePaymentDetails[0].Booking_Information__r.Booking_Date__c.month(), stagePaymentDetails[0].Booking_Information__r.Booking_Date__c.day());
       // Date startDate = date.newinstance(2013, 06, 11);
        Date changeDate = null;
        Boolean lesserDate = False;
        
        //Start date should be 
        /*
        if( startDate != stagePaymentDetails[0].Requested_Date_Expected__c){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Start Date for Current schedule and Expected schedule should be same.'));
          return NULL;
        }
        */      
        
        
        address1  =  stagePaymentDetails[0].Booking_Information__r.Address1__c + ', '+ stagePaymentDetails[0].Booking_Information__r.Address2__c + ', ' + stagePaymentDetails[0].Booking_Information__r.Address3__c;
        if(stagePaymentDetails[0].Booking_Information__r.City__c  != null ) {
          address1 = address1 + ', ' + stagePaymentDetails[0].Booking_Information__r.City__c;
        }
                
        if(stagePaymentDetails[0].Booking_Information__r.Pincode__c != null) {
          if(stagePaymentDetails[0].Booking_Information__r.City__c  != null) {
            address1 =  address1 + '-' + stagePaymentDetails[0].Booking_Information__r.Pincode__c;        
          }
          else {
            address1 =  address1 + ', ' + stagePaymentDetails[0].Booking_Information__r.Pincode__c; 
          }
        }
        
       
        if(address1.contains(', null')){
          address1 = address1.replace(', null' , '');
        }
        else if(address1.contains('-null')) {
          address1 = address1.replace('-null' , '');        
        }
         
        if(address1 == null) {       
          address1 = '';
        } 
        
        
        scudInformation.AccountCompany__c = opp.Account.Lead_Company_Name_cont__pc; 
        scudInformation.AccountCorrespondence__c = address1;
        scudInformation.OpportunityWalkinSource__c = stagePaymentDetails[0].Booking_Information__r.Booking_By__c;
        scudInformation.Accountdesignation__c =  opp.Account.Designation__pc;
        scudInformation.AccountOccupation__c = opp.Account.Occupation_acc__c; 
        
        req_total_sum = booking_token_amt;
        
        //Calculation for New NPV for token amount
            Decimal newDatediff = (startDate.daysBetween(startDate));
            newDatediff= newDatediff.divide(365, 8);
            double doubleNewDateDiff = newDateDiff.setScale(8);
            decimal newDivs = Math.pow(doublerate, doubleNewDateDiff);
            newNPV = newNPV + (booking_token_amt/newDivs);
        
        //Calculation for Old NPV for token amount
            Decimal oldDatediff = (startDate.daysBetween(startDate));
            oldDateDiff = oldDatediff.divide(365, 8);
            double doubleOldDateDiff = oldDateDiff.setScale(8);
            decimal oldDivs = Math.pow(doublerate, doubleOldDateDiff);
            oldNPV = oldNPV + (token_amt/oldDivs);
           
        for(Stage_Payment_Details__c nn : stagePaymentDetails){    
            
            req_total_sum = req_total_sum + nn.Requested_Amount__c;

            CV = nn.CV__c.round();

            if(nn.Requested_Date_Expected__c < changeDate)
            {
              lesserDate = True;
            }

            //Calculation for New NPV
            newDatediff = (startDate.daysBetween(nn.Requested_Date_Expected__c));
            newDatediff= newDatediff.divide(365, 8);
            doubleNewDateDiff = newDateDiff.setScale(8);
            newDivs = Math.pow(doublerate, doubleNewDateDiff);
            newNPV = newNPV + (nn.Requested_Amount__c/newDivs);
            
         
            system.debug('startDate:' + startDate);
            system.debug('Current_Date_Excepted__c:' + nn.Current_Date_Excepted__c);
            //Calculation for Old NPV
            oldDatediff = (startDate.daysBetween(nn.Current_Date_Excepted__c));
            oldDateDiff = oldDatediff.divide(365, 8);
            doubleOldDateDiff = oldDateDiff.setScale(8);
            oldDivs = Math.pow(doublerate, doubleOldDateDiff);
            oldNPV = oldNPV + (nn.Current_Amount__c/oldDivs);
          
            changeDate = nn.Requested_Date_Expected__c;
            
            differenceInCV = (nn.Booking_Information__r.Consideration_Rs__c - nn.Booking_Information__r.Consideration_Actual_Rs__c)/nn.Booking_Information__r.Flat__r.Salable_Area__c;
            //discountGiven = (oldNPV-newNPV) / nn.Booking_Information__r.Base_Rate_Sq_ft_Rs__c;
            //chnaged on 12/6/2013 as per given formula by lodha
            discountGiven = (newNPV-oldNPV) / nn.Booking_Information__r.Flat__r.Salable_Area__c;
        }
        req_total_sum = req_total_sum.round();
        if(lesserDate)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'ERROR: Stage expected date should not lesser than previous stage expected date'));
            return NULL;
        }
        else if(current_total_sum != req_total_sum)
        {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'ERROR: Sum of Amount for Current schedule and Requested schedule must match.'));
          return NULL;
        }
        
        scudInformation.New_NPV__c = newNPV;
        scudInformation.Original_NPV__c = oldNPV;
        displaySubmit = true;
        return null;
    }

    public PageReference Submit() {
        upsert stagePaymentDetails;
        scudInformation.Booking_Information__c = BookingId;
        scudInformation.Requested_Amount_Total__c = req_total_sum;
        scudInformation.SCUD_Status__c = null;
        scudInformation.SI_Email__c = stagePaymentDetails[0].Booking_Information__r.Name_Of_Opportunity__r.Project_Name__r.Site_Incharge__r.Email;
        scudInformation.SM_Email__c = stagePaymentDetails[0].Booking_Information__r.Sales_Person__r.Email;
        scudInformation.Level_1_SI__c = stagePaymentDetails[0].Booking_Information__r.Name_Of_Opportunity__r.Project_Name__r.Site_Incharge__r.Id;
        scudInformation.Level_2_SS__c = stagePaymentDetails[0].Booking_Information__r.Name_Of_Opportunity__r.Project_Name__r.Sales_Strategist__r.Id;
        insert scudInformation;  
        
        String baseUrl = System.URL.getSalesforceBaseUrl().getHost().remove('-api' );
        baseUrl = 'https://' + baseUrl.substring(2,6) + 'salesforce.com';
   
        String scud_url = baseUrl  + '/'+ scudInformation.id;    
        scudInformation.Record_Link__c = scud_url;
        update scudInformation;
        if(stagePaymentDetails[0].Booking_Information__r.Sales_Person__r.Id != null) {
          Sm_id = stagePaymentDetails[0].Booking_Information__r.Sales_Person__r.Id;
        }
        else {
          Sm_id = stagePaymentDetails[0].Booking_Information__r.OwnerId;
        }       
        String mail_msg = 'Hi ' + stagePaymentDetails[0].Booking_Information__r.Sales_Person__r.Name + ',' + '<br/><br/> A SCUD case has been raised. Please click on below link to initiate approval process. <br/><br/>' + 'Link: ' + scud_url + '<br/><br/> Regards, <br/>' + 'Lodha Admin';
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setBccSender(false);
                    mail.setUseSignature(false);
                    mail.setTargetObjectId(Sm_id);
                    mail.setSubject('Initiate New SCUD Approval');                  
                    mail.setHtmlBody(mail_msg);
                    mail.setReplyTo('noreplay@LodhaGroup.com');
                    mail.setSenderDisplayName('Lodha Admin');
                    mail.setSaveAsActivity(false); 
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        return null;
    }
     
   
  @istest(seeAlldata=false)
  private static void testSpScudApprovalController(){
    
    SpTestInsertions spTestInsertions = new SpTestInsertions();

        Project_Name__c projectNameTest = spTestInsertions.createProjectName();
        insert projectNameTest; 
        
         Account accountTest = new Account(Preferred_Correspondence_Address__c = 'test_address', recordtypeid =Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId(), LastName ='Test Last Name',Mobile_Phone__c ='456872934', Occupation_acc__c = 'service');
        insert accountTest;
        
        Contact contactTest = [Select Id, 
                               Designation__c, 
                               Lead_Company_Name_cont__c From Contact Where AccountId = :accountTest.Id]; 
        contactTest.Designation__c = 'Test Designation';
        contactTest.Lead_Company_Name_cont__c = 'Test Company';
        Update contactTest;
        
       // Opportunity opp=new Opportunity(Name='Test Opportunity',recordtypeid =Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Residential').getRecordTypeId(),Account = accountTest ,CloseDate=System.now().date()+20,Project_Name__c = projectNameTest.id,StageName = 'Qualified',Servicing_Team__c='Presales',IsActive__c=true,Carpet_Area__c=100);
             
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
 
     Flat__c FlatTest = [select Id,Salable_Area__c from Flat__c Where Wing__c=:wingTest.Id limit 1]; 
      
        
       // Opportunity opportunityTest = new Opportunity(Name='Test Opportunity',recordtypeid =Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Residential').getRecordTypeId(),Account = accountTest,CloseDate=System.now().date()+20,Project_Name__c = projectNameTest.id,StageName = 'Qualified',Servicing_Team__c='Presales',IsActive__c=true);
        
        Opportunity opportunityTest=new Opportunity(Name='Test Opportunity',recordtypeid =Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Residential').getRecordTypeId(),Accountid = accountTest.Id ,CloseDate=System.now().date()+20,Project_Name__c = projectNameTest.id,StageName = 'Qualified',Servicing_Team__c='Presales',IsActive__c=true,Carpet_Area__c=100);
        
       insert opportunityTest; 
        
        Booking_Information__c bookingInformationTest= new Booking_Information__c(Name_Of_Opportunity__c=opportunityTest.id,Unique_booking_Id__c=FlatTest.id,Flat__c=FlatTest.id,Block_Detail__c='Test Block Details',Consideration_Actual_Rs__c=10000,Consideration_Rs__c=10000,Infrastructure_Incl_in_CV__c='Incl.in CV',Infrastructure2_Incl_in_CV__c='Incl.in CV',Club_Charges_Incl_in_CV__c='Incl.in CV',Infrastructure_Cost_Rs__c=100,Infrastructure_Cost_2_Rs__c=100,Club_Charges_Rs__c=100,Infrastructure_Cost_2Actual_Rs__c=100,Infrastructure_Cost_Actual_Rs__c=150,Club_charges_Actual_Rs__c=100,Base_Rate_Sq_ft_Actual_Rs__c=120,Floor_rise_Sq_ft_Actual_Rs__c=120,Premium_Sq_ft_Actual_Rs__c=120,Applicable_Waiver_Sq_ft_Actual_Rs__c=120,Total_Rate_Sq_ft_Actual_Rs__c=120,Flat_Cost_Actual_Rs__c=120,Applicable_Waiver_Sq_ft_Rs__c=100,Booking_Date__c=System.now().date(),Base_Rate_Sq_ft_Rs__c=1000, Total__c = 1000);
        insert bookingInformationTest;
        
        
        Stage_Payment_Details__c stagePaymentDetailsTest12 = new Stage_Payment_Details__c(Name='Stage Payment Details Test4',Booking_Information__c=bookingInformationTest.Id,Current_Date_Excepted__c=System.now().date()+1,Actual_Completion_Date__c = System.now().date(), Requested_Date_Expected__c=null,Payment_Slab__c=3,Requested_Amount__c=10000, Current_Amount__c = 10000);
        insert stagePaymentDetailsTest12;        
        Stage_Payment_Details__c stagePaymentDetailsTest13 = new Stage_Payment_Details__c(Name='Stage Payment Details Test5',Booking_Information__c=bookingInformationTest.Id,Current_Date_Excepted__c=System.now().date()+3,Actual_Completion_Date__c = System.now().date(), Requested_Date_Expected__c=null,Payment_Slab__c=3,Requested_Amount__c=10000, Current_Amount__c = 10000);
        insert stagePaymentDetailsTest13;
        Stage_Payment_Details__c stagePaymentDetailsTest14 = new Stage_Payment_Details__c(Name='Stage Payment Details Test6',Booking_Information__c=bookingInformationTest.Id,Current_Date_Excepted__c=System.now().date()+5,Actual_Completion_Date__c = NULL, Requested_Date_Expected__c=null,Payment_Slab__c=3,Requested_Amount__c=0, Current_Amount__c = 10000);
        insert stagePaymentDetailsTest14;
        Stage_Payment_Details__c stagePaymentDetailsTest15 = new Stage_Payment_Details__c(Name='Stage Payment Details Test7',Booking_Information__c=bookingInformationTest.Id,Current_Date_Excepted__c=System.now().date()+5,Actual_Completion_Date__c = NULL, Requested_Date_Expected__c=null,Payment_Slab__c=3,Requested_Amount__c=0, Current_Amount__c = 10000);
        insert stagePaymentDetailsTest15;
        
        PageReference ref3=new PageReference('/apex/TestSpScudApproval');
        Test.setCurrentPage(ref3);
        
        ref3.getParameters().put('bid',bookingInformationTest.id);
        
        SpScudApprovalController SpScudApprovalControllerTest3=new SpScudApprovalController();
      
        SpScudApprovalControllerTest3.CalculateNPV();
        SpScudApprovalControllerTest3.Submit();
        
        Booking_Information__c bookingInformationTest2= new Booking_Information__c(Name_Of_Opportunity__c=opportunityTest.id,Unique_booking_Id__c=FlatTest.id,Flat__c=FlatTest.id,Block_Detail__c='Test Block Details',Consideration_Actual_Rs__c=10000,Consideration_Rs__c=10000,Infrastructure_Incl_in_CV__c='Incl.in CV',Infrastructure2_Incl_in_CV__c='Incl.in CV',Club_Charges_Incl_in_CV__c='Incl.in CV',Infrastructure_Cost_Rs__c=100,Infrastructure_Cost_2_Rs__c=100,Club_Charges_Rs__c=100,Infrastructure_Cost_2Actual_Rs__c=100,Infrastructure_Cost_Actual_Rs__c=150,Club_charges_Actual_Rs__c=100,Base_Rate_Sq_ft_Actual_Rs__c=120,Floor_rise_Sq_ft_Actual_Rs__c=120,Premium_Sq_ft_Actual_Rs__c=120,Applicable_Waiver_Sq_ft_Actual_Rs__c=120,Total_Rate_Sq_ft_Actual_Rs__c=120,Flat_Cost_Actual_Rs__c=120,Applicable_Waiver_Sq_ft_Rs__c=100,Booking_Date__c=System.now().date(),Base_Rate_Sq_ft_Rs__c=1000, Total__c = 1000);
        insert bookingInformationTest2;
        
        
        Stage_Payment_Details__c stagePaymentDetailsTest6 = new Stage_Payment_Details__c(Name='Stage Payment Details Test4',Booking_Information__c=bookingInformationTest2.Id,Current_Date_Excepted__c=System.now().date()+1,Actual_Completion_Date__c = System.now().date(), Requested_Date_Expected__c=null,Payment_Slab__c=3,Requested_Amount__c=10000, Current_Amount__c = 2);
        insert stagePaymentDetailsTest6;        
        Stage_Payment_Details__c stagePaymentDetailsTest7 = new Stage_Payment_Details__c(Name='Stage Payment Details Test5',Booking_Information__c=bookingInformationTest2.Id,Current_Date_Excepted__c=System.now().date()+3,Actual_Completion_Date__c = System.now().date(), Requested_Date_Expected__c=null,Payment_Slab__c=3,Requested_Amount__c=10000, Current_Amount__c = 2);
        insert stagePaymentDetailsTest7;
        Stage_Payment_Details__c stagePaymentDetailsTest8 = new Stage_Payment_Details__c(Name='Stage Payment Details Test6',Booking_Information__c=bookingInformationTest2.Id,Current_Date_Excepted__c=System.now().date()+5,Actual_Completion_Date__c = NULL, Requested_Date_Expected__c=null,Payment_Slab__c=3,Requested_Amount__c=0, Current_Amount__c = 10000);
        insert stagePaymentDetailsTest8;
        Stage_Payment_Details__c stagePaymentDetailsTest9 = new Stage_Payment_Details__c(Name='Stage Payment Details Test7',Booking_Information__c=bookingInformationTest2.Id,Current_Date_Excepted__c=System.now().date()+5,Actual_Completion_Date__c = NULL, Requested_Date_Expected__c=null,Payment_Slab__c=3,Requested_Amount__c=0, Current_Amount__c = 10000);
        insert stagePaymentDetailsTest9;
        
        PageReference ref4=new PageReference('/apex/TestSpScudApproval');
        Test.setCurrentPage(ref4);
        
        ref4.getParameters().put('bid',bookingInformationTest2.id);
        
        SpScudApprovalController SpScudApprovalControllerTest4=new SpScudApprovalController();
      
        SpScudApprovalControllerTest4.CalculateNPV();
        SpScudApprovalControllerTest4.Submit();
        
        
        
    
    } 
}