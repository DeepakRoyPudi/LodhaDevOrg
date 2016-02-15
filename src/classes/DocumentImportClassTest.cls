/*    Description: Test Class for DocumentImport Class for DMS Project
*    
*    Version            Date            Author                    Description
*    1.0                02/09/2014      Asmita(Eternus)           Initial Draft
*/

@isTest
private class DocumentImportClassTest {

    static testMethod void importDocumentDataTest() {
        List<DocumentsCategorySetting__c> listAllDocCategoryCustSetting = new List<DocumentsCategorySetting__c>();
        
        // Inserting DocumentCategorySetting Records
        List<DocumentsCategorySetting__c> listDocCategoryCustSetting = DocumentImportClassTest.getDocCategorySettingRecords(1, 'Allotment Letter', 'Allotment Process', 'AL', 1);
        listAllDocCategoryCustSetting.addAll(listDocCategoryCustSetting);
        listDocCategoryCustSetting = DocumentImportClassTest.getDocCategorySettingRecords(2, 'Interest Letter', 'Revenue Process', 'e-INTEREST LETTER', 1);
        listAllDocCategoryCustSetting.addAll(listDocCategoryCustSetting);
        listDocCategoryCustSetting = DocumentImportClassTest.getDocCategorySettingRecords(3, 'SDR Letter', 'Registration Process', 'SDR Letter', 1);
        listAllDocCategoryCustSetting.addAll(listDocCategoryCustSetting);
        listDocCategoryCustSetting = DocumentImportClassTest.getDocCategorySettingRecords(4, 'Payments due email', 'Revenue Process', 'Payment History and Balance Due', 1);
        listAllDocCategoryCustSetting.addAll(listDocCategoryCustSetting);
        listDocCategoryCustSetting = DocumentImportClassTest.getDocCategorySettingRecords(5, 'Welcome Email', 'Welcome Process', 'Welcome', 1);
        listAllDocCategoryCustSetting.addAll(listDocCategoryCustSetting);
        insert listAllDocCategoryCustSetting;
        
        // Creating Account
        List<Account> listAccount = DocumentImportClassTest.getAccountRecord(1);
        insert listAccount;
        
        // Creating a CSV format String that will be passed as a parameter to the webservice
        String strCsvString = 'Allotment Letter.pdf,http://172.29.7.88:8280/share/proxy/alfresco/api/node/content/workspace/SpacesStore/1987d8aa-a47f-47c4-81cd-29852d6b568d/0001236375_SDR%20for%20HighEnd.pdf,,1,2013-08-08 11:38:00,xyz,Email,Manual,Lovely John,INR,1234569\n';
        strCsvString = strCsvString + 'Allotment Letter.pdf,http://172.29.7.88:8280/share/proxy/alfresco/api/node/content/workspace/SpacesStore/1987d8aa-a47f-47c4-81cd-29852d6b568d/0001236375_SDR%20for%20HighEnd.pdf,,1,2013-08-08 11:38:00,xyz,Email,Manual,Lovely John,INR,1234569\n';
        strCsvString = strCsvString + 'Allotment Letter-(1).pdf,http://172.29.7.88:8280/share/proxy/alfresco/api/node/content/workspace/SpacesStore/1987d8aa-a47f-47c4-81cd-29852d6b568d/0001236375_SDR%20for%20HighEnd.pdf,,1,2013-08-08 11:38:00,xyz,Email,Manual,Lovely John,INR,1234569\n';
        strCsvString = strCsvString + '00012345_Allotment Letter(1).pdf,http://172.29.7.88:8280/share/proxy/alfresco/api/node/content/workspace/SpacesStore/1987d8aa-a47f-47c4-81cd-29852d6b568d/0001236375_SDR%20for%20HighEnd.pdf,,1,2013-08-08 11:38:00,xyz,Barcode,Manual,Lovely John,INR,1234569\n';
        strCsvString = strCsvString + '00012345_Allotment Letter-(1).pdf,http://172.29.7.88:8280/share/proxy/alfresco/api/node/content/workspace/SpacesStore/1987d8aa-a47f-47c4-81cd-29852d6b568d/0001236375_SDR%20for%20HighEnd.pdf,,1,2013-08-08 11:38:00,xyz,Barcode,Manual,Lovely John,INR,1234569\n';
        strCsvString = strCsvString + '00012345_Cordysuser_Allotment Letter(1).pdf,http://172.29.7.88:8280/share/proxy/alfresco/api/node/content/workspace/SpacesStore/1987d8aa-a47f-47c4-81cd-29852d6b568d/0001236375_SDR%20for%20HighEnd.pdf,,1,2013-08-08 11:38:00,xyz,Email,Cordys,Lovely John,INR,1234569\n';
        strCsvString = strCsvString + '00012345_SAPuser_Allotment Letter(1).pdf,http://172.29.7.88:8280/share/proxy/alfresco/api/node/content/workspace/SpacesStore/1987d8aa-a47f-47c4-81cd-29852d6b568d/0001236375_SDR%20for%20HighEnd.pdf,,1,2013-08-08 11:38:00,xyz,Email,SAP,Lovely John,INR,1234569\n';
        strCsvString = strCsvString + '00012345_SAPuser_Allotment Letter.pdf,http://172.29.7.88:8280/share/proxy/alfresco/api/node/content/workspace/SpacesStore/1987d8aa-a47f-47c4-81cd-29852d6b568d/0001236375_SDR%20for%20HighEnd.pdf,,1,2013-08-08 11:38:00,xyz,Email,SAP,Lovely John,INR,1234569\n';
        strCsvString = strCsvString + 'Payment History and Balance Due(1) | 0001218524 | CASA RIO | Mediterranea | FLAT C(4),http://172.29.7.88:8280/share/proxy/alfresco/api/node/content/workspace/SpacesStore/1987d8aa-a47f-47c4-81cd-29852d6b568d/0001236375_SDR%20for%20HighEnd.pdf,,1,2013-08-08 11:38:00,xyz,Email,Cordys,Lovely John,INR,1234569\n';
        strCsvString = strCsvString + 'Payment History and Balance Due | 0001218524 | CASA RIO | Mediterranea | FLAT C(4),http://172.29.7.88:8280/share/proxy/alfresco/api/node/content/workspace/SpacesStore/1987d8aa-a47f-47c4-81cd-29852d6b568d/0001236375_SDR%20for%20HighEnd.pdf,,1,2013-08-08 11:38:00,xyz,Email,Cordys,Lovely John,INR,1234569\n';
        strCsvString = strCsvString + 'CASA RIO %3a Welcome Mr(15). SWAPNIL PRABHAKAR CHAVARKAR %7c Customer ID - 0001218524,http://172.29.7.88:8280/share/proxy/alfresco/api/node/content/workspace/SpacesStore/1987d8aa-a47f-47c4-81cd-29852d6b568d/0001236375_SDR%20for%20HighEnd.pdf,,1,2013-08-08 11:38:00,xyz,Email,Cordys,Lovely John,INR,1234569\n';
        strCsvString = strCsvString + 'CASA RIO %3a Welcome Mr. SWAPNIL PRABHAKAR CHAVARKAR %7c Customer ID - 0001218524,http://172.29.7.88:8280/share/proxy/alfresco/api/node/content/workspace/SpacesStore/1987d8aa-a47f-47c4-81cd-29852d6b568d/0001236375_SDR%20for%20HighEnd.pdf,,1,2013-08-08 11:38:00,xyz,Email,Cordys,Lovely John,INR,1234569\n';
        strCsvString = strCsvString + 'ARC(6117),http://172.29.7.88:8280/share/proxy/alfresco/api/node/content/workspace/SpacesStore/1987d8aa-a47f-47c4-81cd-29852d6b568d/0001236375_SDR%20for%20HighEnd.pdf,,1,2013-08-08 11:38:00,xyz,Email,SAP,Lovely John,INR,1234569\n';
        test.startTest();
            DocumentImportClass_Siddharth.importDocumentRecords(strCsvString);
        test.stopTest();
    }
    
    static testMethod void importSmsDataTest(){
    
        // Creating Account
        List<Account> listAccount = DocumentImportClassTest.getAccountRecord(1);
        insert listAccount;
        
        // Creating a CSV format string so as to pass as a parameter to the function
        String strCsvString = '99999999999,12345,Test SMS,2013-08-08 11:38:00,Success,Mobile Number Invalid\n';
        strCsvString = strCsvString + '91199999999,12345,Test SMS,08/08/2014 11:38 AM,Success,Mobile Number Invalid\n';
        strCsvString = strCsvString + '91199999999,12345,Test SMS,08/08/2014 11:38 AM,Success,Mobile Number Invalid,Booking Creation';
        
        test.startTest();
            DocumentImportClass_Siddharth.importSmsRecords(strCsvString);
        test.stopTest();
    }
    
    // Creating DocumentCategorySetting records
    public static List<DocumentsCategorySetting__c> getDocCategorySettingRecords(Integer pIntDocNo, String pStrDocName, String pStrProcessName, String pStrStdName, Integer pNumberOfRecords){
        DocumentsCategorySetting__c oDocCategory = new DocumentsCategorySetting__c();
        List<DocumentsCategorySetting__c> listDocCategorySetting = new List<DocumentsCategorySetting__c>();
        
        for(Integer i = 0 ; i < pNumberOfRecords ; i++){
            
            oDocCategory = new DocumentsCategorySetting__c();
            oDocCategory.Name = 'Doc' + pIntDocNo;
            oDocCategory.Document_Name__c = pStrDocName;
            oDocCategory.Process_Name__c = pStrProcessName;
            oDocCategory.Standard_Name__c = pStrStdName;
            oDocCategory.Is_Available__c = true;
            
            listDocCategorySetting.add(oDocCategory);
        }
        return listDocCategorySetting;
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
    
}