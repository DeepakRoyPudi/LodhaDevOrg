/*
*        Description : Case Trigger Handler
* 
*        Version     Date          Author             Description
*        1.0         19/06/2014    Asmita(Eternus)    Intial Draft
*        1.1         18/11/2014    Anupam Agrawal     Case Mangement validation on "Date Confirm Registration" 
*        1.2         25/11/2014    Asmita             Webservice callout to get the voice ID to attach to the case created by HNI
*        1.3         04/12/2014    Anupam             Added '&&' condition
*/

public class CaseTriggerHandler {
	
    public void onBeforeInsert(List<Case> lstCase)
    {
    	//1.1 and 1.3 added "&&" condition
    	Trigger_Execution__c  objTriggerExecution = Trigger_Execution__c.getInstance('CaseManagementConfirmRegistration');
		if(objTriggerExecution != null && objTriggerExecution.execute__c)
		{
    		CaseManagementConfirmRegistration objCMCR = new CaseManagementConfirmRegistration();
    		objCMCR.confirmRegistrationDate(lstCase);
		}
		// 1.2
		//WebserviceCalloutForHniCasesHelper objWebserviceCallout = new WebserviceCalloutForHniCasesHelper();
		//objWebserviceCallout.getVoiceIdFromJava(lstCase);
    }
    
    public void onBeforeUpdate(Map<id, Case> mapOldCase, Map<id, Case> mapNewCase){
    	
        RestrictCaseOriginUpdate oRestrictCaseOrigin = new RestrictCaseOriginUpdate();
        oRestrictCaseOrigin.checkCaseOrigin(mapOldCase, mapNewCase); 
        
        UpdateL3Value oUpdateL3Value = new UpdateL3Value();
        oUpdateL3Value.replaceL3WithNull(mapOldCase, mapNewCase);
        
        Trigger_Execution__c  objTriggerExecution = Trigger_Execution__c.getInstance('CaseManagementConfirmRegistration');
		//1.3 added "&&" condition
		if(objTriggerExecution != null && objTriggerExecution.execute__c)
		{
	        CaseManagementConfirmRegistration objCMCR = new CaseManagementConfirmRegistration();
	    	objCMCR.confirmRegistrationDate(mapOldCase, mapNewCase);
		}
    }
}