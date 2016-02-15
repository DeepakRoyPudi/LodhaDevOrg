/*
Author - CG DEV
Class Name - ThankYouController 
Date Created - 23/09/2011
Purpose - Controller for ThankYouPage
*/

public class ThankYouController {
    
    public Boolean showFiorenzaForm {get;set;}      
    public Boolean showWadalaForm {get;set;}       
    public Boolean showWorldOneForm {get;set;} 
    public String retUrl {get;set;}

    public String ProjectName {get;set;}            // Added by CG Dev Team 10/11/2011 RenderValues for the Project-specific form
   // public String AssignedProjectName {get;set;}    // Added by CG Dev Team 10/11/2011 RenderValues for the Project-specific form
    public String pid {get;set;}
    
    public Boolean showTheParkForm {get;set;}      
    
    public ThankYouController()
    {
        try{
            pid = System.currentPageReference().getParameters().get('pid'); //Project Id        
            //AssignedProjectName = VisitorFormGlobalVariables__c.getInstance().ProjectName__c;  // Added by CG Dev Team 10/11/2011 RenderValues for the Project-specific form
            ProjectName = [select Name from Project_Name__c where id=:pid].name;              // Added by CG Dev Team 22/09/2011 RenderValues for the Project-specific form      

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
                    showTheParkForm = true;
                }
                else
                {
                      showWorldOneForm = true;    //Added By CG Dev Team 19/10/2011 RenderValues for the Project-specific form
                        //Can Be a default form
                }
        }
        catch (Exception e){
            system.debug('Generic Exception Caught : ' + e.getMessage());
        }
    }
    
            
    
}