public with sharing class DespatchController {

Public List<Despatch__c> despatchlist{get;set;} 

        public despatchcontroller(){
            despatchlist = getDespatchList() ; 
        }
        
        public List<Despatch__c> getDespatchList(){
            List<Despatch__c> displaylist = [SELECT Waybill_No__c, Courier_Name__c, Courier_Site__c, Courier_Name_For__c, Area__c, Contents__c FROM Despatch__c WHERE Waybill_No__c != NULL ORDER BY Despatch_Date__c DESC LIMIT 10]; 
            return displaylist;
        }
        
   
        static testMethod void myUnitTest() {
        
            id RTId = [Select id from RecordType where Name = 'Booked Account'].id;      
            Account a = new Account(FirstName = 'testFirstacc',
                                    LastNAme = 'testLastacc',
                                    Recordtypeid = RTId,
                                    Status__c = 'Created',
                                    PersonMobilePhone = '1234567890',
                                    PersonEmail = 'testtest@test.com',
                                    CRN__c = '098899',
                                    Personal_Email__pc = 'testtest1@test.com',
                                    Project_Name__c = 'Casa Bella Gold'
                                    );
            insert a;
          
            Contact c = [Select id from Contact where AccountId =: a.Id];
             
            id ProfId = [Select id from Profile where Name = 'Custom Overage High Volume Customer Portal'].id;
         
            User u = new User();
            u.LastName = 'testLastacc';
            u.Alias = 'tuser';
            u.Email = 'testtest@test.com';
            u.ContactId = c.Id;
            u.Username = 'testtest123@test.com';
            u.CommunityNickname = 'Testuser';
            u.ProfileId = ProfId;
            //u.TimeZoneSidKey = 'Asia/Calcutta';
            u.TimeZoneSidKey = 'Asia/Kolkata';
            u.LocaleSidKey = 'en_IE_EURO';
            u.EmailEncodingKey = 'ISO-8859-1';
            u.LanguageLocaleKey = 'en_US';
            u.IsActive = true;
            insert u;
        
            System.runAs(u){ 
                despatchcontroller obj = new despatchcontroller();
            }           
        }  
}