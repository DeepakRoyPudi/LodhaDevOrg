/*@Created by: Deepak Pudi 
     @Created Date:   9/7/2015  --
 
 <!-- ------------------------------------------------------------------------------
 | Modified By      | Modified Date       | Version        | Description         |
 --------------------------------------------------------------------------------
 |Sudeep                  9/7/2015             1.0		This trigger set Order type field 
 |														if the field is empty with Default Value						 	
 |
 --------------------------------------------------------------------------------
 |
 ------------------------------------------------------------------------------ -->*/
trigger ProjectDefaultOrder on Project_Name__c (before insert,before update) {

    for(Project_Name__c pobj:Trigger.new){
        
        if(pobj.OrderType__c==null || pobj.OrderType__c==''){
          pobj.OrderType__c='Default';
        }
    
    } 
    
}