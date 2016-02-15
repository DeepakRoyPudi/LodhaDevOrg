/* 
Description : Controller class for visusalforce page RMLandingPage
 @Created by: Sudeep Dube
 @Created Date: 16/07/2015
 
 --------------------------------------------------------------------------------
 | Modified By      | Modified Date       | Version        | Description         |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------

*/

public class RMpreLandingPageController{

       public String CRN {get;set;}
       public RMpreLandingPageController() { }
        
       

       public PageReference gotoCustomer360(){
 
         if(String.isnotBlank(CRN)){ 
          CRN=CRN.trim(); 
          List<Account> accList= [select id,
                                         (select id 
                                          from Booking_Details__r 
                                          where CRN__c=:CRN)
                                 from Account 
                                 where CRN__c=:CRN 
                                 Limit 1];
          
          if(accList.size()>0){
            
            if(accList[0].Booking_Details__r.size()>0){
            
                  PageReference redirectPage = Page.RMLandingPage1;
                  
                  redirectPage.getParameters().put('CRN',CRN);
                  return redirectPage;
             }
             else{
                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,
                                                            System.Label.PrelandingpageErrorNoBookingDetail));  
             return null;
             }     
          }
          else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,
                                                       System.Label.PrelandingpageErrorNoAccountForCRN));
            return null; 
          }
         }
         else{
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,
                                                      System.Label.PrelandingpageErrorNoCRN));   
           return null;
         }
          
        }

}