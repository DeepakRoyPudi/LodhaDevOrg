/*
Author - CG DEV
Class Name - ExpressRegistrationController 
Date Created - 21/10/2011
Purpose - Controller for ExpressRegistrationPage

*    Version        Date                Author                Description
*    1.0            21/10/2011          Anonymous             Initial Draft
*    2.0            11/11/2014          Anupam Agrawal        IT-HD 57234
*    3.0            24/11/2014    Anupam Agrawal     Add new fields related to GA(Google Analytics) IT-HD - 56009
*/

public class ExpressRegistrationExtension {
    public final Lead weblead {set; get;}  
    public Id projectId {get; set;}
    public id rectypeId;
    public string leadFirstName{get; set;}  
    public string leadLastName{get; set;}  
    public string leadEmail{get; set;}
    public string leadMobile{get; set;}
    public string leadstdCode{get;set;}
    public string leadPhone{get; set;}
    public String city{get;set;}

    public string CompanyName{get;set;}
    public string ProjectType{get;set;}
    string recType;
    public String AccommodationValue{get;set;}
    public String BudgetInLakhs{get;set;}
    Public List<String> accTypeList;
    public string DateOfVisit{get;set;}
    public String Purpose{get;set;}
    public String PlotNo{get;set;}
    public String Street{get;set;}
    public string Locality{get;set;}
    public string PinCode{get;set;}
    public String Occupation{get;set;}
    public boolean bdisableButton{get;set;}
    public String CampaignName{get;set;}
    public string publisher{get;set;}

    public String[] accomTypes {get;set;}
    public boolean IsValidEmail {get;set;}
    public boolean IsValidPlotNo {get;set;}
    public boolean IsValidPinCode {get;set;}
    public boolean IsValidMobile {get;set;}
    public String Country{get;set;}    
    public  String others {get;set;}
    /*IT-HD 57234 2.0: Added by Anupam Agrawal: Start variables declaration*/
    public String selectedTime {get;set;}
    public String selectedTimeType {get;set;}
    public String selectedMinute {get;set;}
    
    public List<SelectOption> lstTime {get;set;}
    public List<SelectOption> lstMinute {get;set;}
    public List<SelectOption> lstTimeType {get;set;}
    //Only using Date field of Lead object(Birth date) to dispaly std field on VF page
    public Lead objLead {get;set;}
    /*End variables declaration*/
    
    public ExpressRegistrationExtension(ApexPages.StandardController stdController) {
       try
	   {
	       accTypeList = new List<String>();
	       Country = 'India';
	       weblead = (Lead)stdController.getRecord();  
	       projectId = ApexPages.currentPage().getParameters().get('projectid');
	       CampaignName= ApexPages.currentPage().getParameters().get('campaign');
	       publisher= ApexPages.currentPage().getParameters().get('publisher');
	
	       if(projectId==null)
	       {
	           bdisableButton=true;
	           //ApexPages.addMessages('Project Id can not be blank'); 
	       }
	       else
	       {
	           bdisableButton=false;
	       }
	
	       accomTypes = new String[] {};
	
	       if(projectId != null)
	       { 
	           system.debug('Project Id :' + projectId);
	           List<Project_Name__c> projectList = [Select Record_Type__c,Project_Type__c,Type_of_Accomodation__c from Project_Name__c where id = :projectId];
	
	           system.debug('Project Id :' + projectList[0].Record_Type__c);
	           if(projectList.size()>0)
	           {
	               Project_Name__c objProjectName=projectList[0];
	               recType=objProjectName.Record_Type__c;
	               if(objProjectName.Project_Type__c!=null && objProjectName.Project_Type__c!='')
	               {
	                   ProjectType=objProjectName.Project_Type__c.touppercase();
	               }
	               
	               String accType=objProjectName.Type_of_Accomodation__c;
	               rectypeId = RecordTypeHelper.getRecordTypeId('Lead',recType);
	               
	               if(accType!=null && accType!='')
	               {
	                   accTypeList=accType.split(';');
	               }
	               
	           }
	       }
	       
	   }
       catch(Exception exp)
       {
           String CaseException=exp.getMessage() + '---:--- Line Number is--:' + String.valueOf(exp.getLineNumber());
           //SendErrorMail(CaseException);
           System.debug('----------CaseException----------'+CaseException); 
       }
       
       /* 3.0 Added By Anupam: 57234*/
       lstTime = new List<SelectOption>();
       lstTimeType = new List<SelectOption>();
       lstMinute = new List<SelectOption>();
       objLead = new Lead();
       for(Integer i = 1 ; i <= 12 ; i++)
       {
       		lstTime.add(new SelectOption(String.valueOf(i), String.valueOf(i)));
       }
       
       lstTimeType.add(new SelectOption('PM', 'PM'));
       lstTimeType.add(new SelectOption('AM', 'AM'));
       
       lstMinute.add(new SelectOption(String.valueOf('00'), String.valueOf('00')));
       lstMinute.add(new SelectOption(String.valueOf(15), String.valueOf(15)));
       lstMinute.add(new SelectOption(String.valueOf(30), String.valueOf(30)));
       lstMinute.add(new SelectOption(String.valueOf(45), String.valueOf(45)));
       /* End: 57234*/
    }
    private boolean ShowDesignationCompany(String projectType)
    {
        return true;
    }
    Public void SendErrorMail(String exception1)
    {
        try
        {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String EmailID1='shradha.jaiswal@lodhagroup.com';
            String EmailID2='mangesh.patil@in.fujitsu.com';
            String[] toAdd =  new string[]{EmailID1,EmailID2};
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
    
        weblead.Project_Name__c = projectId;
        weblead.LeadSource = 'Express Registration';
        weblead.FirstName = leadFirstName;
        weblead.LastName = leadLastName;
        //2.0 filled GA related Lead fields
		weblead.Medium_GA__c = ApexPages.currentPage().getParameters().get('medium_ga');
        weblead.Source_GA__c = ApexPages.currentPage().getParameters().get('source_ga');
        weblead.Campaign_GA__c = ApexPages.currentPage().getParameters().get('campaign_ga');
        weblead.Content_GA__c =  ApexPages.currentPage().getParameters().get('content_ga');
        weblead.Term_GA__c = ApexPages.currentPage().getParameters().get('term_ga');
      
        //if(DateOfVisit.length() != 0)
        //{
            //Date dt = Date.parse(DateOfVisit);  
            //weblead.Date_Of_Visit__c =dt;
        //}
        weblead.Email = leadEmail;

        if(city != null && city != '')
        {
            if(ProjectType!='COMMERCIAL')
                weblead.City_R__c = city;
            else
                weblead.City_O__c=city;
        }
        else
        {
            if(ProjectType!='COMMERCIAL')
                weblead.City_R__c = city;
            else
                weblead.City_O__c=city;
        }
        weblead.Mobile__c = leadMobile;
        weblead.STD_Code__c = leadstdCode;
        weblead.Phone = leadPhone; 
        weblead.Recordtypeid = rectypeId;
        weblead.country_O__c = Country;
        
        //IT-HD 0057234 : Anupam Agrawal
        if(BudgetInLakhs == '40-50 lacs')
        {
            weblead.Budget_in_Lakhs__c = 50;
        }
        else if(BudgetInLakhs == '51-60 lacs')
        {
            weblead.Budget_in_Lakhs__c = 60;
        }
        else if(BudgetInLakhs == '61 and Above')
        {
            weblead.Budget_in_Lakhs__c = 61;
        }
        weblead.Purpose__c=Purpose;
        weblead.Address_r1__c=PlotNo;
        weblead.Address2_R__c=Street;
        weblead.Address_3_R__c=Locality;
        weblead.Pincode_R__c=PinCode;
        weblead.Occupation__c=Occupation;
        
        /* Added By Anupam: 57234*/
        weblead.Date_Of_Visit__c = DateTime.newInstance(objLead.Date_Of_Birth__c.year(), 
    													objLead.Date_Of_Birth__c.month(), 
														objLead.Date_Of_Birth__c.day(), 
														selectedTimeType == 'PM' ? Integer.valueOf(selectedTime) + 12 : Integer.valueOf(selectedTime),
														Integer.valueOf(selectedMinute),
													    0);
        
        /* End: 57234*/
        if(Occupation == 'Others')
        {
            weblead.Other_Occupation__c = others;
        }
            
        string str = '';
        for(string s: accomTypes)
        {
           str = str + ';' + s;  
        }

        weblead.Type_of_Accomodation__c = str;
               
        webLead.Company=CompanyName;
        if(CampaignName!=null)
        {
           webLead.Campaign_Name__c=CampaignName;
        }
        if(publisher!=null)
        {
            webLead.WebBanner_Source__c=publisher;
            
        }
        
        if(leadFirstName == '' )
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Please Enter First Name');
           ApexPages.addMessage(myMsg);
           //dateofvisit = dateofvisit;
           return null;
        }
        if (leadLastName == '')
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Please Enter Last Name');
           ApexPages.addMessage(myMsg);
           return null;
        }
       /* if (DateOfVisit.length() == 0)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Please Enter Date of Visit');
           ApexPages.addMessage(myMsg);
           return null;
        }*/
        if (String.valueOf(weblead.Date_Of_Visit__c) =='' || String.valueOf(weblead.Date_Of_Visit__c) ==null)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Please Enter Date of Visit');
           ApexPages.addMessage(myMsg);
           return null;
        }
        if (IsValidPlotNo == false)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Please Enter only Numeric character in Plot/Flat No.');
           ApexPages.addMessage(myMsg);
           return null;
        }
        if (city == 'None')
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Please Enter City');
           ApexPages.addMessage(myMsg);
           return null;
        }
        if (IsValidPinCode == False)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Please Enter Valid Pin Code');
           ApexPages.addMessage(myMsg);
           return null;
        }
         
        if (leadMobile == '' || IsValidMobile == False)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Please Enter Valid Mobile');
           ApexPages.addMessage(myMsg);
           return null;
        }
        if (IsValidEmail == False)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Please Enter Valid Email ');
           ApexPages.addMessage(myMsg);
           return null;
        }
        if (accomTypes.size() == 0)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Please Select Accomodation Type ');
           ApexPages.addMessage(myMsg); 
           return null;
        }
        if (BudgetInLakhs == null || BudgetInLakhs == '' )
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Please Enter Budget');
           ApexPages.addMessage(myMsg);
           return null;
        }

        /* Assign to project specific queues
        Map<string,string> ProjectQueueMap =  new Map<string,string>();
        Map<String, ProjectQueueMapping__c> pqMap = ProjectQueueMapping__c.getAll();
        List<String> pqNames = new List<String>();
        pqNames.addAll( pqMap.keySet());
        for (String p : pqNames) 
        {
            ProjectQueueMapping__c pqObj = pqMap.get(p);
            ProjectQueueMap.put(pqObj.Name,pqObj.Queue__c);
        }  
        
           if(projectId != null && projectId != '' && ProjectQueueMap.containsKey(projectId))  
           {               
                weblead.OwnerId = ProjectQueueMap.get(projectId);           
           }
         End Assign to project specific queues*/  
        
        insert(weblead); 
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    
        //mail.setTemplateId('00XL0000000DYGF');
        mail.setTemplateId('00XD0000001rAxL');  
              
        mail.setTargetObjectId(weblead.id);
       // mail.setOrgWideEmailAddressId('0D2D000000000wo');        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

        system.debug('Come here End');
       }  
       catch(Exception e) { 
           ApexPages.addMessages(e);  
       
       return null;  
      }  
        PageReference p = Page.ThankYou;  
        p.getParameters().put('id',weblead.Id);
        p.setRedirect(true);  
        return p;  
     }

    public List<SelectOption> getItems() 
    {
        List<SelectOption> options = new List<SelectOption>();
        if(accTypeList.size()>0)
        {
            accTypeList.sort();
            for(String typeOfAcc : accTypeList)
            {
                options.add(new Selectoption(typeOfAcc ,typeOfAcc ));
            }
        }
        return options;
    }
    
   
}