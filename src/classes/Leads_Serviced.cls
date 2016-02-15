public class Leads_Serviced {
	
	ApexPages.StandardSetController ssc;
	
	public Leads_Serviced(ApexPages.StandardSetController controller){			
			ssc = controller;	        
	}

	public PageReference mark(){
        PageReference pageRef = ApexPages.currentPage();
        string returnURL = ApexPages.currentPage().getParameters().get('retURL');
        
        list <Lead> lstLeads = new list <Lead> ();
        lstLeads = ssc.getSelected();

        if (lstLeads.size()>0)
        {
            for (Lead l : lstLeads)
            {
            	l.Serviced__c = True;
            }
            update lstLeads;
        }

		pageRef = new PageReference('/00Q' + '?' + returnURL);
		pageRef.setRedirect(true);
		return pageref;
	}
}