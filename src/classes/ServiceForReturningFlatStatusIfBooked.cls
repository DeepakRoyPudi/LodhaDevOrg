/*
*    Description : Apex class that would perform the necessary information retrieval based on the Oasys Code 
*                  received and would return back the the Flat status.
*
*    Version       Date            Author            Description
*    1.0          05/11/2014      Asmita Bubane     Initial Draft
*/

@RestResource(urlMapping='/ServiceForReturningFlatStatusIfBooked/*')
global class ServiceForReturningFlatStatusIfBooked {
    
    private final static String STRBOOKED = 'BOOKED';
    private final static String STRBLOCKED = 'BLOCKED';
    private final static String STRBOOKING = 'BOOKING';

    @HttpGet
    global static String getFlatStatus(){
    	
    	RestRequest req = RestContext.request;
        String pStrOasysCode = RestContext.request.params.get('flatCode');  
    	
    	List<Flat__c> listFlat = new List<Flat__c>();
        
        // retrieving the required information from flat object
        listFlat = [select id, 
                           Status__c
                    from Flat__c
                    where Oasys_Flat_code__c = :pStrOasysCode];
                    
        if(!listFlat.isEmpty()){
            if(listFlat[0].Status__c != null && 
               (listFlat[0].Status__c.equals(STRBOOKED) || listFlat[0].Status__c.equals(STRBLOCKED) || listFlat[0].Status__c.equals(STRBOOKING)))
                return 'Flat is Not available.';
            else
                return 'Flat is Available.';
        }
        return 'Flat does not exist.';
    }
}