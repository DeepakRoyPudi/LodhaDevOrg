trigger CalculateEDC on Opportunity (before insert,before update) {

    EDCCalculationController calculateedc=new EDCCalculationController();
    
    list<Opportunity> lstOpps = trigger.new;

    
    if(trigger.Isbefore && trigger.Isinsert){
    	
    	if(!StaticVariableUtility.calculateEDCBeforeInsertRunOnce()){
    	    calculateedc.CheckforActiveOpp(lstOpps,'Insert',NULL);
            calculateedc.CalculateEDCbeforeinsert(lstOpps );    
    	}
    }
    if(trigger.Isbefore && trigger.Isupdate){
        
        if(!StaticVariableUtility.calculateEDCBeforeUpdateRunOnce()){
            calculateedc.CheckforActiveOpp(lstOpps,'Update',trigger.oldmap);       
            calculateedc.CalculateEDC(lstOpps ,trigger.oldmap);            
        }
    }       
}