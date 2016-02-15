/*
*    Description : Test Class for Handler of Lead trigger
*
*       Date        Version      Name     Description
*    22/08/2014       1.0       Asmita    Initial Draft
*/

@isTest
public class LeadTriggerHandlerTest {
    
        private static final String strSuburb1 = 'Koti';
        private static final String strSuburb2 = 'RC Puram';
        private static final String strSuburb3 = 'Parel';
        private static final String strSuburb4 = 'Karve Road';
    	
        private static final String strZone1 = 'Central Hyderabad';
        private static final String strZone2 = 'North Hyderabad';
        private static final String strZone3 = 'South Central';
        private static final String strZone4 = 'West Pune';

        static testMethod void LeadTriggerHelperTest() {
    	    List<Lead> listAllLead = new List<Lead>();
    	    List<ZoneSuburbMapping__c> listAllZoneSuburbMapping = new List<ZoneSuburbMapping__c>();
        
            // Creating Custom Setting record for ZoneSuburbMapping
            List<ZoneSuburbMapping__c> listZoneSuburbMapping = LeadZoneSuburbMappingHelperTest.getZoneSuburbMappingRecords(strSuburb1, strZone1, 1);
            listAllZoneSuburbMapping.addAll(listZoneSuburbMapping);        
            listZoneSuburbMapping = LeadZoneSuburbMappingHelperTest.getZoneSuburbMappingRecords(strSuburb2, strZone2, 1);
            listAllZoneSuburbMapping.addAll(listZoneSuburbMapping);        
            listZoneSuburbMapping = LeadZoneSuburbMappingHelperTest.getZoneSuburbMappingRecords(strSuburb3, strZone3, 1);
            listAllZoneSuburbMapping.addAll(listZoneSuburbMapping);        
            listZoneSuburbMapping = LeadZoneSuburbMappingHelperTest.getZoneSuburbMappingRecords(strSuburb4, strZone4, 1);
            listAllZoneSuburbMapping.addAll(listZoneSuburbMapping);        
            insert listAllZoneSuburbMapping;
        
            // Creating a project to link with Lead Mandatory field
            List<Project_Name__c> listProject = LeadZoneSuburbMappingHelperTest.getProjectrecords(1);
            insert listProject;
        
            // Creating and updating Lead Records with Suburb(R) and Suburb Values not null
            List<Lead> listLead = LeadZoneSuburbMappingHelperTest.getLeadRecords(strSuburb1, strSuburb4, 1);
            listLead[0].Project_Name__c = listProject[0].Id;
            insert listLead;
        
            listAllLead = [select Zone_RS__c, Zone_OS__c, Suburb_RS__c, Suburb_OS__c from Lead where id = :listLead[0].Id];
            System.assertEquals(ZoneSuburbMapping__c.getValues(listLead[0].Suburb_RS__c).zone__c, listAllLead[0].Zone_RS__c);
            System.assertEquals(ZoneSuburbMapping__c.getValues(listLead[0].Suburb_OS__c).zone__c, listAllLead[0].Zone_OS__c);
            
            listAllLead[0].Suburb_RS__c = strSuburb2;
            listAllLead[0].Suburb_OS__c = strSuburb3;
            update listAllLead;
     }
    
     // Creating Custom setting records
     public static List<ZoneSuburbMapping__c> getZoneSuburbMappingRecords(String pStrSuburb, String pStrZone, Integer pNumberOfRecords){
        
        ZoneSuburbMapping__c oZoneSuburb = new ZoneSuburbMapping__c();
        List<ZoneSuburbMapping__c> listZoneSuburbMapping = new List<ZoneSuburbMapping__c>();
        
        for(Integer i = 0; i < pNumberOfRecords ; i++){
            
            oZoneSuburb = new ZoneSuburbMapping__c();            
            oZoneSuburb.Name = pStrSuburb;
            oZoneSuburb.Zone__c = pStrZone;        
            listZoneSuburbMapping.add(oZoneSuburb);
        }
        
        return listZoneSuburbMapping;
     }// end of getZoneSuburbMappingRecords()
     
     
     // Creating Project Name records
     public static List<Project_Name__c> getProjectRecords(Integer pNumberOfRecords){
         
         Project_Name__c oProject = new Project_Name__c();
         List<Project_Name__c> listProject = new List<Project_Name__c>();
         
         for(Integer i = 0; i < pNumberOfRecords; i++){
             
             oProject = new Project_Name__c();
             
             oProject.Project_Type__c = 'Casa';
             oProject.Record_Type__c = 'Residential';
             oProject.Name = 'Casa Bella';
             oProject.CRN_INIT__c = '100';
             
             listProject.add(oProject);
         }
         
         return listProject;
     }// end of getProjectrecords()
     
     public static List<Lead> getLeadRecords(String pStrSuburbR, String pStrSuburbO, Integer pNumberOfRecords){
         
         Lead oLead = new Lead();
         List<Lead> listLead = new List<Lead>();
         
         for(Integer i = 0; i < pNumberOfRecords; i++){
             
             oLead = new Lead();
             oLead.LastName = 'Test Lead Trigger';
             oLead.Mobile__c = '9955555555';
             oLead.Status = 'Open';
             oLead.Next_Action__c = 'Establish Contact';
             oLead.LeadSource = 'ClubCASA';
             oLead.Suburb_OS__c = pStrSuburbO;
             oLead.Suburb_RS__c = pStrSuburbR;
             
             listLead.add(oLead);
         }
         
         return listLead;
     }
}