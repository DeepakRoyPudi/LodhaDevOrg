/* 
Description - This class contains unit tests for validating the 
*               behavior of DocumentsSMSCSS2_0controller class

@Created by: Trupti Dhoka
@Created Date: 6/may/2015

--------------------------------------------------------------------------------
| Modified By      | Modified Date       | Version        | Description         |
--------------------------------------------------------------------------------
|
--------------------------------------------------------------------------------
|
--------------------------------------------------------------------------------
*/

@isTest
public class DocumentsSMSCSS2_0controllerTest {
    
    //method for creating account
    private static Account createAccount(){
        Account objAccount = new Account();
        objAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Booked Account').getRecordTypeId();
        objAccount.FirstName = 'Test1';
        objAccount.LastName = 'Account1';
        objAccount.CRN__c = '154215';
        objAccount.H_Mobile_No__c = '1234560789';
        objAccount.Mobile_Phone__c = '21241222';
        objAccount.Co_Applicant__c = 'test';
        objAccount.Project_Name__c = 'New Cuffe Parade';
        return objAccount;
    } 
    //method for creating community user
    private static User createUser(Account a)
    {
        User objUser = new User();
        contact c=[select id from contact where accountid=:a.id limit 1];
        objUser.ProfileID = [Select Id From Profile Where Name = 'Custom Overage High Volume Customer Portal'].id;
        objUser.EmailEncodingKey = 'ISO-8859-1';
        objUser.LanguageLocaleKey = 'en_US';
        objUser.TimeZoneSidKey = 'America/New_York';
        objUser.LocaleSidKey = 'en_US';
        objUser.FirstName = 'first';
        objUser.LastName = 'last';
        objUser.Username = 'test@appirio.com';
        objUser.CommunityNickname = 'testUser123';
        objUser.Alias = 't1';
        objUser.Email = 'no@email.com';
        objUser.IsActive = true;
        objUser.ContactId = c.id;
        return objUser;
    }  
    
    private static Project_Name__c  createProjectName()
    {
        Project_Name__c objprojectname = new Project_Name__c();
        objprojectname.Name = 'New Cuffe Parade';
        objprojectname.OrderType__c = 'Custom';
        objprojectname.Project_Type__c = 'Hi End / Luxury';
        objprojectname.Record_Type__c ='Residential';
        objprojectname.CSS_Background_Image_URL__c = 'https://cs14.salesforce.com/css/servlet/servlet.FileDownload?file=00PM0000003RzGG';
        return objprojectname;
    }
    //method for creating list of smstype
    private static SmsTypeForRmCss__c createSmsType(String name)
    {
        SmsTypeForRmCss__c smsType = new SmsTypeForRmCss__c(Name= name);
        return smsType;
    }
    //method for creating list of Documents
    private static list<Documents__c> createDoc(Account acc , Integer noOfRecd) {
        list<Documents__c> docList = new list<Documents__c>();
        
        for(Integer i=0 ; i < noOfRecd ; i++ ) {
            docList.add(new Documents__c(Account__c = acc.Id, 
                                         CRN__c = acc.CRN__c,Name='Document1'+i,
                                         Document_Category__c='Allotment Process',
                                         Date_of_Generation__c = DATETIME.now(),
                                         Version__c = '1'));
        }
        
        return docList;
    }
    
    //method for creating list of SMS
    private static list<SMS_History__c> createSMS(Account acc , Integer noOfRecd) {
        list<SMS_History__c> smsList = new list<SMS_History__c>();
        
        for(Integer i=0 ; i < noOfRecd ; i++ ) {
            smsList.add(new SMS_History__c(Account__c = acc.Id, CRN__c = acc.CRN__c,
                                           Mobile_Number__c = '1234567'+i,
                                           SMS_Text__c = 'Test SMS',
                                           Status__c = 'Sent',
                                           Created_Date__c = DATETIME.now(),
                                           SMS_Type__c = 'Cheque Bounce'));
        }
        
        return smsList;
    }
    
    //method for creating list of Dispatch
    
    private static list<Despatch__c> createDispatch(Account acc , Integer noOfRecd) {
        list<Despatch__c> dispatchList = new list<Despatch__c>();
        
        for(Integer i=0 ; i < noOfRecd ; i++ ) {
            dispatchList.add(new Despatch__c(Account__c = acc.Id, 
                                             Despatch_Date__c = system.today() + i,
                                             Waybill_No__c = '3454554'+i,
                                             Courier_Name__c = 'Test',
                                             Contents__c = 'Test',
                                             Last_Delivery_Status__c = 'Sent'
                                            ));
        }
        
        return dispatchList;
    }
    
    private static void admindocumentTypeSelection()
    {
        AdminDocumentTypeSelectionTest.PicklistValues=new List<AdminDocumnetCategory__c>();
        //craete custom setting data category 
        List<AdminDocumnetCategory__c> allReadyExitingDocument= 
            AdminDocumentTypeSelectionTest.insertDocumentTypesFromField();
        system.debug('allReadyExitingDocument***'+allReadyExitingDocument);
        AdminWidgetCustomizationController controller=new AdminWidgetCustomizationController();
        AdminDocumentTypeSelection adts=new AdminDocumentTypeSelection(controller);
        
        System.assertEquals(adts.documentForRight.size(),allReadyExitingDocument.size());
        System.assertEquals(adts.documentForLeft.size(),
                            AdminDocumentTypeSelectionTest.PicklistValues.size()-
                            allReadyExitingDocument.size()
                           );
        
        adts.getLeftValues();
        adts.getRightValues();
        adts.leftSelectedValues=new List<String>(adts.documentForLeft);
        adts.selectclick();
        adts.saveDocumentType();
        
        /*
        assert for all the picklist vaues As select and saved 
        and now stored in custom setting so that the size must be equal
        */
        
        System.assertEquals( adts.documentForRight.size(),
                            AdminDocumnetCategory__c.getAll().values().size() 
                           );
        
    }
    private static  void admindocumentNameSelection() {
        //craete custom setting data category 
        AdminDocumentNameSelectionTest.masterLabelListValues=new List<AdminDocumentName__c>();
        //craete custom setting data category 
        List<AdminDocumentName__c> allReadyExitingDocument = 
            AdminDocumentNameSelectionTest.insertDocumentNamesFromMasterListCustomSetting();
        
        AdminWidgetCustomizationController controller = new AdminWidgetCustomizationController();
        AdminDocumentNameSelection docNameObj = new AdminDocumentNameSelection(controller);
        
        System.assertEquals(docNameObj.documentForRight.size(),allReadyExitingDocument.size());
        System.assertEquals(docNameObj.documentForLeft.size(),
                            AdminDocumentNameSelectionTest.masterLabelListValues.size()-
                            allReadyExitingDocument.size()
                           );
        
        docNameObj.getLeftNameValues();
        docNameObj.getRightNameValues();
        docNameObj.leftSelectedNameValues = new List<String>(docNameObj.documentForLeft);
        docNameObj.selectClickName();
        docNameObj.saveDocumentName();
        
        /*
        assert for all the master label values As select and saved 
        and now stored in custom setting so that the size must be equal
        */
        
        System.assertEquals( docNameObj.documentForRight.size(),
                            AdminDocumentName__c.getAll().values().size() 
                           );
    }
    static testMethod void documenttest() {
        
        Map < Integer, Documents__c > docMap = new Map < Integer, Documents__c > ();
        //craete custom setting data category and name 
        admindocumentTypeSelection();
        admindocumentNameSelection();
        //create account
        Account objAccount = createAccount();
        insert objAccount;
        
        //create user
        User u = createUser(objAccount);
        insert u;
        
        //create doc records
        list<Documents__c> docList = createDoc(objAccount,11);
        insert doclist;
        
        Project_Name__c projectname = createProjectName();
        insert projectname;
        
        CSSBackgroundImageSetting__c projimage = new  CSSBackgroundImageSetting__c(name='Project Wise',
                                                                                   Project_Wise__c=true);
        insert projimage;
        
        system.runAs(u)
        {
            
            test.StartTest();
            DocumentsSMSCSS2_0controller docsms_csscontroller = new DocumentsSMSCSS2_0controller();
            GoogleAnalyticsHelper googleanalytics = new GoogleAnalyticsHelper();
            CreateQueryHelper queryhelper = new CreateQueryHelper();
            ApexPages.CurrentPage().getparameters().put('currenttab','Document');
            docsms_csscontroller.Customer_CRN = objAccount.CRN__c;
            docsms_csscontroller.docMap =docMap;
            docsms_csscontroller.sortDir='desc NULLS Last';
            docsms_csscontroller.doc_sortField='Date_of_Generation__c';
            system.assertEquals(docsms_csscontroller.Customer_CRN, objAccount.CRN__c);
            
            docsms_csscontroller.toggleSortDoc();
            System.assertEquals(10,docsms_csscontroller.lstDocuments_detailview.size());
            
            docsms_csscontroller.FirstPage();
            System.assertEquals(0,docsms_csscontroller.OffsetSize);
            
            System.assertEquals(true,docsms_csscontroller.getprev());
            
            docsms_csscontroller.next();
            System.assertEquals(10,docsms_csscontroller.OffsetSize);
            
            docsms_csscontroller.previous();
            
            System.assertEquals(0,docsms_csscontroller.OffsetSize);
            
            docsms_csscontroller.LastPageDoc();
            System.assertEquals(false,docsms_csscontroller.getprev());
            System.assertEquals(true,docsms_csscontroller.getnxtDoc());
            
            //check wheter current active tab is 'Document'
            system.assertEquals(docsms_csscontroller.queryString, 'Document');
            docsms_csscontroller.fromDateSearch.Date_of_Generation__c = system.Today();
            docsms_csscontroller.toDateSearch.Date_of_Generation__c = system.Today();
            docsms_csscontroller.docname.Name = 'Document1';
            docsms_csscontroller.selectedSmsType = '--None--';
            docsms_csscontroller.docname.Document_Category__c ='Welcome Process';
            docsms_csscontroller.searchByFilter();
            
            docsms_csscontroller.resetOnTabChange();
            
            docsms_csscontroller.fromDateSearch.Date_of_Generation__c = system.Today() + 5;
            docsms_csscontroller.toDateSearch.Date_of_Generation__c = system.Today();
            docsms_csscontroller.searchByFilter();
            test.StopTest();
        }
    }
    //negative test case for DocTest
    static testMethod void Negativedocumenttest() {
        
        admindocumentTypeSelection();
        admindocumentNameSelection();
        //create account
        Account objAccount = createAccount();
        insert objAccount;
        
        //create user
        User u = createUser(objAccount);
        insert u;
        
        list<Documents__c> docList = new list<Documents__c>();
        Map < Integer, Documents__c > docMap = new Map < Integer, Documents__c > ();
        
        system.runAs(u)
        {
            
            test.StartTest();
            DocumentsSMSCSS2_0controller docsms_csscontroller = new DocumentsSMSCSS2_0controller();
            GoogleAnalyticsHelper googleanalytics = new GoogleAnalyticsHelper();
            CreateQueryHelper queryhelper = new CreateQueryHelper();
            
            ApexPages.CurrentPage().getparameters().put('currenttab','Document');
            
            docsms_csscontroller.Customer_CRN = objAccount.CRN__c;
            docsms_csscontroller.lstDocuments_detailview = null;
            docsms_csscontroller.docMap =null;
            docsms_csscontroller.doc_sortField=null;
            
            
            system.assertEquals(docsms_csscontroller.Customer_CRN, objAccount.CRN__c);
            System.assertEquals(10,docsms_csscontroller.lstDocuments_detailview.size());
            
            docsms_csscontroller.toggleSortDoc();
            System.assertEquals(0,docsms_csscontroller.docMap.size());
            
            docsms_csscontroller.FirstPage();
            System.assertEquals(0,docsms_csscontroller.OffsetSize);
            
            docsms_csscontroller.previous();
            System.assertEquals(-10,docsms_csscontroller.OffsetSize);
            
            docsms_csscontroller.next();
            System.assertEquals(0,docsms_csscontroller.OffsetSize);
            
            docsms_csscontroller.LastPageDoc();
            System.assertEquals(-10,docsms_csscontroller.OffsetSize);
            
            System.assertEquals(false,docsms_csscontroller.getprev());
            System.assertEquals(true,docsms_csscontroller.getnxtDoc());
            
            //check wheter current active tab is 'Document'
            system.assertEquals(docsms_csscontroller.queryString, 'Document');
            
            docsms_csscontroller.searchByFilter();
            docsms_csscontroller.activetab = 'doc';
            docsms_csscontroller.resetOnTabChange();
            test.StopTest();
        }
    }
    
    
    static testMethod void Positivesmstest() {
        
        map <integer, SMS_History__c> smsMap = new map < integer, SMS_History__c > ();
        
        //create account
        Account objAccount = createAccount();
        insert objAccount;
        
        //create user
        User u = createUser(objAccount);
        insert u;
        
        SmsTypeForRmCss__c rec_BookingCreation = createSmsType('Booking Creation');
        Insert rec_BookingCreation;
        
        SmsTypeForRmCss__c rec_ChequeBounce = createSmsType('Cheque Bounce'); 
        Insert rec_ChequeBounce;
        
        
        //create list of SMs
        list<SMS_History__c> smslist = createSMS(objAccount , 6);
        insert smslist;
        
        system.runAs(u)
        {
            
            test.StartTest();
            DocumentsSMSCSS2_0controller docsms_csscontroller = new DocumentsSMSCSS2_0controller();
            GoogleAnalyticsHelper googleanalytics = new GoogleAnalyticsHelper();
            CreateQueryHelper queryhelper = new CreateQueryHelper();
            
            ApexPages.CurrentPage().getparameters().put('currenttab','Document');
            
            docsms_csscontroller.Customer_CRN = objAccount.CRN__c;
            docsms_csscontroller.lstSMS_DetailView = smslist;
            docsms_csscontroller.smsMap =smsMap;
            docsms_csscontroller.sortDir='desc NULLS Last';
            docsms_csscontroller.sms_sortField='Created_Date__c';
            
            system.assertEquals(docsms_csscontroller.Customer_CRN, objAccount.CRN__c);
            System.assertEquals(10,docsms_csscontroller.lstSMS_DetailView.size());
            
            docsms_csscontroller.toggleSortSms();
            System.assertEquals(0,docsms_csscontroller.smsMap.size());
            
            docsms_csscontroller.FirstPage();
            System.assertEquals(0,docsms_csscontroller.OffsetSize);
            
            docsms_csscontroller.previous();
            System.assertEquals(-10,docsms_csscontroller.OffsetSize);
            
            docsms_csscontroller.next();
            System.assertEquals(0,docsms_csscontroller.OffsetSize);
            
            docsms_csscontroller.LastPage();
            System.assertEquals(-10,docsms_csscontroller.OffsetSize);
            
            System.assertEquals(false,docsms_csscontroller.getprev());
            System.assertEquals(true,docsms_csscontroller.getnxt());
            
            //check wheter current active tab is 'Document'
            
            system.assertEquals(docsms_csscontroller.queryString, 'Document');
            docsms_csscontroller.getSMSTypes();
            system.assertEquals(docsms_csscontroller.getSMSTypes().size(), 3);
            
            docsms_csscontroller.selectedSmsType = 'Cheque Bounce';
            docsms_csscontroller.smsfromdate.Created_Date__c = system.now();
            docsms_csscontroller.smstodate.Created_Date__c = system.now();
            docsms_csscontroller.searchbySMSType();
            
            docsms_csscontroller.selectedSmsType = '--None--';
            docsms_csscontroller.smsfromdate.Created_Date__c = system.now()+15;
            docsms_csscontroller.smstodate.Created_Date__c = system.now();
            docsms_csscontroller.searchbySMSType();
            docsms_csscontroller.resetOnTabChange();
            test.StopTest();
        }
    }
    
    //Negative sms test - with no search criteria
    static testMethod void Negativesmstest() {
        
        
        //create account
        Account objAccount = createAccount();
        insert objAccount;
        
        //create user
        User u = createUser(objAccount);
        insert u;
        
        //create list of SMs
        list<SMS_History__c> smslist = new list<SMS_History__c>();
        map <integer, SMS_History__c> smsMap = new map < integer, SMS_History__c > ();
        
        
        system.runAs(u)
        {
            test.StartTest();
            DocumentsSMSCSS2_0controller docsms_csscontroller = new DocumentsSMSCSS2_0controller();
            GoogleAnalyticsHelper googleanalytics = new GoogleAnalyticsHelper();
            CreateQueryHelper queryhelper = new CreateQueryHelper();
            
            ApexPages.CurrentPage().getparameters().put('currenttab','Document');
            
            docsms_csscontroller.Customer_CRN = objAccount.CRN__c;
            docsms_csscontroller.lstSMS_DetailView = null;
            docsms_csscontroller.smsMap =null;
            docsms_csscontroller.sortDir=null;
            docsms_csscontroller.sms_sortField=null;
            
            system.assertEquals(docsms_csscontroller.Customer_CRN, objAccount.CRN__c);
            System.assertEquals(10,docsms_csscontroller.lstSMS_DetailView.size());
            
            docsms_csscontroller.toggleSortSms();
            System.assertEquals(0,docsms_csscontroller.smsMap.size());
            
            docsms_csscontroller.FirstPage();
            System.assertEquals(0,docsms_csscontroller.OffsetSize);
            
            docsms_csscontroller.previous();
            System.assertEquals(-10,docsms_csscontroller.OffsetSize);
            
            docsms_csscontroller.next();
            System.assertEquals(0,docsms_csscontroller.OffsetSize);
            
            docsms_csscontroller.LastPage();
            System.assertEquals(-10,docsms_csscontroller.OffsetSize);
            
            System.assertEquals(false,docsms_csscontroller.getprev());
            System.assertEquals(true,docsms_csscontroller.getnxt());
            
            //check wheter current active tab is 'Document'
            system.assertEquals(docsms_csscontroller.queryString, 'Document');
            docsms_csscontroller.searchbySMSType();
            docsms_csscontroller.activetab = 'sms';
            docsms_csscontroller.resetOnTabChange();
            test.StopTest();
        }
    }
    
    
    static testMethod void Positivedispatchtest() {
        
        map <integer, Despatch__c>dispatchMap = new map < integer, Despatch__c > (); 
        
        //create account
        Account objAccount = createAccount();
        insert objAccount;
        
        //create user
        User u = createUser(objAccount);
        insert u;
        
        //create list of SMs
        list<Despatch__c> dispatchlist = createDispatch(objAccount , 6);
        insert dispatchlist;
        
        system.runAs(u)
        {
            
            test.StartTest();
            DocumentsSMSCSS2_0controller docsms_csscontroller = new DocumentsSMSCSS2_0controller();
            GoogleAnalyticsHelper googleanalytics = new GoogleAnalyticsHelper();
            CreateQueryHelper queryhelper = new CreateQueryHelper();
            
            ApexPages.CurrentPage().getparameters().put('currenttab','Document');
            
            docsms_csscontroller.Customer_CRN = objAccount.CRN__c;
            docsms_csscontroller.lstDispatch_DetailView = dispatchlist;
            docsms_csscontroller.dispatchMap =dispatchMap;
            docsms_csscontroller.sortDir='desc NULLS Last';
            docsms_csscontroller.dispatch_sortField='Despatch_Date__c';
            
            system.assertEquals(docsms_csscontroller.Customer_CRN, objAccount.CRN__c);
            System.assertEquals(10,docsms_csscontroller.lstDispatch_DetailView.size());
            
            docsms_csscontroller.toggleSortDispatch();
            System.assertEquals(6,docsms_csscontroller.dispatchMap.size());
            
            docsms_csscontroller.FirstPage();
            System.assertEquals(0,docsms_csscontroller.OffsetSize);
            
            docsms_csscontroller.previous();
            System.assertEquals(-10,docsms_csscontroller.OffsetSize);
            
            docsms_csscontroller.next();
            System.assertEquals(0,docsms_csscontroller.OffsetSize);
            
            docsms_csscontroller.LastPageDispatch();
            System.assertEquals(-10,docsms_csscontroller.OffsetSize);
            
            System.assertEquals(false,docsms_csscontroller.getprev());
            System.assertEquals(false,docsms_csscontroller.getnxtDispatch());
            
            //check wheter current active tab is 'Document'
            system.assertEquals(docsms_csscontroller.queryString, 'Document');
            docsms_csscontroller.dispatch.Contents__c = 'Test';
            docsms_csscontroller.dispatch.Last_Delivery_Status__c = 'sent';
            docsms_csscontroller.dispatchDateFrom.Despatch_Date__c = system.today();
            docsms_csscontroller.dispatchDateTo.Despatch_Date__c = system.today();
            docsms_csscontroller.searchDispatch();
            docsms_csscontroller.resetOnTabChange();
            docsms_csscontroller.dispatchDateFrom.Despatch_Date__c = system.today() +7;
            docsms_csscontroller.dispatchDateTo.Despatch_Date__c = system.today();
            docsms_csscontroller.searchDispatch();
            test.StopTest();
        }
    }
    
    static testMethod void Negativedispatchtest() {
        
        
        //create account
        Account objAccount = createAccount();
        insert objAccount;
        
        //create user
        User u = createUser(objAccount);
        insert u;
        
        //create list of SMs
        list<Despatch__c> dispatchlist = new list<Despatch__c> ();
        map <integer, Despatch__c>dispatchMap = new map < integer, Despatch__c > (); 
        
        system.runAs(u)
        {
            
            test.StartTest();
            DocumentsSMSCSS2_0controller docsms_csscontroller = new DocumentsSMSCSS2_0controller();
            GoogleAnalyticsHelper googleanalytics = new GoogleAnalyticsHelper();
            CreateQueryHelper queryhelper = new CreateQueryHelper();
            
            ApexPages.CurrentPage().getparameters().put('currenttab','Document');
            
            docsms_csscontroller.Customer_CRN = objAccount.CRN__c;
            docsms_csscontroller.lstDispatch_DetailView = null;
            docsms_csscontroller.dispatchMap =null;
            docsms_csscontroller.sortDir=null;
            docsms_csscontroller.dispatch_sortField=null;
            
            system.assertEquals(docsms_csscontroller.Customer_CRN, objAccount.CRN__c);
            System.assertEquals(10,docsms_csscontroller.lstDispatch_DetailView.size());
            
            docsms_csscontroller.toggleSortDispatch();
            System.assertEquals(0,docsms_csscontroller.dispatchMap.size());
            
            docsms_csscontroller.FirstPage();
            System.assertEquals(0,docsms_csscontroller.OffsetSize);
            
            docsms_csscontroller.previous();
            System.assertEquals(-10,docsms_csscontroller.OffsetSize);
            
            docsms_csscontroller.next();
            System.assertEquals(0,docsms_csscontroller.OffsetSize);
            
            docsms_csscontroller.LastPageDispatch();
            System.assertEquals(-10,docsms_csscontroller.OffsetSize);
            
            System.assertEquals(false,docsms_csscontroller.getprev());
            System.assertEquals(true,docsms_csscontroller.getnxtDispatch());
            
            //check wheter current active tab is 'Document'
            system.assertEquals(docsms_csscontroller.queryString, 'Document');
            docsms_csscontroller.searchDispatch();
            docsms_csscontroller.activetab = 'dispatch';
            docsms_csscontroller.resetOnTabChange();
            test.StopTest();
        }
    }
}