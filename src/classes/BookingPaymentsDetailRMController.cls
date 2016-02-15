/* Version              Created By       Created Date       Description
 *
 *  Initial Draft       Sneha P.         1/02/2015       Controller for BookingPaymentsDetailRM Page
 *
 */
public with sharing class BookingPaymentsDetailRMController {
    
    //Private Variables
   @testVisible private string CRN;
    private integer totalRecs = 0;
   @testVisible private integer offsetSize = 0;
    private integer limitSize= 9;
   @testVisible private Map<Integer, Booking_Payment_Transaction__c> bptMap {get;set;}
     public Booking_Payment_Transaction__c utr {get; set;}
     
    //Constants
   @testVisible private static final String BPTObjName = 'Booking_Payment_Transaction__c';
    private static final String DESC_NULLS_LAST = 'desc NULLS Last'; 
    private static final String ASC_NULLS_FIRST = 'asc NULLS First';
    
    //Properties
    public list<Booking_Payment_Transaction__c> bookingPaymentTransList{
        set;
        get{
            bookingPaymentTransList.clear();
            for(Integer i = OffsetSize ;i<=(OffsetSize +LimitSize ); i++ ) {
                BookingPaymentTransList.add(bptMap.get(i)) ;
            } 
            return bookingPaymentTransList;
        }    
    }
    
    // Set sort direction. Defaults to Descending nulls last
    private String sortDir {
        get  { if (sortDir == null) {  sortDir = DESC_NULLS_LAST; } return sortDir; }
        set;
    }
    // The current field to sort by defaults to Created date
    private String sortField {
        get  { if (sortField == null) {sortField = 'CreatedDate'; } return sortField; }
        set;
    }  
    
    //Constructor
    public BookingPaymentsDetailRMController(){
        CRN = ApexPages.currentPage().getParameters().get('CRN');
        utr = new Booking_Payment_Transaction__c();
        bookingPaymentTransList= new list<Booking_Payment_Transaction__c>();
        bptMap = new Map<Integer, Booking_Payment_Transaction__c>();

        list<Booking_Payment_Transaction__c> bookingLst = CreateQueryHelper.getRecords(BPTObjName ,
                                                'Id','where CRN__c = \''+CRN+'\'', 
                                               CreateQueryHelper.BookingPaymnetsTransDetailRM , 
                                              'order by '+sortField+' '+sortDir ,'');
         for(Booking_Payment_Transaction__c objBPT : bookingLst ) {
            bptMap.put(totalRecs, objBPT);  
            totalRecs++;                         
        } 
                
    }
    
    //Toggles the sorting of query from asc to desc, vice versa
    public void toggleSortBPT() {
      
      sortDir = sortDir.equals(ASC_NULLS_FIRST) ? DESC_NULLS_LAST : ASC_NULLS_FIRST;
      
      sortField = ApexPages.currentPage().getParameters().get('sortField');
      
      if(sortField.EqualsIgnoreCase('CreatedById')) {
      	sortField = 'CreatedBy.Name'; 	
      }
      this.populateBPTMap(CreateQueryHelper.getRecords(BPTObjName ,
                                                       'Id','where CRN__c = \''+CRN+'\'', 
                                                       CreateQueryHelper.BookingPaymnetsTransDetailRM , 
                                                       'order by '+sortField+' '+sortDir ,
                                                       ''));
    }// end of toggleSort
    
    // Method to search Booking payments based on the UTR Code and Transaction date
	public void searchUtr() {
        String whereClause = '';
        whereClause = 'where CRN__c = \''+CRN+'\'';
        
        bptMap.clear();
        bookingPaymentTransList.clear();
        
         if(String.isNotBlank(utr.UTR_Code__c)) {
            whereClause += ' and UTR_Code__c like \'%'+utr.UTR_Code__c+'%\'';
        }
        
        if( utr.Transaction_Date__c != null) {
            createQueryHelper.docfrmdate= Date.newInstance(utr.Transaction_Date__c.Year(),
                                       utr.Transaction_Date__c.month(),
                                       utr.Transaction_Date__c.day());
               whereClause += ' and Transaction_Date__c =: docfrmdate';
             
        }
		this.populateBPTMap(CreateQueryHelper.getRecords(BPTObjName ,
                                                        'Id',whereClause, 
                                                       CreateQueryHelper.BookingPaymnetsTransDetailRM , 
                                                      'order by '+sortField+' '+sortDir ,''));
     }
     
    //Pagination methods
    public void firstPage() {
        offsetSize = 0;
    }
       
    public void previous() {
        offsetSize = offsetSize - limitSize - 1;
    }
    
    public void next() {
        offsetSize = offsetSize + limitSize + 1;
    }
      
    public void lastPage() {
        offsetSize= totalrecs - math.mod(totalRecs,limitSize + 1);
        
         
		if(offsetSize == totalrecs ){
          offsetSize -= limitSize +1;
		}
    }
      
    public boolean getPrev() {
        return (offsetSize== 0) ? true : false ;
    }
      
    public boolean getNxt() {
        return ((offsetSize + limitSize + 1 ) >= totalRecs) ? 
        			true :
        				false;
    }
    
    //Method to populate a map of Booking Payments Transaction with index 
    private void populateBPTMap(list<Booking_Payment_Transaction__c> pBptList){
        
        //Varible to store total no of BPT records
        totalRecs = 0;
        bptMap.clear();
        bookingPaymentTransList.clear();
        
        //Populate map for indexing 
        for(Booking_Payment_Transaction__c bpt: pBptList) {
            bptMap.put(totalRecs,bpt);  
            totalRecs++;                                    
        } 
        firstPage();         
    }
}