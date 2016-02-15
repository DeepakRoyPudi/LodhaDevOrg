public class LeadPullProject
{
public static void pullmethod(Lead[] a)
 {                              
for (Lead l:a) {

/*Update total number of leads in Campaign*/
           
          if(l.LeadSource == 'Channel Partner'&& l.Channel_Partner__c != null){
          Channel_Partner__c cp = [select Total_No_Of_leads__c,No_of_Converted_Leads__c from Channel_Partner__c where id =:l.Channel_Partner__c Limit 1];
          cp.Total_No_Of_leads__c =[select count() from Lead where Channel_Partner__c =:l.Channel_Partner__c]; 
          cp.No_of_Converted_Leads__c =[select count() from Lead where Channel_Partner__c =:l.Channel_Partner__c and ISconverted = True];             
          Update cp;
          } 
          /*Update Referal count based on lead conversion*/
          /*
          if(l.LeadSource == 'Existing Customer'&& l.Referral_Name__c != null && l.isconverted == True){
          Referrals__c ref = [select No_of_Gifts__c from Referrals__c where Referred_Customer__c =: l.id and Referral_Name__c =:l.Referral_Name__c Limit 1];
          ref.No_of_Gifts__c = 1;             
          Update ref;
          }  */   

Projects__c[] pt=[Select URL__c from Projects__c where Name=:l.Project_Interested__c limit 1];
if(pt.size()>0)
l.Mail_ID__c=pt[0].URL__c;
l.Opportunity_Project__c = l.Project_Interested__c;
l.Lead_Status_WF__c = l.Status;
}
}
static testMethod void LeadPullProject()
{  
   Projects__c[] MS1 =new Projects__c[]
    {
    new Projects__c(Name='Loreal',Budget__c=100000,URL__c='www.yahoo.com')
    };
   Insert MS1;  
   Product2[] P2=new Product2[]
    {
    new Product2(Name='Product1',ProductCode='xyz218',Family='Loreal',Project_Type__c='Aspirational',flat_status__c='Available',Isactive=true) 
    };
    Insert P2; 
   
    Lead[] L1=new Lead[]
    {
    new Lead(Company='Wipro',Project_Interested__c='Loreal',Mobile__c='2345678912',LastName='Technologies',LeadSource='Web')
    };
   
  Insert L1;
  MS1=[select URL__C from projects__c where id=:MS1[0].ID];
MS1[0].URL__c='www.hello.com';
update MS1;

Channel_Partner__c cp =new Channel_Partner__c (name='test');
insert cp;
  L1=[select Mail_ID__c,LeadSource,Channel_Partner__c from lead where id=:L1[0].Id];
  L1[0].LeadSource='Channel Partner';
  L1[0].Mail_ID__c=MS1[0].URL__C;
  L1[0].Channel_Partner__c=cp.ID;
  Update L1;

 if(L1[0].LeadSource == 'Channel Partner'&& L1[0].Channel_Partner__c != null){
cp = [select Total_No_Of_leads__c,No_of_Converted_Leads__c from Channel_Partner__c where id =:L1[0].Channel_Partner__c Limit 1];
cp.Total_No_Of_leads__c =[select count() from Lead where Channel_Partner__c =:L1[0].Channel_Partner__c]; 
cp.No_of_Converted_Leads__c =[select count() from Lead where Channel_Partner__c =:L1[0].Channel_Partner__c and ISconverted = True];             
update cp;
}  
    LeadPullProject.pullmethod(L1);
}
}