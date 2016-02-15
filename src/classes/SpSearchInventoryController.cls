public class SpSearchInventoryController{

    public transient  List<String> columnValue {get; set;}
    public transient  List<String> fieldValue {get; set;}
    public transient  List<String> dataValue {get; set;}
    public transient  List<Decimal> flatperfloorcount {get; set;}
    public transient  List<String> wingclusterlist{get; set;}
    public String prjNam {get; set;}
    public String role_name{get; set;}
    public String role_id{get; set;}
    //transient Set<String> SearchResult;
    //transient Set<Id> WingSearchResult;
    Set<String> SearchResult;
    Set<Id> WingSearchResult;
    public transient List<String> wing_det_string{get; set;}
    //transient set<Id> selected_wing_id = new set<Id>();
    set<Id> selected_wing_id = new set<Id>();
    
    public PageReference doSearch() {
        wing_det_string = new List<String>();
        String refQuery=null;
        tmpWingIds = new List<Wing__c>();
        wingIds = new List<Wing__c>();
        Boolean whereClause = true;
        columnValue=new List<String>();
        fieldValue=new List<String>();
        dataValue=new List<String>();
        wingclusterlist=new List<String>();
        prjNam = null;
        flatperfloorcount  = new List<Decimal>();
        Flat__c tmpFlat1 = new Flat__c();
        Flat__c tmpFlat2 = new Flat__c();
        SearchResult = new Set<String>();
        WingSearchResult = new Set<Id>();
        
        if(selectedProjID!=null){ 
            SpAccessController spaccess = new SpAccessController(); 
            access_value = spaccess.getHoverAccessDetails(role_name, selectedProjID);       
           
           
            //Getting all search parameters mapping
            prjNam=[Select Id, Name From Project_Name__c where Id=:selectedProjID].Name;
            
            refQuery='select  Proposed_Completion__c,Project__c,Podium_Unit__c,No_of_flats_floor__c,No_of_Floors__c,No_of_4_wheeler_parking__c,Name,Id,Hold__c,Floor_Completed__c,CurrencyIsoCode,Company__c,Cluster__c, Cluster__r.Name,Max_Block_Days__c,(Select Id,Name,Wing__c,Flat_Type_Text__c,Status__c,View__c,Stage_Completed__c,Amount_Due_Rs__c,Token_Amount_Rs__c,Base_Rate_Sq_Ft_Rs__c,Floor_Rise_Sq_Ft_Rs__c,Premium_Sq_Ft_Rs__c,Applicable_Waiver_Sq_Ft_Rs__c,DAM_Offer_Sq_Ft_Rs__c,Total_Rate_Sq_Ft_Rs__c,Flat_Cost_Rs__c,Infrastructure_Cost_Rs__c,Infrastructure_Cost2_Rs__c,Club_Charges_Rs__c,Consideration_Rs__c,Infrastructure_Incl_in_CV__c,Infrastructure2_Incl_in_CV__c,Club_Charges_Incl_in_CV__c,Flat_Type__c, Actual_Consideration__c, Carpet_Area__c,Salable_Area__c,Floor__c,Flat_No__c, Flat_no_text__c From Flats__r';
            
                                
            refQuery = refQuery+' ORDER BY Flat_No__c ASC) From Wing__c where Project__c=\''+prjNam+'\'';
            
            if(selectedclsuterID!=null){
                 refQuery=refQuery+' and Cluster__c = \''+selectedclsuterID+'\'';
            }
            
            if(selectedwingID!=null){
                 refQuery=refQuery+' and Id = \''+selectedwingID+'\'';
            }
            
            refQuery = refQuery + 'ORDER BY Name';
            
            //All flats within wing.
            wingIds=Database.query(refQuery);
            
            system.debug('Wing details: '+wingIds);
        
            for(Wing__c wing:wingIds){
              
                for(Flat__c flat:wing.Flats__r){
                    boolean FlatType = True, FlatStatus = True, FlatView = True, FlatNo = True, FlatConsideration = True, FloorNo = True;

                    if(flat.Flat_Type__c != selectedflattypeID && selectedflattypeID != NULL)
                    {
                        FlatType = False;
                    }
                    
                    if(selectedflatstatus != NULL && selectedflatstatus != 'ALL' && flat.Status__c != selectedflatstatus )
                    {
                        FlatStatus = False;
                    }

                    
                    if(selectedviewvalue != NULL && flat.View__c != selectedviewvalue)
                    {
                        FlatView = False;
                    }
                    
                    if(flat_no != NULL && flat_no != '' && flat.Flat_No__c != Integer.valueOf(flat_no))
                    {
                        FlatNo = False;
                    }

                    if(floor_no_from != 0 && floor_no_to != 0 && (flat.Floor__c < floor_no_from || flat.Floor__c > floor_no_to))
                    {
                        FloorNo = False;
                    }
                    if(value_from != 0 || value_to != 0 && (flat.Consideration_Rs__c < value_from || flat.Consideration_Rs__c > value_to))
                    {
                        FlatConsideration = False;
                    }
                    
                    system.debug( 'Status -->' + 'FlatType:' + FlatType + ' FlatStatus:' + FlatStatus + ' FlatView:' + FlatView + ' FlatNo:' + FlatNo + ' FlatConsideration:' + FlatConsideration + ' FloorNo:' + FloorNo);
                    if(FlatType && FlatStatus && FlatView && FlatNo && FlatConsideration && FloorNo)
                    {   
                        if(selectedflatstatus != 'ALL')
                        {    
                            flat.Status__c='SEARCH RESULT';
                        }                           
                        SearchResult.add(flat.Wing__c+string.ValueOf(flat.Floor__c));
                        WingSearchResult.add(flat.Wing__c);
                        system.debug('Entered:');
                    }
                }
            }           
           
        } 
        else {
          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Select a Project!!!'));
          query = null;
          return null;
        }   
        system.debug('Search Result:' + SearchResult);
        
        List<aggregateResult> results = [select Flat__r.Wing__c wing, sum(Parking_Nos_4w__c) total_fourw from Booking_Information__c Where Flat__r.Wing__c =:WingSearchResult Group By Flat__r.Wing__c];
        List<Stage_Details__c> Stgeresult = [select Wing__c, Description__c,Actual_Completion_Date__c, Expected_Completion_Date__c, Slab__c from Stage_Details__c Where Wing__c =:WingSearchResult];
      
        
        Integer four_w_count = 0;
        boolean isexecuted = false;
        String wing_name = '';
        //Call method to construct JSON for column, data, field for ext js..
        for(Wing__c wing:wingIds){ 
          wing_name = wing.name;      
          if(WingSearchResult.contains(wing.id))  {            
            for (AggregateResult ar : results) {
              if(ar.get('wing') == wing.Id && !isexecuted) {
                if(ar.get('total_fourw') != null && Integer.valueof(ar.get('total_fourw')) != null) {        
                  four_w_count = Integer.valueof(ar.get('total_fourw'));    
                  isexecuted = true;                 
                }          
              }
              else {
               four_w_count = 0;
               isexecuted = false;
              }            
            }
            decimal available_parking = wing.No_of_4_wheeler_parking__c - four_w_count;
            String parking = String.Valueof(available_parking);
            String possesion_date = 'NA';
            if(wing.Proposed_Completion__c != NULL)
            {
                Datetime dt = datetime.newInstance(wing.Proposed_Completion__c.year(), wing.Proposed_Completion__c.month(),wing.Proposed_Completion__c.day());
                String tmp_date = dt.format('MMM d, yyyy'); 
                //String p_mon = String.Valueof(wing.Proposed_Completion__c.month());
                //String p_year = String.Valueof(wing.Proposed_Completion__c.year());
                
                String p_mon = tmp_date.substring(0, 3).toUpperCase();
                String p_year = tmp_date.substringAfterLast(' ');
                possesion_date = p_mon + '-' + p_year ;
            }
            
            Decimal sum=0;
            String construction_status;       
            for(Stage_Details__c s:Stgeresult) {
              if(s.Wing__c == wing.Id) {
              /*
                if(s.Actual_Completion_Date__c == null) {
                  sum = sum + s.Slab__c;
                  construction_status = s.Description__c + ' Construction Completed';
                } 
                */
                if(s.Actual_Completion_Date__c != null) {
                    sum = sum + s.Slab__c;
                    construction_status = s.Description__c + ' Construction Completed';
                }  
                
              }            
            }
                        
            wing_det_string.add('\''+ sum + '% Payment Due/ ' + parking  + ' Parking Available/Possesion: '+ possesion_date +  '/ ' + construction_status + '\'');
            //Get Flats/Floor in Wing
            Double flatsPerFloor=wing.No_of_flats_floor__c;
            
            //Get Floors in Wing
            Double floorPerWing=wing.No_of_Floors__c;
            //to determine width of the grid
            flatperfloorcount.add(wing.No_of_flats_floor__c);
            // to display header on grid
            wingclusterlist.add('\'' +  wing.Cluster__r.Name + '--'+ wing_name + '\'');
            
            //Generate column values based on flats/floor
            columnValue.add(generateJSONColumnValue(flatsPerFloor, floorPerWing));
            
            //Generate Field Values based on flats/floor
            fieldValue.add(generateJSONFieldValue(flatsPerFloor, floorPerWing));
            
            //Generate Data Values based on flat object, field value
            dataValue.add(generateJSONDataValue(flatsPerFloor, floorPerWing, wing));
            } 
            
            system.debug('&&&&' + wingclusterlist);
        }
        return null;
    }
    
    private String generateJSONColumnValue(Double flatsPerFloor, Double floorPerWing){
        String colVal=null;
        if(flatsPerFloor!=null && floorPerWing!=null){
            colVal='[';
            for(Integer i=1;i<=(flatsPerFloor+1);i++){
                if(i==1){
                    colVal=colVal+'{header: \'\', dataIndex:\'Floor\'},';
                } else if(i==(flatsPerFloor+1)){
                    colVal=colVal+'{header: \'Flat'+(i-1)+'\''+', dataIndex:\'FLAT'+(i-1)+'\' ,renderer: function (value, meta, record) {var v = record.get(\'FLAT'+(i-1)+'\'); if (v.length>12) { v = v.substring((v.lastIndexOf(\':\')+6),(v.lastIndexOf(\'<\')-7));}if(v.length>0){if(v==\'OPEN\'){meta.tdCls=\'flat-open\';} else if (v==\'HOLD\'){meta.tdCls=\'flat-hold\';} else if (v==\'ALL\'){meta.tdCls=\'flat-all\';} else if (v==\'BLOCKED\'){meta.tdCls=\'flat-blocked\';} else if (v==\'BOOKING\'){meta.tdCls=\'flat-booking\';} else if (v==\'BOOKED\'){meta.tdCls=\'flat-booked\';} else if (v==\'SCUD\'){meta.tdCls=\'flat-scud\';} else if (v==\'CANCELLATION\'){meta.tdCls=\'flat-cancellation\';} else if (v==\'SCUD REJECT\'){meta.tdCls=\'flat-scud-reject\';} else if (v==\'FAME RETURN\'){meta.tdCls=\'flat-fame-return\';} else if (v==\'NOT AVAILABLE\'){meta.tdCls=\'flat-not-available\';} else if (v==\'SOLD\'){meta.tdCls=\'flat-sold\';} else if(v==\'SEARCH RESULT\'){meta.tdCls=\'search-result\';} else {meta.tdCls=\'status-unknown\';}}return value;}}';
                } else {
                    colVal=colVal+'{header: \'Flat'+(i-1)+'\''+', dataIndex:\'FLAT'+(i-1)+'\' ,renderer: function (value, meta, record) {var v = record.get(\'FLAT'+(i-1)+'\'); if (v.length>12) { v = v.substring((v.lastIndexOf(\':\')+6),(v.lastIndexOf(\'<\')-7));}if(v.length>0){if(v==\'OPEN\'){meta.tdCls=\'flat-open\';} else if (v==\'HOLD\'){meta.tdCls=\'flat-hold\';} else if (v==\'ALL\'){meta.tdCls=\'flat-all\';} else if (v==\'BLOCKED\'){meta.tdCls=\'flat-blocked\';} else if (v==\'BOOKING\'){meta.tdCls=\'flat-booking\';} else if (v==\'BOOKED\'){meta.tdCls=\'flat-booked\';} else if (v==\'SCUD\'){meta.tdCls=\'flat-scud\';} else if (v==\'CANCELLATION\'){meta.tdCls=\'flat-cancellation\';} else if (v==\'SCUD REJECT\'){meta.tdCls=\'flat-scud-reject\';} else if (v==\'FAME RETURN\'){meta.tdCls=\'flat-fame-return\';} else if (v==\'NOT AVAILABLE\'){meta.tdCls=\'flat-not-available\';} else if (v==\'SOLD\'){meta.tdCls=\'flat-sold\';} else if(v==\'SEARCH RESULT\'){meta.tdCls=\'search-result\';} else {meta.tdCls=\'status-unknown\';}}return value;}},';
                }
            }
            colVal=colVal+']';
        }
        system.debug('Value for Col:'+colVal);                  
        return colVal;
     }
     
     private String generateJSONFieldValue(Double flatsPerFloor, Double floorPerWing){
        String fldVal='[\'Floor\',';
        if(flatsPerFloor!=null && floorPerWing!=null){
            for(Integer i=1;i<=flatsPerFloor;i++){
                if(i==1 && flatsPerFloor==1){
                    fldVal=fldVal+'\'FLAT'+i+'\']';
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
     
     private String generateJSONDataValue(Double flatsPerFloor, Double floorPerWing, Wing__c wing){
        String datVal=null;
        List<Flat__c> tempF = null;
        Flat__c Tmpflat = null;
        List<Flat__c> flatList = new List<Flat__C>();
        List<Flat__c> flatSet = null;
        Map<Integer,List<Flat__c>> floorFlatMap = new Map<Integer, List<Flat__c>>();
        Integer startFloor=0;
        Integer endFloor=0;
        
        flatList = wing.Flats__r;   

        system.debug('flatList from query is:'+flatList);
        
                        
        for(Flat__c f:flatList){
            system.debug('Itterating over all flats'+f);
            system.debug('@@Search flat' + f.Wing__c+string.ValueOf(f.Floor__c));
            if(floorFlatMap.containsKey(Integer.valueOf(f.Floor__c)) && SearchResult.contains(f.Wing__c+string.ValueOf(f.Floor__c)) ){
                system.debug('Floor was already in map.');
                floorFlatMap.get(Integer.valueOf(f.Floor__c)).add(f);               
            }
            else if(SearchResult.contains(f.Wing__c+string.valueOf(f.Floor__c))){
                system.debug('This floor was not in map..'+f.Floor__c);
                tempF = new List<Flat__c>();
                tempF.add(f);
                floorFlatMap.put(Integer.valueOf(f.Floor__c), tempF);               
            }          
        }
        List<Integer> FloorPlan = new List<Integer>(floorFlatMap.keySet());
        FloorPlan.sort();
        System.debug('Florr MAp' + floorFlatMap.values());
        //Start with dataValue and std items
        datVal = '{\'items\':[';       
        
        //Check if floor per wing is not empty.
        if(floorPerWing>0 && floorFlatMap!=null && floorFlatMap.size()>0){
            
     
            system.debug('Floor Plan:' + FloorPlan.size());
            //Itterating floor wise
            integer count = 0;
            integer endPoint = FloorPlan.size();
            for(Integer i : FloorPlan){
                count = count + 1;
                //Get all flats in floor
                system.debug('Getting records for floor:'+i);    
                           
                flatSet = floorFlatMap.get(i);
                system.debug('flatSet:' + flatSet);
                system.debug('Successfully fetched records for floor:'+i);
                //Itterate over all flats in the floor
                for(Integer j=0;j<(flatSet.size()+1);j++){
                    if(j==0){
                        datVal=datVal+'{"Floor":'+'"Floor'+i+'",'; //it was (i-1) changes it to i to display floor from 1 and not 0
                    } 
                    else {
                        Tmpflat = flatSet.get(j-1);
                        String hovertip;
                       // hovertip = 'Cluster: '+ wing.Cluster__r.Name + '&#013;Wing: '+ wing.Name + '&#013;Flat No: ' + Tmpflat.Flat_No__c +  '&#013;Flat Type: ' + Tmpflat.Flat_Type_Text__c + '&#013;Salable Area: ' + Tmpflat.Salable_Area__c  + '&#013;Carpet Area: ' + Tmpflat.Carpet_Area__c  + '&#013;Consideration value: ' + Tmpflat.Consideration_Rs__c  +  '&#013;View: ' + Tmpflat.View__c  + '&#013;Status: ' + Tmpflat.Status__c;
                        if(Tmpflat.Status__c == 'NOT AVAILABLE' || Tmpflat.Status__c == 'OPEN' || Tmpflat.Status__c == 'HOLD' || Tmpflat.Status__c == 'BLOCKED') {
                          hovertip = 'Cluster: '+ wing.Cluster__r.Name + '&#013;Wing: '+ wing.Name + '&#013;Flat No: ' + Tmpflat.Flat_No__c +  '&#013;Flat Type: ' + Tmpflat.Flat_Type_Text__c + '&#013;Salable Area: ' + Tmpflat.Salable_Area__c  + '&#013;Carpet Area: ' + Tmpflat.Carpet_Area__c  + '&#013;Consideration value: ' + Tmpflat.Consideration_Rs__c  +  '&#013;View: ' + Tmpflat.View__c  + '&#013;Status: ' + Tmpflat.Status__c;
                        }
                        else {
                          hovertip = 'Cluster: '+ wing.Cluster__r.Name + '&#013;Wing: '+ wing.Name + '&#013;Flat No: ' + Tmpflat.Flat_No__c +  '&#013;Flat Type: ' + Tmpflat.Flat_Type_Text__c + '&#013;Salable Area: ' + Tmpflat.Salable_Area__c  + '&#013;Carpet Area: ' + Tmpflat.Carpet_Area__c  + '&#013;Consideration value: ' + Tmpflat.Actual_Consideration__c +  '&#013;View: ' + Tmpflat.View__c  + '&#013;Status: ' + Tmpflat.Status__c;
                        }
                        //datVal=datVal+'"FLAT'+j+'":"'+'<a href=\'/'+Tmpflat.ID+'\'>'+Tmpflat.Flat_No__c+'<span style=\'display:none\'>'+Tmpflat.Status__c+'</span></a>'+'"';
                        //if its review done by salesmanager from project page then dont redirect search result to booking
                        
                        if(role_name == 'Lodha Admin' || profile_name == 'System Administrator') {
                          access_value = FALSE;
                        }
                        
                        if(opp_id == null && (profile_name == 'Customer Care Manager' || profile_name == 'Customer Care')){
                            access_value = TRUE;
                        }
                        
                        if(access_value == TRUE) {
                          datVal=datVal+'"FLAT'+j+'":"'+'<a href=\'apex/SpSearchInventory?oppid=' + opp_id + '&proj=' + prjNam  + '&no_access=1'+ '\' title=' + '\'' + hovertip + '\'>'+Tmpflat.Flat_No__c+'<span style=display:none>'+ Tmpflat.Status__c+'</span></a>'+'"';
                        }
                        else if(opp_id == null || Tmpflat.Status__c == 'NOT AVAILABLE' || Tmpflat.Status__c == 'HOLD') {
                          datVal=datVal+'"FLAT'+j+'":"'+'<a href=\'/'+Tmpflat.ID+ '\' title=' + '\'' + hovertip + '\'>'+Tmpflat.Flat_No__c+'<span style=display:none>'+ Tmpflat.Status__c+'</span></a>'+'"';                        
                        }
                        else if(opp_id != null) {
                          if(isSP2 ==false){
                              datVal=datVal+'"FLAT'+j+'":"'+'<a href=\'/apex/SpBookInventory?fid='+Tmpflat.ID+'&oppid='+opp_id+ '&proj='+proj+'\' title=' + '\'' + hovertip + '\'>'+Tmpflat.Flat_No__c+'<span style=display:none>'+ Tmpflat.Status__c+'</span></a>'+'"';
                          }
                          else{
                              datVal=datVal+'"FLAT'+j+'":"'+'<a href=\'/apex/Sp2Booking?fid='+Tmpflat.ID+'&oppid='+opp_id+ '&proj='+proj+'\' title=' + '\'' + hovertip + '\'>'+Tmpflat.Flat_No__c+'<span style=display:none>'+ Tmpflat.Status__c+'</span></a>'+'"';
                          }
                        }
                        
                        
                        
                        if(j == flatSet.size()){
                            datVal=datVal+'}';
                        } else {                            
                            datVal=datVal+',';
                        }
                    }
                    system.debug('Flat loop'+j);                                                           
                }               
                
                //Clearing flatList for next floor.
                flatSet.clear();
                
                //Between floor to print ,
                if(count<endPoint){
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
    

    
   /* public PageReference demoMethod() {
        
        columnValue=new List<String>();
        fieldValue=new List<String>();
        dataValue=new List<String>();
        
        String column1='[{header: \' \', dataIndex:\'Floor\'},{header: \'Flat1\', dataIndex:\'FLAT1\' ,renderer: function (value, meta, record) {var v = record.get(\'FLAT1\'); if (v.length>12) { v = v.substring(0,v.length -11);v = v.substring(v.lastIndexOf(\'>\')+1,v.length);}if(v.length>0){if(v==\'OPEN\'){meta.tdCls=\'flat-open\';} else if (v==\'ALL\'){meta.tdCls=\'flat-all\';} else if (v==\'BLOCKED\'){meta.tdCls=\'flat-blocked\';} else if (v==\'BOOKING\'){meta.tdCls=\'flat-booking\';} else if (v==\'CANCELLATION\'){meta.tdCls=\'flat-cancellation\';} else if (v==\'NOT AVAILABLE\'){meta.tdCls=\'flat-not-available\';} else if (v==\'SOLD\'){meta.tdCls=\'flat-sold\';} else {meta.tdCls=\'status-unknown\';}}return value;}},{header: \'Flat2\', dataIndex:\'FLAT2\' ,renderer: function (value, meta, record) {var v = record.get(\'FLAT2\'); if (v.length>12) { v = v.substring(0,v.length -11);v = v.substring(v.lastIndexOf(\'>\')+1,v.length);}if(v.length>0){if(v==\'OPEN\'){meta.tdCls=\'flat-open\';} else if (v==\'ALL\'){meta.tdCls=\'flat-all\';} else if (v==\'BLOCKED\'){meta.tdCls=\'flat-blocked\';} else if (v==\'BOOKING\'){meta.tdCls=\'flat-booking\';} else if (v==\'CANCELLATION\'){meta.tdCls=\'flat-cancellation\';} else if (v==\'NOT AVAILABLE\'){meta.tdCls=\'flat-not-available\';} else if (v==\'SOLD\'){meta.tdCls=\'flat-sold\';} else {meta.tdCls=\'status-unknown\';}}return value;}}]';
        String field1='[\'Floor\',\'FLAT1\',\'FLAT2\']';
        String Data1='{\'items\':[{"Floor":"Floor0","FLAT1":"<a href=\'/a1DL0000000HAscMAG\'>101<span style=\'display:none\'>ALL</span></a>","FLAT2":"<a href=\'/a1DL0000000HAsdMAG\'>102<span style=\'display:none\'>BLOCKED</span></a>"},{"Floor":"Floor1","FLAT1":"<a href=\'/a1DL0000000HAseMAG\'>201<span style=\'display:none\'>BOOKING</span></a>","FLAT2":"<a href=\'/a1DL0000000HAsfMAG\'>202<span style=\'display:none\'>CANCELLATION</span></a>"},{"Floor":"Floor2","FLAT1":"<a href=\'/a1DL0000000HAsgMAG\'>301<span style=\'display:none\'>NOT AVAILABLE</span></a>","FLAT2":"<a href=\'/a1DL0000000HAshMAG\'>302<span style=\'display:none\'>SOLD</span></a>"},{"Floor":"Floor3","FLAT1":"<a href=\'/a1DL0000000HAsiMAG\'>401<span style=\'display:none\'>CANCELLATION</span></a>","FLAT2":"<a href=\'/a1DL0000000HAsjMAG\'>402<span style=\'display:none\'>SCUD</span></a>"},{"Floor":"Floor4","FLAT1":"<a href=\'/a1DL0000000HAskMAG\'>501<span style=\'display:none\'>SCUD</span></a>","FLAT2":"<a href=\'/a1DL0000000HAslMAG\'>502<span style=\'display:none\'>OPEN</span></a>"},{"Floor":"Floor5","FLAT1":"<a href=\'/a1DL0000000HAsmMAG\'>601<span style=\'display:none\'>BLOCKED</span></a>","FLAT2":"<a href=\'/a1DL0000000HAsnMAG\'>602<span style=\'display:none\'>BOOKING</span></a>"}]}';

        String column2='[{header: \' \', dataIndex:\'Floor\'},{header: \'Flat1\', dataIndex:\'FLAT1\' ,renderer: function (value, meta, record) {var v = record.get(\'FLAT1\'); if (v.length>12) { v = v.substring(0,v.length -11);v = v.substring(v.lastIndexOf(\'>\')+1,v.length);}if(v.length>0){if(v==\'OPEN\'){meta.tdCls=\'flat-open\';} else if (v==\'ALL\'){meta.tdCls=\'flat-all\';} else if (v==\'BLOCKED\'){meta.tdCls=\'flat-blocked\';} else if (v==\'BOOKING\'){meta.tdCls=\'flat-booking\';} else if (v==\'CANCELLATION\'){meta.tdCls=\'flat-cancellation\';} else if (v==\'NOT AVAILABLE\'){meta.tdCls=\'flat-not-available\';} else if (v==\'SOLD\'){meta.tdCls=\'flat-sold\';} else {meta.tdCls=\'status-unknown\';}}return value;}},{header: \'Flat2\', dataIndex:\'FLAT2\' ,renderer: function (value, meta, record) {var v = record.get(\'FLAT2\'); if (v.length>12) { v = v.substring(0,v.length -11);v = v.substring(v.lastIndexOf(\'>\')+1,v.length);}if(v.length>0){if(v==\'OPEN\'){meta.tdCls=\'flat-open\';} else if (v==\'ALL\'){meta.tdCls=\'flat-all\';} else if (v==\'BLOCKED\'){meta.tdCls=\'flat-blocked\';} else if (v==\'BOOKING\'){meta.tdCls=\'flat-booking\';} else if (v==\'CANCELLATION\'){meta.tdCls=\'flat-cancellation\';} else if (v==\'NOT AVAILABLE\'){meta.tdCls=\'flat-not-available\';} else if (v==\'SOLD\'){meta.tdCls=\'flat-sold\';} else {meta.tdCls=\'status-unknown\';}}return value;}},{header: \'Flat3\', dataIndex:\'FLAT3\' ,renderer: function (value, meta, record) {var v = record.get(\'FLAT3\'); if (v.length>12) { v = v.substring(0,v.length -11);v = v.substring(v.lastIndexOf(\'>\')+1,v.length);}if(v.length>0){if(v==\'OPEN\'){meta.tdCls=\'flat-open\';} else if (v==\'ALL\'){meta.tdCls=\'flat-all\';} else if (v==\'BLOCKED\'){meta.tdCls=\'flat-blocked\';} else if (v==\'BOOKING\'){meta.tdCls=\'flat-booking\';} else if (v==\'CANCELLATION\'){meta.tdCls=\'flat-cancellation\';} else if (v==\'NOT AVAILABLE\'){meta.tdCls=\'flat-not-available\';} else if (v==\'SOLD\'){meta.tdCls=\'flat-sold\';} else {meta.tdCls=\'status-unknown\';}}return value;}}]';
        String field2='[\'Floor\',\'FLAT1\',\'FLAT2\', \'FLAT3\']';
        String Data2='{\'items\':[{"Floor":"Floor0","FLAT1":"<a href=\'/a1DL0000000HAsoMAG\'>101<span style=\'display:none\'>OPEN</span></a>","FLAT2":"<a href=\'/a1DL0000000HAspMAG\'>102<span style=\'display:none\'>OPEN</span></a>","FLAT3":"<a href=\'/a1DL0000000HAspMAG\'>103<span style=\'display:none\'>OPEN</span></a>"},{"Floor":"Floor1","FLAT1":"<a href=\'/a1DL0000000HAsqMAG\'>201<span style=\'display:none\'>OPEN</span></a>","FLAT2":"<a href=\'/a1DL0000000HAsrMAG\'>202<span style=\'display:none\'>OPEN</span></a>","FLAT3":"<a href=\'/a1DL0000000HAspMAG\'>203<span style=\'display:none\'>OPEN</span></a>"}]}';
        
        columnValue.add(column1);
        fieldValue.add(field1);
        dataValue.add(Data1);
        
        columnValue.add(column2);
        fieldValue.add(field2);
        dataValue.add(Data2);
        
        system.debug('columnValue:'+columnValue);
        system.debug('fieldValue:'+fieldValue);
        system.debug('dataValue:'+dataValue);
        
        return null;        
    }*/
    
    
    

    //Added by Shreeram
    public String query{get; set;}
    public transient   List<Wing__c> wingIds = null;
    public transient   List<Wing__c> tmpWingIds = null;    
    public transient  List<Project_Name__c> projlist;
    public transient  List<Cluster__c> clusterlist;
    public transient   List<Wing__c> winglist;
    public transient   List<Flat_Type__c> flattypelist;
    public transient  List<View_type_Assignment__c> viewlist;


    public Id selectedProjID{get;set;}
    public Id selectedclsuterID{get;set;}
    public Id selectedwingID{get;set;}
    public Id selectedflattypeID{get;set;}
    public String selectedflatstatus{get;set;}
    public String selectedviewvalue{get;set;}

    public String site_incharge{get;set;}
    public String site_contact_no{get;set;}
    public String contact_no{get;set;}
    public String address{get;set;}
    
    public Integer floor_no{get;set;}
    public Integer floor_no_from{get;set;}
    public Integer floor_no_to{get;set;}
    public String flat_no{get;set;}
    public String flat_no_option{get;set;}
    public Integer value_from{get;set;}
    public Integer value_to{get;set;}
    public String proj{get;set;}
    public String opp_id{get;set;}
    public boolean access_value{get;set;}
    public String acess_parm{get;set;}
    public String profile_name{get;set;}
    
    public boolean isSP2{get;set;}
    
    public SpSearchInventoryController() {
      acess_parm = ApexPages.currentPage().getParameters().get('no_access');
      proj = ApexPages.currentPage().getParameters().get('proj');
      opp_id = ApexPages.currentPage().getParameters().get('oppid');
      
      if(opp_id == null || opp_id == '') {
        opp_id=null;
      }
      if(proj != null && proj != '') {
        String proj_nam = proj.replace('+', ' ');
        Project_Name__c project = [select ID,isSP2__c from Project_Name__c Where Name=:proj_nam];
        selectedProjID = project.Id;
        isSP2=project.isSP2__c;
      }
      else{
        selectedProjID=null;
      }
      if(acess_parm == '1') {
         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'No permission to proceed ahead with booking'));        
      }
      selectedclsuterID=null;
      selectedwingID=null;
      flat_no=null;
      flat_no_option=null;
      
      site_incharge = null;
      site_contact_no = null;
      contact_no = null;
      address = null;
      role_id = UserInfo.getUserRoleId();
      UserRole role = [select Name from UserRole where Id=: UserInfo.getUserRoleId()];
      role_name = role.Name;
      profile_name = [Select Id, Name From Profile where Id=:UserInfo.getProfileId()].Name;    
    }

    public PageReference updateList() {
      String inchargeid;
      if(selectedProjID != null) {
          try {
            Project_Name__c proj= [select Contact_Nos__c, Contact_Center_No__c, Project_Address__c, Site_Incharge__c from Project_Name__c where Id =:selectedProjID];
            inchargeid = proj.Site_Incharge__c;
            site_contact_no = proj.Contact_Center_No__c;
            contact_no = proj.Contact_Nos__c;
            address = proj.Project_Address__c;
          }
          catch(DMLException e) {
            System.debug('Unable to find project details' + e.getMessage());
            site_incharge = null;
            site_contact_no = null;
            contact_no = null;
            address = null;
          }
          try {
              List<User> userlist = new List<User>();
              userlist = [Select Name from User Where Id =: inchargeid];
              if(userlist.size()>0) {
               for(User u:userlist){  site_incharge =  u.Name; }
              }
              else {
                site_incharge = null;
              }
          }
          catch(DMLException e) {
            System.debug('Unable to find site incharge details' + e.getMessage());
            site_incharge = null;
          }
      }
      return null;
    }


    public List<View_type_Assignment__c> getViewList(Id projID) {
      viewlist = [Select Id, Name, View__c from View_type_Assignment__c where Wing__c =: selectedwingID AND RecordType.Name = 'View Type Record'];
      system.debug('*@@*'+viewlist+'****');
      return viewlist;
    }

    public List<selectOption> getProjectsSelectionList() {
      List<selectOption> ProjOptions = new List<selectOption>();
       //new list for holding all of the picklist options
      ProjOptions.add(new selectOption('', 'Select')); 
      //add the first option of '- None -' in case the user doesn't
      // want to select a value or in case no values are
      // returned from query below
      
      
      if(role_name == 'Lodha Admin' || profile_name == 'System Administrator') {
        for (Project_Name__c proj: [select ID, Name from Project_Name__c Order By Name]) { 
          //query for Account records 
          ProjOptions.add(new selectOption(proj.Id, proj.Name)); 
          //for all records found - add them to the picklist options
        }
      }
      else {     
        for (Project_Name__c proj: [select ID, Name from Project_Name__c Where Id IN (select Project_Name__c from SPRINT_Access__c where Allowed_Role__c=:role_name)Order By Name]) { 
          //query for Account records 
          ProjOptions.add(new selectOption(proj.Id, proj.Name)); 
          //for all records found - add them to the picklist options
        }
      }
      /*for (Project_Name__c proj: [select ID, Name from Project_Name__c Order By Name]) { 
          //query for Account records 
          ProjOptions.add(new selectOption(proj.Id, proj.Name)); 
          //for all records found - add them to the picklist options
      }*/
      
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
      for (Cluster__c c: [select ID,Name from Cluster__c Where Project_Name__r.Id =:selectedProjID Order By Name]) { 
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
      for (Wing__c w: [select ID,Name from Wing__c Where Cluster__r.Id =:selectedclsuterID Order By Name]) { 
        //query for Account records 
        Options.add(new selectOption(w.Id, w.Name)); 
        //for all records found - add them to the picklist options
      }
      return Options; 
      //return the picklist options
    }

    public List<selectOption> getFlatTypeSelectionList() {
      List<selectOption> Options = new List<selectOption>();
       //new list for holding all of the picklist options
      Options.add(new selectOption('', 'Select')); 
      //add the first option of '- select -' in case the user doesn't
      // want to select a value or in case no values are
      // returned from query below
      for (Flat_Type__c ft: [select ID,Name from Flat_Type__c Where Wing__r.Id =: selectedwingID]) { 
        //query for Account records 
        Options.add(new selectOption(ft.Id, ft.Name)); 
        //for all records found - add them to the picklist options
      }
      return Options; 
      //return the picklist options
    }

    public List<selectOption> getFlatStatusSelectionList() {
      List<selectOption> Options = new List<selectOption>();
      //new list for holding all of the picklist options
      Options.add(new selectOption('OPEN', 'OPEN'));
      Options.add(new selectOption('ALL', 'ALL'));
      Options.add(new selectOption('BLOCKED', 'BLOCKED'));
      Options.add(new selectOption('BOOKING', 'BOOKING'));
      Options.add(new selectOption('CANCELLATION', 'CANCELLATION'));
      Options.add(new selectOption('NA', 'NOT AVAILABLE'));
      Options.add(new selectOption('SOLD', 'SOLD'));
      Options.add(new selectOption('HOLD', 'HOLD'));
      return Options; 
      //return the picklist options
    }

    public List<selectOption> getViewSelectionList() {
      List<selectOption> Options = new List<selectOption>();
       //new list for holding all of the picklist options
      Options.add(new selectOption('', 'Select')); 
      //add the first option of '- select -' in case the user doesn't
      // want to select a value or in case no values are
      // returned from query below
      for (View_type_Assignment__c vw: getViewList(selectedProjID)) { 
        //query for Account records 
        
        Options.add(new selectOption(vw.View__c, vw.View__c)); 
        //for all records found - add them to the picklist options
        
      }
      return Options; 
      //return the picklist options
    }   
     
}