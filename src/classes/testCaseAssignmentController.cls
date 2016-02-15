/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class testCaseAssignmentController {

    static testMethod void myUnitTest() {
    	List <Case> caselist = new List<Case>();
    	Profile p = [Select id from Profile where Name = 'System Administrator'];
    	
    	User u = [Select id from User where ProfileId = :p.id LIMIT 1];
       for(integer i = 0; i<200; i++){
             Case c = new Case(origin = 'Web',
                               First_Name__c = 'testFirst'+'i',
                               Last_Name__c = 'testLast'+'i', 
                               Mobile__c = '1234567891',
                               Project__c = 'CASA Rio',
                               Buildings_Name__c = 'MARINA',
                               Wing__c = 'd',
                               Flat_No__c = '202',
                               Ownerid = u.ID); 
             caselist.add(c);
            }
       PageReference pageRef = new PageReference('/500/o');
       Test.setCurrentPage(pageRef);
       System.runAs(u){
	       CaseAssignmentController CaseAssignmentControllerobj = new CaseAssignmentController(new ApexPages.StandardSetController(caselist));
	       CaseAssignmentControllerobj.autoAssignment();
	       //String nextPage = CaseAssignmentController.CaseAssignmentControllerobj().getUrl(); 
	       //System.assertEquals('/500/o', nextPage); 
       }

    }
}