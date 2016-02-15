/**********************************************************************************
Name:  CM_scheduleSLAEscalationBatch
Copyright © 2013  Lodha Group
===================================================================================
===================================================================================
Purpose:
-------
Scheduler class to schedule the batch job 'CM_SLAEscalationBatch' 
that take care SLA escalation of case.
===================================================================================
===================================================================================
History
-------
VERSION    AUTHOR              DATE               DETAIL              
1.0 -   CG Dev Team          07/12/2013      INITIAL DEVELOPMENT
**********************************************************************************/

global class CM_scheduleSLAEscalationBatch implements Schedulable {
    
    //Description : global method to schedule the batch job.  
      
    global void execute(SchedulableContext SC) {
        
        CM_UpdateEscalateToBatch updBatchVar = new CM_UpdateEscalateToBatch();
        database.executeBatch(updBatchVar);
        
        CM_SLAEscalationBatch SLABatchVar = new CM_SLAEscalationBatch();
        database.executeBatch(SLABatchVar); 
        
    }
    
}