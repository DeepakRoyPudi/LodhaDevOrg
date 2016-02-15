/*
*        Description : Batch class that gets the last delivery status of the despatch and
*                      update Last Delivery status in Despatch Object. This class is written for DMS
*
*        Version     Date          Author             Description
*        1.0         02/06/2014    Asmita(Eternus)    Intial Draft
*/

public class UpdateDespatchLastStatusFromAftership{
    
    private static final String APIKEY = System.Label.AftershipApiKey;
    private static final String STRDELIVERED = 'delivered';
    
    Map<String, String> mapTrackingNoMsg = new Map<String, String>();
    Map<String, String> mapTrackingNoAndDeliveryDate = new Map<String, String>();
    
    public void getTrackings(){
    
        /*Map<String, String> mapTrackingNoMsg = new Map<String, String>();
        Map<String, String> mapTrackingNoAndDeliveryDate = new Map<String, String>();*/
        
        HttpRequest oRequest = new HttpRequest();
        
        // Setting Request Parameters
        oRequest.setEndpoint('https://api.aftership.com/v4/trackings');
        oRequest.setMethod('GET');      
        //ddad526e-6fde-4bf6-87b7-24d8e59e75fb
        //45f0561d-945f-4159-9e72-14019c1b6b30 - nishant new acount api key
        //String headerString = '45f0561d-945f-4159-9e72-14019c1b6b30';       
        oRequest.setHeader('aftership-api-key', APIKEY);
        
        Http oHttp = new Http();
        HttpResponse oResponse = oHttp.send(oRequest);
        
        JSONParser parser = JSON.createParser(oResponse.getBody());
        MainWrapper oMainWrapper = (MainWrapper)parser.readValueAs(MainWrapper.class);
        
        System.debug('Response ::::::::: '+oResponse.getBody());
        System.debug('Parsed String ::::::::: '+oMainWrapper);
        System.debug('Message ::::::::: '+oMainWrapper.data.trackings.get(0).checkpoints.get(oMainWrapper.data.trackings.get(0).checkpoints.size()-1).message);
        System.debug('Delivered Date ::::::::: '+oMainWrapper.data.trackings.get(0).checkpoints.get(oMainWrapper.data.trackings.get(0).checkpoints.size()-1).checkpoint_time);
        System.debug('Delivered Date ::::::::: '+oMainWrapper.data.trackings.get(oMainWrapper.data.trackings.size()-1).delivery_time);
        
        Integer lastCheckpointPosition;
        
        for(TrackingWrapper track : oMainWrapper.data.trackings){
            if(track.checkpoints.size() > 0){
                lastCheckpointPosition = track.checkpoints.size()-1;
                mapTrackingNoMsg.put(track.tracking_number, track.checkpoints.get(track.checkpoints.size()-1).message);
                if(track.checkpoints.get(track.checkpoints.size()-1).message != null && (track.checkpoints.get(track.checkpoints.size()-1).message).toLowerCase().contains(STRDELIVERED))
                    mapTrackingNoAndDeliveryDate.put(track.tracking_number, track.checkpoints.get(track.checkpoints.size()-1).checkpoint_time);
            }
        }// end of for
        
        System.debug('Tracking Message Map :::::::::::::'+mapTrackingNoMsg);
        System.debug('Tracking Message Map with date :::::::::::::'+mapTrackingNoAndDeliveryDate);
    }
    
    public void updateLastStatus(){ 
    	
        List<Despatch__c> listDespatchUpdate = new List<Despatch__c>();
        String strDeliveredDateTime = '';
           
        // creating a map of tracking number and Desptch records so as to update Lase Delivery Status of each Despatch
        for(Despatch__c despatch : [select id,
                                           Last_Delivery_Status__c,
                                           Waybill_No__c,
                                           Delivered_Date__c    
                                    from Despatch__c]){
            if(mapTrackingNoMsg.containsKey(despatch.Waybill_No__c)){
                System.debug('Status ::::: ' + mapTrackingNoMsg.get(despatch.Waybill_No__c));
                despatch.Last_Delivery_Status__c = mapTrackingNoMsg.get(despatch.Waybill_No__c);
                System.debug('Status ::::: ' + despatch.Last_Delivery_Status__c);
            }
            if(mapTrackingNoAndDeliveryDate.containsKey(despatch.Waybill_No__c)){
                strDeliveredDateTime = mapTrackingNoAndDeliveryDate.get(despatch.Waybill_No__c);
                if(strDeliveredDateTime.contains('T'))
                    strDeliveredDateTime = strDeliveredDateTime.replace('T',' ');
                if(strDeliveredDateTime.contains('Z'))
                    strDeliveredDateTime = strDeliveredDateTime.replace('Z','');
                despatch.Delivered_Date__c = DateTime.valueOf(strDeliveredDateTime);
                
            }// end of if
            if(despatch.Last_Delivery_Status__c != '' || despatch.Delivered_Date__c != null)
                listDespatchUpdate.add(despatch);
        }// end of for
        
        // updating latest delivery status
        if(!listDespatchUpdate.isEmpty()){
            update listDespatchUpdate;
        }
    }// end of execute()
    
     
     public class MainWrapper{
        
        public DataWrapper data;
     }// end of MainWrapper
     
     public class DataWrapper{
        public List<TrackingWrapper> trackings;
        public DataWrapper(){
            trackings = new List<TrackingWrapper>();
        }
     }// end of DataWrapper
     
     public class TrackingWrapper{
        public String tracking_number;
        public String delivery_time;
        
        public List<CheckpointWrapper> checkpoints;
        
        public TrackingWrapper(){
            checkpoints = new List<CheckpointWrapper>();
        }
     }// end of TrackingWrapper
     
     public class CheckpointWrapper{
        public String message;
        public String checkpoint_time;
     }// end of CheckpointWrapper

}// end of class