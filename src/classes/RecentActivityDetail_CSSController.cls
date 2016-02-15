/*Description:
This class is used for ecent activity (detail view) Component

 @Created by: Trupti Dhoka
 @Created Date:  16/03/15   
 
 --------------------------------------------------------------------------------
 | Modified By      | Modified Date       | Version        | Description         |
 --------------------------------------------------------------------------------
 |Trupti Dhoka          18/03/2015          1.1             Pagination logic
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------
*/
public class RecentActivityDetail_CSSController{

  
  public String Customer_CRN {get;set;} //get parameter from component
  
   //Constants
  //Constants
    private static final String DESC_NULLS_LAST = 'desc NULLS Last'; 
    private static final String ASC_NULLS_FIRST = 'asc NULLS First';
  
  //pagination variables
  @testVisible private integer OffsetSize = 0;
  @testVisible private integer LimitSize= 9; 
  @testVisible private integer totalRecs = 0;
  @testVisible private Map<Integer, Case> caseMap {get;set;}
   
  //constructor
  public RecentActivityDetail_CSSController(){ 
         
   }
   
    /*this list returns all the related dispatch associated to user fetched dynamically
     from CreateQueryHelper.getRecords*/
  public list<Case> caseList {
    set;
    get
    { 
        if(caseList == null)
            caseList = new list<Case>(); 
        if(caseMap == null) {
            caseMap = new Map<Integer, Case>();
            list<Case> caseLst = CreateQueryHelper.getRecords('Case','Id','where Account.CRN__c = \''+Customer_CRN+'\'', 
                                                   CreateQueryHelper.RecentActivityDetailCSS, 
                                                  'order by '+sortField+' '+sortDir,'');
             caseMap.clear();
            
             for(Case objCase : caseLst ) {
                caseMap.put(totalRecs,objCase );  
                totalRecs++;                         
            } 
        }
        caseList.clear();
        for(Integer i = OffsetSize ;i<=(OffsetSize +LimitSize ); i++ ) 
        {
            caseList.add(caseMap.get(i)) ;
        } 
        
        return caseList ;
        }
    }
    
   
     // the current sort direction. defaults to asc
    public String sortDir {
        get  { if (sortDir == null) {  sortDir = DESC_NULLS_LAST; } return sortDir;  }
        set;
    }
    // the current field to sort by defaults to Created date
    public String sortField {
        get  { if (sortField == null) {sortField = 'CreatedDate'; } return sortField;  }
        set;
    }  
    
     //toggles the sorting of query from asc to desc
    public void toggleSortSMS() {
      
      sortDir = sortDir.equals(ASC_NULLS_FIRST) ? DESC_NULLS_LAST : ASC_NULLS_FIRST;
      list<Case> cseList = CreateQueryHelper.getRecords('Case','Id','where Account.CRN__c = \''+Customer_CRN+'\'', 
                                               CreateQueryHelper.RecentActivityDetailCSS, 
                                              'order by '+sortField+' '+sortDir,'');
        
      this.populateCaseMap(cseList);
    }// end of toggleSort
    
    public void populateCaseMap(list<Case> pCaseList){
        
        totalRecs = 0;
        caseMap.clear();
        caseList.clear();
        
        for(Case cse : pCaseList) {
            caseMap.put(totalRecs,cse);  
            totalRecs++;                                    
        } 
        FirstPage();
        
    }
    
    // Following methods are used for Pagination
     public void FirstPage() {
         OffsetSize = 0;
       }
       
       public void previous() {
         OffsetSize =  OffsetSize - LimitSize - 1;
       }
    
       public void next() {
         OffsetSize = OffsetSize + 1 + LimitSize;
      }
      
      public void LastPage() {
          OffsetSize= totalrecs - math.mod(totalRecs,LimitSize + 1);
          
          if(OffsetSize == totalrecs ){
          OffsetSize -= LimitSize +1;
          }
      }
      
      public boolean getprev() {
        if(OffsetSize== 0)
          return true;
        else
          return false;
      }
      
      public boolean getnxt() {
         if(((OffsetSize + LimitSize + 1) > totalRecs) ||((OffsetSize + LimitSize + 1) == totalRecs))
             return true;
         else
             return false;
      }    
        
}