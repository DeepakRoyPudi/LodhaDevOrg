@isTest
public with sharing class ChannelPartnerAfeterInsertTest {
	public static testMethod void testCPAfterInsert(){ 
		test.startTest();
        Channel_Partner__c testRec =new Channel_Partner__c(Name='Aparnafirms',
        													Type_of_Channel_Partner__c='Domestic',
        													Email__c='xy@hotmail.com');
        insert testRec;	
		test.stopTest();
	}
	
}