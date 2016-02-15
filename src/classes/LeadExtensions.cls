public class LeadExtensions
{

    public string[] accomTypes{get;set;}    
    public string leadsource{get;set;}    
    public Lead l{get;set;} 
    public string title{get;set;} 
    public string errorMessage{get;set;} 
    public string pid {get;set;}
    string phone; 
    Map<string,string> ProjectQueueMap =  new Map<string,string>();
    boolean newLead = false;

    public Boolean showFiorenzaForm {get;set;}      // Added by CG Dev Team 22/09/2011 RenderValues for the Project-specific form
    public Boolean showWadalaForm {get;set;}        // Added by CG Dev Team 22/09/2011 RenderValues for the Project-specific form
    public Boolean showWorldOneForm {get;set;}      // Added by CG Dev Team 19/10/2011 RenderValues for the Project-specific form    
    public String ProjectName {get;set;}            // Added by CG Dev Team 22/09/2011 RenderValues for the Project-specific form
    public String ExistingMobile{get;set;}          // Added by CG Dev Team 22/09/2011 to Capture Mobile number for Duplicate Check
//    public String AssignedProjectName {get;set;}    // Added by CG Dev Team 10/11/2011 RenderValues for the Project-specific form
        
    //SRCG-199    
    public Boolean showTheParkForm {get;set;} 
    Public string visitors{get; set;}
    Public List<string> configLst{get; set;}
    Public string occ{get; set;}
    
    
    
    
    public LeadExtensions(ApexPages.StandardController controller)
    {
        string lid = System.currentPageReference().getParameters().get('id');
        pid = System.currentPageReference().getParameters().get('pid'); //Project Id
        /* Added by CG Dev Team 22/09/2011
        *   Start:Changes to include Wadala Project form
        */  

        showFiorenzaForm  =false;
        showWadalaForm = false;
        showWorldOneForm = false;
        showTheParkForm=false;
        //AssignedProjectName = VisitorFormGlobalVariables__c.getInstance().ProjectName__c;  // Added by CG Dev Team 10/11/2011 RenderValues for the Project-specific form
        ProjectName = [select Name from Project_Name__c where id=:pid].name;              // Added by CG Dev Team 22/09/2011 RenderValues for the Project-specific form      

        if( ProjectName.equalsIgnoreCase('Lodha Fiorenza') )
        {
            showFiorenzaForm = true;
        }
        else if( ProjectName.equalsIgnoreCase('New Cuffe Parade') )
        {
            showWadalaForm = true;
        }
        else if( ProjectName.equalsIgnoreCase('The Park') )
        {
            showTheParkForm= true;
        }
        else
        {
                showWorldOneForm = true;    // Added by CG Dev Team 19/10/2011 RenderValues for the Project-specific form  
                //Can Be a default form
        }
        
        /* End:Changes to include Wadala Project form */
        phone = System.currentPageReference().getParameters().get('ph'); //Phone Number         
        accomTypes = new String[] {};
        leadsource = '';
        if(lid == null || lid == '')//New Lead
        {
             l =  new Lead();
             newLead = true;
             l.Mobile__c = phone;
             title = 'New Lead';
        }
        else//exisitng Lead
        {
           l = [Select Id, Name, FirstName, LastName, Pincode_R__c, Referrer_Account_CRN_Formula__c,REAP_ID__c,Referred_Booked_Account__c ,Salutation, Address_r1__c, Address_3_O__c, Country_R__c,
               Specify_Other_for_Zone_R__c , Specify_Other_for_City_R__c , Lead_Source_Detail__c ,Specify_Other_for_Suburb_R__c, Interested__c, 
               Status, City_R__c, Zone_RS__c, Address2_R__c, Address_3_R__c, Suburb_RS__c, Phone, Mobile__c, Email, 
               Date_Of_Birth__c, Designation__c, Company,Visiting_on_behalf_of__c, Lead_Company_Name__c, Budget_in_Lakhs__c, LeadSource, 
               LeadSource_Others__c, Owned_Car_Name__c, Club_Membership__c, 
               Project_Name__c, Landline__c, Pincode_o__c ,Purpose__c,Type_of_Accomodation__c,Channel_Partner__c, Corporate_Account__c,NumberOfEmployees,Ethinicity__c,  Marital_status__c, 
               Favorite_travelled_destination_Abroad__c ,Current_Home_ownership__c,Type_of_Home__c,Possession_desired_in__c, Favorite_travelled_destination_India__c,
               Occupation__c, Other_Occupation__c, Cluster_Name__c
               from Lead where Id =: lid AND Isconverted = false];  // CG Dev Team 30/09/2011 NumberOfEmployees for the wadala-specific form
               // CG Dev Team 19/10/2011 ethinicity, marital status fields for the world one form
               // CG Dev Team 23/11/2011 added Favorite_travelled_destination fields.
           ExistingMobile = l.Mobile__c;
           string temp = l.Type_of_Accomodation__c ;
           visitors=l.Visiting_on_behalf_of__c;
           occ=l.Occupation__c;
           if(temp != null && temp != '')
            accomTypes = temp.split(';');
            title = l.Name;
           if(l.LeadSource == 'Newspaper' || l.LeadSource == 'Newspaper' || l.LeadSource == 'Lodha contact center'|| l.LeadSource == 'Exhibition' || l.LeadSource == 'Magazine' || l.LeadSource == 'Radio' || l.LeadSource == 'TV' || l.LeadSource == 'Word of mouth' || l.LeadSource == 'Internal Referral' || l.LeadSource =='Hoarding' || l.LeadSource =='Direct Mailer' || l.LeadSource =='Web' || l.LeadSource =='Email' || l.LeadSource =='Channel Partner' || l.LeadSource =='Corporate Tie-Up' || l.LeadSource =='References')
                leadsource = l.LeadSource;
                
           if(l.LeadSource_Others__c != null && l.LeadSource_Others__c != '')
                leadsource = 'Others';
        }
        populateProjectQueueMap();         
    }
     public List<SelectOption> getItems() 
    {
        List<SelectOption> options = new List<SelectOption>();
        /* Added by CG Dev Team 22/09/2011
           Modified by CG Dev Team 19/10/2011
           Start:Changes to include Project specific values in the form   
        */ 
        if( ProjectName.equalsIgnoreCase('Lodha Fiorenza') ) // Modified by CG Dev Team 10/11/2011 Display Fiorenza-Project Specific form 
        {
            options.add(new SelectOption('2 BHK','2 Bed Residence'));
            options.add(new SelectOption('3 BHK','3 Bed Residence'));
            options.add(new SelectOption('4 BHK','4 Bed Residence'));
            options.add(new SelectOption('Penthouse / Duplex','Penthouse / Duplex'));
        }
        else if( ProjectName.equalsIgnoreCase('New Cuffe Parade') )// Modified by CG Dev Team 10/11/2011 Display Wadala-Project Specific form 
        {
            options.add(new SelectOption('2 BHK','2 Bed Residence'));
            options.add(new SelectOption('3 BHK','3 Bed Residence'));
            options.add(new SelectOption('4 BHK','4 Bed Residence'));                
            options.add(new SelectOption('Penthouse / Duplex','5 Bed Residence (Duplex)'));
        }            // CG Dev Team 19/10/2011 Added fields for the World Crest form
        else if( ProjectName.equalsIgnoreCase('World Crest') )   //  Modified by CG Dev Team 10/11/2011 Display World Crest-Project Specific form 
        {
            options.add(new SelectOption('3 bed world residence','3 Bed World Residence'));
            options.add(new SelectOption('4 bed world residence','4 Bed World Residence'));             
        }            // CG Dev Team 19/10/2011 Added fields for the World One form
        else if( ProjectName.equalsIgnoreCase('The Park') )   //  Modified by CG Dev Team 10/11/2011 Display World Crest-Project Specific form 
        {
            options.add(new SelectOption('2 BHK','2 BHK'));
            options.add(new SelectOption('3 BHK','3 BHK')); 
            options.add(new SelectOption('4 BHK','4 BHK'));             
        }         
        else        
        {
            options.add(new SelectOption('3 bed world residence','3 Bed World Residence'));
            options.add(new SelectOption('4 bed world residence','4 Bed World Residence')); 
            options.add(new SelectOption('World Villa','World Villa'));
            options.add(new SelectOption('World Mansion','World Mansion'));                     
        }
        // End:Changes to include Project specific values in the form          
        return options;
    }
     public List<SelectOption> getLeadSourceList() 
    {
        List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('Newspaper','Newspaper'));
            options.add(new SelectOption('Hoarding','Billboard'));
            options.add(new SelectOption('Web','Website'));
            options.add(new SelectOption('Emailer','E-mailer/Personal Invites'));
            options.add(new SelectOption('Channel Partner','Channel Partner'));
            options.add(new SelectOption('Corporate Tie-Up','Corporate Tie-Up'));
            options.add(new SelectOption('Others','Others'));
            return options;       
    }
   
    void populateProjectQueueMap()
    {
        //Get the mapping from custom setting of Project - Queue Mapping
        Map<String, ProjectQueueMapping__c> pqMap = ProjectQueueMapping__c.getAll();
        List<String> pqNames = new List<String>();
        pqNames.addAll( pqMap.keySet());
        for (String p : pqNames) 
        {
            ProjectQueueMapping__c pqObj = pqMap.get(p);
            ProjectQueueMap.put(pqObj.Name,pqObj.Queue__c);
        }                   
    }
    public PageReference submitLead()
    {
       errorMessage = '';
       try
       {
           string str = '';
           for(string s: accomTypes)
           {
              str = str + ';' + s;  
           }        
           l.Type_of_Accomodation__c = str;
           
           //SRCG-199
           l.Visiting_on_behalf_of__c=visitors;
           l.Occupation__c=occ;
           
           //populate lead source only if it is not empty
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
           l.Project_Name__c = pid;
           l.Status = 'Visit Done';
           l.Interested__c = 'Yes';
           l.FromVisitorForm__c = False;
           if(pid != null && pid != '' && ProjectQueueMap.containsKey(pid.trim()))  
           {               
                l.OwnerId = ProjectQueueMap.get(pid.trim());           
           }
           /*  Added by CG Dev Team 28/09/2011
               Start:Changes to Check Duplicates for current mobile number.
            */  
           List<Lead> LdList = new List<Lead>();
           LdList.add(l); 
           if(l.RecordTypeId == null)
               l.RecordTypeId = [Select r.SobjectType, r.Name, r.Id From RecordType r where r.SobjectType = 'Lead' and r.Name = 'Residential'].Id;
           if(ExistingMobile != null && ExistingMobile != l.Mobile__c)
           {
               FlagDuplicateLead.findDuplicates(LdList);
           }
           if(ExistingMobile == null)
               FlagDuplicateLead.findDuplicates(LdList);           
           if(l.Id != null && l.Id == l.Existing_Lead__c )
               l.Existing_Lead__c = null;
           LdList[0].FromVisitorForm__c = True;
           // End:Changes to Check Duplicates for current mobile number.
           upsert l;
       }
       
       catch(Exception e)
       {
           string errMsg = 'ERROR in upserting lead ' + e.getMessage();
          //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, errMsg,errMsg); 
          //ApexPages.addMessage(myMsg); 
           ApexPages.addMessages(e);
           System.debug(errMsg);
           return null;
       }
       /* Modified by CG Dev Team 22/09/2011 - added pid,retUrl to ThankYouPage */
       PageReference pageRef = new PageReference('/apex/ThankYouPage?pid='+pid+'&retUrl=/home/home.jsp');           
       return pageRef;
    }
    
     public List<SelectOption> getoptions() { 
        List<SelectOption>  options = new List<SelectOption>();
        options.add(new SelectOption('Salaried','Salaried'));
        options.add(new SelectOption('Self Employed','Self Employed'));
        options.add(new SelectOption('Professional','Professional'));
        options.add(new SelectOption('Retired','Retired'));
        options.add(new SelectOption('Housewife','Housewife'));
        options.add(new SelectOption('Student','Student'));
        //options.add(new SelectOption('Others','Others'));
        return options;
    }
 
}