trigger LeadSharingTrigger on Lead (after insert,after update) {
/*   
   
    List<Lead> triggerRecords = [select id,IsConverted,LeadSource,Project_Type__c,Channel_Partner__c,Referral_Name__c,Project_Interested__c from Lead where id IN :Trigger.newMap.keySet()];

    // Now call the share creation methods
    if ( triggerRecords != null && triggerRecords.size() > 0 )
      LeadSharing.addSharing(triggerRecords, 'Read' );
*/      
      
}