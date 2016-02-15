/*
  Version    Date         Auther             Description
  1.1      08/20/2014    Asmita(Eternus)    Modified the code as the Too Many SOQL exception was occuring while deploying the Lead related components
*/

@isTest
private class CalculateCallRatingTest {

    static testMethod void myUnitTest1() {
       
        Project_Name__c pn1=new Project_Name__c(name='Lodha Aria');
        Project_Name__c pn2=new Project_Name__c(name='Lodha Primero');
        Project_Name__c pn3=new Project_Name__c(name='Lodha Bellissimo');
        list <Project_Name__c> lstPN = new list <Project_Name__c> ();
        lstPN.add(pn1);
        lstPN.add(pn2);
        lstPN.add(pn3);
        insert lstPN;   
        
        Lead l=new Lead(Project_Name__c=pn1.Id, Company='Lodha Group', Project_Interested__c='Lodha Aria', Mobile__c='2345678912', LastName='Test', LeadSource='Web');
        insert l;
    
        Account acc=new account(Name='test');
        insert acc;

        Call_Attempts__c ca1 = new Call_Attempts__c (Project_Name__c = pn1.id, Lead__c=l.id, Project_Interested__c='Lodha Aria', Mobile__c=l.Mobile__c, Attempted_By__c='CEO', Call_Attempted_by__c='test', Call_Attempt_Status__c='Open', Call_Type__c='Outbound');
        Call_Attempts__c ca2 = new Call_Attempts__c (Project_Name__c = pn2.id, Lead__c=l.id, Project_Interested__c='Lodha Primero', Mobile__c=l.Mobile__c, Attempted_By__c='CEO', Call_Attempted_by__c='test', Call_Attempt_Status__c='Lost', Call_Type__c='Outbound');
        list <Call_Attempts__c> lstCA = new list <Call_Attempts__c> ();
        lstCA.add(ca1);
        lstCA.add(ca2);
        insert lstCA;
        
        test.startTest();
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(l.id);
        lc.setConvertedStatus('Converted');
        lc.setOwnerId(UserInfo.getUserId());
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        test.stopTest();
        
        /*Opportunity o = new Opportunity(Name = 'Test Opp', AccountId = acc.Id, CloseDate = System.Today()+2, Project_Name__c = pn3.id, StageName = 'Open', No_Show__c = True);
        insert o;
        
        Call_Attempts__c ca3 = new Call_Attempts__c (Opportunity__c = o.Id, Project_Name__c = pn3.id, Project_Interested__c='Lodha Primero', Mobile__c='1983675486', Attempted_By__c='CEO', Call_Attempted_by__c='test', Call_Attempt_Status__c='Visit Done', Call_Type__c='Outbound');
        insert ca3;
        
        Call_Attempts__c ca4 = new Call_Attempts__c (Opportunity__c = o.Id, Project_Name__c = pn3.id, Project_Interested__c='Lodha Primero', Mobile__c='1983675486', Attempted_By__c='CEO', Call_Attempted_by__c='test', Call_Attempt_Status__c='Lost', Call_Type__c='Outbound');
        insert ca4;*/
    }   
    
        static testMethod void myUnitTest2() {
       
        Project_Name__c pn1=new Project_Name__c(name='Lodha Aria');
        Project_Name__c pn2=new Project_Name__c(name='Lodha Primero');
        Project_Name__c pn3=new Project_Name__c(name='Lodha Bellissimo');
        list <Project_Name__c> lstPN = new list <Project_Name__c> ();
        lstPN.add(pn1);
        lstPN.add(pn2);
        lstPN.add(pn3);
        insert lstPN;   
        
        Account acc=new account(Name='test');
        insert acc;
        
        Opportunity o = new Opportunity(Name = 'Test Opp', AccountId = acc.Id, CloseDate = System.Today(), Project_Name__c = pn3.id, StageName = 'Open', No_Show__c = True);
        insert o;
        
        Call_Attempts__c ca3 = new Call_Attempts__c (Opportunity__c = o.Id, Project_Name__c = pn3.id, Project_Interested__c='Lodha Primero', Mobile__c='1983675486', Attempted_By__c='CEO', Call_Attempted_by__c='test', Call_Attempt_Status__c='Visit Done', Call_Type__c='Outbound');
        insert ca3;
        
        Call_Attempts__c ca4 = new Call_Attempts__c (Opportunity__c = o.Id, Project_Name__c = pn3.id, Project_Interested__c='Lodha Primero', Mobile__c='1983675486', Attempted_By__c='CEO', Call_Attempted_by__c='test', Call_Attempt_Status__c='Lost', Call_Type__c='Outbound');
        insert ca4;
        
        CalculateCallRating.recursionControl = False;       
        ca4.Call_Attempt_Status__c = 'Lost';
        update ca4;
    }   
    
}