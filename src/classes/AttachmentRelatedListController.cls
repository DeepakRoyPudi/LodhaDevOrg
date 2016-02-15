/*
*    Description: Controller to create a Attachment related list on Case detail page, the block will have filters and 
*                 each column on related list will be sortable
*
*    Version    Date          Auther           Description
*      1.0      05/20/2014    Asmita Bubane    Initial Draft
*
*/

public class AttachmentRelatedListController{

    // Properties
    public List<Attachment> listAttachment{get; set;}
    public String searchName{get; set;}
    public Attachment fromDateSearch{get; set;}
    public Attachment toDateSearch{get; set;}
    public String attachFileLink{get; set;}
    public String viewFileLink{get; set;}
    public boolean isEditLink{get; set;}
    public boolean isDeleteLink{get; set;}
    public Task objTask1{get; set;}
    public Task objTask2{get; set;}
    
    private Static final String STRCUSTOMERCARE = System.Label.CustomerCareProfile;
    private Static final String STRFUNCTIONALTEAMMEMBER = System.Label.FTMProfile;
    private Static final String STRFUNCTIONALTEAMLEADER = System.Label.FTLProfile;

    // the current sort direction. defaults to asc
    public String sortDir {
        get  { if (sortDir == null) {  sortDir = 'desc'; } return sortDir;  }
        set;
    }
    // the current field to sort by. defaults to last name
    public String sortField {
        get  { if (sortField == null) {sortField = 'CreatedDate'; } return sortField;  }
        set;
    }
    
    // Variables
    Case oCase;
    public String query;
    List<Attachment> listDocRecords = new List<Attachment>();
    Map<Id, Profile> mapProfileId = new Map<Id, Profile>();
    DateTime fromDate;
    DateTime toDate;
    Id caseId;
    Id attachmentId;
    Attachment delAttachment;
    Case oCaseNumber;
    
    
    
    // Constructor
    public AttachmentRelatedListController(ApexPages.StandardController stdController) {
    
        oCase = (Case)stdController.getRecord();
        caseId = ''+oCase.id;
        System.debug('case ::::::::: '+oCase);
        oCaseNumber = new Case();
        oCaseNumber = [select CaseNumber from Case where id = :caseId];
        
        listAttachment = new List<Attachment>();
        fromDateSearch = new Attachment();
        toDateSearch = new Attachment();
        objTask1 = new Task();
        objTask2 = new Task();
        fromDate = null;
        toDate = null;
        
        // Setting query string
        query = 'select Id, Name, BodyLength, Description, LastModifiedDate, CreatedById, CreatedDate from Attachment where ParentId = :caseId';
        
        getAttachmentList();
        isEditLink = true;
        isDeleteLink = true;
        renderActionLinks();
    }// end of Constructor
    
    
    
    // toggles the sorting of query from asc to desc
    public void toggleSort() {
      
      sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
      getAttachmentList();
    }// end of toggleSort
    
    
    
    // create list documents
    public List<Attachment> getAttachmentList(){
    
        listAttachment = new List<Attachment>();
        
        listAttachment = Database.query(query +  ' order by ' + sortField + ' ' + sortDir);
                        
        return listAttachment;
    }// end of getDocumentList
    
    
    // return true or false to render Edit/Delete link depending on profile
    public void renderActionLinks(){
        
        for(Profile oProfile : [select id, Name from Profile where Name = :STRFUNCTIONALTEAMLEADER OR Name = :STRFUNCTIONALTEAMMEMBER OR Name = :STRCUSTOMERCARE]){
        	mapProfileId.put(oProfile.id, oProfile);
        }
        
        if(mapProfileId.containsKey(UserInfo.getProfileId())){
            
            isEditLink = false;
            isDeleteLink = false;
        }
        System.debug('Action render :::::: '+isEditLink + '::::::: ' + isDeleteLink);
    }
    
    // Action method for Go Button
    public PageReference searchByFilter(){
    
        fromDate = objTask1.ActivityDate;
        if(objTask2.ActivityDate != null)
            toDate = objTask2.ActivityDate.addDays(1);
        else
            toDate = objTask2.ActivityDate;
        System.debug('fromDate ::::'+fromDate);
        System.debug('toDate ::::'+toDate);
        
        if(searchName.contains('*'))
            searchName = searchName.replace('*','');
        
        query = '';
        query = 'select Id, Name, BodyLength, Description, LastModifiedDate, CreatedById, CreatedDate from Attachment where ParentId = :caseId';
        
        if(searchName != '' && fromDate != null && toDate != null){
            query = query + ' and Name LIKE \'%' + searchName + '%\' and CreatedDate >= :fromDate and CreatedDate <= :toDate';
        }
        else if(searchName != '' && fromDate != null && toDate == null){
            toDate = System.today();
            query = query + ' and Name LIKE \'%' + searchName + '%\' and CreatedDate >= :fromDate and CreatedDate <= :toDate';
        }
        else if(searchName != '' && fromDate == null && toDate != null){
            query = query + ' and Name LIKE \'%' + searchName + '%\' and CreatedDate <= :toDate';
        }
        else if(searchName != '' && fromDate == null && toDate == null){
            query = query + ' and Name LIKE \'%' + searchName + '%\'';
        }
        else if(searchName == '' && fromDate != null && toDate != null){
            query = query + ' and CreatedDate >= :fromDate and CreatedDate <= :toDate';
        }
        else if(searchName == '' && fromDate == null && toDate != null){
            query = query + ' and CreatedDate <= :toDate ';
        }
        else if(searchName == '' && fromDate != null && toDate == null){
            query = query + ' and CreatedDate >= :fromDate';
        }
        
        System.debug('Query String ::::::::'+query);
        
        sortField = 'Name';
        sortDir = 'asc';
        
        getAttachmentList();
        
        return null;
    }// end of searchByFilter
    
    public PageReference openAttachment(){
    	
    	attachmentId = (Id)ApexPages.currentPage().getParameters().get('attachId');
    	PageReference page = new PageReference('/' + attachmentId);
    	return page;
    }    
    
    // Action Method for Attach File button
    public PageReference attachFile(){
    	
    	attachFileLink = '/p/attach/NoteAttach?pid=' + caseId + '&parentname=' + oCaseNumber.CaseNumber + '&retURL=%2F' + caseId;
    	/*PageReference page = new PageReference('https://cs8.salesforce.com/p/attach/NoteAttach?pid=' + caseId + '&parentname=' + oCase.CaseNumber + '&retURL=%2F' + caseId);
    	return page;*/
    	
    	return null;

    }// end of attachFile
    
    public PageReference viewFile(){
    	
    	viewFileLink = '/ui/content/ViewAllAttachmentsPage?id=' + caseId + '&retURL=%2F' + caseId;
 		/*PageReference page = new PageReference('https://cs8.salesforce.com/ui/content/ViewAllAttachmentsPage?id=' + caseId + '&retURL=%2F' + caseId);
    	return page;*/
    	
    	return null;
    }
    
    // Method for Edit Link (edit link on page)
    public PageReference editAttachment(){
    
        attachmentId = (Id)ApexPages.currentPage().getParameters().get('attachId');
        PageReference page = new PageReference('/' + attachmentId + '/e?retURL=%2F' + caseId);
        
        return page;
    }// end of editDocument
    
    // Method to delete the document (del link on page)
    public void deleteAttachment(){
        attachmentId = (Id)ApexPages.currentPage().getParameters().get('attachId');
        
        for(Attachment attach : listAttachment){
            if(attach.id == attachmentId)
            {
                delAttachment = attach;
            }
        }// end of for loop
        
        try{
            delete delAttachment;
        }
        catch(Exception e){
            System.debug('Exception :::: '+e);
        }
    }// end of deleteDocument
    
}// end of Controller