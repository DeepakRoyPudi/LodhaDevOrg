public class SpAssignStageController {
    
    public List<Stage_Details__c> stgDetListsample {get; set;}
     
    public List<selectOption> getProjectsSelectionList{get;set;}
    public List<selectOption> getClusterSelectionList{get;set;}
    public List<selectOption> getWingsSelectionList{get;set;}
    public List<selectOption> getStageSelectionList{get;set;}
   
    public Id selectedProjID{get;set;}
    public Id selectedclsuterID{get;set;}
    public Id selectedwingID{get;set;}
    public List<Wing__c> winglist;
    public Integer selectedStageID{get;set;}
    public boolean display_stge_table{get;set;}
    public boolean slab_total_ok{get;set;}

    
    public SpAssignStageController () {
      display_stge_table = false;
      selectedProjID=null;
      selectedclsuterID=null;
      selectedwingID=null;
      selectedStageID=null;
      slab_total_ok = TRUE;
    }

    public PageReference updateList() {
      return null;
    }
    
    public PageReference resetAssignStage() {
      selectedProjID=null;
      selectedclsuterID=null;
      selectedwingID=null;
      selectedStageID=null;
      display_stge_table = false;
      return null;
    }
    
    Public PageReference showStageDetails(){
        stgDetListsample = new List<Stage_Details__c>();
        if(selectedStageID==0) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Enter No. of Stages more than "ZERO"'));
            return null;
        }
        integer i;
        Stage_Details__c stgDet;
       
        for(i=1; i<=selectedStageID; i++){
            stgDet = new Stage_Details__c(Name='Stage '+i, Slab__c=null, Description__c='', Expected_Completion_Date__c = null);
            stgDetListsample.add(stgDet);
        }
        display_stge_table = true;
    return null;
    }
    
   /* public void generateBookingStageDetails(Id selectedwingID){
      Booking_Stage_Details__c booking_stgDet;
      List<Booking_Stage_Details__c> tmp_stgDetList = new List<Booking_Stage_Details__c>();
      List<Booking_Stage_Details__c> booking_stgDetList = new List<Booking_Stage_Details__c>();
      
      tmp_stgDetList = [select Id, Name, Wing__c from Booking_Stage_Details__c where Wing__c =: selectedwingID];
      
      delete tmp_stgDetList;
      
      
                             
      for(Stage_Details__c s:stgDetListsample){
        booking_stgDet = new Booking_Stage_Details__c (Name='Booking stage', Booking_Slab__c=0, Wing__c=selectedwingID,Stage__c=null,
                                        Booking_Description__c=' ');
        booking_stgDetList.add(booking_stgDet);
      }
      try {
        upsert booking_stgDetList Id;
      }
      catch(DMLException e){
         System.Debug('Booking Stage detail Insert Failed:' + e.getMessage());
      } 
    }*/
    
    //check percentage
    public decimal getpercentage() {
      decimal sum = 0;
      for(Stage_Details__c s: stgDetListsample)  {
        sum = sum  + s.Slab__c;
      }            
      return sum;     
    }
    
    public PageReference checkpercentage() {
     
      decimal sum = getpercentage();    
      
      if(sum != 100){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Total Slab percentage should be 100. Current total slab% is ' + sum  ));
      }
      else{
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Total Slab percentage equal to 100. Current total slab% is ' + sum  ));
      }
      return null;
    }
    
     public PageReference assignStage() { 
        boolean success = TRUE;
        String fail_msg;
        if(selectedclsuterID==NULL || selectedProjID==NULL ) {
          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Fields marked with * are mandatory'));
          return null;
        }
        decimal sum = getpercentage();
        if(sum != 100) {
          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Current total slab% is ' + sum + '.' + ' Please correct total slab%.'));
          return null;
        }
        
        List<Stage_Details__c> StageDetailsMap = new List<Stage_Details__c>();
        if(selectedwingID == null){
            set<Id> wingSet = new set<Id>();
            for(wing__c w: winglist)
            {
                wingSet.add(w.Id);
                for(Stage_Details__c s: stgDetListsample)
                {
                    Stage_Details__c StageDetails = new Stage_Details__c();
                    StageDetails.Wing__c = w.Id;
                    StageDetails.Name = s.Name;
                    StageDetails.Slab__c = s.Slab__c;
                    StageDetails.Description__c = s.Description__c;
                    StageDetailsMap.add(StageDetails);
                    if(s.Description__c == '') {
                      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Description is mandatory to Save Stage Details.'));
                      return null;
                    }
                }
            }
            
            List<Stage_Details__c> stageDetailsLst = [Select Id From Stage_Details__c Where Wing__c in : wingSet];
            delete stageDetailsLst;
            try {
              insert StageDetailsMap;  
              success  = TRUE;   
            }
            
            catch(Exception e){
              success  = FALSE;
              String validation_error_msg_1 = 'FIELD_CUSTOM_VALIDATION_EXCEPTION';  
              String exception_error = e.getMessage();
              fail_msg = exception_error;
              if(exception_error.contains(validation_error_msg_1)) {
                success  = FALSE;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Slab % cannot be more than 100.'));
              }
            }
       }
       else{
            for(Stage_Details__c s: stgDetListsample)
            {
                Stage_Details__c StageDetails = new Stage_Details__c();
                StageDetails.Wing__c = selectedwingID;
                StageDetails.Name = s.Name;
                StageDetails.Slab__c = s.Slab__c;
                StageDetails.Description__c = s.Description__c;
                StageDetailsMap.add(StageDetails);
                if(s.Description__c == '') {
                  ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Description is mandatory to Save Stage Details'));
                  return null;
                }
            }
            List<Stage_Details__c> stageDetailsLst = [Select Id From Stage_Details__c Where Wing__c = :selectedwingID];
            delete stageDetailsLst;
            try {
              insert StageDetailsMap;
              success  = TRUE;
            }
            catch(Exception e){
              success  = FALSE;
              String validation_error_msg_1 = 'FIELD_CUSTOM_VALIDATION_EXCEPTION'; 
              String exception_error = e.getMessage(); 
              fail_msg = exception_error;
              if(exception_error.contains(validation_error_msg_1)) {
                success  = FALSE;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Slab % cannot be more than 100'));
              }
            }
       }
       
       if(success) {
         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Stages has been assigned to selected wings.'));
       }
       else {
         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Stage assignment failed due to '+ fail_msg ));
       }
       return null;
    }
    
    public List<selectOption> getProjectsSelectionList() {
      List<selectOption> ProjOptions = new List<selectOption>();
       //new list for holding all of the picklist options
      ProjOptions.add(new selectOption('', 'Select')); 
      //add the first option of '- None -' in case the user doesn't
      // want to select a value or in case no values are
      // returned from query below
      for (Project_Name__c proj: ([select ID, Name from Project_Name__c Order By Name])) { 
        //query for Account records 
        ProjOptions.add(new selectOption(proj.Id, proj.Name)); 
        //for all records found - add them to the picklist options
      }
      return ProjOptions; 
      //return the picklist options
    }


    public List<selectOption> getClusterSelectionList() {
      List<selectOption> Options = new List<selectOption>();
       //new list for holding all of the picklist options
      Options.add(new selectOption('', 'Select')); 
      //add the first option of '- None -' in case the user doesn't
      // want to select a value or in case no values are
      // returned from query below
      for (Cluster__c c: ([select ID,Name from Cluster__c Where Project_Name__r.Id =: selectedProjID Order By Name])) { 
        //query for Account records 
        Options.add(new selectOption(c.Id, c.Name)); 
        //for all records found - add them to the picklist options
      }
      return Options; //return the picklist options
    }

    public List<selectOption> getWingsSelectionList() {
      List<selectOption> Options = new List<selectOption>();
       //new list for holding all of the picklist options
      Options.add(new selectOption('', 'Select')); 
      //add the first option of '- None -' in case the user doesn't
      // want to select a value or in case no values are
      // returned from query below
      winglist = [select ID,Name from Wing__c Where Cluster__r.Id =: selectedclsuterID];
      for (Wing__c w: winglist) { 
        //query for Account records 
        Options.add(new selectOption(w.Id, w.Name)); 
        //for all records found - add them to the picklist options
      }
      return Options; 
      //return the picklist options
    }
    
    
    

    
//updated by Apurva Patel.  
    static testMethod void testSpAssignStageController(){
        
        SpTestInsertions spTestInsertions = new SpTestInsertions();
        
        Project_Name__c projectNameTest = spTestInsertions.createProjectName();
        insert projectNameTest;    
    
        Cluster__c clusterTest = spTestInsertions.createCluster(projectNameTest);
        insert clusterTest;
    
        //Stage__c stageTest = spTestInsertions.createStage();
        //insert stageTest;
    
        Wing__c wingTest = spTestInsertions.createWing(clusterTest);
        insert wingTest;
        
       
        
        SpAssignStageController spAssignStageControllerTest = new SpAssignStageController();
        
        
        
        //Test scenario to check when all the selected values are null.
        spAssignStageControllerTest.updateList();
        spAssignStageControllerTest.resetAssignStage();
        spAssignStageControllerTest.showStageDetails();
        spAssignStageControllerTest.assignStage();
        //spAssignStageControllerTest.generateBookingStageDetails(wingTest.Id);   
        
        System.assert(ApexPages.getMessages().get(0).getDetail() == 'Fields marked with * are mandatory');
        
    
      
        
        //Test scenario to check when selectedWingId is null and Description is not blank.
        
        SpAssignStageController spAssignStageControllerTest1 = new SpAssignStageController();
        
        spAssignStageControllerTest1.selectedProjID = projectNameTest.Id;
        spAssignStageControllerTest1.selectedclsuterID = clusterTest.Id;
        spAssignStageControllerTest1.getWingsSelectionList();
        spAssignStageControllerTest1.selectedwingID = null;
        spAssignStageControllerTest1.selectedStageID = 3;
        spAssignStageControllerTest1.showStageDetails();
       
        
         for(Stage_Details__c s :spAssignStageControllerTest1.stgDetListsample){          
            s.Description__c = 'Testing Desc';
            s.Slab__c = 0;
         }
        
        spAssignStageControllerTest1.assignStage();
        //spAssignStageControllerTest1.generateBookingStageDetails(wingTest.Id);
        spAssignStageControllerTest1.resetAssignStage();
       
        
        
         //Test scenario to check when selectedWingId is null and Description is blank.
        
        SpAssignStageController spAssignStageControllerTest4 = new SpAssignStageController();
        
        spAssignStageControllerTest4.selectedProjID = projectNameTest.Id;
        spAssignStageControllerTest4.selectedclsuterID = clusterTest.Id;
        spAssignStageControllerTest4.getWingsSelectionList();
        spAssignStageControllerTest4.selectedwingID = null;
        spAssignStageControllerTest4.selectedStageID = 3;
        spAssignStageControllerTest4.showStageDetails();
        for(Stage_Details__c s :spAssignStageControllerTest4.stgDetListsample){          
          //  s.Description__c = 'Testing Desc';
            s.Slab__c = 120;
         }
        spAssignStageControllerTest4.assignStage();
        //spAssignStageControllerTest4.generateBookingStageDetails(wingTest.Id);
        spAssignStageControllerTest4.resetAssignStage();
        
      
        //Test scenario to check when selectedStageID is 0
        
        SpAssignStageController spAssignStageControllerTest2 = new SpAssignStageController();
        spAssignStageControllerTest2.getProjectsSelectionList();
        spAssignStageControllerTest2.selectedProjID = projectNameTest.Id;
        spAssignStageControllerTest2.getClusterSelectionList();
        spAssignStageControllerTest2.selectedclsuterID = clusterTest.Id;
        spAssignStageControllerTest2.getWingsSelectionList();
        spAssignStageControllerTest2.selectedwingID = wingTest.Id;
        spAssignStageControllerTest2.selectedStageID = 0;
       
        spAssignStageControllerTest2.updateList();
        
        spAssignStageControllerTest2.showStageDetails();
        
        spAssignStageControllerTest2.resetAssignStage();
        
        //Test scenario to check when all the selected Ids are present.
           
       SpAssignStageController spAssignStageControllerTest3 = new SpAssignStageController();
        
       spAssignStageControllerTest3.getProjectsSelectionList();
       spAssignStageControllerTest3.selectedProjID = projectNameTest.Id;
       spAssignStageControllerTest3.getClusterSelectionList();
       spAssignStageControllerTest3.selectedclsuterID = clusterTest.Id;
       spAssignStageControllerTest3.getWingsSelectionList();
       spAssignStageControllerTest3.selectedwingID = wingTest.Id;
       spAssignStageControllerTest3.selectedStageID = 2;
       spAssignStageControllerTest3.updateList();
       spAssignStageControllerTest3.showStageDetails();
         
        for(Stage_Details__c s :spAssignStageControllerTest3.stgDetListsample){
            
            s.Description__c = 'Testing Desc';
            s.Slab__c = 50;
        }
        spAssignStageControllerTest3.getpercentage();
        spAssignStageControllerTest3.checkpercentage();
        spAssignStageControllerTest3.assignStage();
         
        //spAssignStageControllerTest3.generateBookingStageDetails(wingTest.Id);   
        spAssignStageControllerTest3.resetAssignStage();
       
       
       ////Test scenario to check when all the selected Ids are present and description is blank.
        
       SpAssignStageController spAssignStageControllerTest5 = new SpAssignStageController();
        
       spAssignStageControllerTest5.getProjectsSelectionList();
       spAssignStageControllerTest5.selectedProjID = projectNameTest.Id;
       spAssignStageControllerTest5.getClusterSelectionList();
       spAssignStageControllerTest5.selectedclsuterID = clusterTest.Id;
       spAssignStageControllerTest5.getWingsSelectionList();
       spAssignStageControllerTest5.selectedwingID = wingTest.Id;
       spAssignStageControllerTest5.selectedStageID = 2;
       spAssignStageControllerTest5.updateList();
       spAssignStageControllerTest5.showStageDetails();
       for(Stage_Details__c s :spAssignStageControllerTest5.stgDetListsample){          
            //s.Description__c = 'Testing Desc';
            s.Slab__c = 50;
         }
       spAssignStageControllerTest5.assignStage();
       //spAssignStageControllerTest5.generateBookingStageDetails(wingTest.Id);   
       spAssignStageControllerTest5.resetAssignStage();
       
       //selectd wing id null
       SpAssignStageController spAssignStageControllerTest6 = new SpAssignStageController();
        
       spAssignStageControllerTest6.getProjectsSelectionList();
       spAssignStageControllerTest6.selectedProjID = projectNameTest.Id;
       spAssignStageControllerTest6.getClusterSelectionList();
       spAssignStageControllerTest6.selectedclsuterID = clusterTest.Id;
       spAssignStageControllerTest6.getWingsSelectionList();
       spAssignStageControllerTest6.selectedwingID = null;
       spAssignStageControllerTest6.selectedStageID = 2;
       spAssignStageControllerTest6.updateList();
       spAssignStageControllerTest6.showStageDetails();
       for(Stage_Details__c s :spAssignStageControllerTest6.stgDetListsample){          
            s.Description__c = 'Testing Desc';
            s.Slab__c = 50;
         }
       spAssignStageControllerTest6.assignStage();
       //spAssignStageControllerTest5.generateBookingStageDetails(wingTest.Id);   
       spAssignStageControllerTest6.resetAssignStage();
       
       //slab % more than 100
       SpAssignStageController spAssignStageControllerTest7 = new SpAssignStageController();
        
       spAssignStageControllerTest7.getProjectsSelectionList();
       spAssignStageControllerTest7.selectedProjID = projectNameTest.Id;
       spAssignStageControllerTest7.getClusterSelectionList();
       spAssignStageControllerTest7.selectedclsuterID = clusterTest.Id;
       spAssignStageControllerTest7.getWingsSelectionList();
       spAssignStageControllerTest7.selectedwingID = null;
       spAssignStageControllerTest7.selectedStageID = 4;
       spAssignStageControllerTest7.updateList();
       spAssignStageControllerTest7.showStageDetails();
       for(Stage_Details__c s :spAssignStageControllerTest7.stgDetListsample){          
            s.Description__c = 'Testing Desc';
            s.Slab__c = 100;
         }
       spAssignStageControllerTest7.assignStage();
       //spAssignStageControllerTest5.generateBookingStageDetails(wingTest.Id);   
       spAssignStageControllerTest7.resetAssignStage();
     
     
      
        
    }
    

 
}