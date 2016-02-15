@isTest
private class testCSSCaseCreateController {

static testMethod void myUnitTest() {
        List <Case> caselist = new List<Case>();
        Profile p = [Select id from Profile where Name = 'Custom Overage High Volume Customer Portal'];        
        User u = [Select id from User where ProfileId = :p.id AND NAME Like 'AARTI BALIGA%' LIMIT 1];
        Id ContID = [Select ContactId from User where Id = :u.id].COntactid;
        PageReference pageRef = new PageReference('apex/CSSCaseCreatePage');
        Test.setCurrentPage(pageRef);
        System.runAs(u){
           CSSCaseCreateController CSSCaseCreateControllerobj = new CSSCaseCreateController();
           CSSCaseCreateControllerobj.getNewCase();
           //CSSCaseCreateControllerobj.CRN = '123456';
           CSSCaseCreateControllerobj.contactId = ContID;
           CSSCaseCreateControllerobj.submit();
        }

    }
}