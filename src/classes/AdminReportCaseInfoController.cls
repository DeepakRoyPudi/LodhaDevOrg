/*@Created by: Deepak Pudi 
     @Created Date: 11/5/2015 -->
 
 -- ------------------------------------------------------------------------------
 | Modified By      | Modified Date       | Version        | Description         |
 --------------------------------------------------------------------------------
 |Deepak Pudi            3/3/2015            1.0           CaseInformation of all Customers
 --------------------------------------------------------------------------------
 |
 ------------------------------------------------------------------------------ --*/
public class AdminReportCaseInfoController {
    public map<String , Account> mapCRNAndAccount{get;set;}
    public map < string, list < integer >> finalmap {get; set;}
    public Case fromDateSearch  {get; set;}
    public Case toDateSearch  {get; set;}
      
    public static final String ERRORMSG = 'Error: From Date should be less than or equal to To Date.';
    public static final String INBOUND = 'Inbound';
    public static final String OUTBOUND = 'Outbound';
    public static final String YES = 'YES';
    public static final String NO = 'NO';
    public static final String EMAIL = 'Email';
    public static final String CALL = 'Call';
     public static final String GRIEVANCE = 'Grievance';
    
    private String queryString;

   /*Constructor*/
    public AdminReportCaseInfoController() {
        mapCRNAndAccount = new map<String , Account>();
        fromDateSearch = new Case();
        toDateSearch = new Case();
        DateTime fromDate = fromDateSearch.Date_of_Complaint__c;
        DateTime toDate = toDateSearch.Date_of_Complaint__c;
        caseRecordDisplay(NULL, NULL);
        for(Account acc :[Select Id, CRN__c from Account]){
            mapCRNAndAccount.put(acc.CRN__c, acc );
        }
    }
    
  /*Method Displays case records on page according to the date range*/
    public void caseRecordDisplay(datetime fromDate, datetime toDate){
        map < string, list < case >>maplist = new map < string, list < case >>();
        set < string > crnset = new set < string > ();
        finalmap = new map < string, list < integer >> ();
        AggregateResult[] results1 = [SELECT Account.CRN__c, count(Nature_of_Request__c), count(Status), count(caseNumber),
                                             count(Needs_approval_from_director__c), count(Communication_Type__c), count(Interaction_Mode__c)
                                      from   case
                                     Group by Account.CRN__c ];
       
        for (AggregateResult ar: results1) {
            crnset.add((string) ar.get('' + Account.CRN__c));
            system.debug('inside loop====' + ar);
        }
        
        DateTime test = fromDateSearch.Date_of_Complaint__c;
        DateTime test2 = toDateSearch.Date_of_Complaint__c;
        queryString = 'select account.CRN__c,Nature_Of_Request__c,Status,caseNumber,Needs_approval_from_director__c,'+
                        'Communication_Type__c,Interaction_Mode__c,CreatedDate from case';
        queryString += ' Where CreatedDate >=:test AND CreatedDate <=: test2 ';

        for ( case cse : database.query(queryString)) {
            if (cse.account.CRN__c != null) {
                if (maplist.containskey('' + cse.account.CRN__c)) {
                    list <case>temp = new list<case>();
                   if(maplist!=null){
                        temp = maplist.get(cse.account.CRN__c);
                    }
                    temp.add(cse);
                    maplist.put(cse.account.CRN__c, temp);
                } else {
                    list <case>temp = new list<case>();
                    temp.add(cse);
                    maplist.put(cse.account.CRN__c, temp);
                }
            }
        }
       
        for (string s: maplist.keyset()) {
            system.debug('Test s' + s);
            list < integer > Countlist = new list < integer > ();
           integer caseNumber = 0;
           integer grievanceCount = 0;
           integer totalCaseCount = 0;
           integer openTodaycaseCount = 0;
           integer directorApprovalYesCount = 0;
           integer directorApprovalNoCount = 0;
           integer inboundCallCount = 0;
           integer inboundEmailCount = 0;
           integer outboundCallCount = 0;
           integer outboundEmailCount = 0;
           integer inboundCount = 0;
           integer outboundCount = 0;

           if(!maplist.isEmpty()){
            for(case cselst:maplist.get(s)) {
                if (cselst.Nature_Of_Request__c == GRIEVANCE)
                    grievanceCount = grievanceCount + 1;

                if (cselst.caseNumber != NULL)
                    caseNumber = caseNumber + 1;

                if (cselst.Status == 'Open')
                    totalCaseCount = totalCaseCount + 1;
                             
                if (cselst.Status == 'Open' && cselst.CreatedDate.Date() == system.today()) {
                    openTodaycaseCount = openTodaycaseCount + 1;
                }
                   
                if (cselst.Needs_approval_from_director__c == YES)
                    directorApprovalYesCount = directorApprovalYesCount + 1;

                if (cselst.Needs_approval_from_director__c == NO)
                    directorApprovalNoCount = directorApprovalNoCount + 1;

                if (cselst.Communication_Type__c == INBOUND && cselst.Interaction_Mode__c == CALL)
                    inboundCallCount = inboundCallCount + 1;

                if (cselst.Communication_Type__c == INBOUND && cselst.Interaction_Mode__c == EMAIL)
                    inboundEmailCount = inboundEmailCount + 1;

                if (cselst.Communication_Type__c == OUTBOUND && cselst.Interaction_Mode__c == CALL)
                    outboundCallCount = outboundCallCount + 1;

                if (cselst.Communication_Type__c == OUTBOUND && cselst.Interaction_Mode__c == EMAIL)
                    outboundEmailCount = outboundEmailCount + 1;

                if (cselst.Communication_Type__c == INBOUND)
                    inboundCount = inboundCount + 1;

                if (cselst.Communication_Type__c == OUTBOUND)
                    outboundCount = OutboundCount + 1;
            }
           
            Countlist.add(caseNumber);
            Countlist.add(openTodaycaseCount);
            Countlist.add(totalCaseCount);
            Countlist.add(grievanceCount);
            Countlist.add(directorApprovalYesCount);
            Countlist.add(directorApprovalNoCount);
            Countlist.add(inboundCallCount);
            Countlist.add(inboundEmailCount);
            Countlist.add(outboundCallCount);
            Countlist.add(outboundEmailCount);
            Countlist.add(inboundCount);
            Countlist.add(OutboundCount);
           } 
            if (s != null)
                finalmap.put(s, Countlist);
        }
    }
  
  /*To export Page as CSV */
   public PageReference ExportToCSV() {
        PageReference PageRef = Page.AdminReportCaseInfoControllerExport;
        //new PageReference('/apex/AdminReportCaseInfoControllerExport');
        PageRef.setRedirect(false);
        return PageRef;
    }
   
   /*case display according to Date range */
    public void searchByFilter() {
        if (toDateSearch != null && fromDateSearch != null) {
            DateTime fromDate = fromDateSearch.Date_of_Complaint__c;
            DateTime toDate = toDateSearch.Date_of_Complaint__c;
            if(fromDate > toDate)
            {
                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,ERRORMSG);
                 ApexPages.addMessage(myMsg);
            }
            if(fromDate == null && toDate==null){
                caseRecordDisplay(NULL, NULL);
            } else{
                caseRecordDisplay(fromDate, toDate);
            }   
           
        }

    }

}