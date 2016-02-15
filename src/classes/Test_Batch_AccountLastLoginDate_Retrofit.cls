@IsTest(SeeAllData=false)
public class Test_Batch_AccountLastLoginDate_Retrofit{    
    Testmethod static void newmethod(){
    Id newid=[select id,name from recordtype where name='Booked Account'].id;
    Id pId= [Select Id from Profile where Name =:'Custom Overage High Volume Customer Portal' limit 1].id;
    
    Account a=new Account();
        a.FirstName='Test';
        a.LastName='One';
        a.Personal_Email__pc='test1@cg.com';
        a.Last_Login__c = Null;
        a.RecordTypeId=newid;
        insert a;
    
    Contact c = [Select Id from contact where accountId =: a.Id ];
            
        User u = new User();
        u.LastName = 'TestUser';
        u.Alias = 'tuser';
        u.Email = 'test@test.in';
        u.Username = 'abc_123@test.com';
        u.CommunityNickname = 'Testuser';
        u.profileId = pId;
        u.IsActive = true;
        u.ContactId = c.id;
        //u.TimeZoneSidKey = 'Asia/Calcutta';
        u.TimeZoneSidKey = 'Asia/Kolkata';
        u.LocaleSidKey = 'en_IE_EURO';
        u.EmailEncodingKey = 'ISO-8859-1';
        u.LanguageLocaleKey = 'en_US';
        insert u;  
        
        List<user> query=[SELECT Id,contact.AccountId,LastLoginDate,contact.Account.Last_Login__c from user where LastLoginDate != null and contact.Account.RecordType.name='Booked Account' and contact.Account.IsCustomerPortal=true and contact.Account.Last_Login__c=null]; 
            
        Database.BatchableContext BC;
        Batch_AccountLastLoginDate_Retrofit batchRP = new Batch_AccountLastLoginDate_Retrofit();
        batchRP.start(BC);
        Database.executeBatch(batchRP);
        batchRP.execute(BC,query);


    }
}