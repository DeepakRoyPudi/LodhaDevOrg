public with sharing class EditNewProjectImageController {
    
     Map<String, Map<String,Set<String>>> ProjectClusterList;
    public String projId {get;set;}
    public Project_Name__c projName {get;set;}
    public String clusterId {get;set;}
    public Project_Image__c p {get;set;}
    public String pTrade {get;set;}
    public String pView {get;set;}
    public String wingId {get;set;}
    public Boolean  IsCommon {get;set;}
    public Boolean DisCluster {get;set;}
    public Boolean Diswing {get;set;}
    
    public EditNewProjectImageController(ApexPages.StandardController controller) {

        Id pId = ApexPages.currentPage().getParameters().get('id');        
        if(pId != Null){        
            p = [Select Id,IsCommon__c, Project_Name__c, Cluster__c, Wing__c, Trade__c, Project_View__c, Photo_Description__c, IsActive__c from Project_Image__c Where ID=: pId];
            
            projName = [Select Id, Name from Project_Name__c Where id =: p.Project_Name__c];
            ProjId = projName.Name.toUpperCase();
            IsCommon=p.IsCommon__c;
            if(p.IsCommon__c==false){
                clusterId = p.Cluster__c.toUpperCase();
                wingId = p.Wing__c.toUpperCase();
                DisCluster=false;
                Diswing=false;
            }   
            if(p.IsCommon__c==true){
                clusterId = 'Select';
                wingId = 'Select';
                DisCluster=true;
                Diswing=true;
            }        
            List<Booking_Details__c> bookDet = [Select Id, Project__c, Cluster__c, Wing__c from Booking_details__c Where Project__c != NULL AND Cluster__c != NULL AND Wing__c != NULL AND Account__c != NULL AND Account__r.Status__c != 'Cancelled'];
            ProjectClusterList = new Map<String, Map<String,Set<String>>>();
            Map<String, Set<String>> ClusterLst = new Map<String, Set<String>>();
            Set<String> WingSet = new Set<String>();
            for(Booking_Details__c bd1: bookDet){                
                ClusterLst = ProjectClusterList.get(bd1.Project__c.toUpperCase());                
                if(ClusterLst == NULL){
                    ClusterLst = new Map<String, Set<String>>();
                    WingSet = new Set<String>();
                    WingSet.add(bd1.Wing__c.toUpperCase());
                    ClusterLst.put(bd1.Cluster__c.toUpperCase(), WingSet);                
                }
                else{
                    WingSet = ClusterLst.get(bd1.Cluster__c.toUpperCase());
                    if(WingSet == NULL)
                    {
                        WingSet = new Set<String>();
                    }
                    WingSet.add(bd1.Wing__c.toUpperCase());
                    ClusterLst.put(bd1.Cluster__c.toUpperCase(), WingSet);
                }                
                ProjectClusterList.put(bd1.Project__c.toUpperCase(), ClusterLst);                
            }   
        }        
    } 
 
    Public void myaction(){
        if(IsCommon){
            Diswing =true;
            DisCluster=true;
            clusterId='select';
            wingId ='select';
        }
        else if(IsCommon==false){
            Diswing =false;
            DisCluster=false;
        }    
    }
    
    public List<SelectOption> getProjList(){
    
        List<SelectOption> projList = new List<SelectOption>();
        List<String> projNames = new List<String>();
        for(String ProjectName : ProjectClusterList.KeySet()){
            projNames.add(ProjectName);
        }
        projNames.sort();
        projList.add(new SelectOption('Select', 'Please Select'));        
        for(String Project : projNames){
            projList.add(new SelectOption(Project, Project));
        }
        return projList;
    }
   
    public List<SelectOption> getClusterFilter() {

        List<SelectOption> clusterList = new List<SelectOption>();
        List<String> clusterNames = new List<String>();
        clusterList.add(new SelectOption('Select', 'Please Select'));        
        Map<String, Set<String>> selectClusterList = new Map<String, Set<String>>();
        selectClusterList = ProjectClusterList.get(projId);
        if(selectClusterList != NULL){
            for(String cluster: selectClusterList.KeySet()){
                clusterNames.add(cluster);
            }
            clusterNames.sort();
            for(String cluster: clusterNames){
                clusterList.add(new SelectOption(cluster, cluster));
            }
        }
        return clusterList;
    }

    
    public List<SelectOption> getWingFilter() {
   
        List<SelectOption> wingList = new List<SelectOption>();
        List<String> wingNames = new List<String>();
        wingList.add(new SelectOption('Select', 'Please Select'));
        Map<String, Set<String>> selectClusterList2 = new Map<String, Set<String>>();
        selectClusterList2 = ProjectClusterList.get(projId);        
        Set<String> SelectWingSet = new Set<String>();
        if(selectClusterList2 != NULL){
            SelectWingSet = selectClusterList2.get(clusterId);
            if(SelectWingSet != NULL){
                for(String wing: SelectWingSet){
                    wingNames.add(wing.toUpperCase());
                }
                wingNames.sort();
                for(String wing: wingNames){
                    wingList.add(new SelectOption(wing.toUpperCase(), wing.toUpperCase()));
                }
                
            }
        }
        return wingList;
    }
    
    public PageReference save() {
    
        System.debug('@@@ : '+ projId + clusterId + wingId);
        try{
            if(projId != null && projId != 'Select'){
                System.debug('@@ projId = '+projId);
                Id pNameID = [Select Id, Name from Project_Name__c where Name = : projId Limit 1].Id;                    
                //p.Project_Name__c = pNameId;
                if(IsCommon ==false && clusterId != null && wingId != null && clusterId != 'Select' && wingId != 'Select'){
                    p.Cluster__c = clusterId;
                    p.Wing__c = wingId;  
                    p.IsCommon__c=IsCommon;            
                    update p;        
                    PageReference pageRef = new PageReference('/' + p.id);
                    pageRef.setRedirect(true);
                    return pageRef;    
                }
                else if(IsCommon ==true){
                    p.Cluster__c = '';
                    p.Wing__c ='';   
                    p.IsCommon__c=IsCommon;            
                    update p;        
                    PageReference pageRef = new PageReference('/' + p.id);
                    pageRef.setRedirect(true);
                    return pageRef;    
                }
           
            }
        
       }
       catch(Exception e){
            System.debug(e);
       }
         
        if (projId == 'Select'){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please Select a Project'));
            return null;
        }else if (clusterId == 'Select'&& IsCommon ==false){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please Select a Cluster'));
            return null;
        }else if(wingId == 'Select'&& IsCommon ==false){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please select a Wing'));
            return null;
        }
        else
        {
            return null;
        }
        
    }
    
   public PageReference cancel() {
        //PageReference cancel = new PageReference('/a1H/o');
        PageReference cancel = new PageReference('/a0x/o');
            return cancel;
    }

}