public  class attachmentCustomController 
{
   public List<attachment> attList {get;set;}
   public String profileName {get;set;}   
   public Id attchId{get;set;}
   public Boolean isDelete {get;set;}
   public Boolean isEdit {get;set;}
   
   private Id bookingId;
   private Set<String> setProfileName = new Set<String>{'Sap Mapper', 'Accounts Admin','SPOC Team Leader','SPOC Team Member'};
   
   public attachmentCustomController(ApexPages.StandardController controller) 
   {   
        isEdit = true;  
        isDelete = true;           
        bookingId = Apexpages.currentpage().getParameters().get('id');                
        attList = [SELECT id,name,LastModifiedById,CreatedById,LastModifiedDate FROM attachment where parentid =:bookingId ];
        profileName = [select id, name, ProfileId, Profile.Name from user where id=:userinfo.getUserId() ].Profile.Name; //getProfileId()
         
        if(setProfileName.contains(profileName))
        {  
            isEdit = false;
            isDelete = false;
        }     
    }
    
    public PageReference editmethod()
    {
        PageReference returnPage = new PageReference('/'+attchId+'/e');
        returnPage.setRedirect(true);
        return ReturnPage; 
        /*else if(profileName == 'Sap Mapper')
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Unauthorized user ,user don\'t have permission !!!!'));
            return null;
        }
        else
            return null;*/
    }
    
    public PageReference viewmethod()
    {
        PageReference returnPage = new PageReference('/'+attchId);
        returnPage.setRedirect(true);
        return returnPage; 
    }
    
    public void deletemethod()
    {
        Booking_Payment_Transaction__c objBPT = [Select Status__c From Booking_Payment_Transaction__c where Id =:bookingId];
        if(objBPT.Status__c != 'Pending')
        {
            ApexPages.addmessage(new ApexPages.Message(ApexPages.Severity.INFO,'You can not delete this because BTR has been Approved or Rejected.'));
            return;
        }
        if(profileName != null && profileName != 'Sap Mapper')
        {
            Attachment attach = [SELECT id,name FROM attachment WHERE id =:attchId];
            delete attach;       
            attList = [SELECT id,name,LastModifiedById,CreatedById,LastModifiedDate FROM attachment where parentid =:bookingId ];
        }
        /*else if(profileName == 'Sap Mapper' && isDelete)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Unauthorized user ,user don\'t have permission !!!!'));
        }*/
    }
}