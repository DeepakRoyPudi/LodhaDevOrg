@isTest
public class TestTaskCreateController{
    
    //Test Method
    public static testMethod void TestTaskCreateController(){  
    
    Profile Profile1 = [select id from profile where name='System Administrator'];
    User User1 =  [Select id, isActive from User where profileId =:Profile1.id and isActive=true Limit 1];
    
    System.debug('# User1:'+User1);
    
    Account a = new Account();
        a.RecordTypeId=[Select id from RecordType where SobjectType='Account' AND Name='Person Account'].Id;
        a.FirstName=' ';
        a.LastName='Brduser Test';
        a.Mobile_Phone__c='2342342';
        insert a;
        
    PageReference Taskcreatepage = Page.Taskcreatepage ;
        Taskcreatepage.getParameters().put('Id',a.id);   
        test.setCurrentPage(Taskcreatepage);
    
    TaskCreateController nTask = new TaskCreateController();
        nTask.initmethod();
        nTask.newtask=new Task();
        nTask.newtask.ReminderDate__c=date.today();
        nTask.newtask.Query_Type__c='Payment Related';
        nTask.paymentcomment='test comment';
        nTask.getDescribesubjectpiclist();
        nTask.onchange();
        nTask.Createtask();

        
    TaskCreateController nTask11 = new TaskCreateController();
        nTask11.newtask=new Task();
        nTask11.newtask.ReminderDate__c=date.today();
        nTask11.newtask.ReminderTime__c=string.valueof(datetime.now());
        nTask11.initmethod();
        nTask11.newtask.Query_Sub_Type_Payment_Related__c='Interest related';
        nTask11.getDescribesubjectpiclist();
        nTask11.OnchangePaymentRelated();        
        nTask11.Createtask(); 
        
    TaskCreateController nTask12 = new TaskCreateController();
        nTask12.initmethod();
        nTask12.newtask=new Task();
        nTask12.newtask.Query_Sub_Type_Cancellation_Related__c='Refund';
        nTask12.getDescribesubjectpiclist();
        nTask12.OnchangecancelRelated();
        
    TaskCreateController nTask1 = new TaskCreateController();
        nTask1.initmethod();
        nTask1.newtask=new Task();
        nTask1.newtask.Query_Type__c='Document/Information Related';
        nTask1.documentcomment='test';
        nTask1.getDescribesubjectpiclist();
        nTask1.onchange();
        nTask1.Createtask(); 
        
        
    TaskCreateController nTask2 = new TaskCreateController();
        nTask2.initmethod();
        nTask2.newtask=new Task();
        nTask2.newtask.Query_Type__c='Possession Related';
        nTask2.possessioncomment='test';
        nTask2.getDescribesubjectpiclist();
        nTask2.onchange();
        nTask2.Createtask();
        
    
    TaskCreateController nTask3 = new TaskCreateController();
        nTask3.initmethod();
        nTask3.newtask=new Task();
        nTask3.newtask.Query_Type__c='Lead Related/Event Tracking';
        nTask3.leadcomment='test';
        nTask3.getDescribesubjectpiclist();
        nTask3.onchange();
        nTask3.Createtask();
        
        
    TaskCreateController nTask5 = new TaskCreateController();
        nTask5.initmethod();
        nTask5.newtask=new Task();
        nTask5.customercomment='test';
        nTask5.newtask.Query_Type__c='Customer IT Tools Related';
        nTask5.getDescribesubjectpiclist();
        nTask5.onchange();
        nTask5.Createtask();
        

        
    TaskCreateController nTask6 = new TaskCreateController();
        nTask6.initmethod();
        nTask6.newtask=new Task();
        nTask6.newtask.Query_Type__c='Cancellation Related';
        nTask6.getDescribesubjectpiclist();
        nTask6.onchange();
        nTask6.Createtask();
        
    TaskCreateController nTask7 = new TaskCreateController();
        nTask7.newtask=new Task();  
        nTask7.getDescribesubjectpiclist();
        nTask7.newtask.Query_Type__c='TDS Authorization';
        nTask7.onchange();
        nTask7.TDSAuthorizationcomment='test';
        nTask7.Createtask();

    TaskCreateController nTask8 = new TaskCreateController();
        nTask8.newtask=new Task();  
        nTask8.getDescribesubjectpiclist();
        nTask8.newtask.Query_Type__c='Welcome Call Related';
        nTask8.onchange();
        nTask8.welcomecallcomment='test';
        nTask8.Createtask();
    
    }
    
}