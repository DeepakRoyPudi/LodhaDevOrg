@isTest
public class  Test_CM_SummaryReportScheduler {
    public static testMethod  void test_CM_SummaryReportScheduler  (){
    
        test.startTest();
    
        CM_SummaryReportScheduler obj = new  CM_SummaryReportScheduler ();
        String chron = '0 0 23 * * ?';  
        system.schedule('Test Summary Scheduler', chron, obj);
    
        test.stopTest();
    }
}