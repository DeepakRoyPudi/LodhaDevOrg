public class OpportunityExtensions {

    string pid;
    string aid;
    string oid;
    public Opportunity o {get;set;}
    public string[] accomTypes{get;set;}
    public string title{get;set;} 
    public string leadsource{get;set;}      
    
    public Boolean showFiorenzaForm {get;set;}      // Added by CG Dev Team 22/09/2011 RenderValues for the Project-specific form
    public Boolean showWadalaForm {get;set;}        // Added By CG Dev Team 22/09/2011 RenderValues for the Project-specific form
    public Boolean showWorldOneForm {get;set;}      // Added By CG Dev Team 19/10/2011 RenderValues for the Project-specific form    
    public String ProjectName {get;set;}            // Added By CG Dev Team 22/09/2011 RenderValues for the Project-specific form
//    public String AssignedProjectName {get;set;}    // Added by CG Dev Team 10/11/2011 RenderValues for the Project-specific form    


    //SRCG-199    
    public Boolean showTheParkForm {get;set;} 
    Public string visitors{get;set;}
    
    
    public OpportunityExtensions(ApexPages.StandardController controller) 
    {
        

        try
        {
            oid = System.currentPageReference().getParameters().get('id');
            aid = System.currentPageReference().getParameters().get('aid'); //Account Id
            pid = System.currentPageReference().getParameters().get('pid'); //Project Id 
                
                
                /* Added by CG Dev Team 22/09/2011
                   Start:Changes to include Wadala Project form
                */  
                showFiorenzaForm  =false;
                showWadalaForm = false;
                showWorldOneForm = false;
                
                //AssignedProjectName = VisitorFormGlobalVariables__c.getInstance().ProjectName__c;  // Added by CG Dev Team 10/11/2011 RenderValues for the Project-specific form                
                ProjectName = [select Name from Project_Name__c where id=:pid].name;// Get Name from the ProjectId  
                
                if(ProjectName.equalsIgnoreCase('Lodha Fiorenza'))
                {
                    showFiorenzaForm = true;
                }
                else if(ProjectName.equalsIgnoreCase('New Cuffe Parade'))
                {
                    showWadalaForm = true;
                }
                else if(ProjectName.equalsIgnoreCase('The Park'))
                {
                    showTheParkForm= true;
                }
                else
                {
                      showWorldOneForm = true;    //Added By CG Dev Team 19/10/2011 RenderValues for the Project-specific form
                        //Can Be a default form
                }
            
               // End:Changes to include Wadala Project form
                
            accomTypes = new String[] {};
             leadsource = '';

            if(oid == null) //Create New opportunity
            {
                Account a = [Select Id, Name from Account where id =: aid];
                Project_Name__c p = [Select Id, Name from Project_Name__c where id =: pid];
                o =  new Opportunity();
                o.AccountId = aid;
                o.Project_Name__c = pid; 
                o.Name = a.Name + '-' + p.Name; 
                o.StageName = 'Qualification';
                o.CloseDate = System.today() + 45;
                title = 'New Opportunity';
                system.debug('Came here null');
                
            }
            else //Update exsiting Opportunity
            {
                o = [Select Id ,Name, Budgeted_Price__c,CP_Walk_in_REAP_ID__c,Walk_in_Referred_Booked_Account_CRN__c ,Possession_desired_in__c,Lead_Source_Details__c,Referred_Booked_Account__c,Visiting_on_behalf_of__c,LeadSource, Walk_in_Source__c, Walk_in_Channel_Partner__c, Walk_in_Corporate_Account__c, Walk_in_Referred_Booked_Account__c,Walk_in_Source_Details__c, Type_of_Accomodation__c, Channel_Partner__c, Corporate_Account__c, StageName, Total_Consideration_Value__c, Booking_Date__c, Cluster_Name__c from Opportunity where Id =: oid ];  // Modified by CG Dev Team 20/10/2011
                title = o.Name;
                string temp = o.Type_of_Accomodation__c ;
                if(temp != null && temp != '')
                accomTypes = temp.split(';'); 
                 
                visitors=o.Visiting_on_behalf_of__c;
                
                if(o.Walk_in_Source__c == 'Newspaper' || o.Walk_in_Source__c == 'Lodha contact center'|| o.Walk_in_Source__c == 'Exhibition' || o.Walk_in_Source__c == 'Magazine' || o.Walk_in_Source__c == 'Radio' || o.Walk_in_Source__c == 'TV' || o.Walk_in_Source__c == 'Word of mouth' || o.Walk_in_Source__c =='Others' || o.Walk_in_Source__c == 'Referred by Lodha booked customer' || o.Walk_in_Source__c =='Hoarding' || o.Walk_in_Source__c =='Direct Mailer' || o.Walk_in_Source__c =='Web' || o.Walk_in_Source__c =='Email' || o.Walk_in_Source__c =='Channel Partner' || o.Walk_in_Source__c =='Corporate Tie-Up' || o.Walk_in_Source__c =='References')
                {
                    leadsource = o.Walk_in_Source__c;                                          // Modified by CG Dev Team 14/10/2011
                }

               if((o.StageName == 'Closed Won' || o.StageName == 'Cancelled')&&(o.Total_Consideration_Value__c != '' || o.Total_Consideration_Value__c != null) && o.Booking_Date__c != null)
               {
                Account a = [Select Id, Name from Account where id =: aid];
                Project_Name__c p = [Select Id, Name from Project_Name__c where id =: pid];
                o =  new Opportunity();
                o.AccountId = aid;
                o.Project_Name__c = pid; 
                o.Name = a.Name + '-' + p.Name; 
                o.StageName = 'Qualification';
                o.CloseDate = System.today() + 45;
                title = 'New Opportunity';
                system.debug('Came here null');   
                leadsource  = '';
                accomTypes.clear();
                title  = '';         
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
        /* Added by CG Dev Team 22/09/2011
           Modified by CG Dev Team 19/10/2011
           Start:Changes to include Project specific values in the form   
        */  
        if( ProjectName.equalsIgnoreCase('Lodha Fiorenza') )// Added by CG Dev Team 10/11/2011 RenderValues for the Project-specific form
        {
            options.add(new SelectOption('2 BHK','2 Bed Residence'));
            options.add(new SelectOption('3 BHK','3 Bed Residence'));
            options.add(new SelectOption('4 BHK','4 Bed Residence'));        
            options.add(new SelectOption('Penthouse / Duplex','Penthouse / Duplex'));
        }
        else if ( ProjectName.equalsIgnoreCase('New Cuffe Parade') )// Added by CG Dev Team 10/11/2011 RenderValues for the Project-specific form
        {
            options.add(new SelectOption('2 BHK','2 Bed Residence'));
            options.add(new SelectOption('3 BHK','3 Bed Residence'));
            options.add(new SelectOption('4 BHK','4 Bed Residence'));            
            options.add(new SelectOption('Penthouse / Duplex','5 Bed Residence (Duplex)'));
        }            // CG Dev Team 19/10/2011 Added fields for the World Crest form
        else if( ProjectName.equalsIgnoreCase('World Crest') )   // Added by CG Dev Team 10/11/2011 RenderValues for the Project-specific form     
        {
            options.add(new SelectOption('3 bed world residence','3 Bed World Residence'));
            options.add(new SelectOption('4 bed world residence','4 Bed World Residence'));             
        }
        else if( ProjectName.equalsIgnoreCase('The Park') )   // Added by CG Dev Team 10/11/2011 RenderValues for the Project-specific form     
        {
            options.add(new SelectOption('2 BHK','2 BHK'));
            options.add(new SelectOption('3 BHK','3 BHK'));
            options.add(new SelectOption('4 BHK','4 BHK'));              
        }
        else        // CG Dev Team 19/10/2011 Added fields for the World One form
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
       public PageReference goBack() 
    {
        string url = '/apex/AccountPage?id=' + aid + '&pid=' + pid;
         PageReference pageRef = new PageReference(url);           
      return pageRef;     
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
               o.Visiting_on_behalf_of__c=visitors;

               if(leadsource != '' && leadsource != null)
               {
                   o.Walk_in_Source__c = leadsource;        // Modified by CG Dev Team 14/10/2011
               }

               upsert o;
               // End:Changes to include Project specific values in the form 
        }       
       catch(Exception e)
       {
           string errMsg = 'ERROR in upserting Opportunity ' + e.getMessage();
           //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, errMsg,errMsg); 
           //ApexPages.addMessage(myMsg); 
           System.debug(errMsg);
           return null;
       }
     
       /* Modified by CG Dev Team 22/09/2011 - added pid,retUrl to ThankYouPage */    
      PageReference pageRef = new PageReference('/apex/ThankYouPage?pid='+pid+'&retUrl=/'+aid);  
      return pageRef;
    }
 
}