@isTest(SeeAllData=true)
public class TestSendmailforcases{
    
    //Test Method
    public static testMethod void TestSendmailforcases(){ 
    
        Account a = new Account();
        a.FirstName='Test';
        a.LastName='Brduser Test';
        insert a;
        
        Case c = new Case();
        c.accountId=(String)a.Id;
        c.RecordTypeid=[Select id from RecordType where SobjectType='Case' AND Name='CSS Cases'].Id;
        c.Project__c='Casa';
        c.Buildings_Name__c='Building1';
        c.Wing__c='east';
        c.Status='New';
        c.Loan_Stages__c='ADF';
        c.Manager__c='Dilip Sheth';
        c.ADF__c='Yes';
        insert c; 
        
        c.Project__c='Casa';
        c.Buildings_Name__c='Building1';
        c.Wing__c='east';
        c.Status='New';
        c.Loan_Stages__c='ADF';
        c.Manager__c='Dilip Sheth';
        c.ADF__c='No';
        update c; 
        
        
        List<Case> cList = new List<Case>(); 
        cList.add(c);
        
        
        Sendmailforcases cs = new Sendmailforcases();
        cs.sendmailafterinsert(cList);
        cs.sendmailafterupdate(cList);
        
        
    }
}