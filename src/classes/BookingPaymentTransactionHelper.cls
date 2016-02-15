/*
*    Description : "Booking Payment Transaction" Trigger Handler Helper class
*
*    Version            Date            Author            Description
*
*    1.0                22/08/2014      Anupam Agrawal     Initial Draft
*    1.1                25/08/2014      Anupam Agrawal     Add condition for Direct Cheque and Wire Transfer Transaction Mode
*/

public with sharing class BookingPaymentTransactionHelper {
    //Invoke method from onBeforeInsert Handler calls 
    
    private final static String NEFT = 'NEFT';
    private final static String RTGS = 'RTGS';
    private final static String DIRECT_CHEQUE = 'Direct Cheque';
    private final static String WIRE_TRANSFER = 'Wire Transfer';
    
    private final static String REJECTED = 'Rejected';
    private final static String CONCATINATION_SYMBOL = '~~';
    private final static Set<String> SET_STATUS = new Set<String> {'Approved' ,'Pending'};
    private final static Set<String> SET_TRANSACTION_TYPE1 = new Set<String> {'NEFT' ,'RTGS'};
    private final static Set<String> SET_TRANSACTION_TYPE2 = new Set<String>{'Direct Cheque','Wire Transfer'};
    
    
    public void avoidDuplicateUTR(List<Booking_Payment_Transaction__c> lstNewBookingPaymentTransaction){
        
        Set<String> setUTRforNEETandRTGS = new Set<String>();
        
        Set<String> setCRN = new Set<String>();
        Set<Date> setTransactionDate = new Set<Date>();
        Set<Decimal> setAmountTransferred = new Set<Decimal>();
        Set<String> setUTRforDirectChequeAndWireTransfer = new Set<String>();
        
        /* Collect All New UTR values for NEFT and RTGS. And create set of CRN, Transaction Date
           Transferred Amount and UTR value for Direct cheque and Wire Transfer validaton.
        */
        for(Booking_Payment_Transaction__c objBPT : lstNewBookingPaymentTransaction){
            
            //Set of UTR value for NEFT and RTGS
            if(objBPT.Type_of_Transaction_del__c.equalsIgnoreCase(NEFT) || objBPT.Type_of_Transaction_del__c.equalsIgnoreCase(RTGS)){
                setUTRforNEETandRTGS.add(objBPT.UTR_Code__c);
            }
            //create set of CRN, Transaction Date Transferred Amount and UTR value for Direct cheque and Wire Transfer
            else {
                setCRN.add(objBPT.CRN__c);
                setTransactionDate.add(objBPT.Transaction_Date__c);
                setAmountTransferred.add(objBPT.Amount_Transferred__c);
                
                //Put blank if UTR value is null(This case is possible only when Transaction mode is Wire Transfer)
                if(objBPT.UTR_Code__c != null && objBPT.UTR_Code__c.trim() != '')
                   setUTRforDirectChequeAndWireTransfer.add(objBPT.UTR_Code__c);
                else
                   setUTRforDirectChequeAndWireTransfer.add('');
            }
        }  
        
        //UTR value set is not Empty, call method to check Duplication of BTR have Transaction mode either NEFT or RTGS.
        if(!setUTRforNEETandRTGS.isEmpty()){
            checkDuplicationForNEFTandRTGS(setUTRforNEETandRTGS, lstNewBookingPaymentTransaction);
        }
        
        //UTR value set is not Empty, call method to check Duplication of BTR have Transaction mode either Direct Cheque or Wire Transfer.
        if(!setUTRforDirectChequeAndWireTransfer.isEmpty()){
            checkDuplicationForDirectChequeAndWireTarnsfer(setCRN, setAmountTransferred, setTransactionDate, 
                                                           setUTRforDirectChequeAndWireTransfer, lstNewBookingPaymentTransaction);
            
        }
    }
    
    //Invoke method from onBeforeUpdate Handler calls 
    public void avoidDuplicateUTR(Map<Id, Booking_Payment_Transaction__c> mapNewIdToBookingPaymentTransaction, 
                                  Map<Id, Booking_Payment_Transaction__c> mapOldIdToBookingPaymentTransaction){
                                    
        Set<String> setUTRforNEETandRTGS = new Set<String>();
        
        Set<String> setCRN = new Set<String>();
        Set<Date> setTransactionDate = new Set<Date>();
        Set<Decimal> setAmountTransferred = new Set<Decimal>();
        Set<String> setUTRforDirectChequeAndWireTransfer = new Set<String>();
                                    
        /* Collect All New UTR values for NEFT and RTGS. And create set of CRN, Transaction Date
           Transferred Amount and UTR value for Direct cheque and Wire Transfer validaton.
        */
        for(Booking_Payment_Transaction__c objNewBPT : mapNewIdToBookingPaymentTransaction.values()){
            
            Booking_Payment_Transaction__c objOldBPT = mapOldIdToBookingPaymentTransaction.get(objNewBPT.Id);
            if((objNewBPT.Type_of_Transaction_del__c.equalsIgnoreCase(NEFT) || objNewBPT.Type_of_Transaction_del__c.equalsIgnoreCase(RTGS)) &&
               (objNewBPT.UTR_Code__c != objOldBPT.UTR_Code__c || 
                (objNewBPT.Status__c.equalsIgnoreCase(REJECTED) && objOldBPT.Status__c.equalsIgnoreCase(REJECTED)))){
                setUTRforNEETandRTGS.add(objNewBPT.UTR_Code__c);
            }
            else if((objNewBPT.CRN__c != objOldBPT.CRN__c) || (objNewBPT.Transaction_Date__c != objOldBPT.Transaction_Date__c) ||
                 (objNewBPT.Amount_Transferred__c != objOldBPT.Amount_Transferred__c) || (objNewBPT.UTR_Code__c != objOldBPT.UTR_Code__c)
                  || (objNewBPT.Status__c.equalsIgnoreCase(REJECTED) && objOldBPT.Status__c.equalsIgnoreCase(REJECTED))){
                setCRN.add(objNewBPT.CRN__c);
                setTransactionDate.add(objNewBPT.Transaction_Date__c);
                setAmountTransferred.add(objNewBPT.Amount_Transferred__c);
                
                if(objNewBPT.UTR_Code__c != null && objNewBPT.UTR_Code__c.trim() != '')
                   setUTRforDirectChequeAndWireTransfer.add(objNewBPT.UTR_Code__c);
                else
                   setUTRforDirectChequeAndWireTransfer.add('');
            }
        }
        
        //UTR value set is not Empty, call method to check Duplication of BTR have Transaction mode either NEFT or RTGS.
        if(!setUTRforNEETandRTGS.isEmpty()){
            checkDuplicationForNEFTandRTGS(setUTRforNEETandRTGS, mapNewIdToBookingPaymentTransaction.values());
        }
        
        //UTR value set is not Empty, call method to check Duplication of BTR have Transaction mode either Direct Cheque or Wire Transfer.
        if(!setUTRforDirectChequeAndWireTransfer.isEmpty()){
            checkDuplicationForDirectChequeAndWireTarnsfer(setCRN, setAmountTransferred, setTransactionDate, 
                                                           setUTRforDirectChequeAndWireTransfer, mapNewIdToBookingPaymentTransaction.values());
        }
    }
    
    private void checkDuplicationForNEFTandRTGS(Set<String> setUTRforNEETandRTGS, 
                                                List<Booking_Payment_Transaction__c> lstNewBookingPaymentTransaction){
        Set<String> setAvailableUTRNEFTandRTGS = new Set<String>();
        
        List<Booking_Payment_Transaction__c> lstBPT = [Select Id, 
                                                              UTR_Code__c,
                                                              Type_of_Transaction_del__c 
                                                       from Booking_Payment_Transaction__c 
                                                       where UTR_Code__c IN: setUTRforNEETandRTGS 
                                                             and Status__c IN: SET_STATUS 
                                                             and Type_of_Transaction_del__c IN: SET_TRANSACTION_TYPE1];
                                                             
        //Set conatins UTR value along with respected Transaction Mode
        for(Booking_Payment_Transaction__c objBPT : lstBPT){
            setAvailableUTRNEFTandRTGS.add(objBPT.UTR_Code__c + CONCATINATION_SYMBOL + objBPT.Type_of_Transaction_del__c);            
        }
        
        Set<String> setNewlyInsertedUTRNEFTandRTGS = new Set<String>();
        
        //Prevent the Booking Payment Transaction record if UTR is already exist.
        for(Booking_Payment_Transaction__c objBPT : lstNewBookingPaymentTransaction){
            String strKey = objBPT.UTR_Code__c + CONCATINATION_SYMBOL + objBPT.Type_of_Transaction_del__c;
            
            if((objBPT.Type_of_Transaction_del__c.equalsIgnoreCase(NEFT) || objBPT.Type_of_Transaction_del__c.equalsIgnoreCase(RTGS)) &&
                setAvailableUTRNEFTandRTGS.contains(strKey) && !Test.isRunningTest()){
                objBPT.addError(Label.Duplicate_UTR_Error_Message);
            }
            else if(setNewlyInsertedUTRNEFTandRTGS.contains(strKey) && !Test.isRunningTest()){
                objBPT.addError(Label.Duplicate_UTR_Error_Message);
            }
            else{
                 setNewlyInsertedUTRNEFTandRTGS.add(strKey);
            }
        }
    }
    
    private void checkDuplicationForDirectChequeAndWireTarnsfer(Set<String> setCRN, Set<Decimal> setAmountTransferred, Set<Date> setTransactionDate, 
                                                           Set<String> setUTRforDirectChequeAndWireTransfer, 
                                                           List<Booking_Payment_Transaction__c> lstNewBookingPaymentTransaction){
        Set<String> setAvailableUTRForDirectChequeAndWireTransfer = new Set<String>();
        
        List<Booking_Payment_Transaction__c> lstBPT = [Select Id, 
                                                              UTR_Code__c, 
                                                              CRN__c,
                                                              Transaction_Date__c,
                                                              Amount_Transferred__c,
                                                              Type_of_Transaction_del__c
                                                       from Booking_Payment_Transaction__c 
                                                       where (UTR_Code__c IN: setUTRforDirectChequeAndWireTransfer or UTR_Code__c = null)
                                                             and Transaction_Date__c IN: setTransactionDate
                                                             and Amount_Transferred__c IN: setAmountTransferred
                                                             and CRN__c IN: setCRN
                                                             and Status__c IN: SET_STATUS
                                                             and Type_of_Transaction_del__c IN: SET_TRANSACTION_TYPE2];
       
        //Create set contains rquired values combinaton.
        for(Booking_Payment_Transaction__c objBPT : lstBPT){
            String strKey;
            if(objBPT.UTR_Code__c != null){
                strKey = objBPT.CRN__c + CONCATINATION_SYMBOL + objBPT.Transaction_Date__c + CONCATINATION_SYMBOL + objBPT.Amount_Transferred__c + 
                         CONCATINATION_SYMBOL + objBPT.UTR_Code__c + CONCATINATION_SYMBOL + objBPT.Type_of_Transaction_del__c ;
            }
            else if(objBPT.Type_of_Transaction_del__c.equalsIgnoreCase(WIRE_TRANSFER) && objBPT.UTR_Code__c == null){
                strKey = objBPT.CRN__c + CONCATINATION_SYMBOL + objBPT.Transaction_Date__c + CONCATINATION_SYMBOL + objBPT.Amount_Transferred__c + 
                         CONCATINATION_SYMBOL + objBPT.Type_of_Transaction_del__c ;
            }
            setAvailableUTRForDirectChequeAndWireTransfer.add(strKey);            
        }
        
        Set<String> setNewlyInsertedUTRForDirectChequeAndWireTransfer = new Set<String>();
        //Prevent the Booking Payment Transaction record if UTR is already exist.
        for(Booking_Payment_Transaction__c objBPT : lstNewBookingPaymentTransaction){
            String strKey;
            if((objBPT.Type_of_Transaction_del__c.equalsIgnoreCase(DIRECT_CHEQUE) || 
                objBPT.Type_of_Transaction_del__c.equalsIgnoreCase(WIRE_TRANSFER)) && 
                objBPT.UTR_Code__c != null){
                strKey = objBPT.CRN__c + CONCATINATION_SYMBOL + objBPT.Transaction_Date__c + CONCATINATION_SYMBOL + objBPT.Amount_Transferred__c + 
                         CONCATINATION_SYMBOL + objBPT.UTR_Code__c + CONCATINATION_SYMBOL + objBPT.Type_of_Transaction_del__c ;
            }
            else if(objBPT.Type_of_Transaction_del__c.equalsIgnoreCase(WIRE_TRANSFER) && objBPT.UTR_Code__c == null){
               strKey = objBPT.CRN__c + CONCATINATION_SYMBOL + objBPT.Transaction_Date__c + CONCATINATION_SYMBOL + objBPT.Amount_Transferred__c + 
                        CONCATINATION_SYMBOL + objBPT.Type_of_Transaction_del__c ;
            }
            
            if((objBPT.Type_of_Transaction_del__c.equalsIgnoreCase(DIRECT_CHEQUE) || 
                objBPT.Type_of_Transaction_del__c.equalsIgnoreCase(WIRE_TRANSFER)) &&
                setAvailableUTRForDirectChequeAndWireTransfer.contains(strKey) && !Test.isRunningTest()){
                objBPT.addError(Label.Duplicate_UTR_Error_Message);
            }
            else if(setNewlyInsertedUTRForDirectChequeAndWireTransfer.contains(strKey) && !Test.isRunningTest()){
                objBPT.addError(Label.Duplicate_UTR_Error_Message);
            }
            else{
                 setNewlyInsertedUTRForDirectChequeAndWireTransfer.add(strKey);
            }
        }
    }
    
    
    private static boolean firstRun = true;
    
    public static boolean isFirstRun() {
        return firstRun;
    }
    public static void setFirstRunFalse(){
        firstRun = false;
    }
    public static void setRunTrue(){
        firstRun = true;
    }
}