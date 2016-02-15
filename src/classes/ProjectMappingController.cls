/*********************************************************************************
Name:  ProjectMappingController ()
Copyright © 2012  Lodha Group
======================================================
======================================================
Purpose:
-------
interface to store the accomodation and lead source label and values for vistor form generalisation
======================================================
======================================================
History
-------
VERSION    AUTHOR                DATE             DETAIL              
1.0 -   CG Dev Team          14/03/2012      INITIAL DEVELOPMENT  
*********************************************************************************/ 
public with sharing class ProjectMappingController {

    Project_Name__c project {get;set;}
    public List<String> leadSourceList {get;set;}    
    public List<String> accomodationList {get;set;}        
    public List<LeadSourceMap> leadSourceMapList {get;set;}    
    public List<AccomodationMap> accomodationMapList {get;set;}        
    public boolean isAccomodationEmpty {get;set;}
    
    public ProjectMappingController (ApexPages.StandardController controller) {
     try{
         project = (Project_Name__c) controller.getRecord();
         project =[select Type_of_accomodation__c,accomodationMap__c, leadSourceMap__c ,Record_Type__c ,Id from Project_Name__c where Id=:project.Id ];
         if(project.Record_Type__c != 'Residential'){
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, 'Non Residential Project');
                ApexPages.addMessage(msg);         
         }
         if(project.Type_of_accomodation__c == null){
            isAccomodationEmpty = true;
         }
         //else{
             leadSourceList = new List<String>();
             accomodationList = new List<String>();     
             leadSourceMapList = new List<LeadSourceMap>();
             accomodationMapList = new List<AccomodationMap>();      
             populateLeadMap();
             populateAccomodationMap();         
        //}
         
    }catch(exception e){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, 'Error');
            ApexPages.addMessage(msg); 
    }
        
    }

    public void populateLeadMap(){
        leadSourceList = getPicklistDescribe('VisitorFormSettings__c','LeadSource__c');
        String[] leadSourceMappedList;
        set<String> addedleadSource = new set<String>();
        if(project.leadSourceMap__c !=null){
            leadSourceMappedList = project.leadSourceMap__c.split(';');
        }
        for(String leadSourceValue:leadSourceList){
            if(leadSourceMappedList!=null){
                for(String leadSourceMapped:leadSourceMappedList ){
                    String[] leadSourceMappedValue = leadSourceMapped.split(',');
                    if(leadSourceMappedValue[0] == leadSourceValue && !addedleadSource.contains(leadSourceMappedValue[0])){
                        leadSourceMapList.add(new LeadSourceMap(leadSourceMappedValue[1],leadSourceValue )); 
                        addedleadSource.add(leadSourceMappedValue[0]);                     
                    }
                    else{
                        //leadSourceMapList.add(new LeadSourceMap('',leadSourceValue ));                     
                    }   
                }
            }
            else{
                leadSourceMapList.add(new LeadSourceMap(leadSourceValue ,leadSourceValue ));             
            }
        }
    }
    
    public void populateAccomodationMap(){
        accomodationList = project.Type_of_accomodation__c.split(';');
        Set<String> addedaccomodation =new Set<String>();
        String[] accomodationMappedList ;
        if(project.accomodationMap__c!=null){
            accomodationMappedList = project.accomodationMap__c.split(';');
        }
        for(String accomodationValue:accomodationList){
            if(accomodationMappedList!=null){
                for(String accomodationMapped: accomodationMappedList){
                    String[] accomodationMapValue = accomodationMapped.split(',');
                    
                    if(accomodationMapValue[0] == accomodationValue && !addedaccomodation.contains(accomodationMapValue[1])  ){
                        accomodationMapList.add(new accomodationMap(accomodationMapValue[1],accomodationValue)); 
                        addedaccomodation.add(accomodationMapValue[1]);
                    }   
                    else{
                    //    accomodationMapList.add(new accomodationMap(accomodationValue,accomodationValue));                                 
                    }         
                }
            }
            else{
                accomodationMapList.add(new accomodationMap(accomodationValue,accomodationValue));            
            }    
        }
    }
    
    public class AccomodationMap{
        public String accomodationLabel {get;set;}
        public String accomodationValue {get;set;}
        public accomodationMap(String accomodationValue,String accomodationLabel){
            this.accomodationLabel = accomodationLabel ;
            this.accomodationValue = accomodationValue;
        }    
    }

    public class LeadSourceMap{
        public String leadSourceLabel {get;set;}
        public String leadSourceValue {get;set;}
        public leadSourceMap(String leadSourceValue,String leadSourceLabel ){
            this.leadSourceLabel = leadSourceLabel ;
            this.leadSourceValue = leadSourceValue ;
        }
    }

    public Pagereference saveMap(){    
        project.leadSourceMap__c = getLeadMapText();
        project.accomodationMap__c = getAccomodationMapText(); 
        update project;
        return null;
    }

    private String getLeadMapText(){
        String leadSourceStr = '';
        for(LeadSourceMap leadSource: leadSourceMapList){
            if(leadSource.leadSourceValue!= ''){
                leadSourceStr += leadSource.leadSourceLabel+','+leadSource.leadSourceValue+';';
            }
        }
        return leadSourceStr;
    }
    
    private String getAccomodationMapText(){
        String accomodationStr = '';
        for(accomodationMap accomodation :accomodationMapList){
            if(accomodation.accomodationValue!=''){
                accomodationStr += accomodation.accomodationLabel+','+accomodation.accomodationValue+';';            
            }
        }
        return accomodationStr;        
    }
        
    public static List<String> getPicklistDescribe(String objectname,String picklistFieldName)
    {
        List<String> plist = new List<String>();
        for(Schema.PicklistEntry p :Schema.getGlobalDescribe().get(objectname).getDescribe().fields.getMap().get(picklistFieldName).getDescribe().getPicklistValues())
        {
            plist.add(p.getlabel());
        }
        return plist;
    }    

    /****************************TEST METHOD***************************************/         
    public static testMethod void testLeadClasses() 
     {
                
                User u = [select id from user where Profile.name = 'System Administrator' and isActive = true limit 1];
                system.runas(u){

                Id recType = [Select r.SobjectType, r.Name, r.Id From RecordType r where r.SobjectType = 'VisitorFormSettings__c' and r.Name = 'Lead'].Id;
                Project_name__c project = new Project_name__c();
                project.Name = 'testProject';
                project.project_type__c = 'Casa';
                project.record_type__c  = 'Residential';
                project.Type_of_accomodation__c = '2 BHK; 3 BHK';
                insert project;
                
                ApexPages.StandardController pcontroller =  new ApexPages.StandardController(project);        
                ProjectMappingController ctrl =  new ProjectMappingController(pcontroller);                
                ctrl.saveMap();
                }
    }
}