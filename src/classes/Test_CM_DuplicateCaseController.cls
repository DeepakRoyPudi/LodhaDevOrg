@isTest(SeeAllData=true)
public class  Test_CM_DuplicateCaseController {
    public static testMethod  void testDuplicateCaseController (){
        
        id recTypeChildCaseId =  [SELECT Id,Name FROM RecordType WHERE Name = 'CM_Child_Case' LIMIT 1].id;
        
        Case c = [Select id, isDuplicate__c, RecordTypeId, Existing_Parent_Case__c  from Case Where AccountId != null AND RecordTypeId =: recTypeChildCaseId LIMIT 1];
        
        Case c1 =[Select id, isDuplicate__c, RecordTypeId, Existing_Parent_Case__c  from Case Where AccountId != null AND RecordTypeId =: recTypeChildCaseId LIMIT 1];
               
         
        PageReference pageRef = Page.CM_ParentCaseCreatePage;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('caseid', c1.id);
         
        ApexPages.StandardController stdCon = new ApexPages.StandardController(c);
        CM_DuplicateCaseController obj= new CM_DuplicateCaseController(stdCon);
        obj.caseUpdate.Existing_Parent_Case__c = c.Id;
        obj.Save();

    } 
}