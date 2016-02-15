global class BatchProjectImage implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
    global BatchProjectImage(){

    }

    global Database.QueryLocator start(Database.BatchableContext BC){
       // date todays = date.parse(system.now().format('dd/MM/yyyy'));
        String query = 'SELECT CLuster__c,Id,Project__c,Wing__c FROM Booking_Details__c';
        system.debug('querys:'+query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Booking_Details__c> scope){
        
        Map<String, ID> projectMap = new Map<String, ID>();        
        for(Project_Name__c cc: [Select Name, Id From Project_Name__c]){
            String pname=cc.Name;
            pname=pname.toUpperCase();
            projectMap.put(pname, cc.Id);
        }
        
        Map<String, ID> imageMap = new Map<String, ID>();        
        for(project_Image__c cc: [Select Name,Project_Combination__c ,Id From project_Image__c]){
            imageMap.put(cc.Project_Combination__c, cc.Id);
        }
        
        List<project_Image__c> pList = new List<project_Image__c>();
        Map<String, project_Image__c> ProjectImageMap = new Map<String, project_Image__c>(); 
        List<ID> bookIds = new List<ID>();
        Set<String> distinctLastnames = new Set<String>();
       
        if(scope.size() > 0){ 
            for(Booking_Details__c bd:scope){
                
                    if(bd.Cluster__c != null && bd.Wing__c != null && projectMap.get(bd.Project__c.toUpperCase())!= null){
                        project_Image__c p = new project_Image__c();
                        String ppname=bd.Project__c;
                        ppname=ppname.toUpperCase();
                        //System.debug('Project ID= '+ projectMap.get(bd.Project__c));                  
                        p.Project_Name__c= projectMap.get(ppname);
                        p.Cluster__c = bd.Cluster__c;
                        p.Wing__c = bd.Wing__c;
                        String projcomb = ppname + bd.Cluster__c + bd.Wing__c;
                        //p.Project_Combination__c = ppname + bd.Cluster__c + bd.Wing__c;
                        if(!imageMap.containsKey(projcomb.toUpperCase())){
                        ProjectImageMap.put(projcomb, p);
                        }
                        
                    }
            }
            if(ProjectImageMap.size()>0)
            insert ProjectImageMap.Values();
        }
    }

    global void finish(Database.BatchableContext BC){
        // send batch execution email;      
    }
}