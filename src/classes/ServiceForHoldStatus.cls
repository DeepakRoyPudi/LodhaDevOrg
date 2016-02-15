/*
*    Description : Apex class that would perform the necessary information retrieval based on the Oasys Code 
*                  received, return and update the hold status in SFDC
*
*    Version       Date            Author            Description
*    1.0          15/11/2014      Asmita Bubane     Initial Draft
*/

@RestResource(urlMapping='/holdStatusService/*')
global class ServiceForHoldStatus{
   
    private final static String STRUNHOLD = 'Unhold';
    private final static String STRHOLD = 'Hold';
    private final static String STRBLOCKED = 'BLOCKED';
    private final static String STRBOOKED = 'BOOKED';
    private final static Integer STRHOLDMINUTES = Integer.valueOf(System.Label.HoldMinutes);

    @HttpGet
    global static String returnFlatStatus(){
      
      String returnString = '';
      List<Flat__c> listFlatUpdate = new List<Flat__c>();
      
      RestRequest req = RestContext.request;
        //String pStrOasysCode = req.requestURI.substring(req.requestURI.lastIndexOf('/') + 1); 
        String pStrOasysCode = RestContext.request.params.get('flatCode');  
      
      List<Flat__c> listFlat = new List<Flat__c>();
        
        // retrieving the required information from flat object
        listFlat = [select id, 
                           Status__c,
                           Hold_Status__c,
                           Hold_Status_Start_Time__c 
                    from Flat__c
                    where Oasys_Flat_code__c = :pStrOasysCode];
                    
        if(!listFlat.isEmpty()){
            if(listFlat[0].Status__c != null){
                if((listFlat[0].Status__c.equals(STRBLOCKED) || listFlat[0].Status__c.equals(STRBOOKED))
                    && (listFlat[0].Hold_Status__c == null)){
                        //if(!listFlat[0].Hold_Status__c.equals(STRHOLD))
                            returnString = 'Flat is already Booked.';
                }
                else if((listFlat[0].Status__c.equals(STRBLOCKED) || listFlat[0].Status__c.equals(STRBOOKED))
                         && listFlat[0].Hold_Status__c.equals(STRHOLD)){
                   returnString = 'Flat is already Booked.';
                }
                else if(!(listFlat[0].Status__c.equals(STRBLOCKED)) && !(listFlat[0].Status__c.equals(STRBOOKED))
                         && (listFlat[0].Hold_Status__c == null)){
                             //if(!listFlat[0].Hold_Status__c.equals(STRHOLD)){
                        listFlat[0].Hold_Status__c = STRHOLD;
                        listFlat[0].Hold_Status_Start_Time__c = System.now();                        
                        listFlatUpdate.add(listFlat[0]);
                        returnString = 'Flat is Available.';
                    //}
                }
                else if(!(listFlat[0].Status__c.equals(STRBLOCKED)) && !(listFlat[0].Status__c.equals(STRBOOKED))
                         && listFlat[0].Hold_Status__c.equals(STRHOLD)){
                    if(listFlat[0].Hold_Status_Start_Time__c != null){
                        if(System.now().addMinutes(-STRHOLDMINUTES) <= listFlat[0].Hold_Status_Start_Time__c)
                            returnString = 'Flat is on Hold.';
                        else{
                            returnString = 'Flat is Available.';
                            listFlat[0].Hold_Status__c = STRHOLD;
                            listFlat[0].Hold_Status_Start_Time__c = System.now();                        
                            listFlatUpdate.add(listFlat[0]);
                        }
                    }
                }
            }
        }
        if(!listFlatUpdate.isEmpty())
             List<Database.SaveResult> listSaveResult = Database.update(listFlatUpdate);
        return returnString;        
    }
}