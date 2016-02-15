/*
*    Description : Apex class that would perform the necessary information retrieval based on the Oasys Code 
*                  received, Change status to Booked in SFDC and would return back the the Flat status.
*
*    Version       Date            Author            Description
*    1.0          10/10/2014      Asmita Bubane     Initial Draft
*/

@RestResource(urlMapping='/ReturnFlatStatus/*')
global class ReturnFlatStatusService {
	 
    private final static String STROPEN = 'OPEN';
    private final static String STRHOLD = 'HOLD';
    private final static String STRBLOCKED = 'BLOCKED';

    @HttpGet
    global static boolean getFlatStatus(){
    	
    	RestRequest req = RestContext.request;
        //String pStrOasysCode = req.requestURI.substring(req.requestURI.lastIndexOf('/') + 1); 
        String pStrOasysCode = RestContext.request.params.get('flatCode');  
    	
    	List<Flat__c> listFlat = new List<Flat__c>();
        
        // retrieving the required information from flat object
        listFlat = [select id, 
                           Status__c 
                    from Flat__c
                    where Oasys_Flat_code__c = :pStrOasysCode];
                    
        if(!listFlat.isEmpty()){
            if(listFlat[0].Status__c != null && (listFlat[0].Status__c.equals(STROPEN) || listFlat[0].Status__c.equals(STRHOLD))){ 
                listFlat[0].Status__c = STRBLOCKED;
                List<Database.SaveResult> listSaveResult = Database.update(listFlat);
                if(listSaveResult[0].isSuccess())
                    return true;
                else
                    return false;
            }
            return false;
        }
        return false;
    }
}