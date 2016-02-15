public class VisitFormController {

public string accountid;
public string opportunityid;
public opportunity opportunityobj {get; set;}
public boolean DOV {get; set;}
public boolean RDOV {get; set;}
public boolean VisitSelf{get; set;}
public boolean VisitFamily{get; set;}
public boolean VisitFriend{get; set;}
public boolean corporateaccount{get; set;}

public boolean LeadSource{get; set;}

public boolean LeadSourceLodhaContactCenter{get; set;}


public boolean LeadSourceMagazine{get; set;}


public boolean LeadSourceWordofmouth{get; set;}



public boolean IsReferredBookedAccount{get; set;}

public boolean IsExistingBookedAccountYes{get; set;}
public boolean IsExistingBookedAccountNo{get; set;}

public boolean displaysblock{get; set;}

public boolean referredaccount{get; set;}

Public string todaydate {get; set;}




Public VisitFormController(){
    try{
        //accountid=System.currentPageReference().getParameters().get('accid');
        opportunityid=System.currentPageReference().getParameters().get('oppid');
        DOV=false;
        RDOV=false;
        VisitSelf=false;
        VisitFamily=false;
        VisitFriend=false;
        LeadSource=false;
        referredaccount=false;
        todaydate=date.today().format();
        IsReferredBookedAccount=false;
        IsExistingBookedAccountYes=false;
        IsExistingBookedAccountNo=false;
        displaysblock=true;
        
        if(opportunityid != null && opportunityid != ''){
            opportunityobj=[select id,name,Project_Name__c,IsActive__c,Project_Interested__c,Visit_Form_No__c,Visiting_on_behalf_of__c,Date_of_Visit__c,
                            Budgeted_Price__c,Type_of_Accomodation__c,Purpose__c,Possession_desired_in__c,
                            Walk_in_Source__c,Referred_Booked_Account__r.lastname,Referrer_Account_CRN_formula__c,Corporate_Account__r.name,Referred_Booked_Account__r.firstname,Referred_Booked_Account__r.salutation,Walk_in_Referred_Booked_Account__c,Referred_Booked_Account__c,
                            SVF_Printed__c,SVF_Printed_On__c,
                            Account.id,Account.ispersonAccount,Account.lastname,Account.firstname,Account.salutation,Account.DOB_Of_Client__c,
                            Account.Address1_R_cont__pc,Account.Address2_R_cont__pc,Account.Address3_R_cont__pc,Account.Zone_R_cont__pc,
                            Account.City_cont__pc,
                            Account.Country_R_cont__pc,Account.Other_City_cont__pc,Account.State_R_cont__pc,Account.Pincode_R_cont__pc,
                            Account.Occupation_acc__c,Account.Lead_Company_Name_cont__pc,Account.Alternate_Designation__c,
                            Account.Designation__pc,
                            LeadSource,
                            Account.Address3_O_cont__pc,Account.Pincode_O_cont__pc,Account.Phone,Account.Office_Phone_cont__pc,Account.Personal_Email__pc,Account.PersonEmail,Account.Mobile_Phone__c,
                            Account.Type_of_Home__c,Account.Current_Home_ownership__c,Account.Car_s_Owned__c from opportunity where id=:opportunityid];
        }
    
        else{
            displaysblock=false;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Incorrect URL');
            ApexPages.addMessage(myMsg);
        }
    }
    catch(Exception e){
        system.debug('!!!!!!!!!!!!!Exception'+e);
    }

}

public pagereference actionmethod(){
if(opportunityobj != null){
    /*if(opportunityobj.Date_of_Visit__c != null){
        //DOV=true;
    }
    if(opportunityobj.Revisit_Confirmed__c != null){
        //RDOV=true;
    }*/
    
    if(opportunityobj.Visiting_on_behalf_of__c=='Self'){
        VisitSelf=true;
    }
    else if(opportunityobj.Visiting_on_behalf_of__c=='Family'){
        VisitFamily=true;
    }
    else if(opportunityobj.Visiting_on_behalf_of__c=='Friends/Colleague'){
        VisitFriend=true;    
    }
    if(opportunityobj.LeadSource!=''){
        LeadSource=true;
    }    
    
    if(opportunityobj.Referred_Booked_Account__c != null){
        IsReferredBookedAccount=true;
    }
    
    /*if(opportunityobj.Account.Existing_Booked_Customer__c=='Yes'){
        //IsExistingBookedAccountYes=true;
    }
    else if(opportunityobj.Account.Existing_Booked_Customer__c=='No'){        
        //IsExistingBookedAccountNo=true;
    }*/
    
    if(opportunityobj.Referred_Booked_Account__c != null){
        referredaccount=true;
    }
    if(opportunityobj.Corporate_Account__r.name != null){
        corporateaccount=true;
    }
    
    //JIRA - 374 Eternus 20/06/2014
    //Checks if SVF Printed is false, and update it to true
    //Added new Feild SVF_Printed_On__c with DateTime  Deepak Pudi 11/5/2014
    if(!opportunityobj.SVF_Printed__c){
        
        opportunityobj.SVF_Printed__c = true;
        opportunityobj.SVF_Printed_On__c = DateTime.Now();
        Database.Saveresult objSaveResult = Database.update(opportunityobj);
    }
 }
 else{
     displaysblock=false;
     ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Invalid Account Selected');
     ApexPages.addMessage(myMsg);
 }
    
    return null;


}


}