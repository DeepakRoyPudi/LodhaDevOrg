/*<!--  -->
<!--    Version      - 1.0   -->
<!--    Created By   - Trupti D. -->
<!--    Created Date - 2/05/2015 -->

<!--    Description  - Test Class for Detail view of Doc/sms/dispatch-->*/


@isTest

private class DocSmsDispatchCSS2_0ControllerTest {

    static testMethod void documentsTest() {
        
        //create custom setting data category and name
        admindocumentTypeSelection();
        admindocumentNameSelection();
        //Create account rec
        Account accObj = DocSmsDispatchCSS2_0ControllerTest.createAccount();
        insert accObj;

        user communityUsr = createCommunityuser(accObj);
        insert communityUsr;
         
        DocSmsDispatchCSS2_0Controller objCtrler = new DocSmsDispatchCSS2_0Controller();
        test.startTest();

        objCtrler.Customer_CRN = accObj.CRN__c;
        objCtrler.lstDocument_crispView = null;
        objCtrler.lstSMS_crispView = null;
        objCtrler.lstDispatch_crispView = null;
        
        System.assertEquals(0, objCtrler.lstDocument_crispView.size());
        System.assertEquals(0, objCtrler.lstSMS_crispView.size());
        System.assertEquals(0, objCtrler.lstDispatch_crispView.size());

        test.stopTest();

    }


    static testMethod void docSmsDispatch() {
        
            //Create account rec
            //create custom setting data category and name
            admindocumentTypeSelection();
            admindocumentNameSelection();
            Account accObj = DocSmsDispatchCSS2_0ControllerTest.createAccount();
            insert accObj;
    
            user communityUsr = createCommunityuser(accObj);
            insert communityUsr;
    
            list <Documents__c> dlist = createDoc(accObj, 3);
            insert dlist;
    
            list <SMS_History__c> smslist = createSMS(accObj, 3);
            insert smslist;
    
            list <Despatch__c> dispatchlist = createDispatch(accObj, 3);
            insert dispatchlist;
            
             WidgetInfo__c ObjWidgetInfo = ObjWidgetInfo();
            insert objWidgetInfo;
            
            List<Widget_Sequence__c> lstWidget_Sequence = new List<Widget_Sequence__c>();
            for(Integer i = 0; i < 10; i++){
                 Widget_Sequence__c objWidget_Sequence = new Widget_Sequence__c();
                 objWidget_Sequence.Sequence_ClickCount__c= 0;
                 objWidget_Sequence.WidgetInfo__c=objWidgetInfo.id;
                 objWidget_Sequence.User__c = communityUsr.Id ;
                 lstWidget_Sequence.add(objWidget_Sequence);
             }
             insert lstWidget_Sequence; 
             System.RunAs(communityUsr){
                DocSmsDispatchCSS2_0Controller objCtrler = new DocSmsDispatchCSS2_0Controller();
                test.startTest();
                objCtrler.Customer_CRN = accObj.CRN__c;
                objCtrler.lstDocument_crispView = dlist;
                objCtrler.lstSMS_crispView = smslist;
                objCtrler.lstDispatch_crispView = dispatchlist;
                objCtrler.clickDocSMSCount();
                test.stopTest();
        }
    
    }

    //this method return insert document types values from DocumneCategory piclist 
    // of Document__c object
    
        private static void admindocumentTypeSelection()
        {
          AdminDocumentTypeSelectionTest.PicklistValues=new List<AdminDocumnetCategory__c>();
          //craete custom setting data category 
          List<AdminDocumnetCategory__c> allReadyExitingDocument= 
          AdminDocumentTypeSelectionTest.insertDocumentTypesFromField();
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
                               AdminDocumnetCategory__c.getAll().values().size());
           
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
      
      System.assertEquals(docNameObj.documentForRight.size(),
                           AdminDocumentName__c.getAll().values().size());
    }
    private static User createCommunityuser(Account a) {
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
    private static list < Documents__c > createDoc(Account acc, Integer noOfRecd) {
        list < Documents__c > docList = new list < Documents__c > ();

        for (Integer i = 0; i < noOfRecd; i++) {
            docList.add(new Documents__c(Account__c = acc.Id, 
                                CRN__c = acc.CRN__c,Name='Test'+i,
                                Document_Category__c='Cancellation Process',
                                Version__c = '1'));
        }

        return docList;
    }
    private static list < SMS_History__c > createSMS(Account acc, Integer noOfRecd) {
        list < SMS_History__c > smsList = new list < SMS_History__c > ();

        for (Integer i = 0; i < noOfRecd; i++) {
            smsList.add(new SMS_History__c(Account__c = acc.Id, CRN__c = acc.CRN__c,
                Mobile_Number__c = '1234567' + i,
                SMS_Text__c = 'Test SMS',
                Status__c = 'Sent',
                SMS_Type__c = 'Sent'));
        }

        return smsList;
    }
    private static list < Despatch__c > createDispatch(Account acc, Integer noOfRecd) {
        list < Despatch__c > dispatchList = new list < Despatch__c > ();

        for (Integer i = 0; i < noOfRecd; i++) {
            dispatchList.add(new Despatch__c(Account__c = acc.Id,
                Despatch_Date__c = system.today(),
                Waybill_No__c = '3454554' + i,
                Courier_Name__c = 'Test',
                Contents__c = 'Test',
                Last_Delivery_Status__c = 'Sent'
            ));
        }

        return dispatchList;
    }
    private static Account createAccount() {
        Account objAccount = new Account();
        objAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Booked Account').getRecordTypeId();
        objAccount.FirstName = 'Test1';
        objAccount.LastName = 'Account1';
        objAccount.CRN__c = '154215';
        objAccount.H_Mobile_No__c = '1234560789';
        objAccount.Mobile_Phone__c = '21241222';
        objAccount.Co_Applicant__c = 'test';
        return objAccount;
    }

    private static WidgetInfo__c ObjWidgetInfo() {
        WidgetInfo__c objWidgetInfo = new WidgetInfo__c();
        objWidgetInfo.Name='Recent Documents/SMS/Dispatch';
        objWidgetInfo.Available_For__c = 'Both'; 
        return objWidgetInfo;
    }

}