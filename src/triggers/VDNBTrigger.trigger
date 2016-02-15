/*
* Description : VDNB Trigger
*
* Version     Date          Author             Description
* 1.0         08/12/2014    Anupam Agrawal     Intial Draft
*/

trigger VDNBTrigger on VDNB__c (after insert, after update, before insert, before update) 
{
	VDNBHandler objHandler = new VDNBHandler();
	
	if(trigger.isBefore)
	{
		if(trigger.isInsert)
		{
			System.debug('-------------------------inBeforeTrigger---');
			objHandler.onBeforeInsert(trigger.new);
		}
	}
	
	if(trigger.isAfter)
	{
		if(trigger.isInsert)
		{
			objHandler.onAfterInsert(trigger.new);
		}
	}
}