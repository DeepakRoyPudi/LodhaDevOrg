trigger CM_CaseLatestComment on CaseComment (after insert) {
    
    List<Case> cList = new list<Case>();
    List<Case> caseList = new list<Case>();
    set<Id> caseIds = new set<Id>();
   
    for(CaseComment caseComment:Trigger.new){
        caseIds.add(caseComment.parentId);
    }
    
    cList = [SELECT Id, Latest_Comment__c FROM Case WHERE Id IN: caseIds];
    
    
    if(cList.size() > 0){
        for(CaseComment caseComment : Trigger.new){
            for(Case cs : cList){
                if(caseComment.ParentId == cs.Id){
                    cs.latest_comment__c = caseComment.CommentBody; 
                    caseList.add(cs);
                }
            }
        }
        update caseList;
    }
}