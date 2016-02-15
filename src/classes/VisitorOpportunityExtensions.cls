public class VisitorOpportunityExtensions {

    string pid;
    string aid;
    string oid;
    public Opportunity o {get;set;}
    public string[] accomTypes{get;set;}
    public List<VisitorFormSettings__c> UserMapList {get;set;}    
    public VisitorFormSettings__c UserMap {get;set;}    
    public Project_Name__c Project {get;set;}
    public Boolean UserAccess{get;set;}    
    public String Css{get;set;} 
    public String CSS_URL {get;set;}
    public String leadsource {get;set;}

    public VisitorOpportunityExtensions(ApexPages.StandardController controller) 
    {
        

        try
        {
            oid = System.currentPageReference().getParameters().get('id');
            aid = System.currentPageReference().getParameters().get('aid'); //Account Id
            pid = System.currentPageReference().getParameters().get('pid'); //Project Id 
                
            UserMapList = new List<VisitorFormSettings__c>();
            UserMapList = [select RecordType.Name,id,Name,ResidenceType__c,isWorldTowersTemplate__c , isFiorenzaTemplate__c   ,Indulgences__c ,SourceHeader__c ,BudgetTitle__c ,WorkInfo__c ,ContactInfo__c ,OpportunityCSS__c,ThankYouCSS__c,LeadCSS__c,AccountCSS__c,User__c,LeadSource__c,Personal_Details__c,Project_name__c,Default__c,CSS_URL__c,Family__c,Preferences__c from VisitorFormSettings__c where User__c =:UserInfo.getUserId() and RecordType.Name = 'Opportunity'];
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
                        Project = [select Id,Name,Project_Type__c,accomodationMap__c ,leadSourceMap__c ,Type_of_Accomodation__c,Record_Type__c from Project_Name__c where id=:UserMap.Project_Name__c ];
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
      
           
                
            accomTypes = new String[] {};
             leadsource = '';

            if(oid == null) //Create New opportunity
            {
                Account a = [Select Id, Name from Account where id =: aid];
                o =  new Opportunity();
                o.AccountId = aid;
                o.Project_Name__c = Project.Id; 
                o.Name = a.Name + '-' + Project.Name; 
                o.StageName = 'Qualification';
                o.CloseDate = System.today() + 45;
            }
            else //Update exsiting Opportunity
            {
                o = [Select Id ,Name, Budgeted_Price__c,Lead_Source_Details__c,LeadSource, Walk_in_Source__c, Walk_in_Channel_Partner__c, Walk_in_Corporate_Account__c, Walk_in_Source_Details__c, Type_of_Accomodation__c, Channel_Partner__c, Corporate_Account__c, StageName, Total_Consideration_Value__c, Booking_Date__c from Opportunity where Id =: oid ];  // Modified by CG Dev Team 20/10/2011
                string temp = o.Type_of_Accomodation__c ;
                if(temp != null && temp != '')
                {
                    temp = temp.tolowerCase();
                    accomTypes = temp.split(';');  
                }
                
                leadsource = getCurrentLeadSource();                                      
               if((o.StageName == 'Closed Won' || o.StageName == 'Cancelled')&&(o.Total_Consideration_Value__c != '' || o.Total_Consideration_Value__c != null) && o.Booking_Date__c != null)
               {
                Account a = [Select Id, Name from Account where id =: aid];
                o =  new Opportunity();
                o.AccountId = aid;
                o.Project_Name__c = Project.Id; 
                o.Name = a.Name + '-' + Project.Name; 
                o.StageName = 'Qualification';
                o.CloseDate = System.today() + 45;
                leadsource  = '';
                accomTypes.clear();
                  
              } 
              // Start:Changes to include Opportunity are Created or Updated based on condition 
             }
        }
        catch(Exception e)
        {
            System.debug('ERROR in displaying page ' +  e.getMessage());
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
                     if(leadSource[0] == usrleadsource){
                         options.add(new SelectOption(leadSource[0],leadSource[1]));
                     }
                }
            }
        }
        return options;       
    }
       public PageReference goBack() 
    {
        string url = '/apex/visitorAccountPage?id=' + aid + '&pid=' + pid;
         PageReference pageRef = new PageReference(url);           
      return pageRef;     
    }
    
    private String getCurrentLeadSource(){
        String currentLeadSource = '';
        if(UserMap.LeadSource__c!=null && Project.LeadSourceMap__c!=null){
            for(String usrleadsource :UserMap.LeadSource__c.split(';')){
                for(String leadSourceMap:Project.LeadSourceMap__c.split(';')){
                     String[] leadSource = leadSourceMap.split(',');
                     if(leadSource[0] == o.Walk_in_Source__c){
                        currentLeadSource = leadSource[0];
                     }
                }
            }
        }
        return currentLeadSource;
    }
        
     public PageReference submitOpportunity()
    {
       try
       {

               string str = '';
               for(string s: accomTypes)
               {
                  str = str + ';' + s;  
               }
     
               o.Type_of_Accomodation__c = str;
               

               if(leadsource != '' && leadsource != null)
               {
                   o.Walk_in_Source__c = leadsource;        
               }
                upsert o;
        }       
       catch(Exception e)
       {
           string errMsg = 'ERROR in upserting Opportunity ' + e.getMessage();
           System.debug(errMsg);
           return null;
       }
  
      PageReference pageRef = new PageReference('/apex/visitthankyoupage?pid='+pid+'&retUrl=/'+aid);  
      return pageRef;
    }
    
    public static testMethod void testOpportunityClasses() {
    
        User u = [select id from user where Profile.name = 'System Administrator' and isActive = true limit 1];
        system.runas(u){

        Id recType = [Select r.SobjectType, r.Name, r.Id From RecordType r where r.SobjectType = 'VisitorFormSettings__c' and r.Name = 'Opportunity'].Id;
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
        
        Account a = new Account();       
        a.lastname = 'Test Account';
        a.recordtypeId = [Select r.SobjectType, r.Name, r.Id From RecordType r where r.SobjectType = 'Account' and r.Name = 'Person Account'].Id;        
        a.Mobile_Phone__c = '9876543211';
        insert a;        
        
        Opportunity oppty = new opportunity();
        oppty.AccountId = a.Id;
        oppty.Name ='test Opportunity';
        oppty.RecordTypeId = [Select r.SobjectType, r.Name, r.Id From RecordType r where r.SobjectType = 'Opportunity' and r.Name = 'Residential'].Id; 
        oppty.stagename = 'Qualification';
        oppty.closeDate = system.today();
        oppty.project_name__c=project.id;
        insert oppty;
            
        String page1 = '/apex/OpportunityPage?aid=' + oppty.AccountId ;               
        PageReference pageRef1 = new PageReference(page1);        
        Test.setCurrentPage(pageRef1);         
        ApexPages.StandardController controller1 = new ApexPages.StandardController(oppty);  
        VisitorOpportunityExtensions ctrl1 =  new VisitorOpportunityExtensions(controller1);
        //ctrl1.o = oppty;
        ctrl1.accomTypes = new String[]{'2 BHK','3 BHK'};
        ctrl1.leadsource = 'Web';
        ctrl1.getItems();    
        ctrl1.getLeadSourceList();
        ctrl1.goBack();
        ctrl1.submitOpportunity();  
        
        String page2 = '/apex/OpportunityPage?aid=' + oppty.AccountId +  '&id=' + oppty.Id;                
        PageReference pageRef2 = new PageReference(page2);        
        Test.setCurrentPage(pageRef2);
        
        oppty = [Select Id,Name, Budgeted_Price__c,Lead_Source_Details__c,LeadSource, Type_of_Accomodation__c,AccountId from Opportunity where id =: oppty.Id ];    
        ApexPages.StandardController controller2 = new ApexPages.StandardController(oppty);  
        VisitorOpportunityExtensions  ctrl2 =  new VisitorOpportunityExtensions (controller2);
        ctrl2.o = oppty;
        ctrl2.accomTypes = new String[]{'2 BHK','3 BHK'};
        ctrl2.leadsource = 'Web';
        ctrl2.getItems();    
        ctrl2.getLeadSourceList();
        ctrl2.goBack();
        ctrl2.submitOpportunity();
        
        
        String page3 = '/apex/OpportunityPage?aid=' + oppty.AccountId + '&id=' + oppty.Id;                
        PageReference pageRef3 = new PageReference(page3);        
        Test.setCurrentPage(pageRef3);
        oppty = [Select Total_Consideration_Value__c,stagename,Booking_Date__c,Id,Name, Budgeted_Price__c,Lead_Source_Details__c,LeadSource, Type_of_Accomodation__c,AccountId from Opportunity where id =: oppty.Id];    
        oppty.stagename='cancelled';
        oppty.Total_Consideration_Value__c='';
        oppty.Booking_Date__c=system.today();  
        oppty.project_name__c=project.id;
        update oppty;
        ApexPages.StandardController controller3 = new ApexPages.StandardController(oppty);  
        VisitorOpportunityExtensions ctrl3 =  new VisitorOpportunityExtensions(controller3);
        ctrl3.o = oppty;
        ctrl3.accomTypes = new String[]{'2 BHK','3 BHK'};
        ctrl3.leadsource = 'Web';
        ctrl3.getItems();    
        ctrl3.getLeadSourceList();
        ctrl3.goBack();
        ctrl3.submitOpportunity();
        }
    }    
 
}