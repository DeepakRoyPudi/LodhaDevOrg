/*
*        Description : Opportunity trigger helper class for Updating the Account fields from Opportunity
*                      fields on Opportunity insert, update or delete. This class is written for SLBM Phase 2
*
*        Version     Date          Author             Description
*        1.0         24/07/2014    Asmita(Eternus)    Intial Draft
*/

public class AccountUpdateFromOpportunityHelper {
    private static final String STRPERSONRECTYPE = 'Person Account';
    private static final String STRSEMICOLON = ';';
    private static final String STRCROSSPROJECT = 'Cross Project';
    private static final String STRCLOSEDWON = 'Closed Won';
    
    List<Id> listAccountId = new List<Id>();
    List<Account> listAccountUpdate = new List<Account>();
    Map<Id, String> mapProjectName = new Map<Id, String>(); 
    Map<Account, List<Opportunity>> mapAccountOpportunity = new Map<Account, List<Opportunity>>();
    //Creating a object to call getPossessionTypeValue method of LegacyAccountUpdatesOpportunity class
    LegacyAccountUpdatesOpportunity objAccountUpdatesOpp = new LegacyAccountUpdatesOpportunity();
    
    private static Boolean isExecutedOnInsert = false;
    @TestVisible private static Boolean isExecuteOnUpdateOrDelete = false;
    
    // Helper method which is called from OpportunityTriggerHelper class for afterInsert
    public void accountUpdateOnOppInsert(Map<Id, Opportunity> pMapOldOpportunity, Map<Id, Opportunity> pMapNewOpportunity){

        List<Opportunity> listOpportunity = new List<Opportunity>();
        listAccountUpdate = new List<Account>();
        List<String> listTypeOfAccomodationOpp = new List<String>();
        Map<Id, Opportunity> mapOldOpportunity = new Map<Id, Opportunity>();
        String strPurposeOfPurchaseOpp = '';
        String strReasonForPurchaseAcc = '';
        String strProjectNameOpp = '';
        String strProductHistoryAcc = '';
        Integer numberOfCrossProjects = 0;
        Integer intVisitCount = 0;
        boolean isBookedCustomer = false;
        
        // Setting list of AccountId, ProjectName and Map of Account and list of Opportunities related to new Opportunities
	    setAccountId(pMapNewOpportunity);
	    createAccountOpportunityAndProjectNameMap(pMapNewOpportunity);       
        
        // iterating over the Account and its related opportunities to get the Account values to update
	    if(!mapAccountOpportunity.isEmpty()){
            for(Account acc : mapAccountOpportunity.keySet()){
            
                listOpportunity = new List<Opportunity>();
                listOpportunity = mapAccountOpportunity.get(acc);
                strPurposeOfPurchaseOpp = '';
                strReasonForPurchaseAcc = '';
                strProjectNameOpp = '';
                strProductHistoryAcc = '';
                numberOfCrossProjects = 0;
                isBookedCustomer = false;
                intVisitCount = 0;
            
                // Setting the values to account fields to update
                if(!listOpportunity.isEmpty()){
				    for(Opportunity oOpp : listOpportunity){
						
                        // Account - Reason for Purchase
                        // Getting Purpose of Purchase from Opportunity
	                    strPurposeOfPurchaseOpp = oOpp.Purpose__c != NULL ? oOpp.Purpose__c : '';	         
                        // Getting Reason of Purchase from Account
                        if(!String.isBlank(strReasonForPurchaseAcc))
                            strReasonForPurchaseAcc = acc.Reason_for_Purchase__c != NULL && !strReasonForPurchaseAcc.contains(acc.Reason_for_Purchase__c) ? strReasonForPurchaseAcc + STRSEMICOLON + acc.Reason_for_Purchase__c : strReasonForPurchaseAcc;
                        else
                            strReasonForPurchaseAcc = acc.Reason_for_Purchase__c != NULL ? acc.Reason_for_Purchase__c : '';
	        
	                    if(String.isBlank(strReasonForPurchaseAcc))
	                        strReasonForPurchaseAcc = strPurposeOfPurchaseOpp;	            
	                    else if(!String.isBlank(strReasonForPurchaseAcc) && !String.isBlank(strPurposeOfPurchaseOpp)){
	                        if(!strReasonForPurchaseAcc.contains(strPurposeOfPurchaseOpp)){
	                            strReasonForPurchaseAcc = strReasonForPurchaseAcc + STRSEMICOLON + strPurposeOfPurchaseOpp;
	                        }
	                    } // end of if
						
                        // Account - Product History
                        // Getting Project name from Account
                        strProjectNameOpp = oOpp.Project_Name__c != null ? mapProjectName.get(oOpp.Project_Name__c) : '';
                        // Getting Product History from Account
                        if(!String.isBlank(strProductHistoryAcc)) 
                            strProductHistoryAcc = acc.Product_History__c != null && !strProductHistoryAcc.contains(acc.Product_History__c) ? strProductHistoryAcc + STRSEMICOLON + acc.Product_History__c : strProductHistoryAcc;
                        else
                            strProductHistoryAcc = acc.Product_History__c != null ? acc.Product_History__c : '';
            
                        if(String.isBlank(strProductHistoryAcc))
                            strProductHistoryAcc = strProjectNameOpp;            
                        else if(!String.isBlank(strProductHistoryAcc) && !String.isBlank(strProjectNameOpp)){
                            if(!strProductHistoryAcc.contains(strProjectNameOpp))
                                strProductHistoryAcc = strProductHistoryAcc + STRSEMICOLON + strProjectNameOpp;
	                    }// end of if
	                    System.debug('strProductHistoryAcc- for :::: ' + strProductHistoryAcc);
						
						// Account - Cross Project Exposure
						// Counting the Opportunities if the Marketing Source is Cross Project
	                    if(oOpp.Marketing_Source__c != null)
                            if(oOpp.Marketing_Source__c == STRCROSSPROJECT)
                                numberOfCrossProjects = numberOfCrossProjects + 1;
								
					    // Account - Booked Customers
						isBookedCustomer = oOpp.StageName == STRCLOSEDWON ? true : false;
						
						// Account - Visit Count
						if(oOpp.Date_of_Visit__c != null)
                            intVisitCount = intVisitCount + 1;
				    }// end of listOpportunity for
           
                    // Account - Reason for Purchase
                    if(!String.isBlank(strReasonForPurchaseAcc))
                        acc.Reason_for_Purchase__c = strReasonForPurchaseAcc;               
                    // Account - Product History
                    if(!String.isBlank(strProductHistoryAcc))
                        acc.Product_History__c = strProductHistoryAcc;   
                    System.debug(' acc.Product_History__c :::: ' + acc.Product_History__c);            
                    // Account - Cross Project Exposure
                    acc.Cross_Project_Exposure__c = acc.Cross_Project_Exposure__c != null ? acc.Cross_Project_Exposure__c + numberOfCrossProjects : numberOfCrossProjects;           
                    // Account - Booked Customers
                    if(acc.Booked_Customers__c == false && isBookedCustomer == true)
                        acc.Booked_Customers__c = isBookedCustomer;           
                    // Account - Visit Count
                    acc.Visit_Count__c = acc.Visit_Count__c != null ? acc.Visit_Count__c + intVisitCount : intVisitCount; 
                    
                    listAccountUpdate.add(acc);
                }
            }// end of for
            //Update the Account Records
            if(!listAccountUpdate.isEmpty())      
                List<Database.Saveresult> listSaveResult = Database.update(listAccountUpdate);
            
        }
	
    }// end of afterinsert function	
    
    // Helper method which is called from OpportunityTriggerHelper class for afterUpdate 
	public void accountUpdateOnOppUpdateOrDelete(Map<Id, Opportunity> pMapOldOpportunity, Map<Id, Opportunity> pMapNewOpportunity){

	if(!isExecuteOnUpdateOrDelete){
        List<Opportunity> listOpportunity = new List<Opportunity>();
        List<String> listTypeOfAccomodationOpp = new List<String>();
        Map<Id, Opportunity> mapOldOpportunity = new Map<Id, Opportunity>();
        Map<Id, Opportunity> mapOpprtunity = new Map<Id, Opportunity>();
        String strPurposeOfPurchaseOpp = '';
        String strReasonForPurchaseAcc = '';
        String strProjectNameOpp = '';
        String strProductHistoryAcc = '';
        Integer numberOfCrossProjects = 0;
        boolean isBookedCustomer = false;
        Integer intVisitCount = 0;
        listAccountUpdate = new List<Account>();
        System.debug('pMapNewOpportunity :::: ' +  pMapNewOpportunity);
        // Setting list of AccountId, ProjectName and Map of Account and list of Opportunities related to new Opportunities
        if(pMapNewOpportunity != null)
	        setAccountId(pMapNewOpportunity);
	    else
	        setAccountId(pMapOldOpportunity);
	    // getting all the opportunities related to account of new opportunity
	    if(!listAccountId.isEmpty()){
    	    mapOpprtunity.putAll([select id, 
	                                     AccountId,
	                                     Purpose__c, 
	                                     Project_Name__c,
	                                     Marketing_Source__c,
	                                     StageName,
	                                     Date_of_Visit__c
	                              from Opportunity
	                              where AccountId in :listAccountId]);
	        createAccountOpportunityAndProjectNameMap(mapOpprtunity);
	    }
	    
	    // iterating over the Account and its related opportunities to get the Account values to update
        if(!mapAccountOpportunity.isEmpty()){
            for(Account acc : mapAccountOpportunity.keySet()){
                
                listOpportunity = new List<Opportunity>();
                listOpportunity = mapAccountOpportunity.get(acc);
                strPurposeOfPurchaseOpp = '';
                strReasonForPurchaseAcc = '';
                strProjectNameOpp = '';
                strProductHistoryAcc = '';
                numberOfCrossProjects = 0;
                isBookedCustomer = false;
                intVisitCount = 0;
            
                // Setting the values to account fields to update
                if(!listOpportunity.isEmpty()){
                    for(Opportunity oOpp : listOpportunity){
	                    
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
                        strProjectNameOpp = oOpp.Project_Name__c != null ? mapProjectName.get(oOpp.Project_Name__c) : '';
                        if(!String.isBlank(strProjectNameOpp))
                            strProjectNameOpp = strProjectNameOpp.toUpperCase();            
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
        else if(pMapNewOpportunity == null && !listAccountId.isEmpty()){
        	List<Account> listAcc = new List<Account>();
                
        	listAcc = [select id, 
                              Reason_for_Purchase__c, 
                              Product_History__c, 
                              Cross_Project_Exposure__c,
                              Booked_Customers__c, 
                              Visit_Count__c
                       from Account 
                       where id = :listAccountId[0] and 
                             RecordTypeId = :Schema.SObjectType.Account.getRecordTypeInfosByName().get(STRPERSONRECTYPE).getRecordTypeId()];
                                 
            if(!listAcc.isEmpty()){ 
            	Account acc = listAcc[0];
                // Assigning the Calculated values of all the related opportunities to Account
                acc.Reason_for_Purchase__c = strReasonForPurchaseAcc;               
                // Account - Product History
                acc.Product_History__c = strProductHistoryAcc;               
                // Account - Cross Project Exposure
                acc.Cross_Project_Exposure__c = numberOfCrossProjects;           
                // Account - Booked Customers
                acc.Booked_Customers__c = isBookedCustomer;           
                // Account - Visit Count
                acc.Visit_Count__c = intVisitCount; 
                    
                listAccountUpdate.add(acc);
                //Update the Account Records
                if(!listAccountUpdate.isEmpty())      
                    List<Database.Saveresult> listSaveResult = Database.update(listAccountUpdate);
            }
        }
	isExecuteOnUpdateOrDelete = true;
	}//Static Variable IF   
	}// end of afterUpdate function	
    
    // Method to set the AccountId related to the Opportunities NewOpportunities
    public void setAccountId(Map<Id, Opportunity> pMapNewOpportunity){
    	
    	for(Opportunity opp : pMapNewOpportunity.values()){
            listAccountId.add(opp.AccountId);
        }// end of Opportunity for
        
    }
    
    // Creating a map of Account and list of Related Opportunity
	public void createAccountOpportunityAndProjectNameMap(Map<Id, Opportunity> pMapNewOpportunity){
		
        List<Opportunity> listOpportunity = new List<Opportunity>();
        List<Id> listProjectNameId = new List<Id>();
        
        for(Opportunity opp : pMapNewOpportunity.values()){
            listProjectNameId.add(opp.Project_Name__c);
        }// end of Opportunity for
        
        // Creating a map of Project Id and Project Name referring to Opportunity Project Name field
        for(Project_Name__c oProjName : [select id, Name from Project_Name__c where id in :listProjectNameId]){
            mapProjectName.put(oProjName.Id, oProjName.Name);
        }
		
        // Iterating over Accounts related to New Opportunity to create map of Account and its related Opportunities
        // and to create a map of Account and its related Number of Call attempts 
        for(Account acc : [select id, 
                                  Reason_for_Purchase__c, 
                                  Product_History__c, 
                                  Cross_Project_Exposure__c,
                                  Booked_Customers__c, 
                                  Visit_Count__c
                           from Account 
                           where id in :listAccountId and 
                                 RecordTypeId = :Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId()]){
          	  
            listOpportunity = new List<Opportunity>();
            for(Opportunity opp : pMapNewOpportunity.values()){
                if(acc.Id == opp.AccountId){
                    listOpportunity.add(opp);
                }
            }
            
            if(!listOpportunity.isEmpty())
                mapAccountOpportunity.put(acc, listOpportunity);
        }// end of Account for        
          
	}// end of createAccountOpportunityMap()
}