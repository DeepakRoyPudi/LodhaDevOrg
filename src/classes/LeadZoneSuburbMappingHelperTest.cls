/*
*    Description : Test class for Lead trigger Helper to map the Zone value depending on the selected Suburb
*
*       Date        Version      Name     Description
*    17/07/2014       1.0       Asmita    Initial Draft
*/

@isTest
public class LeadZoneSuburbMappingHelperTest {

    private static final String strSuburb1 = 'Koti';
    private static final String strSuburb2 = 'RC Puram';
    private static final String strSuburb3 = 'Parel';
    private static final String strSuburb4 = 'Karve Road';
    	
    private static final String strZone1 = 'Central Hyderabad';
    private static final String strZone2 = 'North Hyderabad';
    private static final String strZone3 = 'South Central';
    private static final String strZone4 = 'West Pune';

    public static testMethod void insertZoneSuburbMappingTest() {
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
        
        listAllLead = [select Zone_RS__c, Zone_OS__c from Lead where id = :listLead[0].Id];
        System.assertEquals(ZoneSuburbMapping__c.getValues(listLead[0].Suburb_RS__c).zone__c, listAllLead[0].Zone_RS__c);
        System.assertEquals(ZoneSuburbMapping__c.getValues(listLead[0].Suburb_OS__c).zone__c, listAllLead[0].Zone_OS__c);
        
        // Testing lead records with null suburbs
        listLead = LeadZoneSuburbMappingHelperTest.getLeadRecords(null, strSuburb4, 1);
        listLead[0].Project_Name__c = listProject[0].Id;
        insert listLead;
        
        listAllLead = [select Zone_RS__c, Zone_OS__c from Lead where id = :listLead[0].Id];
        System.assertEquals(null, listAllLead[0].Zone_RS__c);
        System.assertEquals(ZoneSuburbMapping__c.getValues(listLead[0].Suburb_OS__c).zone__c, listAllLead[0].Zone_OS__c);
        
        // Inserting othe Lead with Suburb as null
        listLead = LeadZoneSuburbMappingHelperTest.getLeadRecords(strSuburb1, null, 1);
        listLead[0].Project_Name__c = listProject[0].Id;
        insert listLead;
        
        listAllLead = [select Zone_RS__c, Zone_OS__c from Lead where id = :listLead[0].Id];
        System.assertEquals(ZoneSuburbMapping__c.getValues(listLead[0].Suburb_RS__c).zone__c, listAllLead[0].Zone_RS__c);
        System.assertEquals(null, listAllLead[0].Zone_OS__c);
        
        // Inserting Lead records in bulk
        listLead = LeadZoneSuburbMappingHelperTest.getLeadRecords(strSuburb1, strSuburb4, 200);
        listLead[0].Project_Name__c = listProject[0].Id;
        insert listLead;

        listAllLead = [select Zone_RS__c, Zone_OS__c, Suburb_OS__c, Suburb_RS__c from Lead where id in :listLead];
        for(Integer i = 0; i < listAllLead.size(); i++){
            System.assertEquals(ZoneSuburbMapping__c.getValues(listAllLead[i].Suburb_RS__c).zone__c, listAllLead[i].Zone_RS__c);
            System.assertEquals(ZoneSuburbMapping__c.getValues(listAllLead[i].Suburb_OS__c).zone__c, listAllLead[i].Zone_OS__c);
        }
        
        LeadZoneSuburbMappingHelper oLeadHelper = new LeadZoneSuburbMappingHelper();
        oLeadHelper.insertZoneDependingOnSuburb(listAllLead);
    }
    
    //test method for updateZoneDependingOnSuburb() method of LeadZoneSuburbMappingHelper Class
    public static testMethod void updateZoneSuburbMappingTest() {
        
        List<Lead> listLeadInsert = new List<Lead>();
        List<Lead> listLeadUpdate = new List<Lead>();
        Map<Id, Lead> mapLeadOld = new Map<Id, Lead>();
        Map<Id, Lead> mapLeadNew = new Map<Id, Lead>();
        
        // Creating Custom Setting record for ZoneSuburbMapping
        List<ZoneSuburbMapping__c> listZoneSuburbMapping = LeadZoneSuburbMappingHelperTest.getZoneSuburbMappingRecords(strSuburb1, strZone1, 1);
        insert listZoneSuburbMapping;
        
        listZoneSuburbMapping = LeadZoneSuburbMappingHelperTest.getZoneSuburbMappingRecords(strSuburb2, strZone2, 1);
        insert listZoneSuburbMapping;
        
        listZoneSuburbMapping = LeadZoneSuburbMappingHelperTest.getZoneSuburbMappingRecords(strSuburb3, strZone3, 1);
        insert listZoneSuburbMapping;
        
        listZoneSuburbMapping = LeadZoneSuburbMappingHelperTest.getZoneSuburbMappingRecords(strSuburb4, strZone4, 1);
        insert listZoneSuburbMapping;
        
        // Creating a project to link with Lead Mandatory field
        List<Project_Name__c> listProject = LeadZoneSuburbMappingHelperTest.getProjectrecords(1);
        insert listProject;
        
        // Creating the leads
        listLeadInsert = LeadZoneSuburbMappingHelperTest.getLeadRecords(strSuburb1, strSuburb4, 200);
        for(Integer i = 0; i < listLeadInsert.size(); i++){
            listLeadInsert[i].Project_Name__c = listProject[0].Id;
        }
        insert listLeadInsert;
        
        // Updating suburb(O) with null value
        listLeadInsert[0].Suburb_OS__c = null;
        listLeadInsert[0].Suburb_RS__c = strSuburb3;    
        update listLeadInsert[0];
        listLeadUpdate = [select Zone_RS__c, Zone_OS__c, Suburb_OS__c, Suburb_RS__c from Lead where id = :listLeadInsert[0].Id];
	    System.assertEquals(ZoneSuburbMapping__c.getValues(listLeadUpdate[0].Suburb_RS__c).zone__c, listLeadUpdate[0].Zone_RS__c);
        System.assertEquals(null, listLeadUpdate[0].Zone_OS__c);
	    mapLeadNew.put(listLeadUpdate[0].Id, listLeadUpdate[0]);
	    mapLeadOld.put(listLeadInsert[0].Id, listLeadInsert[0]);
	    
	    // Updating suburb(R) with null value
	    listLeadUpdate = new List<Lead>(); 
        listLeadInsert[1].Suburb_OS__c = strSuburb4;
        listLeadInsert[1].Suburb_RS__c = null;    
        update listLeadInsert[1];
        listLeadUpdate = [select Zone_RS__c, Zone_OS__c, Suburb_OS__c, Suburb_RS__c from Lead where id = :listLeadInsert[1].Id];
        System.assertEquals(ZoneSuburbMapping__c.getValues(listLeadUpdate[0].Suburb_OS__c).zone__c, listLeadUpdate[0].Zone_OS__c);
	    System.assertEquals(null, listLeadUpdate[0].Zone_RS__c);
	    mapLeadNew.put(listLeadUpdate[0].Id, listLeadUpdate[0]);
	    mapLeadOld.put(listLeadInsert[1].Id, listLeadInsert[1]);
        
        for(Integer i = 2; i < listLeadInsert.size(); i++){
            
            mapLeadOld.put(listLeadInsert[i].Id, listLeadInsert[i]);
            
            listLeadInsert[i].Suburb_RS__c = strSuburb2;
            listLeadInsert[i].Suburb_OS__c = strSuburb3;
            
            mapLeadNew.put(listLeadInsert[i].Id, listLeadInsert[i]);
        }
        
        if(!mapLeadNew.isEmpty())
            update mapLeadNew.values();
            
        listLeadUpdate = [select Zone_RS__c, Zone_OS__c, Suburb_OS__c, Suburb_RS__c from Lead where id in :mapLeadNew.keySet()];
        for(Integer i = 2; i < listLeadUpdate.size(); i++){
            System.assertEquals(ZoneSuburbMapping__c.getValues(listLeadUpdate[i].Suburb_RS__c).zone__c, listLeadUpdate[i].Zone_RS__c);
            System.assertEquals(ZoneSuburbMapping__c.getValues(listLeadUpdate[i].Suburb_OS__c).zone__c, listLeadUpdate[i].Zone_OS__c);
        }
        
        LeadZoneSuburbMappingHelper oLeadHelper = new LeadZoneSuburbMappingHelper();
        oLeadHelper.updateZoneDependingOnSuburb(mapLeadOld, mapLeadNew);
        
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