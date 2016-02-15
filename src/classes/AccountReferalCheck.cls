public class AccountReferalCheck {

    public static void PercentageReceived(Account[] ACC){     
     
       //for (Account A:ACC){

        /*Update Referal Object when Payment is received */
        
   try{ // Added by CG on 03/12/2012 
       IF(ACC[0].ID != null){
       Opportunity[] Op = [Select AccountID,Lead_ID__c from Opportunity where AccountID =: ACC[0].ID Limit 1];
       IF(Op.Size() > 0){
       Referrals__c[] Ref= [Select No_of_Gifts__c,Amount_Received__c,Opportunity_Stage__c from Referrals__c where Referred_Customer__c =:Op[0].Lead_ID__c Limit 1];
       
       IF(Ref.size()>0){
       if(ACC[0].Payment_Made__c == True){         
             Ref[0].Amount_Received__c = True;
             Ref[0].No_of_Gifts__c = 1;
             Ref[0].Gifts_to_be_redeemed__c = Ref[0].No_of_Gifts__c;            
          }    
         else
         {             
             Ref[0].Amount_Received__c = False;
             Ref[0].No_of_Gifts__c = 0;
             Ref[0].Gifts_to_be_redeemed__c = Ref[0].No_of_Gifts__c;         
           }
           Update Ref; 
         }
         }                   
        }
     }catch (Exception e){}
 //  }
 }

Testmethod static void AccountReferalCheck()
{
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
ref=[select  Amount_Received__c,No_of_Gifts__c,Gifts_to_be_redeemed__c from  Referrals__c where id=:ref[0].id];
if(acc[0].Payment_Made__c == True){         
         ref[0].Amount_Received__c = True;
         ref[0].No_of_Gifts__c = 1;
         ref[0].Gifts_to_be_redeemed__c = ref[0].No_of_Gifts__c;            
         update ref;
      }    

Project_Name__c projectName1=new Project_Name__c();
projectName1.name='Loreal';
insert projectName1;

Opportunity[] opp=new Opportunity[]
{
new Opportunity(Name='XYZ123',Project_Name__c = projectName1.id, Booking_Date__c=date.parse('01/01/2012'), AccountID=acc[0].id,StageName='Closed won',Application_Form__c = true,CRM_form__c = true, LOI_Sent__c= true,Agreement_Signed__c = true,CloseDate=Date.newInstance(2008,02,02),ForecastCategoryName='Best Case',Project_Type__c='Aspirational',LeadSource='Existing Customer',ReferralName__c=acc[0].id)
};
Insert opp;
Opportunity[] opp1=new Opportunity[]
{
new Opportunity(Name='XYZ124', Project_Name__c = projectName1.id,Booking_Date__c=date.parse('01/01/2012'), AccountID=acc[0].id,StageName='Closed won',Application_Form__c = true,CRM_form__c = true, LOI_Sent__c= true,Agreement_Signed__c = true,CloseDate=Date.newInstance(2008,02,02),ForecastCategoryName='Best Case',Project_Type__c='Aspirational',LeadSource='Channel Partner',Channel_Partner__c=CP[0].id,Amount=1000000)
};
Insert opp1;
Opportunity[] opp2=new Opportunity[]
{
new Opportunity(Name='XYZ156',Project_Name__c = projectName1.id, Date_Of_Cancellation__c=date.parse('01/01/2012'), AccountID=acc[0].id,StageName='Cancelled',CloseDate=Date.newInstance(2008,02,02),ForecastCategoryName='Best Case',Project_Type__c='Aspirational',LeadSource='Channel Partner',Channel_Partner__c=CP[0].id,Amount=1000000)
};
Insert opp2;
//acc=[select Payment_Made__c from account where id=:acc[0].id];
//acc[0].Payment_Made__c=True;
//update acc;

AccountReferalCheck.PercentageReceived(acc);
}
}