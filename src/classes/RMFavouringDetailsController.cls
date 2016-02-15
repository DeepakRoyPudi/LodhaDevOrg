/*
Description:
the class used as controller in RMFavouringDetailsAndPaymentTransaction page
which get the page param crn and fetch the favoring details  
 
@Created by: Sudeep Kumar Dube 
@Created Date: 11/06/2015
 
 --------------------------------------------------------------------------------
 | Modified By      | Modified Date       | Version        | Description         |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------

*/


public class RMFavouringDetailsController{

//apex parameter set this value in constructor
public String CRN{get;set;}

//record of related booking details 
public Payment_Mode__c mode{get;set;}

public RMFavouringDetailsController(){
  
  CRN=ApexPages.currentPage().getParameters().get('crn');
  mode=new Payment_Mode__c ();
  getmode();
}

//method call from contructor and fetch the related faouring records using CRN   query to Account->booking Detail->Paymnet Mode 
public void getmode(){

  try {
        Account acc = [select id,(select id,Project__c,Plant__c from Booking_Details__r) from Account where crn__c =:CRN limit 1];               
        
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


}