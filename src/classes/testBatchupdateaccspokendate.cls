@isTest
    private class testBatchupdateaccspokendate{
        static testMethod void testBatchClass() {
        Batchupdateaccspokendate bc = new Batchupdateaccspokendate();
        bc.querystring= 'Select id,Last_Call_Date_RO__c from Opportunity where Last_Call_Date_RO__c!=null LIMIT 200';      
        Test.startTest();
        Database.executeBatch(bc, 200);
        Test.stopTest();
    }
}