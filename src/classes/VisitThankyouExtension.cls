public class VisitThankyouExtension {

    public List<VisitorFormSettings__c> UserMapList {get;set;}
    public VisitorFormSettings__c UserMap {get;set;}    
    public Project_Name__c Project {get;set;}
    public Boolean UserAccess{get;set;}    
    public String Css {get;set;}     

    public VisitThankyouExtension(){


            UserMapList = new List<VisitorFormSettings__c>();
            UserMapList = [select RecordType.Name,id,Name,ResidenceType__c ,Indulgences__c ,SourceHeader__c ,BudgetTitle__c ,WorkInfo__c ,ContactInfo__c ,OpportunityCSS__c,ThankYouCSS__c,LeadCSS__c,AccountCSS__c,User__c,LeadSource__c,Personal_Details__c,Project_name__c,Default__c,CSS_URL__c,Family__c,Preferences__c from VisitorFormSettings__c where User__c =:UserInfo.getUserId() and RecordType.Name = 'Confirmation' and Default__c=true];
            if(UserMapList.isEmpty())
            {
                //Redirect to standard page.
                UserAccess=false;
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'User is not Authorised to Access this Project');
                ApexPages.addMessage(msg);
            }
            else
            {
                UserAccess=true;
                UserMap = new VisitorFormSettings__c(); 
                 
                UserMap = UserMapList[0];
              
                
                    if(UserMap.Project_Name__c!= null)
                    {
                        Project = new Project_Name__c();                  
                        Project = [select Id,Name,Project_Type__c,Type_of_Accomodation__c,Record_Type__c from Project_Name__c where id=:UserMap.Project_Name__c];
                    }
               
               
            }
    }


    public PageReference redirectToHomePage() {
        PageReference homePage = new PageReference('/home/home.jsp');
        homePage.getParameters().put('nooverride','1');        
        homePage.setredirect(true);
        return homePage;
    }
    
    public static testMethod void testVisitThankyouExtension() 
     {     
        User u = [select id from user where Profile.name = 'System Administrator' and isActive = true limit 1];
        system.runas(u){

        Id recType = [Select r.SobjectType, r.Name, r.Id From RecordType r where r.SobjectType = 'VisitorFormSettings__c' and r.Name = 'Confirmation'].Id;
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
        
        VisitThankyouExtension v = new VisitThankyouExtension();
        v.redirectToHomePage();
        }    
    }
}