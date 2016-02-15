public class Restrictchangeownership
{
private static Boolean recursioncontrol=false;
public static void ownership(Lead[] l )
{
       //for ( Lead ld: l) {
       
       IF(l[0].Allow_to_Save__c == False){
        
        User[] usr = [Select Profile.Name from User where id =: Userinfo.getuserid() limit 1];
        User[] owner=[Select Profile.Name from User where id =: l[0].OwnerId limit 1];
        Project_Executive__c[] exec=[select project__r.name from Project_Executive__c where Executive__c = :l[0].OwnerId limit 1];
        Project_Executive__c[] exec1=[select project__r.name from Project_Executive__c where Executive__c = :Userinfo.getuserid() limit 1];
        
        if(recursioncontrol==false){
        recursioncontrol=true;
        datetime myDateTime = datetime.now();
        String sDate = String.valueOf(myDateTime);
        String cDate = String.valueOf(l[0].createddate);
        
        if(cDate.substring(14,16) != sDate.substring(14,16)){
             //User[] Usr = [Select Id,Name,profile.Name from User where id =:ld[0].OwnerId limit 1];
             if(owner.size() == 0){ 
                 l[0].OwnerId=UserInfo.getUserId(); 
                 }
             }
        }         
        
        
        if(usr.size()!=0 && owner.size()!=0 && exec.size()!=0 && exec1.size()!=0)  
        {
               
        if(exec[0].project__r.name ==l[0].Project_Interested__c  && exec[0].project__r.name==exec1[0].project__r.name)
        {
        
//Change ownership from PSC to SE
        if(usr[0].Profile.Name=='Presales Consultant' && (owner[0].Profile.Name=='Sales Executive' ||(owner[0].Profile.Name=='Site Incharge'&& (l[0].Status!='Visit Confirmed' && l[0].Status!='Visit Done'&& l[0].Status!='Lost')) || owner[0].Profile.Name=='VP/AVP/GM')&& l[0].OwnerId!=Userinfo.getuserid())
        {
        //String OID=l[0].OwnerId;
                    //system.debug('###Inside'+OID);
                    l[0].OwnerId=Userinfo.getuserid();
                   l[0].addError('Ownership cannot be changed');
        }
//Change Ownership from SE to SE
        if(owner[0].Profile.Name!=null){
        if((usr[0].Profile.Name=='Sales Executive'&& owner[0].Profile.Name=='VP/AVP/GM'&& l[0].OwnerId!=Userinfo.getuserid())||(usr[0].Profile.Name=='Site Incharge'&& owner[0].Profile.Name=='VP/AVP/GM')&& l[0].OwnerId!=Userinfo.getuserid())
        { 
        //String ONID=l[0].OwnerId;
        //system.debug('###Inside'+ONID);
        l[0].OwnerId=Userinfo.getuserid();
        l[0].addError('Ownership cannot be changed');
        }
        }
        }
//Change Ownership from PSC to Other project Execitives
        if(Owner[0].Profile.Name!=null){
        if((usr[0].Profile.Name=='Presales Consultant'||usr[0].Profile.Name=='Site Incharge'||usr[0].Profile.Name=='Sales Executive')  && l[0].OwnerId!=Userinfo.getuserid())
        {
        //Project_Executive__c exec=[select project__r.name from Project_Executive__c where Executive__c = :l[0].OwnerId limit 1];   
         
       String OID1=l[0].OwnerId;
                    
                   
                    if(exec[0].project__r.name!=l[0].Project_Interested__c )
                    {
                               /* if((l[0].status!='Open' || exec[0].project__r.name!=l[0].Project_Interested__c) && l[0].status !='Lost')
                                    {
                                    l[0].OwnerId=Userinfo.getuserid();
                                    l[0].addError('Ownership cannot be changed to other project executives');
                                    }*/
                    
                                if(l[0].status=='Lost'&& usr[0].Profile.Name=='Presales Consultant' && owner[0].Profile.Name=='Presales Consultant'&& l[0].OwnerId!=Userinfo.getuserid())
                                 {
                                 l[0].OwnerId=OID1 ;
                                 }
                   }
}
                   
}
}           
}
//}
}
Static testMethod void Restrictchangeownership()
{
Projects__c[] pjts2= new  Projects__c[] 
{
new Projects__c(Name='Marine',Budget__c=100000 )
};
Insert pjts2;
Product2[] P2=new Product2[]
{
new Product2(Name='Product1',ProductCode='xyz218',Family='Marine',Project_Type__c='Aspirational',flat_status__c='Available',Isactive=true) 
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
new Opportunity(Name='XYZ563s',Project_Name__c=projectName1.id, Booking_Date__c=date.parse('01/01/2012'), AccountID=acc[0].id,StageName='Closed won',Application_Form__c = true,CRM_form__c = true, LOI_Sent__c= true,Agreement_Signed__c = true,CloseDate=Date.newInstance(2008,02,02),ForecastCategoryName='Best Case',Project_Type__c='Aspirational',LeadSource='Existing Customer',ReferralName__c=acc[0].id)
};
Insert opp;
Lead[] L1=new Lead[]
{
new Lead(Allow_to_Save__c =False,Project_Interested__c='Marina',Mobile__c='2345678912',LastName='Technologies',Interested__c='yes',Status='Visit Confirmed',LeadSource = 'Web',Date_Of_Visit__c=Datetime.newInstance(2008, 10, 28, 1, 6, 8))
};
Insert L1;

Opportunity[] opp1=new Opportunity[]
{
new Opportunity(Name='fg5345',Project_Name__c=projectName1.id, Booking_Date__c=date.parse('01/01/2012'), AccountID=acc[0].id,StageName='Closed won',LOI_Sent__c= true,Agreement_Signed__c = true,Application_Form__c = true,CRM_form__c = true, CloseDate=Date.newInstance(2008,02,02),ForecastCategoryName='Best Case',Project_Type__c='Aspirational',LeadSource='Channel Partner',Channel_Partner__c=CP[0].id,Amount=1000000 ,Lead_ID__c=L1[0].id)
};
Insert opp1;
Opportunity[] opp2=new Opportunity[]
{
new Opportunity(Name='bvf567',Project_Name__c=projectName1.id, Date_Of_Cancellation__c=date.parse('01/01/2012'), AccountID=acc[0].id,StageName='Cancelled',CloseDate=Date.newInstance(2008,02,02),ForecastCategoryName='Best Case',Project_Type__c='Aspirational',LeadSource='Channel Partner',Channel_Partner__c=CP[0].id,Amount=1000000)
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
led1.Allow_to_Save__c =False;

insert led1;


/*
Call_Attempts__c[] MS1 =new Call_Attempts__c[]
    {
    new Call_Attempts__c(lead__c =opp1[0].Lead_ID__c,Call_Status__c='Lodha a1qua')
    };
    Insert MS1; */
Payout_percentage__c[] pp1=new Payout_percentage__c[]
{
new Payout_percentage__c(Lead__c=led1.id,Channel_Partner__c=led1.Channel_partner__c,Payout_Percentage__c=2)
};
Insert pp1;
Task[] ts = new Task[2];
ts[0] = new Task(WHOID=L1[0].Id,OWNERID=UserInfo.getUserId(),Subject='Test',priority ='High',status = 'Not started',Mail_Check_Flag__c = 'YES');
insert ts[0];

ts[1] = new Task(WHOID=led1.Id,OWNERID=UserInfo.getUserId(),Subject='Test',priority ='High',status = 'Not started',Mail_Check_Flag__c = 'YES');
insert ts[1];
Project_Executive__c[] MS2 =new Project_Executive__c[]
{
new Project_Executive__c(Executive__c=UserInfo.getUserId(),Project__c=pjts2[0].id,Role_Name__c='Sales Executive')};
insert MS2; 

//Restrictchangeownership.ownership(L1);
//LODHA_UpdateProjectInterested.Updatemethod(L2);

}
}