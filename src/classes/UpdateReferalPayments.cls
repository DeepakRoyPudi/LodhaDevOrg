/*
  Version    Date         Auther             Description
  1.1      08/20/2014    Asmita(Eternus)    Modified the code as the Too Many SOQL exception was occuring while deploying the Lead related components
*/

public class UpdateReferalPayments{

    public static void PaymentDetails(Referral_Payment__c[] RP){     
       
       // 1.1 - Asmita - previously SOQL queries were written in for loop
       List<Id> listReferralId = new List<Id>();
       List<Referral_Payment__c> listRefPayment = new List<Referral_Payment__c>();
       Map<Id, Referrals__c> mapRef = new Map<Id, Referrals__c>();
       List<Referrals__c> listReferralToUpdate = new List<Referrals__c>();
       Double dGiftAmount = 0;
       Double dGiftsRedeemed = 0;
       
       for(Referral_Payment__c objRefer : RP){
       	   if(objRefer.Referral_ID__c != null)
               listReferralId.add(objRefer.Referral_ID__c);
       }
       if(!listReferralId.isEmpty())
           mapRef.putAll([Select id, No_of_Gifts__c,Total_Payment_Made__c from Referrals__c where Id in :listReferralId]);
       if(!mapRef.isEmpty())
           listRefPayment = [Select Gift_Amount_Paid__c,Gifts_Redeemed__c, Referral_ID__c from Referral_Payment__c where Referral_ID__c in :mapRef.keySet()];
           
       if(!mapRef.isEmpty()){
           for(Referrals__c objRef : mapRef.values()){
               dGiftAmount = 0;
               dGiftsRedeemed = 0;               
               for(Referral_Payment__c objRefPay : listRefPayment){
               	   if(objRefPay.Referral_ID__c == objRef.Id){
                       dGiftAmount = dGiftAmount + objRefPay.Gift_Amount_Paid__c;
                       dGiftsRedeemed = dGiftsRedeemed + objRefPay.Gifts_Redeemed__c;
               	   }
               }// end of for               
               objRef.Total_Payment_Made__c = dGiftAmount;
               objRef.Gifts_to_be_redeemed__c = objRef.No_of_Gifts__c - dGiftsRedeemed;
               listReferralToUpdate.add(objRef);
           }// end of for
           if(!listReferralToUpdate.isEmpty())
               Database.SaveResult[] result = Database.update(listReferralToUpdate);
       }// end of if
       
     }    
     
     
  static testMethod void UpdateReferalPayments()
  {
       Account[] acc =new Account[]
      {
          new Account(LastName='XYZ',Email_acc__c='xyz@gmail.com',Payment_Made__c = False)
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
          new Opportunity(Name='XYZh234',Project_Name__c=projectName1.id, Booking_Date__c=date.parse('01/01/2012'), AccountID=acc[0].id,StageName='Closed won',Application_Form__c = true,CRM_form__c = true, LOI_Sent__c= true,Agreement_Signed__c = true,CloseDate=Date.newInstance(2008,02,02),ForecastCategoryName='Best Case',Project_Type__c='Aspirational',LeadSource='Existing Customer',ReferralName__c=acc[0].id)
      };
      Insert opp;
      Lead[] L1=new Lead[]
      {
          new Lead(Project_Interested__c='Marina',Mobile__c='2345678912',LastName='Technologies',Interested__c='yes',Status='Visit Confirmed',LeadSource = 'Web',Date_Of_Visit__c=Datetime.newInstance(2008, 10, 28, 1, 6, 8), Address_r1__c = 'test road', Address2_R__c = 'test Road2', City_R__c = 'Mumbai', Address_3_R__c = 'Mumbai', Pincode_R__c = '123456', State_R__c = 'Maharashtra', Country_R__c = 'India')
      };
      Insert L1;

      Opportunity[] opp1=new Opportunity[]
      {
          new Opportunity(Name='XYZg844',Project_Name__c=projectName1.id, Booking_Date__c=date.parse('01/01/2012'), AccountID=acc[0].id,StageName='Closed won',Application_Form__c = true,CRM_form__c = true, LOI_Sent__c= true,Agreement_Signed__c = true,CloseDate=Date.newInstance(2008,02,02),ForecastCategoryName='Best Case',Project_Type__c='Aspirational',LeadSource='Channel Partner',Channel_Partner__c=CP[0].id,Amount=1000000 ,Lead_ID__c=L1[0].id)
      };
      Insert opp1;

      Opportunity[] opp2=new Opportunity[]
      {
          new Opportunity(Name='XYZn890',Project_Name__c=projectName1.id, Date_Of_Cancellation__c=date.parse('01/01/2012'), AccountID=acc[0].id,StageName='Cancelled',CloseDate=Date.newInstance(2008,02,02),ForecastCategoryName='Best Case',Project_Type__c='Aspirational',LeadSource='Channel Partner',Channel_Partner__c=CP[0].id,Amount=1000000)
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

      //insert led1;

      Campaign[] cam =new Campaign[]
      {
          new Campaign(Name='ABC',Ad_Communication__c='Product', Total_Call_Attempts__c = 0)};
          Insert cam; 

		/*
		Call_Attempts__c[] MS2 =new Call_Attempts__c[]
		{
		new Call_Attempts__c(lead__c =Opp2[0].Lead_id__c,CampaignUsed__c = cam[0].id,Call_Status__c='Lodha a1qua')
		};
		Insert MS2;

		Call_Attempts__c[] MS1 =new Call_Attempts__c[]
		    {
		    new Call_Attempts__c(lead__c =opp1[0].Lead_ID__c,CampaignUsed__c = cam[0].id,Call_Status__c='Lodha a1qua')
		    };
		    Insert MS1; 
		    */
		Payout_percentage__c[] pp1=new Payout_percentage__c[]
        {
            new Payout_percentage__c(Lead__c=led1.id,Channel_Partner__c=led1.Channel_partner__c,Payout_Percentage__c=2)
        };
        Insert pp1;
		/*Task[] ts = new Task[2];
		ts[0] = new Task(WHOID=L1[0].Id,OWNERID=UserInfo.getUserId(),Subject='Test',priority ='High',status = 'Not started',Mail_Check_Flag__c = 'YES');
		insert ts[0];*/


        Lead[] Ld=new Lead[]
        {
             new Lead(OWNERID=UserInfo.getUserId(),Company='Wipro',Project_Interested__c='Marine',Mobile__c='2345678412',LastName='Technologies',LeadSource='Web',Interested__c='yes',Status='Open')
        };
        insert Ld;

        Referrals__c[] ref1=new Referrals__c[]
        {
             new Referrals__c(Referral_Name__c = acc[0].id,Referred_Customer__c=Ld[0].id)
        };
        Insert ref1;
        Date todaydate = date.today();
  
        Referral_Payment__c[] RP=new  Referral_Payment__c[]
        {
            new  Referral_Payment__c(Referral_ID__c=ref[0].id,Date_of_Payment__c = todaydate ,Gift_Amount_Paid__c=10000,Gifts_Redeemed__c=0)
        };
        Insert RP;
        Lead[] L2=new Lead[]
        {
            new Lead(Company='Wipro',Project_Interested__c='LodhaMarine',Mobile__c='2345667892',LastName='Technologies',LeadSource='Web')
        };
        //  Insert L2;
        test.startTest();
            UpdateReferalPayments.PaymentDetails(RP);
        test.stopTest();
        //LODHA_UpdateProjectInterested.Updatemethod(L2);
    }
}