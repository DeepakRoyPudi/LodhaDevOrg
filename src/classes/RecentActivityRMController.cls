/* Version  			Created By   	 Created Date       Description
 *
 * 	Initial Draft		Sneha P.         26/02/2015       Controller for RecentActivity Component
 *
 */
public with sharing class RecentActivityRMController {

    //Properties
    public String customerCRN    {get; set;}   //Get the CRN from attribute of component
    public Integer noOfRecords   {get; set;}   //Get the No. or records to display from attribute of component
	public String accId			 {get; set;}
	
    public list<Case> lstCase {
        set;
        get{ 
            if(lstCase == null){
                // Query all the cases for current user based on CRN ordered by Created date
                lstCase = CreateQueryHelper.getRecords('Case','Id,CaseNumber,AccountId','where Account.CRN__c = \''+customerCRN+'\'', 
                										CreateQueryHelper.RecentActivityCrispRM,
                										'order by CreatedDate DESC','LIMIT '+noOfRecords);
            	
            	//Assign the account Id to a variable
            	if(lstCase.size() > 0)
            		accId = lstCase[0].AccountId;
            	else {
            		list<Account> accList = [Select Id from Account where CRN__c =: customerCRN LIMIT 1];
            		if(accList.size() > 0)
            			accId = accList[0].Id;
            		else
            			accId = null;
            	}
            }              
            return lstCase;
        }
    } 
    
    
    //Constructor
    public RecentActivityRMController(){
    	
    }
     
}