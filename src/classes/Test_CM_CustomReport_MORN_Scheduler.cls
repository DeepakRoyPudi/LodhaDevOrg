@isTest
public class  Test_CM_CustomReport_MORN_Scheduler{
    public static testMethod void CM_CustomReportGenerator_MORN_Scheduler(){

        test.startTest();
        
        CM_CustomReportGenerator_MORN_Scheduler obj = new CM_CustomReportGenerator_MORN_Scheduler();
        String chron = '0 0 23 * * ?';  
        System.schedule('Test MORN Scheduler', chron, obj);
        
        test.stopTest();
    }
}