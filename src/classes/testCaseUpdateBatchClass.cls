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
@isTest(SeeAllData=true)
private class testCaseUpdateBatchClass {

    public static testMethod void testCaseUpdatemethod() {
    Test.StartTest();
    
        Profile p = [Select id from Profile where Name = 'Customer Care'];
        
        User u = new User();
        u.LastName = 'TestUser';
        u.Alias = 'tuser';
        u.Email = 'test@test.in';
        u.Username = 'abc_123@test.com';
        u.CommunityNickname = 'Testuser';
        u.ProfileId = p.Id;
        u.TimeZoneSidKey = 'Asia/Kolkata';
        u.LocaleSidKey = 'en_IE_EURO';
        u.EmailEncodingKey = 'ISO-8859-1';
        u.LanguageLocaleKey = 'en_US';
        u.IsActive = true;
        insert u;
        
        /* SAPBookingIDAgentMapping_del__c a=new SAPBookingIDAgentMapping_del__c(Agent_Name__c=u.id,Booking_ID__c='',Building_Name__c='MARINA',Flat_No__c='202',Project_Name__c='CASA Rio',Wing__c='d');
        insert a; */
        //User u = [SELECT ID, username FROM User where isactive=true limit 1];
        
        System.runAs(u){     
        List <Case> caselist = new List<Case>();
          for(integer i = 0; i<5; i++){
             Case c = new Case(
             //origin = 'Web',
                               First_Name__c = 'testFirst'+'i',
                               Last_Name__c = 'testLast'+'i', 
                               Mobile__c = '1234567891',
                               Project__c = 'CASA Rio',
                               Buildings_Name__c = 'MARINA',
                               Wing__c = 'd',
                               Flat_No__c = '202',
                               Interaction_Mode__c='Call',
                               Communication_Type__c='Inbound',
                               Status='Working',
                               Nature_of_Request__c='Request',
                               Request_for_L1__c='Document Related',
                               Request_for_L2__c='Customer wants original document',
                               Request_for_L3_a__c='NOC',
                               Request_for_L3__c=''
                               //Ownerid = u.ID
                               ); 
             caselist.add(c);
            }
            insert caselist;
            
                CaseUpdateBatchClass CaseUpdateBatchClassobj = new CaseUpdateBatchClass();
                CaseUpdateBatchClassobj.query = 'Select c.OwnerId, c.Id, c.Wing__c, c.Project__c,c.Flat_No__c, c.Buildings_Name__c From Case c LIMIT 200';//WHERE ownerid=\'' + u.id + '\' Limit 200';
                ID batchprocessid = Database.executeBatch(CaseUpdateBatchClassobj);
                
                updateBookingIdBatchClass updateBookingIdBatchClassobj = new updateBookingIdBatchClass();
                updateBookingIdBatchClassobj.query = 'Select c.OwnerId, c.Id, c.Wing__c, c.Project__c,c.Flat_No__c, c.Buildings_Name__c From Case c LIMIT 200';//WHERE ownerid=\'' + u.id + '\' Limit 200';
                ID batchprocessid1 = Database.executeBatch(updateBookingIdBatchClassobj);
             
            }
            Test.StopTest(); 
      }
}