/*
*    Description : Helper class for After Insert Opportunity trigger to populate the Account Lead Origin value 
*                  with related first Opportunity Lead Source
*
*       Date        Version      Name     Description
*    18/07/2014       1.0       Asmita    Initial Draft
*/


public with sharing class AccountOriginSourceFromOpportunityHelper {

    public void populateAccountOriginSourceHelper(Map<Id, Opportunity> pMapOldOpportunity, Map<Id, Opportunity> pMapNewOpportunity){
        
        Set<Id> setAccountId = new Set<Id>();
        List<Opportunity> listOpportunity = new List<Opportunity>();
        Map<Id, Account> mapAccount = new Map<id, Account>();
        Map<Id, Account> mapAccountToUpdate = new Map<Id, Account>();
        
        Id idPersonAccRecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        
        // getting list of Account related to new Opportunities
        for(Opportunity oOpp : pMapNewOpportunity.values()){
            setAccountId.add(oOpp.AccountId);
        }
        
        mapAccount.putAll([select id, 
                                  Origin_Source_of_Lead__c 
                           from Account 
                           where id in :setAccountId and RecordTypeId = :idPersonAccRecType]);
        
        // Getting opportunities ordered by created date in ascending order
        listOpportunity = [select id, 
                                  LeadSource, 
                                  AccountId, 
                                  CreatedDate 
                           from Opportunity 
                           where AccountId in :mapAccount.keySet() and LeadSource != null 
                           order by CreatedDate asc];
        System.debug('ListOpp Size ::::: '+listOpportunity);
        
        // Assigning the Opportunity Lead source to Account Origin Source of Lead field
        for(Opportunity oOpp : listOpportunity){
            for(Id accId : mapAccount.keySet()){
                if(oOpp.AccountId == accId)
                	if(!mapAccountToUpdate.containsKey(accId)){
                	
                	    mapAccount.get(accId).Origin_Source_of_Lead__c = oOpp.LeadSource != null ? oOpp.LeadSource : '';
                	    mapAccountToUpdate.put(accId, mapAccount.get(accId));
                    }
                    break;
            }// end of AccountID for
        }// end of Opportunity for
        
        // Updating the Accounts
        if(!mapAccountToUpdate.isEmpty())
            Database.SaveResult[] oSaveRes = Database.update(mapAccountToUpdate.values());
    }
}