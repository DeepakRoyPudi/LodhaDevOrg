/*
*    Description : StaticVariableUtility is an Apex Class to set the Static Variables to True or False
*                  to control the recursive execution of the Apex Triggers

*    Version            Author                Date                Description
*    1.0                Siddharth(Eternus)    26/08/2014          Initial Draft
*/

public class StaticVariableUtility {

    @testVisible private static Boolean blnInactivateUserForCancelledAccountBeforeInsert = false;
    @testVisible private static Boolean blnInactivateUserForCancelledAccountBeforeUpdate = false;
    
    @testVisible private static Boolean blnCreateLoyaltyDetailsBeforeInsertUpdate = false;
    
    @testVisible private static Boolean blnReferalPercentageUpdateBeforeInsertUpdate = false;
    
    @testVisible private static Boolean blnreferralStatusUpdateBeforeInsertUpdate = false;
    
    @testVisible private static Boolean blnCalculateEDCBeforeInsert = false;
    @testVisible private static Boolean blnCalculateEDCBeforeUpdate = false;
    
    //Returns static variable for InactivateUserForCancelledAccount Before Insert Trigger
    public static Boolean inactivateUserForCancelledAccountBeforeInsertRunOnce(){
    
        if(!blnInactivateUserForCancelledAccountBeforeInsert){
            blnInactivateUserForCancelledAccountBeforeInsert = true;
            return false;
        }
        else{
            return true;
        }
    }
    
    //Returns static variable for InactivateUserForCancelledAccount Before Update Trigger
    public static Boolean inactivateUserForCancelledAccountBeforeUpdateRunOnce(){
    
        if(!blnInactivateUserForCancelledAccountBeforeUpdate){
            blnInactivateUserForCancelledAccountBeforeUpdate = true;
            return false;
        }
        else{
            return true;
        }
    }
    
    //Returns static variable for CreateLoyaltyDetails Before Insert/Update Trigger
    public static Boolean createLoyaltyDetailsBeforeInsertUpdateRunOnce(){
    
        if(!blnCreateLoyaltyDetailsBeforeInsertUpdate){
            blnCreateLoyaltyDetailsBeforeInsertUpdate = true;
            return false;
        }
        else{
            return true;
        }
    }
    
    //Returns static variable for ReferalPercentageUpdate Before Insert/Update Trigger
    public static Boolean referalPercentageUpdateBeforeInsertUpdateRunOnce(){
    
        if(!blnReferalPercentageUpdateBeforeInsertUpdate){
            blnReferalPercentageUpdateBeforeInsertUpdate = true;
            return false;
        }
        else{
            return true;
        }
    }
    
    //Returns static variable for referralStatusUpdate Before Insert/Update Opportunity Trigger
    public static Boolean referralStatusUpdateBeforeInsertUpdateRunOnce(){
    
        if(!blnreferralStatusUpdateBeforeInsertUpdate){
            blnreferralStatusUpdateBeforeInsertUpdate = true;
            return false;
        }
        else{
            return true;
        }
    }
    
    //Returns static variable for CalculateEDC Before Insert Opportunity Trigger
    public static Boolean calculateEDCBeforeInsertRunOnce(){
    
        if(!blnCalculateEDCBeforeInsert){
            blnCalculateEDCBeforeInsert = true;
            return false;
        }
        else{
            return true;
        }
    }
    
    //Returns static variable for CalculateEDC Before Update Opportunity Trigger
    public static Boolean calculateEDCBeforeUpdateRunOnce(){
    
        if(!blnCalculateEDCBeforeUpdate){
            blnCalculateEDCBeforeUpdate = true;
            return false;
        }
        else{
            return true;
        }
    }
}