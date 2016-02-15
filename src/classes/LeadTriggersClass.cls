/*
Author - Jayant
Class Name - LeadTriggersClass
Date Created - 21st July 2011
Date Last Modified - 21st July 2011
Purpose - This class contains the methods that are called from various triggers on Lead object
*/

public class LeadTriggersClass{

//this variable is used in RestrictChangeOwnership method to control Recursion 
private static Boolean recursionControl = false;

/*
method UpdateProjectDetails begins
Author - Jayant
Invocation - this method is called from LeadProcess trigger on Before Insert event
Date Created - 21st July 2011
Date Last Modified - 21st July 2011
Input - trigger.new
Output - void
Purpose - sets several fields on Lead records based on Project_Interested__c field
*/ 
public static void UpdateProjectDetails(list <Lead> lstLead){
	try
	{
		set <string> setProjInt = new set <string> ();
		map <string, Projects__c> mapProjIntProjects = new map <string, Projects__c> ();
		list <Projects__c> lstProjects = new list <Projects__c> ();
		list <Project_Name__c> lstProjectName = [select Id, Name from Project_Name__c];
		Project_Name__c unknownProject = [select Id, Name from Project_Name__c where Name='Unknown Project' limit 1];
		
		for(Lead l : lstLead)
		{
			setProjInt.add(l.Project_Interested__c);
		}
		
		lstProjects = [select Name, URL__c, WebSite_Project_Name__c from Projects__c where WebSite_Project_Name__c in: setProjInt limit 1000];
		
		for(Projects__c p : lstProjects)
		{
			mapProjIntProjects.put(p.WebSite_Project_Name__c, p);
		}	
		
		for(Lead l : lstLead)
		{    
			for(Project_Name__c p : lstProjectName)
			{
			      if(l.ExistingProjectID__c == p.Id)
			      {
			           l.Project_Name__c = p.Id;     
			           break;
			      }
			}
			 
			if(l.Project_Name__c == null && unknownProject != null)
			{
			    l.Project_Name__c = unknownProject.Id;
			}		
			 
			if(l.LeadSource == 'Web' || l.LeadSource == 'WebBanner')
			{
				if(l.Project_Interested__c != null && l.Project_Interested__c != 'Projects')
				{
			    	if(mapProjIntProjects.get(l.Project_Interested__c) != null)
			    	{                         
			        	l.Project_Interested__c = mapProjIntProjects.get(l.Project_Interested__c).Name;                              
			    	}             
			    }
			}
			
			if(mapProjIntProjects.get(l.Project_Interested__c) != null)
			{
				l.Mail_ID__c = mapProjIntProjects.get(l.Project_Interested__c).URL__c;
			}
		     
			l.Opportunity_Project__c = l.Project_Interested__c;
			l.Lead_Status_WF__c = l.Status;                             
		}	
	}
	catch (Exception e){
		system.debug('Generic Exception Caught : ' + e.getMessage());
	}
}

//method UpdateProjectDetails ends


/*
method RestrictChangeOwnership begins
Author - Jayant
Invocation - this method is called from LeadProcess trigger on Before Update event
Date Created - 21st July 2011
Date Last Modified - 21st July 2011
Input - trigger.new
Output - void
Purpose - controls the ownership and modifications to ownership of Leads
*/  
public static void RestrictChangeOwnership(list <Lead> lstLead){
	try
	{
		map <Id, string> mapLeadOwnerProfile = new map <Id, string> ();
		map <Id, string> mapLeadOwnerProject = new map <Id, string> ();
		set <Id> setOwnerIDs = new set <Id> ();
		list <Project_Executive__c> lstPE = new list <Project_Executive__c> ();
		list <User> lstUser = new list <User> ();		
		User usr = [select Id, Profile.Name from User where Id =: UserInfo.getUserId() limit 1];		
		list <Project_Executive__c> lstProjExec = new list <Project_Executive__c> ();
		lstProjExec = [select Id, Project__r.name from Project_Executive__c where Executive__c =: UserInfo.getUserId() limit 1];
	
		for (Lead l : lstLead)
		{
			setOwnerIds.add(l.OwnerId);		
		}
			
		lstPE = [select Id, Executive__c, Project__r.Name from Project_Executive__c where Executive__c in: setOwnerIds limit 1000];
		lstUser = [select Id, Profile.Name from User where Id in: setOwnerIds limit 1000];
	
		for (Project_Executive__c pe : lstPE)
		{
			mapLeadOwnerProject.put(pe.Executive__c, pe.Project__r.Name);
		}
	
		for (User u : lstUser)
		{
			mapLeadOwnerProfile.put(u.Id, u.Profile.Name);
		}
			
		for (Lead l : lstLead)
		{
			if(l.Allow_to_Save__c == false)
			{        
				if(recursionControl == false)
				{
					recursionControl = true;
					datetime myDateTime = datetime.now();
					String sDate = String.valueOf(myDateTime);
					String cDate = String.valueOf(l.CreatedDate);
					
					if(cDate != sDate)
					{
				         if(mapLeadOwnerProfile.get(l.OwnerId) == null)
				         { 
				         	l.OwnerId = UserInfo.getUserId(); 
				         }
					}
				}         
				        
				if(usr != null && mapLeadOwnerProfile.get(l.OwnerId) != null && mapLeadOwnerProject.get(l.OwnerId) != null && lstProjExec.size() > 0)  
				{               
					if(mapLeadOwnerProject.get(l.OwnerId) == l.Project_Interested__c  &&  mapLeadOwnerProject.get(l.OwnerId) == lstProjExec[0].Project__r.Name)
					{        
						//Change ownership from PSC to SE
						if(usr.Profile.Name == 'Presales Consultant' && (mapLeadOwnerProfile.get(l.OwnerId) == 'Sales Executive' ||(mapLeadOwnerProfile.get(l.OwnerId) == 'Site Incharge' && (l.Status != 'Visit Confirmed' && l.Status != 'Visit Done' && l.Status != 'Lost')) || mapLeadOwnerProfile.get(l.OwnerId) == 'VP/AVP/GM') && l.OwnerId != UserInfo.getUserId())
						{       
					    	l.OwnerId = UserInfo.getUserId();
					    	l.addError('Ownership cannot be changed');
						}
					
						//Change Ownership from SE to SE
						if(mapLeadOwnerProfile.get(l.OwnerId) != null)
						{
							if((usr.Profile.Name == 'Sales Executive' && mapLeadOwnerProfile.get(l.OwnerId) == 'VP/AVP/GM' && l.OwnerId != UserInfo.getUserId()) || (usr.Profile.Name == 'Site Incharge' && mapLeadOwnerProfile.get(l.OwnerId) == 'VP/AVP/GM') && l.OwnerId != UserInfo.getUserId())
							{       
								l.OwnerId=UserInfo.getUserId();
								l.addError('Ownership cannot be changed');
							}
						}
					}
							
					//Change Ownership from PSC to Other Project Executives
					if(mapLeadOwnerProfile.get(l.OwnerId) != null)
					{
						if((usr.Profile.Name == 'Presales Consultant' || usr.Profile.Name == 'Site Incharge' || usr.Profile.Name == 'Sales Executive') && l.OwnerId != UserInfo.getUserId())
						{        
							String OID1 = l.OwnerId;                  
					        if(mapLeadOwnerProject.get(l.OwnerId) != l.Project_Interested__c)
					        {
				        		if(l.Status == 'Lost' && usr.Profile.Name == 'Presales Consultant' &&  mapLeadOwnerProfile.get(l.OwnerId) == 'Presales Consultant' && l.OwnerId != UserInfo.getUserId())
	                         	{
	                         		l.OwnerId = OID1 ;
	                         	}
	                        }
						}
					                   
					}
				}           
			}
		}
	}
	catch (Exception e){
		system.debug('Generic Exception Caught : ' + e.getMessage());
	}
}
//method RestrictChangeOwnership ends


/*
method InsertUpdateReferral begins
Author - Jayant
Invocation - this method is called from LeadProcess trigger on After Insert and After Update events
Date Created - 21st July 2011
Date Last Modified - 21st July 2011
Input - trigger.new and trigger.newMap
Output - void
Purpose - Inserts and Updates Referral records, Inserts Payout Percentage records and Updates Channel Partner records
*/
public static void InsertUpdateReferral(list <Lead> lstLead, map <Id, Lead> mapLead){
	try
	{
		list <Referrals__c> lstRef = new list <Referrals__c> ();
		list <Referrals__c> lstUpdRef = new list <Referrals__c> ();
		list <Referrals__c> lstInsRef = new list <Referrals__c> ();	
		list <Payout_Percentage__c> lstPP = new list <Payout_Percentage__c> ();
		list <Channel_Partner__c> lstCP = new list <Channel_Partner__c> ();
		list <Lead> lstLD = new list <Lead> ();
		list <Payout_Percentage__c> lstPPer = new list <Payout_Percentage__c> ();
		list <Payout_Master__c> lstPM = new list <Payout_Master__c> ();
		map <Id, Integer> mapCPLeadCount = new map <Id, Integer> ();
		map <Id, Integer> mapCPConvLeadCount = new map <Id, Integer> ();
		map <Id, Payout_Percentage__c> mapLeadPP = new map <Id, Payout_Percentage__c> ();
		map <String, Decimal> mapCPTypePPer = new map <String, Decimal> ();
		map <String, map<String, Decimal>> mapPropTypeCPTypePPer = new map <String, map<String, Decimal>> ();
		map <Id, String> mapCPCPType = new map <Id, String> (); 
		set <Id> setLeadCP = new set <Id> ();
		set <Channel_Partner__c> setUpdCP = new set <Channel_Partner__c> ();
			
		for (Lead l : lstLead)
		{
			setLeadCP.add(l.Channel_Partner__c);
		}
		
		lstRef = [select Id, Lead_Status__c, Referred_Customer__c, Referral_Name__c from Referrals__c where Referred_Customer__c in: mapLead.keyset() limit 1000];
		lstPP = [select Id, Lead__c from Payout_Percentage__c where Lead__c in: mapLead.keyset() limit 1000];
		lstCP = [select Id, Type_of_Channel_Partner__c, Total_No_Of_Leads__c, No_Of_Converted_Leads__c from Channel_Partner__c where ID in: setLeadCP limit 1000];
		lstLD = [select Id, IsConverted, Channel_Partner__c from Lead where Channel_Partner__c in: setLeadCP order by Channel_Partner__c limit 1000];
		lstPM = [select Id, Payout_Percentage__c, Property_Type__c, Channel_Partner_Type__c from Payout_Master__c order by Property_Type__c limit 1000];
		Integer totLDCount = 0;
		Integer totConvLDCount = 0;
		Id baseCPID = null;
		string baseProp = null;
		if(lstLD.size() > 0)
		baseCPID = lstLD[0].Channel_Partner__c;
		if(lstPM.size() > 0)
		baseProp = lstPM[0].Property_Type__c; 
	
		for (Lead l : lstLead)
		{		
			Boolean found = false;
			if(l.LeadSource == 'Existing Customer' &&  l.Referral_Name__c != null)
			{
				for (Referrals__c r : lstRef)
				{
					if(r.Referred_Customer__c == l.Id && r.Referral_Name__c == l.Referral_Name__c)
					{
						r.Lead_Status__c = l.Status;
						lstUpdRef.add(r);
						found = true;
						break; 
					}
				}
				if(!found)
				{
					Referrals__c newRef =  new Referrals__c (Lead_Status__c = l.Status, Referral_Name__c = l.Referral_Name__c, Referred_Customer__c = l.Id);
					lstInsRef.add(newRef);
				}
			}
			
			for (Lead ld : lstLD)
			{
				if (ld.Channel_Partner__c == baseCPID)
				{
					totLDCount++;
					if (ld.IsConverted == true)
					totConvLDCount++;
				}
				else
				{
					mapCPLeadCount.put(baseCPID, totLDCount);
					mapCPConvLeadCount.put(baseCPID, totConvLDCount);
					baseCPID = ld.Channel_Partner__c;
					totLDCount = 1;
					if (ld.IsConverted == true)
					totConvLDCount = 1;
					else
					totConvLDCount = 0;				
				}
			}
			mapCPLeadCount.put(baseCPID, totLDCount);
			mapCPConvLeadCount.put(baseCPID, totConvLDCount);
			
			for (Channel_Partner__c cp : lstCP)
			{
				cp.Total_No_Of_leads__c = mapCPLeadCount.get(cp.Id);
				cp.No_of_Converted_Leads__c = mapCPConvLeadCount.get(cp.Id);
				mapCPCPType.put(cp.Id, cp.Type_of_Channel_Partner__c);			
			}		
			
			for (Payout_Percentage__c pp : lstPP)
			{
				mapLeadPP.put(pp.Lead__c, pp);		
			}
			
			for (Payout_Master__c pm : lstPM)
			{
				if(baseProp == pm.Property_Type__c)
				{
					mapCPTypePPer.put(pm.Channel_Partner_Type__c, pm.Payout_Percentage__c);
				}
				else
				{
					mapPropTypeCPTypePPer.put(baseProp, mapCPTypePPer);
					baseProp = pm.Property_Type__c;
					mapCPTypePPer.clear();
					mapCPTypePPer.put(pm.Channel_Partner_Type__c, pm.Payout_Percentage__c);				
				}				
			}
			mapPropTypeCPTypePPer.put(baseProp, mapCPTypePPer);
				
			if(l.LeadSource == 'Channel Partner' &&  l.Channel_Partner__c != null && l.Project_Type__c != null && !mapLeadPP.keyset().contains(l.Id))
			{
				Payout_percentage__c PPer = new  Payout_percentage__c (Lead__c = l.ID, Channel_Partner__c = l.Channel_Partner__c, Payout_Percentage__c = mapPropTypeCPTypePPer.get(l.Project_Type__c).get(mapCPCPType.get(l.Channel_Partner__c)));
				lstPPer.add(PPer);
			}
		}
		      
		if(lstInsRef.size() > 0)
		Database.Insert(lstInsRef, false);
		if(lstUpdRef.size() > 0)
		Database.Update(lstUpdRef, false);
		if(lstCP.size() > 0)
		Database.Update(lstCP, false);
		if(lstPPer.size() > 0)
		Database.Insert(lstPPer, false);
	}
	catch (Exception e){
		system.debug('Generic Exception Caught : ' + e.getMessage());
	}     
}
//method InsertUpdateReferral ends


/*
method CallAttemptToOppOnConversion begins
Author - Jayant
Invocation - this method is called from LeadProcess trigger on After Update event
Date Created - 21st July 2011
Date Last Modified - 23rd Sep 2011
Input - trigger.new
Output - void
Purpose - Creates Opportunities from Call Attempts during Lead Conversion based on certain criteria
*/
public static void CallAttemptToOppOnConversion (list <Lead> lstLead){
	try
	{
		Id LeadID, ProjectID, OpportunityID, AccountID;
		list <Call_Attempts__c> lstConvertToOpp = new list <Call_Attempts__c>();
		list <Opportunity> lstOpp = new list <Opportunity>();		
		Opportunity Opp = null;
    	Opportunity oppUpdate = null;
	    ID Record_type = null;
	    Date clsDate = null;
	    String fullName = null;
	    Opportunity opp_data = null;
    
	    for(Lead l : lstLead)
	    {
			if (l.IsConverted) 
	        {	      
		        LeadID = l.Id;
		        ProjectID = l.Project_name__c;
		        AccountID = l.ConvertedAccountId;
		        OpportunityID = l.ConvertedOpportunityId;
		        if (l.FirstName != null)
		            fullName = l.FirstName + ' ' + l.LastName ; 
		        else
		            fullName = l.LastName ;	      
	        }	    
	    }

	    if(OpportunityID != null && LeadID != null)
	    {
	    	opp_data = [Select RecordTypeId, CloseDate from Opportunity where Id =: OpportunityID];
	        
            clsDate = opp_data.CloseDate; 
            Record_type = opp_data.RecordTypeId;
            Integer flag2 = 0;
	
			for(Call_Attempts__c ca : [Select Name, Project_Name__c,Opportunity__c,Id,Project_Name__r.Name, CreatedDate from Call_Attempts__c where Lead__c =: LeadID and Opportunity__c = null order by CreatedDate desc])
			{
	        	Integer flag = 0;
	        	if(ca.project_name__c != ProjectID)
	        	{
	        		for(Integer i=0; i<lstOpp.Size(); i++)
	        		{
	            		if(lstOpp[i].Project_Name__c == ca.project_name__c)
	            		{
	                 		flag=1;
	            		}
	        		}
	        		
	        		if(flag != 1)
	        		{
		        		Opp=new Opportunity();
		        		Opp.Name = fullName + '-' + ca.Project_Name__r.Name;
		        		Opp.CloseDate = ClsDate;
		        		Opp.RecordTypeId = Record_type;
		        		Opp.StageName = 'Qualification';
		        		Opp.Project_Name__c = ca.Project_Name__c;	
		        		Opp.Last_Call_Attempt_Data__c = ca.Id;	        
		        		Opp.AccountId = AccountId;
		        		lstOpp.add(Opp);
	        		}
	        		
	                lstConvertToOpp.add(ca);	
	        	}
				else if(ca.project_name__c == ProjectID)
				{
	            	ca.Opportunity__c=OpportunityID;
	            	lstConvertToOpp.add(ca); 
	            	
	            	if (flag2 == 0)
	            	{
						oppUpdate = new Opportunity(Id = OpportunityID);
						oppUpdate.Last_Call_Attempt_Data__c = ca.Id;
						flag2 = 1;
					}	    
	        	}	
	    	}

			update lstConvertToOpp;

			if(lstOpp.size() > 0)
	        insert lstOpp; 

	      	if (oppUpdate != null)
			update oppUpdate;
	        
	        
			if(lstOpp.size() > 0) 
			{
				for(Integer i=0; i<lstOpp.size(); i++)
				{
					for(Integer j=0; j<lstConvertToOpp.size(); j++)
					{
						if(lstOpp[i].Project_Name__c == lstConvertToOpp[j].Project_Name__c)
						{
							lstConvertToOpp[j].Opportunity__c = lstOpp[i].Id;
						}	               
					}
				}
				update lstConvertToOpp;
			}
	    }
	}
	catch (Exception e)
		{
			system.debug('Generic Exception Caught : ' + e.getMessage());
		}	
}
//method CallAttemptToOppOnConversion ends

}