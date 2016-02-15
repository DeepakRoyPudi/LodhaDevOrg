public class CustQueryContrl {
    
    public CustQueryContrl() {
    }
    
    public String CaseNo{get; set;}
    public String TAT{get; set;}
    public Case NewCase;
    public Boolean Flag = true;
    public Case getNewCase(){
    if (NewCase == null)
    NewCase= new Case();
    return NewCase;
    }
    
    public PageReference submit() {
        NewCase.Origin = 'Web';
        NewCase.SuppliedEmail = NewCase.Email__c;
        NewCase.RecordtypeId = RecordTypeHelper.getRecordTypeId('Case','Other Cases');
        try{
            Flag = True;
            insert NewCase;   
            Case c =[Select CaseNumber,TAT__c from Case where Id =: NewCase.Id];
            CaseNo = c.CaseNumber;
            TAT = (c.TAT__c).format();
        }
        catch(Exception ex){
            Flag = False;
            ApexPages.addMessages(ex);
        }       

        if(Flag){
        PageReference Thanks = Page.queryThanksPage;
        Thanks.setRedirect(false);
        return Thanks;  
        } 
        return null;  
    }

}