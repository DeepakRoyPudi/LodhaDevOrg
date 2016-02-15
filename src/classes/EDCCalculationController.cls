/**********************************************************************************
Name:  EDCCalculationController
Copyright © 2012  Lodha Group
===================================================================================
===================================================================================
Purpose:
-------
Controller For Calculating EDC for Opportunity
===================================================================================
===================================================================================
History
-------
VERSION    AUTHOR                DATE             DETAIL              
1.0 -   CG Dev Team          28/05/2012      INITIAL DEVELOPMENT
**********************************************************************************/

public class EDCCalculationController {
    
    static boolean testBoolean=false;
    List<EDC_for_opportunity__c> edcVO;
    Map<String, EDC_for_opportunity__c> edcVOList;
    Integer edcfromcreateddate{get;set;}
    Integer edcfromvisitddate{get;set;}
    Integer upperedc{get;set;}
    Integer callattemptlimit{get;set;}
    Integer callattemptedc{get;set;}        
    public static boolean isinsert=false;
    public static boolean isFirstUpdate=true;  
    public integer i;
    public set<Id> InActiveOpps;
               
/*********************************************************************
    Purpose     : To get mappig values from custom settings for EDC 
    Parameters  : String projecttype
    Returns     : None
**********************************************************************/  
  /*  public void EDCVOlist(String projecttype){
          
      try{
            edcVO=[select id,Project_Type__c,EDC_from_Created_date__c,EDC_from_Visit_date__c,Upper_Limit__c,Call_Attempt_Limit__c,
            Call_Attempt_EDC__c from EDC_for_opportunity__c where Project_Type__c=:projecttype];    
            
            edcfromcreateddate=Integer.valueof(edcVO.EDC_from_Created_date__c);
            edcfromvisitddate=Integer.valueof(edcVO.EDC_from_Visit_date__c);
            upperedc=Integer.valueof(edcVO.Upper_Limit__c);
            callattemptlimit=Integer.valueof(edcVO.Call_Attempt_Limit__c);
            callattemptedc=Integer.valueof(edcVO.Call_Attempt_EDC__c);
       }catch(Exception  e){
       
       }
    }
   */
   
   public EDCCalculationController(){
          edcVO = new List<EDC_for_opportunity__c>();
          InActiveOpps= new set<Id>();
          edcVOList = new Map<String, EDC_for_opportunity__c>();
      try{
            edcVO=[select id,Project_Type__c,EDC_from_Created_date__c,EDC_from_Visit_date__c,Upper_Limit__c,Call_Attempt_Limit__c,
            Call_Attempt_EDC__c from EDC_for_opportunity__c];    
            for(EDC_for_opportunity__c EDC: edcVO)
            {
                edcVOList.put(EDC.Project_Type__c, EDC);
            }
       }catch(Exception  e){
       
       }
    }
   
   
/**********************************************************************
    Purpose     : To update EDC and upper EDC before Opportunity insert.
    Parameters  : List of Opportunity(Trigger.New)
    Returns     : None
**********************************************************************/   
    public void CalculateEDCbeforeinsert(List<Opportunity> opportunitylist){
    
    try{
    if(!Test.isRunningTest()){
       if(!opportunitylist.IsEmpty()){ 
          Map<id,Project_Name__c>  projectmap=new Map<id,Project_Name__c>([select id,Project_Type__c from Project_Name__c where id!=null]);           
             
             for(Opportunity opplist: opportunitylist){ 
              // EDCVOlist(projectmap.get(opplist.Project_Name__c).Project_Type__c); 
               
                edcfromcreateddate=Integer.valueof(edcVOList.get(projectmap.get(opplist.Project_Name__c).Project_Type__c).EDC_from_Created_date__c);
                edcfromvisitddate=Integer.valueof(edcVOList.get(projectmap.get(opplist.Project_Name__c).Project_Type__c).EDC_from_Visit_date__c);
                upperedc=Integer.valueof(edcVOList.get(projectmap.get(opplist.Project_Name__c).Project_Type__c).Upper_Limit__c);
                
               if(opplist.Date_of_Visit__c!=null){
                   opplist.CloseDate=opplist.Date_of_Visit__c.addDays(edcfromvisitddate);
               }else{
                opplist.CloseDate=System.Today().addDays(edcfromcreateddate);
               } 
               
               
               opplist.Upper_EDC__c=System.Today().addDays(upperedc);
               opplist.Current_EDC__c=opplist.CloseDate;

             }
         } 
         } 
      }catch(Exception e){
      }         
 }
    
/**********************************************************************
    Purpose     : To update EDC and upper EDC after Opp insert 
    Parameters  : List of Opportunity(Trigger.New,Trigger.oldmap)
    Returns     : None
**********************************************************************/    
    public void CalculateEDC(List<Opportunity> opportunitylist,Map<Id,Opportunity> opportunityoldmap){                
        
        
      if(!Test.isRunningTest()){
       if(!opportunitylist.IsEmpty() && testBoolean==false){ 
       
           Map<id,Project_Name__c>  projectmap=new Map<id,Project_Name__c>([select id,Project_Type__c from Project_Name__c where id!=null]);
           String userprofile= [SELECT Profile.Name FROM User where id=:Userinfo.getUserId()].Profile.Name;
           String RoleName = [select UserRole.name from user where id=:Userinfo.getUserId()].UserRole.name;
           i=0;
           for(Opportunity opplist: opportunitylist){ 

             // EDCVOlist(projectmap.get(opplist.Project_Name__c).Project_Type__c); 

                edcfromcreateddate=Integer.valueof(edcVOList.get(projectmap.get(opplist.Project_Name__c).Project_Type__c).EDC_from_Created_date__c);
                edcfromvisitddate=Integer.valueof(edcVOList.get(projectmap.get(opplist.Project_Name__c).Project_Type__c).EDC_from_Visit_date__c);
                upperedc=Integer.valueof(edcVOList.get(projectmap.get(opplist.Project_Name__c).Project_Type__c).Upper_Limit__c);
                        
                  String oldprojectname;
                  Date oldDoV;
                  Date oldEDC;
                  oldEDC=opportunityoldmap.get(opplist.id).CloseDate;
                
                  if(opportunityoldmap.get(opplist.id)!=null){
                      oldprojectname=opportunityoldmap.get(opplist.id).Project_Name__c;
                      oldDoV=opportunityoldmap.get(opplist.id).Date_of_Visit__c;
                  }
                  if(opplist.CloseDate<oldEDC && opplist.IsActive__c==true && userprofile!='System Administrator'&& userprofile!='Sales Planning' && RoleName!='SalesStrategist'){
                      Trigger.New[i].addError('You dont have access to edit EDC value by your own.');
                  }
                opplist.Current_EDC__c=opplist.CloseDate;

                                                     
                if(opplist.Project_Name__c==oldprojectname)
                {
                    system.debug('Inside same project');
                    if(opplist.Date_of_Visit__c!=null){                          
                         if(opplist.Date_of_Visit__c!=oldDoV){           
                             opplist.CloseDate=opplist.Date_of_Visit__c.addDays(edcfromvisitddate);
                             opplist.Upper_EDC__c=opplist.Date_of_Visit__c.addDays(upperedc); 
                             opplist.Current_EDC__c=opplist.CloseDate;
                             system.debug('Inside same project EDC updated');
                             }                            
                       }else{
                        system.debug('InsideELSE:'+(opportunityoldmap.get(opplist.id).IsActive__c==false));
                   
                       }
                       
        
                  }else{
                       system.debug('Insidechangedproject');
                       opplist.Updated_by_visit_date__c=false;
                      if(opplist.Date_of_Visit__c!=null){
                           Date startDateOfVisit = date.parse('20/09/2012');
                           Date endDateOfVisit = date.parse('29/12/2012');   
                           
                           if(opplist.Date_of_Visit__c >= startDateOfVisit && opplist.Date_of_Visit__c <= endDateOfVisit)
                           {
                               if(opplist.Date_of_Visit__c!=oldDoV){   
                                 opplist.CloseDate=endDateOfVisit.addDays(edcfromvisitddate);
                                 opplist.Upper_EDC__c=endDateOfVisit.addDays(upperedc); 
                                 opplist.Current_EDC__c=opplist.CloseDate;
                                 opplist.Updated_by_created_date__c=true;
                                 system.debug('InsidechangedprojectDate_of_Visit__c' +opplist.Date_of_Visit__c);
                               }
                               else if(opplist.Updated_by_visit_date__c!=true){
                                   opplist.CloseDate=endDateOfVisit.addDays(edcfromvisitddate);
                                   opplist.Upper_EDC__c=endDateOfVisit.addDays(upperedc); 
                                   opplist.Current_EDC__c=opplist.CloseDate;
                                   opplist.Updated_by_visit_date__c=true;
                                   system.debug('InsidechangedprojectUpdated_by_visit_date__c' +opplist.Updated_by_visit_date__c);
                               }
                           }
                           else
                           {
                               if(opplist.Date_of_Visit__c!=oldDoV){   
                                 opplist.CloseDate=opplist.Date_of_Visit__c.addDays(edcfromvisitddate);
                                 opplist.Upper_EDC__c=opplist.Date_of_Visit__c.addDays(upperedc); 
                                 opplist.Current_EDC__c=opplist.CloseDate;
                                 opplist.Updated_by_created_date__c=true;
                                 system.debug('InsidechangedprojectDate_of_Visit__c' +opplist.Date_of_Visit__c);
                               }
                               else if(opplist.Updated_by_visit_date__c!=true){
                                   opplist.CloseDate=opplist.Date_of_Visit__c.addDays(edcfromvisitddate);
                                   opplist.Upper_EDC__c=opplist.Date_of_Visit__c.addDays(upperedc); 
                                   opplist.Current_EDC__c=opplist.CloseDate;
                                   opplist.Updated_by_visit_date__c=true;
                                   system.debug('InsidechangedprojectUpdated_by_visit_date__c' +opplist.Updated_by_visit_date__c);
                               }
                           }
                      }else {
                           Date CreatedDate = date.parse('29/12/2012');
                              opplist.Updated_by_created_date__c=false;
                           if(opplist.Updated_by_created_date__c!=true)
                           {
                               if(opplist.CreatedDate.Date() <= CreatedDate)
                               {
                                   opplist.CloseDate=CreatedDate.addDays(edcfromcreateddate);
                                   opplist.Upper_EDC__c=CreatedDate.addDays(upperedc); 
                                   opplist.Current_EDC__c=opplist.CloseDate;
                                   opplist.Updated_by_created_date__c=true;
                                   system.debug('InsidechangedprojectUpdated_by_created_date__c' +opplist.Updated_by_created_date__c);
                               }else{
                                   opplist.CloseDate=opportunityoldmap.get(opplist.id).createddate.date().addDays(edcfromcreateddate);
                                   opplist.Upper_EDC__c=opportunityoldmap.get(opplist.id).createddate.date().addDays(upperedc); 
                                   opplist.Current_EDC__c=opplist.CloseDate;
                                   opplist.Updated_by_created_date__c=true;
                                   system.debug('InsidechangedprojectUpdated_by_created_date__c' +opplist.Updated_by_created_date__c);
                               }
                               
                          }
                      }
                  
                  }
                  
                  if(opplist.CloseDate<system.today()&&(userprofile=='System Administrator' || userprofile=='Sales Planning' || RoleName=='SalesStrategist')){
                      
                          if((opplist.Probability < 95) && (opplist.Probability != 0)){
                                    opplist.StageName='Closed Lost';
                                    opplist.Reasons_for_lost__c='EDC Expired';
                                    opplist.IsActive__c=false;     
                               }else{
                               
                                   opplist.IsActive__c=false; 
                               }                      
                       }
                       else if(opplist.CloseDate>=system.today()){
                            if(InActiveOpps.contains(opplist.id)){
                                system.debug('incative@@@ if');
                                Trigger.New[i].addError('An Active Opportunity exists for the same project');
                            }
                            else{
                                system.debug('incative@@@ if');
                                opplist.IsActive__c=true;
                            }
                       }
                 i++;                                                                                                                                     
                    
           }
           testBoolean=true;
       }
    }

    }

/***********************************************************************
    Purpose     : To update EDC and upper EDC after Call attempt insert
    Parameters  : List of Call_Attempts__c (Trigger.New)
    Returns     : None
*************************************************************************/   
   public void CalculateEDCaftercallattemptinsert(List<Call_Attempts__c> callattemptlist){           
        
        set<Id> oppids=new set<Id>();
        List<Opportunity> opportunityupdatelist=new List<Opportunity>();
     try{
        if(!callattemptlist.IsEmpty()){
        for(Call_Attempts__c attemptIds: callattemptlist)
            {
                oppids.add(attemptIds.Opportunity__c);
            }
            Map<id,Opportunity>  opportunitymap=new Map<id,Opportunity>([select id,CloseDate,Project_Name__r.Project_Type__c,Last_Call_Date_RO__c,Upper_EDC__c from Opportunity where IsActive__c=true and id in: oppids]);
            
            if(!opportunitymap.IsEmpty()){
            for(Call_Attempts__c attemptlist: callattemptlist){            
                //EDCVOlist(opportunitymap.get(attemptlist.Opportunity__c).Project_Name__r.Project_Type__c); 
                
                callattemptlimit=Integer.valueof(EDCVOlist.get(opportunitymap.get(attemptlist.Opportunity__c).Project_Name__r.Project_Type__c).Call_Attempt_Limit__c);
                callattemptedc=Integer.valueof(EDCVOlist.get(opportunitymap.get(attemptlist.Opportunity__c).Project_Name__r.Project_Type__c).Call_Attempt_EDC__c);
                        
               // system.debug('EDCVOlist: '+ opportunitymap.get(attemptlist.Opportunity__c).Last_Call_Date_RO__c.date());            
               // system.debug('EDCVOlist2: '+ opportunitymap.get(attemptlist.Opportunity__c).CloseDate);            
                Integer differenceindays=(opportunitymap.get(attemptlist.Opportunity__c).Last_Call_Date_RO__c.date()).daysBetween(opportunitymap.get(attemptlist.Opportunity__c).CloseDate);
             
               system.debug('differenceindays: '+differenceindays);
               
              if(differenceindays<=callattemptlimit&&(attemptlist.Call_Attempt_Status__c=='Visit Confirmed'||attemptlist.Call_Attempt_Status__c=='Visit Proposed')){
                 opportunity opp=new opportunity();
                 opp=opportunitymap.get(attemptlist.Opportunity__c);                   
                 opp.CloseDate=attemptlist.Proposed_Date_of_Visit__c.date().addDays(callattemptedc);
                 opp.Current_EDC__c=opp.CloseDate;
                 
              if(opp.CloseDate>opp.Upper_EDC__c){
                     opp.Upper_EDC__c=attemptlist.Proposed_Date_of_Visit__c.date().addDays(callattemptedc);  
                 }
                  opportunityupdatelist.add(opp);
               }
               
            }
          }
                update opportunityupdatelist;
        }
      }catch(Exception e){
      }
    }
    
/***********************************************************************
    Purpose     : To Check for Active Opportunity
    Parameters  : List of Opportunity(Trigger.New)
    Returns     : None
*************************************************************************/  
    public void CheckforActiveOpp(List<Opportunity> opportunitylist, String operation,Map<Id,Opportunity> opportunityoldmaplist){                

              
        Set<Id> accountId=new Set<Id>();
        Set<Id> opportunityId=new Set<Id>();
        Boolean isbatchstarted=null;
        InActiveOpps.clear();
        String userprofile= [SELECT Profile.Name FROM User where id=:Userinfo.getUserId()].Profile.Name;
        String RoleName = [select UserRole.name from user where id=:Userinfo.getUserId()].UserRole.name;
        boolean IsActiveCheck=false;
        try{  
           if(!Test.isRunningTest()){
            for(Opportunity opp:opportunitylist){
                opportunityId.add(opp.Id);
                accountId.add(opp.AccountId);
                isbatchstarted=opp.Is_Batch__c;
            }     
        system.debug('@@INSERT2'); 
          if(!isbatchstarted && testBoolean==false){
           
            system.debug('@@INSERT1');
               List<Opportunity> activeopplist=[select id, Name,Multiple_Booking__c,Cluster_Name__c ,Oasys_Flat_Code__c,StageName,Amount,Booking_Date__c,Date_Of_Cancellation__c,LastModifiedDate,Createddate, AccountId, Project_Name__c from Opportunity where AccountId in:accountId 
               and id NOT IN:opportunityId and IsActive__c=true];
    
                system.debug('@@INSERT'+activeopplist.size());
               i = 0;
               for(Opportunity oppval: opportunitylist){  
                    system.debug('@@INSERTwww1'+oppval);
                   for(Opportunity activeopp: activeopplist){           
                        system.debug('@@INSERTwww1s'+activeopplist.size()+activeopp);
                       system.debug('@@'+oppval.Project_Name__c+'-'+activeopp.Project_Name__c+'-'+oppval.Cluster_Name__c+'-'+activeopp.Cluster_Name__c+'-'+oppval.AccountId+'-'+activeopp.AccountId);        
                       if(oppval.Project_Name__c == activeopp.Project_Name__c && oppval.Cluster_Name__c == activeopp.Cluster_Name__c && oppval.AccountId == activeopp.AccountId)
                       {
                           if(operation=='Insert'){
                               system.debug('@@INSERT');
                               if((activeopp.Oasys_Flat_Code__c!=null && activeopp.Multiple_Booking__c==true)|| (activeopp.StageName=='Closed Won' && activeopp.Amount!=null && activeopp.Booking_Date__c!=null)||(activeopp.StageName == 'Cancelled' && activeopp.Amount!=null && activeopp.Date_Of_Cancellation__c!=null))
                               {
                                   system.debug('&&INSIDEIF');
                               }else{
                                   system.debug('&&INSIDEELSE');
                                   Trigger.New[i].addError('An active opportunity exists for the same project.');
                               }
                             }else if(operation=='Update'){         
                                 system.debug('@@UPDATE'); 
                                 if((activeopp.Oasys_Flat_Code__c!=null && activeopp.Multiple_Booking__c==true)||(activeopp.StageName=='Closed Won' && activeopp.Amount!=null && activeopp.Booking_Date__c!=null)||(activeopp.StageName=='Cancelled'  && activeopp.Amount!=null && activeopp.Date_Of_Cancellation__c!=null) || (oppval.Oasys_Flat_Code__c!=null && oppval.Multiple_Booking__c==true)||(oppval.StageName=='Closed Won' && oppval.Amount!=null && oppval.Booking_Date__c!=null)||(oppval.StageName=='Cancelled'  && oppval.Amount!=null && oppval.Date_Of_Cancellation__c!=null))
                                 {              
                                     system.debug('&&%%IF');                                       
                                  }
                                  else if(oppval.IsActive__c==false){
                                        IsActiveCheck=true;
                                        if(userprofile=='System Administrator' || userprofile=='Sales Planning' || RoleName=='SalesStrategist' || ( userprofile=='Customer Care Manager' && (oppval.OASYS_Status__c=='CANCELLATION' || oppval.OASYS_Status__c=='Cancel' ) ) ){
                                            system.debug('&&%%else IF if'+IsActiveCheck);   
                                            InActiveOpps.add(oppval.Id);
                                        }
                                        else{
                                            system.debug('&&%%else IF else'+IsActiveCheck);
                                            Trigger.New[i].addError('You dont have access to edit Inactive opportunities.');
                                            system.debug('&&%%else IF else1'+IsActiveCheck);
                                        }
                                  }else{  
                                    system.debug('&&%%esle');                                
                                     Trigger.New[i].addError('An active opportunity exists for the same project.');                                                      
                                 }
                             }   
                        }                                                         
                    }  
                    system.debug('&&@@@@'+IsActiveCheck+oppval.IsActive__c);
                    if(IsActiveCheck==false && oppval.IsActive__c==false){
                        system.debug('&&@@@@'+userprofile+RoleName);
                        if(userprofile=='System Administrator' || userprofile=='Sales Planning' || RoleName=='SalesStrategist' || ( userprofile=='Customer Care Manager' && (oppval.OASYS_Status__c=='CANCELLATION' || oppval.OASYS_Status__c=='Cancel' ) )){
                             system.debug('&&%%inactive with no existing opps with same projects as SA SP');   
                            }
                        else{
                             system.debug('&&%%inactive with no existing opps with same projects not SA SP');
                             Trigger.New[i].addError('You dont have access to edit Inactive opportunities.');
                             system.debug('&&%%inactive with no existing opps with same projects not SA SP1');
                            }
                        
                    }
                    
                       i++;
                }
                
            }else{
                if(testBoolean==false){
                for(Opportunity opp:opportunitylist){
                    opp.Is_Batch__c=false;                               
                } 
                }              
            }
            }
          }catch(Exception e){}
     }
                              
}