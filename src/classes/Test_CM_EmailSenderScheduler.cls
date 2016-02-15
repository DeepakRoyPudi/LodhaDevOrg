@isTest
  public class  Test_CM_EmailSenderScheduler{
    public static testMethod void testEmailSenderScheduler(){
    
        test.startTest();
       CM_EmailSenderScheduler obj=new CM_EmailSenderScheduler();
              String chron = '0 0 23 * * ?';  
               system.schedule('Test Scheduler', chron, obj);
                test.stopTest();
      
     }
    }