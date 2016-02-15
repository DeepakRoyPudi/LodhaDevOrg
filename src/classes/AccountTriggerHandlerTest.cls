/*
*    Description: Test class for AccountTriggerHandler
*    
*    Version      Date       Author     Description
*     1.0      10/09/2014    Asmita    Initial Draft
*/

@isTest
private class AccountTriggerHandlerTest {

    static testMethod void onBeforeInsertTest() {
        
        List<Account> listNewAccount = new List<Account>();
        
        AccountTriggerHandler accHandler = new AccountTriggerHandler();
        accHandler.onBeforeInsert(listNewAccount);
    }
    static testMethod void onBeforeUpdateTest() {
        
        Map<Id, Account> mapNewAccount = new Map<Id, Account>();
        Map<Id, Account> mapOldAccount = new Map<Id, Account>();
        
        AccountTriggerHandler accHandler = new AccountTriggerHandler();
        accHandler.onBeforeUpdate(mapOldAccount, mapNewAccount);
    }
    static testMethod void onAfterUpdateTest() {
        
        Map<Id, Account> mapNewAccount = new Map<Id, Account>();
        Map<Id, Account> mapOldAccount = new Map<Id, Account>();
        
        AccountTriggerHandler accHandler = new AccountTriggerHandler();
        accHandler.onAfterUpdate(mapOldAccount, mapNewAccount);
    }
}