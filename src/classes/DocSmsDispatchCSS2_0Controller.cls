/* 
Description:
This class is used for documents/sms/dispatch (crisp) Component

 @Created by: Trupti Dhoka.
 @Created Date:  9/03/15   
 
 --------------------------------------------------------------------------------
 | Modified By      | Modified Date       | Version        | Description         |
 --------------------------------------------------------------------------------
 |Sneha p               02/04/2015          1.1             Logic for tracking click count
 --------------------------------------------------------------------------------
 |Sudeep Dube        05/08/2015     1.2                Select only Document which are set by Admin 
                                                       for CSS via Admin Documnet Categoty    
 --------------------------------------------------------------------------------
 |Aditi Mulmule       16/07/2015     1.3         Select only Documents which are set by 
                                                 Admin for CSS via Document Name Visibility 
                                                 and Document Type Visibility    
 --------------------------------------------------------------------------------
*/

public class DocSmsDispatchCSS2_0Controller {
    
    //Private Variable
    private static final String widgetName = 'Recent Documents/SMS/Dispatch';
    private static final String SentDate = 'Created_Date__c';
    private static final String DispatchOrderBy = 'Despatch_Date__c';
    private static final String smsStatus = 'success';
    //Property
    public String Customer_CRN {get;set;} //get parameter from component
    
    //Map to populate Documents with latest Version formula
    public map<String, Documents__c> docMap  {get; set; }
    public set<Id> documentIdSet {get; set;}
    
    
    /*this list returns all the related documets associated to user fetched dynamically
     from CreateQueryHelper.getRecords*/
    public list<Documents__c> lstDocument_crispView{
     
        set;
        get{ 
            if(lstDocument_crispView== null)
                lstDocument_crispView =new list<Documents__c >();
          
               //get all the category type values selected and set by admin
            list<AdminDocumnetCategory__c> allRecords = AdminDocumnetCategory__c.getAll().values();
            list<String> categoryNames=new list<String>();
                
            for(AdminDocumnetCategory__c AdminDocObj: allRecords){
               categoryNames.add('\''+AdminDocObj.name+'\'');
            }
                       
            //get all the Name type values selected and set by admin
            list<AdminDocumentName__c> allNameRecords = AdminDocumentName__c.getAll().values();
            String documentNames='';
           // documentNames ='';
         
            for(AdminDocumentName__c adminDocnameObj: allNameRecords ){
              String excluding_special_Char = adminDocnameObj.Document_Name__c;
              excluding_special_Char = excluding_special_Char.replaceAll('[^a-zA-Z_0-9]','%');
              
                     
              if(String.isBlank(documentNames)) {
                  documentNames = ' Name Like \''+excluding_special_Char +'\'';
              } else {
                  documentNames = documentNames  + ' or Name Like \''+excluding_special_Char +'\'';
              }
            }
            if(categoryNames.size()>0 && allNameRecords.size()>0 ){
              
            list<Documents__c> docList = CreateQueryHelper.getRecords('Documents__c',
                                            'VersionFormula__c,CreatedDate,Id',
                                            'where Account__r.CRN__c = \''+
                                            Customer_CRN+'\' and Document_Category__c IN'+
                                            categoryNames+' and ('+ documentNames + ')',
                                            CreateQueryHelper.RecentDocumentCrispCSS,
                                            'order by Date_of_Generation__c DESC NULLS Last','');
          //  if(docMap == null)
          //      docMap = new map<String, Documents__c>();

          //  if(documentIdSet == null)
          //      documentIdSet = new set<Id>();

            //Check if      
        /*    for(Documents__c objDoc : docList) {
                if(docMap.isEmpty() || (!docMap.isEmpty() && 
                                            (!docMap.containsKey(objDoc.Name) ||
                                                (docMap.containsKey(objDoc.Name) && 
                                                docMap.get(objDoc.Name).VersionFormula__c < objDoc.VersionFormula__c
                                             ) ) ) ) {
                                                
                    docMap.put(objDoc.Name, objDoc);    
                 }
            }
 
            for(String key : docMap.KeySet()) {
                documentIdSet.add(docMap.get(key).ID);
            }   
       */
            lstDocument_crispView.clear();
            for (Documents__c objDoc: docList) {

             //   if(documentIdSet.size() > 0 && documentIdSet.contains(objDoc.Id)) {
                    lstDocument_crispView.add(objDoc);
              //  }
            }
        }
        return lstDocument_crispView;
        }
    }
    /*this list returns all the related sms associated to user fetched dynamically
     from CreateQueryHelper.getRecords*/
     public list<SMS_History__c> lstSMS_crispView{

        set;
        get{ 
          if(lstSMS_crispView== null)
                lstSMS_crispView= CreateQueryHelper.getRecords('SMS_History__c','Id',
                                  'where Account__r.CRN__c = \''+Customer_CRN+'\' and Status__c like  \'%' + smsStatus  + '%\' ', 
                                  CreateQueryHelper.RecentSMSCrispCSS,'order by '+SentDate+' DESC NULLS Last','limit 3');
                return lstSMS_crispView;
        }
    }
    /*this list returns all the related dispatch associated to user fetched dynamically
     from CreateQueryHelper.getRecords*/
     public list<Despatch__c> lstDispatch_crispView{
     
        set;
        get{ 
          if(lstDispatch_crispView== null)
                lstDispatch_crispView = CreateQueryHelper.getRecords('Despatch__c','Id',
                                        'where Account__r.CRN__c = \''+Customer_CRN+'\'', 
                                        CreateQueryHelper.RecentDispatchCrispCSS,'order by '+DispatchOrderBy+' DESC NULLS Last','limit 3');
                return lstDispatch_crispView;
        }
    }
    
    //Function to increment click count for a User
    public void clickDocSMSCount() {
        ClickCountCSSHelper.incrementCount(widgetName);
    }

}