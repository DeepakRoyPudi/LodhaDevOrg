/*
*    Description: Controller to create a SMS History related list on Account detail page, the block will have filters and 
*                 each column on related list will be sortable
*
*    Version    Date          Auther           Description
*      1.0      05/20/2014    Asmita Bubane    Initial Draft
*
*/

public class SMSHistoryRelatedListController{

    // Properties
    public List<SMS_History__c> listSmsHistory{get; set;}
    public String searchName{get; set;}
    public SMS_History__c fromDateSearch{get; set;}
    public SMS_History__c toDateSearch{get; set;}
    public String sms_report_page{get; set;}    
    public boolean isEditLink{get; set;}
    public boolean isDeleteLink{get; set;}
    
    private Static final String STRCUSTOMERCARE = System.Label.CustomerCareProfile;
    private Static final String STRCUSTOMERCAREMANAGER = System.Label.CustomerCareManagerProfile;
    private Static final String STRCUSTOMERCAREE2C = System.Label.CustomerCareEmailToCase;
    private Static final String STRCUSTOMERCAREMANAGERE2C = System.Label.CustomerCareManagerEmailToCaseProfile;
    private Static final String STRSMSHISTORYREPORTID = System.Label.SmsHistoryReportId;
    // the current sort direction. defaults to asc
    public String sortDir {
        get  { if (sortDir == null) {  sortDir = 'desc'; } return sortDir;  }
        set;
    }
    // the current field to sort by. defaults to last name
    public String sortField {
        get  { if (sortField == null) {sortField = 'Created_Date__c'; } return sortField;  }
        set;
    }
    
    // Variables
    Account acct;
    public String query;
    List<SMS_History__c> listsmsRecords = new List<SMS_History__c>();
    String accId;
    DateTime fromDate;
    DateTime toDate;
    Id smsId;
    SMS_History__c delSmsHistory;
    Map<Id, Profile> mapProfileId = new Map<Id, Profile>();
    
    
    // Constructor
    public SMSHistoryRelatedListController(ApexPages.StandardController stdController) {
    
        acct = (Account)stdController.getRecord();
        accId = (Id)ApexPages.currentPage().getParameters().get('id');
        
        listSMSHistory = new List<SMS_History__c>();
        fromDateSearch = new SMS_History__c();
        toDateSearch = new SMS_History__c();
        
        // Setting query string
        query = 'select Id, Mobile_Number__c, SMS_Text__c, SMS_Type__c, Created_Date__c, Status__c, Remark__c from SMS_History__c where Account__c = :accId';
        
        getSmsHistoryList();
        isEditLink = true;
        isDeleteLink = true;
        renderActionLinks();
    }// end of Constructor
    
    
    
    // toggles the sorting of query from asc to desc
    public void toggleSort() {
      
      sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
      getSmsHistoryList();
    }// end of toggleSort
    
    
    
    // create list SMS History Records
    public List<SMS_History__c> getSmsHistoryList(){
    
        listSmsHistory = new List<SMS_History__c>();
        
        try{
              listSmsHistory = Database.query(query +  ' order by ' + sortField + ' ' + sortDir);
           } catch (Exception e) {
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops!'+e));
           }
                        
        return listSmsHistory;
    }// end of getsmsumentList
    
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
    
        fromDate = fromDateSearch.Created_Date__c;
        toDate = toDateSearch.Created_Date__c;
        
        if(searchName.contains('*'))
            searchName = searchName.replace('*','');
        
        query = '';
        query = 'select Id, Mobile_Number__c, SMS_Text__c, SMS_Type__c, Created_Date__c, Status__c, Remark__c from SMS_History__c where Account__c = :accId';
        
        if(searchName != '' && fromDate != null && toDate != null){
            query = query + ' and SMS_Type__c LIKE \'%' + searchName + '%\' and Created_Date__c >= :fromDate and Created_Date__c <= :toDate';
        }
        else if(searchName != '' && fromDate != null && toDate == null){
            toDate = System.today();
            query = query + ' and SMS_Type__c LIKE \'%' + searchName + '%\' and Created_Date__c >= :fromDate and Created_Date__c <= :toDate';
        }
        else if(searchName != '' && fromDate == null && toDate != null){
            fromDate = System.today();
            query = query + ' and SMS_Type__c LIKE \'%' + searchName + '%\' and Created_Date__c >= :fromDate and Created_Date__c <= :toDate';
        }
        else if(searchName != '' && fromDate == null && toDate == null){
            query = query + ' and SMS_Type__c LIKE \'%' + searchName + '%\'';
        }
        else if(searchName == '' && fromDate != null && toDate != null){
            query = query + ' and Created_Date__c >= :fromDate and Created_Date__c <= :toDate';
        }
        else if(searchName == '' && fromDate == null && toDate != null){
            query = query + ' and Created_Date__c <= :toDate';
        }
        else if(searchName == '' && fromDate != null && toDate == null){
            query = query + ' and Created_Date__c >= :fromDate';
        }
        
        System.debug('Query String ::::::::'+query);
        
        sortField = 'SMS_Type__c';
        sortDir = 'asc';
        
        getSmsHistoryList();
        
        return null;
    }// end of searchByFilter
    
    
    
    //Action method for smsument Report button
    public PageReference displayReport(){
    
        sms_report_page = '/' + STRSMSHISTORYREPORTID;
        
        return null;
    }// end of displayReport
    
    // method to open the Despatch record on click of view link
     public PageReference openSmsrecord(){
        
        Id smsId = (Id)ApexPages.currentPage().getParameters().get('smsId');
        PageReference page = new PageReference('/' + smsId);
        return page;
    }   
    
    // Method for Edit Link (edit link on page)
    public PageReference editSmsHistory(){
    
        smsId = (Id)ApexPages.currentPage().getParameters().get('smsId');
        PageReference page = new PageReference('/' + smsId + '/e?retURL=%2F' + acct.id);
        
        return page;
    }// end of editsmsument
    
    // Method to delete the smsument (del link on page)
    public void deleteSmsHistory(){
        smsId = (Id)ApexPages.currentPage().getParameters().get('smsId');
        
        for(SMS_History__c sms : listSmsHistory){
            if(sms.id == smsId)
            {
                delSmsHistory = sms;
            }
        }// end of for loop
        
        try{
            delete delSmsHistory;
        }
        catch(Exception e){
            System.debug('Exception :::: '+e);
        }
    }// end of deletesmsument
    
}// end of Controller