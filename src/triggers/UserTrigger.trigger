/*@Created by: Deepak Pudi 
     @Created Date:   19/3/2015  --
 
 <!-- ------------------------------------------------------------------------------
 | Modified By      | Modified Date       | Version        | Description         |
 --------------------------------------------------------------------------------
 |Deepak Pudi             6/5/2015             1.0          WhenEver user is created Widgets 
                                                             are created for particular User.
 --------------------------------------------------------------------------------
 |
 ------------------------------------------------------------------------------ -->*/
trigger UserTrigger on User (after insert) {
    
    if(trigger.isAfter && trigger.isInsert){
                
        list<Widget_Sequence__c> widgetsequence = new list<Widget_Sequence__c>();
        list<WidgetInfo__c> widgetinfolist = [select Name from WidgetInfo__c];
        
        list<Profile> profileList=[select id from profile where Name = 'Custom Overage High Volume Customer Portal' ];
        if(profileList.size()>0){
            for(User Userobj : trigger.new){
            if(UserObj.ProfileId==profileList[0].id) {  
                for(WidgetInfo__c widinfo : widgetinfolist ){
                   
	              widgetsequence.add(new Widget_Sequence__c(User__c=Userobj.id,
	                                                        Sequence_ClickCount__c=0,
	                                                        WidgetInfo__c=widinfo.id,
	                                                        RecordTypeId = Schema.SObjectType.Widget_Sequence__c.getRecordTypeInfosByName().get('Dynamic').getRecordTypeId()));
                     
                }
             }
            }
        }
        if(widgetsequence.size() > 0)
            insert widgetsequence;
            
    }
}