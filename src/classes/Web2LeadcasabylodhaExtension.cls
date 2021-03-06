/*
Purpose - Controller for web2leadcasabylodha Visualforce Page
TestClass - TestWeb2LeadcasabylodhaExtension
DEPENDENCIES:1. CUSTOM SETTINGS WebToLeadPages__c:CasabyLodha
             2. ProjectId to be specified in the URL.
* 
*        Version     Date          Author             Description
*        1.0         14/11/2011    CG DEV             Intial Draft
*        2.0         21/11/2014    Anupam Agrawal     Add new fields related to GA(Google Analytics) IT-HD - 56009
*/
public class Web2LeadcasabylodhaExtension { 
   
    private final Lead weblead;  
    String e;   //to capture errors
    public Id projectId {get; set;}
    public id rectypeId;
    public string leadName{get; set;}  
    public string leadEmail{get; set;}
    public string leadMobile{get; set;}
    public string leadPhone{get; set;}
    public string leadstdCode{get; set;}
    public String countries{get;set;} 
    public String city{get;set;} 
    public String state{get; set;}
    public String city1 {get; set;}   
    public string CountryCode {get; set;}
    public string Designation{get;set;}
    public string CompanyName{get;set;}
    public string CompanyName1{get;set;}    
    public string ClusterName{get;set;}
    public string ProjectType{get;set;}
    public string recType{get;set;}
    public List<Selectoption> AccommodationType {get;set;}
    public String[] AccommodationValue{get;set;}
    public Integer MandatoryDeCompany{get;set;}
    public boolean bdisableButton{get;set;}
    public String leadLastName{get;set;}
    public boolean showAccommodationType{get;set;}
    public String CampaignName{get;set;}
    public string publisher{get;set;}
    public String returl {get;set;}
    public Boolean Success {get;set;}
    public Boolean allowmobileverification{get;set;}
    public Integer currenttime{get;set;}
    public Boolean allowcallpatching{get;set;}  
    public String callcenterno{get;set;}   
    public string Countryss {get; set;}
    public string CheckCode{get;set;}
    public String CountryName{get;set;}
    
    String EmailId;         //for error mails
    String TemplateId;      //template for lead response
    public string emailProjectAdmin {get; set;}
    public string FetchcustomSettingName {get; set;}
        
    Public String publicKey { get{ return '6LcJYeQSAAAAAIeJZiAtLFYzqR7KI8o5H_dy94Xu';}}
    private static String privateKey = '6LcJYeQSAAAAAE4xEfH32_knvnju_uPyDgs567Wt';
    private static String baseUrl = 'https://www.google.com/recaptcha/api/verify';
    
    public Web2LeadcasabylodhaExtension(ApexPages.StandardController  stdController)
    { 
        currenttime=System.Now().hour();
        Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=8');// ADDED FOR IE COMPATIBILITY
        Success = false;
             
        try
        {

           /***Added for SRCG -170, Fetch Admin email id for sending exception messages about this pages***/
           EmailId = WebToLeadPages__c.getInstance('Exception Tracking Admin').Admin_Email__c;     
           system.debug('%%%EmailId '+EmailId );       
           weblead = (Lead)stdController.getRecord();  
           projectId = ApexPages.currentPage().getParameters().get('projectid');
           CountryName = ApexPages.currentPage().getParameters().get('CountryName');
           CampaignName= ApexPages.currentPage().getParameters().get('campaign');
           publisher= ApexPages.currentPage().getParameters().get('publisher');
           ClusterName = ApexPages.currentPage().getParameters().get('cluster');
           System.debug('The project id is -- ' +  projectId);
           ProjectType='CASA';
           AccommodationType=new List<Selectoption>();
           AccommodationValue = new List<String>();
           MandatoryDeCompany=0;        
           if(projectId != null)
           { 
               List<Project_Name__c> projectList = [Select Record_Type__c,Project_Type__c,Allow_mobile_verification__c,Type_of_Accomodation__c,Allow_Call_Patching__c,Call_Patch_Category__c from Project_Name__c where id = :projectId];
               
                             
               if(projectList[0].Call_Patch_Category__c!=null&&projectList[0].Call_Patch_Category__c!=''){
                  String categoryname=projectList[0].Call_Patch_Category__c;
                  system.debug('$$$'+projectList[0].Call_Patch_Category__c);
                  CallPatchCategory__c callpatch=[select Name,Call_Center_Number__c from CallPatchCategory__c where Name=:categoryname];
                  system.debug('***'+callpatch);
                  system.debug('&&&'+callpatch.Call_Center_Number__c);
                  callcenterno=callpatch.Call_Center_Number__c;
                  }
                       
               if(projectList.size()>0)
               {
                   Project_Name__c objProjectName=projectList[0];
                   recType=objProjectName.Record_Type__c;
                   system.debug(' ## recType'+recType); 
                   allowmobileverification=objProjectName.Allow_mobile_verification__c;
                   allowcallpatching=objProjectName.Allow_Call_Patching__c;
                   
                   if(objProjectName.Project_Type__c!=null && objProjectName.Project_Type__c!='')
                   {
                       showAccommodationType=true;
                       ProjectType=objProjectName.Project_Type__c.touppercase();
                       if(ProjectType!='CASA' && ProjectType!='ASPIRATIONAL')
                       {
                           MandatoryDeCompany=1;
                       }
                       if(ProjectType=='COMMERCIAL')
                       {
                           showAccommodationType=false;
                       }
                       
                   }
                   String accType=objProjectName.Type_of_Accomodation__c;
                   rectypeId = RecordTypeHelper.getRecordTypeId('Lead',recType);
                   
                   if(accType!=null && accType!='')
                   {
                       List<String> accTypeList=accType.split(';');
                       accTypeList.sort();
                       for(String typeOfAcc : accTypeList)
                       {
                           AccommodationType.add(new Selectoption(typeOfAcc ,typeOfAcc ));
                       
                       }
                   }
                   
                   
               }
               else
               {
                   ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Project ID is not defined')); 
               }
           }
           else
           {
               ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Project ID is not defined')); 
           }
           //this.countries = 'India';    //DEFAULT COUNTRY 
           If(CountryName == null || (CountryName != null && CountryName==''))
           {
               system.debug('!!!first '+CountryName);
               this.countries ='India';
           }
           else if(CountryName!=null && CountryName!='')
           {                                 
               this.countries = CountryName;
               system.debug('!!!'+CountryName +countries );               
               CheckCode='0';
           }
         
       }
       catch(Exception exp)
       {
           String CaseException=exp.getMessage() + '---:--- Line Number is--:' + String.valueOf(exp.getLineNumber());
          SendErrorMail(CaseException);
       }
    }         
         
   
    private boolean ShowDesignationCompany(String projectType)
    {
        return true;
    }
    
    private void SendErrorMail(String exception1)
    {
        try
        {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAdd =  new String[]{EmailId};
            mail.setToAddresses(toAdd);
            mail.setReplyTo('noreply@lodhagroup.com');
            mail.setSenderDisplayName('Lodha Group');
            mail.setSubject('Customer creation error');
            mail.sethtmlbody(exception1);
            mail.setBccSender(false);
            mail.setUseSignature(false);
            List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.Email[]{ mail });
        }
        catch(Exception exp)
        {
            
        }
    }
   
    public PageReference saveLead() 
    {  
    
    System.debug(' ## inside save lead');
        try 
        {
            WebToLeadPages__c GetCustomSetting;
            boolean vland =true;                    //CHECK FOR ALL VALIDATIONS
            if((leadname != null && leadname  != '') 
            && (leademail != null && leademail != '') 
            && (leadMobile != null && leadMobile != '' ) 
            && (countries != null && countries != '')
            && ((city != null && city != '') || ( city1 != null && city1 != 'None' ) || (state != null && state != 'None' ))
            )
            {
                /**** Added for SRCG-170 --> GET EMAIL TEMPLATE ID TO SEND AS AUTO-RESPONSE TO CAPTURED LEAD ****/
               system.debug('inside srcg-170'+projectId);
                        Project_Name__c pname=[select Name from Project_Name__c where id=:projectId limit 1];
                        if(countries == 'India'){
                            system.debug('inside srcg-170 inside india'+projectId+countries );
                            FetchcustomSettingName= pname.Name+'-RI';
                            GetCustomSetting=WebToLeadPages__c.getInstance(FetchcustomSettingName);
                            if(GetCustomSetting == null ){
                                system.debug('No exact custom setting records found for combination'+FetchcustomSettingName+'. We are using default email template');
                                GetCustomSetting=WebToLeadPages__c.getInstance('CasabyLodha');  
                                                                  
                            }
                            TemplateId = [select id from EmailTemplate where developername=:GetCustomSetting.Email_Template__c limit 1].Id;   
                            emailProjectAdmin = GetCustomSetting.Admin_Email__c;
                            system.debug('inside srcg-170 inside india last'+FetchcustomSettingName+GetCustomSetting+TemplateId +emailProjectAdmin);
                            
                        }
                        else{
                            system.debug('inside srcg-170 outside india'+projectId+countries );
                            FetchcustomSettingName= pname.Name+'-NRI';
                            GetCustomSetting=WebToLeadPages__c.getInstance(FetchcustomSettingName);
                            if(GetCustomSetting == null ){
                                system.debug('No exact custom setting records found for combination'+FetchcustomSettingName+'. We are using default email template');
                                GetCustomSetting=WebToLeadPages__c.getInstance('CasabyLodha');                                
                            }
                            TemplateId = [select id from EmailTemplate where developername=:GetCustomSetting.Email_Template__c limit 1].Id;   
                            emailProjectAdmin = GetCustomSetting.Admin_Email__c;
                            system.debug('inside srcg-170 outside india last'+FetchcustomSettingName+GetCustomSetting+TemplateId +emailProjectAdmin);
                            
                        }
                        
                        
                weblead.Project_Name__c = projectId;
                weblead.LeadSource = 'Web';
                weblead.LastName = leadName;
                weblead.Email = leadEmail;
                System.debug('Ther country code is -- ' +CountryCode + ' --- Mobile number is -- ' + leadMobile);
                String countryMobile=CountryCode+leadMobile;
                System.debug('#@#$# country mobile ' + countryMobile);
        		
        		//2.0 filled GA related Lead fields
        		weblead.Medium_GA__c = ApexPages.currentPage().getParameters().get('medium_ga');
                weblead.Source_GA__c = ApexPages.currentPage().getParameters().get('source_ga');
                weblead.Campaign_GA__c = ApexPages.currentPage().getParameters().get('campaign_ga');
                weblead.Content_GA__c =  ApexPages.currentPage().getParameters().get('content_ga');
                weblead.Term_GA__c = ApexPages.currentPage().getParameters().get('term_ga');
                
                if(countries=='India')          // ASSIGNT OF CITY AND LANDLINE NUMBERS FOR COUNTRY = INDIA
                {   weblead.Mobile__c = leadMobile;
                    weblead.Phone = leadstdCode+leadPhone;
                    system.debug(weblead.Phone+leadstdCode+leadPhone);
                    if(weblead.Phone !=null && weblead.Phone != '')           
                     {system.debug(weblead.Phone);
                         if(weblead.Phone.length() == 11 )
                         {
                            if(!leadstdCode.startswith('0'))
                                vland = false;                 
                            else
                                vland = true;    
                         }
                         else
                         {
                         vland = false;  
                         }
                         system.debug(vland);
                     }
                    if(ProjectType=='COMMERCIAL')
                    {
                        weblead.Country_O__c = Countries;                
                        weblead.Office_Phone__c = leadstdCode+leadPhone; 
                        weblead.Phone = '';            
                    }
                    else
                    {
                        weblead.Country_R__c = Countries;            
                    }
                    if(city1 != null && city1 != '')
                    {
                        if(ProjectType!='COMMERCIAL')
                            weblead.City_R__c = city1;
                        else
                            weblead.City_O__c=city1;
                    }            
                }
                else        // ASSIGNMENT   FOR OTHER COUNTRIES
                {   weblead.Mobile__c = countryMobile;
                    weblead.Phone = CountryCode+leadstdCode+leadPhone;
                    if(ProjectType=='COMMERCIAL')
                    {
                        weblead.Country_O__c = Countries;                
                        weblead.Office_Phone__c = CountryCode+leadstdCode+leadPhone; 
                        weblead.Phone ='';  
                        weblead.City_O__c='Others';
                        weblead.Specify_Other_for_City_O__c =city;                     
                    }
                    else
                    {
                        system.debug(' ## inside US');
                        
                        weblead.Country_R__c = Countries;            
                        if(countries=='United States') 
                        {
                            weblead.City_R__c = 'Others';
                            weblead.Specify_Other_for_City_R__c = state;
                        }
                        else
                        {    weblead.City_R__c='Others';
                             weblead.Specify_Other_for_City_R__c =city;
                        }
                    }                                     
                }
                weblead.Recordtypeid = rectypeId;
                weblead.ISD_Code__c = CountryCode;
                weblead.STD_Code__c = leadstdCode;
            
                string str = '';
                for(string s: AccommodationValue)
                   {
                      str = str + ';' + s;  
                   }           
                weblead.Type_of_Accomodation__c=str;
                weblead.Designation__c=Designation;
                if(ProjectType=='COMMERCIAL')
                    webLead.Company=CompanyName;
                else
                    weblead.Lead_Company_Name__c =  CompanyName; 
                
                if(CampaignName!=null)
                {
                    webLead.Campaign_Name__c=CampaignName;
                }
                
                if(ClusterName!=null)
                {
                    webLead.Cluster_Name__c=ClusterName;
                }  
                
                if(publisher!=null)
                {
                    webLead.WebBanner_Source__c=publisher;
                }
                 system.debug(' ## vland'+vland);
                    if(vland)   // IF ALL VALIDATIONS ARE CORRECT THEN INSERT
                    {
                        insert(weblead);  
                        Success =true;  
                        system.debug('********insert'+Success+vland);
                        
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.setTemplateId(TemplateId);   
                        mail.setSenderDisplayName('Lodha Group');      
                        mail.setTargetObjectId(weblead.id);  
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                    }
                    else
                    {
                        success = false;
                    }
                     system.debug(' ## vland success '+success);
            }
            else
            {
                success = false;
            }
            system.debug(' ##  success '+success);
        }
        catch(Exception ex) 
        { 
            ApexPages.addMessages(ex);
            system.debug(' ## ERRORUD'+ex+ex.getlinenumber()); 
            Success = false; 
            e = ex.getmessage();
            return null;  
        }  
        return null;  
     }
     public pagereference senderrmsg()
     {
     try{
     
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAdd =  new String[]{emailProjectAdmin };
            mail.setToAddresses(toAdd);
            mail.setReplyTo('noreply@lodhagroup.com');
            mail.setSenderDisplayName('Lodha Group');
            mail.setSubject('Customer creation error');
            String htmlcontent;
            if(e==null || e=='')
                e ='';
            htmlcontent='<b>Exception:</b><br/>'+e+'<br/><b>Lead Details:</b><br/>';
            htmlcontent+='<b>Name:</b>'+weblead.Lastname+'<br/><b>Email Id:</b>'+weblead.email+'<br/>';
            htmlcontent+='<b>CountryCode:</b>'+weblead.Mobile__c+'<br/><b>Landline:</b>'+weblead.phone+'<br/>';
            htmlcontent+='<b>leadstdCode:</b>'+leadstdCode+'<br/><b>countries:</b>'+countries+'<br/>';
            htmlcontent+='<b>city:</b>'+city+'<br/><b>city1:</b>'+city1+'<br/>';
            htmlcontent+='<b>CountryCode:</b>'+CountryCode+'<br/><b>Landline:</b>'+leadstdCode+weblead.phone+'<br/>';
            htmlcontent+='<b>Choice of residence:</b>'+ weblead.Type_of_Accomodation__c+'<br/><b>Mobile:</b>'+weblead.Mobile__c+'<br/>';            
            htmlcontent+='<b>Designation:</b>'+Designation+'<br/><b>CompanyName:</b>'+CompanyName+'<br/>';
            htmlcontent+='<b>ProjectId:</b>'+projectId+'<br/><b>ProjectType:</b>'+ProjectType+'<br/>';            
            htmlcontent+='<b>Campaign name:</b>'+webLead.Campaign_Name__c+'<br/><b>Banner:</b>'+webLead.WebBanner_Source__c+'<br/>';            
            mail.sethtmlbody(htmlcontent);
            mail.setBccSender(false);
            mail.setUseSignature(false);
            List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.Email[]{ mail });
            }
            catch(exception e)
            {}
            return null;
     }
      
}