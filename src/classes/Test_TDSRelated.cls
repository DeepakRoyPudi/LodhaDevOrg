@isTest(seealldata=true)
Public class Test_TDSRelated{
    
    public static testmethod void Test_TDSRelated(){
        User u = [SELECT Id, Name, Username, ProfileId,isactive,profile.name from User Where profile.name='Customer Care Dombivali 1' AND isactive=true limit 1];
        
        id RTId = [Select id from RecordType where Name = 'Person Account'].id;
        
        Account a = new Account(FirstName = 'wedert',
                            LastNAme = 'wedert',
                            Recordtypeid = RTId,
                            Status__c = 'Created',
                            PersonMobilePhone = '2222222222',
                            PersonEmail = 'wwwww@test.com',
                            CRN__c = '2389788',
                            Personal_Email__pc = 'wwwww@test.com'
                            );
        insert a;   
        List<account> accLst=new List<account>();
        accLst.add(a);
        system.runas(u){            
            TDSRelated.validationForCCUsers(accLst);
        }
    
    }


}