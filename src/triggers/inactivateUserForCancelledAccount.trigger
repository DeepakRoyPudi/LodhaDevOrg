/*
*    Description : Trigger work for active/deactivate Custormer Portal User
*
*    Version        Date                Author                Description
*    1.0            16/12/2011		    Anonymous             Initial Draft
*    2.0            17/11/2014          Anupam                Code Commenting (IT-HD 55777)
*                                                             
*/

trigger inactivateUserForCancelledAccount on Account (before insert, before update) 
{   
	
    List<id> accountidListforCancel = new List<id>();    
    List<id> accountidListforActivation = new List<id>();    
    string recordtype;
    
    //Before Insert     
    if(trigger.IsInsert){
        
        if(!StaticVariableUtility.inactivateUserForCancelledAccountBeforeInsertRunOnce()){
        
        for (Account a:trigger.new){
        system.Debug('## Status__c'+a.Status__c);
        
            if(a.Status__c == 'Active' && a.RecordtypeId=='012D0000000hZXJ'){accountidListforActivation.add(a.id);}                
        }   
        
        system.Debug('## accountidListforActivation.size() '+accountidListforActivation.size());    
         
        if(accountidListforActivation.size() != 0){deactivateUser.activatePortalUser(accountidListforActivation);}
        
        }        
    }       
    
    //Before Update 
    if(trigger.IsUpdate){
    //2.0 : IT-HD 55777
    //if(!StaticVariableUtility.inactivateUserForCancelledAccountBeforeUpdateRunOnce()){
        
        for (Account acc:trigger.new)
        {    
            system.Debug('## Status__c'+acc.Status__c);
                
            if(acc.Status__c != trigger.oldMap.get(acc.id).Status__c){   
            
            system.Debug('## Status__c'+acc.Status__c);
                         
                if(acc.Status__c == 'Cancelled' && acc.RecordtypeId=='012D0000000hZXJ'){                    
                    accountidListforCancel.add(acc.id);                
                }                
                if(acc.Status__c == 'Active' && acc.RecordtypeId=='012D0000000hZXJ'){                    
                    accountidListforActivation.add(acc.id);                
                }            
            }        
        }      
        
        system.Debug('## accountidListforActivation.size() '+accountidListforActivation.size());
          
        if(accountidListforCancel.size() != 0){            
            deactivateUser.deactivatePortalUser(accountidListforCancel);        
        }        
        if(accountidListforActivation.size() != 0){            
            deactivateUser.activatePortalUser(accountidListforActivation);        
        }
    //}
    }
}