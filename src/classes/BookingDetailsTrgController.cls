/***********************************************************************************
Name:  BookingDetailsTrgController
Copyright © 2012  Lodha Group
===================================================================================
===================================================================================
Purpose:
-------
Controller class for Trigger developed on Booking_Details__c Object
===================================================================================
===================================================================================
History
-------
VERSION    AUTHOR                DATE             DETAIL              
1.0        CG Dev Team           18/06/2012      INITIAL DEVELOPMENT
************************************************************************************/
public class BookingDetailsTrgController{
    
    public static String NONE='NONE';
    public static String CRB_DAM='CRB + DAM';
    public static String CRB_SCUD='CRB + SCUD';
    public static String CRB_CORPORATE='CRB + Corporate';
    public static String REGISTERED='Registered Customer';
    public static String SALES_GROUP = 'CRB';
    
    public static String CREDIT_TRANSACTION='Credit';
    public static String DEBIT_TRANSACTION='Debit';
     
    public static String POINTS = 'Preferati';
    public static String LADDER = 'Clubcasa';
    
    private static Boolean TriggerExecute=false;
    
    public static Boolean isTriggerExecuted(){
        return TriggerExecute;
    }

    public static void TriggerExecuted(){
        TriggerExecute = true;
    }    
    
    /**************************************************************************************
    Description :  
    **************************************************************************************/
    public void MapBookedAccountAndOpportunity(List<Booking_Details__c> BookingDetailsList){
     try{
        system.Debug('#  -> BookingDetailsTrgController.MapBookedAccountAndOpportunity');
        Set<String> SrcRefFlatCodes = new Set<String>();
        Set<String> CRNSet = new Set<String>();
       
        set<Id> BookingIds = new set<Id>();
       
        for(Booking_Details__c Booking : BookingDetailsList){
                CRNSet.add(Booking.CRN__c);
                CRNSet.add(Booking.Referrer_Booking_Id__c);
                BookingIds.add(Booking.Id);
        }

        Map<String,Booking_Details__c> BookingDetailsMap = getBookingDetailsMap(CRNSet);
        for(Booking_Details__c Booking : BookingDetailsList){
            Booking_Details__c bk = BookingDetailsMap.get(Booking.CRN__c);
            system.Debug('# 1'+bk.Points_Allocated__c +' 2: '+ bk.Points_Revoked__c +' 3:'+bk.Account__r.Status__c);
            if(!bk.Points_Allocated__c || (!bk.Points_Revoked__c && 'Cancelled'.equals(bk.Account__r.Status__c))){
                SrcRefFlatCodes.add(getSrcRefFlatCode(bk));
            }
        }
    if(!SrcRefFlatCodes.isEmpty()){       
            
        Map<String,Double> PaymentRcvdPerCRNMap = getPaidAmountPerCRN(CRNSet);
        Map<String,Consideration_Value_Points__c>  CVPCstStng = getConsiderationValuePoints();
        Map<String,ReferralDetails__c> ReferralDetailsMap = getReferralDetails(SrcRefFlatCodes);
        
        system.debug('@ReferralDetailsMap' + ReferralDetailsMap);
        
        Map<String,Loyalty_Points_History__c> LoyaltyPointsHistoryMap = getLoyaltyPointsHistoryMap(BookingIds);
        
        List<ReferralDetails__c> ReferralDetailToUpdate = new List<ReferralDetails__c>();
        List<Loyalty_Points_History__c> LoyaltyPointsToInsert = new List<Loyalty_Points_History__c>();
        List<Booking_Details__c> BookingDetailsToUpdate = new List<Booking_Details__c>();
        
        List<Project_Name__c> ProjectNameLst = [Select Name, Loyalty_Type__c From Project_Name__c];
        
        Map<String,String> LoyaltyTypeLst = new Map<String,String>();
        
        for(Project_Name__c p : ProjectNameLst){
            LoyaltyTypeLst.put(p.Name.toUpperCase(), p.Loyalty_Type__c);
        }
        
        for(Booking_Details__c Booking : BookingDetailsList){
            Booking = BookingDetailsMap.get(Booking.CRN__c);   
            
            String SrcRefFlatCode =  getSrcRefFlatCode(Booking);  
            String ReferralLoyaltyType = '';
            String ReferrerLoyaltyType = '';
            
            if(Booking.Project__c != NULL && BookingDetailsMap.get(Booking.Referrer_Booking_Id__c).Project__c != NULL)
            {
                ReferralLoyaltyType = LoyaltyTypeLst.get(Booking.Project__c.toUpperCase());
                ReferrerLoyaltyType = LoyaltyTypeLst.get(BookingDetailsMap.get(Booking.Referrer_Booking_Id__c).Project__c.toUpperCase());
            }
            
            system.debug('@SrcRefFlatCode:' + SrcRefFlatCode);       
            ReferralDetails__c RefDet =  ReferralDetailsMap.get(SrcRefFlatCode);
            system.debug('@ReferralDetails:' + RefDet); 
            if(null != RefDet){
                RefDet.Referral_Booked_Account__c = Booking.Account__c;
                ReferralDetailToUpdate.add(RefDet);
            }

         Boolean BookingModified = false;   
         system.Debug('#Point Allocation Starts On : '+Booking.Id);
         if(!'Cancelled'.equals(Booking.Account__r.Status__c)){
            if(!Booking.Points_Allocated__c){
            //Points are not allocated as of now
            system.Debug('#Points are not allocated as of now : '+Booking.Id);
                if(Booking.Account__r.Loyalty_Details__r.Loyalty_Id__c !=  Booking.Referrer_Loyalty_Id__c){
                //Not an Self refferal
                system.Debug('#Not an Self refferal : '+Booking.Id);
                    Booking_Details__c SourceBooking = BookingDetailsMap.get(Booking.Referrer_Booking_Id__c);
                    if(SourceBooking != null){
                        system.Debug('# SourceBooking '+SourceBooking);
                        String SourceProject = '';
                        String RefProject = '';
                        if(SourceBooking.Project__c != NULL)
                        {
                            SourceProject = SourceBooking.Project__c.toUpperCase();
                        }
                        Date SourceAppDate = SourceBooking.Application_Date__c;
                        if(Booking.Project__c != NULL)
                        {
                            RefProject = Booking.Project__c.toUpperCase();
                        }
                        Date RefAppDate = Booking.Application_Date__c;
                        
                        system.Debug('# Source Project :'+SourceProject +' ->  DATE : '+SourceAppDate);
                        system.Debug('# Referrence Project :'+RefProject +' ->  DATE : '+RefAppDate);
                        
                        if(SourceProject != RefProject || SourceAppDate!= RefAppDate){
                        //Project Code and Application Date of Source and Referred are Different
                        system.Debug('#Project Code and Application Date of Source and Referred are Different : '+Booking.Id);
                            
                            Double SourceCV = SourceBooking.Consideration_Value__c;
                            Double RefferedCV = Booking.Consideration_Value__c;
                            
                            Double PaidSourceCV = PaymentRcvdPerCRNMap.get(SourceBooking.CRN__c);
                            Double PaidRefferedCV = PaymentRcvdPerCRNMap.get(Booking.CRN__c);
                            
                            if(SourceCV != null && RefferedCV !=null && PaidSourceCV !=null && PaidRefferedCV != null){
                                if(PaidSourceCV >= (SourceCV*0.099) && PaidRefferedCV >= (RefferedCV*0.099)){
                                //Payemnt made more than 9.9%
                                system.Debug('#Payemnt made more than 9.9% : '+Booking.Id);
                                    Double point = 0;
                                    
                                    system.Debug('#ReferralLoyalty Type : '+ ReferralLoyaltyType);
                                    system.Debug('#ReferrerLoyalty Type : '+ ReferrerLoyaltyType);
                                    if(LADDER.equals(ReferralLoyaltyType) && LADDER.equals(ReferrerLoyaltyType)){
                                        point = 1;
                                        ReferralLoyaltyType = LADDER;
                                    }else if((POINTS.equals(ReferralLoyaltyType) && LADDER.equals(ReferrerLoyaltyType)) || (LADDER.equals(ReferralLoyaltyType) && POINTS.equals(ReferrerLoyaltyType)) || (POINTS.equals(ReferralLoyaltyType) && POINTS.equals(ReferrerLoyaltyType)) ){
                                        point = getLoyaltyPoint(Booking.Consideration_Value__c, CVPCstStng);
                                        ReferralLoyaltyType = POINTS;
                                    }
                                    
                                    if((NONE.equals(Booking.Customer_Group__c) || CRB_DAM.equals(Booking.Customer_Group__c) || CRB_SCUD.equals(Booking.Customer_Group__c)) && SALES_GROUP.equals(Booking.Sales_Group__C)){
                                        //Both Source and Referred gets the Loyalty Points
                                        system.Debug('# Both Source and Referred gets the Loyalty Points'+Booking.Id);
                                    
                                        Loyalty_Points_History__c RefPoint = AllocatePoints(Booking.Account__r.Id,
                                                                                            Booking.Account__r.Loyalty_Details__r.Id,
                                                                                            Booking.Id,
                                                                                            ReferralLoyaltyType,
                                                                                            point);
                                        if(RefPoint != null){
                                            LoyaltyPointsToInsert.add(RefPoint);
                                            Booking.Trigger_Date__c=system.now();
                                            Booking.Points_Allocated__c=true;
                                            
                                            if(ReferralLoyaltyType == NULL)
                                                Booking.Trigger_Msg__c = 'Referral Loyalty Type is Empty';
                                            else if(ReferrerLoyaltyType == NULL)
                                                Booking.Trigger_Msg__c = 'Referrer Loyalty Type is Empty';
                                            else if(Booking.Project__c == NULL)
                                                Booking.Trigger_Msg__c = 'Referral Project is Empty';
                                            else if(BookingDetailsMap.get(Booking.Referrer_Booking_Id__c).Project__c == NULL)
                                                Booking.Trigger_Msg__c = 'Referrer Project is Empty';
                                            else    
                                                Booking.Trigger_Msg__c = ReferralLoyaltyType +' Allocated';
                                            
                                            BookingModified = true;                                         
                                        } 
                                        
                                        
                                        Loyalty_Points_History__c SrcPoint = AllocatePoints(SourceBooking.Account__r.Id,
                                                                                            SourceBooking.Account__r.Loyalty_Details__r.Id,
                                                                                            Booking.Id,
                                                                                            ReferralLoyaltyType,
                                                                                            point);
                                        if(SrcPoint != null){
                                            LoyaltyPointsToInsert.add(SrcPoint);
                                        }                                                                                                                                                                                       
                                    }else if(CRB_CORPORATE.equals(Booking.Customer_Group__c) && SALES_GROUP.equals(Booking.Sales_Group__C)){
                                        //Only Source gets the Loyalty Points
                                        system.Debug('# Only Source gets the Loyalty Points'+Booking.Id);

                                        Loyalty_Points_History__c SrcPoint = AllocatePoints(SourceBooking.Account__r.Id,
                                                                                            SourceBooking.Account__r.Loyalty_Details__r.Id,
                                                                                            Booking.Id,
                                                                                            ReferralLoyaltyType,
                                                                                            point);
                                        if(SrcPoint != null){
                                            LoyaltyPointsToInsert.add(SrcPoint);
                                            Booking.Trigger_Date__c=system.now();
                                            Booking.Trigger_Msg__c=CRB_CORPORATE + ' : Only source gets the points';
                                            Booking.Points_Allocated__c=true;
                                            BookingModified = true;       
                                        }                                                                                                                                   
                                    }else if(REGISTERED.equals(Booking.Customer_Group__c)){
                                    //No One get the Loyslty Points
                                    system.Debug('# No One get the Loyslty Points : REGISTERED :'+Booking.Id);
                                        Booking.Trigger_Date__c=system.now();
                                        Booking.Trigger_Msg__c=REGISTERED+ ' : No One get the Loyalty Points';
                                        BookingModified = true;                                         
                                    }
                                    else {
                                        Booking.Trigger_Date__c=system.now();
                                        Booking.Trigger_Msg__c= Booking.Customer_Group__c + '  ' +  Booking.Sales_Group__c +'Invalid Customer Grp Sales Grp Combo: No One get the Loyalty Points';
                                        BookingModified = true;            
                                    }
                                }else{
                                //Enough Payment is not made 9.9%
                                system.Debug('# Enough Payment is not made 9.9%'+Booking.Id);
                                    Booking.Trigger_Date__c=system.now();
                                    Booking.Trigger_Msg__c='Enough Payment is not made 9.9% check 1';
                                    BookingModified = true;                                                                                         
                                }
                            }else{
                            //Enough Payment is not made 9.9%
                            system.Debug('# Enough Payment is not made 9.9%'+Booking.Id);
                                Booking.Trigger_Date__c=system.now();
                                Booking.Trigger_Msg__c='Enough Payment is not made 9.9% check 2';
                                BookingModified = true;                         
                            }
                        }else{
                        //Project Code and Application Date of Source and Referred are Same
                        system.Debug('# Project Code and Application Date of Source and Referred are Same : '+Booking.Id);
                            Booking.Trigger_Date__c=system.now();
                            Booking.Trigger_Msg__c='Project Code and Application Date of Source and Referred are Same';
                            BookingModified = true;
                        }
                    }else{
                    //Invalid Source Referral Booking Id
                    system.Debug('# Invalid Source Referral Booking Id'+Booking.Id);
                        Booking.Trigger_Date__c=system.now();
                        Booking.Trigger_Msg__c='Booking Id of the Referrer is Invalid';
                        BookingModified = true; 
                    }
                }else{
                //Self refferel
                system.Debug('# Self refferel'+Booking.Id);
                    Booking.Trigger_Date__c=system.now();
                    Booking.Trigger_Msg__c='Self Refferal';
                    BookingModified = true;
                }
            }
         }else{
         //Cancelling Points
         system.Debug('# Cancelling Points : '+Booking.Id);
                Booking_Details__c SourceBooking = BookingDetailsMap.get(Booking.Referrer_Booking_Id__c);
                system.Debug('# SourceBooking '+SourceBooking);
                if(SourceBooking != null){
                                    
                        if(!Booking.Points_Revoked__c){
                            // String SourceKey = String.valueOf(RefDet.Id) + String.valueOf(SourceBooking.Account__r.Id);
                            String SourceKey = String.valueOf(Booking.Id) + String.valueOf(SourceBooking.Account__r.Id);
                            system.Debug('# SourceKey '+SourceKey);
                            Loyalty_Points_History__c SourceHistory = LoyaltyPointsHistoryMap.get(SourceKey);
                            system.Debug('# SourceHistory '+SourceHistory);
                            if(SourceHistory!=null){
                                        
                                Loyalty_Points_History__c SrcPoint = RevokePoints(SourceBooking.Account__r.Id,
                                                                            SourceBooking.Account__r.Loyalty_Details__r.Id,
                                                                            Booking.Id,
                                                                            ReferralLoyaltyType,
                                                                            SourceHistory.Points_Added__c);
                                                                            
                                if(SrcPoint != null){
                                    LoyaltyPointsToInsert.add(SrcPoint);
                                    Booking.Trigger_Date__c=system.now();
                                    Booking.Points_Revoked__c=true;
                                    Booking.Trigger_Msg__c = ReferralLoyaltyType +' Revoked';
                                    BookingModified = true;                                
                                }               
                            }
                                                 
                            // String RefKey = String.valueOf(RefDet.Id) + String.valueOf(Booking.Account__r.Id);
                            String RefKey = String.valueOf(Booking.Id) + String.valueOf(Booking.Account__r.Id);
                            system.Debug('# RefKey '+RefKey);
                            Loyalty_Points_History__c RefHistory = LoyaltyPointsHistoryMap.get(RefKey);
                            system.Debug('# RefHistory '+RefHistory);
                            if(RefHistory != null){

                                Loyalty_Points_History__c RefPoint = RevokePoints(Booking.Account__r.Id,
                                                                            Booking.Account__r.Loyalty_Details__r.Id,
                                                                            Booking.Id,
                                                                            ReferralLoyaltyType,
                                                                            RefHistory.Points_Added__c);
                                                                            
                                if(RefPoint != null){
                                    LoyaltyPointsToInsert.add(RefPoint);
                                    Booking.Trigger_Date__c=system.now();
                                    Booking.Points_Revoked__c=true;
                                    Booking.Trigger_Msg__c = ReferralLoyaltyType +' Revoked';
                                    BookingModified = true; 
                                }           
                     }
                }
            }               
         }   
         if(BookingModified){
            BookingDetailsToUpdate.add(Booking);
         }
           // system.Debug('#Points Allocated : '+LytPoint);
        }
        
        if(!ReferralDetailToUpdate.isEmpty()){
            Update ReferralDetailToUpdate;
        }
        if(!LoyaltyPointsToInsert.isEmpty()){
            Insert LoyaltyPointsToInsert;
        }
        if(!BookingDetailsToUpdate.isEmpty()){
            Update  BookingDetailsToUpdate;
        }
     }//-----------
              
      }catch(Exception e){
        system.Debug('#Exception In MapBookedAccountAndOpportunity : '+e);
      }
        system.Debug('#  <- BookingDetailsTrgController.MapBookedAccountAndOpportunity');   
    }
    
    
    /*****************************************************************************
    Description :
    /****************************************************************************/
    private String getSrcRefFlatCode(Booking_Details__c Booking){
        system.Debug('#  -) BookingDetailsTrgController.getSrcRefFlatCode');
        system.Debug('# Booking.Account__c : '+Booking.Account__c);
        system.Debug('# Booking.Account__r.Loyalty_Details__r : '+Booking.Account__r.Loyalty_Details__c);
        string srcRefFlatCode = '';
        string wingNo = '';
        string flatNo = '';
        
        if(Booking.Account__r.Loyalty_Details__r.Loyalty_Id__c != NULL)
            srcRefFlatCode = Booking.Account__r.Loyalty_Details__r.Loyalty_Id__c.toUpperCase();
        if(Booking.Referrer_Loyalty_Id__c != NULL)
            srcRefFlatCode = srcRefFlatCode + Booking.Referrer_Loyalty_Id__c.toUpperCase();
        if(Booking.Project__c != NULL)
            srcRefFlatCode = srcRefFlatCode + Booking.Project__c.toUpperCase();
        if(Booking.Cluster__c != NULL)
            srcRefFlatCode = srcRefFlatCode + Booking.Cluster__c.toUpperCase();
        if(Booking.Wing__c != NULL)
        {  
            if(Booking.Wing__c.toUpperCase() != 'OTHERS' )
            {
                wingNo = Booking.Wing__c.toUpperCase().replace('WING', '').trim();
                srcRefFlatCode = srcRefFlatCode + wingNo;
            }
        }
        if(Booking.Flat_No__c != NULL)
        {
           string[] temp = Booking.Flat_No__c.split(' ');
           if(temp.size() <= 1)
           {
               temp = Booking.Flat_No__c.split('-');
           }
           if(temp.size() > 1)
           {
               flatNo = temp[1];
               srcRefFlatCode = srcRefFlatCode + flatNo;
           }
        }
        
            return srcRefFlatCode;
    } 
    
    /*****************************************************************************
    Description : This class to used for updating Source Loyalty Id and unique values.. 
    /****************************************************************************/
    public  list<Opportunity> createSrcRefFlatCode(list<Opportunity>  opps){
        
        list<Opportunity> updatedOpps  = new list<Opportunity>();
       // Map<Id, string> ProjectIdMaps= new Map<Id, string>();     Removed Date: 25/01/2013
       // Set<Id> setProjcId= new Set<Id>();                        Removed Date: 25/01/2013
       // set<Id> leadIds = new set<Id>();                          Removed Date: 25/01/2013
       // set<Id> opptyIds = new set<Id>();                         Removed Date: 25/01/2013
        set<String> opptyLoyaltySet = new set<String>();
       // Map<Id, string> loyaltyIdLeadMaps= new Map<Id, string>();     Removed Date: 25/01/2013
       // Map<Id, string> loyaltyIdOpptyMaps= new Map<Id, string>();    Removed Date: 25/01/2013
        set<string> oppMobileNo= new set<string>();
        List<ReferralDetails__c> insertreferralDetailsLst = new List<ReferralDetails__c>();
        Map<Id, ReferralDetails__c> upsertReferralDetailsMap = new Map<Id, ReferralDetails__c>();
        Boolean referralExists = false;
        
        if(!Test.isRunningTest()){
        for(Opportunity aOpp: opps){
           // setProjcId.add(aOpp.Project_Name__c);     Removed Date: 25/01/2013
           // leadIds.add(aOpp.Lead_ID__c);             Removed Date: 25/01/2013
           // opptyIds.add(aOpp.Id);                    Removed Date: 25/01/2013
            opptyLoyaltySet.add(aOpp.LoyaltySourceId__c);
            oppMobileNo.add(aOpp.Mobile_no__c);
    
        }
        
        /*      Removed Date: 25/01/2013
        for(ReferralDetails__c aReferral:[Select id,Lead__c, Opportunity__c , Loyalty_Detail__r.Loyalty_Id__c from ReferralDetails__c where Lead__c=:leadIds or Opportunity__c=:opptyIds]) {
                
                loyaltyIdLeadMaps.put(aReferral.Lead__c,aReferral.Loyalty_Detail__r.Loyalty_Id__c);
                loyaltyIdOpptyMaps.put(aReferral.Opportunity__c,aReferral.Loyalty_Detail__r.Loyalty_Id__c);
        }
        */
        
        //Get the referral details for the referrals provided in the oppty based on mobile number
        
        List<ReferralDetails__c> ref = [Select id,Lead__r.Mobile__c, Lead__r.Project_Name__c, Opportunity__r.Mobile_no__c, Opportunity__r.Project_Name__c, Opportunity__c, Lead__c, Loyalty_Detail__c, Loyalty_Detail__r.Loyalty_Id__c, LastModifieddate From ReferralDetails__c Where Lead__r.Mobile__c =: oppMobileNo OR Opportunity__r.Mobile_no__c =:oppMobileNo];
        Map<String, ReferralDetails__c>  ReferralDetailsMap = new Map<String, ReferralDetails__c>();
        for(ReferralDetails__c rd: ref)
        {
            if(rd.Lead__r.Mobile__c != NULL && rd.Lead__r.Project_Name__c != NULL)
            {
                ReferralDetailsMap.put(rd.Lead__r.Mobile__c+rd.Lead__r.Project_Name__c, rd);
            }
            else{
                ReferralDetailsMap.put(rd.Opportunity__r.Mobile_no__c+rd.Opportunity__r.Project_Name__c, rd);
            }
        }
        /*  Removed Date: 25/01/2013
        if(setProjcId!=null){           
            for(Project_Name__c aProject:  [Select Id, Name From Project_Name__c where Id in:setProjcId]){
                ProjectIdMaps.put(aProject.Id,aProject.Name);
            }
        }
        */
        
        //get loyalty details for the loyalty ids provided in the oppty
        Map<String, Loyalty_Detail__C> loyaltyDetailMap = new Map<String,Loyalty_Detail__C>();
        for(Loyalty_Detail__c ld :[select Loyalty_Id__c,Id  from Loyalty_Detail__c where Loyalty_Id__c  = :opptyLoyaltySet])
        {
            loyaltyDetailMap.put(ld.Loyalty_Id__c,ld);
        }
        
        for(Opportunity aOpp: opps){

            if(ref.size() != 0) {
                referralExists = false;
                //check if referral and matches what the customer provides
                // if yes link oppty to referral
                // else delink oppty from referral
                String ReferralKeyField = aOpp.Mobile_no__c + aOpp.Project_Name__c;
                
                if(ReferralDetailsMap.containsKey(ReferralKeyField))
                {
                     // checking if the loyalty ids match 
                    if(ReferralDetailsMap.get(ReferralKeyField).Loyalty_Detail__r.Loyalty_Id__c != aOpp.LoyaltySourceId__c)
                    {
                        ReferralDetailsMap.get(ReferralKeyField).Opportunity__c = null;
                        System.debug('Invalidating Referral ' + ReferralDetailsMap.get(ReferralKeyField).Loyalty_Detail__r.Loyalty_Id__c);
                    }
                    else
                    {                                 
                         // flag indicates if referral exist as what the customer says
                        referralExists = true;
                        if(aOpp.StageName == 'Closed Won' || aOpp.StageName == 'Closed Book')
                        {
                            ReferralDetailsMap.get(ReferralKeyField).Status__c = 'Booked';
                        }
                        else
                        {
                            ReferralDetailsMap.get(ReferralKeyField).Status__c = 'Under Process';
                        }
                        ReferralDetailsMap.get(ReferralKeyField).Opportunity__c = aOpp.Id;
                        System.debug('Linking Referral ' + ReferralDetailsMap.get(ReferralKeyField).Loyalty_Detail__r.Loyalty_Id__c);
                    }
                    upsertReferralDetailsMap.put(ReferralDetailsMap.get(ReferralKeyField).Id, ReferralDetailsMap.get(ReferralKeyField));
                    System.debug('upsertReferralDetailsMap-->' + upsertReferralDetailsMap);
                }

             }

             if(aOpp.LoyaltySourceId__c != null && !referralExists) {
                    // if no referral exists for that oppty create a new referral 
                    // link it with loyalty detail record
                        if(loyaltyDetailMap.containsKey(aOpp.LoyaltySourceId__c)){
                            ReferralDetails__c r = new ReferralDetails__c();
                            r.Loyalty_Detail__c = loyaltyDetailMap.get(aOpp.LoyaltySourceId__c).Id;
                            r.Opportunity__c = aOpp.Id;
                            if(aOpp.StageName == 'Closed Won' || aOpp.StageName == 'Closed Book')
                            {
                                r.Status__c = 'Booked';
                            }
                            else
                            {
                                r.Status__c = 'Under Process';
                            }
                            insertreferralDetailsLst.add(r);
                            System.debug('creating referral for loyalty id '+ aOpp.LoyaltySourceId__c);
                        }
                        else {
                            System.debug('Cannot create referral as the loyalty details doesnt exist ' + aOpp.LoyaltySourceId__c);
                        }
             }
             aOpp.Source_referral_flat_code__c = '';
             if(aOpp.LoyaltyID__c != NULL)
                 aOpp.Source_referral_flat_code__c =  aOpp.LoyaltyID__c.toUpperCase();
             if(aOpp.LoyaltySourceId__c != NULL)
                 aOpp.Source_referral_flat_code__c = aOpp.Source_referral_flat_code__c + aOpp.LoyaltySourceId__c.toUpperCase();
             if(aOpp.Oasys_Flat_Code__c != NULL)
                 aOpp.Source_referral_flat_code__c = aOpp.Source_referral_flat_code__c + aOpp.Oasys_Flat_Code__c.toUpperCase();


             updatedOpps.add(aOpp);
         }
         system.debug('Map-->'+upsertReferralDetailsMap.values());
         upsert upsertReferralDetailsMap.values();
         
         insert insertreferralDetailsLst;
         }
         return updatedOpps;
   }
    
    /*****************************************************************************
    Description :
    /****************************************************************************/
    private Loyalty_Points_History__c AllocatePoints(Id BookedAccountId,
                                                       Id LoyaltyDetailsId,
                                                       Id ReferenceDetailId,
                                                       String ProgramType,
                                                       Double Point){
                                                            
          return  CreateLoyaltyPoints(BookedAccountId,
                                      LoyaltyDetailsId,
                                      ReferenceDetailId,
                                      ProgramType,
                                      Point,
                                      'Credit');                                                
    }

    /*****************************************************************************
    Description :
    /****************************************************************************/
    private Loyalty_Points_History__c RevokePoints(Id BookedAccountId,
                                                       Id LoyaltyDetailsId,
                                                       Id ReferenceDetailId,
                                                       String ProgramType,
                                                       Decimal Point){
                                                            
          return  CreateLoyaltyPoints(BookedAccountId,
                                      LoyaltyDetailsId,
                                      ReferenceDetailId,
                                      ProgramType,
                                      Double.valueOf(Point),
                                      'Debit');                                             
    }
    /*****************************************************************************
    Description :
    /****************************************************************************/
    private Loyalty_Points_History__c CreateLoyaltyPoints(
                                                        Id BookedAccountId,
                                                        Id LoyaltyDetailsId,
                                                        Id ReferenceDetailId,                                                        
                                                        String ProgramType,
                                                        Double Point,
                                                        String TransactionType ){
        Loyalty_Points_History__c LoyaltyPoint = new Loyalty_Points_History__c();
        LoyaltyPoint.Account__c = BookedAccountId;
        LoyaltyPoint.Booking_Details__c = ReferenceDetailId;
        LoyaltyPoint.Loyalty_Detail__c = LoyaltyDetailsId;
        LoyaltyPoint.Loyalty_Program_Type__c =ProgramType;
        if('Credit'.equals(TransactionType)){
            LoyaltyPoint.Points_Added__c=Point;
        }else{
            LoyaltyPoint.Points_Deducted__c=Point;
        }
        return LoyaltyPoint;
    } 

    /*****************************************************************************
    Description : 
    /****************************************************************************/    
    private Map<String,ReferralDetails__c> getReferralDetails(Set<String> SrcRefFlatCodes){
        system.Debug('#  -> BookingDetailsTrgController.getReferralDetails');
        system.Debug('# SrcRefFlatCodes : '+SrcRefFlatCodes);
        Map<String,ReferralDetails__c> ReferralDetailsMap = new Map<String,ReferralDetails__c>();
        try{
            List<ReferralDetails__c> ReferralDetailsList = [Select r.Status__c, r.Referral_Booked_Account__c,
                                                            r.Opportunity__r.Source_referral_flat_code__c, 
                                                            r.Opportunity__r.Project_Name__r.Loyalty_Type__c,  
                                                            r.Opportunity__c, r.Id, r.Booked_Account__c From ReferralDetails__c r 
                                                            Where r.Opportunity__r.Source_referral_flat_code__c IN:SrcRefFlatCodes];
                                                    
            for(ReferralDetails__c RefDt : ReferralDetailsList){
                ReferralDetailsMap.put(RefDt.Opportunity__r.Source_referral_flat_code__c, RefDt);
            }   
        }catch(Exception e){
            system.Debug('#Exception '+e);  
        }                                           
        system.Debug('#  <- BookingDetailsTrgController.getReferralDetails');
        return ReferralDetailsMap;  
    
    }
    
   /****************************************************************************************************************
   Description : 
   /***************************************************************************************************************/
    private Map<String,Double> getPaidAmountPerCRN(Set<String> CRNset){
        system.Debug('#  -> BookingDetailsTrgController.getPaidAmountPerCRN');
        Map<String,Double> DemadDetailsMap = new Map<String,Double>();
        try{
          if(!CRNset.isEmpty()){
            List<SObject> DemandPerAcc = [Select d.Flat_ID__r.CRN__c CRN, 
                                       Sum(d.Amount_received__c) PaidAmount 
                                       From Demands__c d 
                                       Where d.Flat_ID__r.CRN__c IN:CRNset 
                                       Group By  d.Flat_ID__r.CRN__c]; 
            for(sObject Demand : DemandPerAcc){
                String CRN = string.valueOf(Demand.get('CRN'));
                Double PaidAmount = Double.valueOf(Demand.get('PaidAmount'));
                DemadDetailsMap.put(CRN,PaidAmount);
            }                   
          }                
        }catch(Exception e){
            system.Debug('#Exception : '+e);
        }
        system.Debug('#  <- BookingDetailsTrgController.getPaidAmountPerCRN');
        return DemadDetailsMap;
    }

   /****************************************************************************************************************
   Description : 
   /***************************************************************************************************************/            
   private Map<String,Consideration_Value_Points__c> getConsiderationValuePoints(){
    system.Debug('#  -> BookingDetailsTrgController.getConsiderationValuePoints');
    Map<String,Consideration_Value_Points__c> CVPmap = new Map<String,Consideration_Value_Points__c>(); 
    try{
        for(Consideration_Value_Points__c CVP:Consideration_Value_Points__c.getAll().values()){
            if(CVP.Active__c){
                CVPmap.put(CVP.Name,CVP);
            }
        }
    }catch(Exception e){
        system.Debug('#Exception '+e);  
    }
    system.Debug('#  <- BookingDetailsTrgController.getConsiderationValuePoints');
    return CVPmap;
   }   
   
   /****************************************************************************************************************
   Description : 
   /***************************************************************************************************************/       
   private Double  getLoyaltyPoint(Decimal ConsiderationValue,Map<String,Consideration_Value_Points__c>  CVPCstStng){
    system.Debug('#  -> BookingDetailsTrgController.getCVPoint');
        Double Point = 0;
        try{
            if(ConsiderationValue != null){
                Double OneCrore = 10000000;
                ConsiderationValue = ConsiderationValue / OneCrore;
                for(Consideration_Value_Points__c CVP : CVPCstStng.values()){
                    system.Debug('# ConsiderationValue : '+ConsiderationValue +' : CVP.CV_From__c = '+CVP.CV_From__c +' CVP.CV_To__c = '+CVP.CV_To__c);
                    if(CVP.CV_From__c <= ConsiderationValue && CVP.CV_To__c > ConsiderationValue){
                        Point=CVP.Credits__c;
                        system.Debug('# ---> ConsiderationValue : '+ConsiderationValue +' : CVP.CV_From__c = '+CVP.CV_From__c +' CVP.CV_To__c = '+CVP.CV_To__c);
                        break;
                    }
                }   
            }   
        }catch(Exception e){
            system.Debug('#Exception '+e);      
        }
        system.Debug('#  <- BookingDetailsTrgController.getCVPoint');               
        return Point;
   }
   
   /****************************************************************************************************************
   Description : 
   /***************************************************************************************************************/
   private Map<String,Booking_Details__c> getBookingDetailsMap(Set<String> CRNset){
        system.Debug('#  -> BookingDetailsTrgController.getBookingDetailsMap');
        Map<String,Booking_Details__c> BookingDetailsMap = new Map<String,Booking_Details__c>();
        try{
            if(!CRNset.isEmpty()){
                List<Booking_Details__c> BookingDetailsList = [Select b.CRN__c, b.Account__r.Loyalty_Details__c, b.Account__r.Status__c, 
                                                             b.Account__r.Loyalty_Details__r.Loyalty_Id__c, b.Points_Allocated__c,
                                                             b.Points_Revoked__c, b.Customer_Group__c,b.Sales_Group__c, b.Referrer_Booking_Id__c,
                                                             b.Referrer_Loyalty_Id__c,b.Wing__c, b.Flat_No__c, b.Application_Date__c,
                                                             b.Consideration_Value__c, b.Account__r.Id, b.Account__c, b.Project__c, 
                                                             b.Account__r.Loyalty_Details__r.Id, Cluster__c  
                                                             From Booking_Details__c b Where b.CRN__c IN:CRNset];
                for(Booking_Details__c BkD : BookingDetailsList){
                    BookingDetailsMap.put(BkD.CRN__c, BkD);
                }                                                              
            }
        }catch(Exception e){
            system.Debug('#Exception '+e);
        }
        system.Debug('#  <- BookingDetailsTrgController.getBookingDetailsMap');
        return BookingDetailsMap;
   } 
   
   /****************************************************************************************************************
   Description : 
   /***************************************************************************************************************/   
   
   private Map<String,Loyalty_Points_History__c> getLoyaltyPointsHistoryMap(set<Id> BookingDetailsIds){
    system.Debug('#  -> BookingDetailsTrgController.getLoyaltyPointsHistoryMap');
    Map<String,Loyalty_Points_History__c> LoyaltyPointsHistoryMap = new Map<String,Loyalty_Points_History__c>();
    try{
        List<Loyalty_Points_History__c> LoyaltyPointsHistoryList = [Select l.Booking_Details__r.Id, l.Referral_Details__r.Id, l.Account__r.Id, l.Points_Deducted__c, l.Points_Added__c, 
                                                                    l.Loyalty_Program_Type__c, l.Account__c 
                                                                    From Loyalty_Points_History__c l Where l.Booking_Details__c IN:BookingDetailsIds];
        for(Loyalty_Points_History__c lph : LoyaltyPointsHistoryList){
            String Key = String.valueOf(lph.Booking_Details__r.Id) + String.valueOf(lph.Account__r.Id);
            LoyaltyPointsHistoryMap.put(Key,lph);
        }                                                                   
    }catch(Exception e){
        system.Debug('#Exception '+e);
    }
    system.Debug('#  <- BookingDetailsTrgController.getLoyaltyPointsHistoryMap');
    return LoyaltyPointsHistoryMap;
   }
   
   
   /*
       ****************************************** Test Method *************************************************
   */
   
   @istest(seeAlldata=false)
   private static void testBookingDetailsTrgController() {
        id RTId = [Select id from RecordType where Name = 'Booked Account'].id;
        Account referrerAccount = new Account(FirstName = 'testFirstaccReferrer',
                            LastNAme = 'testFirstaccReferrer',
                            Recordtypeid = RTId,
                            Status__c = 'Created',
                            PersonMobilePhone = '9234567888',
                            PersonEmail = 'referrertest@test.com',
                            CRN__c = '898890',
                            LoyaltyID__c = 'Lyl124',
                            Personal_Email__pc = 'referrertest@test.com'
                            );
        insert referrerAccount;
        
        Booking_Details__c referrerDetails = new Booking_Details__c(
            Account__c = referrerAccount.id,
            CRN__c = '898890',
            Flat_ID__c = 'testBookingDetailsTrgController123');
        insert referrerDetails;
        
        Demands__c referrerDemands = new Demands__c(Flat_ID__c = referrerDetails.Id, ExternalID__c='01pL00000008dem');
        insert referrerDemands;
        
        Account referralAccount = new Account(FirstName = 'testFirstaccreferral',
                            LastNAme = 'testFirstaccreferral',
                            Recordtypeid = RTId,
                            Status__c = 'Created',
                            PersonMobilePhone = '9234567777',
                            PersonEmail = 'referraltest@test.com',
                            CRN__c = '898891',
                            LoyaltyID__c = 'Lyl123',
                            Personal_Email__pc = 'referraltest@test.com'
                            );
        insert referralAccount;
        Booking_Details__c referralDetails = new Booking_Details__c(
            Account__c = referralAccount.id,
            CRN__c = '898891',
            Referrer_Loyalty_Id__c = 'Lyl124',
            Referrer_Booking_Id__c = '898890',
            Flat_ID__c = 'testBookingDetailsTrgController123');
        insert referralDetails;
        
        Demands__c referralDemands = new Demands__c(Flat_ID__c = referralDetails.Id, ExternalID__c='01pL00000009dem');
        insert referralDemands;
    }

}