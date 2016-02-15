@isTest
private class testCaseIntermediateController {

    static testMethod void myUnitTest() {
        List <Case> caselist = new List<Case>();
        Profile p = [Select id from Profile where Name = 'Custom Overage High Volume Customer Portal'];        
        User u = [Select id from User where ProfileId = :p.id AND NAME Like 'AARTI BALIGA%' LIMIT 1];
        Id ContID = [Select ContactId from User where Id = :u.id].COntactid;
        
        case caserec = new Case(origin = 'Web',
                               First_Name__c = 'testFirst',
                               Last_Name__c = 'testLast', 
                               Mobile__c = '1234567891',
                               Project__c = 'CASA Rio',
                               Buildings_Name__c = 'MARINA',
                               Wing__c = 'd',
                               Flat_No__c = '202',
                               Ownerid = u.ID);
        
        PageReference pageRef = new PageReference('apex/CaseIntermediatePage');
        Test.setCurrentPage(pageRef);
        
        System.runAs(u){
              ApexPages.StandardController sc = new ApexPages.standardController(caserec); 
           CaseIntermediateController  CaseIntermediateControllerobj = new  CaseIntermediateController(sc);
           CaseIntermediateControllerobj.autoAssignment();
        }

    }
    
    static testMethod void myUnitTestAdmin() {
        List <Case> caselist = new List<Case>();
        Profile p = [Select id from Profile where Name = 'System Administrator'];        
        User u = [Select id,accountid from User where ProfileId = :p.id AND IsActive = true LIMIT 1];
        Id ContID = [Select ContactId from User where Id = :u.id].COntactid;
        
        case caserec = new Case(origin = 'Web',
                               First_Name__c = 'testFirst',
                               Last_Name__c = 'testLast', 
                               Mobile__c = '1234567891',
                               Project__c = 'CASA Rio',
                               Buildings_Name__c = 'MARINA',
                               Wing__c = 'd',
                               Flat_No__c = '202',
                               Ownerid = u.ID);
        
        PageReference pageRef = new PageReference('apex/CaseIntermediatePage');
        Test.setCurrentPage(pageRef);
        
        System.runAs(u){
              ApexPages.StandardController sc = new ApexPages.standardController(caserec); 
           CaseIntermediateController  CaseIntermediateControllerobj = new  CaseIntermediateController(sc);
           CaseIntermediateControllerobj.autoAssignment();
        }

    }    
}