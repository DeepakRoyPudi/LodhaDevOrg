/*
Description:
Class is helper class for the WidgetInfoTrigger 
the class contains methods which insert records in diffrent objects 

 @Created by: Sudeep Kumar Dube 
 @Created Date: 26/3/2015
 
 --------------------------------------------------------------------------------
 | Modified By      | Modified Date       | Version        | Description         |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------

*/

Public class WidgetInfoTriggerHelper {
  
  public static final String str_CSS='CSS';
  public static final String str_RM='RM';
  public static final String str_Both='Both';
  
    //insert records in Enable Disable Widgets
    public void InsertEnableDisableWidget(List < WidgetInfo__c > new_widgets, List < Project_Name__c > plist) {

        List < EnableDisable_widgets__c > listofEnableDisable = new List < EnableDisable_widgets__c > ();

        for (WidgetInfo__c w: new_widgets) {
            //for all the projects 
            for (Project_Name__c proj: Plist) {
                //create enable disable object record for the projects  and widget
                if (w.Available_For__c != null && w.Available_For__c != '' && w.Available_For__c.equalsIgnoreCase(WidgetInfoTriggerHelper.str_RM)) {
                    EnableDisable_widgets__c enable_disable_widget = new EnableDisable_widgets__c();

                    enable_disable_widget.isEnableForRM__c = true;
                    enable_disable_widget.isEnableForCustomer__c = false;
                    enable_disable_widget.WidgetInfo__c = w.id;
                    enable_disable_widget.Project_Name__c = proj.id;

                    listofEnableDisable.add(enable_disable_widget);
                }

                if (w.Available_For__c != null && w.Available_For__c != '' && w.Available_For__c.equalsIgnoreCase(WidgetInfoTriggerHelper.str_CSS)) {
                    EnableDisable_widgets__c enable_disable_widget = new EnableDisable_widgets__c();

                    enable_disable_widget.isEnableForRM__c = false;
                    enable_disable_widget.isEnableForCustomer__c = true;
                    enable_disable_widget.WidgetInfo__c = w.id;
                    enable_disable_widget.Project_Name__c = proj.id;

                    listofEnableDisable.add(enable_disable_widget);
                }

                if (w.Available_For__c != null && w.Available_For__c != '' && w.Available_For__c.equalsIgnoreCase(WidgetInfoTriggerHelper.str_Both)) {
                    EnableDisable_widgets__c enable_disable_widget = new EnableDisable_widgets__c();

                    enable_disable_widget.isEnableForRM__c = true;
                    enable_disable_widget.isEnableForCustomer__c = true;
                    enable_disable_widget.WidgetInfo__c = w.id;
                    enable_disable_widget.Project_Name__c = proj.id;

                    listofEnableDisable.add(enable_disable_widget);
                }
            }

        }
        //insert records into enable disable object
        if (listofEnableDisable.size() > 0) { 
        try{
        insert listofEnableDisable;
           }catch(DmlException e){
             System.debug('The following exception has occurred: ' + e.getMessage());
            }
        }


    }

    //method for inserting widgets in widgets seq with Default record type  
    public void InsertWidgetSequenceDefaultType(List < WidgetInfo__c > new_widgets, List < Project_Name__c > plist) {

        //  Create List of Widge Seq.
        list < Widget_Sequence__c > widgetSeqList = new list < Widget_Sequence__c > ();
        //Soql Query on existing Max Widget seq. for RM and CSS 
        List < AggregateResult > OrgLevelwidgetsequencesRM = [SELECT Max(Sequence_ClickCount__c) FROM
        Widget_Sequence__c where RecordType.name = 'Default'
        and Sequence_for__c = 'RM'];

        List < AggregateResult > OrgLevelwidgetsequenceCSS = [SELECT Max(Sequence_ClickCount__c) FROM
        Widget_Sequence__c where RecordType.name = 'Default'
        and Sequence_for__c = 'CSS'];

        //Max Seq  for Rm and Css at org Level
        Decimal RMMaxSeq = 0;
        Decimal CSSMaxSeq = 0;

        //reset project id map with max seq if records available in corresponding projects for RM 
        if (OrgLevelwidgetsequencesRM.size() > 0 &&  OrgLevelwidgetsequencesRM[0].get('expr0') != null) {


            RMMaxSeq = (Decimal) OrgLevelwidgetsequencesRM[0].get('expr0');
         
        }

        if (OrgLevelwidgetsequencesRM.size() > 0 &&  OrgLevelwidgetsequenceCSS[0].get('expr0') != null) {
            CSSMaxSeq = (Decimal) OrgLevelwidgetsequenceCSS[0].get('expr0');
            
        }

        //creating the records of each widget sequence for each project
        for (WidgetInfo__c wid: new_widgets) {

            if (wid.Available_For__c != null && wid.Available_For__c != '' && wid.Available_For__c .equalsIgnoreCase(WidgetInfoTriggerHelper.str_RM )|| (wid.Available_For__c != null && wid.Available_For__c != '' && wid.Available_For__c.equalsIgnoreCase(WidgetInfoTriggerHelper.str_Both))) {
                Widget_Sequence__c ws = new Widget_Sequence__c();
                ws.WidgetInfo__c = wid.id;

                ws.Sequence_for__c = 'RM';
                ws.recordtypeid = Schema.SObjectType.Widget_Sequence__c.getRecordTypeInfosByName().get('Default').getRecordTypeId();
                Decimal seq = RMMaxSeq + 1;
                ws.Sequence_ClickCount__c = seq;
                widgetSeqList.add(ws);
                RMMaxSeq = seq;
            }

            if (wid.Available_For__c != null && wid.Available_For__c != '' && wid.Available_For__c .equalsIgnoreCase( WidgetInfoTriggerHelper.str_CSS) || wid.Available_For__c.equalsIgnoreCase(WidgetInfoTriggerHelper.str_Both)) {
                Widget_Sequence__c ws = new Widget_Sequence__c();
                ws.WidgetInfo__c = wid.id;

                ws.Sequence_for__c = 'CSS';
                ws.recordtypeid = Schema.SObjectType.Widget_Sequence__c.getRecordTypeInfosByName().get('Default').getRecordTypeId();
                Decimal seq = CSSMaxSeq + 1;
                ws.Sequence_ClickCount__c = seq;
                widgetSeqList.add(ws);
                CSSMaxSeq = seq;
            }

        }

        if (widgetSeqList.size() > 0) {
             try{ 
                insert widgetSeqList;
             }catch(DmlException e){
                 System.debug('The following exception has occurred: ' + e.getMessage());
             }
        }
    }


    //method for inserting widgets in widgets seq with custom record type  
    public void InsertWidgetSequenceCustomType(List < WidgetInfo__c > new_widgets, List < Project_Name__c > plist) {

        //  Create List of Widge Seq.
        list < Widget_Sequence__c > widgetSeqList = new list < Widget_Sequence__c > ();




        //Soql Query on existing Max Widget seq. for RM and CSS custom RecordType
        List < AggregateResult > projectLevelwidgetsequencesRM = 
            [SELECT project_Name__c, Max(Sequence_ClickCount__c) FROM
            Widget_Sequence__c 
            where RecordType.name = 'Custom'
            and Sequence_for__c = 'RM'
            group by project_name__c];

        List < AggregateResult > projectLevelwidgetsequenceCSS = 
            [SELECT project_Name__c, Max(Sequence_ClickCount__c) 
            FROM Widget_Sequence__c 
            where RecordType.name = 'Custom'
            and Sequence_for__c = 'CSS'
            group by project_name__c];

        //map project name id with Max Seq 
        Map < id, Decimal > ProjectIdMapWithMaxSeqRM = new Map < id, Decimal > ();
        Map < id, Decimal > ProjectIdMapWithMaxSeqCSS = new Map < id, Decimal > ();
        //assign map seq map value default for RM and CSS as 1. 
        //if any project not in wid seq object then this default value will be used and after used for a widgets
        //it should be incremented by one   
        for (Project_name__c pname: plist) {
            ProjectIdMapWithMaxSeqRM.put(pname.id, 0);
            ProjectIdMapWithMaxSeqCSS.put(pname.id, 0);
        }
        //reset project id map with max seq if records available in corresponding projects for RM 
        if (projectLevelwidgetsequencesRM.size() > 0) {
            for (AggregateResult ag: projectLevelwidgetsequencesRM) {

                ProjectIdMapWithMaxSeqRM.put((ID) ag.get('project_Name__c'), (Decimal) ag.get('expr0'));
            }
        }

        if (projectLevelwidgetsequenceCSS.size() > 0) {
            for (AggregateResult ag: projectLevelwidgetsequenceCSS) {
                ProjectIdMapWithMaxSeqCSS.put((ID) ag.get('project_Name__c'), (Decimal) ag.get('expr0'));
            }
        }

        //creating the records of each widget sequence for each project
        for (WidgetInfo__c wid: new_widgets) {

            for (Project_name__c pname: plist) {
                if (wid.Available_For__c != null && wid.Available_For__c != '' && 
                    wid.Available_For__c.equalsIgnoreCase(WidgetInfoTriggerHelper.str_RM) || 
                    wid.Available_For__c != null && wid.Available_For__c != '' && 
                    wid.Available_For__c.equalsIgnoreCase(WidgetInfoTriggerHelper.str_Both)) {
                    Widget_Sequence__c ws = new Widget_Sequence__c();
                    ws.WidgetInfo__c = wid.id;
                    ws.Project_Name__c = pname.id;
                    ws.Sequence_for__c = 'RM';
                    ws.recordtypeid = 
                        Schema.SObjectType.Widget_Sequence__c.getRecordTypeInfosByName().get('Custom').getRecordTypeId();
                    decimal seq = ProjectIdMapWithMaxSeqRM.get(pname.id) + 1;
                    ws.Sequence_ClickCount__c = seq;
                    widgetSeqList.add(ws);
                    ProjectIdMapWithMaxSeqRM.put(pname.id, seq);
                }

                if (wid.Available_For__c != null && wid.Available_For__c != '' && 
                        wid.Available_For__c.equalsIgnoreCase( WidgetInfoTriggerHelper.str_CSS) ||
                        wid.Available_For__c != null && wid.Available_For__c != '' && 
                        wid.Available_For__c .equalsIgnoreCase( WidgetInfoTriggerHelper.str_Both)) {
                    Widget_Sequence__c ws = new Widget_Sequence__c();
                    ws.WidgetInfo__c = wid.id;
                    ws.Project_Name__c = pname.id;
                    ws.Sequence_for__c = 'CSS';
                    ws.recordtypeid = 
                        Schema.SObjectType.Widget_Sequence__c.getRecordTypeInfosByName().get('Custom').getRecordTypeId();
                    decimal seq = ProjectIdMapWithMaxSeqCSS.get(pname.id) + 1;
                    ws.Sequence_ClickCount__c = seq;
                    widgetSeqList.add(ws);
                    ProjectIdMapWithMaxSeqCSS.put(pname.id, seq);
                }
            }

        }

        if (widgetSeqList.size() > 0){
         try{
         insert widgetSeqList;
            } catch(DmlException e){
             System.debug('The following exception has occurred: ' + e.getMessage());
             }    
        }
    }

  /*
    //method for inserting widgets in widgets seq for each user in dynamic record type with seq value for widget 0
    public void InsertWidgetSequenceDynamicType(List < WidgetInfo__c > new_widgets, List < User > UserList) {

        //  Create List of Widge Seq.
        list < Widget_Sequence__c > widgetSeqList = new list < Widget_Sequence__c > ();


        for (WidgetInfo__c wid: new_widgets) {

            for (user u: UserList) {
                Widget_Sequence__c ws = new Widget_Sequence__c();
                ws.WidgetInfo__c = wid.id;
                ws.User__c = u.id;
                ws.Sequence_ClickCount__c = 0;
                ws.recordtypeid = 
                    Schema.SObjectType.Widget_Sequence__c.getRecordTypeInfosByName().get('Dynamic').getRecordTypeId();
                widgetSeqList.add(ws);
            }

        }
        if (widgetSeqList.size() > 0){
         try{
         insert widgetSeqList;
            } catch(DmlException e){
             System.debug('The following exception has occurred: ' + e.getMessage());
            }
         }
         
         
    }
   */
}