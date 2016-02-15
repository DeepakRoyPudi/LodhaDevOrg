/*Description:
This class is used for DocumentsSMSCSS2_0 (detail view) Component

 @Created by: Trupti Dhoka
 @Created Date:  16/03/15   
 
 ---------------------------------------------------------------------------------------
 | Modified By      | Modified Date       | Version        | Description         |
 ---------------------------------------------------------------------------------------
 |Trupti Dhoka           20/03/2015          1.1              Pagination logic
 ----------------------------------------------------------------------------------------
 |Sudeep Dube            05/08/2015          1.1            Select only Document which  
                                                            are setby Admin for CSS via
                                                             Admin Documnet Categoty          
 -----------------------------------------------------------------------------------------
 |Trupti Dhoka           10/06/2015          1.3             Logic for default sorting 
                                                            on document basis on Date 
                                                            of Generation.
 -----------------------------------------------------------------------------------------   
 |Trupti Dhoka           06/07/2015         1.4             Date range in SMS detail View
 --------------------------------------------------------------------------------
 |Aditi Mulmule       16/07/2015            1.5             Select only Documents which are set by 
                                                            Admin for CSS via Document Name 
                                                            Visibility  and Document Type 
                                                            Visibility    
 --------------------------------------------------------------------------------
|Trupti Dhoka           30/07/2015          1.6             Updated SMS type as picklist-fetched 
                                                            picklist values from custom setting 

*/



public class DocumentsSMSCSS2_0controller {
    
    //Constants
    private static final String DocumentObjName = 'Documents__c';
    private static final String SMSObjName = 'SMS_History__c';
    private static final String DispatchObjName = 'Despatch__c';
    private static final String DESC_NULLS_LAST = 'desc NULLS Last'; 
    private static final String ASC_NULLS_FIRST = 'asc NULLS First';
    private static final String smsStatus = 'success';
    public list<String> categoryNames; //all the documnet category to be display
    public String documentNames;
    //Fields used for searchig criteria
    public Documents__c fromDateSearch {get;set;}
    public Documents__c toDateSearch {get;set;}
    public Documents__c docname {get;set;}
    //sms searching criteria
    public SMS_History__c smsfromdate {get; set;}
    public SMS_History__c smstodate {get; set;}
    public String filter_condition {get; set;}
    public String userId {get; set;}
    public SMS_History__c sms {get; set;}
    //Detail View lists  
    public String Customer_CRN{get;set;}
    //get parameter from component-Google Analytics variables
    public static String username {get;set;}
    public static String userCRN {get;set;}
    public static String userProject {get;set;}
    public static String userSeqment {get;set;}
    public static DateTime userLastLogin {get;set;}
    public String activetab {get;set;}
    public Despatch__c dispatch {get;set;}
    public Despatch__c dispatchDateTo {get;set;}
    public Despatch__c dispatchDateFrom {get;set;}
    public String queryString{get;set;}//String for Selecting active tab
    public boolean isProjectWise {get;set;}
    public string imageUrl {get;set;}
    public map<String, Documents__c> doc1Map  {get; set; }
    public set<Id> documentIdSet {get; set;}
    
    public String selectedSmsType {get;set;}
    public static final String noneValue= '--None--';
    //Variables for sorting-Documents/sms/dispatch
    @testVisible private integer totalRecs = 0;
    @testVisible private integer totalDoc = 0;
    @testVisible private integer totalSms = 0;
    @testVisible private integer totalDispatch = 0;
    @testVisible private integer OffsetSize = 0;
    @testVisible private integer LimitSize = 9;
    @testVisible private Map < Integer, Documents__c > docMap {get;set;}
    @testVisible private Map < Integer, SMS_History__c > smsMap {get;set;}
    @testVisible private Map < Integer, Despatch__c > dispatchMap {get;set;}


    // the current sort direction. defaults to asc-Documents
    public String sortDir {
        get {
            if (sortDir == null) {
                sortDir = DESC_NULLS_LAST;
            }
            return sortDir;
        }
        set;
    }
    //variable is used for sorting documents
    public String doc_sortField{
        get{
        if(doc_sortField == null){
            doc_sortField = 'Date_of_Generation__c';
        }
        return doc_sortField;
    }
    set;
    }
    
    //variable is used for sorting SMS
    public String sms_sortField{
        get{
        if(sms_sortField == null){
            sms_sortField = 'Created_Date__c';
        }
        return sms_sortField;
    }
    set;
    }
    
    //variable is used for sorting Dispatch
    public String dispatch_sortField{
        get{
        if(dispatch_sortField == null){
            dispatch_sortField= 'Despatch_Date__c';
        }
        return dispatch_sortField;
    }
    set;
    }
    
    /*this list returns all the related documents associated to user fetched dynamically
     from CreateQueryHelper.getRecords*/
    public list < Documents__c > lstDocuments_detailview {
        set;
        get {
            if (lstDocuments_detailview == null)
             lstDocuments_detailview = new list < Documents__c > ();
             
            if (docMap == null) {
                docMap = new Map < Integer, Documents__c > ();
                
               documentIdSet.clear();          
            
               list <Documents__c> doclist =new list<Documents__c >();
               categoryNames=this.getDocCategoryNames(); 
               
               list<AdminDocumentName__c> allNameRecords = AdminDocumentName__c.getAll().values();
               String documentNames = this.getDocNames();
               
               if(categoryNames.size()>0 && allNameRecords .size()>0){
               doclist = CreateQueryHelper.getRecords( DocumentObjName, 'VersionFormula__c,CreatedDate,Id',
                                      'where Account__r.CRN__c = \'' + Customer_CRN + '\' and Document_Category__c in '+categoryNames+ ' and ('+ documentNames + ')',
                                           
                                      CreateQueryHelper.RecentDocumentDetailCSS, 'order by ' + doc_sortField + ' ' + sortDir, '');
                }
               //commented version logic
            /*    for(Documents__c objDoc : docList) {
                    if(doc1Map.isEmpty() || (!doc1Map.isEmpty() && 
                                                (!doc1Map.containsKey(objDoc.Name) ||
                                                    (doc1Map.containsKey(objDoc.Name) && 
                                                    doc1Map.get(objDoc.Name).VersionFormula__c < objDoc.VersionFormula__c
                                                 ) ) ) ) {
                                                    
                        doc1Map.put(objDoc.Name, objDoc);   
                     }
                }   
                for(String key : doc1Map.KeySet()) {
                    documentIdSet.add(doc1Map.get(key).ID);
                    
                }   */
                docMap.clear();
                for (Documents__c objDoc: docList) {
                   // if(documentIdSet.size() > 0 && documentIdSet.contains(objDoc.Id)) {
                        docMap.put(totaldoc, objDoc);
                        totaldoc++;
                   // }
                }
            } 
           lstDocuments_detailview.clear();
           for (Integer i = OffsetSize; i <= (OffsetSize + LimitSize); i++) {
                lstDocuments_detailview.add(docMap.get(i));
            } 
        
           return lstDocuments_detailview;
        }
    }

    /*this list returns all the related sms associated to user fetched dynamically
     from CreateQueryHelper.getRecords*/
    public list < SMS_History__c > lstSMS_DetailView {

        set;
        get {
            if (lstSMS_DetailView == null) 
            lstSMS_DetailView = new list < SMS_History__c > ();

            if (smsMap == null) {
                smsMap = new map < integer, SMS_History__c > ();
               list < SMS_History__c > smslist = CreateQueryHelper.getRecords(SMSObjName, 'CreatedDate,Id',
                    'where Account__r.CRN__c = \'' + Customer_CRN + '\' and Status__c like  \'%' + smsStatus  + '%\' ',
                CreateQueryHelper.RecentSMSDetailCSS, 'order by ' + sms_sortField + ' ' + sortDir, '');
                smsMap.clear();
                for (SMS_History__c smsobj: smslist) {
                    smsMap.put(totalSms, smsobj);
                    totalSms++;
                }
            }
            lstSMS_DetailView.clear();
            for (integer i = OffsetSize; i <= (OffsetSize + LimitSize); i++) {
                lstSMS_DetailView.add(smsMap.get(i));
            }
            return lstSMS_DetailView;
        }

    }

    /*this list returns all the related dispatch associated to user fetched dynamically
     from CreateQueryHelper.getRecords*/
    public list < Despatch__c > lstDispatch_DetailView {

        set;
        get {
            if (lstDispatch_DetailView == null) 
            lstDispatch_DetailView = new list < Despatch__c > ();

            if (dispatchMap == null) {
                dispatchMap = new map < integer, Despatch__c > ();
                list < Despatch__c > dispatchlist = CreateQueryHelper.getRecords(DispatchObjName, 'CreatedDate,Id,Slug__c',
                    'where Account__r.CRN__c = \'' + Customer_CRN + '\'',
                CreateQueryHelper.RecentDespatchDetailCSS, 'order by ' + dispatch_sortField + ' ' + sortDir, '');
                dispatchMap.clear();

                for (Despatch__c dobj: dispatchlist) {
                    dispatchMap.put(totalDispatch, dobj);
                    totalDispatch++;
                }
            }
            lstDispatch_DetailView.clear();
            for (integer i = OffsetSize; i <= (OffsetSize + LimitSize); i++) {
                lstDispatch_DetailView.add(dispatchMap.get(i));
            }
            return lstDispatch_DetailView;
        }

    }
    public List<SelectOption> getSMSTypes() {

            List<SelectOption> options = new List<SelectOption>();
             options.add(new SelectOption(noneValue,noneValue));
            for(SmsTypeForRmCss__c sType:SmsTypeForRmCss__c.getall().values() ){
                options.add(new SelectOption(sType.Name,sType.Name));
                
            }
           return options;

        }
    
    //constructor
    public DocumentsSMSCSS2_0controller() {
        init();
    }
    
    public void init()
    {
        queryString = ApexPages.CurrentPage().getparameters().get('currenttab');
        if (queryString == null) {
            queryString = 'Document';
        }
        userId = Userinfo.getUserid();
        Customer_CRN = CreateQueryHelper.getCustomerCRN(userId);
        if(String.isNotBlank(Customer_CRN)){
            fromDateSearch = new Documents__c();
            toDateSearch = new Documents__c();
            docname = new Documents__c();
            smsfromdate = new SMS_History__c();
            smstodate = new SMS_History__c();
            sms = new SMS_History__c();
            //Add Sms Type into the picklist
            dispatch = new Despatch__c();
            dispatchDateTo = new Despatch__c();
            dispatchDateFrom = new Despatch__c();
            
            doc1Map = new map<String, Documents__c>();
            documentIdSet = new set<Id>();            
           
            /* Google Analytics*/
    
            GoogleAnalyticsHelper.GetReportParameters(userId);
            username = GoogleAnalyticsHelper.username;
            userCRN = GoogleAnalyticsHelper.userCRN;
            userProject = GoogleAnalyticsHelper.userProject;
            userSeqment = GoogleAnalyticsHelper.userSeqment;
            userLastLogin = GoogleAnalyticsHelper.userLastLogin;
            this.checkBackgroundImage();
        }
    }
    /* Function to determine if the Background image will be displayed project wise 
       or the Default image will be displayed.*/
    public void checkBackgroundImage() {

        BackgroundImageHelper.populateBackgroundImgParam(userCRN);
        isProjectWise = BackgroundImageHelper.isProjectWise;
        imageUrl = BackgroundImageHelper.imageUrl;

    }
    /* Function which will call on tab change and execute specified method */
    public void resetOnTabChange() {

        OffsetSize = 0;
        LimitSize = 9;
        doc_sortField = 'Date_of_Generation__c';
        sms_sortField = 'Created_Date__c';
        dispatch_sortField ='Despatch_Date__c';
        selectedSmsType ='';
        //sortField = 'CreatedDate';
        sortDir = DESC_NULLS_LAST;
        if (activetab == 'doc') {
            searchByFilter();
        } else if (activetab == 'sms') {
            searchbySMSType();
        } else if (activetab == 'dispatch') {
            searchDispatch();
        } 
    }
    /*function used for sorting fields in asc/desc*/
    public void toggleSortDoc() {
        sortDir = sortDir.equals( ASC_NULLS_FIRST) ? DESC_NULLS_LAST :  ASC_NULLS_FIRST;
        this.searchByFilter();

    }
    
    /*function used for sorting fields in asc/desc*/
    public void toggleSortSms() {
        sortDir = sortDir.equals( ASC_NULLS_FIRST) ? DESC_NULLS_LAST :  ASC_NULLS_FIRST;
        this.searchbySMSType();

    }
   
   /*functions used for sorting fields in asc/desc*/
    public void toggleSortDispatch() {

        sortDir = sortDir.equals( ASC_NULLS_FIRST) ? DESC_NULLS_LAST :  ASC_NULLS_FIRST;
        this.searchDispatch();
    }


    //Method to populate a map of documents
    public void populateDocMap(list < Documents__c > pDocumentsList) {
        totalDoc = 0;
        docMap.clear();
        lstDocuments_detailview.clear();
        
        doc1Map = new map<String, Documents__c>();
        documentIdSet.clear();
        
    /*    for(Documents__c objDoc : pDocumentsList) {
            if(doc1Map.isEmpty() || (!doc1Map.isEmpty() && 
                                        (!doc1Map.containsKey(objDoc.Name) ||
                                            (doc1Map.containsKey(objDoc.Name) && 
                                            doc1Map.get(objDoc.Name).VersionFormula__c < objDoc.VersionFormula__c
                                         ) ) ) ) {

                doc1Map.put(objDoc.Name, objDoc);   

             }
        }

        for(String key : doc1Map.KeySet()) {
            documentIdSet.add(doc1Map.get(key).ID);

        } */
        for (Documents__c d: pDocumentsList) {
           // if(documentIdSet.size() > 0 && documentIdSet.contains(d.Id)) {
                docMap.put(totalDoc, d);
                totalDoc++;
           // }
        }
        FirstPage();

    }
    //Method to populate a map of sms
    public void populateSMSMap(list < SMS_History__c > pSMSList) {
        totalSms = 0;
        smsMap.clear();
        lstSMS_DetailView.clear();

        for (SMS_History__c s: pSMSList) {
            smsMap.put(totalSms, s);
            totalSms++;
        }
        FirstPage();
    }
    
    //Method to populate a map of dispatch 
    public void populateDispatchMap(list < Despatch__c > pDispatchList) {
        totalDispatch = 0;
        dispatchMap.clear();
        lstDispatch_DetailView.clear();

        for (Despatch__c d: pDispatchList) {
            dispatchMap.put(totalDispatch, d);
            totalDispatch++;
        }
        FirstPage();
    }
  
  /*This method is used for searching functionality for Documents*/
    public void searchByFilter()

    {
        lstDocuments_detailView.clear();
        docMap.clear();

        if (fromDateSearch.Date_of_Generation__c > toDateSearch.Date_of_Generation__c) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: From Date should be less than or equal to To Date.');
            ApexPages.addMessage(myMsg);
        }

        categoryNames = this.getDocCategoryNames();
        documentNames = this.getDocNames();   
        if(categoryNames.size()>0 && String.isNotBlank(documentNames)) {
        filter_condition = 'where Account__r.CRN__c = \'' + Customer_CRN + '\' and Document_Category__c in '+categoryNames+ ' and ('+ documentNames + ')';
                                            

        if (fromDateSearch.Date_of_Generation__c != null) {
            DateTime fromDate = fromDateSearch.Date_of_Generation__c;
            createQueryHelper.frmdate = fromDate;
            filter_condition += ' and Date_of_Generation__c >=:frmdate';
          }

        if (toDateSearch.Date_of_Generation__c != null) {
            DateTime toDate = toDateSearch.Date_of_Generation__c;
            createQueryHelper.todate = toDate;
            filter_condition += ' and Date_of_Generation__c <=:todate';
        }

        if(docname.Name != ' ' && docname.Name != null && docname.Name != '')
        {
            
            docname.Name= docname.Name.replaceAll('[^a-zA-Z_0-9]','%');
            filter_condition+= ' and Name like \'%' + docname.Name + '%\'  ';
        }

        if(docname.Document_Category__c != '--None--' && docname.Document_Category__c != null )
        {
            createQueryHelper.documentName = docname.Document_Category__c; 
            filter_condition += ' and Document_Category__c =:documentName' ;
        }

        if(categoryNames.size()>0){
        list < Documents__c > doclst1 = CreateQueryHelper.getRecords( DocumentObjName, 'VersionFormula__c,CreatedDate,Id',
                        filter_condition, CreateQueryHelper.RecentDocumentDetailCSS,
                          'order by ' + doc_sortField + ' ' + sortDir, ' ' );
        this.populateDocMap(doclst1);
        }
       }
    }

  /*This method is used for handling searching criterias in sms table*/
    public void searchbySMSType() {

        smsMap.clear();
        lstSMS_detailView.clear();

        String whereClause = '';
        whereClause = 'where Account__r.CRN__c = \'' + Customer_CRN + '\' and Status__c like  \'%' + smsStatus  + '%\' ';

        if(String.isNotBlank(selectedSmsType) && selectedSmsType != noneValue){
            whereClause += ' and SMS_Type__c =  \'' + selectedSmsType + '\' ';
        }

         if (smsfromdate.Created_Date__c > smstodate.Created_Date__c) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: From Date should be less than or equal to To Date.');
            ApexPages.addMessage(myMsg);
         }
        
        if (smsfromdate.Created_Date__c != null) {
            DateTime smsdate = smsfromdate.Created_Date__c;
            createQueryHelper.frmdate = smsdate;
            whereClause += ' and Created_Date__c >=: frmdate ';
        }
        
        if (smstodate.Created_Date__c != null) {
            DateTime smstodate = smstodate.Created_Date__c;
            createQueryHelper.todate = smstodate;
            whereClause += ' and Created_Date__c <=: todate ';
        }

        list < SMS_History__c > smslst1 = CreateQueryHelper.getRecords(SMSObjName, 'CreatedDate,Id',
                       whereClause,CreateQueryHelper.RecentSMSDetailCSS,
                       'order by ' + sms_sortField + ' ' + sortDir, '');
        //populate map
        this.populateSMSMap(smslst1);

    }

  /*This method is used for handling searching criterias in Dispatch table*/
    public void searchDispatch() {
        dispatchMap.clear();
        lstDispatch_DetailView.clear();
        if (dispatchDateFrom.Despatch_Date__c > dispatchDateTo.Despatch_Date__c) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: From Date should be less than or equal to To Date.');
            ApexPages.addMessage(myMsg);
        }
        String whereClause = '';
        whereClause = 'where Account__r.CRN__c = \'' + Customer_CRN + '\'';


        if (dispatch.Contents__c != '' && dispatch.Contents__c != null) {
            dispatch.Contents__c = dispatch.Contents__c.replaceAll('[^a-zA-Z_0-9]','%');
           whereClause += ' and Contents__c like \'%' + dispatch.Contents__c + '%\'';
        }

        if (dispatch.Last_Delivery_Status__c != '' && dispatch.Last_Delivery_Status__c != null) {
           dispatch.Last_Delivery_Status__c = dispatch.Last_Delivery_Status__c.replaceAll('[^a-zA-Z_0-9]','%');
            whereClause += ' and Last_Delivery_Status__c like \'%' + dispatch.Last_Delivery_Status__c + '%\'';
        }

        if (dispatchDateFrom.Despatch_Date__c != null) {
            createQueryHelper.frmDispatchDate1 = dispatchDateFrom.Despatch_Date__c;
            whereClause += ' and Despatch_Date__c >=: frmDispatchDate1';
        }
        if (dispatchDateTo.Despatch_Date__c != null) {
            createQueryHelper.toDispatchDate1 = dispatchDateTo.Despatch_Date__c;
            whereClause += ' and Despatch_Date__c <=: toDispatchDate1';
        }

        list < Despatch__c > dispatchList = CreateQueryHelper.getRecords(DispatchObjName, 'CreatedDate,Id', whereClause,
                                                CreateQueryHelper.RecentDespatchDetailCSS,
                                                    'order by ' + dispatch_sortField + ' ' + sortDir, '');
        this.populateDispatchMap(dispatchList);
    }


    /*Following methods are used for handling pagination logics*/
    public void FirstPage() {
        OffsetSize = 0;
    }

    public void previous() {

        OffsetSize = OffsetSize - LimitSize - 1;

    }

    public void next() {
        OffsetSize = OffsetSize + LimitSize + 1;

    }

    public void LastPage() {
        OffsetSize = totalSms - math.mod(totalSms, LimitSize + 1);
          if(OffsetSize == totalrecs ){
          OffsetSize -= LimitSize +1;
          }
    }

    public boolean getprev() {
        if (OffsetSize == 0) return true;
        else return false;
    }

    public boolean getnxt() {
        if (((OffsetSize + LimitSize + 1) > totalSms) || ((OffsetSize + LimitSize + 1) == totalSms)) return true;
        else return false;
    }

    public boolean getnxtDoc() {

        if (((OffsetSize + LimitSize + 1) > totalDoc) || ((OffsetSize + LimitSize + 1) == totalDoc)) return true;
        else return false;
    }

    public void LastPageDoc() {

        OffsetSize = totalDoc - math.mod(totalDoc, LimitSize + 1);
          
          if(OffsetSize == totalrecs ){
          OffsetSize -= LimitSize +1;
          }
      

    }

    public boolean getnxtDispatch() {
        if (((OffsetSize + LimitSize + 1) > totalDispatch) || ((OffsetSize + LimitSize + 1) == totalDispatch))

        return true;
        else return false;
    }

    public void LastPageDispatch() {
        OffsetSize = totalDispatch - math.mod(totalDispatch, LimitSize+1);
          if(OffsetSize == totalrecs ){
          OffsetSize -= LimitSize +1;
          }
    }


   public list<String> getDocCategoryNames(){
     //get all the category type values selected and set by admin
                List<AdminDocumnetCategory__c> AdminControlledDocCategory=AdminDocumnetCategory__c.getAll().values();
                list<String> categoryNames=new list<String>();
                for(AdminDocumnetCategory__c AdminDocObj: AdminControlledDocCategory){
                   categoryNames.add('\''+AdminDocObj.name+'\'');
                }
      return categoryNames;
   }
   public String getDocNames(){
     //get all the category type values selected and set by admin
                 list<AdminDocumentName__c> allNameRecords = AdminDocumentName__c.getAll().values();
           String documentNames='';
           for(AdminDocumentName__c adminDocnameObj: allNameRecords ){
              String excluding_special_Char = adminDocnameObj.Document_Name__c;
              excluding_special_Char = excluding_special_Char.replaceAll('[^a-zA-Z_0-9]','%');
              
                     
              if(String.isBlank(documentNames)) {
                  documentNames = ' Name Like \''+excluding_special_Char +'\'';
              } else {
                  documentNames = documentNames  + ' or Name Like \''+excluding_special_Char +'\'';
              }
            }
      return documentNames;
   }

}