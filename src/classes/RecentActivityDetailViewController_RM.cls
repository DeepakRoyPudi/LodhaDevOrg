/* Description - Controller for RecentActivityDetailView_RM
 *
 * Created By - Sneha P.
 *
 * Created Date - 27-01-15
 */

public with sharing class RecentActivityDetailViewController_RM {
    
    //Private Variables
    private string PARAM_CRN;
    
    //Properties
    public list<Case> lstCase {get; set;}
    
    
    //Constructor
    public RecentActivityDetailViewController_RM(){
        
        PARAM_CRN = ApexPages.currentPage().getParameters().get('CRN');
        this.displaycaselist();
    }
    
    //Method to get fields from fieldset
    public List<Schema.FieldSetMember> getFields() {
        return SObjectType.Case.FieldSets.RecentActivityDetailView_RM.getFields();
    }
    
    //Method to get all the Case records related to a CRN 
    public pagereference displaycaselist()
    {
        lstCase = new List<case>();
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : this.getFields()) {
            query += f.getFieldPath()+' , ' ;
        }
        query += 'Id FROM Case where Account.CRN__c = \''+PARAM_CRN+'\'';
        lstCase = Database.query(query);
        return null;
    }
    
}