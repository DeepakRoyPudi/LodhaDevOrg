/*
* Description : VDNB Trigger Helper Test
*
* Version     Date          Author             Description
* 1.0         09/12/2014    Anupam Agrawal     Intial Draft
*/
@isTest
private class VDNBHelperTest 
{
    static testMethod void testVDNBHelper() 
    {
    	Project_Name__c objPN = new Project_Name__c(name='Lodha Aria');
        insert objPN;    
        
        Account acc=new account(Name='test');
        insert acc;
        
        Opportunity objOpp = new Opportunity(Name = 'Test Opp', AccountId = acc.Id, CloseDate = System.Today(), 
        									Project_Name__c = objPN.id, StageName = 'Open', No_Show__c = True);
        insert objOpp;
        
        List<VDNB__c> lstVDNB = new List<VDNB__c>();
        VDNB__c objVDNB = new VDNB__c(Opportunity__c = objOpp.Id,  
                                                      Project_Interested__c='Lodha Primero', Mobile__c='1983675486', Attempted_By__c='CEO', 
                                                      Call_Attempted_by__c='test', Call_Type__c='Outbound');
        lstVDNB.add(objVDNB);
        
        VDNB__c objVDNB1 = new VDNB__c(Opportunity__c = objOpp.Id, Project_Interested__c='Lodha Primero', 
                                                      Mobile__c='1983675486', Attempted_By__c='CEO',  Call_Attempted_by__c='test',
                                                      Call_Type__c='Outbound');
        lstVDNB.add(objVDNB1);
        
        Test.startTest();
        insert lstVDNB;
        Opportunity objOpportunity = [Select Id, VDNB__c from Opportunity where Id =: objOpp.Id];
        System.assertEquals(objOpportunity.VDNB__c, lstVDNB[0].Id);
        Test.stopTest();
    }
}