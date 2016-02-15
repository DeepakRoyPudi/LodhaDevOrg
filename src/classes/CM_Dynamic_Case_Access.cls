/**********************************************************************************
Name:  CM_Dynamic_Case_Access 
Copyright © 2013  Lodha Group
===================================================================================
===================================================================================
Purpose:
-------
Controller For CM_Dynamic_Case_Access Case Trigger
===================================================================================
===================================================================================
History
-------
VERSION    AUTHOR              DATE               DETAIL              
1.0 -   CG Dev Team          11/12/2013      INITIAL DEVELOPMENT
**********************************************************************************/

public class CM_Dynamic_Case_Access {
    
    List<CaseShare> csList = new List<CaseShare>();
    
    public void childCaseInsert(List<Case> cNewList){
        
        //List<CaseShare> cShareList = [SELECT CaseAccessLevel,CaseId,Id,UserOrGroupId FROM CaseShare ];
        
        try{
        
            for(case cs : cNewList){
                CaseShare newCaseShare = new CaseShare(
                CaseId = cs.ParentId,
                UserOrGroupId = cs.OwnerId,
                CaseAccessLevel= 'Read'
                );
                
                csList.add(newCaseShare);
            }
            
            insert csList;
        }
            catch(Exception exp)
        {
            system.debug('## Exception occcured while inserting Child Case : '+exp); 
        }
    }
    
    public void childCaseUpdate(List<Case> cNewList, List<Case> cOldList){
        
        set<Id> parentIds = new set<Id>();
        List<CaseShare> csDelList = new List<CaseShare>();
       // List<CaseShare> cShareList = [SELECT CaseAccessLevel,CaseId,Id,UserOrGroupId FROM CaseShare limit 10000];
        
        try{
        
            for(case cs : cNewList){
                for(case c : cOldList){
                    system.debug('##@@ c.OldOwnerId__c: '+c.OldOwnerId__c);
                    system.debug('##@@ cs.OwnerId : '+cs.OwnerId );
                    
                    if(c.OldOwnerId__c != cs.OwnerId){
                       
                        CaseShare newCaseShare = new CaseShare(
                        CaseId = cs.ParentId,
                        UserOrGroupId = cs.OwnerId,
                        CaseAccessLevel= 'Read'
                        );
                        
                        csList.add(newCaseShare);
                            
                        for(CaseShare cShareDel : [SELECT CaseAccessLevel,CaseId,Id,UserOrGroupId FROM CaseShare limit 10000]){
                            if((cShareDel.UserOrGroupId == c.OldOwnerId__c) && (cShareDel.CaseId == c.ParentId)){
                                csDelList.add(cShareDel);    
                            }
                        } 
                        
                    }
                }
            }
           
            insert csList;
            delete csDelList;
        }
            catch(Exception exp)
        {
            system.debug('## Exception occcured while updating Child Case : '+exp); 
        }
    }
}