/*
*    Description : "Atachement" Trigger Handler Helper class
*
*    Version            Date            Author            Description
*
*    1.0                25/08/2014      Anupam Agrawal     Initial Draft
*/

public with sharing class AttachmentHelper {
	
	public void avoidAttachmentDeletion(Map<Id, Attachment> mapOldIdToAttachment){
	    String strKeyPrefix = Booking_Payment_Transaction__c.sObjectType.getDescribe().getKeyPrefix();
        String profileName = [Select Id, Profile.Name from User where Id =: UserInfo.getUserId()].Profile.Name;

        if(profileName == 'Accounts Admin'){
            for(Attachment objAttachment : mapOldIdToAttachment.values()){
                if(String.valueOf(objAttachment.ParentId).startswith(strKeyPrefix))
                    objAttachment.addError('Insufficent Privilege: Cannot delete attachment.'); 
            }
        }
	}
}