/*
*    Description : Test class for FlatTriggerHandler
*
*    Version       Date            Author            Description
*    1.0          10/11/2014      Asmita Bubane     Initial Draft
*/

@isTest
private class FlatTriggerHandlerTest {
    
    // Method to test the onAfterInsert method
    static testMethod void onAfterInsertTest() {
        Map<Id, Flat__c> mapNewFlat = new Map<Id, Flat__c>();
        Map<Id, Flat__c> mapOldFlat = new Map<Id, Flat__c>();
        
        FlatTriggerHandler objFlatHandler = new FlatTriggerHandler();
        objFlatHandler.onAfterInsert(mapNewFlat, mapOldFlat);
    }
    
    // Method to test the onAfterUpdate method
    static testMethod void onAfterUpdateTest() {
        Map<Id, Flat__c> mapNewFlat = new Map<Id, Flat__c>();
        Map<Id, Flat__c> mapOldFlat = new Map<Id, Flat__c>();
        
        FlatTriggerHandler objFlatHandler = new FlatTriggerHandler();
        objFlatHandler.onAfterUpdate(mapNewFlat, mapOldFlat);
    }
}