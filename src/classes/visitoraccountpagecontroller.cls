public class visitoraccountpagecontroller
{
    public Account a{get;set;} 
    
    public String pid {get;set;} 
    string aid;
    Opportunity o;
    public string title{get;set;} 

        
    public string[] entertainmentTypes{get;set;}   
    public string ProjectName {get;set;}
    
    
  
    public List<VisitorFormSettings__c> UserMapList {get;set;}    
    public VisitorFormSettings__c UserMap {get;set;}    
    public Project_Name__c Project {get;set;}
    public Boolean UserAccess{get;set;}    
    public String Css {get;set;} 
    public String CSS_URL {get;set;}
    
    
    
    public visitoraccountpagecontroller(ApexPages.StandardController controller)
    {
        title='';
        aid = System.currentPageReference().getParameters().get('id');      
        
            UserMapList = new List<VisitorFormSettings__c>();
            UserMapList = [select RecordType.Name,id,Name,isFiorenzaTemplate__c ,isWorldTowersTemplate__c ,ResidenceType__c ,Indulgences__c ,SourceHeader__c ,BudgetTitle__c ,WorkInfo__c ,ContactInfo__c ,OpportunityCSS__c,ThankYouCSS__c,LeadCSS__c,AccountCSS__c,User__c,LeadSource__c,Personal_Details__c,Project_name__c,Default__c,CSS_URL__c,Family__c,Preferences__c from VisitorFormSettings__c where User__c =:UserInfo.getUserId() and RecordType.Name = 'Account'];
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
                        Project = [select Id,Name,Project_Type__c,Type_of_Accomodation__c,Record_Type__c from Project_Name__c where id=:UserMap.Project_Name__c ];
                        pid=Project.Id;
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
     
        entertainmentTypes = new String[] {};    
        
        if(aid != null || aid != '')
        {
           try
           {
            a = [Select Id, FirstName, LastName, Anniversary_Date__c, 
                        City_cont__pc,
                        Address3_O_cont__pc,
                Pincode_R_cont__pc, DOB_Of_Client__c, Salutation, Address1_R_cont__pc, Address2_R_cont__pc,
                Zone_R_cont__pc,
                Address3_R_cont__pc, 
                Suburb_R_cont__pc,
                Phone, Mobile_Phone__c , PersonEmail,
                Email_acc__c, isPersonAccount , PersonBirthdate,
                Designation__pc, 
                Lead_Company_Name_cont__pc,
                Car_s_Owned__c, Club_Membership__pc, Country_R_cont__pc,NumberOfEmployees,
                Ethinicity__c,Marital_Status__c,Family_Size__pc ,Spouse_Name__c,Children_Names__c, Holiday_Destination_s__c,Favorite_Mall_Shopping_Center__c,
                Newspaper__c, Website_s__c,Magazine_s__c,TV_Channel_s__c,Sport_s__c,Entertainment__c,Favorite_Restaurant__c,
                Favorite_travelled_destination_Abroad__c, Favorite_travelled_destination_India__c
                from Account where Id =: aid and isPersonAccount = true];         
            title = a.FirstName + ' ' + a.LastName;
            string temp = a.Entertainment__c;
            if(temp != null && temp != '')
                entertainmentTypes = temp.split(';');
           }
           catch(Exception e)
           {
                string errMsg = 'ERROR in query ' + e.getMessage();
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, errMsg,errMsg); 
                ApexPages.addMessage(myMsg); 
                System.debug(errMsg);               
           }
        }       
    } 
     
    public PageReference submitAccount()
    {
       try
       {
            /* // CG Dev Team 22/09/2011
               //Start:Changes to include entertainmentTypes for WorldOne/WorldCrest Project 
            */  
           string str = '';
           for(string s: entertainmentTypes)
           {
              str = str + ';' + s;  
           }        
           a.Entertainment__c = str;
           // End:Changes to include entertainmentTypes for WorldOne/WorldCrest Project 
           if(a != null)
               upsert a;
       }       
       catch(Exception e)
       {
           string errMsg = 'ERROR in upserting Account ' + e.getMessage();
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, errMsg,errMsg); 
           ApexPages.addMessage(myMsg); 
           System.debug(errMsg);
           return null;
       }
       try
       {
           system.debug('PROJECTID'+pid+'ACCOUNTID'+aid);
           o = [Select Id, Project_Name__c ,Isactive__c from Opportunity where Project_Name__c =: pid AND AccountId=: aid AND Isactive__c=true order by lastmodifieddate desc LIMIT 1];  
           
       }
        catch(Exception e)
       {}
       
       string url = '';
       if(o != null)//Opportunity exists
       {
            url = '/apex/VisitorOpportunity?id=' + o.Id +  '&aid=' + aid + '&pid=' + pid;
       }
       else//Opportunity needs to be created
       {
            url = '/apex/VisitorOpportunity?aid=' + aid + '&pid=' + pid;
       }
       
       PageReference pageRef = new PageReference(url);           
       return pageRef;
    }  
            /* // CG Dev Team 22/09/2011
               //Start:Changes to include entertainmentTypes for WorldOne/WorldCrest Project 
            */ 
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Movie','Movie'));
        options.add(new SelectOption('Play','Play/Theatre'));
        options.add(new SelectOption('Outdoor Sport','Outdoor Sport'));
        options.add(new SelectOption('Other/s','Other/s'));
        return options;
    }
           // End:Changes to include entertainmentTypes for WorldOne/WorldCrest Project 
           

    /*****************************TEST**********************************/           
 
}