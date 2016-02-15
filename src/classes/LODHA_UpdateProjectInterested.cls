public class LODHA_UpdateProjectInterested{
   public static void Updatemethod(Lead[] l){ 
     for(Lead b:l){
     if(b.LeadSource == 'Web'||b.LeadSource == 'WebBanner'){
            if(b.Project_Interested__c != null && b.Project_Interested__c !='Projects'){
            Projects__c[] MS = [Select Name from Projects__c where WebSite_Project_Name__c =:b.Project_Interested__c limit 1];
            if(MS.size() > 0){                         
               b.Project_Interested__c = MS[0].Name;                  
              }             
            }
          }
        }
     }
         
   public static void InsertUpdateReferral(Lead[] l){ 
       for (Lead b:l) {           
           
           If(b.LeadSource == 'Existing Customer' &&  b.Referral_Name__c != null ){
           Referrals__c[] RC = [Select ID from Referrals__c where Referred_Customer__c =: b.ID and Referral_Name__c =:b.Referral_Name__c];
           If(RC.size() == 0){
           system.debug('Ramesh'+RC.size());
            Referrals__c[] RS = new  Referrals__c[]
            {new Referrals__c(Lead_Status__c = b.Status,Referral_Name__c=b.referral_Name__c,Referred_Customer__c = b.ID)};
             Insert RS;
            }
            else
            {
            RC[0].Lead_Status__c = b.status;
            Update RC[0];
            }
           }
           
           If(b.LeadSource == 'Channel Partner' &&  b.Channel_Partner__c != null ){
           Payout_percentage__c[] PPER = [Select ID from Payout_percentage__c where Lead__c =: b.ID];
           
           Channel_Partner__c CP = [Select Type_of_Channel_Partner__c from Channel_Partner__c where ID =: b.Channel_Partner__c Limit 1];
           //CP.Total_No_Of_leads__c =[select count() from Lead where Channel_Partner__c =:b.Channel_Partner__c]; 
           //CP.No_of_Converted_Leads__c =[select count() from Lead where Channel_Partner__c =:b.Channel_Partner__c and ISconverted = True];             
           //Update cp;
           
           //----------------------------------
           
            List<Lead> LD = [Select ID,ISconverted from Lead where Channel_Partner__c =:b.Channel_Partner__c];   
            Integer TOT_Leads = 0;
            Integer TOT_ConLeads = 0;
                          
            for (Lead Led : LD ) 
            {             
              TOT_Leads = LD.size();         
            }
             CP.Total_No_Of_leads__c = TOT_Leads-1;
            for (Lead Led1 : LD ) 
            {
              if(Led1.ISconverted == True){  
              TOT_ConLeads = TOT_ConLeads + 1;}          
            }          
            CP.No_of_Converted_Leads__c = TOT_ConLeads;
            Update cp;
           //-----------------------------------
           
           If(PPER.size() == 0 && b.Project_Type__c !=null){                   
           Payout_Master__c PM = [Select Payout_Percentage__c from Payout_Master__c where Property_type__c =: b.Project_Type__c and Channel_Partner_Type__c=: CP.Type_of_Channel_Partner__c Limit 1];
           Payout_percentage__c[] PP = new  Payout_percentage__c[]
           {new Payout_percentage__c(Lead__c = b.ID,Channel_Partner__c=b.Channel_Partner__c,Payout_Percentage__c = PM.Payout_Percentage__c)};
           Insert PP;
           }
          }        
                 
        }
      }        
    
static testMethod void LODHA_UpdateProjectInterested()
{  
  Projects__c[] MS1 =new Projects__c[]
    {
    new Projects__c(Name='LodhaMarine',WebSite_Project_Name__c='LodhaMarine',Budget__c=100000)
    };
    Insert MS1; 
     Product2[] P2=new Product2[]
    {
    new Product2(Name='Product1',ProductCode='xyz218',Family='LodhaMarine',Project_Type__c='Aspirational',flat_status__c='Available',Isactive=true) 
    };
    Insert P2; 
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
new Opportunity(Name='XYZ098',Project_Name__c=projectName1.id, Booking_Date__c=date.parse('01/01/2012'), AccountID=acc[0].id,StageName='Closed won',Application_Form__c = true,CRM_form__c = true, LOI_Sent__c= true,Agreement_Signed__c = true,CloseDate=Date.newInstance(2008,02,02),ForecastCategoryName='Best Case',Project_Type__c='Aspirational',LeadSource='Existing Customer',ReferralName__c=acc[0].id)
};
Insert opp;
Lead[] L1=new Lead[]
{
new Lead(Project_Interested__c='Marina',Mobile__c='2345678912',LastName='Technologies',Interested__c='yes',Status='Visit Confirmed',LeadSource = 'Web',Date_Of_Visit__c=Datetime.newInstance(2008, 10, 28, 1, 6, 8))
};
Insert L1;

Opportunity[] opp1=new Opportunity[]
{
new Opportunity(Name='XYZ567',Project_Name__c=projectName1.id, Booking_Date__c=date.parse('01/01/2012'), AccountID=acc[0].id,StageName='Closed won',Application_Form__c = true,CRM_form__c = true, LOI_Sent__c= true,Agreement_Signed__c = true,CloseDate=Date.newInstance(2008,02,02),ForecastCategoryName='Best Case',Project_Type__c='Aspirational',LeadSource='Channel Partner',Channel_Partner__c=CP[0].id,Amount=1000000 ,Lead_ID__c=L1[0].id)
};
Insert opp1;
Opportunity[] opp2=new Opportunity[]
{
new Opportunity(Name='XYZ382', Project_Name__c=projectName1.id,Date_Of_Cancellation__c=date.parse('01/01/2012'), AccountID=acc[0].id,StageName='Cancelled',CloseDate=Date.newInstance(2008,02,02),ForecastCategoryName='Best Case',Project_Type__c='Aspirational',LeadSource='Channel Partner',Channel_Partner__c=CP[0].id,Amount=1000000)
};
Insert opp2;

Lead led1 = new Lead();
led1.status='Follow up';
led1.LeadSource = 'Channel Partner';
led1.Project_Interested__c ='Marine';
led1.Mobile__c='1234567893';
led1.LastName='XXXXXX';
led1.Interested__c='Yes';
led1.Follow_Up_Date__c=Datetime.newInstance(2008, 10, 28, 1, 6, 8);
led1.Channel_Partner__c=CP[0].id;

insert led1;

    Lead[] L2=new Lead[]
    {
    new Lead(Company='Wipro',Project_Interested__c='LodhaMarine',Mobile__c='2345678921',LastName='Technologies',LeadSource='Web')
    };
     Insert L2;
    //Update L1;
    
       
     
    
 LODHA_UpdateProjectInterested.Updatemethod(L2); 

}
}