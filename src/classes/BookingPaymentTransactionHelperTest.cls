@isTest(SeeAllData = false)
private class BookingPaymentTransactionHelperTest 
{
    static testMethod void testBookingPaymentTransactionTrigger() 
    {
        Account objAccount = BookingPaymentTransactionHelperTest.createAccount();
        insert objAccount;
    
        Booking_Details__c bd = BookingPaymentTransactionHelperTest.createBookingDetail(objAccount);
        insert bd;
        
        List<Booking_Payment_Transaction__c> lstBPT = new List<Booking_Payment_Transaction__c>();
        //lstBPT.addAll(createBPT('NEFT', 'NEW12345678', 200, bd.Id));
        
        lstBPT = BookingPaymentTransactionHelperTest.createBtrRecords(100, 'NEFT', bd, 'NEW12345678');
        lstBPT.addAll(BookingPaymentTransactionHelperTest.createBtrRecords(1, 'Direct Cheque', bd, '123456'));
        lstBPT.addAll(BookingPaymentTransactionHelperTest.createBtrRecords(1, 'Wire Transfer', bd, '123456'));
        lstBPT.addAll(BookingPaymentTransactionHelperTest.createBtrRecords(1, 'Wire Transfer', bd, null));
        
        
        //Failure cases: NEFT.
        lstBPT.addAll(BookingPaymentTransactionHelperTest.createBtrRecords(2, 'NEFT', bd, 'NEW12345678'));
        
        //Sccessful case : 'Direct Cheque' with different BTR fields value.
        lstBPT.addAll(BookingPaymentTransactionHelperTest.createBtrRecords(1, 'Direct Cheque', bd, '123457'));
            
        //Failure case: 'Direct Cheque' with Same BTR detail.
        lstBPT.addAll(BookingPaymentTransactionHelperTest.createBtrRecords(1, 'Direct Cheque', bd, '123456'));
            
            
        //Failure Case: 'Wire Transfer' with Same BTR Detail
        lstBPT.addAll(BookingPaymentTransactionHelperTest.createBtrRecords(1, 'Wire Transfer', bd, '123456'));
            
        //Failure Case: 'Wire Transfer' with Same BTR Detail
        lstBPT.addAll(BookingPaymentTransactionHelperTest.createBtrRecords(1, 'Wire Transfer', bd, null));
        Test.startTest();
        try{
          insert lstBPT ;
        }
        catch(Exception e){
        }
        
        BookingPaymentTransactionHelper.setRunTrue();
        System.debug('---------------------------'+BookingPaymentTransactionHelper.isFirstRun());
        //Update Failure for First record.
        lstBPT[0].UTR_Code__c = 'NEW123456782';
        
        Booking_Payment_Transaction__c objBPT = [Select Id, UTR_Code__c from Booking_Payment_Transaction__c where UTR_Code__c = '123457'];
        objBPT.UTR_Code__c = '123456';
        update objBPT;
        
        System.assertEquals(objBPT.UTR_Code__c , '123456');
        
        lstBPT[lstBPT.size() - 2 ].UTR_Code__c = null;
        try{
            update lstBPT;
        }
        catch(Exception e){
        }
        Test.stopTest();
    }
    
    private static Account createAccount(){
        Account objAccount = new Account();
        objAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        objAccount.FirstName='Test ';
        objAccount.LastName='Account';
        objAccount.CRN__c='121212';
        objAccount.H_Mobile_No__c='4444411111';
        objAccount.Mobile_Phone__c='4444411111';
        objAccount.Co_Applicant__c='test';
        return objAccount;
    }
    
    private static Booking_Details__c createBookingDetail(Account objAccount){
        Booking_Details__c bd = new Booking_Details__c();
        bd.Account__c = objAccount.Id;
        bd.CRN__c = '121212';
        bd.Flat_ID__c ='147147';
        bd.Allotment_Date__c = System.today();
        bd.Project__c = 'Test';
        bd.Cluster__c = 'Clust';
        bd.wing__c = 'Wng';
        return bd;
    }
    private static List<Booking_Payment_Transaction__c> createBtrRecords(Integer pNumber, 
                                                                         String pStrTypeOfTransaction, 
                                                                         Booking_Details__c pIdBooking,
                                                                         String strUTR){
        
        List<Booking_Payment_Transaction__c> listBtr = new List<Booking_Payment_Transaction__c>();
        
        for(Integer intIndex = 0; intIndex < pNumber; intIndex ++){
            
            Booking_Payment_Transaction__c oTempBtr = new Booking_Payment_Transaction__c();
            oTempBtr.Type_of_Transaction_del__c = pStrTypeOfTransaction;
            oTempBtr.Booking__c = pIdBooking.Id;
            oTempBtr.Type_of_Transaction_del__c = pStrTypeOfTransaction;
            
            if(pStrTypeOfTransaction.equalsIgnoreCase('NEFT')){
                oTempBtr.UTR_Code__c = strUTR + intIndex;
            }
            if(pStrTypeOfTransaction.equalsIgnoreCase('Direct Cheque')){
                oTempBtr.UTR_Code__c = strUTR;
            }
            if(pStrTypeOfTransaction.equalsIgnoreCase('Wire Transfer')){
                oTempBtr.UTR_Code__c = strUTR;
            }
            if(pStrTypeOfTransaction.equalsIgnoreCase('RTGS')){
                oTempBtr.UTR_Code__c = 'NEW12345678' + intIndex;
            }
            
            oTempBtr.Bank_Name__c = 'Citibank N.A.';
            oTempBtr.Amount_Transferred__c = 1000;
            oTempBtr.Remitted_to_Account__c = '1000';
            oTempBtr.Transaction_Date__c = System.today();
            oTempBtr.Bank_Account_Holders_Name__c = 'Test';
            
            listBtr.add(oTempBtr);
        }
        return listBtr;
    }
}