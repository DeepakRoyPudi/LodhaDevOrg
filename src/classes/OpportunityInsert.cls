public class OpportunityInsert {

public static void RevenueCalculation(Opportunity[] Opr){     
     
//for (Opportunity Opp:Opr){

/*Update Account Upon Opportunity Stage changes*/
String CHKFLAG = 'No';
IF(Opr[0].StageName == 'Closed Won'){
CHKFLAG = 'Yes';
}

IF(Opr[0].AccountID != null){
Account NAC = [Select Opportunity_Stage__c from Account where ID = : Opr[0].AccountID Limit 1];
NAC.Opportunity_Stage__c = CHKFLAG;
Update NAC;
} 


//}
          
                   
           /* INSERTING OPP-ID IN REFERAL RECORD ENTRY  */
   If(Opr[0].LeadSource == 'Existing Customer') {        
   Referrals__c[] Ref= [Select Opportunity__c from Referrals__c where Referred_Customer__c =:Opr[0].Lead_ID__c Limit 1];
   IF(Ref.size()>0){
   for(Referrals__c CC:Ref){
   CC.Opportunity__c = Opr[0].ID;   
   CC.Opportunity_Stage__c = Opr[0].StageName;      
   Update Ref;
   }   
    } 
   }
   
/* UPDATING REFERRAL RECORD BASED ON CONDITION */
  //INCLUDED THIS BELOW IF CONDITION
 If(Opr[0].LeadSource == 'Existing Customer') {         
Referrals__c[] R= [Select No_of_Gifts__c,Amount_Received__c,Opportunity_Stage__c from Referrals__c where Referral_Name__c =:Opr[0].AccountID ];
  
System.debug('Inside Opr[0].AccountID' +Opr[0].AccountID);
IF(R.Size()> 0 &&  CHKFLAG =='No')
{            
   for(integer K=0;K<R.size();K++){
   System.debug('Inside Opr[0].AccountID' +Opr[0].AccountID); 
   R[K].Eligible__c = True;         
   Update R[K];  
  }  
 }
 else if(R.Size()> 0 && CHKFLAG =='Yes'){
  for(integer K=0;K<R.size();K++){  
   R[K].Eligible__c = False;         
  Update R[K]; 
 } 
}
}

    

  
           
         /* INSERTING PERCENTAGE PAYMENT RECORD FOR CHANNEL PARTNER  */
If(Opr[0].LeadSource == 'Channel Partner' &&  Opr[0].Channel_Partner__c != null) {
Payout_percentage__c[] prrp = [Select Payout_Percentage__c from Payout_percentage__c where Channel_Partner__c =: Opr[0].Channel_Partner__c and (Lead__c =: Opr[0].Lead_ID__c or Opportunity__c =:Opr[0].ID) Limit 1];

IF(prrp.size()>0){
         for(Payout_percentage__c PA:prrp)
         prrp[0].Opportunity__c = Opr[0].ID;
         if(Opr[0].Amount != null){
        prrp[0].Payout_Amount__c = Opr[0].Amount*(prrp[0].Payout_Percentage__c/100);/*(Opportunity__r.Amount)*(Payout_Percentage__c /100)*/
        }
         Update prrp;
         }
       
 If(prrp.size() == 0 && Opr[0].Project_Type__c!=null){ 
 Channel_Partner__c[] CP = [Select Type_of_Channel_Partner__c from Channel_Partner__c where ID =: Opr[0].Channel_Partner__c Limit 1];
 IF(CP.size()> 0){
 Payout_Master__c[] PM = [Select Payout_Percentage__c from Payout_Master__c where Property_type__c =: Opr[0].Project_Type__c and Channel_Partner_Type__c=: CP[0].Type_of_Channel_Partner__c Limit 1];
 IF(PM.size()> 0){
 Payout_percentage__c PP = new  Payout_percentage__c(Opportunity__c=Opr[0].ID,Channel_Partner__c =Opr[0].Channel_Partner__c,Payout_Percentage__c =PM[0].Payout_Percentage__c);
 Insert PP;
 }
 }
 }
IF(Opr[0].StageName == 'Cancelled'&& Opr[0].Leadsource =='Channel Partner' && Opr[0].Channel_Partner__c != null){
   IF(prrp.size()>0){
   for(Payout_percentage__c PPP:prrp)
   PPP.Payout_Percentage__c=0;
   Prrp[0].Payout_Amount__c=0;
   Update prrp;
   }       
  }  
}
           
        

        /*BRINGING LEAD CALL ATTEMPTS TO OPPORTUNITY */
        /*to be written as a separate cclass*/
         if(Opr[0].Lead_ID__c != null){
         
         Call_Attempts__c[] CA= [Select Name from Call_Attempts__c where Lead__c =:Opr[0].Lead_ID__c];
         IF(CA.size()< 1000){
         for(Call_Attempts__c CC:CA)
         CC.Opportunity__c = Opr[0].ID;
        //Update CA; //Commented by Jolly as no updates are required for the Call Attempts at Opportunities. It was causing conflict with the new lead to Opportunity conversion process
         } 
         }    
      //INCLUDED THIS BELOW IF CONDITION 
     If(Opr[0].LeadSource == 'Channel Partner' &&  Opr[0].Channel_Partner__c != null) {           
         Channel_Partner__c[] CP = [Select Name,Total_No_Of_Opportunities__c,Number_Of_Won_Opportunities__c from Channel_Partner__c where ID =: Opr[0].Channel_Partner__c Limit 1];

         IF(CP.size()>0){
         
        // for(Channel_Partner__c AA:CP)
         CP[0].Number_Of_Won_Opportunities__c = [Select Count() from Opportunity where Channel_Partner__c =:Opr[0].Channel_Partner__c and StageName = 'Closed Won'];
         CP[0].Total_No_Of_Opportunities__c = [Select Count() from Opportunity where Channel_Partner__c =:Opr[0].Channel_Partner__c];
         Decimal ConAmount = 0;
         Decimal WonAmount = 0;
         Opportunity[] Op= [Select Amount from Opportunity where Channel_Partner__c =:Opr[0].Channel_Partner__c];
         IF(Op.size()>0){
         for(integer i=0;i<Op.size();i++){
         if(Op[i].Amount != null)          
         ConAmount += Op[i].Amount;}         
         }

         Opportunity[] WOp= [Select Amount from Opportunity where Channel_Partner__c =:Opr[0].Channel_Partner__c and StageName =: 'Closed Won'];
         IF(WOp.size()>0){
         for(integer j=0;j<WOp.size();j++){
         if(WOp[j].Amount != null)          
         WonAmount += WOp[j].Amount;}         
         }
         CP[0].Total_Value_Opportunities__c = ConAmount;
         CP[0].Total_Value_Won_Opportunities__c = WonAmount;
         Update CP[0];
         } 
         }                
      //}
    }
    
static testMethod void OpportunityInsert()
{


Projects__c[] pjts1= new  Projects__c[] 
  {
   new Projects__c(Name='Marine',Budget__c=100000 )
  };
  Insert pjts1;
  
Account[] acc =new Account[]
{
new Account(LastName='XYZ', Email_acc__c='xyz@gmail.com',Payment_Made__c = False)
};
Insert acc;
Channel_Partner__c[] CP=new Channel_Partner__c[]
{
new Channel_Partner__c(Name='Aparnafirms',Type_of_Channel_Partner__c='Domestic',Email__c='xy@hotmail.com')
};
Insert CP;
Payout_percentage__c[] pp=new Payout_percentage__c[]
{
new Payout_percentage__c(Channel_Partner__c=CP[0].id,Payout_Percentage__c=2)
};
Insert pp;
Referrals__c[] ref=new Referrals__c[]
{
new Referrals__c(Referral_Name__c=acc[0].id)
};
Insert ref;
Project_Name__c projectName1=new Project_Name__c();
projectName1.name='Loreal';
insert projectName1;
Opportunity[] opp=new Opportunity[]
{
new Opportunity(Name='XY567',Project_Name__c=projectName1.id, Booking_Date__c=date.parse('01/01/2012'), AccountID=acc[0].id,StageName='Closed won',Application_Form__c = true,CRM_form__c = true, LOI_Sent__c= true,Agreement_Signed__c = true,CloseDate=Date.newInstance(2008,02,02),ForecastCategoryName='Best Case',Project_Type__c='Aspirational',LeadSource='Existing Customer',ReferralName__c=acc[0].id)
};
Insert opp;
Opportunity[] opp1=new Opportunity[]
{
new Opportunity(Name='dgfhj56',Project_Name__c=projectName1.id, Booking_Date__c=date.parse('01/01/2012'), AccountID=acc[0].id,StageName='Closed won',Application_Form__c = true,CRM_form__c = true, LOI_Sent__c= true,Agreement_Signed__c = true,CloseDate=Date.newInstance(2008,02,02),ForecastCategoryName='Best Case',Project_Type__c='Aspirational',LeadSource='Channel Partner',Channel_Partner__c=CP[0].id,Amount=1000000)
};
Insert opp1;
Opportunity[] opp2=new Opportunity[]
{
new Opportunity(Name='sdgf678',Project_Name__c=projectName1.id, Date_Of_Cancellation__c=date.parse('01/01/2012'), AccountID=acc[0].id,StageName='Cancelled',CloseDate=Date.newInstance(2008,02,02),ForecastCategoryName='Best Case',Project_Type__c='Aspirational',LeadSource='Channel Partner',Channel_Partner__c=CP[0].id,Amount=1000000)
};
Insert opp2;
OpportunityInsert.RevenueCalculation(Opp);
}
}