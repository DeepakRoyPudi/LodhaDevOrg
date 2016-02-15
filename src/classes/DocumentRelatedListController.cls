/*
*    Description: Controller to create a Document related list on Account detail page, the block will have filters and 
*                 each column on related list will be sortable
*
*    Version    Date          Auther           Description
*      1.0      05/20/2014    Asmita Bubane    Initial Draft
*
*/

public class DocumentRelatedListController{

    // Properties
    public List<Documents__c> listDocument{get; set;}
    public String searchName{get; set;}
    public Despatch__c fromDateSearch{get; set;}
    public Despatch__c toDateSearch{get; set;}
    public String doc_generate_page{get; set;}
    public String doc_report_page{get; set;}    
    public String iss_Link{get; set;}
    public boolean isEditLink{get; set;}
    public boolean isDeleteLink{get; set;}
    
    private Static final String STRCUSTOMERCARE = System.Label.CustomerCareProfile;
    private Static final String STRCUSTOMERCAREMANAGER = System.Label.CustomerCareManagerProfile;
    private Static final String STRCUSTOMERCAREE2C = System.Label.CustomerCareEmailToCase;
    private Static final String STRCUSTOMERCAREMANAGERE2C = System.Label.CustomerCareManagerEmailToCaseProfile;
    private Static final String STRDOCUMENTREPORTID = System.Label.DocumentReportId;
    private Static final String STRGENERATEDOCUMENTADDRESS = System.Label.GenerateDocumentAddress;
    private Static final String STRISSLINK = System.Label.DocumentIssLink;
    
    // the current sort direction. defaults to asc
    public String sortDir {
        get  { if (sortDir == null) {  sortDir = 'desc'; } return sortDir;  }
        set;
    }
    // the current field to sort by. defaults to last name
    public String sortField {
        get  { if (sortField == null) {sortField = 'Date_of_generation__c'; } return sortField;  }
        set;
    }
    
    // Variables
    Account acct;
    public String query;
    List<Documents__c> listDocRecords = new List<Documents__c>();
    String accId;
    Date fromDate;
    Date toDate;
    Id docId;
    Documents__c delDoc;
    Map<Id, Profile> mapProfileId = new Map<Id, Profile>();
    
    
    // Constructor
    public DocumentRelatedListController(ApexPages.StandardController stdController) {
    
        acct = (Account)stdController.getRecord();
        accId = (Id)ApexPages.currentPage().getParameters().get('id');
        system.debug('accId :::::::: '+accId);
        
        listDocument = new List<Documents__c>();
        fromDateSearch = new Despatch__c();
        toDateSearch = new Despatch__c();
        
        // Setting query string
        query = 'select Id, Name, View_Document__c, View_Email__c, Document_Category__c, Version__c, Date_of_generation__c, Identification_Parameter__c, Publish_Mode__c, Document_Source__c, Email_URL__c, Document_URL__c, User__c from Documents__c where Account__c = :accId';
        
        getDocumentList();
        isEditLink = true;
        isDeleteLink = true;
        renderActionLinks();
    }// end of Constructor
    
    
    
    // toggles the sorting of query from asc to desc
    public void toggleSort() {
      
      sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
      getDocumentList(); 
    }// end of toggleSort
    
    
    
    // create list documents
    public List<Documents__c> getDocumentList(){
    
        listDocument = new List<Documents__c>();
        
       try{
              listDocument = Database.query(query +  ' order by ' + sortField + ' ' + sortDir);
       } 
       catch (Exception e) {
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops!'+e));
       }
                        
        return listDocument;
    }// end of getDocumentList
    
    // return true or false to render Edit/Delete link depending on profile
    public void renderActionLinks(){
        
        for(Profile oProfile : [select id, 
                                       Name 
                                from Profile 
                                where Name = :STRCUSTOMERCARE 
                                      OR Name = :STRCUSTOMERCAREMANAGER 
                                      OR Name = :STRCUSTOMERCAREMANAGERE2C 
                                      OR Name = :STRCUSTOMERCAREE2C]){
            mapProfileId.put(oProfile.id, oProfile);
        }
        
        if(mapProfileId.containsKey(UserInfo.getProfileId())){
            
            isEditLink = false;
            isDeleteLink = false;
        }
    }
    
    // Action method for Go Button
    public PageReference searchByFilter(){
    
        fromDate = fromDateSearch.Despatch_Date__c;
        if(toDateSearch.Despatch_Date__c != null)
            toDate = toDateSearch.Despatch_Date__c.addDays(1);
        else
            toDate = null;
        
        if(searchName.contains('*'))
            searchName = searchName.replace('*','');
        
        query = '';
        query = 'select Id, Name, View_Document__c, View_Email__c, Document_Category__c, Version__c, Date_of_generation__c, Identification_Parameter__c, Publish_Mode__c, Document_Source__c, Email_URL__c, Document_URL__c, User__c from Documents__c where Account__c = :accId';
        
        if(searchName != '' && fromDate != null && toDate != null){
            query = query + ' and Name LIKE \'%' + searchName + '%\' and Date_of_Generation__c >= :fromDate and Date_of_Generation__c <= :toDate';
        }
        else if(searchName != '' && fromDate != null && toDate == null){
            toDate = System.today();
            query = query + ' and Name LIKE \'%' + searchName + '%\' and Date_of_Generation__c >= :fromDate and Date_of_Generation__c <= :toDate';
        }
        else if(searchName != '' && fromDate == null && toDate != null){
            query = query + ' and Name LIKE \'%' + searchName + '%\' and Date_of_Generation__c <= :toDate';
        }
        else if(searchName != '' && fromDate == null && toDate == null){
            query = query + ' and Name LIKE \'%' + searchName + '%\'';
        }
        else if(searchName == '' && fromDate != null && toDate != null){
            query = query + ' and Date_of_Generation__c >= :fromDate and Date_of_Generation__c <= :toDate';
        }
        else if(searchName == '' && fromDate == null && toDate != null){
            query = query + ' and Date_of_Generation__c <= :toDate';
        }
        else if(searchName == '' && fromDate != null && toDate == null){
            query = query + ' and Date_of_Generation__c >= :fromDate';
        }
        
        System.debug('Query String ::::::::'+query);
        
        sortField = 'Name';
        sortDir = 'asc';
        
        getDocumentList();
        
        return null;
    }// end of searchByFilter
    
    
    
    // Action Method for Generate Documents button
    public PageReference generateDocuments(){
    
        doc_generate_page = STRGENERATEDOCUMENTADDRESS; //'http://172.29.7.81/cordys/print2pdf/';

        return null;
    }// end of generateDocuments
    
    public PageReference displayIss(){
        
        iss_Link = STRISSLINK; //'http://lodhaapps/iss/'; 
        return null;
    }
    
    //Action method for Document Report button
    public PageReference displayReport(){
    
        doc_report_page = '/' + STRDOCUMENTREPORTID;
        
        return null;
    }// end of displayReport
    
    // method to open the Document on click of document name
    public PageReference openDocument(){
        
        Id docId = (Id)ApexPages.currentPage().getParameters().get('docId');
        PageReference page = new PageReference('/' + docId);
        return page;
    }    
    
    // Method for Edit Link (edit link on page)
    public PageReference editDocument(){
    
        docId = (Id)ApexPages.currentPage().getParameters().get('docId');
        PageReference page = new PageReference('/' + docId + '/e?retURL=%2F' + acct.id);
        
        return page;
    }// end of editDocument
    
    // Method to delete the document (del link on page)
    public void deleteDocument(){
        docId = (Id)ApexPages.currentPage().getParameters().get('docId');
        
        for(Documents__c doc : listDocument){
            if(doc.id == docId)
            {
                delDoc = doc;
            }
        }// end of for loop
        
        try{
            delete delDoc;
        }
        catch(Exception e){
            System.debug('Exception :::: '+e);
        }
    }// end of deleteDocument
    
}// end of Controller