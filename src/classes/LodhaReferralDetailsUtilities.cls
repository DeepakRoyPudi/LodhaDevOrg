/**********************************************************************************
Name:  LodhaReferralDetailsUtilities
Copyright © 2012  Lodha Group
===================================================================================
===================================================================================
Purpose:
-------
This utilities used to update Referral details object.. 
===================================================================================
===================================================================================
History
-------
VERSION    AUTHOR                DATE             DETAIL              
1.0 -   CG Dev Team          27/06/2012      INITIAL DEVELOPMENT
**********************************************************************************/

public with sharing class LodhaReferralDetailsUtilities {
    
    //Insert into Lead Referral Details Object
    public static boolean  insertLeadReferralDetails(Id leadId, string LoyaltyId){
        Boolean isSuccess =false;
        string leadMobileNo = [Select Id, Mobile__c From Lead Where Id = : leadId].Mobile__c;
        
        List<ReferralDetails__c> ref = [Select id, Status__c, Lead__r.Mobile__c, Opportunity__r.Mobile_no__c, Opportunity__c, Lead__c, Loyalty_Detail__c From ReferralDetails__c Where Lead__r.Mobile__c =: leadMobileNo OR Opportunity__r.Account.Mobile_Phone__c =:leadMobileNo];
        system.debug('#ref:' + ref);
        List<ReferralDetails__c> ref1 = new List<ReferralDetails__c>();
        system.debug('LodhaReferralDetailsUtilities:insertLeadReferralDetails starts');
            try{
                for(ReferralDetails__c r: ref)
                {
                    
                    r.Status__c = 'Duplicate';
                    ref1.add(r);
                }
                Update ref1;
                system.debug('#ref1:' + ref1);
                ReferralDetails__c aReferral= new ReferralDetails__c();                 
                aReferral.Loyalty_Detail__c = LoyaltyId ;
                aReferral.Lead__c = leadId;
            //    aReferral.Status__c = 'Lead Created'; 
                insert aReferral;       
                isSuccess = true;
            }
            catch(Exception ex){
                throw ex;
                system.debug('LodhaReferralDetailsUtilities:insertLeadReferralDetails'+ex.getMessage());
            }
        system.debug('LodhaReferralDetailsUtilities:insertLeadReferralDetails ends');
        return isSuccess;
    }
    
    //Add Opportunity info into Referral Details Object
    public static void updateOpportunityReferralDetails(list<Opportunity> lstOpportunity){
        system.debug('LodhaReferralDetailsUtilities:updateOpportunityReferralDetails starts');
            try{ 
                    
                Map<Id,Opportunity> oppMapIds= new Map<Id,Opportunity>();
                set<String> leadIds = new set<String>();
                for(Opportunity aOpps:lstOpportunity){
                    oppMapIds.put(aOpps.Lead_ID__c,aOpps);
                    leadIds.add(aOpps.Lead_ID__c);
                }
                
                list<ReferralDetails__c> newReferrals= new list<ReferralDetails__c>();      
                
                list<ReferralDetails__c> lstReferrals= new list<ReferralDetails__c>();      
                lstReferrals = [Select id,Lead__c ,Opportunity__c,Status__c from ReferralDetails__c where Lead__c=:leadIds];
            
                for(ReferralDetails__c aReferral:lstReferrals) {
                        aReferral.Opportunity__c = oppMapIds.get(aReferral.Lead__c).Id;                     
                        aReferral.Status__c = oppMapIds.get(aReferral.Lead__c).Referral_Status__c;                   
                        newReferrals.add(aReferral);
                }
                update newReferrals;
            } catch(Exception ex){
                system.debug('LodhaReferralDetailsUtilities:updateOpportunityReferralDetails'+ex.getMessage());
            }
            system.debug('LodhaReferralDetailsUtilities:updateOpportunityReferralDetails exists');
    }
    
    //Add Opportunity info into Referral Details Object
    public static void updateReferralPointsDetails(list<Loyalty_Points_History__c > lstLoyaltyPointsHistory){
        system.debug('LodhaReferralDetailsUtilities:updateReferralPointsDetails starts');
            try{ 
                system.debug('**********'+lstLoyaltyPointsHistory);
                
                set<Id> allLoyaltyDetailIds = new set<Id>();
                for(Loyalty_Points_History__c loyaltyHistory:lstLoyaltyPointsHistory){
                    allLoyaltyDetailIds.add(loyaltyHistory.Loyalty_Detail__c);
                }
                set<string> allLoyaltyIds = new set<string>();
                for(Loyalty_Detail__c aloyalty: [Select Loyalty_Id__c from Loyalty_Detail__c where id in: allLoyaltyDetailIds]){
                    allLoyaltyIds.add(aloyalty.Loyalty_Id__c);
                }
                
                system.debug('**********'+allLoyaltyIds);
                Map<string,decimal> LoyaltyPointsAddedMap= new Map<string,decimal>();
                Map<string,decimal> LoyaltyPointsDeductedMap= new Map<string,decimal>();
                Map<string,decimal> LoyaltyladderAddedMap= new Map<string,decimal>();
                Map<string,decimal> LoyaltyladderDeductedMap= new Map<string,decimal>();
                decimal newPoints;
                
                list<Loyalty_Points_History__c> allRelatedLoyaltyPoints = [Select Id, Points_Deducted__c, Points_Added__c, Loyalty_Program_Type__c,Loyalty_Detail__r.Loyalty_Id__c From Loyalty_Points_History__c where Loyalty_Detail__r.Loyalty_Id__c In: allLoyaltyIds];
                system.debug('# 0'+allRelatedLoyaltyPoints);
                system.debug('# 1'+allRelatedLoyaltyPoints[0].Loyalty_Detail__r.Loyalty_Id__c);
                for(Loyalty_Points_History__c loyaltyHistory:allRelatedLoyaltyPoints){
                    system.debug('# 2'+loyaltyHistory);
                    system.debug('# y'+loyaltyHistory.Points_Added__c);
                    if(loyaltyHistory.Loyalty_Program_Type__c=='Preferati'){
                        system.debug('# x'+loyaltyHistory);
                                newPoints = 0;
                                
                                if(LoyaltyPointsAddedMap.get(loyaltyHistory.Loyalty_Detail__r.Loyalty_Id__c)!=null){
                                    
                                    newPoints= LoyaltyPointsAddedMap.get(loyaltyHistory.Loyalty_Detail__r.Loyalty_Id__c)+((loyaltyHistory.Points_Added__c==null)?0:loyaltyHistory.Points_Added__c);
                                    
                                } else{                                 
                                    newPoints=((loyaltyHistory.Points_Added__c==null)?0:loyaltyHistory.Points_Added__c);
                                }
                                
                                LoyaltyPointsAddedMap.put(loyaltyHistory.Loyalty_Detail__r.Loyalty_Id__c,newPoints);
                                
                                newPoints = 0;
                                
                                if(LoyaltyPointsDeductedMap.get(loyaltyHistory.Loyalty_Detail__r.Loyalty_Id__c)!=null ){
                                    
                                    newPoints= LoyaltyPointsDeductedMap.get(loyaltyHistory.Loyalty_Detail__r.Loyalty_Id__c) + ((loyaltyHistory.Points_Deducted__c ==null)?0:loyaltyHistory.Points_Deducted__c);
                                    
                                } else{                                 
                                    
                                    newPoints = ((loyaltyHistory.Points_Deducted__c==null)?0:loyaltyHistory.Points_Deducted__c);
                                }
    
                                LoyaltyPointsDeductedMap.put(loyaltyHistory.Loyalty_Detail__r.Loyalty_Id__c,newPoints);
                                
                    } else if(loyaltyHistory.Loyalty_Program_Type__c=='Clubcasa'){
                        
                                newPoints = 0;
                                newPoints=LoyaltyladderAddedMap.get(loyaltyHistory.Loyalty_Detail__r.Loyalty_Id__c);
                                
                                if(LoyaltyladderAddedMap.get(loyaltyHistory.Loyalty_Detail__r.Loyalty_Id__c)!=null){
                                    newPoints= LoyaltyladderAddedMap.get(loyaltyHistory.Loyalty_Detail__r.Loyalty_Id__c)+((loyaltyHistory.Points_Added__c==null)?0:loyaltyHistory.Points_Added__c);
                                } else{                                 
                                    newPoints=((loyaltyHistory.Points_Added__c==null)?0:loyaltyHistory.Points_Added__c);
                                }
                                LoyaltyladderAddedMap.put(loyaltyHistory.Loyalty_Detail__r.Loyalty_Id__c,newPoints);
                                
                                newPoints = 0;
                                
                                if(LoyaltyladderDeductedMap.get(loyaltyHistory.Loyalty_Detail__r.Loyalty_Id__c)!=null ){
                                    
                                    newPoints= LoyaltyladderDeductedMap.get(loyaltyHistory.Loyalty_Detail__r.Loyalty_Id__c)+((loyaltyHistory.Points_Deducted__c==null)?0:loyaltyHistory.Points_Deducted__c);
                                    
                                } else{
                                    
                                    newPoints = ((loyaltyHistory.Points_Deducted__c==null)?0:loyaltyHistory.Points_Deducted__c);
                                }
    
                                LoyaltyladderDeductedMap.put(loyaltyHistory.Loyalty_Detail__r.Loyalty_Id__c,newPoints);
                        
                    }
                }
                    system.debug('# 3'+LoyaltyPointsAddedMap+'# 4'+LoyaltyPointsDeductedMap);
                    system.debug('# 5'+LoyaltyladderDeductedMap+'# 6'+LoyaltyladderAddedMap);
                    list<Loyalty_Detail__c> udpatedLoyaltyDetails= new list<Loyalty_Detail__c>();
                    
                    for(Loyalty_Detail__c aLoyDetail: [Select l.Total_preferati_points__c, l.Loyalty_Id__c, l.Current_casa_ladder__c From Loyalty_Detail__c l where Loyalty_Id__c =:allLoyaltyIds]){
                        system.debug('I am here - stuck 1?');
                        system.debug('I am here1 - ' + LoyaltyPointsAddedMap.get(aLoyDetail.Loyalty_Id__c));
                        system.debug('I am here2 -' + LoyaltyPointsDeductedMap.get(aLoyDetail.Loyalty_Id__c));
                        system.debug('I am here3-' + aLoyDetail.Total_preferati_points__c);
                        system.debug('I am here4-'+ LoyaltyPointsDeductedMap.get(aLoyDetail.Loyalty_Id__c));
                        aLoyDetail.Total_preferati_points__c = (LoyaltyPointsAddedMap.get(aLoyDetail.Loyalty_Id__c)==null?0:LoyaltyPointsAddedMap.get(aLoyDetail.Loyalty_Id__c)) - (LoyaltyPointsDeductedMap.get(aLoyDetail.Loyalty_Id__c)==null?0:LoyaltyPointsDeductedMap.get(aLoyDetail.Loyalty_Id__c));
                      //  aLoyDetail.Total_preferati_points__c = LoyaltyPointsAddedMap.get(aLoyDetail.Loyalty_Id__c) - LoyaltyPointsDeductedMap.get(aLoyDetail.Loyalty_Id__c) ;
                        system.debug('I am here 1 - ' + LoyaltyPointsAddedMap.get(aLoyDetail.Loyalty_Id__c));

                        aLoyDetail.Current_casa_ladder__c = String.valueOf((LoyaltyladderAddedMap.get(aLoyDetail.Loyalty_Id__c)==null?0:LoyaltyladderAddedMap.get(aLoyDetail.Loyalty_Id__c)) - (LoyaltyladderDeductedMap.get(aLoyDetail.Loyalty_Id__c)==null?0:LoyaltyladderDeductedMap.get(aLoyDetail.Loyalty_Id__c)) );
                        
                        system.debug('I am here 2 - ' + LoyaltyPointsAddedMap.get(aLoyDetail.Loyalty_Id__c));

                        
                        if(aLoyDetail.Total_preferati_points__c<0)
                        {
                            aLoyDetail.Total_preferati_points__c = 0;
                        }
                        system.debug('I am here 21 - ' + LoyaltyPointsAddedMap.get(aLoyDetail.Loyalty_Id__c));

                        if(Integer.valueOf(aLoyDetail.Current_casa_ladder__c)<0)
                        {
                            aLoyDetail.Current_casa_ladder__c = '0';
                        }
                        system.debug('I am here 3 - ' + LoyaltyPointsAddedMap.get(aLoyDetail.Loyalty_Id__c));
                
                        udpatedLoyaltyDetails.add(aLoyDetail);
                    }
                        system.debug('#7'+udpatedLoyaltyDetails);
                    update udpatedLoyaltyDetails;
                    
                
                
                
            } catch(Exception ex){
                system.debug('LodhaReferralDetailsUtilities:updateReferralPointsDetails'+ex.getMessage());
            }
            system.debug('LodhaReferralDetailsUtilities:updateReferralPointsDetails exists');
        
    }
    
    
    @isTest(seeAlldata=false)
    
    private  static void test_insertLeadReferralDetails()
    {   
        //Create test data
        Lead testLead = new Lead();
        testLead.FirstName = 'firstName';
        testLead.LastName ='lastName';
        testLead.Mobile__c = '9191919191';      
        testLead.LeadSource = 'Referral';
        testLead.Country_O__c = 'India';
        testLead.ISD_Code__c ='0091';   
        insert testLead;
        
        //Case 1:
        Boolean case1ReferralStatus = false;
        test.startTest();
            case1ReferralStatus = LodhaReferralDetailsUtilities.insertLeadReferralDetails(testLead.Id, null);            
        test.stopTest();
        
        //Assert:
       // system.assertEquals(case1ReferralStatus, true);         
    }
    
    @istest(seeAlldata=false)
    
    private static void test_updateOppsReferralStatus(){
        //Create test data
        Lead testLead = new Lead();
        testLead.FirstName = 'firstName';
        testLead.LastName ='lastName';
        testLead.Mobile__c = '9191919191';      
        testLead.LeadSource = 'Referral';
        testLead.Country_O__c = 'India';
        testLead.ISD_Code__c ='0091';   
        insert testLead;
        LodhaReferralDetailsUtilities.insertLeadReferralDetails(testLead.Id, null);
        Account acc =new Account(LastName='XYZ', Email_acc__c='xyz@gmail.com',Payment_Made__c = False);
        Insert acc;
        Opportunity[] opps= new Opportunity[]{(new Opportunity (Name='XYZ', Lead_ID__c=testlead.id, AccountID=acc.id,StageName='Closed won',Application_Form__c = true,CRM_form__c = true, LOI_Sent__c= true,Agreement_Signed__c = true,CloseDate=Date.newInstance(2008,02,02),ForecastCategoryName='Best Case',Project_Type__c='Aspirational',LeadSource='Referral'))};            
        Insert opps;
        //Case1: Update Opps stage Status
        //Case 1:
        Boolean case1ReferralStatus = false;
        test.startTest();
            LodhaReferralDetailsUtilities.updateOpportunityReferralDetails(opps);            
        test.stopTest();
        //Assert:
       // system.assertEquals([Select status__c from ReferralDetails__c where Lead__c=:testLead.Id].status__c,'Closed won');
    }
    
    @isTest(seeAlldata=false)
    
    private  static void test_updateReferralPointsDetails()
    {   
        //Create test data
        string referralsNo = '10.0';
        Loyalty_Detail__c testLoyaltyDetails = new Loyalty_Detail__c();
        testLoyaltyDetails.Current_casa_ladder__c = 'Current_Casa_Ladder';
        testLoyaltyDetails.Loyalty_Id__c ='testLoyaltyId';
        testLoyaltyDetails.Number_of_successful_referrals__c = decimal.valueOf(referralsNo);    
        testLoyaltyDetails.Total_number_of_referrals__c = decimal.valueOf(referralsNo);
        testLoyaltyDetails.Total_preferati_points__c = decimal.valueOf('1000');
        
        insert testLoyaltyDetails;
        
        List<Loyalty_Points_History__c> testLoyaltyPointHistoryLst = new List<Loyalty_Points_History__c>();
        
        Loyalty_Points_History__c testLoyaltyPointHistory = new Loyalty_Points_History__c();
        
        testLoyaltyPointHistory.CurrencyIsoCode = 'INR';
        testLoyaltyPointHistory.Loyalty_Detail__c = testLoyaltyDetails.Id;
        testLoyaltyPointHistory.Loyalty_Program_Type__c = 'Preferati';
        testLoyaltyPointHistory.Points_Added__c = decimal.valueOf('1000');
        
        testLoyaltyPointHistoryLst.add(testLoyaltyPointHistory);
        
        testLoyaltyPointHistory = new Loyalty_Points_History__c();
        testLoyaltyPointHistory.CurrencyIsoCode = 'INR';
        testLoyaltyPointHistory.Loyalty_Detail__c = testLoyaltyDetails.Id;
        testLoyaltyPointHistory.Loyalty_Program_Type__c = 'Preferati';
        testLoyaltyPointHistory.Points_Added__c = decimal.valueOf('1000');
        
        testLoyaltyPointHistoryLst.add(testLoyaltyPointHistory);
        
        testLoyaltyPointHistory = new Loyalty_Points_History__c();
        testLoyaltyPointHistory.CurrencyIsoCode = 'INR';
        testLoyaltyPointHistory.Loyalty_Detail__c = testLoyaltyDetails.Id;
        testLoyaltyPointHistory.Loyalty_Program_Type__c = 'Clubcasa';
        testLoyaltyPointHistory.Points_Deducted__c = decimal.valueOf('1000');
        
        testLoyaltyPointHistoryLst.add(testLoyaltyPointHistory);
        
        insert testLoyaltyPointHistory;
        delete testLoyaltyPointHistory;
    
       /* test.startTest();
            case1ReferralStatus = LodhaReferralDetailsUtilities.insertLeadReferralDetails(testLead.Id, null);            
        test.stopTest();
        */
        //Assert:
        //system.assertEquals(case1ReferralStatus, true);      
    
    }
}