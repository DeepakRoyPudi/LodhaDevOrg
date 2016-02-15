/****************************************************************************************************
Name:  LodhaGroupContactController ()
Copyright © 2012  Lodha Group
=====================================================================================================
=====================================================================================================
Purpose: 
-------
Visualforce page to replace standard web2lead page for web2lead in lodhagroup.com/contactus.php
=====================================================================================================
=====================================================================================================
History
History
-------
		VERSION    AUTHOR                DATE             DETAIL              
		1.0 -     CG Dev Team          02/04/2012      INITIAL DEVELOPMENT  
*       2.0       Anupam Agrawal       24/11/2014        Add new fields related to GA(Google Analytics) IT-HD - 56009
*/
public class LodhaGroupContactController {
    
    public String name {get;set;}
    public String email {get;set;}
    public String countryCode {get;set;}
    public String mobileNumber {get;set;}
    public String stdCode{get;set;}
    public String landLineNumber {get;set;}
    public String country {get;set;}
    public String city {get;set;}
    public String cityText {get;set;}
    public String uscitystate{get;set;}
    public String projectInterested {get;set;}
    public String campaignName {get;set;}
    public String publisher {get;set;}
    public String projectType {get;set;}
    public list<SelectOption> projectList {get;set;}
    public Boolean isinserted {get;set;}
    public string sourceofinformation{get;set;}
    public string recType{get;set;}
    public Boolean allowcallpatching{get;set;} 
     public String callcenterno{get;set;}
     public Boolean allowmobileverification{get;set;}
    private Map<Id,project_name__c> allProjects{get;set;}
    private String recordtypeid ;
    private String emailTemplateId ; 
    private String AdminEmailId ;
    Public String EmailId;
    private List<String> projectNames ; 
    public Integer currenttime{get;set;}
    String Error;
    Lead newlead;
    Public String FetchcustomSettingName;
    public String CountryNames{get;set;}
    public String CheckCode{get;set;}
    
    

    public LodhaGroupContactController(){
       
        try{
           
           
           campaignName= ApexPages.currentPage().getParameters().get('campaign');    //GET CAMPAIGN NAME FROM URL        
           publisher= ApexPages.currentPage().getParameters().get('publisher');      //GET PUBLISHER NAME FROM URL
           CountryNames= ApexPages.currentPage().getParameters().get('CountryName');
           currenttime=System.Now().hour();           
           getAllProjects();         //CREATE PROJECT MAP
           populateProjectList();    //DISPLAY PROJECT LIST 
           isinserted= false;
           

           /**** GET EMAIL TEMPLATE ID TO SEND AS AUTO-RESPONSE TO CAPTURED LEAD ****/
           //emailTemplateId = [select id from EmailTemplate where developername=:WebToLeadPages__c.getInstance('LodhaGroup').Email_Template__c limit 1].Id;       
           //AdminEmailId = WebToLeadPages__c.getInstance('LodhaGroup').Admin_Email__c;     
           //this.country='India'; 
           
            /***Added for SRCG -170, Fetch Admin email id for sending exception messages about this pages***/
           EmailId = WebToLeadPages__c.getInstance('Exception Tracking Admin').Admin_Email__c;     
           system.debug('%%%EmailId '+EmailId );             
           
           
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
        }
        catch(exception e){
            sendErrorMessage(e);
          system.debug('%%%message'+e.getmessage());  
        }
    }
    /*******************************************************************
        Purpose     : Populate the All ProjectNames in dropdown                        
        Parameters  : None
        Returns     : List of SelectOption of all ProjectName
    ********************************************************************/
    private void getAllProjects(){
    
        try{
            allProjects = new Map<Id,project_name__c>([select id,Name,Record_Type__c,Project_Type__c,City__c,Location__c from Project_name__c 
            where name!='Unknown Project' AND name!='Generic' AND Isactive__c=true]);
            projectNames  = new List<String>();
            for(project_name__c project:allProjects.values()){
                projectNames.add(project.Name);
            }
            projectNames.sort();        
        }
        catch(exception e){
            sendErrorMessage(e);        
        }
    }
    
    private void populateProjectList(){
        try{
            projectList = new list<selectoption>();
            projectList.add(new selectoption('Select Project','Select Project'));
            String projectlabel='';
            if(allProjects!=null && !allProjects.isEmpty()){
                for(String str: projectNames){                
                    for(project_name__c project:allProjects.values()){   
                        if(str == project.Name){
                        projectlabel=project.Name;
                        if(project.Location__c!=''&&project.Location__c!=null)
                        {
                            projectlabel+=', '+project.Location__c;
                        }
                        if(project.City__c!=''&&project.City__c!=null)
                        {
                            projectlabel+=', '+project.City__c;
                        }
                            
                        
                            projectList.add(new selectoption(project.Id,projectlabel));                                                
                        }
                    }                
                }
            }
        }
        catch(exception e){
            sendErrorMessage(e);
        }
    }
    
    public pagereference ProjectName(){
    List<Project_Name__c> projectList = [Select Record_Type__c,Project_Type__c,Allow_mobile_verification__c,Type_of_Accomodation__c,Allow_Call_Patching__c,Call_Patch_Category__c from Project_Name__c where id = :projectInterested ];
        
        
        
        if(projectList.size()>0)
           {
               Project_Name__c objProjectName=projectList[0];
               recType=objProjectName.Record_Type__c;
               system.debug(' ## recType'+recType); 
               allowmobileverification=objProjectName.Allow_mobile_verification__c;
               allowcallpatching=objProjectName.Allow_Call_Patching__c;
            
            
            if(projectList[0].Call_Patch_Category__c!=null&&projectList[0].Call_Patch_Category__c!=''){
                  String categoryname=projectList[0].Call_Patch_Category__c;
                  system.debug('$$$'+projectList[0].Call_Patch_Category__c);
                  CallPatchCategory__c callpatch=[select Name,Call_Center_Number__c from CallPatchCategory__c where Name=:categoryname];
                  system.debug('***'+callpatch);
                  system.debug('&&&'+callpatch.Call_Center_Number__c);
                  callcenterno=callpatch.Call_Center_Number__c;
                  }
            }      
     return null;
    }
              
    /*******************************************************************
        Purpose     : Save Lead                      
        Parameters  : None
        Returns     : None
    ********************************************************************/    
    public void submitLead(){
        try{
           
            newlead= new Lead(); 
            WebToLeadPages__c GetCustomSetting;
            newlead.lastname = name;
            newlead.email = email;
            newlead.LeadSource = 'Web';            
            newlead.ISD_Code__c = CountryCode;
            newlead.STD_Code__c = stdCode;
            newlead.Campaign_Name__c=CampaignName;
            newlead.WebBanner_Source__c=publisher;
            
            if(projectInterested != null && projectInterested != '' && !allProjects.isEmpty()){
                recordtypeid = RecordTypeHelper.getRecordTypeId('Lead',allProjects.get(projectInterested).Record_Type__c);
                projectType =  allProjects.get(projectInterested).Project_Type__c.touppercase();
            }                        

            newlead.Recordtypeid = Recordtypeid;
            newlead.Project_Name__c = projectInterested;                         
            
         /**** Added for SRCG-170 --> GET EMAIL TEMPLATE ID TO SEND AS AUTO-RESPONSE TO CAPTURED LEAD ****/
           system.debug('inside srcg-170'+projectInterested);
                    Project_Name__c pname=[select Name from Project_Name__c where id=:projectInterested limit 1];
                    if(country == 'India'){
                        system.debug('inside srcg-170 inside india'+projectInterested+country);
                        FetchcustomSettingName= pname.Name+'-RI';
                        GetCustomSetting=WebToLeadPages__c.getInstance(FetchcustomSettingName);
                        if(GetCustomSetting == null ){
                            system.debug('No exact custom setting records found for combination'+FetchcustomSettingName+'. We are using default email template');
                            GetCustomSetting=WebToLeadPages__c.getInstance('CasabyLodha');  
                                                              
                        }
                        emailTemplateId= [select id from EmailTemplate where developername=:GetCustomSetting.Email_Template__c limit 1].Id;   
                        AdminEmailId= GetCustomSetting.Admin_Email__c;
                        system.debug('inside srcg-170 inside india last'+FetchcustomSettingName+GetCustomSetting+emailTemplateId+AdminEmailId);
                    }
                    else{
                        system.debug('inside srcg-170 outside india'+projectInterested+country);
                        FetchcustomSettingName= pname.Name+'-NRI';
                        GetCustomSetting=WebToLeadPages__c.getInstance(FetchcustomSettingName);
                        if(GetCustomSetting == null ){
                            system.debug('No exact custom setting records found for combination'+FetchcustomSettingName+'. We are using default email template');
                            GetCustomSetting=WebToLeadPages__c.getInstance('CasabyLodha');  
                                                              
                        }
                        emailTemplateId= [select id from EmailTemplate where developername=:GetCustomSetting.Email_Template__c limit 1].Id;   
                        AdminEmailId= GetCustomSetting.Admin_Email__c;
                        system.debug('inside srcg-170 outside india last'+FetchcustomSettingName+GetCustomSetting+emailTemplateId+AdminEmailId);
                    } 
            
            if(country == 'India'){
                newlead.Mobile__c = mobileNumber ;
                newlead.Phone = stdCode + landLineNumber;
                
                if(ProjectType=='COMMERCIAL'){    
                    newlead.Country_O__c = country;                
                    newlead.Office_Phone__c = stdCode+landLineNumber; 
                    newlead.Phone = '';
                    newlead.City_O__c=city;
                }
                else{
                    newlead.Country_R__c = country;
                    newlead.City_R__c = city;
                }
            }
            else{
            
             
             
                newlead.Mobile__c = CountryCode + mobileNumber ;
                newlead.Phone = CountryCode + stdCode + landLineNumber;              
                
                if(projectType == 'COMMERCIAL')
                {    newlead.City_O__c = 'Others';
                     newlead.Specify_Other_for_City_O__c = cityText;
                     newlead.Country_O__c = country;                
                     newlead.Office_Phone__c = CountryCode+stdCode+landLineNumber; 
                     newlead.Phone ='';  
                }
                
                else if(country == 'United States'){
                
               
                
                     newlead.City_R__c='Others';
                     newlead.Specify_Other_for_City_R__c =uscitystate;
                     newlead.Country_R__c = country;
                }else{
                     newlead.City_R__c='Others';
                     newlead.Specify_Other_for_City_R__c =cityText;
                     newlead.Country_R__c = country;  
                
                }
            }
            //2.0 filled GA related Lead fields
			newlead.Medium_GA__c = ApexPages.currentPage().getParameters().get('medium_ga');
	        newlead.Source_GA__c = ApexPages.currentPage().getParameters().get('source_ga');
	        newlead.Campaign_GA__c = ApexPages.currentPage().getParameters().get('campaign_ga');
	        newlead.Content_GA__c =  ApexPages.currentPage().getParameters().get('content_ga');
	        newlead.Term_GA__c = ApexPages.currentPage().getParameters().get('term_ga');
            insert newlead;
              
            sendMailtoLead(emailTemplateId,newlead.Id);
            isinserted=true;            
        }catch(exception e){
        system.debug('## exception : '+e);
        
            Error=e.getmessage();  
              
            isinserted=false;            
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
            mail.setTemplateId(emailTemplateId);         
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
            String[] toAdd =  new String[]{EmailId};
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
            htmlcontent+='<b>Name:</b>'+newlead.name+'<br/><b>Email Id:</b>'+newlead.email+'<br/>';
            htmlcontent+='<b>Mobile:</b>'+newlead.Mobile__c+'<br/><b>Landline:</b>'+newlead.phone+'<br/>';
            htmlcontent+='<b>stdCode:</b>'+stdCode+'<br/><b>country:</b>'+country+'<br/>';
            htmlcontent+='<b>city:</b>'+city+'<br/><b>citytext:</b>'+citytext+'<br/>';
            htmlcontent+='<b>CountryCode:</b>'+CountryCode+'<br/><b>Landline:</b>'+stdCode+newlead.phone+'<br/>';
            htmlcontent+='<b>Mobile:</b>'+newlead.Mobile__c+'<br/>';            
            htmlcontent+='<b>ProjectName:</b>'+projectInterested+'<br/><b>ProjectType:</b>'+ProjectType+'<br/>';            
            htmlcontent+='<b>Campaign name:</b>'+newlead.Campaign_Name__c+'<br/><b>Banner:</b>'+newlead.WebBanner_Source__c+'<br/>';            
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