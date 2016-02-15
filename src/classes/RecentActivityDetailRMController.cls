/* Version  			Created By   	 Created Date       Description
 *
 * 	Initial Draft		Sneha P.         04/03/2015       Controller for RecentActivityDetailRM Page
 *
 */

public with sharing class RecentActivityDetailRMController {
    //Private Variables
    private string CRN;
    private integer totalRecs = 0;
    @testVisible private integer OffsetSize = 0;
    public String limitSize {get; set;}
    @testVisible private Map<Integer, Case> caseMap;
    
    //Constants
    private static final String DESC_NULLS_LAST = 'desc NULLS Last'; 
    private static final String ASC_NULLS_FIRST = 'asc NULLS First';
    private static final String CREATED_DATE = 'CreatedDate'; 
    //Properties
    public String frm          {get; set;}
    
    public List<SelectOption> getRecordNos() {

        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('9','10'));
        options.add(new SelectOption('24','25'));
        options.add(new SelectOption('49','50'));
        options.add(new SelectOption('99','100'));
        return options;
    }
    
    
     public list<Case> caseList {
        set;
        get{ 
            if(caseList == null)
                caseList = new list<Case>();
            if(caseMap == null) {
                caseMap = new Map<Integer, Case>();
                
                list<Case> caseLst = CreateQueryHelper.getRecords('Case','Id',
                									   'where Account.CRN__c = \''+CRN+'\'', 
                                                       CreateQueryHelper.RecentActivityDetailRM, 
                                                      'order by '+sortField+' '+sortDir ,'');
                
                 
                 caseMap.clear();
                 for(Case objCase : caseLst ) {
                    caseMap.put(totalRecs,objCase );  
                    totalRecs++;                         
                } 
            }
            
            caseList.clear();
            for(Integer i = OffsetSize ;i<=(OffsetSize +Integer.valueOf(limitSize) ); i++ ) {
                caseList.add(caseMap.get(i)) ;
            } 
            return caseList ;
        }
    }
    
    //Constructor
    public RecentActivityDetailRMController(){
        CRN = ApexPages.currentPage().getParameters().get('CRN');
        limitSize = '9';
    }
    
    //Assign sort Direction, default is Descending and nulls last 
    public String sortDir {
        get  { if (sortDir == null) {  sortDir = DESC_NULLS_LAST; } return sortDir;  }
        set;
    }
    
    //Assign sort field, default is CreatedDate 
    public String sortField {
        get  { if (sortField == null) {sortField = CREATED_DATE; } return sortField;  }
        set;
    }  
    
     //Toggles the sorting of query from asc to desc or vice versa and display data accordingly
    public void toggleSortSMS() {
      
      sortDir = sortDir.equals(ASC_NULLS_FIRST) ? DESC_NULLS_LAST : ASC_NULLS_FIRST;
      
      if(sortField.equalsIgnoreCase('OwnerId')){
      	sortField = 'Owner.Name';		
      }
      searchCase();
     
    }// end of toggleSort
    
    public void searchCase() {
    	 
      	this.populateCaseMap(CreateQueryHelper.getRecords('Case','Id','where Account.CRN__c = \''+CRN+'\'', 
                                               CreateQueryHelper.RecentActivityDetailRM, 
                                              'order by '+sortField+' '+sortDir ,''));	
    }
    
    //Method to populate Case map with index
    public void populateCaseMap(list<Case> pCaseList) {
        
        totalRecs = 0;
        caseMap.clear();
        caseList.clear();
        
        for(Case cse : pCaseList) {
            caseMap.put(totalRecs,cse);  
            totalRecs++;                                    
        } 
      	FirstPage();
    }
    
    //Methods for Pagination
	public void firstPage() {
		OffsetSize = 0;
	}
   
	public void previous() {
		OffsetSize = OffsetSize - Integer.valueOf(limitSize) - 1;
	}

	public void next() {
		OffsetSize = OffsetSize + 1 + Integer.valueOf(limitSize);
	}
  
	public void lastPage() {
		OffsetSize= totalrecs - math.mod(totalRecs,Integer.valueOf(limitSize) + 1);
		
		if(OffsetSize == totalRecs ){
          OffsetSize = OffsetSize- Integer.valueOf(limitSize) +1;
		}
	}
  
	public boolean getPrev() {
		return (OffsetSize== 0) ? true : false ;
	}
  
	public boolean getNxt() {
			
		return  (((OffsetSize + Integer.valueOf(limitSize) + 1) > totalRecs) ||
					((OffsetSize + Integer.valueOf(limitSize) + 1) == totalRecs)) ? 
						true : 
							false;
	}   
    
}