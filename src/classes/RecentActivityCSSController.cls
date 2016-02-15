public class RecentActivityCSSController {
public Payment_Mode__c mode{get;set;}
@testVisible private static final String widgetName = 'Recent Activity';
public String Customer_CRN {get;set;} //get parameter from component
public RecentActivityCSSController()
    {
      try {
        String userid = userinfo.getuserid();
       
        User userdetail = [select accountid, id from user where id =: userid];
        Account acc = [select id,(select id,Project__c,Plant__c from Booking_Details__r) from Account where id =:userdetail.accountid limit 1];      
        
        String projectid;
        String plant;
        if(acc!=null){
          for(Booking_Details__c bd : acc.Booking_Details__r){
            projectid=bd.Project__c;
            plant=bd.Plant__c;
          }
        
          if(plant!=null){
            mode = [Select id, Name, In_Favor_of__c, Payable_in_City__c, Account_Number__c, Bank_Name__c,
                    Bank_Address__c, IFSC_Code__c, MICR_Code__c, SWIFT_Code__c, UTR_Code__c, Date_of_Transaction__c, 
                    Branch__c from Payment_Mode__c where  Plant__c =:plant];    
          } 
        }        
      } 
      catch(System.Exception e) {
        ApexPages.addMessages(e);    
      }   
                                                                   
    }
    
  //Function to increment click count for a User
    public void clickCount() {
        ClickCountCSSHelper.incrementCount(widgetName);
        
    }
}