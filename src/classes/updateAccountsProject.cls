public class updateAccountsProject{
public static void updateProjectName(List<Booking_Details__c> bookDet){
 List<id> accIdList = new List<id>();
 /*
 Commented the lines which was updating Cluster and Flat No from Booking Details to Account since SRCG-107 has been dropped
 */
 
 Map<string, string> accIdProjectNameMapping = new Map<string, string>();
 Map<string, string> accIdClusterMapping = new Map<string, string>();
 Map<string, string> accIdFlatNoMapping = new Map<string, string>();
 Map<string, string> accIdWingMapping = new Map<string, string>();
 List<Account> accListforUpdate = new List<Account>(); 
    for (Booking_Details__c bd: bookDet){
            accIdList.add(bd.Account__c);     
            accIdProjectNameMapping.put(bd.Account__c, bd.Project__c);  
            accIdClusterMapping.put(bd.Account__c, bd.CLuster__c);
            accIdFlatNoMapping.put(bd.Account__c, bd.Flat_No__c);
            accIdWingMapping .put(bd.Account__c, bd.Wing__c);
            
         }
     System.debug('accIdProjectNameMapping: '+accIdProjectNameMapping); 
    for (Account acc:[Select id, CRN__c from Account where id IN:accIdList]){ 
           acc.Project_Name__c = accIdProjectNameMapping.get(acc.id);
           acc.Cluster__c = accIdClusterMapping.get(acc.id);
           acc.Flat_No__c= accIdFlatNoMapping.get(acc.id);
           acc.Wing__c= accIdWingMapping.get(acc.id);

           accListforUpdate.add(acc); 
         }  
    system.debug('accListforUpdate: '+accListforUpdate); 
    system.debug('accListforUpdate: '+accListforUpdate[0].Project_Name__c);  
    update accListforUpdate;
  }
}