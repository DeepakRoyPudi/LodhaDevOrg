/* Description - Controller for RecentDocsSMSDispatchRM Component
 * 
 * Created By - Sneha p.
 *
 * Created Date - 03/03/15
 */
public with sharing class RecentDocsSmsDispatchRMController {
	
	public list<SMS_History__c> smsList = new list<SMS_History__c>();
	
	//Property
	public String PARAM_CRN    {get;   set;}//Get the CRN from attribute
	public Integer noOfRecords {get; set;}//Get the No. or records to display from attribute of component
	public String tab		   {get; set;}
    //public list<smsWrapper> smsWrapperList {get; set;}
    //Constants
    private static final String DocumentObjName = 'Documents__c';
    private static final String SMSObjName = 'SMS_History__c';
    private static final String DispatchObjName = 'Despatch__c';
    private static final String DispatchOrderBy = 'Despatch_Date__c';
	private static final String SentDate = 'Created_Date__c';
	    
    //Properties
    //Property for Document list that is displayed on Page
    public list<Documents__c> docList {
        set;
        get{ 
            if(docList == null){
                docList = CreateQueryHelper.getRecords(DocumentObjName,'Id ',
                							           'where Account__r.CRN__c = \''+PARAM_CRN+'\'', 
											           CreateQueryHelper.RecentDocsCrispRM, 
        							                  'Order by Date_of_Generation__c DESC NULLS Last',
        							                   'LIMIT '+noOfRecords);
            }              
            return docList;
        }
    } 
    
    

    //Property for smsHistory list that is displayed on Page
    public list<smsWrapper> smsWrapperList {
        set;
        get{ 
    		smsWrapperList = new list<smsWrapper>();
            smsList = CreateQueryHelper.getRecords(SMSObjName,'Id,Mobile_Number__c',
            							   		   'where Account__r.CRN__c =\''+PARAM_CRN+'\'', 
   										   		   CreateQueryHelper.RecentSMSCrispRM, 
    							                   'Order by '+SentDate+' DESC NULLS Last',
    							                   'LIMIT '+noOfRecords);	
        	for(SMS_History__c sms: smsList) {
        		
        		if(sms.Mobile_Number__c != null)
        			smsWrapperList.add(new smsWrapper(sms, 
        											  maskmobileno(String.valueOf(sms.Mobile_Number__c)
        											  			  )));	
        		else
        			smsWrapperList.add(new smsWrapper(sms, maskmobileno('')));	
        		
        	}
            return smsWrapperList;
        }
    } 
    
    //Property for Dispatch list that is displayed on Page
    public list<Despatch__c> dispatchList {
        set;
        get{ 
            if(dispatchList == null){
                dispatchList = CreateQueryHelper.getRecords(DispatchObjName,'Id',
                									'where Account__r.CRN__c =\''+PARAM_CRN+'\'',
       	 											CreateQueryHelper.RecentDispatchCrispRM, 
        							 				'Order by '+DispatchOrderBy+' DESC NULLS Last',
        							 				'LIMIT '+noOfRecords);		
            }              
            return dispatchList;
        }
    } 
    
    //Constructor
	public RecentDocsSmsDispatchRMController() { 
		tab = 'Documents';
	}
	
	//Method called on click of View All link.
	public void viewAll() {
		tab = ApexPages.currentPage().getParameters().get('selectedTab');
	}
	
	 // Method to mask mobile no     
    private String maskmobileno(String mobileNo) {
    
		string p = mobileNo;
		String maskedPhoneNo = '';
		integer i = 0;
		while (i < p.length()) {

			if (i == 0) {
				maskedPhoneNo = p.substring(i, i + 1);
			}else if (i == 1) {
				maskedPhoneNo += p.substring(i, i + 1);
			} 
		    else if (i == p.length() - 1 || i == p.length() - 2) {
		            maskedPhoneNo += p.substring(i, i + 1);
	        } 
	        else {
		        maskedPhoneNo += 'X';
		    }
	        i = i + 1;
		}
		return maskedPhoneNo;
    }
    
	public class smsWrapper {
		public SMS_History__c smshistory {get; set;}	
		public String mobileNo 		 {get; set;}
		public smsWrapper(SMS_History__c pSmshistory,String pMobileNo) {
			smshistory = pSmshistory;
			mobileNo = pMobileNo;
		}
		
	} 
}