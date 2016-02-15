/*
*    Description : Handler Class for Opportunity trigger
*
*       Date        Version      Name     Description
*    18/07/2014       1.0       Asmita    Initial Draft
*   
*    24/07/2014       1.1       Asmita    Calling Helper Class for Updating the Account fields depending on related
*                                         Opportunity fields.
*/

public class OpportunityTriggerHandler {
	
    // calling Helper method for afterInsert event
    public void isAfterInsert(Map<Id, Opportunity> pMapOldOpportunity, Map<Id, Opportunity> pMapNewOpportunity){
        
        // SLBM Phase 1 : Updates Account Origin Source of Lead field
        AccountOriginSourceFromOpportunityHelper oUpdateAccountHelper = new AccountOriginSourceFromOpportunityHelper();
        oUpdateAccountHelper.populateAccountOriginSourceHelper(pMapOldOpportunity, pMapNewOpportunity);
        
        // SLBM Phase 2 : Updates Account Type of Accomodation, Possession Type, Product History, 
        // Purpose of Purchase, Booked Customer, Visit Count, Cross Project exposure
        AccountUpdateFromOpportunityHelper oAccountUpdateHelper = new AccountUpdateFromOpportunityHelper();
        oAccountUpdateHelper.accountUpdateOnOppInsert(pMapOldOpportunity, pMapNewOpportunity);
    }
    
    // calling Helper method for afterUpdate event
    public void isAfterUpdate(Map<Id, Opportunity> pMapOldOpportunity, Map<Id, Opportunity> pMapNewOpportunity){
        
        // SLBM Phase 2 : Updates Account Type of Accomodation, Possession Type, Product History, 
        // Purpose of Purchase, Booked Customer, Visit Count, Cross Project exposure
        AccountUpdateFromOpportunityHelper oAccountUpdateHelper = new AccountUpdateFromOpportunityHelper();
        oAccountUpdateHelper.accountUpdateOnOppUpdateOrDelete(pMapOldOpportunity, pMapNewOpportunity);
    }
    
    // calling Helper method for afterDelete event
    public void isAfterDelete(Map<Id, Opportunity> pMapOldOpportunity, Map<Id, Opportunity> pMapNewOpportunity){
        
        // SLBM Phase 2 : Updates Account Type of Accomodation, Possession Type, Product History, 
        // Purpose of Purchase, Booked Customer, Visit Count, Cross Project exposure
        AccountUpdateFromOpportunityHelper oAccountUpdateHelper = new AccountUpdateFromOpportunityHelper();
        oAccountUpdateHelper.accountUpdateOnOppUpdateOrDelete(pMapOldOpportunity, null);
    }

}