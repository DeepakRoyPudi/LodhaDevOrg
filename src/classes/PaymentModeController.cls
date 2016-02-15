public with sharing class PaymentModeController {

    public Payment_Mode__c mode{get;set;}
    public Booking_Payment_Transaction__c booking_tran{get;set;}
    public List<Booking_Details__c> bookinglist{get;set;}
    public List<Booking_Payment_Transaction__c> transaction_list{get;set;}
    public Id booking_id{get;set;}
    public String error{get;set;}
    public String error1{get;set;}
    public String dup_error{get;set;}    
    public String typeoftransaction{get;set;}
    
    public list<selectoption> getOldTransactionTypes(){
        List<selectoption> transLst=new List<selectoption>();
        transLst.add(new selectoption('','---None---'));
        transLst.add(new selectoption('RTGS','RTGS'));
        transLst.add(new selectoption('NEFT','NEFT'));   
        return transLst;
    }
    
    public PaymentModeController() {
      booking_tran = new Booking_Payment_Transaction__c();
      error = null;
      dup_error = null;
      getBookingdata();
      init();
    }
    
    Public void init(){
      
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
    
    public void getBookingdata() {
      
      User userdetail = [select accountid, id from user where id =: userinfo.getuserid()];
      bookinglist = [select Id,Primary_Applicant__c,Co_Applicant__c,CRN__c,CLuster__c,Flat_No__c,Project__c,Wing__c from Booking_Details__c where Account__c =: userdetail.accountid limit 1];
      system.debug('!!!!!!!!!!'+bookinglist);
      for(Booking_Details__c br:bookinglist ) {
        booking_tran.CRN__c = br.CRN__c;
        booking_tran.Cluster__c = br.CLuster__c;
        booking_tran.Flat__c = br.Flat_No__c;
        booking_tran.Project_Name__c = br.Project__c;
        booking_tran.Wing__c= br.Wing__c ;
        booking_tran.Booking__c = br.Id;
        booking_tran.Account_Name_New__c= br.Primary_Applicant__c;
        booking_tran.Co_Applicant_Name_New__c= br.Co_Applicant__c;
        booking_id = br.Id;
      }
    }
    
    public PageReference paymentsave() { 
        error = null;
        dup_error = null;
        error1=null;
        
        try {
            booking_tran.Type_of_Transaction_del__c=typeoftransaction;
            if(booking_tran.Type_of_Transaction_del__c == '' || booking_tran.Type_of_Transaction_del__c == null ){
                error1= 'Error: Transaction type is mandatory to save.';
                system.debug('inside no transaction1'+booking_tran.Type_of_Transaction_del__c);
                return null;            
            }
            //booking_tran.Uniqueness__c=booking_tran.CRN__c+'_'+booking_tran.UTR_Code__c+'_'+booking_tran.Amount_Transferred__c+'_'+booking_tran.Transaction_Date__c.day()+'.'+booking_tran.Transaction_Date__c.month()+'.'+booking_tran.Transaction_Date__c.Year();
            //system.debug('@@@@@@@@@@@@@'+booking_tran.Uniqueness__c);
            insert booking_tran;
        }
        catch(DMLException e) {
            
            System.debug('@@ Insert Failed' + e.getMessage());
            String exception_error = e.getMessage();
            String validation_error_msg_1 = 'FIELD_CUSTOM_VALIDATION_EXCEPTION';  
           
            //dont reload the page in case of custom validation errors so as to retain error messages
            if(exception_error.contains(validation_error_msg_1)) {
                system.debug('@@@@@@@@@@@@@validation');
                return null;
            }
           else if(exception_error.contains('DUPLICATE_VALUE') && booking_tran.UTR_Code__c != null) {
                error = 'Error:';
                system.debug('@@@@@@@@@@@@@dup');
                Booking_Payment_Transaction__c bptDupObj=[select id,Status__c,CRN__c,Uniqueness__c,Amount_Transferred__c,Transaction_Date__c,UTR_Code__c from Booking_Payment_Transaction__c where UTR_Code__c=:booking_tran.UTR_Code__c AND CRN__c=:booking_tran.CRN__c AND Transaction_Date__c=:booking_tran.Transaction_Date__c AND Amount_Transferred__c=:booking_tran.Amount_Transferred__c Limit 1];
                dup_error = 'The same transaction exists in the system in Approved/Pending/Rejected stage. Please contact your Relationship Manage in case of any queries.';
                
                return null;
            }
           
            else {
                error = null;
                dup_error = null;
                
                //if no custom validation error then reload the page
                PageReference pr = new PageReference(System.currentPageReference().getURL());              
                pr.setRedirect(true);               
                return pr;     
            }
        }
        //reload the page to make inputfields blank
        PageReference pr = new PageReference(System.currentPageReference().getURL());              
        pr.setRedirect(true);               
        return pr;
    }
    
    // public Getter to provide table headers 
   public string[] getheaders() { 
     return new string [] {'Project Name','Cluster','Wing','Flat', 'Bank Name', 'Amount  Transferred', 'Remitted to Account','Type of Transaction','UTR Code','Transaction Date','Status', 'Accounts Remarks' }; 
   }
   
   public List<Booking_Payment_Transaction__c> getTransactionList() {
     transaction_list = [Select Project_Name__c,Wing__c,Type_of_Transaction_del__c,Uniqueness__c,Flat__c,Cluster__c,Bank_Name__c,Amount_Transferred__c,UTR_Code__c,
                         Transaction_Date__c,Status__c, Accounts_Remarks__c, Remitted_to_Account__c from Booking_Payment_Transaction__c 
                         Where Booking__c =: booking_id Order By CreatedDate DESC];
     return transaction_list;
   }

}