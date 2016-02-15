/**********************************************************************************
Name:  CM_DuplicateCaseController 
Copyright © 2013  Lodha Group
===================================================================================
===================================================================================
Purpose:
-------
Controller For CM_DuplicateCaseController VF page 
===================================================================================
===================================================================================
History
-------
VERSION    AUTHOR                DATE             DETAIL              
1.0 -   CG Dev Team          02/12/2013      INITIAL DEVELOPMENT
**********************************************************************************/

public with sharing class CM_DuplicateCaseController {
    
    public Id caseId{get;set;}
    public Id recTypeDuplicateId{get;set;}
    public Case caseUpdate{get;set;}
    public boolean showSuccess{get;set;}
    
    public CM_DuplicateCaseController (ApexPages.StandardController controller) {
    
        caseId = ApexPages.currentPage().getParameters().get('caseId');
        
        caseUpdate = [SELECT Id, isDuplicate__c, RecordTypeId, Existing_Parent_Case__c FROM Case WHERE Id =: caseId LIMIT 1];
        recTypeDuplicateId = [SELECT Id,Name FROM RecordType WHERE Name = 'CM_Dupilcate' LIMIT 1].Id;  
        
        showSuccess = false;
    }
    
    public pageReference Save(){
        try{
            if(caseUpdate.Existing_Parent_Case__c != NULL && caseUpdate.Existing_Parent_Case__c != caseUpdate.Id){
                caseUpdate.isDuplicate__c = true;
                caseUpdate.RecordTypeId = recTypeDuplicateId;
                update caseUpdate;
                showSuccess = true;
            }
        } catch(DmlException e) {
            //System.debug('The following exception has occurred: ' + e.getMessage());
            ApexPages.addMessages(e);
        }
        
        return null;
    }

}