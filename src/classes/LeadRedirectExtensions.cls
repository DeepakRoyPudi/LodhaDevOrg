public class LeadRedirectExtensions {

    string profileId;
    string projectId;
    string retURL ;
    string recordType ;
    string obj;
    string lid;

    
    public LeadRedirectExtensions (ApexPages.StandardController controller) 
    {
        VisitorFormGlobalVariables__c gv = VisitorFormGlobalVariables__c.getInstance();      
        profileId= gv.ProfileId__c;  
        //get project id from custom setting - later this will come from project selection VF Page   
        projectId = gv.ProjectId__c; 
        try
        {
            lid = System.currentPageReference().getParameters().get('id');               
            retURL = System.currentPageReference().getParameters().get('retURL');        
            recordType = System.currentPageReference().getParameters().get('RecordType');
            obj = System.currentPageReference().getParameters().get('ent');               
        }
        catch(Exception e)
        {
            
        }      
    }   
    public PageReference pageredirect()
    {
        string url = ''; 
        string userprofileId = UserInfo.getProfileId();
        
        if(userprofileId.equalsIgnoreCase(profileId))
        {
            if(lid == null || lid == '')//New Lead
                url = '/apex/LeadPage?pid=' + projectId ;
            else
                url = '/apex/LeadPage?id=' + lid + '&pid=' + projectId ;   
            PageReference pageRef = new PageReference(url);
            pageRef.setRedirect(true);
            return pageRef;         
        }
        else
        {
            if(lid == null || lid == '')//New Lead
            {
                if(recordType != null && recordType != '')
                    url = '/00Q/e?retURL='+ retURL + '&RecordType=' + recordType + '&ent=' + obj + '&nooverride=1';
                else
                    url = '/00Q/e?retURL='+ retURL + '&ent=' + obj + '&nooverride=1';
            }
            else //Edit
                url = '/' + lid + '/e?retURL=' + retURL + '&nooverride=1';
            PageReference pageRef = new PageReference(url);
            pageRef.setRedirect(true);
            return pageRef;  
        }        
    }   
}