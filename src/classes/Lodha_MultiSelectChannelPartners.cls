public class Lodha_MultiSelectChannelPartners
{

    public Lodha_MultiSelectChannelPartners(ApexPages.StandardController controller) {

    }

    
 
    //Our collection of the class/wrapper objects cContact 
    public List<cContact> contactList {get; set;}
    public Boolean selectAllCheckbox {get; set;}
    
    //This method uses a simple SOQL query to return a List of Contacts
    public List<cContact> getChannelPartners(){
        if(contactList == null){
            contactList = new List<cContact>();
        
            for(Channel_Partner__c c : [select Id,Channel_Partner_RefNo__c,Email__c,Name,Type_of_Channel_Partner__c from Channel_Partner__c limit 1000]){
                /* As each contact is processed we create a new cContact object and
                add it to the contactList */
                contactList.add(new cContact(c));
            }
        }
        return contactList;
    }
    
    public PageReference processSelected(){
        /*We create a new list of Contacts that we be populated only with Contacts
        if they are selected*/
        List<Channel_Partner__c> selectedContacts = new List<Channel_Partner__c>();
        
        /*We will cycle through our list of cContacts and will check to see if the 
        selected property is set to true, if it is we add the Contact to the 
        selectedContacts list. */
        for(cContact cCon : getChannelPartners()){
           if(cCon.selected == true){
                selectedContacts.add(cCon.con);
            }
        }
        Id Leadid = System.currentPageReference().getParameters().get('id');

        /* Now we have our list of selected contacts and can perform any type of 
        logic we want, sending emails, updating a field on the Contact, etc */
        System.debug('These are the selected Contacts...');
        for(Channel_Partner__c con : selectedContacts){
            con.Lead__c =Leadid ;
        }
        update selectedContacts;
        String url='/'+Leadid;
        PageReference DetailPage = new PageReference(url);
        DetailPage.setRedirect(true);
        return DetailPage;
        
    }
    
    /* This is our wrapper/container class. A container class is a class, a data 
    structure, or an abstract data type whose instances are collections of other 
    objects. In this example a wrapper class contains both the standard salesforce 
    object Contact and a Boolean value */
    public class cContact{
        public Channel_Partner__c con {get; set;}
        public Boolean selected {get; set;}
        
        /*This is the contructor method. When we create a new cContact object we pass a 
        Contact that is set to the con property. We also set the selected value to false*/
        public cContact(Channel_Partner__c c){
            con = c;
            selected = false;
        }
    }
    
 public static testMethod void valid()
{
    Channel_Partner__c testspa = new Channel_Partner__c(Name='Aparnafirms',Type_of_Channel_Partner__c='Domestic',Email__c='xy@hotmail.com');
        insert testspa;
    ApexPages.StandardController stdController = new ApexPages.StandardController(testspa);
    Lodha_MultiSelectChannelPartners test = new Lodha_MultiSelectChannelPartners(stdController);
    PageReference p = test.processSelected();
}

}