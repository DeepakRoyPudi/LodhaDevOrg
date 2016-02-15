/*
*    Version            Date            Author            Description
*
*    1.0                25/08/2014      Anupam Agrawal     Initial Draft
*/

trigger AttachmentTrigger on Attachment (before delete){
   AttachmentHandler handler = new AttachmentHandler();   
   if(trigger.isBefore){
       if(trigger.isDelete){
          handler.onBeforeDelete(trigger.oldMap);
       }	
   }
}