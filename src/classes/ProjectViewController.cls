public with sharing class ProjectViewController {
    
    public String projectName {get;set;}
    public String cluster {get;set;}
    public String wing {get;set;}
    public List<Project_Image__c> projImgList {get;set;}
    public Boolean noImg {get;set;}    
    public Boolean noImgcommon {get;set;}
    public List<Project_Image__c> CommonprojImgList {get;set;}    
    
    public ProjectViewController () {
    
        try{              
             
            User u = [SELECT Id, Name, username,Accountid from User Where id =: userinfo.getUserId()];            
            Account MyAccount = [SELECT Id, Name, Project_Name__c from Account Where id=: u.Accountid];    
            //Account MyAccount = [SELECT Id, Name, Project_Name__c from Account Where id='001L0000004CevB'];        
            List<Booking_Details__c> BookDetailList = [SELECT Id, CLuster__c, Wing__c, Account__c from Booking_Details__c Where Account__c =: MyAccount.Id limit 1];
            Booking_Details__c BookDetail=BookDetailList[0];
            projectName = MyAccount.Project_Name__c;
            cluster = BookDetail.CLuster__c;
            Wing = BookDetail.Wing__c; 
            Project_Name__c project = [SELECT Id, Name from Project_Name__c Where Name LIKE : projectName ];             
            projImgList= [SELECT Id, Cluster__c, Wing__c,Test_URL__c , Project_View__c, Trade__c, CreatedDate, Project_Name__c, Photo_Description__c,IsCommon__c,Image_Description__c, IsActive__c from Project_Image__c Where Project_Name__c =: project.Id AND Cluster__c =: BookDetail.CLuster__c AND Wing__c =: BookDetail.Wing__c AND IsActive__c=true ORDER BY CreatedDate DESC LIMIT 8];   
            CommonprojImgList= [SELECT Id, Cluster__c, Wing__c,Test_URL__c , Project_View__c, Trade__c, CreatedDate, Project_Name__c,IsCommon__c,Photo_Description__c, Image_Description__c, IsActive__c from Project_Image__c Where Project_Name__c =: project.Id AND IsActive__c=true AND IsCommon__c=true ORDER BY CreatedDate DESC LIMIT 4];   
            if(projImgList.size()==0){
                noImg = true; 
                noImgcommon = true;  
            }   
            else if(CommonprojImgList.size()==0){
                noImg = false; 
                noImgcommon = true;
            }else{
                noImg = false; 
            }    
                  
        }        
        catch(Exception exp){

        }
    }      
}