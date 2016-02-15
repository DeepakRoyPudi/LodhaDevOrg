/*
*        Description : Test Class for NotesAndAttachmentRLAccountController
*
*        Version     Date          Author             Description
*        1.0         05/08/2014    Asmita(Eternus)    Intial Draft
*/

@isTest
private class NotesAndAttachmentOnAccntControllerTest {

    static testMethod void AttachmentonAccountTest() {
    	
    	ApexPages.StandardController sc;
        NotesAndAttachmentRLOnAccountController objAttachmentRelatedList;
        
        // Creating Account
        List<Account> listAccount = NotesAndAttachmentOnAccntControllerTest.getAccountRecord(1);
        insert listAccount;

        List<Attachment> listAttachment = NotesAndAttachmentOnAccntControllerTest.getAttachmentRecord(1);
        listAttachment[0].ParentId = listAccount[0].Id;
        insert listAttachment;

        sc = new ApexPages.StandardController(listAccount[0]);
        objAttachmentRelatedList = new NotesAndAttachmentRLOnAccountController(sc);

        objAttachmentRelatedList.toggleSort();
        
        objAttachmentRelatedList.searchName = 'testFile*';
        ApexPages.currentPage().getParameters().put('attachId', listAttachment[0].Id); 

        System.assertEquals('https://cs8.salesforce.com/' + listAttachment[0].Id, objAttachmentRelatedList.openAttachment().getUrl());
        System.assertEquals('https://cs8.salesforce.com/' + listAttachment[0].Id + '/e?retURL=%2F' + listAccount[0].Id, objAttachmentRelatedList.editAttachment().getUrl());
        System.assertEquals(null, objAttachmentRelatedList.searchByFilter());
        System.assertEquals(null, objAttachmentRelatedList.attachFile());
        System.assertEquals(null, objAttachmentRelatedList.viewAll());
        System.assertEquals(null, objAttachmentRelatedList.attachFile());
        objAttachmentRelatedList.listAttachment.add(listAttachment[0]);
        System.assertEquals(null, objAttachmentRelatedList.deleteAttachment());
    }
    
    // Creating Account records
    public static List<Account> getAccountRecord(Integer pNumberOfRecords){
        
        Account oAcc = new Account();
        List<Account> listAccount = new List<Account>();
        
        for(Integer i = 0 ; i < pNumberOfRecords; i++){
            
            oAcc = new Account();
            oAcc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            oAcc.LastName = 'Test Trigger';
            oAcc.FirstName = 'Test';
            oAcc.Mobile_Phone__c = '9211111111';
            
            listAccount.add(oAcc);
        }
        
        return listAccount;
    }// end of getAccountRecords
    
    // Creating Attachments
    public static List<Attachment> getAttachmentRecord(Integer pNumberOfRecords){
    
	    Attachment oAttach = new Attachment();
	    List<Attachment> listAttachment = new List<Attachment>();
	
	    for(Integer i = 0; i < pNumberOfRecords; i++){
	    
		    oAttach = new Attachment();
		
		    oAttach.Name = 'testFile';
		    oAttach.Description = 'test description';
		    oAttach.Body = Blob.valueOf('Test File Contents');
		
		    listAttachment.add(oAttach);
        }
	
	    return listAttachment;
    }
}