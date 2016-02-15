@isTest
public class  Test_CM_Dynamic_Case_Access{
    public static testMethod  void testDynamicCaseAccess (){
        test.startTest();

        Id user = [select id, name from User where alias ='ljohn' LIMIT 1].id;
        Case c1= new Case();
        c1.ownerid = user;
        List<Case> caseList1 = new List <Case>();
        caseList1.add(c1);
        
        

        CM_Dynamic_Case_Access obj = new CM_Dynamic_Case_Access();
        obj.childCaseInsert(caseList1);
        
        Case c2 = c1.clone();
        Id userId = [select id, name from User where alias ='rich' LIMIT 1].id;

        c2.OldOwnerId__c = userId;
        List<Case> caseList2 = new List<Case>();
        caseList2.add(c2);
        obj.childCaseUpdate(caseList1, caseList2);


        test.stopTest();  
    }
}