/*
*    Description : Apex Web service class that would be exposed to the external application. A list of Document records and 
                   MS History records would be provided as a parameter which in turn would create the records
*
*    Version            Date            Author            Description
*
*    1.0                05/06/2014      Asmita Bubane     Initial Draft
*
*    1.1                05/12/2014      Siddharth Birari  The webservice assumes that, CRN number would be available as one of the 
*                                                         column which needs to be mapped with respective Account Id in salesforce
*
*    1.2                05/16/2014      Asmita Bubane     Removing the mapping of Document_Category field and mapping the 
*                                                         Email_URL field
*
*    1.3                05/21/2014      Asmita Bubane     Created new method which will be exposed as a webservice method to 
*                                                         parse CSV contains and insert the SMS History records.
*
*    1.4                07/07/2014      Asmita Bubane     Code modification To get the User and file Name from the New File Name 
*                                                         Format that is CRN_CordysUser_FileName.
*    
*    1.5                15/07/2014      Asmita Bubane     Code modification for getting the file name by searching the search word
*                                                         using custom setting if document source is 'Cordys'.
*  
*    1.6                05/12/2014     Asmita             Code modification for ignoring the CRN of the documents which does not
*                                                         contains underscore as these files are not getting inserted in salesforce.
*/
 
global with sharing class DocumentImportClass_Siddharth{  

    webservice static void importDocumentRecords(String fileContentsInString){
    
        // Class Variables
        List<String> fileLines = new List<String>();        
        List<String> fieldValues = new List<String>();
        List<String> listFileNameChunks = new List<String>();
        List<String> listDuplicateFileName = new List<String>();
        List<String> listCordysEmailChaunks = new List<String>();
        List<Documents__c> listOfDocuments = new List<Documents__c>();
        List<Documents__c> listUpdateDocuments = new List<Documents__c>();
        Map<String, String> mapDocCategorySetting = new Map<String, String>();
        Map<String, DocumentsCategorySetting__c> mapWordSearchDocName = new Map<String, DocumentsCategorySetting__c>();
        String strFileName = '';
        String strCRN = '';
        String strDocName = '';
        String strSearchCode = '';
        Boolean flagForValidDocNmae = false;
        
        List<Account> listAccountCrn = new List<Account>(); 
        Map<String, Id> mapAccountCrn = new Map<String, Id>();
        
        //List to maintain the CRN Numbers retrieved through csv
        Set<String> setCrn = new Set<String>();
        
        Documents__c documentRecord = new Documents__c();
        
        System.debug('Webservice Parameter' + fileContentsInString);
                        
        fileLines = fileContentsInString.split('\n'); // Splitting the records with new line.
        
        // Creating a map of Document Name and Process Name/ Document Category of the Document from Custom Setting
        for(DocumentsCategorySetting__c setting : DocumentsCategorySetting__c.getall().values()){
            
            mapDocCategorySetting.put(setting.Document_Name__c, setting.Process_Name__c);
            if(!String.isBlank(setting.Standard_Name__c))
                mapWordSearchDocName.put(setting.Standard_Name__c, setting);
        }  
               
        
        for(Integer i=1; i<fileLines.size(); i++){
            // The first line of CSV file would the header(Field Labels), so loop is strating from 1.
            listFileNameChunks = new String[]{};
            fieldValues = new String[]{};
            flagForValidDocNmae = false;
            
            fieldValues = fileLines[i].split(',');
            
            // Mapping the values from CSV to salesforce fields.
            documentRecord = new Documents__c();
            strFileName = fieldValues[0];
            //documentRecord.Name = fieldValues[0];
            documentRecord.Document_URL__c = fieldValues[1];
            //documentRecord.Document_Category__c = fieldValues[2];
            documentRecord.Email_URL__c = fieldValues[2];
            documentRecord.Version__c = fieldValues[3];            
            documentRecord.Date_of_Generation__c = DateTime.valueOf(fieldValues[4]);
            documentRecord.Identification_Parameter__c = fieldValues[5];
            documentRecord.Publish_Mode__c = fieldValues[6];
            documentRecord.Document_Source__c = fieldValues[7];
            documentRecord.RM_User_Name__c = fieldValues[8];
            
            // Getting the User and File Name depending on the Document Source
            if(!String.isBlank(fieldValues[7])){
                
                // if Document source is Manual and Publish mode is not Barcode
                if(fieldValues[7].equalsIgnoreCase('Manual') && !fieldValues[6].equalsIgnoreCase('Barcode')){
                    
                    strDocName = '';
                    strDocName = strFileName;
                    if(strDocName.contains('-')){
                        listDuplicateFileName = strDocName.split('-');
                        documentRecord.Name = listDuplicateFileName[0].trim();
                    }
                    else
                        documentRecord.Name = strDocName.trim();
                    System.debug('documentRecord.Name ::::: ' + documentRecord.Name);
                    if(fieldValues[10] != null)
                        strCRN = fieldValues[10];
                    documentRecord.Document_Category__c = mapDocCategorySetting.get(documentRecord.Name);
                    flagForValidDocNmae = true;
                }
                else{
                    
                    strDocName = '';
                    System.debug('strFileName ::::::' + strFileName);
                    if(strFileName.contains('_')){
                    	flagForValidDocNmae = true;
	                    listFileNameChunks = strFileName.split('_');
	                    
	                    strCRN = listFileNameChunks[0];
	                    
	                    // If Document source is Cordys or SAP else document source is Manual and Publish Mode is Barcode
	                    if(fieldValues[7].equalsIgnoreCase('Cordys') || fieldValues[7].equalsIgnoreCase('SAP')){
	                        
	                        if(fieldValues[7].equalsIgnoreCase('Cordys') && strFileName.contains('Payment History and Balance Due')){
	                            
	                            listCordysEmailChaunks = new List<String>();
	                            // If Source is cordys then sometimes the document name will contain Email subject
	                            listCordysEmailChaunks = strFileName.split('\\|');
	                            strCRN = listCordysEmailChaunks[1].trim();
	                            
	                            strDocName = listCordysEmailChaunks[0];
	                            if(strDocName.contains('(')){
	                                listDuplicateFileName = strDocName.split('\\(');
	                                strDocName = listDuplicateFileName[0].trim();
	                            }
	                            else
	                                strDocName = strDocName.trim();
	                        }
	                        else if(fieldValues[7].equalsIgnoreCase('Cordys') && strFileName.contains('Welcome')){
	                            
	                            listCordysEmailChaunks = new List<String>();
	                            // If Source is cordys then sometimes the document name will contain Email subject
	                            listCordysEmailChaunks = strFileName.split('-');
	                            strCRN = listCordysEmailChaunks[1].trim();
	                            strDocName = 'Welcome';
	                        }
	                        else{
	                            documentRecord.User__c = listFileNameChunks[1];
	                            System.debug('strDocName :::::: '+strDocName);
	                            strDocName = listFileNameChunks[2].replace(listFileNameChunks[2].substring(listFileNameChunks[2].length()-4,listFileNameChunks[2].length()),'');
	                            if(strDocName.contains('(')){
	                                listDuplicateFileName = strDocName.split('\\(');
	                                strDocName = listDuplicateFileName[0].trim();
	                            }
	                            else
	                                strDocName = strDocName.trim();
	                        }
	                    }
	                    else if(fieldValues[7].equalsIgnoreCase('Manual') && fieldValues[6].equalsIgnoreCase('Barcode')){
	                        
	                        strDocName = listFileNameChunks[1].replace(listFileNameChunks[1].substring(listFileNameChunks[1].length()-4,listFileNameChunks[1].length()),'');
	                        if(strDocName.contains('-')){
	                            listDuplicateFileName = strDocName.split('-');
	                            strDocName = listDuplicateFileName[0].trim();
	                        }
	                        else
	                            strDocName = strDocName.trim();
	                    }
	                    
	                    if(!mapWordSearchDocName.isEmpty()){
	                       if(!String.isBlank(strDocName) && mapWordSearchDocName.containsKey(strDocName)){
	                            if(mapWordSearchDocName.get(strDocName).Is_Available__c){
	                                documentRecord.Name = mapWordSearchDocName.get(strDocName).Document_Name__c;
	                                documentRecord.Document_Category__c = mapDocCategorySetting.get(documentRecord.Name);
	                            }
	                        } 
	                    }
                    }// if File name contains "_"
                    else{
                    	flagForValidDocNmae = false;
                        System.debug('Invalid File Name .......');
                    }               
                    
                }// end of else
                
                if(flagForValidDocNmae){
                	System.debug('Flag true.......');
                    // If the CRN is 10 digit then removing the starting 0
                    if(!String.isBlank(strCRN)){
                        for(Integer j=0; j<strCRN.length(); j++){
                            if(strCRN.startsWith('0'))
                                strCRN = strCRN.replaceFirst('0','');
                            else
                                break;
                       }
                   }
                   setCrn.add(strCRN);    //Maintain a list of CRN values in the system            
                   documentRecord.CRN__c = strCRN;
                }// end of flagForValidDocName if
                else
                    System.debug('Flag False........');
                
            }// end of if

            listOfDocuments.add(documentRecord);
        }
        
        //Retrieve the Account Id respective to CRN Number 
        if(!setCrn.isEmpty()){
            
            listAccountCrn = [select Id,
                                     CRN__c
                              from Account
                              where CRN__c IN: setCrn];
            
            if(!listAccountCrn.isEmpty()){
                
                for(Account oAcc : listAccountCrn){
                    
                    mapAccountCrn.put(oAcc.CRN__c, oAcc.Id);
                }                
            }
        }
        
        //Mapping the Account Id to the respective Document records based on the CRN received through the CSV
        if(!mapAccountCrn.isEmpty() && !listOfDocuments.isEmpty()){	
            
            for(Documents__c objDocument : listOfDocuments){
                
                if(mapAccountCrn.containsKey(objDocument.CRN__c)){
                    
                    objDocument.Account__c = mapAccountCrn.get(objDocument.CRN__c);
                    listUpdateDocuments.add(objDocument);
                }                
            }
        }
        
        if(!listUpdateDocuments.isEmpty()){
                        
            List<Database.Saveresult> listSaveResult = Database.insert(listUpdateDocuments);
            System.debug('Inserted Documents :::: ' + listSaveResult);
        }        
    }
    
    // Webservice for importing the SMS History Records
    webService static void importSmsRecords(String SMSRecords){
        
        // Class Variables
        List<String> fileLines = new List<String>();        
        List<String> fieldValues = new List<String>();
        List<SMS_History__c> listSmsRecord = new List<SMS_History__c>();
        List<SMS_History__c> listUpdateSMSRecord = new List<SMS_History__c>();
        
        List<Account> listAccountCrn = new List<Account>(); 
        Map<String, Id> mapAccountCrn = new Map<String, Id>();
        
        //List to maintain the CRN Numbers retrieved through csv
        List<String> setCrn = new List<String>();
        
        SMS_History__c smsRecord = new SMS_History__c();
        DateTime createdDateTime;
                
        fileLines = SMSRecords.split('\n'); // Splitting the records with new line.               
        
        for(Integer i=1; i<fileLines.size(); i++){ 
        
            // The first line of CSV file will be the header(Field Labels), so loop is strating from 1.
            fieldValues = new String[]{};
            fieldValues = fileLines[i].split(',');
             
            // Mapping the values from CSV to salesforce fields.
            smsRecord = new SMS_History__c();
            smsRecord.Mobile_Number__c = fieldValues[0];
            smsRecord.SMS_Text__c = fieldValues[2];
            smsRecord.Created_Date__c = DateTime.parse(fieldValues[3]);           
            smsRecord.Status__c = fieldValues[4];
            smsRecord.Remark__c = fieldValues[5];
            if(fieldValues.size() == 6)
                smsRecord.Remark__c = '';
            else
                smsRecord.SMS_Type__c = fieldValues[6];
            
            System.debug('CRN ::::: '+fieldValues[1]);
            //Assumes that the value at index # 1 is storing CRN
            setCrn.add(fieldValues[1]);    //Maintain a list of CRN values in the system
            smsRecord.CRN__c = fieldValues[1];           
            
            listSmsRecord.add(smsRecord);
        }
        
        //Retrieve the Account Id respective to CRN Number 
        if(!setCrn.isEmpty()){
            
            listAccountCrn = [select Id,
                                     CRN__c
                              from Account
                              where CRN__c IN: setCrn];
            
            if(!listAccountCrn.isEmpty()){
                
                for(Account oAcc : listAccountCrn){
                    
                    mapAccountCrn.put(oAcc.CRN__c, oAcc.Id);
                }                
            }
        }
        
        //Mapping the Account Id to the respective SMS Records records based on the CRN received through the CSV
        if(!mapAccountCrn.isEmpty() && !listSmsRecord.isEmpty()){
            
            for(SMS_History__c objSms : listSmsRecord){
                
                if(mapAccountCrn.containsKey(objSms.CRN__c)){
                    
                    objSms.Account__c = mapAccountCrn.get(objSms.CRN__c);
                    listUpdateSMSRecord.add(objSms);
                }                
            }
        }
        
        if(!listUpdateSMSRecord.isEmpty()){
                        
            List<Database.Saveresult> listSaveResult = Database.insert(listUpdateSMSRecord);
        }        
    }
}