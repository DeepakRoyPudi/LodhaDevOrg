/* 
*    Description : Helper class for Account to Populate the Zone field depending on the Suburb selected
*    
*    Date         Version    Name             Description
*    17/7/2014    1.0        Asmita Bubane    Initial Draft
*/

public class AccountZoneSuburbMappingHelper {
	
	public Id idPersonRectype;
	
	private static final String STROTHERCITY = 'OTHER CITY';
	@TestVisible private static Boolean isExecuteOnUpdateOrDelete = false;
	
	public AccountZoneSuburbMappingHelper(){
	    
	    idPersonRectype = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
	}
	
	// Method to populate the Zone field if the Suburb field is not null
    public void insertZoneDependingOnSuburb(list<Account> listNewAccount){
    	
        // Iterating through new Accounts
        for(Account oAcc : listNewAccount){
            	
            if(oAcc.RecordTypeId == idPersonRectype){
            		
                // populating value for Zone_O from custom setting depending on Suburb selected
                if(oAcc.Suburb_O_cont__pc != null){            	
                    if(ZoneSuburbMapping__c.getall().containsKey(oAcc.Suburb_O_cont__pc)){
            	        oAcc.Zone_O_cont__pc = (ZoneSuburbMapping__c.getValues(oAcc.Suburb_O_cont__pc) != NULL && ZoneSuburbMapping__c.getValues(oAcc.Suburb_O_cont__pc).Zone__c != NULL) ? ZoneSuburbMapping__c.getValues(oAcc.Suburb_O_cont__pc).Zone__c : '';
            	        System.debug('oAcc.Zone_O_cont__pc :::: '+oAcc.Zone_O_cont__pc);
            	    }            	    
                }
                else if(oAcc.Suburb_O_cont__pc == null)
                    oAcc.Zone_O_cont__pc = '';
            
                // populating value for Zone_R from custom setting depending on Suburb selected
                if(oAcc.Suburb_R_cont__pc != null){            	
                    if(ZoneSuburbMapping__c.getall().containsKey(oAcc.Suburb_R_cont__pc)){
            	        oAcc.Zone_R_cont__pc = (ZoneSuburbMapping__c.getValues(oAcc.Suburb_R_cont__pc) != NULL && ZoneSuburbMapping__c.getValues(oAcc.Suburb_R_cont__pc).Zone__c != NULL) ? ZoneSuburbMapping__c.getValues(oAcc.Suburb_R_cont__pc).Zone__c : '';
            	    }            	    
                }
                else if(oAcc.Suburb_R_cont__pc == null)
                    oAcc.Zone_R_cont__pc = '';
            }
                
        }// end of for
    }
    
    // Method to update the Zone if the Suburb field is changed
    public void updateZoneDependingOnSuburb(Map<Id, Account> mapOldAccount, Map<Id, Account> mapNewAccount){
        
        if(!isExecuteOnUpdateOrDelete){
            // Iterating through Account
            for(Account oAcc : mapNewAccount.values()){
                
                if(oAcc.RecordTypeId == idPersonRectype){
                    // populating value for Zone_O from custom setting depending on Suburb selected
                    if(mapOldAccount.get(oAcc.id).Suburb_O_cont__pc != mapNewAccount.get(oAcc.id).Suburb_O_cont__pc){
            	        if(oAcc.Suburb_O_cont__pc != null){
            	            if(ZoneSuburbMapping__c.getall().containsKey(oAcc.Suburb_O_cont__pc)){
            	                oAcc.Zone_O_cont__pc = (ZoneSuburbMapping__c.getValues(oAcc.Suburb_O_cont__pc) != NULL && ZoneSuburbMapping__c.getValues(oAcc.Suburb_O_cont__pc).Zone__c != NULL) ? ZoneSuburbMapping__c.getValues(oAcc.Suburb_O_cont__pc).Zone__c : '';
            	            }  
            	        }
            	        else if(oAcc.Suburb_O_cont__pc == null)
                            oAcc.Zone_O_cont__pc = '';
                    }// end of if
            
                    // populating value for Zone_R from custom setting depending on Suburb selected
                    if(mapOldAccount.get(oAcc.id).Suburb_R_cont__pc != mapNewAccount.get(oAcc.id).Suburb_R_cont__pc){
               	        if(oAcc.Suburb_R_cont__pc != null){            	
            	            if(ZoneSuburbMapping__c.getall().containsKey(oAcc.Suburb_R_cont__pc)){
            	                oAcc.Zone_R_cont__pc = (ZoneSuburbMapping__c.getValues(oAcc.Suburb_R_cont__pc) != NULL && ZoneSuburbMapping__c.getValues(oAcc.Suburb_R_cont__pc).Zone__c != NULL) ? ZoneSuburbMapping__c.getValues(oAcc.Suburb_R_cont__pc).Zone__c : '';
            	            }            	    
                        }
                        else if(oAcc.Suburb_R_cont__pc == null)
                            oAcc.Zone_R_cont__pc = '';
                    }// end of if
                }
            }// end of for
            isExecuteOnUpdateOrDelete = true;
        }// end of if
    }
}