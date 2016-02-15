global class SpAccessController{

public SpAccessController() {

}

public boolean getHoverAccessDetails(String role_name, Id proj_id) {
  List<SPRINT_Access__c> accesslist = [select Only_Hover__c from SPRINT_Access__c where Project_Name__c=:proj_id and Allowed_Role__c=:role_name];
  
  if(accesslist.size() > 0){
    SPRINT_Access__c access = accesslist.get(0);
    return access.Only_Hover__c;
  }
  else {
    return false;
  }
}

public String getBookingAccess(String role_name, Id proj_id, String prev_status, String new_status){
  List<SPRINT_Access__c> accesslist = [select Permission_Type__c from SPRINT_Access__c where Project_Name__c=:proj_id 
                                       and Allowed_Role__c=:role_name and Next_Status__c includes(:new_status) and 
                                   Previous_Status__c=:prev_status];
    system.debug('%%%%%%' + accesslist );
  if(accesslist.size() > 0){
    SPRINT_Access__c access = accesslist.get(0);
    return access.Permission_Type__c; 
  }
  else {
    return 'View';
  }

}


static testMethod void SpAccessController(){
   
   
    //test         
    Project_Name__c projectNameTest = new Project_Name__c(Name='Test Project Name',CRN_INIT__c= 'LCP', Project_Type__c = 'Test Casa',Record_Type__c='Test Residential');
    insert projectNameTest; 
    
    SpAccessController spa = new SpAccessController();
    spa.getHoverAccessDetails('TESTROLE', projectNameTest.Id);
    
    SPRINT_Access__c  sprint = new SPRINT_Access__c (Allowed_Role__c='TESTROLE', Project_Name__c=projectNameTest.Id);
    insert sprint;
    
    SpAccessController spa1 = new SpAccessController();
    spa1.getHoverAccessDetails('TESTROLE', projectNameTest.Id);
    
    SpAccessController spa2 = new SpAccessController();
    spa2.getBookingAccess('TESTROLE', projectNameTest.Id, 'BOOKING', 'OPEN');
    
    sprint.Previous_Status__c = 'OPEN';
    sprint.Next_Status__c = 'BOOKING';
    sprint.Permission_Type__c = 'View';
    update sprint;
    
    SpAccessController spa3 = new SpAccessController();
    spa3.getBookingAccess('TESTROLE', projectNameTest.Id, 'OPEN','BOOKING');
    
    

}

}