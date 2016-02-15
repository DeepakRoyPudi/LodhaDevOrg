/**********************************************************************************
Name:  PersonalAccountHomeLoanController
Copyright © 2012  Lodha Group
===================================================================================
===================================================================================
Purpose:
-------
Controller For PersonalAccountHomeLoan VF page for Customer Portal Users
===================================================================================
===================================================================================
History
-------
VERSION                 AUTHOR                  DATE               DETAIL              
1.0 -                 CG Dev Team            14/06/2012      INITIAL DEVELOPMENT
**********************************************************************************/
public class PersonAccountHomeLoanController {


    public List<Opportunity> bookedopplist{get;set;}
    public List<accountwrapper> wrapperlist{get;set;}
    public String inputvalue{get;set;}
    public List<Account> accountfilterlist{get;set;}
    public Set<Id> accountids{get;set;}

     
    public PersonAccountHomeLoanController() {
        bookedopplist = new List<Opportunity>();
        Bookedaccounts();
    }
           
    public class accountwrapper{    
        public String Accountid{get;set;}
        public String AccountName{get;set;}
        public String mobilenumber{get;set;}
    } 
   
    public List<accountwrapper> Bookedaccounts()
    {
    try{
        bookedopplist = [Select Id, AccountId, Account.Name,Amount, Account.RecordType.Name,Booking_Date__c,Account.H_Mobile_No__c,
        Oasys_Flat_Code__c,Stage__c,OASYS_Status__c from Opportunity 
        where Account.RecordType.Name =: 'Person Account' AND Booking_Date__c!=null AND ( (StageName='Closed Won') OR (StageName='Closed Book'))
        AND Oasys_Flat_Code__c !=null AND ( (OASYS_Status__c='Sold')OR(OASYS_Status__c='Booking'))];
        
        wrapperlist=new List<accountwrapper>();
            accountids=new Set<Id>();   
        for(Opportunity Opp: bookedopplist)
            {        
            if(!accountids.contains(opp.AccountId)){
                         
                accountwrapper wrapper=new accountwrapper();
                wrapper.Accountid=Opp.AccountId;
                accountids.add(Opp.AccountId);
                wrapper.AccountName=Opp.Account.Name;
                wrapper.mobilenumber=opp.Account.H_Mobile_No__c;
                wrapperlist.add(wrapper);
              }
            
            }
        }catch(exception e){
         return null;
        }
        return wrapperlist;
    }
     public PageReference ViewAll() {     
         Bookedaccounts();
        return null;
    }


    public PageReference Searchbyname() {
    
    try{

     if(inputvalue!=null && inputvalue!=''){
     
             inputvalue='%'+inputvalue+'%';
             String Querystring='Select Id,Name,FirstName,LastName,H_Mobile_No__c from Account where ((Firstname LIKE '+'\''+inputvalue+'\''+') OR (LastName Like '+'\''+inputvalue+'\''+') OR (Name Like '+'\''+inputvalue+'\''+') OR (H_Mobile_No__c LIKE '+'\''+inputvalue+'\''+')) AND (ID IN: accountids )';     
             accountfilterlist=Database.Query(Querystring);                
             wrapperlist=new List<accountwrapper>();
             
          for(Account acc: accountfilterlist)
            {                            
                accountwrapper wrapper=new accountwrapper();
                wrapper.Accountid=acc.Id;
                wrapper.AccountName=acc.Name;
                wrapper.mobilenumber=acc.H_Mobile_No__c;
                wrapperlist.add(wrapper);            
            }   
       
          }else{         
               Bookedaccounts();         
          }
          }catch(Exception e){
           return null;
          }
          
          inputvalue=inputvalue.replace('%','');
        return null;
    }


    
/************************************ Test Methods *************************************/   
  
    static testmethod void testPersonAccountHomeLoanController(){
    
        Account a = new Account();
            a.RecordTypeId=[Select id from RecordType where SobjectType='Account' AND Name='Person Account'].Id;
            a.FirstName='Test ';
            a.LastName='Brduser';
            a.H_Mobile_No__c='4444411111';
            insert a;
            
        Project_Name__c project=new Project_Name__c();
            project.Name='Test';
            project.Project_Type__c='Casa';
            insert project;
            
        Date bookDate = date.valueOf('2012-06-15');   
        Date closeDate = date.valueOf('2012-09-21');   
        
        Opportunity opp = new Opportunity();
            opp.Name='abc';
            opp.Project_Name__c=project.Id;
            opp.Booking_Date__c=bookDate ;
            opp.CloseDate= closeDate;
            opp.RecordTypeId='012200000009NBSAA2';
            opp.AccountId=a.id;
            opp.Oasys_Flat_Code__c='423422312';
            opp.OASYS_Status__c='Booking';
            opp.StageName='Closed Won';
            opp.CRM_form__c = True;
            opp.Application_Form__c =True;
            opp.LoyaltyID__c='a';
            opp.LoyaltySourceId__c='b12';
            
            insert opp;
        
       
       
        PageReference PersonAccountHomeLoanPage = Page.PersonAccountHomeLoanPage ;
            PersonAccountHomeLoanPage.getParameters().put('inputvalue',a.LastName);   
            test.setCurrentPage(PersonAccountHomeLoanPage);
        
        PersonAccountHomeLoanController search=new PersonAccountHomeLoanController();  
            search.inputvalue='Account';
            search.ViewAll();
            search.Searchbyname();
            
    }
   
}