/* 
Description:
This class is used for MilestoneOutstanding (crisp) Component

 @Created by: Shruti Nikam
 @Created Date:  9/03/15   
 
 --------------------------------------------------------------------------------
 | Modified By      | Modified Date       | Version        | Description         |
 --------------------------------------------------------------------------------
 |Sneha p               03/04/2015          1.1             Logic for tracking click count
 --------------------------------------------------------------------------------
 |Trupti D.             16/07/2015          1.2             Updated logic -used Demand object 
                                                            for fetching records
 -------------------------------------------------------------------------------*/
public class RecentMilestonesPaidCSS2_0Controller {
    
    @testVisible private static final String widgetName = 'Payments Received';
    public static String DemandObj = 'Demands__c';
    public List<Demands__c>  lstMilestonePaid {get; set;}
    //public Static String Cust_CRN{get;set;}
    public decimal TotalReceived {get;set;}
    public decimal Received_Percent {get;set;}
    public String Customer_CRN {get;set;} //get parameter from component
    public RecentMilestonesPaidCSS2_0Controller() {
        //init();
    }
       
    public void getInit(){     
     
        TotalReceived = 0;
        Received_Percent = 0;
        if(String.isNotBlank(Customer_CRN )){
            List<Booking_Details__c> bdList = new List<Booking_Details__c>(
                                                [Select id,Account__c,Consideration_Value__c,Flat_ID__c  
                                                    from Booking_Details__c 
                                                        where CRN__c = :Customer_CRN LIMIT 1]);
            lstMilestonePaid = new List<Demands__c>();
            
            if(bdList.size()>0){
            lstMilestonePaid =  CreateQueryHelper.getRecords(DemandObj,'Id,Createddate,Billing_Date__c,Balance_Due__c',
                                    'where Flat_ID__c = \''+bdList[0].id +'\' and Billing_Date__c != null', 
                                        CreateQueryHelper.MilestonePaidCSS2_0,'order by Payment_received_on__c desc NULLS LAST','');
            } 
           
            //Calculate Total Amount Received
            if(lstMilestonePaid.size() >  0) 
            {
                for(Demands__c d : lstMilestonePaid)
                {
                    if(d.Amount_received__c != null)
                    {
                        TotalReceived =TotalReceived + d.Amount_received__c;
                    }
                }
            }
            List<Demands__c> lstMilestonePaid1 = new List<Demands__c>();
            for(Demands__c demand: lstMilestonePaid){
                if(demand.Balance_Due__c <= 0 || (demand.Balance_Due__c > 0 && demand.Amount_received__c > 0 )){
                    lstMilestonePaid1.add(demand);
                }
            }
            lstMilestonePaid.clear();
            for(Demands__c demand: lstMilestonePaid1){
                lstMilestonePaid.add(demand);
            }
            
            
          
           //calculate Payment receive in percent
            if(bdList != null && TotalReceived >=0 && bdList[0].Consideration_Value__c != null && bdList[0].Consideration_Value__c > 0){
                Received_Percent = (TotalReceived / bdList[0].Consideration_Value__c) * 100;
                Received_Percent= Received_Percent.setScale(2);
            }
            
             else
            {
                Received_Percent = 0;
            }
           
        }
        
    }

    //Method to increment click count of widget
    public void clickPaymentRecdCount() {
        ClickCountCSSHelper.incrementCount(widgetName);
    }
}