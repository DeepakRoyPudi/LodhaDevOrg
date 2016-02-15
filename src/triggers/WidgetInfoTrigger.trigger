/*
Description:
this trigger work on after insert on widget info object , 
whenever the record insert in widgetinfo object , after the insert record 
also the record created for enabledisbale widget object 
and widget sequesce object with all record type. 

 @Created by: Sneha Patil 
 @Created Date: 17/03/2015
 
 --------------------------------------------------------------------------------
 | Modified By      | Modified Date       | Version        | Description         |
 --------------------------------------------------------------------------------
 | Sudeep K Dube     20/03/2015               IntialDraft    Correction in functionaity with creating helper class   
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------

*/




trigger WidgetInfoTrigger on WidgetInfo__c(After insert,Before insert,Before Update) {
 
  
 //check validate data and not duplicate in name field record in before trigger
 if(Trigger.isBefore){
   //validate data that data must not be blank
   for(WidgetInfo__c widget:Trigger.new){
    if(String.isBlank(widget.name) || String.isBlank(widget.Available_For__c) ){
       widget.addError('Name and Avaialable for fields not empty');
     }
   }
   //validate data that name field must be unique
   for(widgetInfo__c wid:[select name from WidgetInfo__c]){
     for(WidgetInfo__c widget:Trigger.new){
       if(wid.name.equalsIgnoreCase(widget.name)){
         widget.addError('Name must be unique , Name already exist');
       }
     }      
   }
       
   
 }
 else{
    
   if(Trigger.isInsert && Trigger.isAfter){
    // this trigger insert the configuration data when a new trigger is inserted. in following object 
    // 1. Enable disable object 
    // 2. Widget seq object  for three type of record type 1.dynamic 2.default 3.custom   

    //List of all projects for creating the data in enable disable object and wideget seq object(for three record types) 
    
    List < Project_Name__c > plist = [select id from Project_Name__c];

    //helper class for all the required operation to be performed 
    WidgetInfoTriggerHelper wftHelper = new WidgetInfoTriggerHelper();

    //this below method insert the record in enable and disable object 
    wftHelper.InsertEnableDisableWidget(Trigger.new, plist);

    //this below method insert the record in Default Record Type Widget Seq
    wftHelper.InsertWidgetSequenceDefaultType(Trigger.new, plist);

    //this below method insert the record in Custom Record Type Widget Seq
    wftHelper.InsertWidgetSequenceCustomType(Trigger.new, plist);

    //Soql Query on existing users 
   // List < User > UserList = [select id from user where Profile.Name = 'Custom Overage High Volume Customer Portal'];
    //this below method insert the record in Dynamic Record Type Widget Seq
   // wftHelper.InsertWidgetSequenceDynamicType(Trigger.new, UserList);
 }
 
 
 }
 
 
}