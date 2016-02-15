/*********************************************************************************
Name:  LandingpageController()
Copyright © 2011  Lodha Group
======================================================
======================================================
Purpose:
-------
Web to lead Page
======================================================
======================================================
History
-------
VERSION    AUTHOR                DATE             DETAIL              
1.0 -   CG Dev Team          26/12/2011      INITIAL DEVELOPMENT  
*********************************************************************************/ 


public class LandingpageExtenstion {


    public String projectId {get;set;}
    public String CampaignName{get;set;}
    public String publisher{get;set;}
    public String leadEmail{get;set;}
    public string ErrorMessage {get;set;}
    public Boolean ReapId_success{get;set;}
    public String urlreapid{get;set;}
    public String reapId{get;set;}
    public String channelpartnernameId{get;set;}
    public String firstname{get;set;}
    public String lastname{get;set;}
    public String mobile{get;set;}
    public String CountryCode{get;set;}
    public String suburb{get;set;}
    public String city{get;set;}
    public String city1{get;set;}
    public String country{get;set;}
    public String occupation{get;set;}
    public String other_occupation{get;set;}  
    public String designation{get;set;} 
    public String company{get;set;} 
    public String budget{get;set;}
    public String carsowned{get;set;}
    public String destination_India{get;set;}
    public String destination_Abroad{get;set;}
    public String Ch_Name{get;set;}
    public String Ch_Contact{get;set;}
    public String Ch_Mobile{get;set;}
    public Boolean Valid{get;set;}
    public Channel_Partner__c ch_partner {get;set;}
    public Lead submitlead{get;set;}    
    public Boolean ReapForm {get;set;}
    public Boolean LeadForm {get;set;}
    public String OccupationValue{get;set;}
    public String Webbanner_Source{get;set;}
    public Boolean showconfirm {get;set;}   
    public String Pidnotfound{get;set;}
     
            
            /*
             * constructor
             */
    public LandingpageExtenstion(ApexPages.StandardController controller) 
    {

        Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=8');
        try{
            reapId = '';
            ReapForm = true;
            LeadForm = false;
            showconfirm=false;
            ReapId_success=true;

            submitlead=(Lead)controller.getRecord();
 
            projectId = ApexPages.currentPage().getParameters().get('projectid');
            CampaignName= ApexPages.currentPage().getParameters().get('campaign');
            publisher= ApexPages.currentPage().getParameters().get('publisher');
            urlreapid=ApexPages.currentPage().getParameters().get('urlreapid');
            Webbanner_Source=ApexPages.currentPage().getParameters().get('Webbanner_Source');
            

            if(projectId!=null)
            {
                List<Project_Name__c> projectList = [Select Record_Type__c,Project_Type__c,Type_of_Accomodation__c from Project_Name__c where id = :projectId];

                if(projectList==null)    
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Project Values Empty')); 

                }

            }else{

                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Project ID  not defined')); 
                Pidnotfound='Project ID  not defined';
                

            }

             this.country = 'India';
        }

        catch(Exception exp)
        {
             ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Project ID  not defined')); 

        }

    }
           

    /*******************************************************************
            Purpose     : To submit REAP ID 
            Parameters  : None
            Returns     : Null Pagereference to refresh the page
    ********************************************************************/

    public PageReference SubmitReapId()
        {

        try
        {
            if(projectId!=null &&projectId!='')
            {
                    if((reapid!='')&& (reapid.toUpperCase().startsWith('LD0'))&& (reapid.length() == 8))
                    {
                        ch_partner= [select id,name,Mobile_Phone__c,reap_Id__c,City__c,Contact_Person__c from Channel_Partner__c where reap_Id__c = :reapid limit 1];
                        if(ch_partner==null) 
                        {
                            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'ReapId not found');
                            ApexPages.addMessage(msg);
                        }
                        else
                        {
        
                            channelpartnernameId=ch_partner.id;
                            Ch_Name = ch_partner.Name;
                            Ch_Contact = ch_partner.Contact_person__c;
                            Ch_Mobile = ch_partner.Mobile_Phone__c;
                            ReapForm = false;                
                            LeadForm = true;
                            showconfirm=false;   
                                        
                        }
                    }
                    else
                    {
                        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Enter Reap Id'+reapid.toUpperCase()+reapid.length());
                        ApexPages.addMessage(msg);  
                        ErrorMessage = 'Please enter a valid REAP ID';
                           
                    }
                    
             }else{
             
                     ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Project ID  not defined')); 
                     Pidnotfound='Project ID is not defined';
             
             }





        }
        catch(Exception e)
        {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'ERROR OCCURED'+e);
            ErrorMessage = 'Please enter a valid REAP ID';
            ApexPages.addMessage(msg); 
            ReapId_success=false;    
            return null;   
 
        }
       
        return null; 
           
    }
    
    
    /*******************************************************************
            Purpose     : Validatation for other occupation
            Parameters  : None
            Returns     : Boolean value
    ********************************************************************/


     public Boolean isotherOccupation()
        {
                    if((occupation!= null && occupation!=''))
                    {
                        if(Occupation == 'Others' && (other_occupation == null && other_occupation == '' )){
                        
                          return false;
                          }
                       
                          return true;    
                    }
                        return false;
          }
          
          
       
    /*******************************************************************
            Purpose     : SaveLead
            Parameters  : None
            Returns     : Null Pagereference to refresh the page
    ********************************************************************/
    public PageReference saveLead() {  
    
        try{


                    submitlead.Project_Name__c = projectId;
                    submitlead.LeadSource = 'Channel Partner';
            

                  if((firstname!=null && firstname !='')
                     && (lastname!=null && lastname!='')
                     && (mobile!=null && mobile!='')
                     && (CountryCode!=null && CountryCode!='')
                     && (suburb!=null && suburb!='')
                     && (country!= null && country!= '')
                     && ((city != null && city != '') || ( city1 != null && city1 != 'None'))
                     && ((occupation!= null && occupation!=''))
                     && (company!= null && company!= '')
                     && (designation!= null && designation!= '')
                     && (budget!= null && budget!= '')
                     && (carsowned!= null && carsowned!= '')
                     && (destination_India!= null && destination_India!= '') 
                     && (destination_Abroad!= null && destination_Abroad!= '')
                     && isotherOccupation()
                    )
                    {
                    
                    submitlead.Occupation__c=occupation;
                    submitlead.Other_Occupation__c=other_occupation;
                 
                    
                    if(country!=null && country== 'India')
                    {
                        submitlead.City_R__c=city1;
                    
                    }else  
                          
                    {
                     submitlead.City_R__c=city;
                    }
                    
                     if(Webbanner_Source!=null && Webbanner_Source!='')
                        {
                            submitlead.WebBanner_Source__c=Webbanner_Source;
                        }
                            
                        submitlead.firstname=firstname;
                        submitlead.lastname=lastname;
                        submitlead.mobile__c=mobile;
                        submitlead.ISD_Code__c = CountryCode;
             
                        submitlead.Channel_Partner__c=channelpartnernameId;
            
                        submitlead.Country_R__c = country; 
                        submitlead.Address_3_R__c=suburb;
                        
                        
                       
                        submitlead.Lead_Company_Name__c=company;
                        submitlead.Designation__c=designation;
                        submitlead.Budget_in_Lakhs__c=Integer.valueof(budget);
                        submitlead.Owned_Car_Name__c=carsowned;
                        submitlead.Favorite_travelled_destination_India__c=destination_India;
                        submitlead.Favorite_travelled_destination_Abroad__c=destination_Abroad;
            
            
                        insert(submitlead);
                        LeadForm = false;
                        showconfirm=true;
                        reapform=false;
            
                    }
                    else{
                    
                            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Mandatory field values missing');
                            ApexPages.addMessage(msg);  
                            return null;
                    }
                            
            
            
            
            
                    }catch(System.DMLException e) { 
                        ApexPages.addMessages(e);
                        system.debug('ERRORUD'+e); 
                        return null;
            
                    }
                  
      
        return null;
       
      
        
        
        

    }

        /*******************************************************************
                Purpose     : Make null values
                Parameters  : None
                Returns     : Null Pagereference to refresh the page
        ********************************************************************/

    public PageReference savemorelead() { 


                        ReapForm = false;                
                        LeadForm = true;
                        showconfirm=false; 
                        submitlead=new lead();
                        firstname=null;
                        lastname=null;
                        mobile=null;
                        suburb=null;
                        city=null;
                        city1=null;
                        occupation=null;
                        other_occupation=null;
                        designation=null;
                        company=null;
                        budget=null;
                        carsowned=null;
                        destination_India=null;
                        destination_Abroad=null;
                
                        this.country = 'India';
                        return null;
    }
}