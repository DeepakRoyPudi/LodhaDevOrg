/*
*        Description : Batch class that delets the entry of Despatches from Aftership Account.
*                      This class is written for DMS project.
*
*        Version     Date          Author             Description
*        1.0         03/06/2014    Asmita(Eternus)    Intial Draft
*/

global class BatchDeleteDeliveredDespatch implements Database.batchable<sObject>, Database.AllowsCallouts{
    
    private static final String APIKEY = System.Label.AftershipApiKey;
    
    global Database.QueryLocator start(Database.BatchableContext BC){
    
        String query = 'select id, slug__c, Last_Delivery_Status__c, Waybill_No__c from Despatch__c';
        return Database.getQueryLocator(query);
    }// end of start()
    
    global void execute(Database.BatchableContext BC, List<Despatch__c> scope){
    
        HttpRequest oRequest = new HttpRequest();
        Http oHttp;
        HttpResponse oResponse;
        //String headerString = '45f0561d-945f-4159-9e72-14019c1b6b30';
        
        List<Despatch__c> listDespatch = (List<Despatch__c>)scope;
        for(Despatch__c oDespatch : listDespatch){
        
            if(oDespatch.Last_Delivery_Status__c != null && (oDespatch.Last_Delivery_Status__c.contains('Delivery') || oDespatch.Last_Delivery_Status__c.contains('DELIVERY'))){
            
                // Setting Request Parameters
                oRequest.setEndpoint('https://api.aftership.com/v3/trackings/'+oDespatch.Slug__c+'/'+oDespatch.Waybill_No__c);
                oRequest.setMethod('DELETE');      
                
                oRequest.setHeader('aftership-api-key', APIKEY);
                
                // Getting the Response from AfterShip
                oHttp = new Http();
                oResponse = oHttp.send(oRequest);
                System.debug('Response :: '+oResponse.getBody());
                
            }// end of if
        }// end of for
    }// end of execute()
    
    global void finish(Database.BatchableContext BC)
    {
    }// end of finish
    
}// end of class