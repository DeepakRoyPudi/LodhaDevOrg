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
private class testScheduleCaseUpdateBatchClass {

    static testMethod void myUnitTest() {
       
       User u = [SELECT ID, username FROM User limit 1];
       
       Test.startTest();
       /*Case c = new Case(origin = 'Web',
	         				   First_Name__c = 'testFirst',
	         				   Last_Name__c = 'testLast', 
	         				   Mobile__c = '1234567891',
	         				   Project__c = 'CASA Bella',
	         				   Buildings_Name__c = 'Eleganta',
	         				   Wing__c = 'A',
	         				   Flat_No__c = '1104',
	                     	   Ownerid = u.ID);
      
      insert c;*/
      
      String jobId = System.schedule('testBasicScheduledApex','0 0 22 ? * 6L', new ScheduleCaseUpdateBatchClass());
      CronTrigger ct = [SELECT id, CronExpression, TimesTriggered, 
         				NextFireTime
         				FROM CronTrigger WHERE id = :jobId];
      System.assertEquals('0 0 22 ? * 6L', ct.CronExpression);
      System.assertEquals(0, ct.TimesTriggered);
      Test.stopTest();
    }
}