/*
*    Description : Apex Test Class for StaticVariableUtility 

*    Version            Author                Date                Description
*    1.0                Siddharth(Eternus)    26/08/2014          Initial Draft
*/
@isTest
private class StaticVariableUtilityTest {

    static testMethod void inactivateUserForCancelledAccountBeforeInsertRunOnceTest() {
    
        Test.startTest();
            System.assertEquals(false, StaticVariableUtility.inactivateUserForCancelledAccountBeforeInsertRunOnce());
            System.assertEquals(true, StaticVariableUtility.inactivateUserForCancelledAccountBeforeInsertRunOnce());
        Test.stopTest();
    }
    
    static testMethod void inactivateUserForCancelledAccountBeforeUpdateRunOnceTest() {
    
        Test.startTest();
            System.assertEquals(false, StaticVariableUtility.inactivateUserForCancelledAccountBeforeUpdateRunOnce());
            System.assertEquals(true, StaticVariableUtility.inactivateUserForCancelledAccountBeforeUpdateRunOnce());
        Test.stopTest();
    }
    
    static testMethod void createLoyaltyDetailsBeforeInsertUpdateRunOnceTest() {
    
        Test.startTest();
            System.assertEquals(false, StaticVariableUtility.createLoyaltyDetailsBeforeInsertUpdateRunOnce());
            System.assertEquals(true, StaticVariableUtility.createLoyaltyDetailsBeforeInsertUpdateRunOnce());
        Test.stopTest();
    }
    
    static testMethod void referalPercentageUpdateBeforeInsertUpdateRunOnceTest() {
    
        Test.startTest();
            System.assertEquals(false, StaticVariableUtility.referalPercentageUpdateBeforeInsertUpdateRunOnce());
            System.assertEquals(true, StaticVariableUtility.referalPercentageUpdateBeforeInsertUpdateRunOnce());
        Test.stopTest();
    }
    
    static testMethod void referralStatusUpdateBeforeInsertUpdateRunOnceTest() {
    
        Test.startTest();
            System.assertEquals(false, StaticVariableUtility.referralStatusUpdateBeforeInsertUpdateRunOnce());
            System.assertEquals(true, StaticVariableUtility.referralStatusUpdateBeforeInsertUpdateRunOnce());
        Test.stopTest();
    }
    
    static testMethod void calculateEDCBeforeInsertRunOnceTest() {
    
        Test.startTest();
            System.assertEquals(false, StaticVariableUtility.calculateEDCBeforeInsertRunOnce());
            System.assertEquals(true, StaticVariableUtility.calculateEDCBeforeInsertRunOnce());
        Test.stopTest();
    }
    
    static testMethod void calculateEDCBeforeUpdateRunOnceTest() {
    
        Test.startTest();
            System.assertEquals(false, StaticVariableUtility.calculateEDCBeforeUpdateRunOnce());
            System.assertEquals(true, StaticVariableUtility.calculateEDCBeforeUpdateRunOnce());
        Test.stopTest();
    }
}