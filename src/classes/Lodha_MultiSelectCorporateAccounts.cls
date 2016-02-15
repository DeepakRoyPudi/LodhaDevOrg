public class Lodha_MultiSelectCorporateAccounts
{

    public Lodha_MultiSelectCorporateAccounts(ApexPages.StandardController controller) {

    }

    
 
    //Our collection of the class/wrapper objects cContact 
    public List<cContact> contactList {get; set;}
    public Boolean selectAllCheckbox {get; set;}
    
    //This method uses a simple SOQL query to return a List of Contacts
    public List<cContact> getCorporateAccounts(){
        if(contactList == null){
            contactList = new List<cContact>();
        
            for(Corporate_Account__c c : [select Id,Corporate_Group__c,Name,Industry_Types__c,Annual_Turnover__c,Contact_Number__c from Corporate_Account__c limit 1000]){
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
        List<Corporate_Account__c> selectedContacts = new List<Corporate_Account__c>();
        
        /*We will cycle through our list of cContacts and will check to see if the 
        selected property is set to true, if it is we add the Contact to the 
        selectedContacts list. */
        for(cContact cCon : getCorporateAccounts()){
           if(cCon.selected == true){
                selectedContacts.add(cCon.con);
            }
        }
        Id Campaignid = System.currentPageReference().getParameters().get('id');

        /* Now we have our list of selected contacts and can perform any type of 
        logic we want, sending emails, updating a field on the Contact, etc */
        System.debug('These are the selected Contacts...');
        for(Corporate_Account__c con : selectedContacts){
            con.Campaign__c =Campaignid ;
        }
        update selectedContacts;
        String url='/'+CampaignId;
        PageReference DetailPage = new PageReference(url);
        DetailPage.setRedirect(true);
        return DetailPage;
        
    }
    
    /* This is our wrapper/container class. A container class is a class, a data 
    structure, or an abstract data type whose instances are collections of other 
    objects. In this example a wrapper class contains both the standard salesforce 
    object Contact and a Boolean value */
    public class cContact{
        public Corporate_Account__c con {get; set;}
        public Boolean selected {get; set;}
        
        /*This is the contructor method. When we create a new cContact object we pass a 
        Contact that is set to the con property. We also set the selected value to false*/
        public cContact(Corporate_Account__c c){
            con = c;
            selected = false;
        }
    }
    
    public static testMethod void valid()
{
    Corporate_Account__c testspa = new Corporate_Account__c(Name='Aparnafirms');
        insert testspa;
    ApexPages.StandardController stdController = new ApexPages.StandardController(testspa);
    Lodha_MultiSelectCorporateAccounts test = new Lodha_MultiSelectCorporateAccounts(stdController);
    PageReference p = test.processSelected();
}


}