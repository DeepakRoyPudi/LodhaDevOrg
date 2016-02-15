/*    Description: Test Class for BatchCallToPalavaWebservice
*    
*    Version            Date            Author                    Description
*    1.0                10/11/2014      Asmita(Eternus)           Initial Draft
*/

@isTest
private class BatchCallToPalavaWebserviceTest {

    static testMethod void callToPalavaWebserivce() {
    	Database.Querylocator qryLocator;
    	Database.Batchablecontext bc;
    	BatchCallToPalavaWebservice objBatchCallToWebservice;
    	Flat__c oFlat = new Flat__c();
    	
        // Setting MockCallout class which will call respond method of MochHttpResponseForAftership
        Test.setMock(HttpCalloutMock.class, new MockupResponseForReturningStatusPalava());
        
        // Inserting Project Name Record
        List<Project_Name__c> listProject = BatchCallToPalavaWebserviceTest.getProjectRecords(1);
        insert listProject;
        
        // Inserting Cluster record
        List<Cluster__c> listCluster = BatchCallToPalavaWebserviceTest.getClusterRecords(1);
        listCluster[0].Project_Name__c = listProject[0].Id;
        insert listCluster;
        
        // Inserting Wing Record
        List<Wing__c> listWing = BatchCallToPalavaWebserviceTest.getWingRecords(1);
        listWing[0].Cluster__c = listCluster[0].Id;
        insert listWing;
        
        // Inserting Flat Type Record
        List<Flat_Type__c> listFlatType = BatchCallToPalavaWebserviceTest.getFlatTypeRecords(1);
        listFlatType[0].Wing__c = listwing[0].Id;
        insert listFlatType; 
        
        // Inserting Flat record
        List<Flat__c> listFlat = BatchCallToPalavaWebserviceTest.getFlatRecords(1, 101, 'BLOCKED');
        listFlat[0].Wing__c = listwing[0].Id;
        listFlat[0].Flat_Type__c = listFlatType[0].Id;
        insert listFlat; 
        
        List<String> listOasysFlatCode = new List<String>();
        
        for(Flat__c objFlat : listFlat){
            listOasysFlatCode.add(objFlat.Oasys_Flat_code__c);
        }
        
        objBatchCallToWebservice = new BatchCallToPalavaWebservice(listOasysFlatCode, 0);
        
        test.startTest();
            qryLocator = objBatchCallToWebservice.start(bc);
            
            Database.Querylocatoriterator qryLocatorIterator = qryLocator.iterator();
            while(qryLocatorIterator.hasNext()){
                
                oFlat = (Flat__c)qryLocatorIterator.next();
                listFlat.add(oFlat);
                
            }// end of while
            
            objBatchCallToWebservice.execute(bc, listFlat);
            objBatchCallToWebservice.finish(bc);
        test.stopTest();
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