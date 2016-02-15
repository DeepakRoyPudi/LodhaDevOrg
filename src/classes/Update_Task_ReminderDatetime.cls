public class Update_Task_ReminderDatetime{

public static void Updatemethod(Task[] ts){
ID strid = UserInfo.getProfileId();
//if(ts[0].WHOID != null){
//Task tsk =[Select WHOID,TaskDateTime__c from Task where Id =: ts[0].ID limit 1];    
if(ts[0].WHOID != null){   
Lead[] led = [Select Mobile__c,Status,Date_Of_Visit__c,Follow_Up_Date__c from Lead where Id =: ts[0].WHOID limit 1];
if(led.size()>0){
system.debug('Inside If'+led[0].Mobile__c);
ts[0].Mobile_Phone__c = led[0].Mobile__c;
if(led[0].Status =='Visit Confirmed')
    {
    ts[0].TaskDateTime__c =  led[0].Date_Of_Visit__c;
    ts[0].IsReminderSet =TRUE;
    ts[0].ReminderDateTime = led[0].Date_Of_Visit__c.addMinutes(-15);
    }
if(led[0].Status =='Follow up')
    {
    ts[0].TaskDateTime__c =  led[0].Follow_Up_Date__c;
    ts[0].IsReminderSet =TRUE;
    ts[0].ReminderDateTime = led[0].Follow_Up_Date__c.addMinutes(-15);
    }
//update ts[0];
} 
}
}

static testMethod void Update_Task_ReminderDatetime()
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
Project_Name__c projectName1=new Project_Name__c();
projectName1.name='Loreal';
insert projectName1;

Opportunity[] opp=new Opportunity[]
{
new Opportunity(Name='XYZy654',Project_Name__c=projectName1.id, Booking_Date__c=date.parse('01/01/2012'), AccountID=acc[0].id,StageName='Closed won',Application_Form__c = true,CRM_form__c = true, LOI_Sent__c= true,Agreement_Signed__c = true,CloseDate=Date.newInstance(2008,02,02),ForecastCategoryName='Best Case',Project_Type__c='Aspirational',LeadSource='Existing Customer',ReferralName__c=acc[0].id)
};
Insert opp;
Lead[] L1=new Lead[]
{
new Lead(Project_Interested__c='Marina',Mobile__c='2345678912',LastName='Technologies',Interested__c='yes',Status='Visit Confirmed',LeadSource = 'Web',Date_Of_Visit__c=Datetime.newInstance(2008, 10, 28, 1, 6, 8))
};
Insert L1;

Opportunity[] opp1=new Opportunity[]
{
new Opportunity(Name='XYZv678',Project_Name__c=projectName1.id, Booking_Date__c=date.parse('01/01/2012'), AccountID=acc[0].id,StageName='Closed won',Application_Form__c = true,CRM_form__c = true, LOI_Sent__c= true,Agreement_Signed__c = true,CloseDate=Date.newInstance(2008,02,02),ForecastCategoryName='Best Case',Project_Type__c='Aspirational',LeadSource='Channel Partner',Channel_Partner__c=CP[0].id,Amount=1000000 ,Lead_ID__c=L1[0].id)
};
Insert opp1;
Opportunity[] opp2=new Opportunity[]
{
new Opportunity(Name='XYrZ',Project_Name__c=projectName1.id, Date_Of_Cancellation__c=date.parse('01/01/2012'), AccountID=acc[0].id,StageName='Cancelled',CloseDate=Date.newInstance(2008,02,02),ForecastCategoryName='Best Case',Project_Type__c='Aspirational',LeadSource='Channel Partner',Channel_Partner__c=CP[0].id,Amount=1000000)
};
Insert opp2;
Lead led = new Lead();
led.status='Visit Confirmed';
led.Mobile__c='1234567892';
led.LastName='XXXXXX';
led.Interested__c='Yes';
led.Date_Of_Visit__c=Datetime.newInstance(2008, 10, 28, 1, 6, 8);
led.Project_Interested__c='Alqua';
insert led;

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

Task[] ts = new Task[2];
ts[0] = new Task(WHOID=led.Id,OWNERID=userinfo.getuserid(),Mail_Check_Flag__c = 'YES',status = 'Not Started');
insert ts[0];
ts[1] = new Task(WHOID=led1.Id,OWNERID=userinfo.getuserid(),Mail_Check_Flag__c = 'YES',status = 'Not Started');
insert ts[1];
Updatemethod(ts);
MailtoMissedTask.SendMailtomanager(ts);
Lead[] L2=new Lead[]
    {
    new Lead(Company='Wipro',Project_Interested__c='LodhaMarine',Mobile__c='2345167892',LastName='Technologies',LeadSource='Web')
    };
     //Insert L2;
//LODHA_UpdateProjectInterested.Updatemethod(L2);

}
}