@isTest
public class  Test_CM_ComplaintCaseReportMORNScheduler {
    public static testMethod  void testCM_ComplaintCasesReportMORNScheduler (){
    
        test.startTest();
    
        CM_ComplaintCasesReportMORNScheduler obj = new  CM_ComplaintCasesReportMORNScheduler();
        String chron = '0 0 23 * * ?';  
        system.schedule('Test MORN Scheduler', chron, obj);
    
        test.stopTest();
    }
}