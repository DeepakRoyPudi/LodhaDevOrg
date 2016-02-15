public with sharing class AdminViewController {
    
    public String projId {get;set;}
    public String clusterId {get;set;}
    public Project_Name__c projName {get;set;}
    public Project_Image__c p {get;set;}
    public String pTrade {get;set;}
    public String pView {get;set;}
    public String wingId {get;set;}    
    public String projectName{get;set;}
    public String cluster{get;set;}
    public String wing{get;set;}
    public List<Project_Image__c> projImgList{get;set;}
    public Boolean noImg{get;set;}
    public Boolean noImg1{get;set;}
    public List<Project_Image__c> projImgList1{get;set;}
    
    
    Map<String, Map<String,Set<String>>> ProjectClusterList;
    
    public AdminViewController() {
        noImg1=true;
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
                if(WingSet == NULL){
                    WingSet = new Set<String>();
                }
                WingSet.add(bd1.Wing__c.toUpperCase());
                ClusterLst.put(bd1.Cluster__c.toUpperCase(), WingSet);
            }
            
            ProjectClusterList.put(bd1.Project__c.toUpperCase(), ClusterLst);
            
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
    
    public PageReference search() {        
    
        try{               
            noImg = false;
            if(projId != null && clusterId != null && wingId != null && projId != 'Select' && clusterId != 'Select' && wingId != 'Select'){                
                projectName = projId;
                cluster = clusterId;
                Wing = wingId;                  
                Project_Name__c proj = [SELECT Id, Name from Project_Name__c Where Name LIKE : projectName ];             
                projImgList = [SELECT Id, Cluster__c, Wing__c, Test_URL__c , Project_View__c, Trade__c, CreatedDate, Project_Name__c, Photo_Description__c, Image_Description__c, IsActive__c from Project_Image__c Where Project_Name__c =: proj.Id AND Cluster__c =: clusterId AND Wing__c =: WingId AND IsActive__c = true ORDER BY CreatedDate DESC LIMIT 8];   
                if(projImgList.size()==0){
                    noImg = true;   
                }                
                Project_Name__c proj1 = [SELECT Id, Name from Project_Name__c Where Name LIKE : projectName ]; 
                projImgList1 = [SELECT Id, Cluster__c, Wing__c,Test_URL__c , Project_View__c, Trade__c, CreatedDate, Project_Name__c,IsCommon__c,Photo_Description__c, Image_Description__c, IsActive__c from Project_Image__c Where Project_Name__c =: proj1.Id AND IsActive__c=true AND IsCommon__c=true ORDER BY CreatedDate DESC LIMIT 4];   
                if(projImgList.size()==0){
                    noImg = true; 
                    noImg1 = true;  
                }   
                else if(projImgList1.size()==0){
                    noImg = false; 
                    noImg1 = true;
                }else{
                    noImg = false;
                    noImg1 = false;
                }    
            
            }     
            else if(projId != null && projId != 'Select' && clusterId =='Select'&& wingId =='Select'){
                projectName = projId;
                cluster = clusterId;
                Wing = wingId;                 
                Project_Name__c proj1 = [SELECT Id, Name from Project_Name__c Where Name LIKE : projectName]; 
                projImgList1 = [SELECT Id, Cluster__c, Wing__c, Test_URL__c , Project_View__c, Trade__c, CreatedDate, Project_Name__c, Photo_Description__c, Image_Description__c, IsActive__c,IsCommon__c from Project_Image__c Where Project_Name__c =: proj1.Id AND IsActive__c = true AND IsCommon__c=true ORDER BY CreatedDate DESC LIMIT 4];   
                if(projImgList1.size()==0){
                    noImg1 = true;                 
                }
                else{
                    noImg1 = false;
                }
                noImg = true; 

            }
           
           if(projId == null || projId == 'Select'){
               ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please Select a Project'));
               noImg =true;
               noImg1=true;
               return null;
           } 
           else if((clusterId != null && clusterId !='Select') && (wingId == null || wingId =='Select')){
               ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please Select a Wing'));
               noImg =true;
               noImg1=true;
               return null;
            }

        
        }
        catch(Exception exp){      
        }        
        return null;
    }
}