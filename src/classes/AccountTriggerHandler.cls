/*
*    Description : Handler Class for Account trigger
*
*       Date        Version      Name     Description
*    17/07/2014       1.0       Asmita    Initial Draft
*/

public class AccountTriggerHandler {
	
     // Method will be executed if before insert event occures	
	 public void onBeforeInsert(List<Account> listNewAccount){
         
         // Calling AccountZoneSuburbMappingHelper to populate the Zone field depending on Sunburb value selected
         AccountZoneSuburbMappingHelper oAccountZoneSuburbMapper = new AccountZoneSuburbMappingHelper();
         oAccountZoneSuburbMapper.insertZoneDependingOnSuburb(listNewAccount);
     }
     
     // Method will be executed if before update event occures
     public void onBeforeUpdate(Map<Id, Account> mapOldAccount, Map<Id, Account> mapNewAccount){
         
         // Calling AccountZoneSuburbMappingHelper to populate the Zone field depending on Sunburb value selected
         AccountZoneSuburbMappingHelper oAccountZoneSuburbMapper = new AccountZoneSuburbMappingHelper();
         oAccountZoneSuburbMapper.updateZoneDependingOnSuburb(mapOldAccount, mapNewAccount);
     }
     
     // Method will be executed if after update event occures
     public void onAfterUpdate(map<id,Account> accOldMap,map<id,Account> accNewMap){  

        //call UpdateAccountUserEmailHelper
        //Handler To update Eamil id on user object if Personal email is changed on booked Account.
        UpdateAccountUserEmailHelper oUpdateAccountUserEmailHelper = new UpdateAccountUserEmailHelper();
        oUpdateAccountUserEmailHelper.updateUser(accOldMap,accNewMap);       
     }
}