global class SpBatchGenerateInventory implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
    Map<Id,String> recTypeMap = new Map<Id,String>();
    Map<Id,Map<String,Flat_Type__c>> wingFlatDetMap = new Map<Id, Map<String,Flat_Type__c>>();
    Map<Id,Map<String,View_type_Assignment__c>> wingFlatTypeMap = new Map<Id,Map<String,View_type_Assignment__c>>();
    Map<Id,Map<String,View_type_Assignment__c>> wingViewTypeMap = new Map<Id,Map<String,View_type_Assignment__c>>();
    Map<Id,Map<String,Rate_Card__c>> wingRateViewTypeMap = new Map<Id,Map<String,Rate_Card__c>>();
    Map<Id,Map<String,Rate_Card__c>> wingRateFloorTypeMap = new Map<Id,Map<String,Rate_Card__c>>();

    set<String> FlatStatset = new set<String>();
    String message;
    global SpBatchGenerateInventory(){

    }

    global Database.QueryLocator start(Database.BatchableContext BC){
        
        List<Inventory_Management__c> customSettingIM = Inventory_Management__c.getall().values();
        
        String WhereClause = '';
        if(customSettingIM.size() >= 1)
        {
            if(customSettingIM[0].Project_Id__c != '' && customSettingIM[0].Project_Id__c != NULL)
            {
                WhereClause = 'Where Cluster__r.Project_Name__c = ' + '\'' + customSettingIM[0].Project_Id__c + '\'';
            }
        }
        String query = 'select Id, Name, Podium_Unit__c, No_of_Floors__c, No_of_flats_floor__c, Project__c, Cluster_hidden__c from Wing__C ' + WhereClause; 
        system.debug('querys:'+query);
        return Database.getQueryLocator(query);
    }
         
    global void execute(Database.BatchableContext BC, List<Wing__c> WingList){
        
        /******** Start Get RecordType Details ***********/
        
        List<RecordType> recTypeList = [select Id, Name from RecordType where Name = 'Flat Type Record' or Name ='View Type Record' or Name = 'Floor Rise Rate' or Name = 'Premium View Rate Record'];
        for(Integer i=0; i< recTypeList.size(); i++){
            recTypeMap.put(recTypeList[i].Id,recTypeList[i].Name);
        }
        
        /******** End RecordType Details ***********/
        
        set<Id> wingSet = new set<Id>();
        for(Wing__c wing: WingList){
        	wingSet.add(wing.Id);
        }
        
        /******** Start Get Flat Details ***********/
        
        Map<String,Flat_Type__c> flatDetMap = new Map<String,Flat_Type__C>();
        for(Flat_Type__c ft: [select Id, Name, Base_Rate_Sq_Ft__c, Carpet_Area__c, 
                                                        Club_Charge_Rs__c,Infrastructure_Rs__c, 
                                                        Infrastructure_2_Rs__c, Salable_Area__c,
                                                        Token_Amount_Rs__c,Wing__r.Id
                                                        from Flat_Type__c where Wing__r.Id IN :wingSet]){
                                                        
                                                                  
                                                        
            if(!wingFlatDetMap.containsKey(ft.Wing__r.Id)){
                wingFlatDetMap.put(ft.Wing__r.Id, new Map<String,Flat_Type__C>{ft.Id => ft});
            }
            else {
           
                wingFlatDetMap.get(ft.Wing__r.Id).put(ft.Id, ft);
            }
                                                            
        }
        /********  End Flat Details  ***********/
        
        /*********** Start Get Flat View Assignment Details ******************/
        
        Integer i=0;
        Map<String,View_type_Assignment__c> viewTypeMap = new Map<String,View_type_Assignment__c>();
        Map<String,View_type_Assignment__c> flatTypeMap = new Map<String,View_type_Assignment__c>();
        for(View_type_Assignment__c fv:[select Name, Id, RecordType.Id, Flat_Type__r.Id,Flat_Type__r.Name,
                                                            Column_Index__c, From__c, To__c, Pattern__c, View__c, Wing__r.Id 
                                                            from View_type_Assignment__c
                                                            where Wing__r.Id IN :wingSet]) {
           //the wingViewTypeMap will look like below
           //In case of Range, say 10 -15 floor, its broken down 
           //to each floor and one value is stored per floor
           //overlapping range defintion if any will get overwritten
           //{Wing A => {'Odd'  => '1BHK <other fields from the SObject>', 
           //            'Even' => '2BHK <other fields from the Sobject>',
           //            '1'    => '3BHK <other fields from the SObject>',
           //            '2'    => '4BHK <other fields from the SObject>'},
           // Wing B => {}
           //}
           
           if(fv.Column_Index__c.length() == 1) {
             fv.Column_Index__c = 0 + fv.Column_Index__c;
           }
           
                      
            if(recTypeMap.get(fv.RecordType.Id) == 'Flat Type Record'){
              if(fv.Pattern__c == 'Range'){
                for(Integer j=fv.From__C.intValue(); j<=fv.To__C.intValue(); j++){
                  if(!wingFlatTypeMap.containsKey(fv.Wing__r.Id)){
                    wingFlatTypeMap.put(fv.Wing__r.Id, new Map<String,View_type_Assignment__c>{string.valueof(j)+ fv.Column_Index__c => fv});
                  }
                  else{
                    wingFlatTypeMap.get(fv.Wing__r.Id).put(string.valueof(j)+ fv.Column_Index__c, fv);
                  }    
                 }
               }
               //if pattern odd/even and range seleted with floor range
               else if((fv.Pattern__c == 'Odd' || fv.Pattern__c == 'Even') && fv.From__C != null && fv.To__C != null ) {
                   for(Integer j=fv.From__C.intValue(); j<=fv.To__C.intValue(); j++){
                   
                        if(!wingFlatTypeMap.containsKey(fv.Wing__r.Id)){
                            wingFlatTypeMap.put(fv.Wing__r.Id, new Map<String,View_type_Assignment__c>{fv.Pattern__c + string.valueof(j) + fv.Column_Index__c => fv});
                        }
                        else{
                          wingFlatTypeMap.get(fv.Wing__r.Id).put(fv.Pattern__c + string.valueof(j) + fv.Column_Index__c , fv);
                        }
                        
                    }
                }
                else if(fv.Pattern__c == 'All') {
                                
                    if(!wingFlatTypeMap.containsKey(fv.Wing__r.Id)){
                            wingFlatTypeMap.put(fv.Wing__r.Id, new Map<String,View_type_Assignment__c>{fv.Column_Index__c => fv});
                    }
                    else{
                          wingFlatTypeMap.get(fv.Wing__r.Id).put(fv.Column_Index__c , fv);
                    }
                }
                else if(!wingFlatTypeMap.containsKey(fv.Wing__r.Id)){
                    wingFlatTypeMap.put(fv.Wing__r.Id, new Map<String,View_type_Assignment__c>{fv.Pattern__c + fv.Column_Index__c => fv});
                }
                else{
                    wingFlatTypeMap.get(fv.Wing__r.Id).put(fv.Pattern__C + fv.Column_Index__c, fv);
                }
            }
            system.debug('flat type map-->' + wingFlatTypeMap);
            
            
            if(recTypeMap.get(fv.RecordType.Id) == 'View Type Record'){
                if(fv.Pattern__c == 'Range'){
                    for(Integer j=fv.From__C.intValue(); j<=fv.To__C.intValue(); j++){
                        
                        if(!wingViewTypeMap.containsKey(fv.Wing__r.Id)){
                            wingViewTypeMap.put(fv.Wing__r.Id, new Map<String,View_type_Assignment__c>{string.valueof(fv.Flat_Type__r.Id) + string.valueof(j) + fv.Column_Index__c => fv});
                        }
                        else{
                            wingViewTypeMap.get(fv.Wing__r.Id).put(string.valueof(fv.Flat_Type__r.Id) + string.valueof(j)+ fv.Column_Index__c, fv);
                        }
                        
                    }
                }
                //if pattern odd and range seleted
                else if((fv.Pattern__c == 'Odd' || fv.Pattern__c == 'Even') && fv.From__C != null && fv.To__C != null ){
                    for(Integer j=fv.From__C.intValue(); j<=fv.To__C.intValue(); j++){
                        if(!wingViewTypeMap.containsKey(fv.Wing__r.Id)){
                            wingViewTypeMap.put(fv.Wing__r.Id, new Map<String,View_type_Assignment__c>{string.valueof(fv.Flat_Type__r.Id) + fv.Pattern__c + string.valueof(j) + fv.Column_Index__c => fv});
                        }
                        else{
                            wingViewTypeMap.get(fv.Wing__r.Id).put(string.valueof(fv.Flat_Type__r.Id) + fv.Pattern__c + string.valueof(j) + fv.Column_Index__c, fv);
                        }
                    }
                }
                else if(fv.Pattern__c == 'All') {                                
                  if(!wingViewTypeMap.containsKey(fv.Wing__r.Id)){
                    wingViewTypeMap.put(fv.Wing__r.Id, new Map<String,View_type_Assignment__c>{ string.valueof(fv.Flat_Type__r.Id) + fv.Column_Index__c => fv});
                  }
                  else {
                    wingViewTypeMap.get(fv.Wing__r.Id).put(string.valueof(fv.Flat_Type__r.Id) + fv.Column_Index__c , fv);
                  }
                }
                else if(!wingViewTypeMap.containsKey(fv.Wing__r.Id)){
                    wingViewTypeMap.put(fv.Wing__r.Id, new Map<String,View_type_Assignment__c>{string.valueof(fv.Flat_Type__r.Id) + fv.Pattern__c + fv.Column_Index__c => fv});
                }
                else{
                    wingViewTypeMap.get(fv.Wing__r.Id).put(string.valueof(fv.Flat_Type__r.Id) + fv.Pattern__c + fv.Column_Index__c, fv);
                }
            }  
            
            
                                                             
        }
        
        /*********** End Flat View Assignment Details ******************/
    
        /*********** Start Rate Card Details ******************/
        
        i=0;
        for(Rate_Card__c rc:[select Name, Id, RecordType.Id, Flat_Type__r.Id,Flat_Type__r.Name, 
                             Floor_From__c, Floor_To__c, Floor_Rise_Sq_Ft__c, Premium_View__c, View_Rate_Sq_Ft__c,Wing__r.Id 
                             from Rate_Card__c where Wing__r.Id IN :wingSet]) { 
                             
                             
                                             
            if(recTypeMap.get(rc.RecordType.Id) == 'Floor Rise Rate'){
              for(Integer j=rc.Floor_From__c.intValue(); j<=rc.Floor_To__c.intValue(); j++){
                
                if(!wingRateFloorTypeMap.containsKey(rc.Wing__r.Id)){
                   wingRateFloorTypeMap.put(rc.Wing__r.Id, new Map<String,Rate_Card__c>{string.valueof(rc.Flat_Type__r.Id) + string.valueof(j) => rc});
                }
                else{
                   wingRateFloorTypeMap.get(rc.Wing__r.Id).put(string.valueof(rc.Flat_Type__r.Id) + string.valueof(j), rc);
                }               
              }

            }
                   
            if(recTypeMap.get(rc.RecordType.Id) == 'Premium View Rate Record'){
                if(!wingRateViewTypeMap.containsKey(rc.Wing__r.Id)){
                   wingRateViewTypeMap.put(rc.Wing__r.Id, new Map<String,Rate_Card__c>{string.valueof(rc.Flat_Type__r.Id) + rc.Premium_View__c => rc});
                }
                else{
                   wingRateViewTypeMap.get(rc.Wing__r.Id).put(string.valueof(rc.Flat_Type__r.Id) + rc.Premium_View__c, rc);
                }
            }                                                   
        }
        
        /*********** End Rate Card Details ******************/
        
        /*********** Start Get Flat Details based on Status ******************/
        
        for(Flat__c f: [select Unique_Flat_Key__c from Flat__c where Status__c IN ('BOOKED', 'BOOKING', 'SCUD', 'SOLD') and Wing__c IN:wingSet]){
            FlatStatset.add(f.Unique_Flat_Key__c);
        }
        
        /*********** End Flat Details ******************/
        
        
     
        /*********** Start Create Inventory ******************/
        
    
        String pattern;
        Integer floor=0;
        Integer startNum; 
        Integer flatNo = 0;
        i = 0;
        Integer j;
        Integer creation_status = 0; 
        List<Flat__C> flatList = new List<Flat__C>();
        String col_index;
        Flat__C f = new Flat__C();
        Map<Id, Integer> flatMap = new Map<Id, Integer>();
        AggregateResult[] aggrflats = [Select count(Id) flatCount, Wing__c from Flat__c where Wing__r.Id IN :wingSet Group By Wing__c];
        for(AggregateResult FlatAggr: aggrflats){
            flatMap.put((Id)FlatAggr.get('Wing__c'),(Integer)FlatAggr.get('flatCount'));
        }
    
        for(Wing__C w : WingList){
            Integer ground_floor_flat = 0;
            if(w.Podium_Unit__c == 'Yes') {
              startNum = 000;
              ground_floor_flat = w.No_of_flats_floor__c.intvalue();
            }
            else {
              startNum = 100;
            }
            
            // Integer flat_limit = getFlatcount(w.Id);
            Integer flat_limit = flatMap.get(w.Id);
             
            Integer totalFlats = w.No_of_Floors__c.intValue() *  w.No_of_flats_floor__c.intvalue();
            totalFlats = totalFlats + ground_floor_flat;
            if(totalFlats < flat_limit) {
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Mismatch in current Inventory. Please Contact System Administrator'));
              // return null;
            }
            Integer remainder;
            Integer start;
            if(w.Podium_Unit__c == 'Yes') {
              start = 0;
            }
            else { start =1;}
            for(i=start; i <= w.No_of_Floors__c.intValue(); i++){
              
                for(j=1; j<= w.No_of_flats_floor__c.intValue(); j++) {
                  
                    flatNo = startNum + j;
                    remainder = math.mod(i,2);
                    if(remainder == 1){
                        pattern = 'Odd';
                    }
                    else{
                        pattern ='Even';
                    }                               
                    floor = i;                  
                    System.Debug('Calling generate Inventory for floor:' + i + 'flat:' + flatNo + 'pattern:' + pattern + 'wingId:' + w.Id + 'colmn index: ' + String.valueof(flatNo).right(2));
                    if(String.valueof(flatNo).right(2).length() == 1) {
                      col_index = 0 + String.valueof(flatNo).right(2);
                    }
                    else {
                      col_index = String.valueof(flatNo).right(2);
                    }
                    f = assignFlatAttributes(w.Id,flatNo, pattern, floor, col_index );
                   
                    //f.Oasys_Flat_code__c = w.Project__c + w.Cluster_hidden__c + w.Name + String.ValueOf(flatNo);
                    
                    if(String.ValueOf(flatNo).length() == 3) {
                      f.Oasys_Flat_code__c = w.Project__c + ' ' + w.Cluster_hidden__c + ' ' + w.Name + ' ' + '0' + String.ValueOf(flatNo);
                    }
                    else if(String.ValueOf(flatNo).length() == 1) {
                      f.Oasys_Flat_code__c = w.Project__c + ' ' + w.Cluster_hidden__c + ' ' + w.Name + ' ' + '000' + String.ValueOf(flatNo);
                    }
                    else {                   
                      f.Oasys_Flat_code__c = w.Project__c + ' ' + w.Cluster_hidden__c + ' ' + w.Name + ' ' + String.ValueOf(flatNo);
                    }
                    
                    if(!FlatStatset.contains(f.Unique_Flat_Key__c)) {
                      flatList.add(f);
                    }
                }
                
                if(w.Podium_Unit__c == 'Yes' && j < w.No_of_flats_floor__c.intValue()) {
                  startNum = flatNo;
                }
                else if(w.Podium_Unit__c == 'Yes' && j == w.No_of_flats_floor__c.intValue()) {
                  startNum = 100;               
                }
                else {
                  startNum = startNum + 100;
                }
                
               
                
            }
        }
        try {
           upsert flatList Unique_Flat_Key__c;
           // return 'TRUE';
        }
        catch (DmlException e) {
          // return e.getmessage();
          //System.debug('Upsert Failed' + e.getMessage());
        }
        
        /*********** End Create Inventory ******************/
    }
    

    
     Flat__c assignFlatAttributes(Id wingId, Integer fNo, String p, Integer flNo, String Column_Index){
        Flat__C flat = new Flat__C();
        Integer fromRange = 0;
        Integer toRange = 0;
        Decimal flat_cost = 0;
        String floorNumber = string.valueof(flNo);
        String floor;
        //get flat type details from View_Type_Assignment__c Object
        //first figure out the flat type of that particular flat by checking the flat type assignment patterns
        flat.Wing__c = wingId;
        flat.Flat_No__c = fNo;
        if(flNo == 0) {
          floor = 'ZERO';
          flat.Unique_Flat_Key__c = fNo + floor + string.valueof(wingId);
        }
        else {
          flat.Unique_Flat_Key__c = fNo + flNo + string.valueof(wingId);
        }
        flat.floor__C = flNo;
        String flatTypeId;
        
        
        
        system.debug('%%%%%%%%'  + wingFlatTypeMap);
        if(wingFlatTypeMap.containsKey(wingId)){
           /* if(wingFlatTypeMap.get(wingId).containsKey('All')){
                flat.Flat_Type__C = wingFlatTypeMap.get(wingId).get('All').Flat_Type__r.Id;
                message = 'S01-Successfully assigned Flat type to Flat.\n';
            }*/
            if (wingFlatTypeMap.get(wingId).containsKey(Column_Index)){
                flat.Flat_Type__C = wingFlatTypeMap.get(wingId).get(Column_Index).Flat_Type__r.Id;
                message = 'S01-Successfully assigned Flat type to Flat.\n';
            }
            else if(wingFlatTypeMap.get(wingId).containsKey(p + Column_Index)){
                flat.Flat_Type__C = wingFlatTypeMap.get(wingId).get(p+Column_Index).Flat_Type__r.Id;
                message = 'S02-Successfully assigned Flat type to Flat.\n';
            }
            else if(wingFlatTypeMap.get(wingId).containsKey(p+floorNumber+Column_Index)){
                flat.Flat_Type__C = wingFlatTypeMap.get(wingId).get(p+floorNumber+Column_Index).Flat_Type__r.Id;
                message = 'S03-Successfully assigned Flat type to Flat.\n';
            }
            else if (wingFlatTypeMap.get(wingId).containsKey(floorNumber + Column_Index)){
                flat.Flat_Type__C = wingFlatTypeMap.get(wingId).get(floorNumber + Column_Index).Flat_Type__r.Id;
                message = 'S04-Successfully assigned Flat type to Flat.\n';
            } 
            if (flat.Flat_Type__C == null){
                message = 'E01-Check View_Type_Assignment__C Object: Flat Type Assignment does not exists for Flat No:' + fNo + ' in Wing:' + wingId + '\n';
            }
           
        }
        else {
            message = 'E02-Check View_Type_Assignment__C Object: No flat type assignment record exists for wing:' + wingId + '\n';
        }
        
        flatTypeId = string.valueof(flat.Flat_Type__C);
        
        //get view type details from View_Type_Assignment__c Object
         //system.debug('%%%%%%%%'  + wingViewTypeMap);      
        if(wingViewTypeMap.containsKey(wingId)){
           /* if(wingViewTypeMap.get(wingId).containsKey(flatTypeId +'All')){
                flat.View__c = wingViewTypeMap.get(wingId).get(flatTypeId  + 'All').View__c;
                message = message + 'S05-Successfully assigned View to Flat.\n';
            }*/
            if (wingViewTypeMap.get(wingId).containsKey(flatTypeId  + Column_Index)){
                flat.View__c = wingViewTypeMap.get(wingId).get( flatTypeId  +Column_Index).View__c;
                message = 'S05-Successfully assigned View to Flat.\n';
            }
            else if(wingViewTypeMap.get(wingId).containsKey(flatTypeId + p + Column_Index)){
                flat.View__c = wingViewTypeMap.get(wingId).get(flatTypeId + p + Column_Index).View__c;
                message = message  + 'S06-Successfully assigned View to Flat.\n';
            }
            else if (wingViewTypeMap.get(wingId).containsKey(flatTypeId + floorNumber + Column_Index)){
                 flat.View__c = wingViewTypeMap.get(wingId).get(flatTypeId + floorNumber + Column_Index).View__c;
                 message = message  + 'S07-Successfully assigned View to Flat.\n';
            }
            else if (wingViewTypeMap.get(wingId).containsKey(flatTypeId + p + floorNumber + Column_Index)){
                 flat.View__c = wingViewTypeMap.get(wingId).get(flatTypeId + p + floorNumber + Column_Index).View__c;
                 message = message  + 'S08-Successfully assigned View to Flat.\n';
            }
            if (flat.View__c == null){
                 message = message  + 'E03-View Type doesnt exists for Flat No:' + fNo + ' in Wing:' + wingId + '\n';
            }
        }
        else {
            message = message + 'E04-Check View_Type_Assignment__C Object: No view type assignment record exists Flat No:' + fNo + 'in wing: ' + wingId + '\n';
        }
        //get base attributes for that particulat flat type from Flat_Type__C Object
        if(wingFlatDetMap.containsKey(wingId)){
            
            if(wingFlatDetMap.get(wingId).containsKey(flatTypeId)){
                flat.Base_Rate_Sq_Ft_Rs__c = wingFlatDetMap.get(wingId).get(flatTypeId).Base_Rate_Sq_Ft__c;
                flat.Carpet_Area__c = wingFlatDetMap.get(wingId).get(flatTypeId).Carpet_Area__c;
                flat.Salable_Area__c = wingFlatDetMap.get(wingId).get(flatTypeId).Salable_Area__c;
                flat.Token_Amount_Rs__c = wingFlatDetMap.get(wingId).get(flatTypeId).Token_Amount_Rs__c;
                flat.Club_Charges_Rs__c = wingFlatDetMap.get(wingId).get(flatTypeId).Club_Charge_Rs__c;
                flat.Infrastructure_Cost_Rs__c = wingFlatDetMap.get(wingId).get(flatTypeId).Infrastructure_Rs__c;
                flat.Infrastructure_Cost2_Rs__c = wingFlatDetMap.get(wingId).get(flatTypeId).Infrastructure_2_Rs__c;
                message = message  + 'S09-Successfully assigned rate values to Flat.\n';                
            }
            else{
              
               message = message + 'E05-Check Flat_Type__C object: No flat details record exists for wing:' + wingId + 'flat Id:' +flat.Flat_Type__C + '\n';
            }
        }
        else {
            
            message = message + 'E06-Check Flat_Type__C object: No flat details record exists for wing:' + wingId + '\n';
        }
        
        //get rate card details 
        //get rate card details for view rates
        if(wingRateViewTypeMap.containsKey(wingId)){        
            if(wingRateViewTypeMap.get(wingId).containsKey(flatTypeId + flat.View__c)){               
                flat.Premium_Sq_Ft_Rs__c = wingRateViewTypeMap.get(wingId).get(flatTypeId + flat.View__c).View_Rate_Sq_Ft__c;  
                message = message  + 'S10-Successfully assigned Premium View Rate to Flat.\n';                
            }
            else{
                flat.Premium_Sq_Ft_Rs__c = 0;
                message = message + 'E07-Check Rate_Card__C object: No premium view rate details record exists for wing:' + wingId + 'flat Id:' +flat.Flat_Type__C + '\n';
            }
        }
        else {
            flat.Premium_Sq_Ft_Rs__c = 0;
            message = message + 'E08-Check Rate_Card__C object: No rate card details record exists for wing:' + wingId + '\n';
        }
        
        //get rate card details for floor rise rates
        if(wingRateFloorTypeMap.containsKey(wingId)){
            if (wingRateFloorTypeMap.get(wingId).containsKey(flatTypeId + floorNumber)){
                 Decimal sum = 0;
                 for(Integer j=1 ;j<=Integer.valueOf(floorNumber); j++) {
                   if(wingRateFloorTypeMap.get(wingId).containsKey(flatTypeId + string.valueof(j))) {
                     sum = sum + wingRateFloorTypeMap.get(wingId).get(flatTypeId + string.valueof(j)).Floor_Rise_Sq_Ft__c;
                   }
                   else {
                     sum = sum + 0;
                   }
                 }
                 //flat.Floor_Rise_Sq_Ft_Rs__c = wingRateFloorTypeMap.get(wingId).get(flatTypeId + floorNumber).Floor_Rise_Sq_Ft__c;                
                 flat.Floor_Rise_Sq_Ft_Rs__c = sum;
                 message = message  + 'S11-Successfully assigned Floor rise Rate to Flat.\n';          
            } 
           else {
                flat.Floor_Rise_Sq_Ft_Rs__c = 0;               
                message = message  + 'E09-Check Rate_Card__C Object: Floor rise rate details does not exists for Flat No:' + fNo + ' in Wing:' + wingId + '\n';
            }
        }
        else {
            flat.Floor_Rise_Sq_Ft_Rs__c = 0;
            message = message  + 'E10-Check Rate_Card__C Object: No rate card details record exists for wing:' + wingId + '\n';
        }
            
        flat_cost = flat.Salable_Area__c * (flat.Base_Rate_Sq_Ft_Rs__c + flat.Floor_Rise_Sq_Ft_Rs__c + flat.Premium_Sq_Ft_Rs__c);
        if(flat_cost != 0) { 
          flat.Flat_Cost_Rs__c =  flat_cost;
          flat.Consideration_Rs__c = flat.Flat_Cost_Rs__c + flat.Infrastructure_Cost_Rs__c;
          message = message  + 'S12-Successfully assigned Flat Cost to Flat.\n' + '-->All Flat attributes assigned successfully to flat record.';     
        }
        else {
          message = message  + 'E11-Failed assigned Flat Cost to Flat as one of rate elements is missing.\n' + '-->Errors in assigning flat attributes to Flat record.';
        }
        flat.Message__c = message;
        return flat;
     } 
     
    global void finish(Database.BatchableContext BC){
        // send batch execution email;      
    }
}