public class BookingDetailsController{
    
    public String retURL;
    Booking_Details__c obj;
    public List<Demands__c> demands;
    
    public BookingDetailsController(ApexPages.StandardController controller) {
        this.obj= (Booking_Details__c)controller.getRecord();      
        retURL = ApexPages.currentPage().getParameters().get('retURL');    
    }

    public BookingDetailsController() {     
        retURL = ApexPages.currentPage().getParameters().get('retURL'); 
    }
    
    public Id UId = UserInfo.getUserId();
    public ID accid = [Select id, Accountid from User where id = :UId].accountid;

    public List<Booking_Details__c> bdList = new List<Booking_Details__c>([Select 
    id,Account__c,Flat_ID__c from Booking_Details__c where Account__c = :accid LIMIT 1]);
    
    public ID bdId;// = bdList[0].id;
            
    public PageReference  autoAssignment(){
    
        PageReference fieldpage ;
        String Utype = UserInfo.getUserType();
        if(bdList.size() != 0) bdId = bdList[0].id;
        //Id UId = UserInfo.getUserId();    
        if(Utype != 'Standard'){
        
            /*accid = [Select id, Accountid from User where id = :UId].accountid;
            List<Booking_Details__c> bdList = new List<Booking_Details__c>();
            bdList = [Select id,Account__c from Booking_Details__c where Account__c = :accid LIMIT 1];*/ 
            
            if(bdId != null){
            //bdId = bdList[0].id;
            fieldpage = new pagereference('/apex/bookingdetails?id='+bdId);
            fieldpage.setredirect(true);
            }
            else{
            fieldpage = new pagereference('/apex/NoBookingDetails');
            fieldpage.setredirect(true);
            }
        }else{
        fieldpage = new pagereference('/a0a/o');
        fieldpage.setredirect(true);
        }
        
        return fieldpage;
 
    }
    
    public List<Demands__c> getAllDemands() {
    if(bdList.size() != 0) bdId = bdList[0].id;
                if(demands == null) demands = [select Payment_Milestone_Formula__c,Custom_Due_Date__c, Due_Date__c,Payment_received_on__c,Demand_amount__c,Amount_received__c,Balance_Due__c,Overdue_Status__c 
                                                FROM Demands__c
                                                WHERE Flat_ID__c =:bdID];

                return demands;

        }
        
    public string gettotalDemandAmt(){
    if(bdList.size() != 0) bdId = bdList[0].id;
    decimal totalDemandAmtNum = 0;
    string totalDemandAmtstr = '';
    List<AggregateResult> totalDemandAmt = new List<AggregateResult>();
    totalDemandAmt = [Select Sum(Demand_amount__c) DemandAmt 
                              FROM Demands__c 
                              Where (Flat_ID__c = :bdId)
                              ]; 
    system.debug('booking id: '+bdID);
    if(totalDemandAmt.size() != 0 && totalDemandAmt[0].get('DemandAmt') != null)
        {
        totalDemandAmtNum= ((decimal)totalDemandAmt[0].get('DemandAmt'));
        totalDemandAmtNum = totalDemandAmtNum.setScale(1);
        totalDemandAmtstr = 'INR '+ totalDemandAmtNum.format();
        }else{
            totalDemandAmtstr = 'INR 0';
        }
        return totalDemandAmtstr; 
    }
    
    public string gettotalAmtReceived(){
    if(bdList.size() != 0) bdId = bdList[0].id;
    decimal totalAmtRecNum = 0;
    string totalAmtRecstr = '';
    List<AggregateResult> totalAmtRec = new List<AggregateResult>();
    totalAmtRec = [Select Sum(Amount_received__c) AmtRec 
                              FROM Demands__c 
                              Where (Flat_ID__c = :bdId)
                              ]; 
    
    if(totalAmtRec.size() != 0 && totalAmtRec[0].get('AmtRec') != null)
        {
        totalAmtRecNum= ((decimal)totalAmtRec[0].get('AmtRec'));
        totalAmtRecNum = totalAmtRecNum.setScale(1);
        totalAmtRecstr = 'INR '+ totalAmtRecNum.format();
        }else{
            totalAmtRecstr = 'INR 0';
        }
        return totalAmtRecstr; 
    }
    
    public string gettotalBalnceDue(){
    if(bdList.size() != 0) bdId = bdList[0].id;
    decimal totalBalDueNum = 0;
    string totalBalDuestr = '';
    List<AggregateResult> totalBalDue = new List<AggregateResult>();
    totalBalDue = [Select Sum(Balance_Due__c) BalDue 
                              FROM Demands__c 
                              Where (Flat_ID__c = :bdId)
                              ]; 
    
    if(totalBalDue.size() != 0 && totalBalDue[0].get('BalDue') != null)
        {
        totalBalDueNum= ((decimal)totalBalDue[0].get('BalDue'));
        totalBalDueNum = totalBalDueNum.setScale(1);
        totalBalDuestr = 'INR '+totalBalDueNum.format();
        }else{
            totalBalDuestr = 'INR 0';
        }
        return totalBalDuestr;
    }
}