public with sharing class CSSCaseCreateController {


    public String CaseNo{get; set;}
    public String TAT{get; set;}
    public Id contactId;
    public string crn;
    public Id accId;    
    public Case NewCase;
    public Boolean Flag = true;
    //public Id AccOwnerId;
    //public String AccOwnerName;
    
    public CSSCaseCreateController() {
    
     Id userid = UserInfo.getUserid();
        contactId = [Select id, ContactId FROM User WHERE id =:userid].ContactID;
        if(contactId != null)
            {    
                crn = [Select id, AccountID, Account.CRN__c FROM Contact WHERE id =: contactId].Account.CRN__c;  
                        
                accId =[Select id, AccountID, Account.CRN__c, Account.OwnerId FROM Contact WHERE id =: contactId].Accountid;
                 system.debug('accId: '+accId); 
            }  
    }
    
    public Case getNewCase(){        
        if (NewCase == null)
        NewCase= new Case();
        return NewCase;
    }

    public PageReference submit() {
        Id CRNID;
        String Project;
        String Building;
        String Wing;
        String FlatNo;
        
        system.debug('accId: '+accId);
        //Id recdtypeId = [Select id from Recordtype where Name = 'Master'].id;
        //AccOwnerId = [Select ID, OwnerId from Contact where Id = :contactId].ownerId;
        //system.debug('AccOwnerId: '+AccOwnerId);
        //AccOwnerName = [Select Id, Name From User where Id =:AccOwnerId].FirstName;
        //system.debug('AccOwnerName: '+AccOwnerName);
        NewCase.Origin = 'Web';
        //NewCase.RecordTypeID = recdtypeId;
        //NewCase.Account_Owner__c = AccOwnerName;
        System.debug('CRNNAME&&&&&&&&&:' + crn);
       try{
            if(crn != null){
                Booking_Details__c bd = [Select id,Project__c,Wing__c,CLuster__c,Flat_No__c  from Booking_Details__c where CRN__c =: crn];
                CRNID = bd.id;
                Project = bd.Project__c;
                Building= bd.CLuster__c;
                Wing = bd.Wing__c;
                FlatNo = bd.Flat_No__c;
            }
            System.debug('CRNID&:' + CRNID);
            if(contactId != null && CRNID != null){
                NewCase.AccountId = accId;
                NewCase.CRN__c = CRNID;
                NewCase.Project__c = Project;
                NewCase.Buildings_Name__c = Building;
                NewCase.Wing__c = Wing;
                NewCase.Flat_No__c = FlatNo;
            }
            NewCase.SuppliedEmail = NewCase.Email__c;
            Flag = True;
            insert NewCase; 
            //system.debug('CASE Rec: '+ NewCase);
            //system.debug('case id: '+ NewCase.Id);
            Case c =[Select CaseNumber,TAT__c from Case where Id =: NewCase.Id];
            CaseNo = c.CaseNumber;
            TAT = (c.TAT__c).format();
        }
        catch(Exception ex){
            Flag = False;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Some Problem Occured While Logging Your Case. Please Contact Your Admiistrator');
            ApexPages.addMessage(myMsg);
        }  

        if(Flag){
        PageReference Thanks = Page.CSSCaseThankyouPage;
        Thanks.setRedirect(false);
        return Thanks;  
        } 
        return null;
    }

}