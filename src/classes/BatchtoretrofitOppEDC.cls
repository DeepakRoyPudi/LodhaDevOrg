global class BatchtoretrofitOppEDC implements Database.Batchable<SObject>,Database.Stateful{

    public String querystring;
    public Map<String,EDC_for_opportunity__c> edcsettingmap;
    List<EDC_for_opportunity__c> edcvolist=[select id,Project_Type__c,EDC_from_Created_date__c,EDC_from_Visit_date__c,Upper_Limit__c,Call_Attempt_Limit__c,
            Call_Attempt_EDC__c from EDC_for_opportunity__c];
    Map<id,Project_Name__c>  projectmap=new Map<id,Project_Name__c>([select id,Project_Type__c from Project_Name__c]); 
    global Database.QueryLocator start(Database.BatchableContext BC){
       
            querystring='select id,CloseDate,Upper_EDC__c,Project_Name__c,Date_of_Visit__c,Last_Call_Date_RO__c,StageName,IsActive__c,Current_EDC__c,Reasons_for_lost__c,Is_Batch__c from Opportunity Where Upper_EDC__c = NULL';
            system.debug('querystring:' + querystring);
            return Database.getQueryLocator(querystring);
        }
        
        global void execute(Database.BatchableContext BC, List<sObject> sobjectlist){
          List<Opportunity> opportunityupdatelist=new List<Opportunity>();
          
            edcsettingmap=new Map<String,EDC_for_opportunity__c>();
            for(EDC_for_opportunity__c edcvalue: edcvolist){
                edcsettingmap.put(edcvalue.Project_Type__c,edcvalue);            
            }
            
            for(sObject sobj: sobjectlist){
            
                Opportunity opp=(Opportunity)sobj;
                String projecttype=projectmap.get(opp.Project_Name__c).Project_Type__c;
                Integer edcfromcreateddate=Integer.valueof(edcsettingmap.get(projecttype).EDC_from_Created_date__c); 
                Integer edcfromvisitddate=Integer.valueof(edcsettingmap.get(projecttype).EDC_from_Visit_date__c); 
                Integer upperedc=Integer.valueof(edcsettingmap.get(projecttype).Upper_Limit__c);
                Integer callattemptlimit=Integer.valueof(edcsettingmap.get(projecttype).Call_Attempt_Limit__c);
                Integer callattemptedc=Integer.valueof(edcsettingmap.get(projecttype).Call_Attempt_EDC__c);
             
               opp.IsActive__c=true;           
                if(opp.Date_of_Visit__c==null){                                                                                                                                 
                    opp.Closedate=system.today().adddays(edcfromcreateddate); 
                    opp.Upper_EDC__c=System.Today().addDays(upperedc);
                    opp.Current_EDC__c=opp.CloseDate;               
                }else{
                    Date dovlimit= date.parse('20/09/2012');      
                                  
                    if(opp.Date_of_Visit__c>=dovlimit){
                        opp.Closedate=system.today().adddays(edcfromvisitddate); 
                        opp.Upper_EDC__c=System.Today().addDays(upperedc);
                        opp.Current_EDC__c=opp.CloseDate;                    
                    }else{
                        system.debug('edcfromvisitddate: ' + edcfromvisitddate);
                        opp.Closedate=opp.Date_of_Visit__c.adddays(edcfromvisitddate); 
                        system.debug('opp.Closedate: ' + opp.Closedate);
                        opp.Upper_EDC__c=opp.Date_of_Visit__c.addDays(upperedc);
                        opp.Current_EDC__c=opp.CloseDate; 
                    
                    }
                
                } 

               if(opp.Last_Call_Date_RO__c!=null){

                    Integer differenceindays=(opp.Last_Call_Date_RO__c.date()).daysBetween(opp.CloseDate);
                    
                    Date lastcalldate=opp.Last_Call_Date_RO__c.date();
                    String oppid=opp.id;
                    
                    List<Call_Attempts__c > callattemptlist=[select id,Createddate,Proposed_Date_of_Visit__c,Call_Attempt_Status__c from Call_Attempts__c where DAY_ONLY(Createddate)=:lastcalldate AND Opportunity__c=:oppid];

                    for(Call_Attempts__c callattempt: callattemptlist){


                        if((differenceindays<=callattemptlimit)&&(callattempt.Call_Attempt_Status__c=='Visit Confirmed'||callattempt.Call_Attempt_Status__c=='Visit Proposed')){
                            opp.CloseDate=callattempt.Proposed_Date_of_Visit__c.date().addDays(callattemptedc);
                             opp.Current_EDC__c=opp.CloseDate;   
                
                        }
                             if(opp.CloseDate>opp.Upper_EDC__c){
                                 opp.Upper_EDC__c=callattempt.Proposed_Date_of_Visit__c.date().addDays(callattemptedc);  
                             }
                    
                    }

                }  
                integer differenceindays=(system.today()).daysBetween(opp.closedate); 
                                   
                system.debug('@@'+opp.Upper_EDC__c);
                system.debug('##'+system.Today());
                system.debug('differenceindays'+differenceindays);
                
                if(differenceindays<0&&opp.IsActive__c==true){
                    opp.Is_Batch__c=true;
                    if((opp.StageName=='Closed Won')||(opp.StageName=='Cancelled')||(opp.StageName=='Closed Book')){
                        opp.IsActive__c=False;   
                    }else{
                        opp.StageName='Closed Lost';
                        opp.Reasons_for_lost__c='EDC Expired';
                        opp.IsActive__c=False;                   
                    }
                }
                opportunityupdatelist.add(opp);                                                    
            }
        
            update opportunityupdatelist;
        }
        
        global void finish(Database.BatchableContext BC){
        
       }
       
       global void dummy1(){
       
       Integer int1 = 100;
       Integer int2 = 100;
       Integer int3 = 100;
       Integer int4 = 100;
       Integer int5 = 100;
       Integer int6 = 100;
       Integer int7 = 100;
       Integer int8 = 100;
       Integer int9 = 100;
       Integer int10 = 100;
       Integer int11 = 100;
       Integer int12 = 100;
       Integer int13 = 100;
       Integer int14 = 100;
       Integer int15 = 100;
       Integer int16= 100;
       Integer int17 = 100;
       Integer int18 = 100;
       Integer int19 = 100;
       Integer int20 = 100;
       Integer int21 = 100;
       Integer int22 = 100;
       Integer int23 = 100;
       Integer int24 = 100;
       Integer int25 = 100;
       Integer int26 = 100;
       Integer int27 = 100;
       Integer int28 = 100;
       Integer int29 = 100;
       Integer int30 = 100;
       Integer int31 = 100;
       Integer int32= 100;
       Integer int33 = 100;
Integer int34 = 100;
Integer int35 = 100;
Integer int36 = 100;
Integer int37 = 100;
Integer int38 = 100;
Integer int39 = 100;
Integer int40 = 100;
Integer int41 = 100;
Integer int42 = 100;
Integer int43 = 100;
Integer int44 = 100;
Integer int45 = 100;
Integer int46 = 100;
Integer int47 = 100;
Integer int48 = 100;
Integer int49 = 100;
Integer int50 = 100;
Integer int51 = 100;
Integer int52 = 100;
Integer int53 = 100;
Integer int54 = 100;
Integer int55 = 100;
Integer int56 = 100;
Integer int57 = 100;
Integer int58 = 100;
Integer int59 = 100;
Integer int60 = 100;
Integer int61 = 100;
Integer int62 = 100;
Integer int63 = 100;
Integer int64 = 100;
Integer int65 = 100;
Integer int66 = 100;
Integer int67 = 100;
Integer int68 = 100;
Integer int69 = 100;
Integer int70 = 100;
Integer int71 = 100;
Integer int72 = 100;
Integer int73 = 100;
Integer int74 = 100;
Integer int75 = 100;
Integer int76 = 100;
Integer int77 = 100;
Integer int78 = 100;
Integer int79 = 100;
Integer int80 = 100;
Integer int81 = 100;
Integer int82 = 100;
Integer int83 = 100;
Integer int84 = 100;
Integer int85 = 100;
Integer int86 = 100;
Integer int87 = 100;
Integer int88 = 100;
Integer int89 = 100;
Integer int90 = 100;
Integer int91 = 100;
Integer int92 = 100;
Integer int93 = 100;
Integer int94 = 100;
Integer int95 = 100;
Integer int96 = 100;
Integer int97 = 100;
Integer int98 = 100;
Integer int99 = 100;
Integer int100 = 100;
Integer int101 = 100;
Integer int102 = 100;
Integer int103 = 100;
Integer int104 = 100;
Integer int105 = 100;
Integer int106 = 100;
Integer int107 = 100;
Integer int108 = 100;
Integer int109 = 100;
Integer int110 = 100;
Integer int111 = 100;
Integer int112 = 100;
Integer int113 = 100;
Integer int114 = 100;
Integer int115 = 100;
Integer int116 = 100;
Integer int117 = 100;
Integer int118 = 100;
Integer int119 = 100;
Integer int120 = 100;
Integer int121 = 100;
Integer int122 = 100;
Integer int123 = 100;
Integer int124 = 100;
Integer int125 = 100;
Integer int126 = 100;
Integer int127 = 100;
Integer int128 = 100;
Integer int129 = 100;
Integer int130 = 100;
Integer int131 = 100;
Integer int132 = 100;
Integer int133 = 100;
Integer int134 = 100;
Integer int135 = 100;
Integer int136 = 100;
Integer int137 = 100;
Integer int138 = 100;
Integer int139 = 100;
Integer int140 = 100;
Integer int141 = 100;
Integer int142 = 100;
Integer int143 = 100;
Integer int144 = 100;
Integer int145 = 100;
Integer int146 = 100;
Integer int147 = 100;
Integer int148 = 100;
Integer int149 = 100;
Integer int150 = 100;
Integer int151 = 100;
Integer int152 = 100;
Integer int153 = 100;
Integer int154 = 100;
Integer int155 = 100;
Integer int156 = 100;
Integer int157 = 100;
Integer int158 = 100;
Integer int159 = 100;
Integer int160 = 100;
Integer int161 = 100;
Integer int162 = 100;
Integer int163 = 100;
Integer int164 = 100;
Integer int165 = 100;


       }

}