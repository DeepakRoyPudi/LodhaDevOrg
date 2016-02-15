/*

Purpose - Controller for web2leadcasabylodha Visualforce Page
DEPENDENCIES:1. CUSTOM SETTINGS WebToLeadPages__c:lodhagroup
             2. ProjectId to be specified in the URL.
* 
*        Version     Date          Author             Description
*        1.0         -             CG DEV             Intial Draft
*        2.0         24/11/2014    Anupam Agrawal     Add new fields related to GA(Google Analytics) IT-HD - 56009
*/
public class Web2LeadExtension { 
   
    private final Lead weblead;  
    public Id projectId {get; set;}
    public id rectypeId;
    String e;   //to capture errors
    public string leadName{get; set;}  
    public string leadEmail{get; set;}
    public string leadMobile{get; set;}
    public string leadPhone{get; set;}
    public string leadstdCode{get; set;}
    public String countries{get;set;} 
    public String city{get;set;}
    public String city1 {get; set;}   
    public String state{get; set;}
    public string CountryCode {get; set;}
    public string Designation{get;set;}
    public string CompanyName{get;set;}
    public string ProjectType{get;set;}
     public string ProjectName{get;set;}
     public string recType{get;set;}
    public List<Selectoption> AccommodationType {get;set;}
    
    public String AccommodationValue{get;set;}
    public Integer MandatoryDeCompany{get;set;}
    public Integer Mandatorychoiceofresidence{get;set;}
    public boolean bdisableButton{get;set;}
    public String leadLastName{get;set;}
    public boolean showAccommodationType{get;set;}
    public String CampaignName{get;set;}
    public string publisher{get;set;}
    public boolean success{get;set;}  
    public Boolean allowmobileverification{get;set;}  
    public Boolean allowcallpatching{get;set;}  
    public Integer currenttime{get;set;}
    public String callcenterno{get;set;}

    String EmailId;         //for error mails
    String TemplateId;      //template for lead response 
          
    public string emailProjectAdmin {get; set;}
    public string FetchcustomSettingName {get; set;}  
    
    public string CheckCode{get;set;}
    public String CountryName{get;set;}
     
    public Web2LeadExtension(ApexPages.StandardController  stdController)
    {
    Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=8'); // ADDED FOR IE COMPATIBILITY
     success = false;
       try
       {
       currenttime=System.Now().hour();
       
       /***Added for SRCG -170, Fetch Admin email id for sending exception messages about this pages***/
       EmailId = WebToLeadPages__c.getInstance('Exception Tracking Admin').Admin_Email__c;     
       system.debug('%%%EmailId '+EmailId ); 
           
       weblead = (Lead)stdController.getRecord();  
       projectId = ApexPages.currentPage().getParameters().get('projectid');
       CampaignName= ApexPages.currentPage().getParameters().get('campaign');
       publisher= ApexPages.currentPage().getParameters().get('publisher');
       CountryName = ApexPages.currentPage().getParameters().get('CountryName');
       System.debug('The project id is -- ' +  projectId);
       if(projectId==null)
       {
           bdisableButton=true;
           //ApexPages.addMessages('Project Id can not be blank'); 
           
       }
       else
       {
           bdisableButton=false;
       }
       /*if(projectId != null){
       recType = [Select Record_Type__c from Project_Name__c where id = :projectId].Record_Type__c;
       }
       if(rectypeId != null){
       rectypeId = [Select id, Name from RecordType where SobjectType = 'Lead' AND Name = :recType].id;
       }*/
       ProjectType='CASA';
       AccommodationType=new List<Selectoption>();
       MandatoryDeCompany=0;
       AccommodationType.add(new Selectoption('', 'Please Select'));
       if(projectId != null)
       { 
       
          List<Project_Name__c> projectList = [Select Name, Record_Type__c,Project_Type__c,Allow_mobile_verification__c,Type_of_Accomodation__c,Allow_Call_Patching__c,Call_Patch_Category__c from Project_Name__c where id = :projectId];
          
         if(projectList[0].Call_Patch_Category__c!=null&&projectList[0].Call_Patch_Category__c!=''){
          String categoryname=projectList[0].Call_Patch_Category__c;
          CallPatchCategory__c callpatch=[select Name,Call_Center_Number__c from CallPatchCategory__c where Name=:categoryname];
          callcenterno=callpatch.Call_Center_Number__c;
          }
          
           if(projectList.size()>0)
           {
               Project_Name__c objProjectName=projectList[0];
               recType=objProjectName.Record_Type__c;
               
               
               allowmobileverification=objProjectName.Allow_mobile_verification__c;
               allowcallpatching=objProjectName.Allow_Call_Patching__c;
               
               if(objProjectName.Project_Type__c!=null && objProjectName.Project_Type__c!='')
               {
                  
                   
                   ProjectType=objProjectName.Project_Type__c.touppercase();
                   ProjectName=objProjectName.Name.touppercase();
                   if(ProjectType!='CASA' && ProjectType!='ASPIRATIONAL')
                   {
                       
                       MandatoryDeCompany=1;
                       
                   }  if(ProjectName=='LODHA BELLEZZA')
                       {
                           showAccommodationType=true;
                           Mandatorychoiceofresidence=1;
                       }
                  
                   
               }
               String accType=objProjectName.Type_of_Accomodation__c;
               rectypeId = RecordTypeHelper.getRecordTypeId('Lead',recType);
               
               if(accType!=null && accType!='')
               {
                   List<String> accTypeList=accType.split(';');
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
       
       //this.countries = 'India';//DEFAULT COUNTRY 
       
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
           system.debug('CaseException'+CaseException);
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
    public PageReference saveLead() {  
    try {
     WebToLeadPages__c GetCustomSetting;
     boolean vland=true;        //CHECK FOR ALL VALIDATIONS
    if((leadname != null && leadname  != '') 
        && (leademail != null && leademail != '') 
        && (leadMobile != null && leadMobile != '' ) 
        && (countries != null && countries != '')
        && ((city != null && city != '') || ( city1 != null && city1 != 'None' ) || (state != null && state != 'None' ) )
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
                        
                        
            if(ProjectName!='LODHA BELLEZZA'){weblead.Project_Name__c = projectId;}
            
            else if(AccommodationValue!=null && AccommodationValue!=''){
            
                    if(AccommodationValue=='Sky Villa')
                    {
                        Project_Name__c sky=[select id from Project_Name__c where name='Lodha Bellezza Sky Villa'];
                        weblead.Project_Name__c=sky.id;
                    }
                    else if(AccommodationValue=='Spa Villa')
                    {
                        Project_Name__c spa=[select id from Project_Name__c where name='Lodha Bellezza Spa Villa'];
                        weblead.Project_Name__c=spa.id;
                    }
            }
           
            
        
        
        weblead.LeadSource = 'Web';
        weblead.LastName = leadName;
        weblead.Email = leadEmail;
        //2.0 filled GA related Lead fields
		weblead.Medium_GA__c = ApexPages.currentPage().getParameters().get('medium_ga');
        weblead.Source_GA__c = ApexPages.currentPage().getParameters().get('source_ga');
        weblead.Campaign_GA__c = ApexPages.currentPage().getParameters().get('campaign_ga');
        weblead.Content_GA__c =  ApexPages.currentPage().getParameters().get('content_ga');
        weblead.Term_GA__c = ApexPages.currentPage().getParameters().get('term_ga');
        System.debug('Ther country code is -- ' + CountryCode + ' --- Mobile number is -- ' + leadMobile);
        String countryMobile=CountryCode+leadMobile;
        System.debug('#@#$# country mobile ' + countryMobile);
        
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
        
        else  
        
          // ASSIGNMENT FOR OTHER COUNTRIES
        
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
        weblead.Type_of_Accomodation__c=AccommodationValue;
        weblead.Designation__c=Designation;
        if(ProjectType=='COMMERCIAL')
            webLead.Company=CompanyName;
        else
            weblead.Lead_Company_Name__c =  CompanyName;           
        
        if(CampaignName!=null)
        {
            webLead.Campaign_Name__c=CampaignName;
        }
        if(publisher!=null)
        {
            webLead.WebBanner_Source__c=publisher;
        }
        
        if(vland)// IF ALL VALIDATIONS ARE CORRECT THEN INSERT
        {        
        insert(weblead);  
        success = true;
       
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setTemplateId(TemplateId);         
        mail.setTargetObjectId(weblead.id);   
        mail.setSenderDisplayName('Lodha Group');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
          
        /*
        if(CampaignName!=null)
        {
            webLead.Campaign_Name__c=CampaignName;
            List<Campaign> CampaignList=[Select ID from Campaign where Name=:CampaignName];
            if(CampaignList.size()>0)
            {
                CampaignMember omember=new CampaignMember();
                omember.CampaignId=CampaignList[0].ID;
                omember.LeadId=webLead.ID;
                insert omember;
            }
            
        }
        */
          }
          else
          {
            success = false;
          }
        }
        else
        {
            success = false;
        }
       } 
       catch(Exception ex) { 
           ApexPages.addMessages(ex);
           system.debug('ERRORUD'+ex); 
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
            String[] toAdd =  new String[]{emailProjectAdmin};
            mail.setToAddresses(toAdd);
            mail.setReplyTo('noreply@lodhagroup.com');
            mail.setSenderDisplayName('Lodha Group');
            mail.setSubject('Customer creation error');
            String htmlcontent;
            if(e ==null || e=='')
            {
                e='';
            }
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