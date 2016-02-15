/*
*    Description : A scheduler to call the apex class which is getting the response from Aftership
*                  and updates Laste Delivery status and Delivered date in Depstach object
*
*    Vesrion     Date            Author           Description   
*     1.0      16/09/2014    Asmita (Eternus)    Initial Draft
*/

global class AftershipLastStatusUpdateCallScheduler implements Schedulable{
    
    global void execute(SchedulableContext sc) {
        
        callGetTrackingCalloutMethod();
    }
    
    @future(callout = true)
    public static void callGetTrackingCalloutMethod(){
        UpdateDespatchLastStatusFromAftership updateLastStatus = new UpdateDespatchLastStatusFromAftership();
        updateLastStatus.getTrackings();         
        updateLastStatus.updateLastStatus();
    }
}