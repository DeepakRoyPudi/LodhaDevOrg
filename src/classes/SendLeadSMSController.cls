public with sharing class SendLeadSMSController {

    //Variable Declaration
    Lead LeadList = new Lead();
    Public String smsText {get;set;}
    Public String smsType {get; set;}
    Public Boolean sendSMS {get; set;}
    Boolean stopSms;
    String vcDate = '';
    Integer smsCount;
    Id leadId;
    
    public SendLeadSMSController(ApexPages.StandardController controller) {
        smsText = null;
        smsType = null;
        sendSMS = True;
        
        stopSms = False;
        lead objLead = (Lead)controller.getRecord();
        leadId = objLead.Id;
        
        List<sObject> sObjectList = new List<sObject>();
        //Getting Opportunity, ProjectName, OpportunityHistory Records
        sObjectList = [Select Id, Name, Mobile__c,
                            (Select Call_Status__c From R00NR0000000Md3NMAS__r Order by Name Desc),
                            Project_Name__r.Date_Time__c, Project_Name__r.Date__c, Project_Name__r.Name, Project_Name__r.Contact_Center_No__c, 
                            Project_Name__r.Project_Address__c, Project_Name__r.Send_SMS__c, Project_Name__r.Thank_You_Sms__c, 
                            Project_Name__r.Thank_You_Sms_Template__c, Project_Name__r.Visit_Confirmed_Sms__c, Project_Name__r.Visit_Confirmed_Sms_Template__c, 
                            Project_Name__r.Non_Contactable_Sms__c, Project_Name__r.Non_Contactable_Sms_Template__c, LeadSource From Lead Where Id =: leadId];
        
        if(sObjectList.size() > 0)
        {
            LeadList = (lead) sObjectList.get(0);
            
        getItems();
        }
    }
    
    
    Public Pagereference sendSMS()
    {
        system.debug('#Sending SMS...');
        if(LeadList.Mobile__c != null)
        {
            if(smsType != null && smsType != '-- Select --' && smsText != '' && smsText != null )
            {
                //create object of SMS history
                smagicinteract__smsMagic__c smsObj = new smagicinteract__smsMagic__c();
                
                smsObj.smagicinteract__Lead__c = LeadList.Id;

                smsObj.smagicinteract__PhoneNumber__c = LeadList.Mobile__c;

                smsObj.smagicinteract__SMSText__c = smsText;

                smsObj.smagicinteract__SenderId__c = 'Lodha';

                smsObj.smagicinteract_Name_custom__c = LeadList.Name;
                
                smsObj.SMS_Type__c = smsType;
                
                smsObj.smagicinteract__external_field__c = smagicinteract.ApexAPI.generateUniqueKey();
                if(stopSms == true){
                    smsObj.smagicinteract__disableSMSOnTrigger__c = 1;
                }else{
                    smsObj.smagicinteract__disableSMSOnTrigger__c = 0;
                }
                system.debug('@@@@@@@@@@@@@@Boolean is:'+smsObj.smagicinteract__disableSMSOnTrigger__c);
                try{
                    insert smsObj;
                    System.debug('#SMS Send Succefully');
                }catch(ListException e)
                {
                    System.debug('#Error in SMS Sending:' + e);
                }
             }
        }
        return null;
    }
        
    public List<SelectOption> getItems() {
    
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('-- Select --','-- Select --'));
        try{  
        If(LeadList.Project_Name__r.Send_SMS__c && LeadList.Project_Name__r.Non_Contactable_Sms__c && LeadList.R00NR0000000Md3NMAS__r[0].Call_Status__c != 'Call Completed' && LeadList.R00NR0000000Md3NMAS__r[1].Call_Status__c != 'Call Completed' && LeadList.LeadSource != 'Cross Project')
        {
            options.add(new SelectOption('Non-Contactable','Non-Contactable'));
            sendSMS = False;
        }
        }
        catch(Exception e)
        {
        
        }
        return options;
    }
    
    Public PageReference smsTemplate()
    {
        if(smsType != null && smsType != '-- Select --')
        {

            //Template SMS for Non-Contactable
            if(smsType == 'Non-Contactable')
            {
                smsText = LeadList.Project_Name__r.Non_Contactable_Sms_Template__c;
            }   
                
           //Replacing dynamic Project Name in SMS Template
           if(smsText != null && smsText != '')
           {
                //Replacing dynamic Contact No. in SMS Template
                smsText = smsText.replace('<Project Name>', LeadList.Project_Name__r.Name);
                
                if(LeadList.Project_Name__r.Contact_Center_No__c != NULL){
                    smsText = smsText.replace('<Contact No.>', LeadList.Project_Name__r.Contact_Center_No__c);
                }
                else
                {
                    smsText = smsText.replace('<Contact No.>', '');
                }
                
                //Replacing dynamic Project Address in SMS Template
                if(LeadList.Project_Name__r.Project_Address__c != NULL){
                    smsText = smsText.replace('<Project Address>', LeadList.Project_Name__r.Project_Address__c);
                }
                else
                {
                    smsText = smsText.replace('<Project Address>', '');
                }
                
            }
        }
        return null;
    }
  
  @istest(seeAlldata=false)
  private static void test_sendSMS(){
    // Create test data
    test.startTest();
    
    Project_Name__c p = new Project_Name__c(Name = 'Test Project', Project_Address__c = 'Test Address', Contact_Center_No__c = '8892103311', Project_Type__c = 'Casa', Record_Type__c = 'Residential', Send_SMS__c = True, Thank_You_Sms__c = True, Non_Contactable_Sms__c = True, Visit_Confirmed_Sms__c = True, Date_Time__c = True, Thank_You_Sms_Template__c = 'Thank You', Non_Contactable_Sms_Template__c = 'Non Contactable', Visit_Confirmed_Sms_Template__c = 'Visit Confirmed' );
    
    insert p;
    
    Lead l = new Lead(LastName = 'Test Lead', Mobile__c = '9992103377', Project_Name__c = p.id, Status = 'Open', Next_Action__c = 'Establish Contact', LeadSource = 'Event');
    
    insert l;
    
    Call_Attempts__c ca = new Call_Attempts__c(Lead__c = l.id, Project_name__c = p.id, Attempted_By__c = 'CED', Call_Attempted_by__c = 'Celina George', Call_Type__c = 'Inbound Call', Call_Status__c = 'Call InCompleted', Call_Attempt_Status__c = 'Open', Reason_for_Inbound_Call__c = 'Click to call');
    
    insert ca;
    
    Call_Attempts__c ca1 = new Call_Attempts__c(Lead__c = l.id, Project_name__c = p.id, Attempted_By__c = 'CED', Call_Attempted_by__c = 'Celina George', Call_Type__c = 'Inbound Call', Call_Status__c = 'Call InCompleted', Call_Attempt_Status__c = 'Open', Reason_for_Inbound_Call__c = 'Click to call');
    
    insert ca1;
    
    ApexPages.StandardController controller = new ApexPages.StandardController(l); 
    SendLeadSMSController bsExt = new SendLeadSMSController(controller);
    bsExt.smsType = 'Non-Contactable';
    bsExt.smsTemplate();
    bsExt.stopSms =true;
    bsExt.sendSMS();
    
    Project_Name__c p1 = new Project_Name__c(Name = 'Test Project', Project_Address__c = 'Test Address', Project_Type__c = 'Casa', Record_Type__c = 'Residential', Send_SMS__c = True, Thank_You_Sms__c = True, Non_Contactable_Sms__c = True, Visit_Confirmed_Sms__c = True, Date_Time__c = True, Thank_You_Sms_Template__c = 'Thank You', Non_Contactable_Sms_Template__c = 'Non Contactable', Visit_Confirmed_Sms_Template__c = 'Visit Confirmed' );
    
    insert p1;
    
    Lead l1 = new Lead(LastName = 'Test Lead', Mobile__c = '9992103377', Project_Name__c = p1.id, Status = 'Open', Next_Action__c = 'Establish Contact', LeadSource = 'Event');
    
    insert l1;
    
    Call_Attempts__c ca2 = new Call_Attempts__c(Lead__c = l.id, Project_name__c = p.id, Attempted_By__c = 'CED', Call_Attempted_by__c = 'Celina George', Call_Type__c = 'Inbound Call', Call_Status__c = 'Call InCompleted', Call_Attempt_Status__c = 'Open', Reason_for_Inbound_Call__c = 'Click to call');
    
    insert ca2;
    
    Call_Attempts__c ca3 = new Call_Attempts__c(Lead__c = l.id, Project_name__c = p.id, Attempted_By__c = 'CED', Call_Attempted_by__c = 'Celina George', Call_Type__c = 'Inbound Call', Call_Status__c = 'Call InCompleted', Call_Attempt_Status__c = 'Open', Reason_for_Inbound_Call__c = 'Click to call');
    
    insert ca3;
    
    Apexpages.currentPage().getParameters().put('Id',l1.Id);
    ApexPages.StandardController controller1 = new ApexPages.StandardController(l1); 
    SendLeadSMSController bsExt1 = new SendLeadSMSController(controller1);
    bsExt1.smsType = 'Non-Contactable';
    bsExt1.smsTemplate();
    bsExt1.stopSms =true;
    bsExt1.sendSMS();     
    test.stoptest();
    
  }
}