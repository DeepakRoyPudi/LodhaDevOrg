public class VisitorLeadPageController 
{
    public List<VisitorFormSettings__c> UserMapList {get;set;}
    public Lead l{get;set;}
    public List<String> accomTypes {get;set;}
    public String title {get;set;} 
    public String leadsource {get;set;}   
    public String Phone {get;set;}    
    public String ExistingMobile {get;set;}
    public list<String> LeadSourceSet {get;set;}        
    public VisitorFormSettings__c UserMap {get;set;}    
    public Project_Name__c Project {get;set;}
    public Boolean UserAccess{get;set;}    
    public String Css {get;set;} 
    public String CSS_URL {get;set;}   
     
    Map<string,string> ProjectQueueMap =  new Map<string,string>();    
        
    public VisitorLeadPageController (ApexPages.StandardController controller)
    {
        try
        {
            string LeadId = System.currentPageReference().getParameters().get('id');
            phone = System.currentPageReference().getParameters().get('ph');        
    
            UserMapList = new List<VisitorFormSettings__c>();
            UserMapList = [select RecordType.Name,id,Name,AccountCSS__c,isFiorenzaTemplate__c, isWorldTowersTemplate__c,ResidenceType__c ,Indulgences__c ,SourceHeader__c ,BudgetTitle__c ,WorkInfo__c ,ContactInfo__c ,OpportunityCSS__c,ThankYouCSS__c,LeadCSS__c,User__c,LeadSource__c,Personal_Details__c,Project_name__c,Default__c,CSS_URL__c from VisitorFormSettings__c where User__c =:UserInfo.getUserId() and RecordType.Name = 'Lead' ];
            if(UserMapList.isEmpty())
            {
                //Redirect to standard page.
                UserAccess=false;
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'User is not Authorised to Access this Project');
                ApexPages.addMessage(msg);
            }
            else
            {
                
                UserMap = new VisitorFormSettings__c();  
                for(VisitorFormSettings__c u:UserMapList )
                {
                    if(u.Default__c)
                    {
                        UserMap = u;
                    }
                }
                if(UserMap != null)
                {
                    UserAccess=true;
                    if(UserMap.Project_Name__c!= null)
                    {
                        Project = new Project_Name__c();                  
                        Project = [select Id,Name,accomodationMap__c, leadSourceMap__c,Project_Type__c,Type_of_Accomodation__c,Record_Type__c from Project_Name__c where id=:UserMap.Project_Name__c ];
                    }
                    //Css = UserMap.Css__c;
                }
                else
                {
                    UserAccess=false;
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'User is not Associated to a default Project');
                    ApexPages.addMessage(msg);
                }                
            }
          
            accomTypes = new List<String>();
            leadsource = '';
            if(LeadId == null || LeadId == '')//New Lead
            {
                 l=  new Lead();
                 l.Mobile__c = phone;
                 title= 'New Lead';
            }
            else//exisitng Lead
            {
               l = [Select Id, Name, FirstName, LastName, Pincode_R__c, Salutation, Address_r1__c, Address_3_O__c, Country_R__c,
                   Specify_Other_for_Zone_R__c , Specify_Other_for_City_R__c , Specify_Other_for_Suburb_R__c, Interested__c, 
                   Status, City_R__c, Zone_RS__c, Address2_R__c, Address_3_R__c, Suburb_RS__c, Phone, Mobile__c, Email, 
                   Date_Of_Birth__c, Designation__c, Company, Lead_Company_Name__c, Budget_in_Lakhs__c, LeadSource, 
                   LeadSource_Others__c, Owned_Car_Name__c, Club_Membership__c, Type_of_Accomodation__c, 
                   Project_Name__c, Landline__c, Channel_Partner__c, Corporate_Account__c,NumberOfEmployees,Ethinicity__c,  Marital_status__c, 
                   Favorite_travelled_destination_Abroad__c , Favorite_travelled_destination_India__c
                   from Lead where Id =: leadId AND Isconverted = false];  
               ExistingMobile = l.Mobile__c;
               title = l.Name;
               string temp = l.Type_of_Accomodation__c;
               if(temp != null && temp != '')
               {
                    temp = temp.tolowerCase();
                    accomTypes = temp.split(';');           
               }
             }  
             leadsource = getCurrentLeadSource();
             if(l.LeadSource_Others__c != null && l.LeadSource_Others__c != '')
                leadsource = 'Others';                            
             populateProjectQueueMap();         
        } 
        catch (Exception e)
        {
            system.debug('INIT_ERROR:'+e);
        }
    } 

    public List<SelectOption> getItems() 
    {
        List<SelectOption> options = new List<SelectOption>();
        if(Project!= null )
        {
            if(Project.accomodationMap__c!=null){
                for(String accomodationMap :Project.accomodationMap__c.split(';'))
                {
                    String[] accomodation = accomodationMap.split(',');
                    options.add(new SelectOption(accomodation[0].tolowerCase(),accomodation[1]));
                }
            }
         }
        return options;
    }   
    
    public List<SelectOption> getLeadSourceList() 
    {
        List<SelectOption> options = new List<SelectOption>();
        if(UserMap != null && UserMap.LeadSource__c != '' && Project.LeadSourceMap__c !=null)
        {
            for(String usrleadsource :UserMap.LeadSource__c.split(';')){
                for(String leadSourceMap:Project.LeadSourceMap__c.split(';')){
                     String[] leadSource = leadSourceMap.split(',');
                     if(leadSource[0].tolowerCase() == usrleadsource.tolowerCase()){
                         options.add(new SelectOption(leadSource[0],leadSource[1]));
                     }
                }
            }
        }
        return options;       
    }
   
    void populateProjectQueueMap()
    {
        Map<String, ProjectQueueMapping__c> pqMap = ProjectQueueMapping__c.getAll();
        List<String> pqNames = new List<String>();
        pqNames.addAll( pqMap.keySet());
        for (String p : pqNames) 
        {
            ProjectQueueMapping__c pqObj = pqMap.get(p);
            ProjectQueueMap.put(pqObj.Name,pqObj.Queue__c);
        }                   
    }
   
    public String getCurrentLeadSource(){
        String currentLeadSource = '';
        if(UserMap.LeadSource__c!=null && Project.LeadSourceMap__c!=null){
            for(String usrleadsource :UserMap.LeadSource__c.split(';')){
                for(String leadSourceMap:Project.LeadSourceMap__c.split(';')){
                     String[] leadSource = leadSourceMap.split(',');
                     if(leadSource[0] == l.LeadSource){
                        currentLeadSource = leadSource[0];
                     }
                }
            }
        }
        return currentLeadSource;
    }
    public PageReference submitLead()
    {
       try
       {
           string str = '';
           for(string s: accomTypes)
           {
              str = str + ';' + s;  
           }        
           l.Type_of_Accomodation__c = str;

           if(leadsource != '' && leadsource != null ) 
           {
                l.LeadSource = leadsource;
           }
           else
           {
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please specify Lead Source.');
                    ApexPages.addMessage(msg);
                    return null;
           }
           //In all scenarios - Project Name will be changed to pid(Fiorenza) and Queue (Fiorenza Queue)
           l.Project_Name__c = Project.Id;
           l.Status = 'Visit Done';
           l.Interested__c = 'Yes';
           l.FromVisitorForm__c = False;
           if(ProjectQueueMap.containsKey(Project.Id))  
           {               
                l.OwnerId = ProjectQueueMap.get(Project.Id);           
           }
           List<Lead> LeadList = new List<Lead>();
           LeadList.add(l); 
           if(l.RecordTypeId == null)
               l.RecordTypeId = [Select r.SobjectType, r.Name, r.Id From RecordType r where r.SobjectType = 'Lead' and r.Name = 'Residential'].Id;
           if(ExistingMobile != null && ExistingMobile != l.Mobile__c)
           {
               FlagDuplicateLead.findDuplicates(LeadList);
           }
           if(ExistingMobile == null)
               FlagDuplicateLead.findDuplicates(LeadList);           
           if(l.Id != null && l.Id == l.Existing_Lead__c )
               l.Existing_Lead__c = null;
           LeadList[0].FromVisitorForm__c = True;
           upsert l;
       }
       catch(Exception e)
       {
           string errMsg = 'ERROR in upserting lead ' + e.getMessage();
           ApexPages.addMessages(e);
           return null;
       }
       return Page.visitthankyoupage;
    } 
    
    /****************************TEST METHOD***************************************/         
    public static testMethod void testLeadClasses() 
     {
                
                User u = [select id from user where Profile.name = 'System Administrator' and isActive = true limit 1];
                system.runas(u){

                Id recType = [Select r.SobjectType, r.Name, r.Id From RecordType r where r.SobjectType = 'VisitorFormSettings__c' and r.Name = 'Lead'].Id;
                Project_name__c project = new Project_name__c();
                project.Name = 'testProject';
                project.project_type__c = 'Casa';
                project.record_type__c  = 'Residential';
                insert project;
                
                VisitorFormSettings__c vfSetting = new VisitorFormSettings__c();
                vfSetting.User__c = u.Id;
                vfSetting.Project_Name__c = project.Id;
                vfSetting.RecordTypeId = recType;
                vfSetting.Default__c = true;
                vfSetting.LeadSource__c = 'Corporate Tie-Up; Newspaper; Hoarding; Channel Partner; Web; Emailer; Others';
                insert vfSetting;

                List<VisitorFormSettings__c> vfSettingList = [select RecordType.Name,id,Name,AccountCSS__c,isFiorenzaTemplate__c, isWorldTowersTemplate__c,ResidenceType__c ,Indulgences__c ,SourceHeader__c ,BudgetTitle__c ,WorkInfo__c ,ContactInfo__c ,OpportunityCSS__c,ThankYouCSS__c,LeadCSS__c,User__c,LeadSource__c,Personal_Details__c,Project_name__c,Default__c,CSS_URL__c from VisitorFormSettings__c where User__c =:UserInfo.getUserId() and RecordType.Name = 'Lead' ];                
                system.debug(vfSetting+'________'+vfSettingList);


                Lead l = new Lead();                   
                l.LastName = 'test';
                l.Mobile__c = '9876543210';
                l.LeadSource = 'website';
                l.Type_of_Accomodation__c = '1 bhk;2bhk';
                l.Project_Name__c = project.Id;
                insert l;
                ApexPages.StandardController controller1 = new ApexPages.StandardController(l);  
                String page1 = '/apex/visitorleadpage' + '?id=' + l.Id ;             
                PageReference pageRef1 = new PageReference(page1);        
                Test.setCurrentPage(pageRef1);
                ApexPages.StandardController controller2 =  new ApexPages.StandardController(l);        
                VisitorLeadPageController ctrl2 =  new VisitorLeadPageController(controller2);
                ctrl2.getItems();
                ctrl2.getLeadSourceList();
                ctrl2.leadsource = 'Website';
                ctrl2.submitLead(); 
                
                //New Lead
                ApexPages.StandardController controller3 = new ApexPages.StandardController(l);  
                String page3 = '/apex/visitorleadpage'; 
                PageReference pageRef3 = new PageReference(page3);        
                Test.setCurrentPage(pageRef3 );
                ApexPages.StandardController controller4 =  new ApexPages.StandardController(l);        
                VisitorLeadPageController ctrl4 =  new VisitorLeadPageController(controller4);
                ctrl4.getItems();
                ctrl4.getLeadSourceList();
                ctrl2.leadsource = 'Website';
                ctrl4.submitLead();                 
                }
     }    
}