/*
*    Description : Test class for ServiceForHoldStatus
*
*    Version       Date            Author            Description
*    1.0          15/11/2014      Asmita Bubane     Initial Draft
*/
 
@isTest
private class ServiceForHoldStatusTest{

    static testMethod void returnStatusWithUnholdAndNotBooked() {
         
        // Setting MockCallout class which will call respond method of MochHttpResponseForAftership
        Test.setMock(HttpCalloutMock.class, new MockupResponseForReturningStatusPalava());
        
        // Inserting Project Name Record
        List<Project_Name__c> listProject = ServiceForHoldStatusTest.getProjectRecords(1);
        insert listProject;
        
        // Inserting Cluster record
        List<Cluster__c> listCluster = ServiceForHoldStatusTest.getClusterRecords(1);
        listCluster[0].Project_Name__c = listProject[0].Id;
        insert listCluster;
        
        // Inserting Wing Record
        List<Wing__c> listWing = ServiceForHoldStatusTest.getWingRecords(1);
        listWing[0].Cluster__c = listCluster[0].Id;
        insert listWing;
        
        // Inserting Flat Type Record
        List<Flat_Type__c> listFlatType = ServiceForHoldStatusTest.getFlatTypeRecords(1);
        listFlatType[0].Wing__c = listwing[0].Id;
        insert listFlatType; 
        
        // Inserting Flat record
        List<Flat__c> listFlat = ServiceForHoldStatusTest.getFlatRecords(1, 101, 'OPEN');
        listFlat[0].Wing__c = listwing[0].Id;
        listFlat[0].Flat_Type__c = listFlatType[0].Id;
        listFlat[0].Hold_Status__c = null;
        insert listFlat; 
                
        // Calling the webservice
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/holdStatusService';  
        req.addParameter('flatCode', 'Test Project Test Cluster Test Wing 101');

        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;

        String results = ServiceForHoldStatus.returnFlatStatus();
        
        System.assertEquals(results, 'Flat is Available.');
    }
    
    static testMethod void returnStatusWithUnholdAndBooked() {
         
        // Setting MockCallout class which will call respond method of MochHttpResponseForAftership
        Test.setMock(HttpCalloutMock.class, new MockupResponseForReturningStatusPalava());
        
        // Inserting Project Name Record
        List<Project_Name__c> listProject = ServiceForHoldStatusTest.getProjectRecords(1);
        insert listProject;
        
        // Inserting Cluster record
        List<Cluster__c> listCluster = ServiceForHoldStatusTest.getClusterRecords(1);
        listCluster[0].Project_Name__c = listProject[0].Id;
        insert listCluster;
        
        // Inserting Wing Record
        List<Wing__c> listWing = ServiceForHoldStatusTest.getWingRecords(1);
        listWing[0].Cluster__c = listCluster[0].Id;
        insert listWing;
        
        // Inserting Flat Type Record
        List<Flat_Type__c> listFlatType = ServiceForHoldStatusTest.getFlatTypeRecords(1);
        listFlatType[0].Wing__c = listwing[0].Id;
        insert listFlatType; 
        
        // Inserting Flat record
        List<Flat__c> listFlat = ServiceForHoldStatusTest.getFlatRecords(1, 101, 'BOOKED');
        listFlat[0].Wing__c = listwing[0].Id;
        listFlat[0].Flat_Type__c = listFlatType[0].Id;
        listFlat[0].Hold_Status__c = null;
        insert listFlat; 
                
        // Calling the webservice
        // Calling the webservice
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/holdStatusService';  
        req.addParameter('flatCode', 'Test Project Test Cluster Test Wing 101');

        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;

        String results = ServiceForHoldStatus.returnFlatStatus();
        
        System.assertEquals(results, 'Flat is already Booked.');
    }
    
    static testMethod void returnStatusWithHoldAndBooked() {
         
        // Setting MockCallout class which will call respond method of MochHttpResponseForAftership
        Test.setMock(HttpCalloutMock.class, new MockupResponseForReturningStatusPalava());
        
        // Inserting Project Name Record
        List<Project_Name__c> listProject = ServiceForHoldStatusTest.getProjectRecords(1);
        insert listProject;
        
        // Inserting Cluster record
        List<Cluster__c> listCluster = ServiceForHoldStatusTest.getClusterRecords(1);
        listCluster[0].Project_Name__c = listProject[0].Id;
        insert listCluster;
        
        // Inserting Wing Record
        List<Wing__c> listWing = ServiceForHoldStatusTest.getWingRecords(1);
        listWing[0].Cluster__c = listCluster[0].Id;
        insert listWing;
        
        // Inserting Flat Type Record
        List<Flat_Type__c> listFlatType = ServiceForHoldStatusTest.getFlatTypeRecords(1);
        listFlatType[0].Wing__c = listwing[0].Id;
        insert listFlatType; 
        
        // Inserting Flat record
        List<Flat__c> listFlat = ServiceForHoldStatusTest.getFlatRecords(1, 101, 'BOOKED');
        listFlat[0].Wing__c = listwing[0].Id;
        listFlat[0].Flat_Type__c = listFlatType[0].Id;
        listFlat[0].Hold_Status__c = 'Hold';
        listFlat[0].Hold_Status_Start_Time__c = System.now(); 
        insert listFlat; 
                
        // Calling the webservice
        // Calling the webservice
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/holdStatusService';  
        req.addParameter('flatCode', 'Test Project Test Cluster Test Wing 101');

        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;

        String results = ServiceForHoldStatus.returnFlatStatus();
        
        System.assertEquals(results, 'Flat is already Booked.');
    }
    
    static testMethod void returnStatusWithHoldAndNotBookedWithinHalfAnHour() {
         
        // Setting MockCallout class which will call respond method of MochHttpResponseForAftership
        Test.setMock(HttpCalloutMock.class, new MockupResponseForReturningStatusPalava());
        
        // Inserting Project Name Record
        List<Project_Name__c> listProject = ServiceForHoldStatusTest.getProjectRecords(1);
        insert listProject;
        
        // Inserting Cluster record
        List<Cluster__c> listCluster = ServiceForHoldStatusTest.getClusterRecords(1);
        listCluster[0].Project_Name__c = listProject[0].Id;
        insert listCluster;
        
        // Inserting Wing Record
        List<Wing__c> listWing = ServiceForHoldStatusTest.getWingRecords(1);
        listWing[0].Cluster__c = listCluster[0].Id;
        insert listWing;
        
        // Inserting Flat Type Record
        List<Flat_Type__c> listFlatType = ServiceForHoldStatusTest.getFlatTypeRecords(1);
        listFlatType[0].Wing__c = listwing[0].Id;
        insert listFlatType; 
        
        // Inserting Flat record
        List<Flat__c> listFlat = ServiceForHoldStatusTest.getFlatRecords(1, 101, 'OPEN');
        listFlat[0].Wing__c = listwing[0].Id;
        listFlat[0].Flat_Type__c = listFlatType[0].Id;
        listFlat[0].Hold_Status__c = 'Hold';
        listFlat[0].Hold_Status_Start_Time__c = System.now(); 
        insert listFlat; 
                
        // Calling the webservice
        // Calling the webservice
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/holdStatusService';  
        req.addParameter('flatCode', 'Test Project Test Cluster Test Wing 101');

        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;

        String results = ServiceForHoldStatus.returnFlatStatus();
        
        System.assertEquals(results, 'Flat is on Hold.');
    }
    
    static testMethod void returnStatusWithHoldAndNotBookedAfterHalfAnHour() {
         
        // Setting MockCallout class which will call respond method of MochHttpResponseForAftership
        Test.setMock(HttpCalloutMock.class, new MockupResponseForReturningStatusPalava());
        
        // Inserting Project Name Record
        List<Project_Name__c> listProject = ServiceForHoldStatusTest.getProjectRecords(1);
        insert listProject;
        
        // Inserting Cluster record
        List<Cluster__c> listCluster = ServiceForHoldStatusTest.getClusterRecords(1);
        listCluster[0].Project_Name__c = listProject[0].Id;
        insert listCluster;
        
        // Inserting Wing Record
        List<Wing__c> listWing = ServiceForHoldStatusTest.getWingRecords(1);
        listWing[0].Cluster__c = listCluster[0].Id;
        insert listWing;
        
        // Inserting Flat Type Record
        List<Flat_Type__c> listFlatType = ServiceForHoldStatusTest.getFlatTypeRecords(1);
        listFlatType[0].Wing__c = listwing[0].Id;
        insert listFlatType; 
        
        // Inserting Flat record
        List<Flat__c> listFlat = ServiceForHoldStatusTest.getFlatRecords(1, 101, 'OPEN');
        listFlat[0].Wing__c = listwing[0].Id;
        listFlat[0].Flat_Type__c = listFlatType[0].Id;
        listFlat[0].Hold_Status__c = 'Hold';
        listFlat[0].Hold_Status_Start_Time__c = System.now().addMinutes(-32); 
        insert listFlat; 
                
        // Calling the webservice
        // Calling the webservice
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/holdStatusService';  
        req.addParameter('flatCode', 'Test Project Test Cluster Test Wing 101');

        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;

        String results = ServiceForHoldStatus.returnFlatStatus();
        
        System.assertEquals(results, 'Flat is Available.');
    }
    
    // Creating Project Name records
    public static List<Project_Name__c> getProjectRecords(Integer pNumberOfRecords){
        
        Project_Name__c objProjName = new Project_Name__c();
        List<Project_Name__c> listProjectName = new List<Project_Name__c>();
        
        for(Integer i = 0 ; i < pNumberOfRecords ; i++){
          
            objProjName = new Project_Name__c();
            
            objProjName.Name = 'Test Project';
            objProjName.Project_Type__c = 'Casa';
            objProjName.Record_Type__c = 'Residential';
            
            listProjectName.add(objProjName);
        }
        
        return listProjectName;
    }
    
    // Creating Cluster record
    public static List<Cluster__c> getClusterRecords(Integer pNumberOfRecords){
        
        Cluster__c objCluster = new Cluster__c();
        List<Cluster__c> listCluster = new List<Cluster__c>();
        
        for(Integer i = 0 ; i < pNumberOfRecords ; i++){
          
            objCluster = new Cluster__c();            
            objCluster.Name = 'Test Cluster';
            
            listCluster.add(objCluster);
        }
        
        return listCluster;
    }
    
    // Creating Wing record
    public static List<Wing__c> getWingRecords(Integer pNumberOfRecords){
        
        Wing__c objWing = new Wing__c();
        List<Wing__c> listWing = new List<Wing__c>();
        
        for(Integer i = 0 ; i < pNumberOfRecords ; i++){
          
            objWing = new Wing__c();            
            objWing.Name = 'Test Wing';
            
            listWing.add(objWing);
        }
        
        return listWing;
    }
    
    // Creating Flat Type record
    public static List<Flat_Type__c> getFlatTypeRecords(Integer pNumberOfRecords){
        
        Flat_Type__c objFlatType = new Flat_Type__c();
        List<Flat_Type__c> listFlatType = new List<Flat_Type__c>();
        
        for(Integer i = 0 ; i < pNumberOfRecords ; i++){
          
            objFlatType = new Flat_Type__c();            
            objFlatType.Name = 'Test Flat Type';
            
            listFlatType.add(objFlatType);
        }
        
        return listFlatType;
    }
    
    // Creating Flat record
    public static List<Flat__c> getFlatRecords(Integer pNumberOfRecords, Integer pFlatNumber, String pStatus){
        
        Flat__c objFlat = new Flat__c();
        List<Flat__c> listFlat = new List<Flat__c>();
        
        for(Integer i = 0 ; i < pNumberOfRecords ; i++){
          
            objFlat = new Flat__c();            
            objFlat.Flat_No__c = pFlatNumber;
            objFlat.Status__c = pStatus;
            objFlat.Oasys_Flat_code__c = 'Test Project Test Cluster Test Wing ' + pFlatNumber;
            
            listFlat.add(objFlat);
        }
        
        return listFlat;
    }
}