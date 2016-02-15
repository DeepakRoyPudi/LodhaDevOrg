public with sharing class SendSMSController{

    //Variable Declaration
    Opportunity OpportunityList = new Opportunity();
    Public String smsText {get;set;}
    Public String smsType {get; set;}
    Public Boolean disableSendSMS {get; set;}
    Public Boolean disableScheduleDate {get; set;}
    Public Boolean disableScheduleSMS {get; set;}
    Public Boolean scheduleSMS {get; set;}
    Public String scheduleSMSDate {get; set;}
    Public String scheduleSMSTime {get; set;}
    Public String errorMessage{get; set;}
    public Boolean isSaved{get;set;}
    Public Boolean stopSms;
    Integer smsCount;
    
    public SendSMSController(ApexPages.StandardController controller) {
        
        smsText = null;
        smsType = null;
        disableSendSMS = True;
        disableScheduleSMS = False;
        disableScheduleDate = False;
        scheduleSMS = False;
        stopSms = False;
        Id opportunityId;
            
        opportunity objOpportunity = (opportunity)controller.getRecord();
        opportunityId = objOpportunity.Id;

        //Getting Opportunity, ProjectName, OpportunityHistory Records
        OpportunityList = [Select Id, Name, CreatedDate, Mobile_no__c, Last_Call_Attempt_Call_Type__c, Last_Call_Attempt_Call_Status__c, leadsource,
                            Send_Non_Contactable_SMS__c, Last_Call_Attempt_Status_RO__c, Call_Proposed_Date_of_Visit_RO__c,Call_Proposed_Date_of_Visit_New__c, IsActive__c,
                            Project_Name__r.Date_Time__c, Project_Name__r.Date__c, Project_Name__r.Name, Project_Name__r.Contact_Center_No__c, 
                            Project_Name__r.Project_Address__c, Project_Name__r.Send_SMS__c, Project_Name__r.Thank_You_Sms__c, 
                            Project_Name__r.Thank_You_Sms_Template__c, Project_Name__r.Visit_Confirmed_Sms__c, Project_Name__r.Visit_Confirmed_Sms_Template__c, 
                            Project_Name__r.Non_Contactable_Sms__c,Marketing_Source__c, Project_Name__r.Non_Contactable_Sms_Template__c From Opportunity Where Id =: opportunityId ];
        
        //Getting Opportunity related SMS Magic records where SMS Type Thank You
        smsCount = [Select count() From smagicinteract__smsMagic__c where Opportunity__c =: opportunityId AND SMS_Type__c = 'Thank You'];
        getItems();
    }

       
    Public Pagereference sendSMS()
    {
        system.debug('#Sending SMS...');
        if(OpportunityList.Mobile_no__c != null)
        {
            if(smsType != null && smsType != '-- Select --' && smsText != '' && smsText != null )
            {
                //create object of SMS history
                smagicinteract__smsMagic__c smsObj = new smagicinteract__smsMagic__c();

                smsObj.smagicinteract__PhoneNumber__c = OpportunityList.Mobile_no__c;

                smsObj.smagicinteract__SMSText__c = smsText;

                smsObj.smagicinteract__SenderId__c = 'Lodha';

                smsObj.smagicinteract_Name_custom__c = OpportunityList.Name;
                
                smsObj.Opportunity__c = OpportunityList.Id;
                
                smsObj.SMS_Type__c = smsType;
                
                smsObj.smagicinteract__external_field__c = smagicinteract.ApexAPI.generateUniqueKey();
                if(stopSms == true){
                    smsObj.smagicinteract__disableSMSOnTrigger__c = 1;
                }else{
                    smsObj.smagicinteract__disableSMSOnTrigger__c = 0;
                }
                System.debug('#Boolean is:' +smsObj.smagicinteract__disableSMSOnTrigger__c);
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

        Date createdDate = date.newInstance(OpportunityList.CreatedDate.year(), OpportunityList.CreatedDate.month(),OpportunityList.CreatedDate.day());
        
            
        If(OpportunityList.IsActive__c && smsCount == 0 && OpportunityList.Project_Name__r.Send_SMS__c && createdDate == system.today() && OpportunityList.Project_Name__r.Thank_You_Sms__c && OpportunityList.Last_Call_Attempt_Call_Type__c == 'Inbound Call' && OpportunityList.Last_Call_Attempt_Call_Status__c == 'Call Completed')
        {
            options.add(new SelectOption('Thank You','Thank You'));
            disableSendSMS = False;
        }
        
        If(OpportunityList.IsActive__c && OpportunityList.Project_Name__r.Send_SMS__c && OpportunityList.Project_Name__r.Non_Contactable_Sms__c && OpportunityList.Send_Non_Contactable_SMS__c && OpportunityList.leadsource != 'Cross Project' && OpportunityList.Marketing_Source__c != 'Cross Project')
        {
            options.add(new SelectOption('Non-Contactable','Non-Contactable'));
            disableSendSMS = False;
        }
        

        If(OpportunityList.IsActive__c && OpportunityList.Project_Name__r.Send_SMS__c && OpportunityList.Project_Name__r.Visit_Confirmed_Sms__c && OpportunityList.Last_Call_Attempt_Status_RO__c == 'Visit Confirmed' && OpportunityList.Call_Proposed_Date_of_Visit_RO__c != null)
        {
            options.add(new SelectOption('Visit Confirmed','Visit Confirmed'));
            disableSendSMS = False;
            scheduleSMSDate = OpportunityList.Call_Proposed_Date_of_Visit_RO__c.format('dd/MM/yyyy');
        }
        system.debug('option:' + OpportunityList.Call_Proposed_Date_of_Visit_RO__c);
        system.debug('option:' + options);
        return options;
    }
    
    Public PageReference smsTemplate()
    {
        String vcDate = '';
        if(smsType == null || smsType == '-- Select --')
        {
            smsText = '';
            disableScheduleSMS = False;
            disableScheduleDate = False;
        }
        
        //Template SMS for Thank you
        if(smsType == 'Thank You')
        {                
            smsText = OpportunityList.Project_Name__r.Thank_You_Sms_Template__c;
            disableScheduleSMS = False;
            disableScheduleDate = False;
            scheduleSMS = False;
        }  
        //Template SMS for Non-Contactable
        if(smsType == 'Non-Contactable')
        {
            smsText = OpportunityList.Project_Name__r.Non_Contactable_Sms_Template__c;
            disableScheduleSMS = False;
            disableScheduleDate = False;
            scheduleSMS = False;
        }
       //Template SMS for Visit Confirmed
       if(smsType == 'Visit Confirmed')
       {
            smsText = OpportunityList.Project_Name__r.Visit_Confirmed_Sms_Template__c;
            disableScheduleSMS = True;
            scheduleSMS = False;
       }    
            
       //Replacing dynamic Project Name in SMS Template
       if(smsText != null && smsText != '')
       {
            //Replacing dynamic Contact No. in SMS Template
            
            //added for SRCG-181
            smsText = smsText.replace('<Mobile No>',OpportunityList.Mobile_no__c);
            //
            
            smsText = smsText.replace('<Project Name>', OpportunityList.Project_Name__r.Name);
            
            if(OpportunityList.Project_Name__r.Contact_Center_No__c != NULL){
                smsText = smsText.replace('<Contact No.>', OpportunityList.Project_Name__r.Contact_Center_No__c);
            }
            else
            {
                smsText = smsText.replace('<Contact No.>', '');
            }
            
            //Replacing dynamic Project Address in SMS Template
            if(OpportunityList.Project_Name__r.Project_Address__c != NULL){
                smsText = smsText.replace('<Project Address>', OpportunityList.Project_Name__r.Project_Address__c);
            }
            else
            {
                smsText = smsText.replace('<Project Address>', '');
            }
            if(OpportunityList.Project_Name__r.Date_Time__c && OpportunityList.Call_Proposed_Date_of_Visit_RO__c != NULL)
            {
                vcDate = OpportunityList.Call_Proposed_Date_of_Visit_RO__c.format('dd/MM/yyyy') + ' at ' + OpportunityList.Call_Proposed_Date_of_Visit_RO__c.format('HH:mm');
                smsText = smsText.replace('<Date> at <time>', vcDate);
            }
            else if(OpportunityList.Project_Name__r.Date__c && OpportunityList.Call_Proposed_Date_of_Visit_RO__c != NULL)
            {
                vcDate = OpportunityList.Call_Proposed_Date_of_Visit_RO__c.format('dd/MM/yyyy');
                smsText = smsText.replace('<Date> at <time>', vcDate);
            }
            else
            {
                smsText = smsText.replace('<Date> at <time>', system.today().format());
            }
        }
        return null;
    }
    
    Public Pagereference scheduleDate()
    {
        if(scheduleSMS)
            disableScheduleDate = True;
        else
            disableScheduleDate = False;
        return null;
    }

}