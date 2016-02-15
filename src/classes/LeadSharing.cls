public class LeadSharing {
/* Commented out by Compro: Confirmed by Lodha on Dec 20 */

/*

    public static void addSharing( Lead[] leads, String accessLevel ){
      // receives a list of leads; need to grab the corresponding project exec records
      //Map<ID,Lead> leadMap = new Map<ID,Lead>( leads );

      LeadShare[] leadShares = new LeadShare[0];
 
        for ( Lead l : leads ) {
        
        
          List<Project_Executive__c> execs =
            [select id, Executive__c,Role_Name__c from Project_Executive__c where project__r.name = :l.Project_Interested__c];   
   
          User usr = [Select Profile.Name from user where id =: Userinfo.getuserid() limit 1];
              
              
          // Build Lead Sharing Records for each Execs
          for (Project_Executive__c exec : execs ) 
          {
            if( usr.Profile.Name!=Null && exec.Role_Name__c!='Sales Executive'){
            LeadShare ls = new LeadShare();
            ls.LeadId = l.Id;
            ls.UserOrGroupId = exec.Executive__c;
            ls.LeadAccessLevel = accessLevel;           
            System.debug('this is ls: ' + ls);
            leadShares.add( ls );
            }
          }                   
        }
        
        // Insert the sharing records
        if ( leadShares.size() > 0 ){
            try {
                System.debug('performing bulk LeadShare insert');
                Database.insert( leadShares, false );
            } catch (System.DmlException e) {
                System.debug( 'error bulk inserting shares' );
                for (Integer k = 0; k < e.getNumDml(); k++) {
                    // Process exception here
                    System.debug(e.getDmlMessage(k));
                }
            }
        }
        
    }

static testMethod void LeadSharing()
{
String CHKFLAG = 'No';
Projects__c[] pjts2= new  Projects__c[] 
{
new Projects__c(Name='Marine',WebSite_Project_Name__c = 'Marine' ,Budget__c=100000 )
};
Insert pjts2;
Account[] acc =new Account[]
{
new Account(LastName='XYZ', Email_acc__c='xyz@gmail.com',Payment_Made__c = false)
};
Insert acc;
Account[] acc1 =new Account[]
{
new Account(LastName='XYZ', Email_acc__c='xyz@gmail.com',Payment_Made__c = True)
};
Insert acc1;
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

Opportunity[] opp=new Opportunity[]
{
new Opportunity(Name='XYZ', AccountID=acc[0].id,StageName='Closed won',Application_Form__c = true,CRM_form__c = true, LOI_Sent__c= true,Agreement_Signed__c = true,CloseDate=Date.newInstance(2008,02,02),ForecastCategoryName='Best Case',Project_Type__c='Aspirational',LeadSource='Existing Customer',ReferralName__c=acc[0].id)
};
Insert opp;

Opportunity[] opp1=new Opportunity[]
{
new Opportunity(Name='XYZ', AccountID=acc[0].id,StageName='Closed won',Application_Form__c = true,CRM_form__c = true, LOI_Sent__c= true,Agreement_Signed__c = true,CloseDate=Date.newInstance(2008,02,02),ForecastCategoryName='Best Case',Project_Type__c='Aspirational',LeadSource='Channel Partner',Channel_Partner__c=CP[0].id,Amount=1000000)
};
Insert opp1;

  

Referrals__c[] ref1=new Referrals__c[]
{
new Referrals__c(Referral_Name__c=opp[0].AccountID)
};
Insert ref1;


Lead[] L2=new Lead[]
{
new Lead(Project_Interested__c='Marina',Mobile__c='2345678912',LastName='Technologies',Interested__c='yes',Status='Visit Confirmed',LeadSource = 'Existing Customer',Referral_Name__c=acc[0].id,Date_Of_Visit__c=Datetime.Now())
};
Insert L2;


Opportunity[] opp2=new Opportunity[]
{
new Opportunity(Name='XYZ',Lead_id__c =L2[0].id,AccountID=acc[0].id,StageName='Cancelled',CloseDate=Date.newInstance(2008,02,02),ForecastCategoryName='Best Case',Project_Type__c='Aspirational',LeadSource='Channel Partner',Channel_Partner__c=CP[0].id,Amount=1000000)
};
Insert opp2;

Referrals__c[] ref=new Referrals__c[]
{
new Referrals__c(Referral_Name__c=opp2[0].AccountID , Referred_Customer__c =opp2[0].Lead_ID__c)
};
Insert ref;

Campaign[] cam =new Campaign[]
{
new Campaign(Name='ABC',Total_Call_Attempts__c = 0)};
Insert cam; 

*/
//////T/H/I/S///W/A/S////C/O/M/M/E/N/T/E/D///////E/A/R/L/I/E/R/////////////
/*Call_Attempts__c[] MS2 =new Call_Attempts__c[]
{
new Call_Attempts__c(Project_Interested__c='Aqua',Call_Type__c='Email',Attempted_By__c='CED',Call_Attempted_by__c='Celing George',lead__c =Opp2[0].Lead_id__c,CampaignUsed__c = cam[0].id,Call_Status__c='Lodha a1qua')
};
Insert MS2;
*/
//////A/B/O/V/E//W/A/S////C/O/M/M/E/N/T/E/D///////E/A/R/L/I/E/R/////////////

/////////////////////////////////
/*
Lead[] L1=new Lead[]
{
new Lead(OWNERID=UserInfo.getUserId(),Company='Wipro',Project_Interested__c='Marine',Mobile__c='0000078912',LastName='Technologies',LeadSource='Web',Interested__c='yes',Status='Open')
};
insert L1;
Project_Executive__c[] MS1 =new Project_Executive__c[]
{
new Project_Executive__c(Executive__c=Userinfo.getuserid(),Project__c= pjts2[0].id,Role_Name__c='Sales Executive')
};
insert MS1;
LODHA_UpdateProjectInterested.Updatemethod(L1);
LeadSharing.addSharing(L1,'Read');
}
*/
}