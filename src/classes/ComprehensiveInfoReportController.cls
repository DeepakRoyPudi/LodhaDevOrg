public with sharing class ComprehensiveInfoReportController {
    public Account account{get;set;}
    public Booking_Details__c booking{get;set;} 
    public Case cases {get;set;}
    
       
    map<String,Account> mapAccount{get;set;}
    map<string,Integer> mapcasecomplaint{get;set;}
    map<string,Integer> mapcaseGrievance{get;set;}
    map<string,Booking_Details__c> mapbooking{get;set;}
    
    
    public map<string,Account> getmAccounts(){        
            if(mapAccount == null){
                mapAccount = new map<String, Account>();            
                for( Account acc :Database.query('Select CRN__c, Co_Applicant__c ,LoyaltyID__c, CIP__c , Preferred_mode_of_Contact__c ,OwnerId , Ethinicity__c , Age__c , Marital_Status__c ,'+
                                                    +'No_of_children__c , Purpose_of_purchase_of_existing_property__c , Industry from Account ')){                                                    
                mapAccount.put(acc.CRN__c, acc);                                                    
                }
                        }
            return mapAccount;
        }
    
    public map<string,Booking_Details__c> getmBooking(){
        if(mapbooking == null){
            mapbooking = new map<string,Booking_Details__c>();
            for(Booking_Details__c bookings : Database.query('select Account__r.CRN__c, Consideration_Value__c , CV_paid__c , Project_Name__c from Booking_Details__c '))
                {
                mapbooking.put(bookings.Account__r.CRN__c,bookings);
                }
        }
        return mapbooking;
    }
    
/*  public map<string,case> mCase(){
        //mapcase = new map<string,case>();
        //for(case Cse :Database.query('') )
    }*/ 

  /*public map<string,Account> getmAccounts(){
      if(mapAccount == Null){
      mapAccount = new map<String,Account>();
      for(Account Acc : Database.query('select CRN__c,Co_Applicant__c , CIP__c ,LoyaltyID__c, Preferred_mode_of_Contact__c ,OwnerId ,Ethinicity__c ,Age__c,Marital_Status__c ,No_of_children__c , Purpose_of_purchase_of_existing_property__c,Industry,  (select Consideration_Value__c,CV_paid__c ,Project_Name__c from Booking_Details__r) from Account'))
          {
          mapAccount.put(Acc.CRN__c, Acc );
          }
      }
      return mapAccount;
      }*/
      
     /* This Method is used for displaying the Count fields of the case reports*/
      public void getmCase(){
            mapcasecomplaint = new map<string,Integer>();
            mapcaseGrievance = new map<string,Integer>();
            for(case Cse :[Select Account.CRN__c,Nature_of_Request__c  from case where Nature_of_Request__c ='Complaint' OR Nature_of_Request__c = 'Grievance' ])
            {
                if(cse.Nature_of_Request__c =='Complaint'){
                    if(mapcasecomplaint.isEmpty() && !mapcasecomplaint.containsKey(Cse.Account.CRN__c)){
                        mapcasecomplaint.put(Cse.Account.CRN__c ,1) ;
                    }else if(mapcasecomplaint.containsKey(Cse.Account.CRN__c)) {
                        Integer count = mapcasecomplaint.get(Cse.Account.CRN__c);
                        mapcasecomplaint.put(Cse.Account.CRN__c, ++count);
                    }
                    }else {
                        
                    if(cse.Nature_of_Request__c =='Grievance'){
                        if(mapcaseGrievance.isEmpty() && !mapcaseGrievance.containsKey(Cse.Account.CRN__c)){
                            mapcaseGrievance.put(Cse.Account.CRN__c ,1) ;
                        }else if(mapcaseGrievance.containsKey(Cse.Account.CRN__c)) {
                            Integer count = mapcaseGrievance.get(Cse.Account.CRN__c);
                            mapcaseGrievance.put(Cse.Account.CRN__c, ++count);
                            
                        }
                
                }
            }
           /* return mapcasecomplaint;*/
        } 
    }
    
    /*This Method is Used for displaying CaseInfo Report*/
    
        
}