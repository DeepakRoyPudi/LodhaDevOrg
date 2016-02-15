public class AccountRedirectExtensions 
{

    string profileId;
    string projectId;
    string retURL ;
    string recordType ;
    string obj;
    string aid;
    
    public AccountRedirectExtensions (ApexPages.StandardController controller) 
    {
        VisitorFormGlobalVariables__c gv = VisitorFormGlobalVariables__c.getInstance();      
        profileId= gv.ProfileId__c;  
        //get project id from custom setting - later this will come from project selection VF Page   
        projectId = gv.ProjectId__c;        
        try
        {
            aid = System.currentPageReference().getParameters().get('id');               
            retURL = System.currentPageReference().getParameters().get('retURL');        
            recordType = System.currentPageReference().getParameters().get('RecordType');
            obj = System.currentPageReference().getParameters().get('ent');               
        }
        catch(Exception e)
        {
            //ApexPage.
        }      
    }   
    public PageReference pageredirect()
    {
        string url = ''; 
        string userprofileId = UserInfo.getProfileId();
        
        if(userprofileId.equalsIgnoreCase(profileId))
        {
            if(aid != null && aid != '')               
                url = '/apex/AccountPage?id=' + aid + '&pid=' + projectId ;   
            PageReference pageRef = new PageReference(url);
            pageRef.setRedirect(true);
            return pageRef;         
        }
        else
        {
            if(aid != null && aid != '')                
                url = '/' + aid + '/e?retURL=' + retURL + '&nooverride=1';
            PageReference pageRef = new PageReference(url);
            pageRef.setRedirect(true);
            return pageRef;  
        }        
    }
 
}