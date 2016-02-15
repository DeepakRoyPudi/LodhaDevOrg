/*
*    Description : "Atachement" Trigger Handler class
*
*    Version            Date            Author            Description
*
*    1.0                25/08/2014      Anupam Agrawal     Initial Draft
*/

public with sharing class AttachmentHandler {
	
	AttachmentHelper objHelper = new AttachmentHelper();
	public void onBeforeDelete(Map<Id, Attachment> mapOldIdToAttachment){
		objHelper.avoidAttachmentDeletion(mapOldIdToAttachment);
	}
}