/* this controller have been written for Component for Related List for RM (Customer 360) page. 1. Opportunities 2. Notes Attachment
 @Created by: Sudeep Dube
 @Created Date: 10/march/2015
 @Input Parameter:Account as Input parameter assign by calling the controller.
 --------------------------------------------------------------------------------
 | Modified By      | Modified Date       | Version        | Description         |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------
*/

public class RMRelatedListComponentController {


    // Properties
    public List < Attachment > listAttachment {get;set;}
    public String searchName {get;set;}
    public String attachFileLink {get;set;}
    public String viewFileLink {get;set;}
    Public Account oAccount {get;set;} //This property(account) assign by component parameter 
    
    // Constructor
    public RMRelatedListComponentController() {
        System.debug('Account::::::::');
    } // end of Constructor  
    
    //the method is called in first line of 
    //getAttchemnt method and it intialize all the required variable and objects
    public void preCallMethod() {
        idAccount = oAccount.id;
        listAttachment = new List < Attachment > ();
        // Setting query string
        query = 'select Id, Name, Description, LastModifiedDate, CreatedDate, CreatedById from Attachment where ParentId = :idAccount';

        getAttachmentList();
    }

    // the current sort direction. defaults to asc
    public String sortDir {
        get {
            if (sortDir == null) {
                sortDir = 'desc';
            }
            return sortDir;
        }
        set;
    }
    // the current field to sort by. defaults to last name
    public String sortField {
        get {
            if (sortField == null) {
                sortField = 'CreatedDate';
            }
            return sortField;
        }
        set;
    }

    // Variables
    //   Account oAccount;
    public String query;
    List < Attachment > listDocRecords = new List < Attachment > ();
    public Id idAccount;
    Id attachmentId;
    Attachment delAttachment;




    // toggles the sorting of query from asc to desc
    public void toggleSort() {

        sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
        getAttachmentList();
    } // end of toggleSort



    // create list documents
    public List < Attachment > getAttachmentList() {

        preCallMethod();

        listAttachment = new List < Attachment > ();

        try {
            listAttachment = Database.query(query + ' order by ' + sortField + ' ' + sortDir);

        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops!' + e));
        }

        return listAttachment;
    } // end of getDocumentList

    // Action method for Go Button
    public PageReference searchByFilter() {

        if (searchName.contains('*')) searchName = searchName.replace('*', '');

        query = '';
        query = 'select Id, Name, LastModifiedDate, CreatedDate, CreatedById from Attachment';

        if (searchName != '') {
            query = query + ' and Name LIKE \'%' + searchName + '%\'';
        }

        sortField = 'Name';
        sortDir = 'asc';

        getAttachmentList();

        return null;
    }


    public PageReference openAttachment() {

        attachmentId = (Id) ApexPages.currentPage().getParameters().get('attachId');
        PageReference page = new PageReference('https://cs8.salesforce.com/' + attachmentId);
        return page;
    }

    // Action Method for Attach File button
    public PageReference attachFile() {

        attachFileLink = 'https://cs8.salesforce.com/p/attach/NoteAttach?pid=' + 
        idAccount + '&parentname=' + oAccount.FirstName + '+' + 
        oAccount.LastName + '&retURL=%2F' + idAccount;
        return null;

    } // end of attachFile

    public PageReference viewAll() {

        viewFileLink = 'https://cs8.salesforce.com/ui/content/ViewAllNotesPage?id=' + 
            idAccount + '&retURL=%2F' + idAccount;
        return null;
    }

    // Method for Edit Link (edit link on page)
    public PageReference editAttachment() {

        attachmentId = (Id) ApexPages.currentPage().getParameters().get('attachId');
        PageReference page = new PageReference('https://cs8.salesforce.com/' + 
            attachmentId + '/e?retURL=%2F' + idAccount);

        return page;
    } // end of editDocument

    // Method to delete the document (del link on page)
    public PageReference deleteAttachment() {
        attachmentId = (Id) ApexPages.currentPage().getParameters().get('attachId');

        for (Attachment attach: listAttachment) {
            if (attach.id == attachmentId) {
                delAttachment = attach;
            }
        } // end of for loop

        try {
            delete delAttachment;
        } catch (Exception e) {
            System.debug('Exception :::: ' + e);
        }
        return null;
    } // end of deleteDocument
} // end of Controller