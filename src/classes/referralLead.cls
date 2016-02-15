public class referralLead{

	public static boolean leadFlag = false;
	
	public static void insertReferralObject(List<Lead> leadlist){ 

		if(leadFlag== false){

			Map<ID,ID> referrLeads = new Map<ID,ID>();     
			Map<ID,ID> referrLoyID = new Map<ID,ID>();

			List<Account> acc = new List<Account>();
			for(Lead l: leadlist){
				if(l.LeadSource=='Internal Referral'){ 
					referrLeads.put(l.Referred_Booked_Account__c,l.Id); 
				}
			}

			if(referrLeads.size()>0){
				for(Account a : [SELECT ID,Loyalty_Details__c FROM Account WHERE id in :referrLeads.keySet()]){
					referrLoyID.put(a.id,a.Loyalty_Details__c);
				}
			}     

			for(Lead l: leadlist){
				if(l.LeadSource=='Internal Referral'){ 
					LodhaReferralDetailsUtilities.insertLeadReferralDetails(l.Id, referrLoyID.get(l.Referred_Booked_Account__c));
				}
			}
			
			leadFlag= true;
		}

	}
}