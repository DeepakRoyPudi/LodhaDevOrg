/*
*    Description : Test class for CM_ParentCaseCreatePageController
*
*    Version    Date          Author            Description
*    1.0        11/12/2013    Admin Bhargava    Initial Draft
*    1.1        08/18/2014    Asmita            Modified the code to get the code coverage of CM_ParentCaseCreatePage more than 75% which is currently 58%
*    1.2        09/10/2014    Asmita            Modified the code to get the test code coverage of CM_ChildCaseCreatePage more than 75%
*/

@isTest(SeeAllData=true)
public class  Test_CM_ParentCaseCreatePageController {
    public static testMethod  void testParentCaseCreation(){

        test.startTest(); 
        id RTId = [Select id from RecordType where Name = 'Person Account' LIMIT 1].id;
    
        Account a = new Account(LastName = 'testingFirstacc',
                                Recordtypeid = RTId ,     
                                PersonMobilePhone = '1234567890',
                                PersonEmail = 'testing@test.com'
                                );  
        insert a; 
        
        // 1.1 Modified- Asmita 08/18/2014
        // Creating Opportunity of related account to create a Booking Information so as to call the getFlatlst method
        // Inserting Project name
        List<Project_Name__c> listProjectName = Test_CM_ParentCaseCreatePageController.createProjectNameRecord(1);
        insert listProjectName;
        
        // Inserting Cluster
        List<Cluster__c> listCluster = Test_CM_ParentCaseCreatePageController.createClusterRecords(1);
        listCluster[0].Project_Name__c = listProjectName[0].Id;
        insert listCluster;
        
        // Inserting Wing Record
        List<Wing__c> listWing = Test_CM_ParentCaseCreatePageController.createWingRecords(1);
        listWing[0].Cluster__c = listCluster[0].Id;
        insert listWing;
        
        // Inserting dlat record
        List<Flat__c> listFlat = Test_CM_ParentCaseCreatePageController.createFlatRecord(1);
        listFlat[0].Wing__c = listWing[0].Id;
        insert listFlat;
        
        // Inserting Oportunity
        List<Opportunity> listOpportunity = Test_CM_ParentCaseCreatePageController.createOpportunityRecords(1);
        listOpportunity[0].AccountId = a.Id;
        listOpportunity[0].Project_Name__c = listProjectName[0].Id;
        insert listOpportunity;
        
        // Inserting Booking Information
        List<Booking_Information__c> listBookingInfo = Test_CM_ParentCaseCreatePageController.createBookingInfoRecords(1);
        listBookingInfo[0].Name_Of_Opportunity__c = listOpportunity[0].Id;
        listBookingInfo[0].Unique_booking_Id__c = listFlat[0].Id;
        insert listBookingInfo;
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Customer Care' limit 1];
    
        User u1 = new User();
        u1.Email = 'email1@email.com';
        u1.Alias = 'Alias2';
        u1.TimeZoneSidKey = 'America/New_York';
        u1.LocaleSidKey = 'ca';
        u1.EmailEncodingKey = 'UTF-8';
        u1.ProfileId = p.id;
        u1.LanguageLocaleKey = 'en_US';
        u1.FirstName = 'firstname1';
        u1.LastName = 'lastname1';
        u1.username= 'username1@first.com';
        insert u1;

        
        
        case c=new case();
        System.Debug('Test Accoyunt'+a.Id);
        
        ApexPages.currentPage().getParameters().put('acctId', a.Id);
        ApexPages.currentPage().getParameters().put('oppid', listOpportunity[0].Id);

        ApexPages.StandardController stdCon = new ApexPages.StandardController(c);
        CM_ParentCaseCreatePageController obj1 = new CM_ParentCaseCreatePageController(stdCon);
        obj1.parentCaseType='Single Request';
        obj1.ParentCase();
        obj1.caseCreate.AccountId=a.id;
        obj1.caseCreate.Interaction_Mode__c='Call';
        obj1.caseCreate.Communication_Type__c='Inbound';
        obj1.caseCreate.Nature_of_Request__c='Complaint';
        obj1.caseCreate.OwnerId=u1.id;
        obj1.OnNatureOfRequestChange();
        obj1.caseCreate.Case_Summary__c='Test';
        obj1.caseCreate.Case_Resolution__c='Test';
        // 1.2 Asmita
        obj1.caseCreate.Request_for_L1__c='Cancellation Related';
        obj1.OnL1Change();
        obj1.caseCreate.Request_for_L2__c='Procedural Information';
        obj1.caseCreate.Request_for_L3__c='Documentation';
        obj1.caseCreate.Request_for_L3_a__c=''; 
        obj1.OnChange();          
        
        obj1.Back();
        obj1.SaveParentCase();
        obj1.CreateSubCase();
        obj1.CancelReq();
        obj1.OnL2Change();
        
        List<selectoption> listFlatOption = obj1.getflatLst();
        
        c=new case();
        ApexPages.currentPage().getParameters().put('acctId', a.Id);
        
        stdCon = new ApexPages.StandardController(c);
        CM_ParentCaseCreatePageController obj2 = new CM_ParentCaseCreatePageController(stdCon);
        obj2.parentCaseType='Single Request';
        obj2.ParentCase();
        obj2.caseCreate.AccountId=a.id;
        obj2.caseCreate.Interaction_Mode__c='Call';
        obj2.caseCreate.Communication_Type__c='Inbound';
        obj2.caseCreate.Nature_of_Request__c='Grievance';
        obj2.caseCreate.OwnerId=u1.id;
        obj2.OnNatureOfRequestChange();
        obj2.caseCreate.Case_Summary__c='Test';
        obj2.caseCreate.Case_Resolution__c='Test';
        obj2.caseCreate.Request_for_L1__c='Document Related';
        obj2.OnL1Change();
        obj2.caseCreate.Request_for_L2__c='Document not delivered';
        obj2.caseCreate.Request_for_L3__c='';
        obj2.caseCreate.Request_for_L3_a__c='Welcome Email'; 
        obj2.OnChange(); 
        obj2.SaveAndClose();
        obj2.closeSec();         
        obj2.OnL2Change();
        
        test.stopTest();   
        
        System.Debug('1............................'+obj1.caseCreate.Id);
    }


    public static testMethod  void testParentCaseCreation1(){
        test.startTest(); 
        id RTId = [Select id from RecordType where Name = 'Booked Account' LIMIT 1].id;
    
        Account a = new Account(FirstName = 'testingFirstacc',
                                LastNAme = 'testingLastacc',
                                Recordtypeid = RTId ,     
                                PersonMobilePhone = '1234567890',
                                PersonEmail = 'testing@test.com'
                                );
        insert a; 
        
        
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Customer Care' limit 1];
    
        User u1 = new User();
        u1.Email = 'email1@email.com';
        u1.Alias = 'Alias2';
        u1.TimeZoneSidKey = 'America/New_York';
        u1.LocaleSidKey = 'ca';
        u1.EmailEncodingKey = 'UTF-8';
        u1.ProfileId = p.id;
        u1.LanguageLocaleKey = 'en_US';
        u1.FirstName = 'firstname1';
        u1.LastName = 'lastname1';
        u1.username= 'username1@first.com';
        insert u1;

        case c = new case();
        System.Debug('Test Accoyunt'+a.Id);
        ApexPages.currentPage().getParameters().put('acctId', a.Id);

        ApexPages.StandardController stdCon1 = new ApexPages.StandardController(c);
        CM_ParentCaseCreatePageController obj = new CM_ParentCaseCreatePageController(stdCon1);
        obj.getpcTypes();
        obj.getStatus();
        obj.parentCaseType='Multiple Request';
        obj.ParentCase();
        obj.caseCreate.AccountId=a.id;
        obj.caseCreate.Interaction_Mode__c='Call';
        obj.caseCreate.Communication_Type__c='Inbound';
        obj.caseCreate.Nature_of_Request__c='Complaint';
        obj.caseCreate.OwnerId=u1.id;
        obj.OnNatureOfRequestChange();
        obj.caseCreate.Case_Summary__c='Test';
        obj.caseCreate.Case_Resolution__c='Test';
        obj.Back();
        obj.SaveParentCase();
        obj.CreateSubCase();
        obj.CancelReq();
        obj.OnL2Change();
        
        System.Debug('3............................'+obj.caseCreate.Id);
        
        // 1.2 Asmita
        List<Case> listCase = Test_CM_ParentCaseCreatePageController.createParentCaseRecord(1, 'Multiple Request', 'Request');
        listCase[0].AccountId = a.Id;
        insert listCase;
        
        Queue_Configuration__c q = [select Id, QueueId__c, Queue_Type__c, Name from Queue_Configuration__c where name ='Brokerage FT Queue']; 
        
        System.Debug('ParentId....'+listCase[0].Id);
        
        ApexPages.currentPage().getParameters().put('ParentId', listCase[0].Id);
        ApexPages.currentPage().getParameters().put('acctId', a.id);
        ApexPages.currentPage().getParameters().put('ptype', obj.caseCreate.ParentCaseType__c);
        
        ApexPages.StandardController stdCon2 = new ApexPages.StandardController(c);
        ApexPages.currentPage().getParameters().put('ParentId', listCase[0].Id);
        CM_ChildCaseCreatePageController cobj=new CM_ChildCaseCreatePageController(stdCon2);        
        cobj.getccTypes();
        cobj.subCaseType='Child Case';
        cobj.caseCreate.Priority='Medium';
        cobj.spocQueueId=  q.Id;
        cobj.caseCreate.Request_for_L1__c='Document Related';
        cobj.OnL1Change();
        cobj.caseCreate.Request_for_L2__c='Customer wants original document';
        cobj.caseCreate.Request_for_L3_a__c='NOC';
        cobj.Back();
        cobj.SaveChildCase();
        cobj.CreateSubCase(); // 1.2 Asmita
        cobj.ChildCase();
        cobj.CancelReq();
        // 1.2 Asmita
        List<SelectOption> listSelectOption = cobj.getfQueue();
        List<SelectOption> listSelectOptionS = cobj.getsQueue();
        
        
        ApexPages.StandardController stdCon3 = new ApexPages.StandardController(c);
        ApexPages.currentPage().getParameters().put('ParentId', listCase[0].Id);
        CM_ChildCaseCreatePageController cobj2=new CM_ChildCaseCreatePageController(stdCon3);         
        cobj2.getccTypes();
        cobj2.subCaseType='Action Item';
        cobj2.caseCreate.Priority='Medium';
        cobj.spocQueueId=  q.Id;
        cobj2.caseCreate.Request_for_L1__c='Cancellation Related'; // 1.2 Asmita
        cobj2.OnL1Change();
        cobj2.caseCreate.Request_for_L2__c='Procedural information'; // 1.2 Asmita
        cobj2.caseCreate.Request_for_L3__c='Loan foreclosure'; // 1.2 Asmita
        cobj2.OnChange();
        cobj2.Back();
        cobj2.SaveActionItem();
        cobj2.CancelReq(); 
        cobj2.SaveChildCase();
        cobj2.CreateSubCase();
        // 1.2 Asmita
        cobj2.ChildCase();
        listSelectOption = cobj2.getfQueue();
        
        // 1.2 Asmita
        listCase = Test_CM_ParentCaseCreatePageController.createParentCaseRecord(1, 'Single Request', 'Request');
        listCase[0].AccountId = a.Id;
        insert listCase;
        
        ApexPages.StandardController stdCon4 = new ApexPages.StandardController(c);
        ApexPages.currentPage().getParameters().put('ParentId', listCase[0].Id);
        cobj2=new CM_ChildCaseCreatePageController(stdCon4);         
        cobj2.getccTypes();
        cobj2.subCaseType='Action Item';
        cobj2.caseCreate.Priority='Medium';
        cobj.spocQueueId=  q.Id;
        cobj2.caseCreate.Request_for_L1__c='Cancellation Related';
        cobj2.OnL1Change();
        cobj2.caseCreate.Request_for_L2__c='Procedural information';
        cobj2.caseCreate.Request_for_L3__c='Loan foreclosure';
        cobj2.OnChange();
        cobj2.Back();
        cobj2.SaveActionItem();
        cobj2.CancelReq(); 
        cobj2.SaveChildCase();
        cobj2.CreateSubCase();
        cobj2.ChildCase();
        listSelectOption = cobj2.getfQueue();
        
        test.stopTest(); 
    }
    
    public static testMethod void testParentCaseCreation2(){
        test.startTest(); 
        id RTId = [Select id from RecordType where Name = 'Booked Account' LIMIT 1].id;
        id OppId = [Select id from Opportunity LIMIT 1].id;
    
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Customer Care' limit 1];
    
        User u1 = new User();
        u1.Email = 'email1@email.com';
        u1.Alias = 'Alias2';
        u1.TimeZoneSidKey = 'America/New_York';
        u1.LocaleSidKey = 'ca';
        u1.EmailEncodingKey = 'UTF-8';
        u1.ProfileId = p.id;
        u1.LanguageLocaleKey = 'en_US';
        u1.FirstName = 'firstname1';
        u1.LastName = 'lastname1';
        u1.username= 'username1@first.com';
        insert u1;

        case c = new case();
        ApexPages.currentPage().getParameters().put('oppid', OppId);
        
        
        ApexPages.StandardController stdCon4 = new ApexPages.StandardController(c);
        CM_ParentCaseCreatePageController obj = new CM_ParentCaseCreatePageController(stdCon4);
        obj.getpcTypes();
        obj.getStatus();
        obj.parentCaseType='Multiple Request';
        obj.ParentCase();
        obj.caseCreate.Opportunity__c =OppId;
        obj.caseCreate.Interaction_Mode__c='Call';
        obj.caseCreate.Communication_Type__c='Inbound';
        obj.caseCreate.Nature_of_Request__c='Complaint';
        obj.caseCreate.OwnerId=u1.id;
        obj.OnNatureOfRequestChange();
        obj.caseCreate.Case_Summary__c='Test';
        obj.caseCreate.Case_Resolution__c='Test';
        obj.Back();
        obj.SaveParentCase();
        obj.CreateSubCase();
        obj.CancelReq();
        
        System.Debug('3............................'+obj.caseCreate.Id);
         
        Queue_Configuration__c q = [select Id, QueueId__c, Queue_Type__c, Name from Queue_Configuration__c where name ='Brokerage FT Queue']; 
        
        System.Debug('ParentId....'+obj.caseCreate.Id);
        
        ApexPages.StandardController stdCon5 = new ApexPages.StandardController(c);
        ApexPages.currentPage().getParameters().put('ParentId', obj.caseCreate.Id);
        ApexPages.currentPage().getParameters().put('oppid', oppid);
        ApexPages.currentPage().getParameters().put('ptype', obj.caseCreate.ParentCaseType__c);
        
        CM_ChildCaseCreatePageController cobj=new CM_ChildCaseCreatePageController(stdCon5);        
        cobj.getccTypes();
        cobj.subCaseType='Child Case';
        cobj.caseCreate.Priority='Medium';
        cobj.spocQueueId=  q.Id;
        cobj.caseCreate.Request_for_L1__c='Document Related';
        cobj.OnL1Change();
        cobj.caseCreate.Request_for_L2__c='Customer wants original document';
        cobj.caseCreate.Request_for_L3_a__c='NOC';
        cobj.Back();
        cobj.SaveChildCase();
        cobj.CreateSubCase();
        cobj.CancelReq();
        
        
        ApexPages.StandardController stdCon6 = new ApexPages.StandardController(c);
        ApexPages.currentPage().getParameters().put('ParentId', obj.caseCreate.Id);
        CM_ChildCaseCreatePageController cobj2=new CM_ChildCaseCreatePageController(stdCon6);         
        cobj2.getccTypes();
        cobj2.subCaseType='Action Item';
        cobj2.caseCreate.Priority='Medium';
        cobj.spocQueueId=  q.Id;
        cobj2.caseCreate.Request_for_L1__c='Document Related';
        cobj2.OnL1Change();
        cobj2.caseCreate.Request_for_L2__c='Customer wants original document';
        cobj2.caseCreate.Request_for_L3_a__c='NOC';
        cobj2.OnChange();
        cobj2.Back();
        cobj2.SaveActionItem();
        cobj2.CancelReq(); 
        
        
        test.stopTest(); 
    }
    
    // Asmita - 08/18/2014
    // Method returns list of Project Name Record to insert
    public static List<Project_Name__c> createProjectNameRecord(Integer pNumberOfRecords){
        
        Project_Name__c oProjName = new Project_Name__c();
        List<Project_Name__c> listProjectName = new List<Project_Name__c>();
        
        for(Integer i = 0; i < pNumberOfRecords; i++){
            
            oProjName = new Project_Name__c();
            oProjName.Name = 'Test Project';
            oProjName.Project_Type__c = 'Casa';
            oProjName.Record_Type__c = 'Residential';
            
            listProjectName.add(oProjName);
        }
        
        return listProjectName;
    }
    
    // Asmita - 08/18/2014
    // Method returns the list of Cluster records
    public static List<Cluster__c> createClusterRecords(Integer pNumberOfRecords){
        
        Cluster__c oCluster = new Cluster__c();
        List<Cluster__c> listCluster = new List<Cluster__c>();
        
        for(Integer i = 0; i < pNumberOfRecords; i++){
            
            oCluster = new Cluster__c();
            oCluster.Name = 'Test Cluster1';
            listCluster.add(oCluster);
        }
        
        return listCluster;
    }
    
    // Asmita - 08/18/2014
    // Method that returns Wing records to insert
    public static List<Wing__c> createWingRecords(Integer pNumberOfRecords){
        
        Wing__c oWing = new Wing__c();
        List<Wing__c> listWing = new List<Wing__c>();
        
        for(Integer i = 0; i < pNumberOfRecords; i++){
             
            oWing = new Wing__c();
            oWing.Name = 'Test Wing';
            listWing.add(oWing);
        }
        
        return listWing;
    }
    
    // Asmita - 08/18/2014
    // Method that returns flat record information to create a flat record
    public static List<Flat__c> createFlatRecord(Integer pNumberOfRecords){
        
        Flat__c oFlat = new Flat__c();
        List<Flat__c> listFlat = new List<Flat__c>();
        
        for(Integer i = 0; i < pNumberOfRecords; i++){
            
            oFlat = new Flat__c();
            oFlat.Flat_No__c = 101;
            oFlat.Oasys_Flat_code__c = 'Test Project Cluster Wing';
            listFlat.add(oFlat);
        }
        
        return listFlat;
    }
    
    // Asmita - 08/18/2014
    // Method return list of Opportunity Record to insert
    public static List<Opportunity> createOpportunityRecords(Integer pNumberOfRecords){
        
        Opportunity oOpp = new Opportunity();
        List<Opportunity> listOpportunity = new List<Opportunity>();
        
        for(Integer i = 0; i < pNumberOfRecords; i++){
            
            oOpp = new Opportunity();
            oOpp.Name = 'Test Opp1';
            oOpp.CloseDate = System.today();
            oOpp.stageName = 'Closed Won';
            oOpp.Servicing_Team__c = 'Presales';
            oOpp.Name_of_PSC__c = 'Amarjyot Kaur';
            
            listOpportunity.add(oOpp);
        }
        return listOpportunity;
    }
    
    // Asmita - 08/18/2014
    // Method return list of Booking Information Record to insert
    public static List<Booking_Information__c> createBookingInfoRecords(Integer pNumberOfRecords){
        
        Booking_Information__c oBookingInfo = new Booking_Information__c();
        List<Booking_Information__c> listBookingInfo = new List<Booking_Information__c>();
        
        for(Integer i = 0; i < pNumberOfRecords; i++){
            
            oBookingInfo = new Booking_Information__c();
            oBookingInfo.InActive__c = true;
            oBookingInfo.Oasys_Flat_Code__c = 'Test Project Cluster Wing';
            
            listBookingInfo.add(oBookingInfo);
        }
        
        return listBookingInfo;
    }
    
    // Asmita 09/10/2014
    public static List<Case> createParentCaseRecord(Integer pNumberOfRecords, String pStrCaseType, String pStrRequestType){
        
        List<Case> listCase = new List<Case>();
        Case objCase = new Case();
        
        for(Integer i = 0; i < pNumberOfRecords; i++){
            
            objCase = new Case();
            objCase.CaseType__c = pStrCaseType;
            objCase.Nature_of_Request__c = pStrRequestType;
            objCase.Communication_Type__c = 'Email';
            objCase.Interaction_Mode__c = 'Outbound';
            objCase.Initial_Remarks__c = 'test';
            objCase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CM_Dummy_Parent').getRecordTypeId();
            
            listCase.add(objCase);
        }
        return listCase;
    }
}