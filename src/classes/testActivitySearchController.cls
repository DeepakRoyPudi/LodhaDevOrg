@isTest
private class testActivitySearchController {    
    static testMethod void myUnitTest() {
    
        Profile p = [Select id from Profile where Name = 'Customer Care Dombivali 1'];
        User u = [Select id,accountid from User where ProfileId = :p.id AND IsActive = true LIMIT 1];
        //Account a = [Select id from Account WHERE RecordType.name = 'Booked Account' LIMIT 1];
        //Contact c = [Select id from Contact where Accountid = :a.id];
        // 1.0 Asmita 18/11/2014
        List<Account> a = testActivitySearchController.getAccountRecord(1);
        insert a;
        Contact c = [Select id from Contact where Accountid = :a[0].id];
        /*List<Contact> c = testActivitySearchController.getContactRecord(1);
        c[0].AccountId = a[0].Id;
        insert c;*/
        //system.debug('user details: '+u.id);
        //system.debug('user acc: '+u.accountid);
        ActivitySearchController ext;
        Task t;
        // System.runAs(u){
            t = new task();
            t.Subject='Test Object 1';
            t.Query_Type__c='Payment Related';
            t.Status='open';
            t.Priority='Normal';
            insert t;
            
            PageReference pageRef = Page.searchActivities;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('accid', a[0].id);
            ApexPages.currentPage().getParameters().put('subject', 'email');
            ApexPages.currentPage().getParameters().put('queryType', 'Payment');
            ApexPages.currentPage().getParameters().put('querySubtype', 'Payment');

            ActivitySearchController ActivitySearchControllerobj = new ActivitySearchController();
            ActivitySearchControllerobj.toggleSort();
            ActivitySearchControllerobj.runQuery();
            ActivitySearchControllerobj.runSearch();
            ActivitySearchControllerobj.contid = c.id;
            
            ApexPages.StandardController con = new ApexPages.StandardController(t);
            ext = new ActivitySearchController(con);
            
       // }
    }
    
    // Creating Account records
    public static List<Account> getAccountRecord(Integer pNumberOfRecords){
        
        Account oAcc = new Account();
        List<Account> listAccount = new List<Account>();
        
        for(Integer i = 0 ; i < pNumberOfRecords; i++){
            
            oAcc = new Account();
            oAcc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Booked Account').getRecordTypeId();
            oAcc.LastName = 'TestAccount';
            oAcc.Mobile_Phone__c = '9211111111';
            oAcc.CRN__c = '12345';
            
            listAccount.add(oAcc);
        }
        
        return listAccount;
    }// end of getAccountRecords
    
    // Creating Account records
    public static List<Contact> getContactRecord(Integer pNumberOfRecords){
        
        Contact oCon = new Contact();
        List<Contact> listContact = new List<Contact>();
        
        for(Integer i = 0 ; i < pNumberOfRecords; i++){
            
            oCon = new Contact();
            oCon.LastName = 'TestContact';
            
            listContact.add(oCon);
        }
        
        return listContact;
    }// end of getAccountRecords
}