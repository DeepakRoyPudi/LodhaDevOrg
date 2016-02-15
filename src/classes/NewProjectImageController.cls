/*
* Description : Apex Controller Class for 'NewProjectImage' visualforce page
*
*   Version        Date                Author                Description
*    2.0                             Deepak Pudi       Code Changes for Lodha Supremus II
*    3.0          9/12/2014          Deepak Pudi        IT HD 62284 - Code RollBack
*/
public  with sharing class NewProjectImageController {
    
    Map<String, Map<String,Set<String>>> ProjectClusterList;
    public String projId {get;set;}
    public String clusterId {get;set;}
    public Project_Name__c projName {get;set;}
    public Project_Image__c p {get;set;}
    public String pTrade {get;set;}
    public String pView {get;set;}
    public String wingId {get;set;}
    public Boolean IsCommon{get;set;}
    public Boolean Diswing {get;set;} 
    public Boolean DisCluster{get;set;}    
    public NewProjectImageController (ApexPages.StandardController controller) {
    	ProjId = '';
        
        Id pId = ApexPages.currentPage().getParameters().get('id');
        System.debug('@@@ pid='+ pid);
        Diswing =false;
        DisCluster=false;
        List<Booking_Details__c> bookDet = [Select Id, Project__c, Cluster__c, Wing__c from Booking_details__c Where Project__c != NULL AND Cluster__c != NULL AND Wing__c != NULL AND Account__c != NULL AND Account__r.Status__c != 'Cancelled'];
        System.debug('=========== id ' + pId);
        if(pId != null){
            p = [Select Id, Project_Name__c, Cluster__c, Wing__c, Trade__c, Project_View__c, Photo_Description__c, IsActive__c,IsCommon__c from Project_Image__c Where ID=: pId];
            projName = [Select Id, Name from Project_Name__c Where id =: p.Project_Name__c];
            ProjId = projName.Name.toUpperCase();
            if(p.Cluster__c !='' && p.Cluster__c !=null && p.Wing__c != null && p.Wing__c!=''){
                clusterId = p.Cluster__c.toUpperCase();
                wingId = p.Wing__c.toUpperCase();
            }
            IsCommon=p.IsCommon__c;
            if(IsCommon==true){
                Diswing =true;
                DisCluster=true;
            }        
        }
        else{
           p = new Project_Image__c();
        }
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
    Public void myaction(){
        system.debug('myaction'+IsCommon);
        if(IsCommon){
            system.debug('if '+IsCommon);
            Diswing =true;
            DisCluster=true;
            clusterId='select';
            wingId ='select';
        }
        else if(IsCommon==false){
            system.debug('else if '+IsCommon);
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
        	/*if(Project.equalsIgnoreCase('LODHA SUPREMUS II')){
        		projList.add(new SelectOption('Lodha Supremus 2', Project));
        		continue;
        	}*/
            	
            projList.add(new SelectOption(Project, Project));
        }
        return projList;
    }
    
    public List<SelectOption> getClusterFilter(){

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
    /*changes for LODHA SUPREMUS II  Deepak Pudi */
    /*3.0 Deepak Pudi*/
    public PageReference save() {
    	/*if(projId.equalsIgnoreCase('LODHA SUPREMUS II')){
          projId = 'Lodha Supremus 2'; 
        }*/
      Project_Image__c pRec = new Project_Image__c();
        try{
        	System.debug('=========== Project Id ' + projId);
        	System.debug('=========== clusterId ' + clusterId);
        	System.debug('=========== wingId ' + wingId);
            if(projId != null && clusterId != null && wingId != null && projId != 'Select' && clusterId != 'Select' && wingId != 'Select' && IsCommon ==false){
                Id pNameID = [Select Id, Name from Project_Name__c where Name = : projId Limit 1].Id;
                pRec.Project_Name__c = pNameId;
                pRec.Cluster__c = clusterId;
                pRec.Wing__c = wingId;
                pRec.Trade__c = p.Trade__c;
                pRec.Project_View__c = p.Project_View__c;
                pRec.Photo_Description__c = p.Photo_Description__c;
                pRec.IsActive__c = p.IsActive__c;
                pRec.IsCommon__c=false;
                insert pRec;                
                PageReference pageRef = new PageReference('/' + pRec.id);
                pageRef.setRedirect(true);
                return pageRef;            
            }
            else if(projId != null && projId != 'Select' && IsCommon ==true){               
                Id pNameID = [Select Id, Name from Project_Name__c where Name = : projId Limit 1].Id;
                pRec.Project_Name__c = pNameId;
                pRec.Cluster__c = '';
                pRec.Wing__c = '';
                pRec.Trade__c = p.Trade__c;
                pRec.Project_View__c = p.Project_View__c;
                pRec.Photo_Description__c = p.Photo_Description__c;
                pRec.IsActive__c = p.IsActive__c;
                pRec.IsCommon__c=true;
                insert pRec;                
                PageReference pageRef = new PageReference('/' + pRec.id);
                pageRef.setRedirect(true);
                return pageRef;
            }
        
        }
        catch(Exception e){            
        }
                 
        if (projId == 'Select'){            
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please Select a Project'));
            return null;
        }
        else if (clusterId == 'Select'&& IsCommon ==false){           
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please Select a Cluster'));
            return null;
        }
        else if(wingId == 'Select'&& IsCommon ==false){            
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please select a Wing'));
            return null;
        }
        else{
            return null;
        }
        
    }
    
   public PageReference cancel() {
        //PageReference cancel = new PageReference('/a1H/o');
        PageReference cancel = new PageReference('/a0x/o');
            return cancel;
    }

}