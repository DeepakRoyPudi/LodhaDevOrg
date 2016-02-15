@isTest
    private class testupdateProjectNameonAccount{    
        
        public static testMethod void testchangeOwnermethod() {
        
                Account a = [Select ID from Account where RecordType.Name = 'Booked Account' LIMIT 1];
                Booking_Details__c std = new Booking_Details__c(
                                                Account__c = a.id,
                                                CRN__c = '12345678',
                                                Flat_ID__c = '12345678');
                insert std;
        }
    }