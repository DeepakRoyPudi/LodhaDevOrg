/*
*    Description: Batch class will process all the exosting opportunities of Account and 
*                 update the Account fields created for SLBM Phase 2
*
*    Version      Date           Author             Description
*    1.0         08/25/2014     Asmita(Eternus)    Initial draft
*/

global with sharing class LegacyAccountUpdateFromOpportunities implements Database.Batchable<sObject> {
    
    private static final String STRPERSONRECTYPE = 'Person Account';
    private static final String STRSEMICOLON = ';';
    private static final String STRCROSSPROJECT = 'Cross Project';
    private static final String STRCLOSEDWON = 'Closed Won';
    
    // Start
    global Database.QueryLocator start(Database.BatchableContext pBc){
    
        Id idPersonRecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get(STRPERSONRECTYPE).getRecordTypeId();
        String strQuery = 'select Id, Product_History__c, Reason_for_Purchase__c, Cross_Project_Exposure__c, Booked_Customers__c, Visit_Count__c from Account where RecordTypeId = \'' + idPersonRecType + '\'';
        
        return Database.getQueryLocator(strQuery);
    }
    
    // Execute
    global void execute(Database.BatchableContext pBc, List<Account> pListAccount){
        
        List<Opportunity> listOpportunity = new List<Opportunity>();
        List<Opportunity> listOpportunityPerAccount = new List<Opportunity>();
        List<Account> listAccountUpdate = new List<Account>();
        Map<Id, Account> mapAccountToUpdate = new Map<Id, Account>();
        Map<Id, Account> mapAccount = new Map<Id, Account>();
        Map<Account, List<Opportunity>> mapAccountAndOpportunity = new Map<Account, List<Opportunity>>();
        Account oAcc = new Account();
        List<String> listProductHistory = new List<String>();
        String strPurposeOfPurchaseOpp = '';
        String strReasonForPurchaseAcc = '';
        String strProjectNameOpp = '';
        String strProductHistoryAcc = '';
        Integer numberOfCrossProjects = 0;
        boolean isBookedCustomer = false;
        Integer intVisitCount = 0;
        
        mapAccount.putAll(pListAccount);
        
        listOpportunity = [select id,
                                  Project_Name__r.Name,
                                  Purpose__c,
                                  Marketing_Source__c,
                                  StageName,
                                  Date_of_Visit__c,
                                  AccountId
                           from Opportunity
                           where AccountId IN :pListAccount];
        // Creating map of account and related opportunites
        for(Account acc : pListAccount){
        	listOpportunityPerAccount = new List<Opportunity>();
            for(Opportunity opp : listOpportunity){
            	if(acc.Id == opp.AccountId){
                    listOpportunityPerAccount.add(opp);
                }
            }
            if(!listOpportunityPerAccount.isEmpty())
                mapAccountAndOpportunity.put(acc, listOpportunityPerAccount);
        }
        
        System.debug('mapAccountAndOpportunity :::: ' + mapAccountAndOpportunity);
        // Iterating over list of opportunities to get the values need to update for the Account
        if(!mapAccountAndOpportunity.isEmpty()){
            for(Account acc : mapAccountAndOpportunity.keySet()){
                
                listOpportunityPerAccount = new List<Opportunity>();
                listOpportunityPerAccount = mapAccountAndOpportunity.get(acc);
                strPurposeOfPurchaseOpp = '';
                strReasonForPurchaseAcc = '';
                strProjectNameOpp = '';
                strProductHistoryAcc = '';
                numberOfCrossProjects = 0;
                isBookedCustomer = false;
                intVisitCount = 0;
            
                // Setting the values to account fields to update
                if(!listOpportunityPerAccount.isEmpty()){
				    for(Opportunity oOpp : listOpportunityPerAccount){
	                    
	                    // Account - Reason for Purchase
						// Getting Purpose of Purchase from Opportunity
	                    strPurposeOfPurchaseOpp = oOpp.Purpose__c != NULL ? oOpp.Purpose__c : '';	         
	                    if(String.isBlank(strReasonForPurchaseAcc))
	                        strReasonForPurchaseAcc = strPurposeOfPurchaseOpp;	            
	                    else if(!String.isBlank(strReasonForPurchaseAcc) && !String.isBlank(strPurposeOfPurchaseOpp)){
	                        if(!strReasonForPurchaseAcc.contains(strPurposeOfPurchaseOpp)){
	                            strReasonForPurchaseAcc = strReasonForPurchaseAcc + STRSEMICOLON + strPurposeOfPurchaseOpp;
	                        }
	                    } // end of else
	                    
	                    // Account - Product History
						// Getting Project name from Account
                        strProjectNameOpp = oOpp.Project_Name__c != null ? oOpp.Project_Name__r.Name : '';
                        /*if(!String.isBlank(strProjectNameOpp))
                            strProjectNameOpp = strProjectNameOpp.toUpperCase();    */        
                        if(String.isBlank(strProductHistoryAcc))
                            strProductHistoryAcc = strProjectNameOpp;            
                        else if(!String.isBlank(strProductHistoryAcc) && !String.isBlank(strProjectNameOpp)){
                            if(!strProductHistoryAcc.contains(strProjectNameOpp))
                                strProductHistoryAcc = strProductHistoryAcc + STRSEMICOLON + strProjectNameOpp;
	                    }// end of else
	                    
	                    // Account - Cross Project Exposure
						// Counting the Opportunities if the Marketing Source is Cross Project
	                    if(oOpp.Marketing_Source__c != null)
                            if(oOpp.Marketing_Source__c == STRCROSSPROJECT)
                                NumberOfCrossProjects = NumberOfCrossProjects + 1;
                                
                        // Account - Booked Customers
                        if(isBookedCustomer == false)
						    isBookedCustomer = oOpp.StageName == STRCLOSEDWON ? true : false;
						
						// Account - Visit Count
						if(oOpp.Date_of_Visit__c != null)
                            intVisitCount = intVisitCount + 1;
				    }// end of for listOpportunity
				    
				    // Assigning the Calculated values of all the related opportunities to Account             
                    // Account - Reason for Purchase
                    if(!String.isBlank(strReasonForPurchaseAcc))
                        acc.Reason_for_Purchase__c = strReasonForPurchaseAcc;               
                    // Account - Product History
                    if(!String.isBlank(strProductHistoryAcc))
                        acc.Product_History__c = strProductHistoryAcc;               
                    // Account - Cross Project Exposure
                    acc.Cross_Project_Exposure__c = numberOfCrossProjects;           
                    // Account - Booked Customers
                    acc.Booked_Customers__c = isBookedCustomer;           
                    // Account - Visit Count
                    acc.Visit_Count__c = intVisitCount; 
                    
                    listAccountUpdate.add(acc);
                } //end of if
            }// end of for
            //Update the Account Records
            if(!listAccountUpdate.isEmpty())      
                List<Database.Saveresult> listSaveResult = Database.update(listAccountUpdate);
        } //end of if
    }
    
     //Finish
    global void finish(Database.BatchableContext pBc){
       
    }
}