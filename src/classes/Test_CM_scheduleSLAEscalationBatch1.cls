@isTest
public class  Test_CM_scheduleSLAEscalationBatch1 {
    public static testMethod  void testscheduleSLAEscalationBatch (){
    
        test.startTest();
    
        CM_scheduleSLAEscalationBatch obj = new  CM_scheduleSLAEscalationBatch();
        String chron = '0 0 23 * * ?';  
        system.schedule('Test Sched', chron, obj);
    
        test.stopTest();
    }
}