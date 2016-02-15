public class partnerpaymentdetail {

public List<Booking_Details__c> paymentdetailList;
public Id channelpartner_id;
public List<Booking_Details__c> getpaymentList{get;set;}
public List<Booking_Details__c> pDetailList;
public Decimal TotalGrossAmount{get;set;}
public Decimal TotalTDSAmount{get;set;}
public Decimal TotalNetAmount{get;set;}
//public List<Booking_Details__c> totalPaymentDetailList;

public Decimal TempNetAmount=0;
public Decimal TempTDSAmount=0;
public Decimal TempGrossAmount=0;
//Channel_Partner__c
public partnerpaymentdetail() {
   Id Account_id= [SELECT Id, AccountId,ContactId FROM User where Id=:UserInfo.getUserId()].AccountId;
   System.debug('1......................' + Account_id);
   channelpartner_id = [select Channel_Partner__c from Account where Id=:Account_id].Channel_Partner__c;
      System.debug('2......................' + channelpartner_id );

}

public void CalculateTotal(List<Booking_Details__c> paymentList  ){
    List<AggregateResult> result = [SELECT sum (Gross_Amount__c) total_gross,sum(TDS__c ) total_tds,sum(Net_Amount__c ) net_amt from Channel_Partner_Payment__c where Channel_Partner__c =:channelpartner_id];


    if (result != null && result.size() > 0){
        for(AggregateResult a: result){
            if(a != null){
                if(a.get('total_gross') != null && Integer.valueOf(a.get('total_gross')) != null ){
                    //TempNetAmount += Integer.valueof(a.get('net_amt'));
                    TempGrossAmount += Integer.valueof(a.get('total_gross'));
                }
                if (Integer.valueof(a.get('total_tds')) != null){
                    TempTDSAmount += Integer.valueof(a.get('total_tds'));
                }
                if(Integer.valueof(a.get('net_amt')) != null){
                    //TempGrossAmount += Integer.valueof(a.get('total_gross'));               
                    TempNetAmount += Integer.valueof(a.get('net_amt'));               
                }
            }
        }
    }
    TotalGrossAmount =TempGrossAmount ;
    TotalTDSAmount =TempTDSAmount ;
    TotalNetAmount =TempNetAmount ;
}




public ApexPages.StandardSetController pDetail {
        get {
            if(pDetail == null) {
                 List<Booking_Details__c> AllDetailList = new List<Booking_Details__c>();
                 
                 pDetailList = [select Project__c, ProjectNameUppercase__c, Application_Date__c, CLuster__c, Wing__c, Flat_No__c, Customer_Code__c,
                       Primary_Applicant__c, Channel_Partner_Payment__r.Mode_of_Payment__c , Channel_Partner_Payment__r.Payment_Detail__c, Consideration_Value__c ,
                       Channel_Partner_Payment__r.Gross_Amount__c,Channel_Partner_Payment__r.TDS__c, 
                       Channel_Partner_Payment__r.Net_Amount__c, Channel_Partner_Payment__r.Name_of_Beneficiary__c
                       from Booking_Details__c where Channel_Partner__c =:channelpartner_id and Channel_Partner_Payment__c !=null and status__c='Active'
                                                               order by Application_Date__c DESC];
               
                 for(Booking_Details__c bd:pDetailList){
                  //  Decimal total = 0;
                   // for(Demands__c dem:bd.Demands__r){
                     //   total += dem.Demand_amount__c;
                    //}
                    //if(0.2*bd.Consideration_Value__c >= total){
//                        String str = String.valueOf(bd.get('Project__c')).toUpperCase();
                       // if(bd.get('Project__c') != null){
                            //String str = String.valueOf(bd.get('Project__c')).toUpperCase();
                           // System.debug('str = -----------------------------' + str);
                            //bd.Project__c = str;
                       // }
                        AllDetailList.add(bd);
                   // }
                }
                CalculateTotal(AllDetailList);
                pDetail = new ApexPages.StandardSetController(AllDetailList);
                // sets the number of records in each page set
                pDetail.setPageSize(10);
            }
            return pDetail;
        }
        set;
    }
    
public List<Booking_Details__c> getpaymentList() {
    return (List<Booking_Details__c>)pDetail.getRecords();
}





// returns the first page of records
    public void first() {
        pDetail.first();
    }
 
    // returns the last page of records
    public void last() {
        pDetail.last();
    }
 
    // returns the previous page of records
    public void previous() {
        pDetail.previous();
    }
 
    // returns the next page of records
    public void next() {
        pDetail.next();
    }
    
    public Boolean hasNext {
        get {return pDetail.getHasNext();}
        set;
    }
 
    public Boolean hasPrevious {
        get {return pDetail.getHasPrevious();}
        set;
    }

}