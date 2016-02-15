public class RecentActivityCrispViewController_RM
{
    public list<Case> lstCase {get; set;}
    public string getcasetype{get;set;}
    Public Integer noOfRecords{get; set;}
    Public Integer size{get;set;}
   
    public RecentActivityCrispViewController_RM(){}
    
     public list<selectoption> getCasestatus()
    {
        list<selectoption>selectopt=new list<selectoption>();
        
        selectopt.add(new selectoption('New','New'));
        selectopt.add(new selectoption('Working','Working'));
        selectopt.add(new selectoption('Escalated','Escalated'));
        selectopt.add(new selectoption('Closed','Closed'));
        return selectopt;
    }
    
    public List<Schema.FieldSetMember> getFields() {
        return SObjectType.Case.FieldSets.RecentActivityCrispView_RM.getFields();
    }
    public pagereference displaycaselist()
    {
        lstCase = new List<case>();
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : this.getFields()) {
            query += f.getFieldPath()+' , ' ;
        }
        //it was showing result according to the case status selected 
        //query += 'Id,CaseNumber FROM Case where status=:getcasetype Order By LastModifiedDate limit 3';
        query += 'Id,CaseNumber FROM Case Order By LastModifiedDate limit 3';
        lstCase = Database.query(query);
        
        return null;
    }
    
    
      /*public list<Case> getlstCase() {
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : this.getFields()) {
            query += f.getFieldPath() + ', ';
        }
        query += 'Id FROM Case';
        return Database.query(query);
    }*/
}