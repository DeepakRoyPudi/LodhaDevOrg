/*
* Description : VDNB Trigger Handler
*
* Version     Date          Author             Description
* 1.0         08/12/2014    Anupam Agrawal     Intial Draft
*/

public class VDNBHandler 
{
	VDNBHelper objVDNBHelper = new VDNBHelper();
	public void onBeforeInsert(List<VDNB__c> lstNewVDNB)
	{
		objVDNBHelper.populateOtherValue(lstNewVDNB);
	}
	public void onAfterInsert(List<VDNB__c> lstNewVDNB)
	{
		objVDNBHelper.updateOpportunityWithLastVDNB(lstNewVDNB);
	}
}