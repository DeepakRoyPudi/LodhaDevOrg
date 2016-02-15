@isTest
public class TestCalculateACD{
    
    //Test Method
    public static testMethod void TestCalculateACD(){  
    
    Task t = new Task();
     t.status = 'Open';
     t.Query_Type__c='Payment Related';
     t.Priority='Normal';
     t.Subject='call';
     insert t;
     t.status = 'Completed';
     update t;
       
    }
    
    
}