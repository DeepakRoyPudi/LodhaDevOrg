@isTest(SeeAllData=true)
public class  Test_CM_TAT_CalculationController {
    public static testMethod  void testTATCalculationController  (){
        
        
        List<case> a=[SELECT Id, Communication_Type__c, Queue_Id__c,OwnerId,CreatedById,AccountId,Account.Name,CreatedBy.name,caseNumber,Mobile_Phone__c, OldOwnerId__c, Status, BusinessHoursId, RecordTypeId, Request_for_L1__c,Request_for_L2__c, Request_for_L3_a__c, Request_for_L3__c, Queue_Name__c, CreatedDate, Remaining_Hours__c, CM_TAT__c, ParentId, Nature_of_Request__c, TL__c, TL_EmailId__c, PIC_EmailId__c,Initial_Remarks__c FROM Case where (RecordType.name='CM_Dummy_Parent' OR RecordType.name='CM_Parent_Only') limit 1];
        List<case> b=[SELECT Id, Communication_Type__c, Queue_Id__c,OwnerId,CreatedById,AccountId,Account.Name,CreatedBy.name,caseNumber,Mobile_Phone__c, OldOwnerId__c, Status, BusinessHoursId, RecordTypeId, Request_for_L1__c,Request_for_L2__c, Request_for_L3_a__c, Request_for_L3__c, Queue_Name__c, CreatedDate, Remaining_Hours__c, CM_TAT__c, ParentId, Nature_of_Request__c, TL__c, TL_EmailId__c, PIC_EmailId__c  FROM Case WHERE RecordType.name='CM_Child_Case' OR RecordType.name='CM_Action_Item' limit 1];
        
        CM_TAT_CalculationController caseTAT = new CM_TAT_CalculationController();
        caseTAT.parentTatCal(a);
        caseTAT.childTatCal(b);
        caseTAT.updateParentCase(a);
        caseTAT.duplicateTatCal(a);
    }
}