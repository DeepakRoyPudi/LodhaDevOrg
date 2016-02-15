/**********************************************************************************
Name:  CM_TAT_CalculationController
Copyright © 2013  Lodha Group
===================================================================================
===================================================================================
Purpose:
-------
Controller For CM_TAT_Calculation Case Trigger
===================================================================================
===================================================================================
History
-------
VERSION    AUTHOR              DATE               DETAIL              
1.0 -   CG Dev Team          05/12/2013      INITIAL DEVELOPMENT
1.1     Asmita               22/09/2014      Resolve Too Many SOQL Exception while executing test class of EditCasesForRMController
**********************************************************************************/

public class CM_TAT_CalculationController{
    
    // 1.1 - Asmita
    /*CM_Tat_Calculation__c parentTatHours = [SELECT CaseType__c,Id,Legal__c,Name,Non_Legal__c FROM CM_Tat_Calculation__c WHERE Name = 'Parent' OR CaseType__c = 'Parent' LIMIT 1];
    CM_Tat_Calculation__c childTatHours = [SELECT CaseType__c,Id,Legal__c,Name,Non_Legal__c FROM CM_Tat_Calculation__c WHERE Name = 'Child' OR CaseType__c = 'Child' LIMIT 1];
    CM_Tat_Calculation__c aiFTMTatHours = [SELECT CaseType__c,Id,Legal__c,Name,Non_Legal__c FROM CM_Tat_Calculation__c WHERE Name = 'AIFTM' OR CaseType__c = 'AIFTM' LIMIT 1];
    CM_Tat_Calculation__c aiSPOCTatHours = [SELECT CaseType__c,Id,Legal__c,Name,Non_Legal__c FROM CM_Tat_Calculation__c WHERE Name = 'AISPOC' OR CaseType__c = 'AISPOC' LIMIT 1];*/
    CM_Tat_Calculation__c parentTatHours = CM_Tat_Calculation__c.getValues('Parent');
    CM_Tat_Calculation__c childTatHours = CM_Tat_Calculation__c.getValues('Child');
    CM_Tat_Calculation__c aiFTMTatHours = CM_Tat_Calculation__c.getValues('AIFTM');
    CM_Tat_Calculation__c aiSPOCTatHours = CM_Tat_Calculation__c.getValues('AISPOC');
    
    // 1.1 - Asmita
    //Id recTypeActionItemId = [SELECT Id,Name FROM RecordType WHERE Name = 'CM_Action_Item'].Id;
    //Id recTypeChildCaseId = [SELECT Id,Name FROM RecordType WHERE Name = 'CM_Child_Case'].Id;
    Id recTypeActionItemId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CM_Action_Item').getRecordTypeId();
    Id recTypeChildCaseId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CM_Child_Case').getRecordTypeId();
    
    List<CM_New_TAT_Calculation__c> tatList = [SELECT Hours__c,ReqCombinations__c FROM CM_New_TAT_Calculation__c];
    
    public void parentTatCal(List<Case> pList){
        
        List<Case> csList = new List<Case>();
        
        for(Case cs : pList){
        
            String pCombi = cs.Request_for_L1__c+cs.Request_for_L2__c+cs.Request_for_L3_a__c+cs.Request_for_L3__c;
            
            system.debug('## pCombi : '+pCombi);
            
            for(CM_New_TAT_Calculation__c tat : tatList){
            
              system.debug('## tat.ReqCombinations__c : '+tat.ReqCombinations__c);
              system.debug('## tat.Hours__c : '+tat.Hours__c);
              
                if(pCombi == tat.ReqCombinations__c){
                    cs.Remaining_Hours__c = tat.Hours__c;
                    system.debug('## tat.ReqCombinations__c : '+tat.ReqCombinations__c);
                    system.debug('## tat.Hours__c : '+tat.Hours__c);
                
            
                    double d = cs.Remaining_Hours__c * 3600;
                    Integer s = Integer.valueof(d); 
                    cs.CM_TAT__c = cs.CreatedDate.addSeconds(s);
                    
                    system.debug('## cs.CM_TAT__c : '+cs.CM_TAT__c);
                                
                    double dd = BusinessHours.diff(cs.BusinessHoursId, cs.CreatedDate, cs.CM_TAT__c)/1000;
                    Integer ss = Integer.valueof(dd); 
                    cs.CM_TAT__c = cs.CreatedDate.addSeconds(ss);
                    
                    system.debug('## cs.CM_TAT__c : '+cs.CM_TAT__c);
                    
                    csList.add(cs);
                
                }
                
            }
        }
        
        update csList;
        
    }
    
    List<Case> caseList{get;set;} 
    List<Case> childList{get;set;}
    List<Case> pList{get;set;} 
    set<Id> parentIdLst = new set<Id>();
    set<Id> caseIdLst = new set<Id>();
    
    Map<id,Set<id>> aiMapList = new Map<id,Set<id>>();
    set<id> chMapList = new set<id>();
    
    public void childTatCal(List<Case> cList){
        
        List<Case> csChildList = new List<Case>();
        List<Case> csChildParentList = new List<Case>();
        List<Case> csParentList = new List<Case>();
        
        try{
        if(cList != null && cList.size() > 0)
        for(Case cs : cList){
            chMapList = aiMapList.get(cs.ParentId);
            if(chMapList == NULL){
                chMapList = new Set<Id>();
            }
            chMapList.add(cs.id);
            aiMapList.put(cs.ParentId, chMapList );
                
        }
        
        for(id ps : aiMapList.KeySet()){
            parentIdLst.add(ps);
        }
        
        
        system.debug('## childList : '+parentIdLst.size());
        system.debug('## childList : '+parentIdLst);
        
        childList = [Select Id, RecordTypeId, CreatedDate, Remaining_Hours__c, ParentId, CM_TAT__c from Case Where Id IN: parentIdLst];
        
        system.debug('## childList : '+childList.size());
        
        if(childList != null && childList.size() > 0){
            
            for(Case cs : cList){
                for(Case ps : childList){ 
                
                    system.debug('## ps.Id : '+ps.Id);
                    if(Cs.ParentId == ps.Id){
                    
                        System.debug('## inside if conditon : '+ps.Id);
                        String pCombi = cs.Request_for_L1__c+cs.Request_for_L2__c+cs.Request_for_L3_a__c+cs.Request_for_L3__c;
            
                        system.debug('## pCombi : '+pCombi);
                        
                    for(CM_New_TAT_Calculation__c tat : tatList){
        
                        system.debug('## tat.ReqCombinations__c : '+tat.ReqCombinations__c);
                        system.debug('## tat.Hours__c : '+tat.Hours__c);
                        
                        if(pCombi == tat.ReqCombinations__c){
                            cs.Remaining_Hours__c = tat.Hours__c;
                            system.debug('## tat.ReqCombinations__c : '+tat.ReqCombinations__c);
                            system.debug('## tat.Hours__c : '+tat.Hours__c);
                        
                            double d = cs.Remaining_Hours__c * 3600;
                            Integer s = Integer.valueof(d); 
                            cs.CM_TAT__c = cs.CreatedDate.addSeconds(s);
                            
                            system.debug('## cs.CM_TAT__c : '+cs.CM_TAT__c);
                            
                            double dd = BusinessHours.diff(cs.BusinessHoursId, cs.CreatedDate, cs.CM_TAT__c)/1000;
                            Integer ss = Integer.valueof(dd); 
                            cs.CM_TAT__c = cs.CreatedDate.addSeconds(ss);
                            
                            system.debug('## cs.CM_TAT__c : '+cs.CM_TAT__c);
                            
                            if(cs.CM_TAT__c > ps.CM_TAT__c){
                                ps.Remaining_Hours__c = cs.Remaining_Hours__c;
                                ps.CM_TAT__c = cs.CM_TAT__c;
                            }
                            
                            system.debug('## ps.Remaining_Hours__c : '+ps.Remaining_Hours__c);
        
                            caseIdLst.add(ps.id);
                            csChildList.add(cs);
                            csChildParentList.add(ps);
                        }
                    
                    }
                        
                    }
                }    
            }
            
            update csChildList;
            update csChildParentList;
            
            updateParentCase(csChildParentList);
            
        }
        }catch(Exception ex){
            System.debug('Error = ' + ex.getMessage());
        }
    }
    
    public void updateParentCase(List<Case> cList){
        
        List<Case> csChildList = new List<Case>();
        List<Case> csChildParentList = new List<Case>();
        List<Case> csParentList = new List<Case>();
        
        
        for(Case cs : cList){
            chMapList = aiMapList.get(cs.ParentId);
            if(chMapList == NULL){
                chMapList = new Set<Id>();
            }
            chMapList.add(cs.id);
            aiMapList.put(cs.ParentId, chMapList );
                
        }
        
        for(id ps : aiMapList.KeySet()){
            parentIdLst.add(ps);
        }
        
        system.debug('@@## childList : '+parentIdLst.size());
        system.debug('@@## childList : '+parentIdLst);
        
        childList = [Select Id, RecordTypeId, CreatedDate, Remaining_Hours__c, ParentId, CM_TAT__c from Case Where Id IN: parentIdLst];
        
        system.debug('@@## childList : '+childList.size());
        
        if(childList.size() > 0){
            
            for(Case cs : cList){
                for(Case cps : childList){ 
                    
                    system.debug('@@## cPs.Remaining_Hours__c  : '+cPs.Remaining_Hours__c );
                    system.debug('@@## cPs.CM_TAT__c : '+cPs.CM_TAT__c );
                    
                    if(cs.ParentId == cps.Id){
                        system.debug('@@## cs.Id : '+cs.Id);
                        system.debug('@@## cs.ParentId : '+cs.ParentId);
                        system.debug('@@## cPs.Id : '+cPs.Id);
                        if(cs.CM_TAT__c > cps.CM_TAT__c ){
                            cps.Remaining_Hours__c = cs.Remaining_Hours__c;
                            cps.CM_TAT__c = cs.CM_TAT__c;
                        } 
                        
                        system.debug('@@## cPs.Remaining_Hours__c  : '+cPs.Remaining_Hours__c );
                        system.debug('@@## cPs.CM_TAT__c : '+cPs.CM_TAT__c );
                        
                        csParentList.add(cps); 
                        //update cps;
                    } 
                    
                    
                }
            }
            
            system.debug('@@## csParentList : '+csParentList);
            
            update csParentList;
            
        }
    }
    
    public void duplicateTatCal(List<Case> dList){
    
    }
    
    
}