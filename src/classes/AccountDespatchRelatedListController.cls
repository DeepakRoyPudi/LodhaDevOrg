/*
*    Description: Controller to create a Despatch related list on Account detail page, along with Track button in front of 
*                 each record which will display the status of the delivered courier.
*
*    Version    Date          Auther           Description
*      1.0      05/27/2014    Asmita Bubane    Initial Draft
*
*/
public class AccountDespatchRelatedListController {
	
	// Properties
	public List<Despatch__c> listDespatch{get; set;} 
	public Id trackingNumber{get; set;}
	public String searchContent{get; set;}
	public String searchStatus{get; set;}
	public Despatch__c fromDateSearch{get; set;}
    public Despatch__c toDateSearch{get; set;}
    String sms_report_page{get; set;}
    public boolean isEditLink{get; set;}
    public boolean isDeleteLink{get; set;}
    
    private Static final String STRCUSTOMERCARE = System.Label.CustomerCareProfile;
    private Static final String STRCUSTOMERCAREMANAGER = System.Label.CustomerCareManagerProfile;
    private Static final String STRCUSTOMERCAREE2C = System.Label.CustomerCareEmailToCase;
    private Static final String STRCUSTOMERCAREMANAGERE2C = System.Label.CustomerCareManagerEmailToCaseProfile;
	// the current field to sort by. defaults to last name
    public String sortField {
        get  { if (sortField == null) {sortField = 'Date_of_Generation__c'; } return sortField;  }
        set;
    }
    // the current sort direction. defaults to asc
    public String sortDir {
        get  { if (sortDir == null) {  sortDir = 'desc'; } return sortDir;  }
        set;
    }
	
	
	// Variables 
	Account oAcc;
	public String accId;
	public String query;
	Date fromDate;
    Date toDate;
    Despatch__c delDespatch;
    Id desId;
    Map<Id, Profile> mapProfileId = new Map<Id, Profile>();
	
	
	// Constructor
    public AccountDespatchRelatedListController(ApexPages.StandardController controller) {
    	
    	oAcc = (Account)controller.getRecord();
    	accId = (Id)ApexPages.currentPage().getParameters().get('id');
    	
    	fromDateSearch = new Despatch__c();
        toDateSearch = new Despatch__c();
    	
    	// Setting query string
        query = 'select Id, Waybill_No__c, Waybill_Date__c, Sender_Name__c, Despatch_Date__c, Courier_Name__c, Last_Delivery_Status__c, Slug__c, Contents__c, Area__c, Milestone__c, Delivered_Date__c from Despatch__c where Account__c = :accId';
    	
		getDespatchRecords();
		isEditLink = true;
        isDeleteLink = true;
        renderActionLinks();
    }// End of Constructor
    
    // toggles the sorting of query from asc to desc
    public PageReference toggleSort() {
      
      sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
      getDespatchRecords();
      
      return null;
    }// end of toggleSort
    
    // Method to get the related Despatch records of Account
    public List<Despatch__c> getDespatchRecords(){
    	
    	listDespatch = new List<Despatch__c>();
    	
    	try{
              listDespatch = Database.query(query +  ' order by ' + sortField + ' ' + sortDir);
        } catch (Exception e) {
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops!'+e));
        }
    	
        return listDespatch;
    }// End of getDespatchRecords()
    
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
        toDate = toDateSearch.Despatch_Date__c;
    	
    	 if(searchContent.contains('*'))
            searchContent = searchContent.replace('*','');
            
        if(searchStatus.contains('*'))
            searchStatus = searchStatus.replace('*','');
        
        query = '';
        query = 'select Id, Waybill_No__c, Waybill_Date__c, Sender_Name__c, Despatch_Date__c, Courier_Name__c, Last_Delivery_Status__c, Slug__c, Contents__c, Area__c, Milestone__c, Delivered_Date__c  from Despatch__c where Account__c = :accId';
        
        if(searchContent != '' && fromDate != null && toDate != null && searchStatus != ''){
            query = query + ' and Contents__c LIKE \'%' + searchContent + '%\' and Date_of_Generation__c >= :fromDate and Date_of_Generation__c <= :toDate and Last_Delivery_Status__c LIKE \'%' + searchStatus + '%\'';
        }
        else if(searchContent != '' && fromDate != null && toDate != null && searchStatus == ''){
            query = query + ' and Contents__c LIKE \'%' + searchContent + '%\' and Date_of_Generation__c >= :fromDate and Date_of_Generation__c <= :toDate';
        }
        else if(searchContent != '' && fromDate != null && toDate == null && searchStatus != ''){
        	toDate = System.today();
            query = query + ' and Contents__c LIKE \'%' + searchContent + '%\' and Date_of_Generation__c >= :fromDate and Date_of_Generation__c <= :toDate and Last_Delivery_Status__c LIKE \'%' + searchStatus + '%\'';
        }
        else if(searchContent != '' && fromDate != null && toDate == null && searchStatus == ''){
        	toDate = System.today();
            query = query + ' and Contents__c LIKE \'%' + searchContent + '%\' and Date_of_Generation__c >= :fromDate and Date_of_Generation__c <= :toDate';
        }
        else if(searchContent != '' && fromDate == null && toDate != null && searchStatus != ''){
        	fromDate = System.today();
            query = query + ' and Contents__c LIKE \'%' + searchContent + '%\' and Date_of_Generation__c >= :fromDate and Date_of_Generation__c <= :toDate and Last_Delivery_Status__c LIKE \'%' + searchStatus + '%\'';
        }
        else if(searchContent != '' && fromDate == null && toDate != null && searchStatus == ''){
        	fromDate = System.today();
            query = query + ' and Contents__c LIKE \'%' + searchContent + '%\' and Date_of_Generation__c >= :fromDate and Date_of_Generation__c <= :toDate';
        }
        else if(searchContent != '' && fromDate == null && toDate == null && searchStatus != ''){
            query = query + ' and Contents__c LIKE \'%' + searchContent + '%\' and Last_Delivery_Status__c LIKE \'%' + searchStatus + '%\'';
        }
        else if(searchContent != '' && fromDate == null && toDate == null && searchStatus == ''){
            query = query + ' and Contents__c LIKE \'%' + searchContent + '%\'';
        }
        else if(searchContent == '' && fromDate != null && toDate != null && searchStatus != ''){
        	fromDate = System.today();
            query = query + ' and Date_of_Generation__c >= :fromDate and Date_of_Generation__c <= :toDate and Last_Delivery_Status__c LIKE \'%' + searchStatus + '%\'';
        }
        else if(searchContent == '' && fromDate != null && toDate != null && searchStatus == ''){
        	fromDate = System.today();
            query = query + ' and Date_of_Generation__c >= :fromDate and Date_of_Generation__c <= :toDate';
        }
        else if(searchContent == '' && fromDate != null && toDate == null && searchStatus != ''){
        	toDate = System.today();
            query = query + ' and Date_of_Generation__c >= :fromDate and Date_of_Generation__c <= :toDate and Last_Delivery_Status__c LIKE \'%' + searchStatus + '%\'';
        }
        else if(searchContent == '' && fromDate != null && toDate == null && searchStatus == ''){
            query = query + ' and Date_of_Generation__c >= :fromDate';
        }
        else if(searchContent == '' && fromDate == null && toDate != null && searchStatus != ''){
        	fromDate = System.today();
            query = query + ' and Date_of_Generation__c >= :fromDate and Date_of_Generation__c <= :toDate and Last_Delivery_Status__c LIKE \'%' + searchStatus + '%\'';
        }
        else if(searchContent == '' && fromDate == null && toDate != null && searchStatus == ''){
            query = query + ' and Date_of_Generation__c <= :toDate';
        }
        else if(searchContent == '' && fromDate == null && toDate == null && searchStatus != ''){
        	fromDate = System.today();
            query = query + ' and Last_Delivery_Status__c LIKE \'%' + searchStatus + '%\'';
        }
        
        
        System.debug('Query String ::::::::'+query);
        
        sortField = 'Waybill_No__c';
        sortDir = 'asc';
        
        getDespatchRecords();
        
        return null;
    }
    
     // method to open the Despatch record on click of view link
     public PageReference openDespatch(){
    	
    	Id despatchId = (Id)ApexPages.currentPage().getParameters().get('despatchId');
    	PageReference page = new PageReference('/' + despatchId);
    	return page;
    }    
    
    // Method for Edit Link (edit link on page)
    public PageReference editDespatch(){
    
        desId = (Id)ApexPages.currentPage().getParameters().get('desId');
        PageReference page = new PageReference('/' + desId + '/e?retURL=%2F' + accId);
        
        return page;
    }// end of editDocument
    
    // Method to delete the despatch record (del link on page)
    public void deleteDespatch(){
        desId = (Id)ApexPages.currentPage().getParameters().get('desId');
        
        for(Despatch__c des : listDespatch){
            if(des.id == desId)
            {
                delDespatch = des;
            }
        }// end of for loop
        
        try{
            delete delDespatch;
        }
        catch(Exception e){
            System.debug('Exception :::: '+e);
        }
    }// end of deleteDocument
    
}