public class ChangeOwnerID{
 public static void Updatemethod1(Lead[] ld){
 Projects__c[] MS = [Select Name,URL__c from Projects__c where WebSite_Project_Name__c =:ld[0].Project_Interested__c limit 1];
/////////////N/E/W////C/O/D/E///////F/O/R////W/2/L/E/A/D/////B/Y/////C/O/M/P/R/O////// 
Project_Name__c[] ProjectName = [Select ID, Name from Project_Name__c ];
Project_Name__c[] ProjectName_UProject = [Select ID, Name from Project_Name__c where Name='Unknown Project' limit 1];

for(Integer i=0;i<LD.Size();i++)
{    
      for(Integer j=0;j<ProjectName.Size();j++)
     {
     ///Incase wrong IDs are passed which more than 15 Character, using Try/Catch Block
         try
         {
           if(ld[i].ExistingProjectID__c ==ProjectName[j].id)
           {
                ld[i].Project_Name__c= ProjectName[j].Id;     
                break;
           }
         }
         catch (exception e)
         {
           System.debug('Error Caught'+e);
           if(ld[i].Project_Name__c==null)
           {
               //ld[i].Project_Name__c= 'a09P0000000AK6N'; 
               ld[i].Project_Name__c= ProjectName_UProject[0].id;
           }            
         }
     }
     ///Incase the IDs are not matched, assign the Unknown Project 
     if(ld[i].Project_Name__c==null)
     {
         //ld[i].Project_Name__c= 'a09P0000000AK6N'; 
         ld[i].Project_Name__c= ProjectName_UProject[0].id;
     }                             
 }
//////////////C/O/D/E///////E/N/D////H/E/R/E/////// 

 
 if(ld[0].LeadSource == 'Web'||ld[0].LeadSource == 'WebBanner'){
   if(ld[0].Project_Interested__c != null && ld[0].Project_Interested__c !='Projects'){
     if(MS.size() > 0){                         
        ld[0].Project_Interested__c = MS[0].Name;                              
       }             
      }
     }
if(MS.size()>0){
ld[0].Mail_ID__c=MS[0].URL__c;
}
ld[0].Opportunity_Project__c = ld[0].Project_Interested__c;
ld[0].Lead_Status_WF__c = ld[0].Status;
}




Testmethod static void ChangeOwnerID()
{
Projects__c[] pjts2= new  Projects__c[] 
{
new Projects__c(Name='Loreal',Budget__c=100000 )
};
Insert pjts2;  

Project_Name__c projectName1=new Project_Name__c();
projectName1.name='Loreal';
insert projectName1;

Project_Executive__c[] MS1 =new Project_Executive__c[]
{
new Project_Executive__c(Executive__c=UserInfo.getUserId(),Project__c=pjts2[0].id,Role_Name__c='Sal Executive')
};
insert MS1;
Account[] acc =new Account[]
{
new Account(LastName='XYZ', Email_acc__c='xyz@gmail.com',Payment_Made__c = False)
};
Insert acc;

Lead[] L2=new Lead[]
{
new Lead(Company='Wipro',Date_of_visit__c= datetime.now(),status = 'Follow up',Project_Interested__c='Loreal',Mobile__c='2345567892',LastName='Technologies',LeadSource='Web')
};
//Insert L2;

Lead[] led = new Lead[1];
led[0] = new Lead();
led[0].status='Follow up';
led[0].Mobile__c='1234567892';
led[0].LastName='XXXXXX';
led[0].Interested__c='Yes';
led[0].LeadSource = 'Web';
led[0].Project_Interested__c = 'Loreal';
led[0].OWNERID=UserInfo.getUserId();
insert led;

Channel_Partner__c[] CP=new Channel_Partner__c[]
{
new Channel_Partner__c(Name='Aparnafirms',Type_of_Channel_Partner__c='Domestic',Email__c='xy@hotmail.com')
};
Insert CP;

Opportunity[] opp=new Opportunity[]
{
new Opportunity(Name='XYZ200',Project_Name__c = projectName1.id, Booking_Date__c=date.parse('01/01/2012'), AccountID=acc[0].id,StageName='Closed won',Application_Form__c = true,CRM_form__c = true, LOI_Sent__c= true,Agreement_Signed__c = true,CloseDate=Date.newInstance(2008,02,02),ForecastCategoryName='Best Case',Project_Type__c='Aspirational',LeadSource='Existing Customer',ReferralName__c=acc[0].id)
};
Insert opp;
Lead[] L1=new Lead[]
{
new Lead(Project_Interested__c='Marina',Mobile__c='2345678912',LastName='Technologies',Interested__c='yes',Status='Visit Confirmed',LeadSource = 'Existing Customer',Referral_Name__c=acc[0].id,Date_Of_Visit__c=Datetime.newInstance(2008, 10, 28, 1, 6, 8))
};
//Insert L1;

Opportunity[] opp1=new Opportunity[]
{
new Opportunity(Name='XYZ100',Project_Name__c = projectName1.id, Booking_Date__c=date.parse('01/01/2012'), AccountID=acc[0].id,StageName='Closed won',LOI_Sent__c= true,Agreement_Signed__c = true,Application_Form__c = true,CRM_form__c = true, CloseDate=Date.newInstance(2008,02,02),ForecastCategoryName='Best Case',Project_Type__c='Aspirational',LeadSource='Channel Partner',Channel_Partner__c=CP[0].id,Amount=1000000 ,Lead_ID__c=L1[0].id)
};
Insert opp1;
Opportunity[] opp2=new Opportunity[]
{
new Opportunity(Name='XYZ300',Project_Name__c = projectName1.id, Date_Of_Cancellation__c=date.parse('01/01/2012'), AccountID=acc[0].id,StageName='Cancelled',CloseDate=Date.newInstance(2008,02,02),ForecastCategoryName='Best Case',Project_Type__c='Aspirational',LeadSource='Channel Partner',Channel_Partner__c=CP[0].id,Amount=1000000)
};
Insert opp2;

 
Lead[] L3=new Lead[]
{
new Lead(Company='Wipro',Project_Interested__c='Loreal',Mobile__c='7891112222',LastName='Technologies',LeadSource='Web')
};
Insert L3;
    


//Restrictchangeownership.ownership(L3); 
LODHA_UpdateProjectInterested.Updatemethod(L3);
//Updatemethod(led);  
Updatemethod1(L3); 
}        
}