public with sharing class PartnerBookingDetailController {
public Id channelpartner_id;
public Channel_Partner__c channelPartner{get;set;}
public Map<Id, Integer> eligibilitycheckMap{get;set;}
public Map<Id, Decimal> percentagePayableMap{get;set;}
public List<Booking_Details__c> bDetailList {get;set;}
public Id bookingRecord {get;set;}
public string fromDate {get;set;}
public string toDate {get;set;}
public String filterValue {get;set;}
public String contactPerson{get;set;}
public String email{get;set;}
public String mobile{get;set;}
public String officeNo{get;set;}
public String reapId{get;set;}
public String organizationName{get;set;}
public booking_details__c bRecord {get;set;}
public boolean isTrue {get;set;}
public boolean selectedOption {get;set;}
public boolean channel_partner_present = false;

    public partnerBookingDetailController(){
        isTrue = false;
        filterValue = 'all';

        try{
        
            Id Account_id= [SELECT Id, AccountId,ContactId FROM User where Id=:UserInfo.getUserId()].AccountId;
            //System.debug('1@@@@@@@@@@@@@@@@@....................' + Account_id);
            channelpartner_id = [select  Channel_Partner__c from Account where Id=:Account_id].Channel_Partner__c;
            if(channelpartner_id == null) {
                channel_partner_present = false;
            }
            else {
                channel_partner_present  = true;
            }
            //System.debug('22....................' + channelpartner_id );
         
            if (channelpartner_id != null){
                getAllBookingDetailList();
            }        
          
            //System.debug('5....................' );
            
            if(channelpartner_id != null) {
                channelPartner = [select id, Email__c, Mobile_Phone__c , Contact_Person__c,Office_No__c,REAP_ID__c,Name from Channel_Partner__c where Id =: channelpartner_id ];
                //System.debug('@@##'+channelPartner.Email__c  );
                //System.debug('@@##'+channelPartner.Mobile_Phone__c );
                contactPerson=  channelPartner.Contact_Person__c ;
                email =  channelPartner.Email__c ;
                mobile=  channelPartner.Mobile_Phone__c ;
                officeNo=  channelPartner.Office_No__c ;
                reapId=  channelPartner.REAP_ID__c ;
                organizationName=  channelPartner.Name  ;
                //System.debug('@@##'+email);
            }
        }catch(Exception e){
            //System.debug('@@## Error on Loading partnerBookingDetails Constructor'+e.getmessage());
        }
    }
    
    public ApexPages.StandardSetController bDetail {
        get{
           if (channel_partner_present  == true){
            if(bDetail == null) {
                if(bDetailList==null || bDetailList.size()==0 ){
                    //bDetailList = new List<Booking_Details__c>();
                    
                   		//System.debug('bDetail Property.......... ');
                        string soqlQuery = 'Select b.Name, b.Id, b.ProjecttypeUpperCase__c, b.ProjectNameUppercase__c, b.Wing__c,b.Customer_Code__c, b.Project__c, b.Flat_No__c, b.Co_Applicant__c, b.Customer_Group__c,b.Primary_Applicant__c,b.Project_Name__r.Project_Type__c, b.CLuster__c, b.Application_Date__c,b.Consideration_Value__c,(select Amount_received__c, Demand_amount__c from Demands__r),b.Flat_Cost_Formula__c,b.Flat_Cost__c, b.Invoice_Received_Date__c,b.Service_Tax_Cess__c,b.Status__c,b.Basic_Brokerage_amount__c,b.Total_Brokerage__c ,b.Education_Cess_amount__c, b.Channel_Partner_Offer__c,b.Channel_Partner__r.REAP_ID__c,b.Project_Name__r.International_Brokerage_Percentage__c,b.Customer_Type__c, b.Project_Name__r.Domestic_Brokerage_Percentage__c,b.Service_tax_amount__c,b.Secondary_and_Higher_Education_Cess__c ,b.Channel_Partner_Payment__c From Booking_Details__c b where Channel_Partner__c = :channelpartner_id';
                        //System.debug('Testing3'+soqlQuery);
                        if(fromDate != NULL && toDate != NULL){
                            Date fromDateValue = date.parse(fromDate);
                            Date toDateValue = date.parse(toDate);
                            soqlQuery += ' AND Application_Date__c >= :fromDateValue AND Application_Date__c <= :toDateValue';
                        }

                        soqlQuery += ' order by b.Application_Date__c DESC';
                
                        //if (channelpartner_id != null){
                            bDetailList = Database.query(soqlQuery);
                            //System.debug('soqlQuery -->' + soqlQuery);
                      //  }
                   
                }
                
                //Asmita-  07/06/2014- Modified: To resolve Attempt To de-reference null object exception
                bDetail = new ApexPages.StandardSetController(bDetailList);
                //System.debug('bDetailList ::::::: '+bDetailList);
                //b.Basic_Brokerage_Amount__c 
                //b.Total_Brokerage__c
                eligibilitycheckMap = new Map<Id, Integer>();
                percentagePayableMap= new Map<Id,Decimal>();
                
                if(bDetailList != null && bDetailList.size() > 0){
               
                for(Booking_Details__c bd : bDetailList){
                 
                    Decimal total = 0;
                    for(Demands__c dem:bd.Demands__r){
                      if(dem.Amount_received__c!=null)
                        total += dem.Amount_received__c;
                    }
                   
                    
                    if(bd.Channel_Partner_Offer__c !=null && bd.Channel_Partner_Offer__c != 0){
                        if(bd.Channel_Partner_Offer__c!=null){
                            percentagePayableMap.put(bd.id,bd.Channel_Partner_Offer__c);
                        }else{
                            percentagePayableMap.put(bd.id,0.00);
                        }
                    }else if(bd.Channel_Partner__r.REAP_ID__c!=null && bd.Channel_Partner__r.REAP_ID__c.toUpperCase().startswith('LI')){
                        if(bd.Project_Name__r.International_Brokerage_Percentage__c!=null){
                            percentagePayableMap.put(bd.id,bd.Project_Name__r.International_Brokerage_Percentage__c);
                        }else{
                            percentagePayableMap.put(bd.id,0.00);
                        }
                    } else{
                        if(bd.Project_Name__r.Domestic_Brokerage_Percentage__c!=null){
                            percentagePayableMap.put(bd.id,bd.Project_Name__r.Domestic_Brokerage_Percentage__c);
                        }else{
                            percentagePayableMap.put(bd.id,0.00);
                        }
                    }
                    //System.debug('###'+ percentagePayableMap);
                    double CV = 0;
                    
                    if(bd.Consideration_Value__c != null && bd.Status__c == 'Active'){
                        CV= 0.15*bd.Consideration_Value__c;
                    }

                    Booking_Details__c bookingDetail = [ SELECT Id, name,account_status__c,Account__c FROM Booking_Details__c WHERE Id =: bd.Id]; 
                    //System.debug('-----------bookingDetail -------------------' + bookingDetail +'-'+bookingDetail.account_status__c);
                    
                    if(bookingDetail != null && bookingDetail.account_status__c != null && bookingDetail.account_status__c=='Active' && CV <= total){
                       eligibilitycheckMap.put(bd.Id, 1);
                       //System.debug('IF');
                    }               
                    else {
                        eligibilitycheckMap.put(bd.Id, 0);
                        //System.debug('ELSE');
                    }
           
               }
                bDetail = new ApexPages.StandardSetController(bDetailList);
                }
                // sets the number of records in each page set
                bDetail.setPageSize(10);
            }
            if(bDetail != null)
            	return bDetail;
            else
            	return null;
           }
           else {            
               return null;
           }
           
        }
        set;
    }
    public List<AggregateResult> agResultList {get;set;}
    public map<String,Decimal> eligibleAmtMap = new Map<String,Decimal> ();
    public map<String,Decimal> amtPaidMap = new Map<String,Decimal> ();
    public List<BDSummaryWrapper> summaryList {get;set;}
    
    public void getAllBookingDetailList(){
        Date fDateValue=null;
        Date tDAteValue=null;
        eligibleAmtMap = new Map<String,Decimal> ();
        amtPaidMap = new Map<String,Decimal> ();
        
        try{
        
            if(filterValue == 'all'){
                fromDate = null;
                toDate = null;
                isTrue = false;
            }else{
                isTrue = true;
            }
            summaryList = new List<BDSummaryWrapper>();
            
            String queryRecord = 'SELECT Project_Name__r.Project_Type__c, sum(Basic_Brokerage_amount__c),sum(Booking_Brokerage_Payout__c),'+
                                    'count(Invoice_Received_Date__c) FROM Booking_Details__c where Channel_Partner__c =:channelpartner_id ';
                                    //System.debug('333333333333........'+queryRecord );
            if(fromDate!=null)    {
                fDateValue= date.parse(fromDate);
                queryRecord += ' and Application_Date__c >=: fDateValue';
            }   
            if(toDate!=null){
                tDAteValue = date.parse(toDate);
                queryRecord += ' and Application_Date__c <=: tDAteValue';
            } 
            queryRecord += ' group by Project_Name__r.Project_Type__c';
            //System.debug('44444444444........'+queryRecord );
            agResultList= database.query(queryRecord);
            if(agResultList!=null && agResultList.size()>0){
                for(AggregateResult ag:agResultList){
                    if( string.valueof(ag.get('Project_Type__c'))!=null && string.valueof(ag.get('Project_Type__c')).trim()!=''){
                        BDSummaryWrapper summaryRecord= new BDSummaryWrapper();
                      // summaryRecord.projType =string.valueof(ag.get('Project_Type__c')).toUpperCase();
                        summaryRecord.projType =string.valueof(ag.get('Project_Type__c'));
                        summaryRecord.invoiceReceived = Integer.valueof(ag.get('expr2'));
                        if(string.valueof(ag.get('expr0'))!=null && string.valueof(ag.get('expr0')).trim()!=''){
                            summaryRecord.invoiceAmt = Integer.valueof(ag.get('expr0'));
                        }else{
                            summaryRecord.invoiceAmt = 0;
                        }
                     
                        
                        //summaryRecord.amtPaid = string.valueof(ag.get('expr1'));
                        summaryList.add(summaryRecord);
                    }
                }
            }
            //System.debug('6....................'+summaryList.size());
            
            
             String queryString = 'Select b.Application_Date__c,(select Amount_received__c, Demand_amount__c from Demands__r),b.Flat_Cost_Formula__c,'+
                                                                    'b.Invoice_Received_Date__c,b.Service_Tax_Cess__c,b.Status__c,b.Basic_Brokerage_amount__c,b.Total_Brokerage__c ,b.Education_Cess_amount__c,'+
                                                                    'b.Channel_Partner_Offer__c,b.Channel_Partner__r.REAP_ID__c,b.Project_Name__r.International_Brokerage_Percentage__c,b.Customer_Type__c,'+
                                                                    'b.Project_Name__r.Domestic_Brokerage_Percentage__c,b.Service_tax_amount__c,b.Secondary_and_Higher_Education_Cess__c ,b.Channel_Partner_Payment__c, '+
                                                                    'b.Project_Name__r.Project_Type__c,b.Channel_Partner_Payment__r.Gross_Amount__c,b.Booking_Brokerage_Payout__c From Booking_Details__c b where Channel_Partner__c =:channelpartner_id ';
             //System.debug('Testing1'+ queryString);                                                     
            if(fromDate!=null)    {
                fDateValue= date.parse(fromDate);
                queryString += ' and b.Application_Date__c >=: fDateValue';
            }   
            if(toDate!=null){
                tDAteValue = date.parse(toDate);
                queryString += ' and b.Application_Date__c <=: tDAteValue';
            } 
            queryString += ' order by b.Application_Date__c DESC';
            
            List<Booking_Details__c> bDSummaryList = database.query(queryString);
            //System.debug('Testing'+bDSummaryList);
            for(Booking_Details__c bd :bDSummaryList){
                Decimal total=0 ;
             
                for(Demands__c dem:bd.Demands__r){
                if(dem.Amount_received__c!=null)
                    total += dem.Amount_received__c;
                }
                
                
                
              
                if(bd.Project_Name__r.Project_Type__c!=null){
                if((bd.Flat_Cost_Formula__c!=null && 0.15*bd.Flat_Cost_Formula__c <= total) && bd.Status__c == 'Active' && bd.Basic_Brokerage_amount__c!=null ){
                                          if(eligibleAmtMap.get(bd.Project_Name__r.Project_Type__c)!=null){
                        eligibleAmtMap.put(bd.Project_Name__r.Project_Type__c,(eligibleAmtMap.get(bd.Project_Name__r.Project_Type__c)+ bd.Basic_Brokerage_amount__c));
                     }else{
                        eligibleAmtMap.put(bd.Project_Name__r.Project_Type__c,bd.Basic_Brokerage_amount__c);
                     }
                        
                }
                if(bd.Channel_Partner_Payment__c!=null && bd.Booking_Brokerage_Payout__c !=null){
                     if(amtPaidMap.get(bd.Project_Name__r.Project_Type__c)!=null){
                        amtPaidMap.put(bd.Project_Name__r.Project_Type__c,(amtPaidMap.get(bd.Project_Name__r.Project_Type__c)+ bd.Booking_Brokerage_Payout__c));
                     }else{
                        amtPaidMap.put(bd.Project_Name__r.Project_Type__c,bd.Booking_Brokerage_Payout__c);
                     }
                 }
                               }
            }
            //System.debug('amtPaidMap****' + amtPaidMap);


            integer invoiceRecvdTotal = 0;
            Decimal invoiceAmtTotal = 0.0;
            Decimal amtPaidTotal = 0.0;
            Decimal eligibleAmtTotal = 0.0;
            Decimal balanceDueTotal = 0.0;
            //System.debug('7..............................');
            if(summaryList!=null && summaryList.size()>0){
                //System.debug('%****^'+amtPaidMap);
                for(BDSummaryWrapper sm:summaryList){
                    if(eligibleAmtMap!=null){
                        if(eligibleAmtMap.get(sm.projType)!=null){
                            sm.eligibleAmt = eligibleAmtMap.get(sm.projType);
                        }else{
                            sm.eligibleAmt = 0.0;
                        }
                        //System.debug('!!!!!!!'+sm.eligibleAmt);
                    }
                    //System.debug('%****@@^'+amtPaidMap.get(sm.projType));
                    if(amtPaidMap!=null && amtPaidMap.get(sm.projType)!=null){
                        if(amtPaidMap.get(sm.projType)!=null){
                            sm.amtPaid = amtPaidMap.get(sm.projType);
                        }else{ 
                      //  if(String.valueOf(amtPaidMap.get(sm.projType))==''){
                            sm.amtPaid = 0.0;
                      //  }
                        }
                        //System.debug('!!!!!!!!!!!'+sm.amtPaid);
                    }
                    if(sm.amtPaid!=null){
                        //System.debug('@@' + sm.eligibleAmt + '-' + sm.amtPaid);
                        sm.balanceDue = sm.eligibleAmt - sm.amtPaid;
                        
                        
                    }else{
                    if(sm.amtPaid==null){
                    sm.amtPaid=0.00;
                    sm.balanceDue=sm.eligibleAmt;
                    }
                    
                    }
                      
                   
                    invoiceRecvdTotal += sm.invoiceReceived;
//                    invoiceAmtTotal += Decimal.valueof(sm.invoiceAmt);
                    invoiceAmtTotal += sm.invoiceAmt;

                    if(sm.amtPaid!=null)
                    amtPaidTotal += sm.amtPaid;
                    eligibleAmtTotal += sm.eligibleAmt;
                    if(sm.balanceDue!=null)
                    balanceDueTotal += sm.balanceDue;
                }
                
                BDSummaryWrapper totalRec = new BDSummaryWrapper();
                totalRec.projType = 'TOTAL';
                totalRec.invoiceReceived =invoiceRecvdTotal;
//                totalRec.invoiceAmt =String.valueof(invoiceAmtTotal);
                totalRec.invoiceAmt = invoiceAmtTotal;

                totalRec.amtPaid =amtPaidTotal;
                totalRec.eligibleAmt =eligibleAmtTotal;
                totalRec.balanceDue =balanceDueTotal;
                summaryList.add(totalRec);
            }
            //System.debug('&&&&..............' + summaryList);

            bDetailList = NULL;
            bDetail = NULL;
            
    }catch(Exception ex){
        //System.debug('@@## Error on Loading getAllBookingDetailList Method : '+ex.getmessage());
    }
            
    }
    
    public void renderPanel(){
        
    }
    
    public List<Booking_Details__c> getBookingDetailList() {
        //System.debug('1---------------------------' );
        try{
 //System.debug('2@@@@@@@@@@-------------- channel_partner_present  ------------- = ' +  channel_partner_present  );
  //System.debug('333333-------------- bDetail   ------------- = ' +  bDetail );


        if (channel_partner_present  == true){
            if(bDetail != null){
                return (List<Booking_Details__c>)bDetail.getRecords();
            }else{
                return new List<Booking_Details__c>();
            }
        }
        else {
           return new List<Booking_Details__c>();
        }
        }catch(Exception ex){
        //System.debug('ex = ---------------------------' + ex );

        }
        return null;
    }

    // returns the first page of records
    public void first() {
        if(bDetail != null){
            bDetail.first();
        }
    }
 
    // returns the last page of records
    public void last() {
        if(bDetail != null){
            bDetail.last();
        }
    }
 
    // returns the previous page of records
    public void previous() {
        if(bDetail != null){
            bDetail.previous();
        }
    }
 
    // returns the next page of records
    public void next() {
        if(bDetail != null){
            bDetail.next();
        }
    }
    
    public Boolean hasNext {
        get {
        if(channel_partner_present  == true) {
            return bDetail.getHasNext();
        }
        else {
            return false;
        }
        }
        set;
    }
 
    public Boolean hasPrevious {
        get {
        if(channel_partner_present  == true) {
            return bDetail.getHasPrevious();
        }
        else {
        return false;
        }
        }
        set;
    }
    
    public class BDSummaryWrapper{
        public String projType {get;set;}
        public Integer invoiceReceived {get;set;}
        public Decimal invoiceAmt {get;set;}
        public Decimal eligibleAmt {get;set;}
        public Decimal amtPaid {get;set;}
        public Decimal balanceDue {get;set;}
    }
        
}