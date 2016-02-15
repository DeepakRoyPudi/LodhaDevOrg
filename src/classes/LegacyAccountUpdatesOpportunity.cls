/*
*    Description : Apex class to populate the values in Account object in 'Type Of Accommodation Required' 
*                  and 'Possession Type' fields from the related Opportunity records from 'Type Of Accommodation'
*                  'Possession Desired In' fields respectively
*
*    Version                    Date                    Author                        Description
*    1.0                        16/07/2014              Siddharth(Eternus)            Initial Draft
*/

global class LegacyAccountUpdatesOpportunity implements Database.Batchable<sObject>{

    private static final String STRRECORDTYPENAME = 'Person Account';
    private static final String STRSEMICOLON = ';';
    private static final String STRREADYTOMOVEIN = 'Ready to Move In';
    private static final String STRUNDERCONSTRUCTIONONEYEAR = 'Under Construction < 1 year';
    private static final String STRUNDERCONSTRUCTIONONETOTWOYEAR = 'Under Construction 1 - 2 years';
    private static final String STRUNDERCONSTRUCTIONMORETHANTWOYEAR = 'Under Construction > 2 years';
    private static final String STRSIXTOTWELEVEMONTHS = '6 to 12 Months';
    private static final String STRONETOTWOYEARS = '1 to 2 Years';
    private static final String STRTWOTOFIVEYEARS = '2 to 5 Years';

    //Start Method
    global Database.QueryLocator start(Database.BatchableContext pBc){
    
        Schema.RecordTypeInfo rtInfo = Account.SObjectType.getDescribe().getRecordTypeInfosByName().get(STRRECORDTYPENAME);
        Id idRtPersonAccount = rtInfo.getRecordTypeId();
        
        String strQuery = 'select Id, Type_of_Accommodation_Required__c, Possession_Type__c from Account where RecordTypeId = \'' + idRtPersonAccount + '\'';
        
        return Database.getQueryLocator(strQuery);
    }
    
    //Execute Method
    global void execute(Database.BatchableContext pBc, List<sObject> pListScope){
    
        //List of Parent Account Records in the Batch
        List<Account> listParentAccount = (List<Account>)pListScope;
        Map<Id, Account> mapParentAccount = new Map<Id, Account>(listParentAccount);
        
        List<Opportunity> listParentOpportunity = new List<Opportunity>();
        listParentOpportunity = [select Id,
                                        Type_of_Accomodation__c,
                                        Possession_desired_in__c,
                                        AccountId
                                 from Opportunity 
                                 where AccountId IN :mapParentAccount.keySet()];
        
        //Iterating over all the Opportunity Records
        if(!listParentOpportunity.isEmpty()){
            
            for(Opportunity oOpp : listParentOpportunity){
                
                //Get the values from Opportunity
                String strOppTypeOfAccommodation = oOpp.Type_of_Accomodation__c != NULL ? oOpp.Type_of_Accomodation__c : '';
                String strOppPossessionDesiredIn = oOpp.Possession_desired_in__c != NULL ? oOpp.Possession_desired_in__c : '';
                List<String> lstOppTypeOfAccommodation = new List<String>();

                //Retrieve the Parent Account Recordo
                Account oParentAccount = mapParentAccount.get(oOpp.AccountId);
                
                //Get the values from Account 
                String strAccTypeOfAccommodation = (oParentAccount.Type_of_Accommodation_Required__c != NULL) ? oParentAccount.Type_of_Accommodation_Required__c : '';
                String strAccPossessionType = (oParentAccount.Possession_Type__c != NULL) ? oParentAccount.Possession_Type__c : '';
                
                List<String> lstAccPossessionType = new List<String>();
                
                //Populate Type of Accommodation
                if(!String.isBlank(strOppTypeOfAccommodation)){
                    
                    lstOppTypeOfAccommodation = strOppTypeOfAccommodation.split(STRSEMICOLON);
                }
                
                //If Account.Type of Accommodation is Empty
                if(String.isBlank(strAccTypeOfAccommodation)){
                    
                    oParentAccount.Type_of_Accommodation_Required__c = strOppTypeOfAccommodation;
                }
                
                //If Account.Type of Accommodation is NOT EMPTY
                if(!lstOppTypeOfAccommodation.isEmpty() && !String.isBlank(strAccTypeOfAccommodation)){
                    
                    for(String strTempOppTypeOfAccommodation : lstOppTypeOfAccommodation){
                    
                        if(!strAccTypeOfAccommodation.contains(strTempOppTypeOfAccommodation))
                            strAccTypeOfAccommodation = strAccTypeOfAccommodation + STRSEMICOLON + strTempOppTypeOfAccommodation;
                    }
                    oParentAccount.Type_of_Accommodation_Required__c = strAccTypeOfAccommodation;
                }
                
                //Populate Possession Type
                //If Account. Possession Type is Empty
                if(String.isBlank(strAccPossessionType)){
                    
                    oParentAccount.Possession_Type__c = this.getPossessionTypeValue(strOppPossessionDesiredIn);
                }
                //If Account. Possession Type is NOT Empty
                if(!String.isBlank(strAccPossessionType) && !String.isBlank(strOppPossessionDesiredIn)){
                    
                    if(!strAccPossessionType.toLowerCase().contains(strOppPossessionDesiredIn.toLowerCase()))
                        oParentAccount.Possession_Type__c = oParentAccount.Possession_Type__c + 
                                                            STRSEMICOLON + 
                                                            this.getPossessionTypeValue(strOppPossessionDesiredIn);
                }
                
                //Assign the Account record back in the Map
                mapParentAccount.put(oParentAccount.Id, oParentAccount);
            }// For Opportunity
        }
        //Update all the Account Records
        List<Database.Saveresult> listSaveResult = Database.update(mapParentAccount.values());
    }
    
    //Finish Method
    global void finish(Database.BatchableContext pBc){
       
    }
    
    //Method to return the Mapped Possession Type Value
    public String getPossessionTypeValue(String pStrOppPossessionType){
        
        if(pStrOppPossessionType.equalsIgnoreCase(STRREADYTOMOVEIN)){
            
            return STRREADYTOMOVEIN;
        }
        if(pStrOppPossessionType.equalsIgnoreCase(STRUNDERCONSTRUCTIONONEYEAR)){
            
            return STRSIXTOTWELEVEMONTHS;
        }
        if(pStrOppPossessionType.equalsIgnoreCase(STRUNDERCONSTRUCTIONONETOTWOYEAR)){
            
            return STRONETOTWOYEARS;
        }
        if(pStrOppPossessionType.equalsIgnoreCase(STRUNDERCONSTRUCTIONMORETHANTWOYEAR)){
            
            return STRTWOTOFIVEYEARS;
        }
        return '';
    }
}