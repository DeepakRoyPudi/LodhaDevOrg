/*
*    Description : Apex class that would perform the necessary information retrieval based on the Oasys Code 
*                  received, Cancel the Flat from SFDC
*
*    Version       Date            Author            Description
*    1.0          05/11/2014      Asmita Bubane     Initial Draft
*/

@RestResource(urlMapping='/ServiceForCancellationOfFlat/*')
global class ServiceForCancellationOfFlat {

    private final static String STRHOLD = 'HOLD';

    @HttpGet
    global static boolean flatCancellation(){ 
    	
    	RestRequest req = RestContext.request;
        String pStrOasysCode = RestContext.request.params.get('flatCode');  
    	
    	List<Flat__c> listFlat = new List<Flat__c>();
        
        // retrieving the required information from flat object
        listFlat = [select id, 
                           Status__c 
                    from Flat__c
                    where Oasys_Flat_code__c = :pStrOasysCode];
                    
        if(!listFlat.isEmpty()){
            if(listFlat[0].Status__c != null && !listFlat[0].Status__c.equals(STRHOLD)){
                listFlat[0].Status__c = STRHOLD;
                List<Database.SaveResult> listSaveResult = Database.update(listFlat);
                if(listSaveResult[0].isSuccess())
                    return true;
                else
                    return false;
            }
            else
                return false;
        }
        return false;
    }

}