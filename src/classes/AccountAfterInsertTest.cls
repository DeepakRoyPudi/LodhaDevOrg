@isTest
public with sharing class AccountAfterInsertTest {
	public static testMethod void testAccountAfterInsert(){ 
		test.startTest();
		Id recTypeId = [Select Id From RecordType  Where SobjectType = 'Account' and DeveloperName = 'Channel_Partner_Account'].id;  
        Account a = new Account(FirstName = 'testFirstacc',
                                LastNAme = 'testLastacc',
                                Recordtypeid = recTypeId,
                                Status__c = 'Created',
                                PersonMobilePhone = '1234567890',
                                PersonEmail = 'testtest@test.com',
                                CRN__c = '098899',
                                isViaCP__c = true,
                                Personal_Email__pc = 'testtest1@test.com',
                                Project_Name__c = 'Casa Bella Gold'
                                );
        insert a;	
		test.stopTest();
	}
}