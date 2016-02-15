@isTest
private class testInterestCalculatorController {

    static testMethod void myUnitTest() {
        List <Case> caselist = new List<Case>();
        Profile p = [Select id from Profile where Name = 'System Administrator'];        
        User u = [Select id from User where ProfileId = :p.id LIMIT 1];
       
        PageReference pageRef = new PageReference('apex/InterestCalculator');
        Test.setCurrentPage(pageRef);
        System.runAs(u){
           InterestCalculatorController InterestCalculatorControllerobj = new InterestCalculatorController();
           InterestCalculatorControllerobj.outstandingAmount  = 2000000.00;
           InterestCalculatorControllerobj.intCalc.demand_date__c = System.TODAY()-1 ;
           InterestCalculatorControllerobj.intCalc.payment_date__c = System.TODAY();
           InterestCalculatorControllerobj.getProxyObject();
           InterestCalculatorControllerobj.getInterestAmount();
           //String nextPage = CaseAssignmentController.CaseAssignmentControllerobj().getUrl(); 
           //System.assertEquals('/500/o', nextPage); 
        }

    }
}