public class CaseAssignmentController {

    public CaseAssignmentController(ApexPages.StandardSetController controller) {

    }
    
	public PageReference  autoAssignment(){
		
		Set<Id> profileIds = new Set<Id>();
		List<CaseAssignmentProfiles__c> CaseAssignmentProfilesList = CaseAssignmentProfiles__c.getall().values();
		
		for (CaseAssignmentProfiles__c Pid :CaseAssignmentProfilesList){
			profileIds.add(Pid.Profile_Id__c);
		}
		
		system.debug('CURRENT USER PROFILE ID' + userInfo.getProfileId());
 		PageReference pageRef = ApexPages.currentPage();
 			
				if(profileids.contains(userInfo.getProfileId())){ 
						CaseUpdateBatchClass CaseUpdateBatchClassobj = new CaseUpdateBatchClass();
						database.ExecuteBatch(CaseUpdateBatchClassobj);
						pageRef = new PageReference('/500/o');
						pageRef.setRedirect(true); 
				}
				else
				{
						pageRef = new PageReference('/apex/CaseAssignmentError');
						pageRef.setRedirect(true); 
						
				}    
		 		
					return pageref;
	} 
 
}