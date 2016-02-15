@isTest(seealldata=false)  
private class testinactivateUserForCancelledAccount {                    
    public static testMethod void myunittest() {
    
    id RTId = [Select id from RecordType where Name = 'Booked Account'].id;
    Account a = new Account(FirstName = 'testFirstacc',
                            LastNAme = 'testLastacc',
                            Recordtypeid = RTId,
                            Status__c = 'Created',
                            PersonMobilePhone = '1234567890',
                            PersonEmail = 'testtest@test.com',
                            CRN__c = '098899',
                            Personal_Email__pc = 'testtest1@test.com'
                            );
    insert a;
    
            
    a.Status__c = 'Active';
    update a;
    
    a.Status__c = 'Cancelled';
    update a;
    
    deactivateUser.send_email1('test','test','test@gmail.com');
    }
}