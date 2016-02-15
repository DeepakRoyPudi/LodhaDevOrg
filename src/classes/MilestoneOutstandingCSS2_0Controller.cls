/* 
Description:
This class is used for MilestoneOutstanding (crisp) Component

 @Created by: Shruti Nikam
 @Created Date:  9/03/15   
 
 --------------------------------------------------------------------------------
 | Modified By      | Modified Date       | Version        | Description         |
 --------------------------------------------------------------------------------
 | Sneha p               03/04/2015          1.1             Logic for tracking click count
 --------------------------------------------------------------------------------
 | |Trupti D.           16/07/2015          1.2             Updated logic -used Demand object 
                                                            for fetching records
 --------------------------------------------------------------------------------
*/


public class MilestoneOutstandingCSS2_0Controller {
    
    //Private Constants
    @testVisible private static final String widgetName = 'Upcoming/Due Payments';
    public static String DemandObj = 'Demands__c';
    public decimal TotalAmtDue {get; set;}
    public String Customer_CRN {get;set;} //get parameter from component
    public List<Demands__c> listDemands1 {get; set;}
   
    public MilestoneOutstandingCSS2_0Controller ()
    {
       //init();
    }
    
    //Fetch records for Milsestone Outstanding and calculate total balance due
    public void getInit(){
        
        if(String.isNotBlank(Customer_CRN)){
               listDemands1 = new List<Demands__c>();
                TotalAmtDue = 0;  
                List<Booking_Details__c> bdList = new List<Booking_Details__c>
                                                    ([Select id,Account__c,Flat_ID__c  
                                                        from Booking_Details__c 
                                                            where CRN__c = :Customer_CRN LIMIT 1]);
                if(bdList.size()>0){
                    listDemands1= CreateQueryHelper.getRecords(DemandObj,'Id',
                                            'where Flat_ID__c = \''+bdList[0].id +'\' and Billing_Date__c != null', 
                                                CreateQueryHelper.MilestoneOutstandingCSS,'order by Due_Date__c asc NULLS LAST','');
                                    
                    //calculate total balance due
                    if(listDemands1.size() > 0){
                        for(Demands__c d : listDemands1){
                            if(d.Balance_Due__c != null){
                                TotalAmtDue = TotalAmtDue + d.Balance_Due__c ;
                            }
                        }
                    }
                    List<Demands__c> lstMilestone = new List<Demands__c>();
		            for(Demands__c demand: listDemands1){
		                if(demand.Balance_Due__c > 0 ){
		                    lstMilestone.add(demand);
		                }
		            }
		            listDemands1.clear();
		            for(Demands__c demand: lstMilestone){
		                listDemands1.add(demand);
		            }
		                  
                }
        }
     
    }
    //Method to increment the widget counter
    public void clickMilestoneCount() {
        ClickCountCSSHelper.incrementCount(widgetName);
    }
   
}