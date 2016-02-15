global class Batch_AccountLastLoginDate_Retrofit implements  Database.Batchable<sObject>{

    global Database.QueryLocator start(Database.BatchableContext BC){
        string query='SELECT Id,contact.AccountId,LastLoginDate,contact.Account.Last_Login__c from user where LastLoginDate != null and contact.Account.RecordType.name=\'Booked Account\' and contact.Account.IsCustomerPortal=true and contact.Account.Last_Login__c=null';
        return Database.getQueryLocator(query);  
     }
     global void execute(Database.BatchableContext BC, List<user> scope){        
         for(user a:scope){
             a.contact.Account.Last_Login__c = a.LastLoginDate;   
             update a.contact.Account; 
         }       
    }
    global void finish(Database.BatchableContext BC){
    }
}