@isTest
public class  Test_CM_CustomReport_EVEN_Scheduler{
    public static testMethod void CM_CustomReportGenerator_EVEN_Scheduler(){

        test.startTest();
        
        CM_CustomReportGenerator_EVEN_Scheduler obj = new CM_CustomReportGenerator_EVEN_Scheduler();
        String chron = '0 0 23 * * ?';  
        System.schedule('Test EVEN Scheduler', chron, obj);
        
        test.stopTest();
    }
}