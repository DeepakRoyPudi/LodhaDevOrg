public class SpGetInventoryChart {
    final List<Wing__c> wingList = new List<Wing__C>();
    List<Flat__c> flatList = new List<Flat__C>();
    set<Id> wingIdSet = new set<Id>();
    Map<Double, Flat__c> flatDetail = null;
    //Map<Integer, Map<Decimal, Flat__c>> floorWise = new Map<Integer, Map<Decimal, Flat__c>>();
    public Double flatsPerFloor = null;
    public Double floorPerWing = null;
    public List<String> columnValue {get; set;}
    public List<String> fieldValue {get; set;}
    public List<String> dataValue {get; set;}
    public Double flatperfloorcount {get; set;}
    public String cluster_name{get; set;}
    public String wing_name{get; set;}
    List<Flat__c> flatSet = null;
    public String podium_unit{get; set;}
    
    public SpGetInventoryChart(ApexPages.StandardController controller) {
        System.debug('wing details ' + controller.getRecord());
        this.wingList.add((Wing__C)controller.getRecord());
        if(null == this.wingList[0]) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Record Id missing');
        }
        System.debug('wing details list ' + wingList);
    }
    
    public PageReference goBack(){
    PageReference redirect = new ApexPages.StandardController(wingList[0]).view();
      redirect.setRedirect(true);
      return redirect;
    }
    public void getInventory(){
        //Identify wing
        getWingIds();
        columnValue=new List<String>();
        fieldValue=new List<String>();
        dataValue=new List<String>();
        flatperfloorcount = 0;
        //Scan through individual wings
        for(Id wing:wingIdSet){
            
            system.debug('Individual Wing ID: '+wing);
            //Get floors, flats/floor in a wing.
            getWingDetails(wing);
            //Generate column values based on flats/floor
            columnValue.add(generateJSONColumnValue());
            
            //Generate Field Values based on flats/floor
            fieldValue.add(generateJSONFieldValue());
            
            //Generate Data Values based on flat object, field value
            dataValue.add(generateJSONDataValue(wing));           
        }        
    }
    
    set<Id> getWingIds(){
        for(Wing__c w: [select id, Name, Cluster__r.Name from Wing__c where Id =:wingList]){
            wingIdSet.add(w.Id);
            cluster_name = w.Cluster__r.Name;
            wing_name = w.Name; 
        }
        return wingIdSet;        
     }
     
     private void getWingDetails(Id wingId){
        Wing__c wingTemp = [select No_of_Floors__c, Podium_Unit__c, Floor_Completed__c, No_of_flats_floor__c from Wing__c  where id =:wingId ];
        
        //Get Flats/Floor in Wing
        flatsPerFloor=wingTemp.No_of_flats_floor__c;
        flatperfloorcount = flatsPerFloor;
        //Get Floors in Wing
        floorPerWing=wingTemp.No_of_Floors__c;
        podium_unit = wingTemp.Podium_Unit__c;
     }
     
     
     private String generateJSONColumnValue(){
        String colVal=null;
        if(flatsPerFloor!=null && floorPerWing!=null){
             colVal='[';
            for(Integer i=1;i<=(flatsPerFloor+1);i++){
                
                if(i==1){
                    colVal=colVal+'{header: \'            \', dataIndex:\'Floor\'},';
                } else if(i==(flatsPerFloor+1)){
                    colVal=colVal+'{header: \'Flat'+(i-1)+'\''+', dataIndex:\'FLAT'+(i-1)+'\' , renderer: function (value, meta, record) {var v = record.get(\'FLAT'+(i-1)+'\'); if (v.length>12) { v = v.substring((v.lastIndexOf(\':\')+6),(v.lastIndexOf(\'<\')-7));}if(v.length>0){if(v==\'OPEN\'){meta.tdCls=\'flat-open\';} else if (v==\'ALL\'){meta.tdCls=\'flat-all\';} else if (v==\'BLOCKED\'){meta.tdCls=\'flat-blocked\';} else if (v==\'HOLD\'){meta.tdCls=\'flat-hold\';} else if (v==\'BOOKING\'){meta.tdCls=\'flat-booking\';} else if (v==\'CANCELLATION\'){meta.tdCls=\'flat-cancellation\';} else if (v==\'NOT AVAILABLE\'){meta.tdCls=\'flat-not-available\';} else if (v==\'SCUD\'){meta.tdCls=\'flat-scud\';} else if (v==\'SCUD REJECT\'){meta.tdCls=\'flat-scud-reject\';} else if (v==\'FAME RETURN\'){meta.tdCls=\'flat-fame-return\';}  else if (v==\'SOLD\'){meta.tdCls=\'flat-sold\';} else {meta.tdCls=\'status-unknown\';}}return value;}}';
                } else {
                    colVal=colVal+'{header: \'Flat'+(i-1)+'\''+', dataIndex:\'FLAT'+(i-1)+'\' ,renderer: function (value, meta, record) {var v = record.get(\'FLAT'+(i-1)+'\'); if (v.length>12) { v = v.substring((v.lastIndexOf(\':\')+6),(v.lastIndexOf(\'<\')-7));;}if(v.length>0){if(v==\'OPEN\'){meta.tdCls=\'flat-open\';} else if (v==\'ALL\'){meta.tdCls=\'flat-all\';} else if (v==\'BLOCKED\'){meta.tdCls=\'flat-blocked\';} else if (v==\'HOLD\'){meta.tdCls=\'flat-hold\';} else if (v==\'BOOKING\'){meta.tdCls=\'flat-booking\';} else if (v==\'CANCELLATION\'){meta.tdCls=\'flat-cancellation\';} else if (v==\'NOT AVAILABLE\'){meta.tdCls=\'flat-not-available\';} else if (v==\'SCUD\'){meta.tdCls=\'flat-scud\';} else if (v==\'SCUD REJECT\'){meta.tdCls=\'flat-scud-reject\';} else if (v==\'FAME RETURN\'){meta.tdCls=\'flat-fame-return\';}  else if (v==\'SOLD\'){meta.tdCls=\'flat-sold\';} else {meta.tdCls=\'status-unknown\';}}return value;}},';
                }
            }
            colVal=colVal+']';
        }
        system.debug('Value for Col:'+colVal);                  
        return colVal;
     }
     
     
     private String generateJSONFieldValue(){
        String fldVal='[\'Floor\',';
        if(flatsPerFloor!=null && floorPerWing!=null){
            for(Integer i=1;i<=flatsPerFloor;i++){
                if(i==1 && flatsPerFloor==1){
                    fldVal=fldVal+'\'FLAT'+i+'\']';
                } else if(i==1){
                    fldVal=fldVal+'\'FLAT'+i+'\',';
                } else if(i==flatsPerFloor){
                    fldVal=fldVal+'\'FLAT'+i+'\']';
                } else {
                    fldVal=fldVal+'\'FLAT'+i+'\',';
                }                   
            }
        }
        system.debug('Field Values are: '+fldVal);                   
        return fldVal;
     }
     
     private String generateJSONDataValue(Id wingId){
        String datVal=null;
        Integer start;
        List<Flat__c> tempF = null;
        Flat__c Tmpflat = null;
        Map<Integer,List<Flat__c>> floorFlatMap = new Map<Integer, List<Flat__c>>();
        
        flatList =[Select Flat_Type_Text__c, Wing__c, View__c, Total_Rate_Sq_Ft_Rs__c, Token_Amount_Rs__c, SystemModstamp,
                   Status__c, Stage_Completed__c, Salable_Area__c, Premium_Sq_Ft_Rs__c, Name, Message__c,
                   LastModifiedDate, LastModifiedById, LastActivityDate, IsDeleted, Infrastructure_Incl_in_CV__c,
                   Infrastructure_Cost_Rs__c, Infrastructure_Cost2_Rs__c, Infrastructure2_Incl_in_CV__c, Id,
                   Floor__c, Floor_Rise_Sq_Ft_Rs__c, Flat_Type__c, Flat_No__c, Flat_Cost_Rs__c,
                   DAM_Offer_Sq_Ft_Rs__c, CurrencyIsoCode, CreatedDate, CreatedById, Consideration_Rs__c,
                   Club_Charges_Rs__c, Club_Charges_Incl_in_CV__c, Carpet_Area__c, Base_Rate_Sq_Ft_Rs__c,
                   Applicable_Waiver_Sq_Ft_Rs__c, Amount_Due_Rs__c From Flat__c where wing__c =:wingId Order By Flat_No__c ];
                   
        system.debug('flatList from query is:'+flatList);
                
        for(Flat__c f:flatList){
            system.debug('Itterating over all flats'+f);
            if(floorFlatMap.containsKey(Integer.valueOf(f.Floor__c))){
                system.debug('Floor was already in map.');
                floorFlatMap.get(Integer.valueOf(f.Floor__c)).add(f);               
            }
            else{
                system.debug('This floor was not in map..'+f.Floor__c);
                tempF = new List<Flat__c>();
                tempF.add(f);
                floorFlatMap.put(Integer.valueOf(f.Floor__c), tempF);               
            }               
        }
        
        //Start with dataValue and std items
        datVal = '{\'items\':[';       
        
        //Check if floor per wing is not empty.
        if(floorPerWing>0 && floorFlatMap!=null && floorFlatMap.size()>0){
             if(podium_unit == 'Yes') {
               start = 0;
             }
             else {
               start = 1;
             }
            // system.debug('######'+floorFlatMap);
            //Itterating floor wise
            for(Integer i=start; i<=floorPerWing; i++){
                //Get all flats in floor
                system.debug('Getting records for floor:'+i);               
                flatSet = floorFlatMap.get(i);
                system.debug('Successfully fetched records for floor:'+i);
            //  system.debug('&&&&&'+flatSet );
                //Itterate over all flats in the floor
                for(Integer j=0;j<=flatSet.size();j++){
                    if(j==0){
                        //Print {"floor":"Floor(i-1)",
                        datVal=datVal+'{"Floor":'+'"Floor'+i+'",';
                    } 
                    else {
                        //Print "FLAT(j+1)":"flatSet.get(j)"
                        Tmpflat = flatSet.get(j-1);
                        String hovertip = 'Flat No: ' + Tmpflat.Flat_No__c  + '&#013;Flat Type: ' + Tmpflat.Flat_Type_Text__c +  '&#013;Salable Area: ' + Tmpflat.Salable_Area__c + '&#013;Carpet Area: ' + Tmpflat.Carpet_Area__c + '&#013;Consideration value: ' + Tmpflat.Consideration_Rs__c + '&#013;View: ' + Tmpflat.View__c + '&#013;Status: ' + Tmpflat.Status__c;
                        
                        //String test = HTMLENCODE(hovertip);
                        datVal=datVal+'"FLAT'+j+'":"'+'<a href=\'/'+Tmpflat.ID+'\' title=' + '\'' + hovertip + '\'>' +Tmpflat.Flat_No__c+'<span style= display:none>'+ Tmpflat.Status__c +'</span></a>'+'"';
                        if(j == flatSet.size()){
                            //Print ,
                            datVal=datVal+'}';
                        } else {
                            //Print }
                            datVal=datVal+',';
                        }
                    }
                    system.debug('Flat loop'+j);                                       
                }               
                
                //Clearing flatList for next floor.
                flatSet.clear();
                
                //Between floor to print ,
                if(i<floorPerWing){
                    //Print ,
                    datVal=datVal+',';
                }
            system.debug('Floor loop'+i);    
            }
        } else {
            system.debug('Floor per wing is wrong..');
        }
        
        
        
        //End of dataValue
        datVal = datVal+']}';
        system.debug('Data Values for JSON is:'+datVal);
        return datVal;
     }
     
     
     
//updated by Apurva Patel and Paragi Shah.

static testMethod void spGetInventoryChartTest(){

    Project_Name__c projectNameTest = new Project_Name__c(Name='Test Project Name',CRN_INIT__c='LBV',Project_Type__c = 'Test Casa',Record_Type__c='Test Residential');
    insert projectNameTest;    
    
    Cluster__c clusterTest = new Cluster__c(Name='Test Cluster',Project_Name__c = projectNameTest.Id);
    insert clusterTest;
       
    Wing__c wingTest = new Wing__c(Name='Test Wing',Cluster__c=clusterTest.Id,No_of_Floors__c=10,No_of_flats_floor__c=2);
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
    
    PageReference ref = new PageReference('/apex/testspGetInventoryChart');
    Test.setCurrentPage(ref);
    ApexPages.StandardController stc1 = new ApexPages.StandardController(wingTest);    
    SpGetInventoryChart spGetInventoryCharttest = new SpGetInventoryChart(stc1); 
    
    System.assert(ApexPages.getMessages().size() == 0); 
    
    spGetInventoryCharttest.getInventory();
    spGetInventoryCharttest.goBack();    
}   
  
       
}