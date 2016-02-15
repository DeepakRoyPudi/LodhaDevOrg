/*********************************************************************************
Name:  CasaGroupContactusController ()
Copyright © 2012  Lodha Group
======================================================
======================================================
Purpose:
-------
Visualforce page to replace standard web2lead page for web2lead in casabylodha.com
======================================================
======================================================
History
-------
		VERSION    AUTHOR                DATE             DETAIL              
		1.0 -     CG Dev Team          03/04/2012      INITIAL DEVELOPMENT  
*       2.0       Anupam Agrawal       24/11/2014        Add new fields related to GA(Google Analytics) IT-HD - 56009
*/

public class CasaGroupContactusController {

            public Boolean allowmobileverification { get; set; }
 
            public String campaignName {get;set;}
            public String publisher {get;set;}
    
  
    
            Lead weblead;
            public String name {get;set;}
            
            public String email {get;set;}
            public String countryCode {get;set;}
            public String mobileNumber {get;set;}
            public String stdCode{get;set;}
            public String landLineNumber {get;set;}
            public String country {get;set;}
            public String city {get;set;}
            public String uscitystate{get;set;}
            public String cityText {get;set;}
            
            public String projectInterested {get;set;}           
            public String projectType {get;set;}
            public String rectypeId {get;set;}
            public String sourceofinformation {get;set;}
            
         
            public String selectedcountry{get;set;}
            public String selectedcountry1{get;set;}
            
            public List<SelectOption> selectproject{get;set;}
            public List<String> projectNames{get;set;}
            public String selectedproject{get;set;}
            public String ProjectId{get;set;}
            
            public Map<Id,project_name__c> projectlistmap{get;set;}        
            public String emailTemplateId{get;set;}
            private String AdminEmailId;
            public Boolean isinserted{get;set;}
            String EmailId;
            String Error;
            project_name__c p{get;set;}
            public String CountryName{get;set;}
            public String CountryNames{get;set;}
            public String CheckCode{get;set;}
            
            public string ErrorReportEmailId {get; set;}
            private string FetchcustomSettingName ;
            
            public CasaGroupContactusController ()            
             {
            try{
            
                
                 isinserted=false;
                 getAllprojectname();
                 campaignName= ApexPages.currentPage().getParameters().get('campaign');
                 CountryNames= ApexPages.currentPage().getParameters().get('CountryName');
                 publisher= ApexPages.currentPage().getParameters().get('publisher');
                 projectlistmap= new Map<Id,project_name__c>([select id,Name,Record_Type__c,Project_Type__c from Project_name__c
                 where name!='Lodha Bellezza' AND name!='Unknown Project' AND name!='Generic' AND Project_Type__c='casa' AND Isactive__c=true]);
                 projectNames  = new List<String>();
                 
                  for(project_name__c project:projectlistmap.values()){
                  
                        projectNames.add(project.Name);
                    }
                    projectNames.sort();
                 
                  EmailId = WebToLeadPages__c.getInstance('CasabyLodha').Admin_Email__c;   
                  /**** GET EMAIL TEMPLATE ID TO SEND AS AUTO-RESPONSE TO CAPTURED LEAD ****/
                 //emailTemplateId = [select id from EmailTemplate where developername=:WebToLeadPages__c.getInstance('CasabyLodha').Email_Template__c limit 1].Id;       
                 //AdminEmailId = WebToLeadPages__c.getInstance('CasabyLodha').Admin_Email__c;
                 
                 
                  /***Added for SRCG -170, Fetch Admin email id for sending exception messages about this pages***/
                   ErrorReportEmailId = WebToLeadPages__c.getInstance('Exception Tracking Admin').Admin_Email__c;     
                   system.debug('%%%ErrorReportEmailId '+ErrorReportEmailId ); 
                 //this.country='India';
                 If(CountryNames== null || (CountryNames!= null && CountryNames==''))
                    {
                        system.debug('!!!first '+CountryNames);
                        this.country='India';
                    }
                    else if(CountryNames!=null && CountryNames!='')
                    {                                 
                        this.country= CountryNames;
                        system.debug('!!!'+CountryNames+country);               
                        CheckCode='0';
                    }    
                             
                  
                 
               
               }catch(Exception e){
                   sendErrorMessage(e);
               }
            }
 
            
    /*******************************************************************
        Purpose     : Populate the All ProjectNames in dropdown                        
        Parameters  : None
        Returns     : List of SelectOption of all ProjectName
    ********************************************************************/

            public List<SelectOption> getAllprojectname()
            
                {
                                selectproject=new List<SelectOption>();
                                selectproject.add(new SelectOption('None','-Select Project-'));
                               
                                try{                          
                                   if(projectlistmap!=null && !projectlistmap.isEmpty()){                                        
                                          for(String str:projectNames){                                                              
                                            for(project_name__c project:projectlistmap.values()){                                                  
                                                if(str == project.Name){
                                                       selectproject.add(new selectoption(project.Id,project.Name));                                                
                                                    }
                                                }                
                                            }
                                       
                                        }                                
                                }catch(Exception e){
                                    sendErrorMessage(e);
                                }
                            return selectproject;                
                }
                
             
    /*******************************************************************
        Purpose     : Save Lead                      
        Parameters  : None
        Returns     : None
    ********************************************************************/      
                
            
            
            public void submitLead()            
                {                                                       
                             weblead=new Lead();
                         
                     try
                        
                        {
                         WebToLeadPages__c GetCustomSetting;
                        /**** Added for SRCG-170 --> GET EMAIL TEMPLATE ID TO SEND AS AUTO-RESPONSE TO CAPTURED LEAD ****/
                        system.debug('inside srcg-170'+selectedproject );
                        if(selectedproject != null && selectedproject != '')
                        {
                            system.debug('inside srcg-170'+selectedproject );
                            Project_Name__c pname=[select Name from Project_Name__c where id=:selectedproject limit 1];
                            if(country == 'India'){
                                system.debug('inside srcg-170 inside india'+selectedproject+country);
                                FetchcustomSettingName= pname.Name+'-RI';
                                GetCustomSetting=WebToLeadPages__c.getInstance(FetchcustomSettingName);
                                if(GetCustomSetting == null ){
                                    system.debug('No exact custom setting records found for combination'+FetchcustomSettingName+'. We are using default email template');
                                    GetCustomSetting=WebToLeadPages__c.getInstance('CasabyLodha');                                                                    
                                }
                                emailTemplateId = [select id from EmailTemplate where developername=:GetCustomSetting.Email_Template__c limit 1].Id;   
                                AdminEmailId = GetCustomSetting.Admin_Email__c;
                                system.debug('inside srcg-170 inside india last'+FetchcustomSettingName+GetCustomSetting+emailTemplateId+AdminEmailId );
                            }
                            else{
                                system.debug('inside srcg-170 outside india'+selectedproject +country);
                                FetchcustomSettingName= pname.Name+'-NRI';
                                GetCustomSetting=WebToLeadPages__c.getInstance(FetchcustomSettingName);
                                if(GetCustomSetting == null ){
                                    system.debug('No exact custom setting records found for combination'+FetchcustomSettingName+'. We are using default email template');
                                    GetCustomSetting=WebToLeadPages__c.getInstance('CasabyLodha');                                                                    
                                }
                                emailTemplateId = [select id from EmailTemplate where developername=:GetCustomSetting.Email_Template__c limit 1].Id;   
                                AdminEmailId = GetCustomSetting.Admin_Email__c;
                                system.debug('inside srcg-170 outside india last'+FetchcustomSettingName+GetCustomSetting+emailTemplateId+AdminEmailId );
                            }
                        
                        }
                         if(publisher!=null)
                            {
                                webLead.WebBanner_Source__c=publisher;                               
                            }
                            if(CampaignName!=null)
                            {
                             weblead.Campaign_Name__c=CampaignName;
                             }
                        if(selectedproject!= null && selectedproject!= '' && !projectlistmap.isEmpty())
                            {
                                rectypeId = RecordTypeHelper.getRecordTypeId('Lead',projectlistmap.get(selectedproject).Record_Type__c);
                                projectType =  projectlistmap.get(selectedproject).Project_Type__c.touppercase();
     
                            }
                           
                            if(sourceofinformation!=null && sourceofinformation!='')
                            { 
                                weblead.Lead_Source_Detail__c=sourceofinformation;
                            }
                                        weblead.LeadSource='web';
                                        weblead.lastname = name;
                                        weblead.email =email;                                     
                                        weblead.ISD_Code__c =CountryCode;
                                        weblead.STD_Code__c = stdCode;                                       
                                        weblead.Recordtypeid = rectypeId;                                             
                                        weblead.Campaign_Name__c=CampaignName;                                                                                                
                                        weblead.Project_Name__c=selectedproject;                                      
                               if(country=='India')     
                                  {
                                        weblead.Mobile__c =mobileNumber;
                                        weblead.Phone = stdCode+landLineNumber;                                                 
                               if(ProjectType=='COMMERCIAL')
                                  {
                                        weblead.Country_O__c = Country;
                                        weblead.City_O__c=city;                
                                        weblead.Office_Phone__c = stdCode+landLineNumber; 
                                        weblead.Phone = '';            
                                  }else
                                      {
                                        weblead.Country_R__c = Country;
                                        weblead.City_R__c = city;            
                                      }                                    
                                   } 
                                else                                              
                                   {
                                        weblead.Mobile__c =countryCode +mobileNumber ;
                                        weblead.Phone =countryCode +stdCode +landLineNumber;                                                                                                  
                                   if(ProjectType=='COMMERCIAL')                                                      
                                     {
                                         weblead.Country_O__c = Country;                                                              
                                         weblead.City_O__c='Others';
                                         weblead.Specify_Other_for_City_O__c = cityText;                
                                         weblead.Office_Phone__c = countryCode+stdCode+landLineNumber; 
                                         weblead.Phone = '';                                             
                                     }
                                     else if(country == 'United States'){
                                         weblead.Country_R__c = Country; 
                                         weblead.City_R__c = 'Others';
                                         weblead.Specify_Other_for_City_R__c =uscitystate; 
                                         
                                    }else{
                                                                             
                                         weblead.Country_R__c = Country; 
                                         weblead.City_R__c = 'Others';
                                         weblead.Specify_Other_for_City_R__c =cityText;           
                                         }
                                    }
                                    	//2.0 filled GA related Lead fields
										weblead.Medium_GA__c = ApexPages.currentPage().getParameters().get('medium_ga');
								        weblead.Source_GA__c = ApexPages.currentPage().getParameters().get('source_ga');
								        weblead.Campaign_GA__c = ApexPages.currentPage().getParameters().get('campaign_ga');
								        weblead.Content_GA__c =  ApexPages.currentPage().getParameters().get('content_ga');
								        weblead.Term_GA__c = ApexPages.currentPage().getParameters().get('term_ga');
                                         insert weblead; 
                                         isinserted=true; 
                                         sendMailtoLead(emailTemplateId,weblead.Id);                                                                                                              
                                                     
                             } catch(exception e){
                                isinserted=false;
                               Error=e.getmessage();
                                
                            }           
                          }  
     /*******************************************************************
        Purpose     : sendmail after lead is created                     
        Parameters  : None
        Returns     : None
    ********************************************************************/                                                              
                    
          private void sendMailtoLead(String templateId,String leadId){
            try{
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setTemplateId(templateId);         
                mail.setTargetObjectId(leadId);   
                mail.setSenderDisplayName('Lodha Group');
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });         
            }
            catch(exception e){
                sendErrorMessage(e);
            }
        }      
    
    /**********************************************************************
        Purpose     : SendErrormail if there is an exception               
        Parameters  : None
        Returns     : None
    ***********************************************************************/
    public void sendErrorMessage(Exception e){
        try{
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAdd =  new String[]{ErrorReportEmailId};
            mail.setToAddresses(toAdd);
            mail.setReplyTo('noreply@lodhagroup.com');
            mail.setSenderDisplayName('Lodha Group');
            mail.setSubject('Customer creation error');
            String htmlcontent;
            htmlcontent='<b>Exception:</b><br/>'+e+'<br/>';           
            mail.sethtmlbody(htmlcontent);
            mail.setBccSender(false);
            mail.setUseSignature(false);
            List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.Email[]{ mail });
        }
        catch(Exception ex){
        
        }
    }   
    /************************************************************************
        Purpose     : SendErrormail if there is an error in inserting Lead                 
        Parameters  : None
        Returns     : None
    ***********************************************************************/
    public pagereference senderrmsg()
     {
     try{
     
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAdd =  new String[]{AdminEmailId};
            mail.setToAddresses(toAdd);
            mail.setReplyTo('noreply@lodhagroup.com');
            mail.setSenderDisplayName('Lodha Group');
            mail.setSubject('Customer creation error');
            String htmlcontent;
            if(Error==null || Error=='')
                Error ='';
            htmlcontent='<b>Exception:</b><br/>'+Error+'<br/><b>Lead Details:</b><br/>';
            htmlcontent+='<b>Name:</b>'+weblead.name+'<br/><b>Email Id:</b>'+weblead.email+'<br/>';
            htmlcontent+='<b>Mobile:</b>'+weblead.Mobile__c+'<br/><b>Landline:</b>'+weblead.phone+'<br/>';
            htmlcontent+='<b>stdCode:</b>'+stdCode+'<br/><b>country:</b>'+country+'<br/>';
            htmlcontent+='<b>city:</b>'+city+'<br/><b>citytext:</b>'+citytext+'<br/>';
            htmlcontent+='<b>CountryCode:</b>'+CountryCode+'<br/><b>Landline:</b>'+stdCode+weblead.phone+'<br/>';
            htmlcontent+='<b>Mobile:</b>'+weblead.Mobile__c+'<br/>';            
            htmlcontent+='<b>ProjectName:</b>'+selectedproject+'<br/><b>ProjectType:</b>'+ProjectType+'<br/>';            
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
    public void ProjectName()
    {
        List<Project_Name__c> projectList = [Select Record_Type__c,Project_Type__c,Allow_mobile_verification__c,Type_of_Accomodation__c,Allow_Call_Patching__c,Call_Patch_Category__c from Project_Name__c where id = :selectedproject];
        system.debug('>>>>'+projectList+projectinterested);
        if(projectList.size()>0)
           {
               Project_Name__c objProjectName=projectList[0];
               allowmobileverification = objProjectName.Allow_mobile_verification__c;
               system.debug('>>>>allowmobileverification'+allowmobileverification);
           }    
    }

               
}