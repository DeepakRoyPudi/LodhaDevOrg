/* Version              Created By       Created Date       Description
 *
 *  Initial Draft       Sneha P.         27//02/2015       Controller for RecentDocsSMSDispatchDetailRM Page.
 *														   Displays Customers Docs/SMS/Dispatch in tabbed view 		
 *
 */
public with sharing class RecentDocsSMSDispatchDetailRMController {
    
    //Private Variables
    @testVisible private string PARAM_CRN;
    private integer totalRecsDoc = 0;
    private integer totalRecsSms = 0;
    private integer totalRecsDispatch = 0;
    
    private integer offsetSize = 0;
    private integer limitSize= 9;
    private Map<Integer, SMS_History__c> mapSms;    
    private Map<Integer, Documents__c> mapDoc;      
    @testVisible private Map<Integer, Despatch__c> mapDispatch;  

    //Properties
    public Despatch__c dispatch                 {get; set;}
    public Despatch__c dispatchDateTo           {get; set;}
    public Despatch__c dispatchDateFrom         {get; set;}
    public String currentTab                    {get; set;}
    public Documents__c fromDateSearch          {get; set;}
    public Documents__c toDateSearch            {get; set;}
    public String searchName                    {get; set;}
    public String doc_report_page               {get; set;}    
    public String doc_generate_page             {get; set;}
    public String iss_Link                      {get; set;}
    public SMS_History__c sms                   {get; set;}
    public SMS_History__c smsDateTo             {get; set;}
    public Integer noOfRecords                  {get; set;}   
    public boolean isEditLink                   {get; set;}
    public boolean isDeleteLink                 {get; set;}
    
    public String selectedSmsType				{get; set;}
    
    //Constants
    private static final String documentObjName = 'Documents__c';
    private static final String SMSObjName = 'SMS_History__c';
    private static final String dispatchObjName = 'Despatch__c';
    private static final String sortOrderDesc = 'desc NULLS Last'; 
    private static final String sortOrderAsc = 'asc NULLS First';
    private static final String createdDate = 'Date_of_Generation__c';
    private static final String dispatchDate = 'Despatch_Date__c';
    private static final String sentDate = 'Created_Date__c';
    private static final String CRN = 'CRN';
    private static final String documentTab= 'Documents';
    private static final String smsTab = 'SMS';
    
    //Constant to store Error Message 
    private static final String dateError = 'From Date should be less than To Date';
    private static final String noneValue = 'None';
    
    public List<SelectOption> getSmsType() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(noneValue,noneValue));
        for(SmsTypeForRmCss__c smsType : SmsTypeForRmCss__c.getall().values() ) {
	        options.add(new SelectOption(smsType.Name,smsType.Name));
        }
	    return options;
	}
    
    
    public list<SMS_History__c> smsList {
        set;
        get { 
            smsList.clear();
            for(Integer i = offsetSize ;i<=(offsetSize +limitSize ); i++ ) {
                smsList.add(mapSms.get(i)) ;
            }     
            return smsList;
        }
    } 
    
    public list<Documents__c> docList {
        set;
        get {
            docList.clear();
            for(Integer i = offsetSize ;i<=(offsetSize +limitSize ); i++ ) {
                docList.add(mapDoc.get(i)) ;
            }     
            return docList; 
        }
    }
    
    public list<Despatch__c> dispatchList {
        set;
        get {
            dispatchList.clear();
            for(Integer i = offsetSize ;i<=(offsetSize +limitSize ); i++ ) {
                dispatchList.add(mapDispatch.get(i)) ;
            }     
            return dispatchList; 
        }
    }
    
     // the current sort direction. defaults to asc
    public String sortDir {
        get  { if (sortDir == null) {  sortDir = sortOrderDesc; } return sortDir;  }
        set;
    }
    // the current field to sort by. defaults to last name
    public String sortField {
        get  { if (sortField == null) {sortField = createdDate; } return sortField;  }
        set;
    }  
    
    public String smsSortField {
        get  { if (smsSortField == null) {smsSortField = sentDate; } return smsSortField;  }
        set;
    }  
    
    public String dispatchSortField {
        get { 
        	if (dispatchSortField == null) {dispatchSortField = dispatchDate; } 
        		return dispatchSortField;  
        }
        set;
    }  
     
    //Constructor
    public RecentDocsSMSDispatchDetailRMController(){
        
        dispatch = new Despatch__c();
        dispatchDateTo = new Despatch__c();
        dispatchDateFrom = new Despatch__c();
        sms = new SMS_History__c();
        smsDateTo = new SMS_History__c();
        fromDateSearch = new Documents__c();
        toDateSearch = new Documents__c();
        smsList = new list<SMS_History__c>();
        docList = new list<Documents__c>();
        dispatchList = new list<Despatch__c>();
        mapSms = new map<Integer, SMS_History__c>();
        mapDoc = new map<Integer, Documents__c>();
        mapDispatch = new map<Integer, Despatch__c>();          
        
        PARAM_CRN = ApexPages.currentPage().getParameters().get(CRN);
        currentTab = ApexPages.currentPage().getParameters().get('selectedTab');

        this.populateDocMap(CreateQueryHelper.getRecords(DocumentObjName,
                                        			 'Id,CreatedDate,Document_URL__c ',
                                       				 'where Account__r.CRN__c = \''+PARAM_CRN+'\'',
                                       				  CreateQueryHelper.RecentDocsDetailRM, 
                                      				  'order by '+sortField+' '+sortDir ,
                                      				  ''));
        
        isEditLink = true;
        isDeleteLink = true;
        renderActionLinks();
    }
    
    /* Method to return true or false to render Edit/Delete link depending on User
     * Permission.
     */
    public void renderActionLinks(){
        
        //Check if the User has Edit access for that object then only display Edit link
        if(!Schema.sObjectType.Documents__c.isUpdateable())
        	isEditLink = false;
        
        //Check if the User has Delete access for that object then only display Delete link
        if(!Schema.sObjectType.Documents__c.isDeletable())
        	isDeleteLink = false;
    }
    
    /* Function is executed when the Tab is changed on the Page, this will reinitialize values
     * and check the current selected tab to call respective method
     */
    public void resetOnTabChange() {
       
        offsetSize = 0;
        limitSize= 9;
        sortDir = sortOrderDesc;
        
        String slctdTab = apexpages.currentpage().getparameters().get('currTab');
        
        if(String.isNotBlank(slctdTab))        
            currentTab = slctdTab;
        if(currentTab == documentTab) {
          fromDateSearch.Date_of_Generation__c = null;
          toDateSearch.Date_of_Generation__c = null;
          searchDocs();
        } else if(currentTab == smsTab) {
          sms.SMS_Type__c = null;
          sms.Created_Date__c = null;
          smsDateTo.Created_Date__c = null;
          searchSms();
        } else {
          dispatch.Last_Delivery_Status__c = null;
          dispatchDateTo.Despatch_Date__c = null;
          dispatchDateFrom.Despatch_Date__c = null;
          dispatch.Contents__c = null;
          searchDispatch();
        }
    }
    
    /* Method to search Document records based on Created Date and populate a map with 
     * filtered data
     */
    public void searchDocs() {
        
        if(fromDateSearch.Date_of_Generation__c > toDateSearch.Date_of_Generation__c) {
          ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, dateError));
          return;
        }
        
        docList.clear();
        mapDoc.clear();
        
        string whereClause =  'where Account__r.CRN__c = \''+PARAM_CRN+'\'';
        
        if(fromDateSearch.Date_of_Generation__c != null) {
          createQueryHelper.frmdate = fromDateSearch.Date_of_Generation__c ;
          whereClause += ' and Date_of_Generation__c >=:frmdate' ;
        }
        
        if(toDateSearch.Date_of_Generation__c != null) {        
            createQueryHelper.todate = toDateSearch.Date_of_Generation__c;
            whereClause += ' and Date_of_Generation__c <=: todate' ;

        }
		this.populateDocMap(CreateQueryHelper.getRecords(DocumentObjName,
														 'Id,CreatedDate,Document_URL__c ',
                                           				  whereClause,
                                           				  CreateQueryHelper.RecentDocsDetailRM, 
                                          				  'order by '+sortField+' '+sortDir ,
                                          				  ''));
    }
    
    /* Method to search Dispatch records based on Created Date and populate a map with 
     * filtered data
     */
    public void searchSms() {
        String whereClause = 'where Account__r.CRN__c = \''+PARAM_CRN+'\'';
        mapSms.clear();
        smsList.clear();
        
         if(String.isNotBlank(selectedSmsType) && !selectedSmsType.equalsIgnoreCase(noneValue)) {
            whereClause += ' and SMS_Type__c = \''+selectedSmsType+'\'';
        }
        
        if( sms.Created_Date__c != null  ) {
            createQueryHelper.frmdate = DateTime.newInstance(sms.Created_Date__c.Year(),
                                       sms.Created_Date__c.month(),
                                       sms.Created_Date__c.day(),
                                       0,
                                       0,
                                       0);
             
             whereClause += ' and Created_Date__c >=: frmdate';
             
        }
        if(smsDateTo.Created_Date__c != null) {
             createQueryHelper.toDate = DateTime.newInstance(smsDateTo.Created_Date__c.Year(),
                                        smsDateTo.Created_Date__c.month(),
                                       smsDateTo.Created_Date__c.day(),
                                       23,
                                       59,
                                       59);
            whereClause += ' and Created_Date__c <=: toDate';   
        }
        
		this.populateSMSMap(CreateQueryHelper.getRecords(SMSObjName,
       													'Id,CreatedDate',
                                                		whereClause,
                                                 		CreateQueryHelper.RecentSMSDetailRM, 
                                              			'order by '+smsSortField+' '+sortDir ,''));
       
     }
     
    /* Method to search Dispatch records based on Content, Last Delivery status and From and to date
    * and populate a map with filtered data
    */
    public void searchDispatch() {
        
        if(dispatchDateFrom != null && dispatchDateTo != null &&
           dispatchDateFrom.Despatch_Date__c > dispatchDateTo.Despatch_Date__c) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, dateError));
            return;
        }
        String whereClause = '';
        whereClause = 'where Account__r.CRN__c = \''+PARAM_CRN+'\'';
        
        if(String.isNotBlank(dispatch.Contents__c)) {
            whereClause += ' and Contents__c like \'%'+dispatch.Contents__c+'%\'';
        }
        
        if(String.isNotBlank(dispatch.Last_Delivery_Status__c)) { 
            whereClause += ' and Last_Delivery_Status__c = \''+dispatch.Last_Delivery_Status__c+'\'';
        }
        
        if(dispatchDateFrom.Despatch_Date__c != null) {
            createQueryHelper.frmDispatchDate = dispatchDateFrom.Despatch_Date__c;
            whereClause += ' and Despatch_Date__c >=: frmDispatchDate';
            
        }
        
        if(dispatchDateTo.Despatch_Date__c != null) {
            createQueryHelper.toDispatchDate = dispatchDateTo.Despatch_Date__c;
            whereClause += ' and Despatch_Date__c <=: toDispatchDate';
        }
        
        createQueryHelper.todate = dispatchDateTo.Despatch_Date__c;
        this.populateDispatchMap(CreateQueryHelper.getRecords(DispatchObjName,
    													   'Id,CreatedDate',
    													    whereClause,
                                                		    CreateQueryHelper.RecentDispatchDetailRM, 
                                                            'order by '+dispatchSortField+' '+sortDir ,
                                                            ''));
    }
     
     //toggles the sorting of query from asc to desc
    public void toggleSortSMS() {
      
      sortDir = sortDir.equals(sortOrderAsc) ? sortOrderDesc : sortOrderAsc;
      this.searchSMS();
    }// end of toggleSort
    
    //toggles the sorting of query from asc to desc
    public void toggleSortDoc() {
      
      sortDir = sortDir.equals(sortOrderAsc) ? sortOrderDesc : sortOrderAsc;
      this.searchDocs();
    }// end of toggleSort
    
    public void toggleSortDispatch() {
      
      sortDir = sortDir.equals(sortOrderAsc) ? sortOrderDesc : sortOrderAsc;
      this.searchDispatch();
    }
    
    //Method to populate a map of dispatch with index 
    public void populateDispatchMap(list<Despatch__c> pDispatchList){
        
        totalRecsDispatch = 0;
        mapDispatch.clear();
        dispatchList.clear();
        
        for(Despatch__c dispatch: pDispatchList) {
            mapDispatch.put(totalRecsDispatch ,dispatch);  
            totalRecsDispatch ++;                                    
        }   
       firstPage();
    }
    
    //Method to populate a map of SMS with index 
    public void populateSMSMap(list<SMS_History__c> smsHistoryList){
        
        totalRecsSms = 0;
        mapSms.clear();
        smsList.clear();
        
        for(SMS_History__c sms : smsHistoryList) {
            mapSms.put(totalRecsSms ,sms);  
            totalRecsSms ++;                                    
        }   
        firstPage();
    }
    
    //Method to populate a map of Document with index 
    public void populateDocMap(list<Documents__c> pDocList){
        
        totalRecsDoc = 0;
        mapDoc.clear();
        docList.clear();
        
        for(Documents__c doc : pDocList) {
            mapDoc.put(totalRecsDoc,doc);  
            totalRecsDoc++;                                    
        }   
        firstPage();
    }
    
    // Method to delete document record
    public PageReference deleteDetailDocument(){
        String docId = (Id)ApexPages.currentPage().getParameters().get('docId');
        try{
            delete new Documents__c(Id = (Id)docId);
            PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
			pageRef.setRedirect(true);
			return pageRef;
            
        }
        catch(Exception e){
            system.debug('Exception :::: '+e);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
            return null;
        }
    }// end of deleteDocument
    
    // Action Method for Generate Documents button
    public PageReference generateDocuments() {
        
        doc_generate_page = System.Label.GenerateDocumentAddress; 
        return null;
    }
    
    // Action Method for Display ISS button     
    public PageReference displayIss() {
        iss_Link = System.Label.DocumentIssLink; 
        return null;
    }
    
    //Action method for Document Report button
    public PageReference displayReport() {
        doc_report_page = '/' + System.Label.DocumentReportId;
        return null;
    }
    
    //Pagination methods
    public void firstPage() {
        offsetSize = 0;
    }
     
    public void previous() {
        offsetSize = offsetSize - limitSize - 1;
    }
     
    public void next() {
        offsetSize = offsetSize + limitSize + 1;
    }
    
    public void lastPage() {
       offsetSize= totalRecsSms - math.mod(totalRecsSms ,limitSize + 1);
       
       if(offsetSize == totalRecsSms ){
          offsetSize = offsetSize- Integer.valueOf(limitSize) +1;
        }
    }
    
    public boolean getPrev() {
        return (offsetSize== 0) ? true : false;
    }
    
    public boolean getNxt() {
       return ((offsetSize + limitSize + 1) >= totalRecsSms ) ? true : false ;
    }
    
    public boolean getNxtDoc() {
       return ((offsetSize + limitSize + 1) >= totalRecsDoc) ?  true :  false;
    }

    public void lastPageDoc() {
       offsetSize= totalRecsDoc- math.mod(totalRecsDoc,limitSize + 1);
       
       if(offsetSize == totalRecsDoc ){
          offsetSize = offsetSize- Integer.valueOf(limitSize) +1;
        }
    }
    
    public boolean getNxtDispatch() {
       return ((offsetSize + limitSize + 1) >= totalRecsDispatch) ?  true :  false;
    }

	public void lastPageDispatch() {
       offsetSize= totalRecsDispatch- math.mod(totalRecsDispatch,limitSize + 1);
       
       if(offsetSize == totalRecsDispatch ){
          offsetSize = offsetSize- Integer.valueOf(limitSize) +1;
        }
     }
}