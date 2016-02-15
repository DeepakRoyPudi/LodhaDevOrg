public class Personaccountcontroller {

    
 List<accoutwrapper> accwrapperlist{get;set;}
 List<accoutwrapper> filteredaccwrapperlist{get;set;}
  
    public Personaccountcontroller(){    
         
         // AllPersonaccounts();
         displayfiltered=true;
    
    }
     
     public ApexPages.StandardSetController allaccountrecords{get; set;} 
     public ApexPages.StandardSetController filteredaccounts{get; set;} 
     public String inputvalue{get;set;}
     public Boolean displayall{get;set;}
     public Boolean displayfiltered{get;set;}
     public Integer recordssize{get;set;}
     public List<Sobject> accountlist{get;set;}
     set<id> accids;
     /*
     public void AllPersonaccounts(){
     
     displayall=true;
     displayfiltered=false;
     searchsucess=false;
     
        List<opportunity> opplist=[Select Id, AccountId, Account.Name,Amount, Account.RecordType.Name,Booking_Date__c,Account.H_Mobile_No__c,
        Account.Mobile_Phone__c,Oasys_Flat_Code__c,Stage__c,OASYS_Status__c from Opportunity 
        where Account.RecordType.Name =: 'Person Account' AND Booking_Date__c!=null AND ( (StageName='Closed Won') OR (StageName='Closed Book'))
        AND Oasys_Flat_Code__c !=null AND ( (OASYS_Status__c='Sold')OR(OASYS_Status__c='Booking')) order by Name];
          accountlist=new List<Sobject>();
          accids=new set<id>();
          
         for(opportunity opp: opplist){
             accids.add(opp.AccountId);         
         }       
         allaccountrecords= new ApexPages.StandardSetController(Database.getQueryLocator([select id,name,H_Mobile_No__c,Mobile_Phone__c from account where id in:accids order by Name]));
         allaccountrecords.setPageSize(25);          
           
     }  
 public List<accoutwrapper> getAccwrapperlist() {
        accwrapperlist= new List<accoutwrapper>();

        for (Account category : (List<Account>)allaccountrecords.getRecords())       
              accwrapperlist.add(new accoutwrapper(category));
        return accwrapperlist;
    }
    */
    
    /*
    
    public PageReference ViewAll() {     
        //  AllPersonaccounts();
         return null;
    } 
     */
     
public Boolean searchsucess{get;set;}    
public pagereference Searchbyname(){  
    try{
         
     if(inputvalue!=null && inputvalue!=''){
     
             //displayall=false;
             //displayfiltered=true;
             
             List<opportunity> opplist=[Select Id, Account.IsPersonAccount, AccountId, Amount, Account.RecordType.Name, Account.Firstname, Account.LastName, Account.Name, Account.Mobile_Phone__c, Account.H_Mobile_No__c, Booking_Date__c, Oasys_Flat_Code__c, Stage__c, OASYS_Status__c from Opportunity 
                where (Account.IsPersonAccount = true AND Account.RecordType.Name =: 'Person Account') AND ( (StageName='Closed Won') OR (StageName='Closed Lost') OR (StageName='Qualification')
                OR (StageName='Value Proposition') OR (StageName='Closed Book') OR (StageName='Disqualified') ) AND ((Account.Firstname LIKE : '%'+inputvalue+'%') OR (Account.LastName Like : '%'+inputvalue+'%') OR (Account.Name Like : '%'+inputvalue+'%') OR (Account.Mobile_Phone__c Like : '%'+inputvalue+'%') OR (Account.H_Mobile_No__c LIKE : '%'+inputvalue+'%'))  order by Name];
                  
                 accountlist=new List<Sobject>();
                 accids=new set<id>();
                  
                 for(opportunity opp: opplist){
                     accids.add(opp.AccountId);         
                 }  
             
             
             inputvalue='%'+inputvalue+'%';
             String Querystring= 'Select Id, Name, FirstName, LastName, H_Mobile_No__c, Mobile_Phone__c, IsPersonAccount from Account where (ID IN: accids) order by Name';
            
            filteredaccounts=new ApexPages.StandardSetController(Database.getQueryLocator(queryString)); 
             filteredaccounts.setPageSize(10);  
             searchsucess=true; 
             recordssize=filteredaccounts.getResultSize();                                            
          }
          }catch(Exception e){
           return null;
          }  
          inputvalue=inputvalue.replace('%','');
          return null;
    }
     
 public List<accoutwrapper> getFilteredaccwrapperlist() {
        filteredaccwrapperlist= new List<accoutwrapper>();
      if(inputvalue!=null && inputvalue!=''&&searchsucess){
        for (Account category : (List<Account>)filteredaccounts.getRecords())       
              Filteredaccwrapperlist.add(new accoutwrapper(category));
       
           }
        return filteredaccwrapperlist;
 
 }


  /*   
public Boolean hasNext {get{return allaccountrecords.getHasNext();}set;}
public Boolean hasPrevious {get{return allaccountrecords.getHasPrevious();}set;}
public Integer pageNumber {get{return allaccountrecords.getPageNumber();}set;}
public void previous(){allaccountrecords.previous();}  
public void next(){allaccountrecords.next();}
public void first(){allaccountrecords.first();}
public void last(){allaccountrecords.last();}
*/

public Boolean filteredhasNext {get{return filteredaccounts.getHasNext();}set;}
public Boolean filteredhasPrevious {get{return filteredaccounts.getHasPrevious();}set;}
public Integer filteredpageNumber {get{return filteredaccounts.getPageNumber();}set;}
public void filteredprevious(){filteredaccounts.previous();}  
public void filterednext(){filteredaccounts.next();}
public void filteredfirst(){filteredaccounts.first();}
public void filteredlast(){filteredaccounts.last();}



/************************************ Test Methods *************************************/   
  
    static testmethod void testPersonAccountController(){
    
        Account a = new Account();
            a.RecordTypeId=[Select id from RecordType where SobjectType='Account' AND Name='Person Account'].Id;
            a.FirstName='Test ';
            a.LastName='Brduser';
            a.H_Mobile_No__c='4444411111';
            a.Mobile_Phone__c='4444411111';
            insert a;
            
        Project_Name__c project=new Project_Name__c();
            project.Name='Test';
            project.Project_Type__c='Casa';
            insert project;
            
        Date bookDate = date.valueOf('2012-06-15');   
        Date closeDate = date.valueOf('2012-09-21');   
          
        Opportunity opp = new Opportunity();
            opp.Name='Brduser';
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
     /* 
        PageReference PersonAccountPage = Page.PersonAccountPage ;
           // PersonAccountPage.getParameters().put('inputvalue',a.LastName);   
            test.setCurrentPage(PersonAccountPage);
      */  
        PersonAccountController search=new PersonAccountController();  
            search.inputvalue='Brduser';
            search.Searchbyname();
            search.getFilteredaccwrapperlist();
            search.filteredprevious();
            search.filterednext();
            search.filteredfirst();
            search.filteredlast();
            
            //search.ViewAll();
            //search.filteredlast();
            
            
    }




}