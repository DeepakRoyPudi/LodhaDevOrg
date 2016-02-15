global class DNDUpdateOnAccounts implements Database.Batchable<sObject>{ 
   global Database.QueryLocator start(Database.BatchableContext info){ 
       String query='select id,mobile_phone__c,PersonMobilePhone,Mobile1__c,Mobile_CSS__c,CRN__c,recordtypeid,TRAI_DND__c,PersonDoNotCall,Not_Interested_Customer__c from account where recordtype.name=\'Booked Account\' AND TRAI_DND__c=true AND PersonMobilePhone!=null'; 
       return Database.getQueryLocator(query);
   }     
   global void execute(Database.BatchableContext info, List<Account> scope){
       Set<string> mobileset=new Set<string>();
       for(Account a:scope){
           if(a.PersonMobilePhone != null && a.PersonMobilePhone != ''){
               mobileset.add(a.PersonMobilePhone); 
           }      
       }       
       List<account> PersonaccountLst=[select id,mobile_phone__c,Mobile1__c,Mobile_CSS__c,recordtypeid,TRAI_DND__c,PersonDoNotCall,Not_Interested_Customer__c from Account where recordtype.name='Person Account' AND mobile_phone__c IN:mobileset AND ( PersonDoNotCall=false OR Not_Interested_Customer__c=false) ];
       System.debug('==================Retrived Person accountlist======'+PersonaccountLst);
       string emailbody='';
       for(account b:PersonaccountLst){
           b.PersonDoNotCall=true;
           b.Not_Interested_Customer__c=true;
           emailbody+='\n'+b.Id+' with mobile no '+b.mobile_phone__c+'\n';
       }
       update PersonaccountLst;
       
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'kumaresan.m@capgemini.com','Mulakdeep.Singh@lodhagroup.com'};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Information regarding person accounts processed by batch');
        mail.setPlainTextBody('The person account processed with DND are:\n\n' +emailbody);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });        
       
   }     
   global void finish(Database.BatchableContext info){   
   } 
}