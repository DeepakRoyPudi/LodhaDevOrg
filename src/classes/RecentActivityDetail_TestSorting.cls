public class RecentActivityDetail_TestSorting{

    //private variable
 public String Customer_CRN {get;set;} //get parameter from component
  private integer totalRecs = 0;
  @testVisible private integer OffsetSize = 0;
  @testVisible private integer LimitSize= 7; 
  @testVisible private Map<Integer, Case> caseMap {get;set;}
    
  public RecentActivityDetail_TestSorting()
    { 
         
    }
   
  public list<Case> caseLst {
     
        get{ 
          if(caseLst == null)
       caseLst = CreateQueryHelper.getRecords('Case','Id,CreatedDate','where Account.CRN__c = \''+Customer_CRN+'\'',
       				 CreateQueryHelper.RecentActivityDetailCSS,'','');
            return caseLst;  
            
            
       }
        set;
        
    }
}