/*
Description:
this class is used as extension controller for new booking transaction from RM available Booking Transaction widget 
and the vf page that is used  will open in two ways:
1. in new bpt click button. 
2. in the iframe of favoring details with new transaction and transaction history. 
'vw' a parameter is used in return pagereference in save function 
for identification of the schenario from where the page is opened.

 @Created by: Sudeep Kumar Dube 
 @Created Date: 15/06/2015
 
 --------------------------------------------------------------------------------
 | Modified By      | Modified Date       | Version        | Description         |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------

*/


public class RMNewPaymentTransactionController 
{
    //public Attachment objAttachment {get; set;}
    Public Boolean newBpt{get;set;}
    public Boolean noRecord{get;set;}
    Public Boolean closeFetch{get;set;}
    Public String crn{get;set;}
    Public List<Booking_Details__c> bdetails{get;set;}
    Public Booking_Payment_Transaction__c bpt{get;set;}
    Public String error{get;set;}
    Public String dup_error{get;set;}  
    Public Boolean Isduplicate{get;set;}
    public Boolean isFileUpload{get;set;}
    private Set<String> setProfileName = new Set<String>{'Sap Mapper','Accounts Admin'};
    //public string filenames{get; set;}
    public List<Attachment> lstAttachment {get;set;} 
    public List<Attachment> lstInsertAttachment{get;set;}
    //record success fully saved flag if true the yes and false not saved 
    //this variable will be used in javascript to check if record save then refresh both i frame on faveoring details page 
    public Boolean isRecordSaved{get;set;} 
    
    public RMNewPaymentTransactionController(ApexPages.StandardController controller) 
    {
        isRecordSaved=false;
        lstInsertAttachment=new List<Attachment>();
        newBpt = false;
        noRecord = false;
        closeFetch = true;
        isFileUpload = true;
        error = null;
        dup_error = null;
        Isduplicate = false;
        //objAttachment = new Attachment();
        lstAttachment = new List<Attachment>();
        crn = ApexPages.currentPage().getParameters().get('CRN');
        String profileName = [select id, name, ProfileId, Profile.Name from user where id=:userinfo.getUserId() ].Profile.Name;
        if(setProfileName.contains(profileName))
            isFileUpload = false;
        if(crn != null)  
            fetch();    
    }

    Public void fetch(){
        try{
            closeFetch = false;
            bpt = new Booking_Payment_Transaction__c();
            if(crn != null){            
                bdetails = [SELECT id, Name, Project__c, Cluster__c,Primary_Applicant__c,Co_Applicant__c,Wing__c, CRN__c, Flat_No__c 
                                FROM Booking_Details__c 
                                WHERE CRN__c =: crn LIMIT 1];
                if(bdetails.size()!= 0){
                    for(Booking_Details__c bd : bdetails ){
                        bpt.Booking__c = bd.id;
                        bpt.CRN__c = bd.CRN__c;
                        bpt.Project_Name__c = bd.Project__c;
                        bpt.Cluster__c = bd.Cluster__c;
                        bpt.Wing__c = bd.Wing__c;
                        bpt.Flat__c = bd.Flat_No__c;
                        
                        bpt.Account_Name_New__c = bd.Primary_Applicant__c;
                        bpt.Co_Applicant_Name_New__c = bd.Co_Applicant__c;
                    }                        
                    
                    newBpt = true;
                }else{
                    newBpt = false;
                    closeFetch = true;
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'No records found'));
                }
            }else{
                newBpt = false;
            }
        }catch(System.Exception e){
            ApexPages.addMessages(e);    
        }                                                             
    }
    
    //Add by Anupam Agrawal: Check the validation of required fields. 
    public void addAttachment(){
        Boolean isCorrect = bpt.Type_of_Transaction_del__c != null &&
                            bpt.Bank_Name__c != null &&
                            bpt.Amount_Transferred__c != null &&
                            bpt.Remitted_to_Account__c != null &&
                            bpt.Transaction_Date__c != null &&
                            bpt.Bank_Account_Holders_Name__c != null;
        
       if(!isCorrect){
           ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Insert all Mandatory field(s) value before Attachment.'));
       }
       else if(bpt.Type_of_Transaction_del__c != 'Wire Transfer' && (bpt.UTR_Code__c == null || bpt.UTR_Code__c.trim() == '')){
           ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Enter UTR Code value.'));
       }
       else{
           lstAttachment = new List<Attachment>();
           
            
           for(Attachment attach :lstInsertAttachment){
           lstAttachment.add(attach);
           System.debug('attch::::'+attach);
           }
           
           for(Integer i = lstInsertAttachment.size(); i < 5 ; i++)             
               lstAttachment.add(new Attachment());
       
       }
    }
    
    public void UploadFile()  
    {  
        //PageReference pr; 
         integer i=0; 
         lstInsertAttachment.clear();
        for(Attachment objAttachmentFile : lstAttachment){
                System.debug('body:::'+objAttachmentFile.body);
                    if(objAttachmentFile.body != null){
                       System.debug('nameFile::::'+objAttachmentFile.name);
                     lstInsertAttachment.add(objAttachmentFile);  
                   }
         }
        lstAttachment.clear();
        
    }      
    
    
    Public pageReference bptSave(){
        error = null;
        dup_error = null;
        
        try{ 
            if(bpt.Type_of_Transaction_del__c.equalsIgnoreCase('Direct cheque') && bpt.MT940__c == null){ 
                ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.ERROR,'MT940 is mandatory to save.'));
                lstAttachment = new List<Attachment>();
                return null;
            }     
            //bpt.Uniqueness__c=bpt.CRN__c+'_'+bpt.UTR_Code__c+'_'+bpt.Amount_Transferred__c+'_'+bpt.Transaction_Date__c.day()+'.'+bpt.Transaction_Date__c.month()+'.'+bpt.Transaction_Date__c.Year();
            insert bpt;
            isRecordSaved=true;
            
           System.debug('isRecordSaved:::'+isRecordSaved);
            try{
                /*
                List<Attachment> lstInsertAttachment = new List<Attachment>();
               
                for(Attachment objAttachmentFile : lstAttachment){
                System.debug('body:::'+objAttachmentFile.body);
                    if(objAttachmentFile.body == null){
                       objAttachmentFile.parentId = bpt.id;
                        
                        lstAttachment.remove(i);
                    }
                i=i+1;
                }
                 */
                for(Attachment objAttachmentFile :lstInsertAttachment ) {
                  objAttachmentFile.parentId = bpt.id;
                }
                
                if(!lstInsertAttachment.isEmpty())
                    insert lstInsertAttachment;      
                  system.debug('lstInsertAttachment:::'+lstInsertAttachment.size());   
             }catch(Exception ex){
                lstAttachment = new List<Attachment>();
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Unexpected error occurred: Attachment Limit Exceeded.Contact your system administrator'));
                return null;
            }
        }catch(System.Exception e){
            lstAttachment = new List<Attachment>();
            Isduplicate=false;
            String exception_error = e.getMessage();
            String validation_error_msg_1 = 'FIELD_CUSTOM_VALIDATION_EXCEPTION';
            
            if(exception_error.contains(validation_error_msg_1)) {
                system.debug('@@@@@@@@@@@@@custom validation');
                ApexPages.addMessages(e); 
                return null;
            }
            else if(exception_error.contains('DUPLICATE_VALUE')) {
                if( bpt.UTR_Code__c != null ){
                    Booking_Payment_Transaction__c bptDupObj=[select id,Status__c,CRN__c,Uniqueness__c,Amount_Transferred__c,Transaction_Date__c,UTR_Code__c from Booking_Payment_Transaction__c where UTR_Code__c=:bpt.UTR_Code__c AND CRN__c=:bpt.CRN__c AND Transaction_Date__c=:bpt.Transaction_Date__c AND Amount_Transferred__c=:bpt.Amount_Transferred__c Limit 1];
                    system.debug('@@@@@@@@@@@@@dup');
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Same transaction exists in the system for '+bptDupObj.CRN__c+' & '+bptDupObj.Status__c+' under '+bpt.UTR_Code__c+'. Contact your PI/Admin to update/reject the transaction.');
                    
                    ApexPages.addMessage(myMsg);
                    error='/'+bptDupObj.id;
                    Isduplicate=true;
                    return null;
                }
                else{
                    Booking_Payment_Transaction__c bptDupObj=[select id,Status__c,CRN__c,Uniqueness__c,UTR_Code__c from Booking_Payment_Transaction__c where CRN__c=:bpt.CRN__c AND UTR_Code__c=:bpt.UTR_Code__c AND Amount_Transferred__c=:bpt.Amount_Transferred__c AND Transaction_Date__c=:bpt.Transaction_Date__c Limit 1];
                    system.debug('@@@@@@@@@@@@@dup wire transfer'); 
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Same transaction exists in the system for '+bptDupObj.CRN__c+' & '+bptDupObj.Status__c+' under '+bpt.UTR_Code__c+'. Contact your PI/Admin to update/reject the transaction.');
                    ApexPages.addMessage(myMsg);
                    error='/'+bptDupObj.id;
                    Isduplicate=true;
                    return null;               
                }            
            }
            else{
                system.debug('@@@@@@@@@@@@@else');
                error = null;
                dup_error = null;  
                
                PageReference pr = new PageReference(System.currentPageReference().getURL());              
                pr.setRedirect(true);               
                return pr;   
            } 
        }
        //the below string variable contains where the page is open in new browser tab with header and without header 
        String whereItisUsed=ApexPages.currentPage().getParameters().get('isdtp');
        if(String.isnotBlank(whereItisUsed)){
        
            if(whereItisUsed.equalsIgnoreCase('vw')){
         
            System.debug('@@@@insidevw:::::');            
         
            return null ;
            
            }
            else{
                PageReference bptPage = new ApexPages.StandardController(bpt).view();
                bptPage.setRedirect(true);
                return bptPage;
                 }
        }
        else{
        PageReference bptPage = new ApexPages.StandardController(bpt).view();
        bptPage.setRedirect(true);
        return bptPage;
        }
    }
}