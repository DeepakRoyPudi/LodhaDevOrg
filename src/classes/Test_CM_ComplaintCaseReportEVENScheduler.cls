@isTest
public class  Test_CM_ComplaintCaseReportEVENScheduler {
    public static testMethod  void testCM_ComplaintCasesReportEVENScheduler (){
    
        test.startTest();
    
        CM_ComplaintCasesReportEVENScheduler obj = new  CM_ComplaintCasesReportEVENScheduler();
        String chron = '0 0 23 * * ?';  
        system.schedule('Test EVEN Scheduler', chron, obj);
    
        test.stopTest();
    }
}