public class AccountExtensions
{
    public Account a{get;set;} 
    
    public String pid {get;set;} 
    string aid;
    Opportunity o;
    public string title{get;set;} 

    public Boolean showFiorenzaForm {get;set;}      // CG Dev Team 22/09/2011 RenderValues for the Project-specific form
    public Boolean showWadalaForm {get;set;}        // CG Dev Team 22/09/2011 RenderValues for the Project-specific form
    public Boolean showWorldOneForm {get;set;}      // CG Dev Team 19/10/2011 RenderValues for the Project-specific form      
    public string[] entertainmentTypes{get;set;}    // CG Dev Team 20/10/2011 for the WorlOne/WorldCrest Project-specific form
    public string ProjectName {get;set;}        // CG Dev Team 24/10/2011 for the WorlOne/WorldCrest Project-specific form
//    public String AssignedProjectName {get;set;}    // Added by CG Dev Team 10/11/2011 RenderValues for the Project-specific form
        
    public AccountExtensions(ApexPages.StandardController controller)
    {
        title='';
        aid = System.currentPageReference().getParameters().get('id');
        pid = System.currentPageReference().getParameters().get('pid'); //Project Id        
        
        /* // CG Dev Team 22/09/2011
            //Start:Changes to include Wadala Project name
        */  
        showFiorenzaForm  =false;
        showWadalaForm = false;
        showWorldOneForm = false;
        system.debug('pid'+pid);
       // AssignedProjectName = VisitorFormGlobalVariables__c.getInstance().ProjectName__c;  // Added by CG Dev Team 10/11/2011 RenderValues for the Project-specific form
        ProjectName = [select Name from Project_Name__c where id=:pid].name;// Get Name from the ProjectId       
        
        if( ProjectName.equalsIgnoreCase('Lodha Fiorenza') )
        {
            showFiorenzaForm = true;
        }
        else if( ProjectName.equalsIgnoreCase('New Cuffe Parade') )
        {
            showWadalaForm = true;
        }
        else
        {
               showWorldOneForm =true; // CG Dev Team 19/10/2011 RenderValues for the Project-specific form      
                //Can Be a default form
        }
        // End:Changes to include Wadala Project name
        
        entertainmentTypes = new String[] {};     // Added by CG Dev Team 20/10/2011
        
        if(aid != null || aid != '')
        {
           try
           {
            a = [Select Id, FirstName, LastName, Anniversary_Date__c, 
                City_cont__pc, 
                Address3_O_cont__pc,
                Pincode_R_cont__pc, DOB_Of_Client__c, Salutation, Address1_R_cont__pc, Address2_R_cont__pc,
                Zone_R_cont__pc, Address3_R_cont__pc, 
                Suburb_R_cont__pc, 
                Phone, Mobile_Phone__c , PersonEmail,
                Email_acc__c, isPersonAccount , PersonBirthdate, Designation__pc, Lead_Company_Name_cont__pc,
                Car_s_Owned__c, Club_Membership__pc, Country_R_cont__pc,NumberOfEmployees,
                Ethinicity__c,Marital_Status__c,Family_Size__pc ,Spouse_Name__c,Children_Names__c, Holiday_Destination_s__c,Favorite_Mall_Shopping_Center__c,
                Newspaper__c, Website_s__c,Magazine_s__c,TV_Channel_s__c,Sport_s__c,Entertainment__c,Favorite_Restaurant__c,
                Favorite_travelled_destination_Abroad__c, Favorite_travelled_destination_India__c,
                Occupation_acc__c,Other_Occupation_acc__c
                from Account where Id =: aid and isPersonAccount = true];           // CG Dev Team 30/09/2011 NumberOfEmployees for the wadala-specific form
                // CG Dev Team 19/10/2011 added lines 53-54  for the world one form
               // CG Dev Team 23/11/2011 added Favorite_travelled_destination fields.                
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
           o = [Select Id, Project_Name__c from Opportunity where IsActive__c = True AND Project_Name__c =: pid AND AccountId=: aid order by lastmodifieddate desc LIMIT 1];  
       }
        catch(Exception e)
       {}
       
       string url = '';
       if(o != null)//Opportunity exists
       {
            url = '/apex/OpportunityPage?id=' + o.Id +  '&aid=' + aid + '&pid=' + pid;
       }
       else//Opportunity needs to be created
       {
            url = '/apex/OpportunityPage?aid=' + aid + '&pid=' + pid;
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
}