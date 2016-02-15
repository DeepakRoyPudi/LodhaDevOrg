global with sharing class LoyaltyRedeemController {
    
    
/*    
    webservice static boolean validateSession(string currentSession){
        
        Boolean isValidSession = false;
        
        if(currentSession!=null && currentSession.trim().equalsIgnoreCase(userInfo.getSessionId()))
        {
            isValidSession =true;
        }
        return isValidSession;
    } 
*/

    webservice static Boolean validateRedeemPoints(string redeemPoints, string programType){
        system.Debug('# -> LoyaltyRedeemController.validateRedeemPoints');
        Boolean isValidPoints = false;
        try{
            if(redeemPoints != null && programType != null){
                system.Debug('# Redeem Points and session IDs are Valid');        
                decimal points = decimal.valueOf(redeemPoints);
                system.Debug('# Redeem Points :'+points);
                ID accid = [Select id, Accountid from User where id = :userInfo.getUserId()].accountid;
                system.Debug('# accid :'+accid);    
                Id LoyaltyId= [Select a.Loyalty_Details__c From Account a where Id=:accid].Loyalty_Details__c;  
                system.Debug('# LoyaltyId :'+LoyaltyId);      
                list<Loyalty_Detail__c> allLoyalty= [Select Id, loyalty_Id__c, Current_casa_ladder__c,Total_preferati_points__c, Total_number_of_referrals__c  From Loyalty_Detail__c where Id =:LoyaltyId];
                system.Debug('# allLoyalty :'+allLoyalty); 
                if(programType.equalsIgnoreCase('Points')
                         && points <= allLoyalty[0].Total_preferati_points__c){
                            
                        isValidPoints = true;
                        
                } else if(programType.equalsIgnoreCase('Ladder') 
                        && redeemPoints == allLoyalty[0].Current_casa_ladder__c){
                    
                     isValidPoints = true;
                }
            }
        } catch(Exception ex) {
            system.Debug('#Exception : '+ex);
            throw new LodhaServiceException('Unexpected Exception. Please Contact Your Salesforce Admin.',ex);            
        }
        system.Debug('# <- LoyaltyRedeemController.validateRedeemPoints');
        return isValidPoints;
    }
    
    /********************************************************************************************************
    Description: Webservice method created records in RedemptionDetails__c and ItemDetails__c 
    Return :  Boolean
    ********************************************************************************************************/
    webservice static Boolean createTransactionDetails(WebMethodOrderResponseWrapper WebMethodOrderResponse){
        system.Debug('# -> LoyaltyRedeemController.createTransactionDetails');        
        RedemptionDetails__c  rd = null;
        String prgType = ''; //added by Pratik A. to make scope wider
        try{
            if(WebMethodOrderResponse != null){
              ResultDataWrapper rsd = WebMethodOrderResponse.ResultData;
              if(rsd != null){
                List<Loyalty_Detail__c> LDList = new List<Loyalty_Detail__c>();
                LDList = [Select Id, Loyalty_Id__c from Loyalty_Detail__c Where Loyalty_Id__c=:rsd.LoyaltyID LIMIT 1]; 
                
                if(!LDList.isEmpty()){   
                    Id UserId = UserInfo.getUserId();             
                    User UserDetails = [Select u.ContactId, u.AccountId  From User u where u.Id=:UserId];
                    rd = new RedemptionDetails__c();
                    rd.Account__c = UserDetails.AccountId;
                    rd.City__c = rsd.City ;
                    rd.Delivery_Address1__c = rsd.Delivery_Address1;
                    rd.Delivery_Address_2__c = rsd.Delivery_Address2;
                    rd.Delivery_Address3__c = rsd.Delivery_Address3;
                    rd.Delivery_Address4__c = rsd.Delivery_Address4;
                    rd.Delivery_Address5__c = rsd.Delivery_Address5;
                    rd.Delivery_Address_6__c = rsd.Delivery_Address6;
                    rd.FirstName__c = rsd.FirstName ;
                    rd.LastName__c = rsd.LastName ;
                    rd.PinCode__c = rsd.PinCode ;
                    rd.Salutation__c = rsd.Salutation ;
                    rd.State__c = rsd.State ;
                    rd.Acknowledgement_Number__c = rsd.AcknowledgementNumber ;
                    rd.Redemption_Confirmation_Number__c = rsd.RedemptionConfirmationNumber ;
                    rd.Ladder__c = rsd.Ladder; 
                    rd.Total_Cart_Points__c = rsd.TotalCartPoints;
                    rd.Loyalty_Detail__c = LDList[0].Id;
                    if(rd != null){
                        insert rd;
                    }
                    //comment by Pratik A. to declare it at top 
                    //String prgType = '';
                    Double Point = 0;
                    if(rsd.Ladder != null && rsd.Ladder != 0){
                        Point = rsd.Ladder;
                        prgType = 'Clubcasa';
                    }else{
                        Point = rsd.TotalCartPoints;
                        prgType = 'Preferati';
                    }
                    if(!''.equals(prgType)){
                        Loyalty_Points_History__c LoyaltyPoint = new Loyalty_Points_History__c();
                        LoyaltyPoint.Account__c = UserDetails.AccountId;
                        LoyaltyPoint.Loyalty_Detail__c =  LDList[0].Id;
                        LoyaltyPoint.Loyalty_Program_Type__c =prgType;
                        LoyaltyPoint.Points_Deducted__c=Point;
                        insert LoyaltyPoint;                                                                              
                    }
                    OrderDetailsWrapper  od = rsd.OrderDetails;
                    if(od != null){ 
                        List<ItemDetailsWrapper> itdList = od.ItemDetails;
                        List<ItemDetails__c> itdCList = new List<ItemDetails__c>();
                        for(ItemDetailsWrapper itds : itdList){                     
                            ItemDetails__c itd = new ItemDetails__c(); 
                            itd.Name = itds.ItemName;
                            itd.ItemPoint__c = itds.ItemPoint;
                            itd.ItemQty__c = itds.ItemQty;
                            itd.RedemptionDate__c = itds.RedemptionDate;
                            itd.Redemption_Details__c = rd.Id;
                            itd.RedemptionStatus__c = itds.RedemptionStatus;
                            itd.TotalPoint__c = itds.TotalItemPoint;
                            itdCList.add(itd);
                        }
                        if(!itdCList.isEmpty()){
                            insert itdCList;
                        }
                    }
                 }
              }
            }
        }catch(Exception e){
            system.Debug('#Exception : '+e);
            throw new LodhaServiceException('Unexpected Exception. Please Contact Your Salesforce Admin.',e);
        }
        system.Debug('# <- LoyaltyRedeemController.createTransactionDetails');          
        if(rd != null){
          SessionTrackController.addsessiondetails('called by web service', 'Redemption', 'Redemption for ' + prgType);
         return true;
        }
        else {
          return false;        
        }
    }
    
    /********************************************************************************************************
    Description: Webservice method to check session_status of logged in member 
    Return :  Boolean
    ********************************************************************************************************/
    webservice static Boolean sessionStatus(){
        return true;
    }
    
    
    webservice static CustomerDetailsResponseWrapper getCustomerDetails(CustomerDetailsRequestWrapper CustomerDetailsRequest){
        system.Debug('# -> LoyaltyRedeemController.getCustomerDetails');
        CustomerDetailsResponseWrapper CustomerDetailsResponse = new CustomerDetailsResponseWrapper();
        try{
            CustomerDetailsResponse.Program_ID = CustomerDetailsRequest.Program_ID;
            CustomerDetailsResponse.SubProgram_ID = CustomerDetailsRequest.SubProgram_ID;
            CustomerDetailsResponse.Country_ID = CustomerDetailsRequest.Country_ID;
            Id UserId = UserInfo.getUserId();
            system.debug('@USER:' + UserId);
            User UserDetails = [Select u.ContactId, u.AccountId  From User u where u.Id=:UserId];
            if(UserDetails.AccountId != null){
                Account acc = [Select a.Id, a.Salutation, a.FirstName, a.LastName, 
                                      a.Mobile_Phone__c, a.PersonEmail, a.Phone,
                                      a.BillingStreet, a.BillingState, a.BillingPostalCode, a.BillingCountry, a.BillingCity,
                                      a.Loyalty_Details__r.Loyalty_Id__c,
                                      a.Loyalty_Details__c  From Account a Where a.Id=:UserDetails.AccountId];
                if(acc!=null){
                    CustomerDetailsResponse.Session_Status = 'Active';
                    CustomerDetailsResponse.Loyalty_ID = acc.Loyalty_Details__r.Loyalty_Id__c;
                    CustomerDetailsResponse.Customer_First_Name = acc.FirstName;
                    CustomerDetailsResponse.Customer_Last_Name = acc.LastName;
                    CustomerDetailsResponse.Registered_Address_Line_1 = acc.BillingStreet;
                    //CustomerDetailsResponse.Registered_Address_Line_2;
                    CustomerDetailsResponse.Registered_Address_Line_3 = acc.BillingCountry;
                    CustomerDetailsResponse.Registered_Address_City = acc.BillingCity;
                    CustomerDetailsResponse.Registered_Address_State = acc.BillingState;
                    CustomerDetailsResponse.Registered_Address_PinCode = acc.BillingPostalCode;
                    CustomerDetailsResponse.Registered_Email_ID = acc.PersonEmail;
                    CustomerDetailsResponse.Registered_Mobile_No = acc.Mobile_Phone__c;
                    CustomerDetailsResponse.Registered_Landline_No = acc.Phone;
                    
                    
                    if(acc.Loyalty_Details__c != null){
                        Loyalty_Detail__c LDDetails = [Select Id, Current_casa_ladder__c, Total_preferati_points__c  From Loyalty_Detail__c  where Id =:acc.Loyalty_Details__c LIMIT 1];
                        system.debug('#LDDetails:' + LDDetails.Current_casa_ladder__c);
                        system.debug('#Id:' + LDDetails.Id);
                        if(LDDetails != null){  
                            CustomerDetailsResponse.Ladder_Type = LDDetails.Current_casa_ladder__c; //total number of ladder
                            CustomerDetailsResponse.Points = LDDetails.Total_preferati_points__c;  // total points
                        }
                    }
                }                                     
            }
            system.debug('#CustomerDetailsResponse:' + CustomerDetailsResponse);
        }catch(Exception e){
            system.Debug('Exception :'+e);
            throw new LodhaServiceException('Unexpected Exception. Please Contact Your Salesforce Admin.',e);
        }
        system.Debug('# <- LoyaltyRedeemController.getCustomerDetails');
        return CustomerDetailsResponse;
    }
    
   
    
    global class WebMethodOrderResponseWrapper{
        webservice ResultDataWrapper ResultData;
    }
    
    global class ResultDataWrapper{
        webservice String PragramID;
        webservice String CountryID;
        webservice String LoyaltyID;
        webservice String Salutation;
        webservice String FirstName;
        webservice String LastName;
        webservice Decimal Ladder;
        webservice String Delivery_Address1;
        webservice String Delivery_Address2;
        webservice String Delivery_Address3;
        webservice String Delivery_Address4;
        webservice String Delivery_Address5;
        webservice String Delivery_Address6;
        webservice String City;
        webservice String State;
        webservice String PinCode;
        webservice String RedemptionConfirmationNumber;
        webservice String AcknowledgementNumber;
        webservice Decimal TotalCartPoints;
        webservice OrderDetailsWrapper OrderDetails;
    }
    
    global class OrderDetailsWrapper{
        webservice List<ItemDetailsWrapper> ItemDetails;
    }
    global class ItemDetailsWrapper{
        webservice String ItemName;
        webservice Decimal ItemPoint;
        webservice Decimal ItemQty;
        webservice Decimal TotalItemPoint;
        webservice String RedemptionStatus;
        webservice Date RedemptionDate;
    
    }
    
    global class CustomerDetailsRequestWrapper{
        webservice String Program_ID;
        webservice String SubProgram_ID;
        webservice String Country_ID;
    }

    global class CustomerDetailsResponseWrapper{
        webservice String Program_ID;
        webservice String SubProgram_ID;
        webservice String Country_ID;
        webservice String Session_Status;
        webservice String Loyalty_ID;
        webservice String Ladder_Type;
        webservice Decimal Points;
        webservice String Customer_First_Name;
        webservice String Customer_Last_Name;
        webservice String Registered_Address_Line_1;
        webservice String Registered_Address_Line_2;
        webservice String Registered_Address_Line_3;
        webservice String Registered_Address_City;
        webservice String Registered_Address_State;
        webservice String Registered_Address_PinCode;
        webservice String Registered_Email_ID;
        webservice String Registered_Mobile_No;
        webservice String Registered_Landline_No;
    }   
    
    /***************************************************
    Webservice Exception Class 
    ***************************************************/    
    public class LodhaServiceException extends Exception {
    }
    
    /******************************************* Test Method ***********************************************/
        
    @isTest(seealldata = False)
    public static void testLoyaltyRedeemController()
    {
        Id ProfileId=[Select Id, Name, UserLicense.LicenseDefinitionKey From Profile Where Name = 'Custom Overage High Volume Customer Portal'].Id;
            
        id RTId = [Select id from RecordType where Name = 'Booked Account'].id;
            
        Loyalty_Detail__c testLoyalty= new Loyalty_Detail__c();
        testLoyalty.Name ='test';
        testLoyalty.Loyalty_Id__c = 'LY01';
        insert testLoyalty;
        Account lAccount = new Account(FirstName = 'testFirstacc',
                        LastNAme = 'testLastacc',
                        Recordtypeid = RTId,
                        Status__c = 'Created',
                        PersonMobilePhone = '9324567888',
                        PersonEmail = 'ltest@test.com',
                        CRN__c = '898980',
                        Personal_Email__pc = 'ltest@test.com',
                        Loyalty_Details__c = testLoyalty.Id
                        );
        insert lAccount;
    
        Id lContact = [Select id  from Contact where Accountid =: lAccount.Id].Id;
         
        User portalUser= new User(Alias='TESTUSER',Email='TEST.USER@TEST.TEST',
                EmailEncodingKey='UTF-8',FirstName='First_TEST',LastName='TEST_LAST_NAME', LanguageLocaleKey='en_US',
                LocaleSidKey='en_GB',ProfileId=ProfileId, timezonesidkey='Europe/London',Title='TEST TITLE',
                username='TEST.USER@TEST.TEST', contactid=lContact);
        insert portalUser; 
       
       CustomerDetailsRequestWrapper CDRW = new CustomerDetailsRequestWrapper();
       
        system.runAS(portalUser)
        {
            LoyaltyRedeemController.getCustomerDetails(CDRW);
            LoyaltyRedeemController.validateRedeemPoints('10','Points');
        }
       
       List<ItemDetailsWrapper> IDW = new List<ItemDetailsWrapper>(); 
       
       ItemDetailsWrapper idwobj = new ItemDetailsWrapper();
       
       idwobj.ItemName = 'ItemName';
       idwobj.ItemPoint = 10.00;
       idwobj.ItemQty = 10.00;
       idwobj.TotalItemPoint = 10.00;
       idwobj.RedemptionStatus = 'RedemptionStatus';
       IDW .add(idwobj);
       
       OrderDetailsWrapper ODW = new OrderDetailsWrapper();
       
       ODW.ItemDetails = IDW;
       
       WebMethodOrderResponseWrapper WMORW = new WebMethodOrderResponseWrapper();
        
       ResultDataWrapper RDW = new ResultDataWrapper();
       RDW.PragramID = 'P0001';
       RDW.CountryID = '91';
       RDW.LoyaltyID = testLoyalty.Loyalty_Id__c;
       RDW.Salutation = 'Sal';
       RDW.FirstName = 'Test';
       RDW.LastName = 'Test';
       RDW.Ladder = 5.00;
       RDW.Delivery_Address1 = 'Address';
       RDW.OrderDetails = ODW;
        
       WMORW.ResultData = RDW;
        
       LoyaltyRedeemController.createTransactionDetails(WMORW);
    }
}