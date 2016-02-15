/*@Created by: Deepak Pudi 
     @Created Date:   19/3/2015  --
 
 <!-- ------------------------------------------------------------------------------
 | Modified By      | Modified Date       | Version        | Description         |
 --------------------------------------------------------------------------------
 |Sudeep                  8/5/2015             1.0
 |Deepak Pudi             27/5/2015            1.1         Changes for code to improve code coverage
 --------------------------------------------------------------------------------
 |
 ------------------------------------------------------------------------------ -->*/
trigger ProjectNametrigger on Project_Name__c(after insert) {
    list < WidgetInfo__c >  widgetnames = [select id, Name, Available_For__c from WidgetInfo__c];
    list < EnableDisable_widgets__c > EnableDisableWidget = new list < EnableDisable_widgets__c > ();
    list < Widget_Sequence__c > widgetSeq = new list < Widget_Sequence__c > ();
     
  
    //Soql Query on Widget seq.
     integer CSSsequence = 1;
    integer RMsequence = 1;
     map < string, integer > CustomSequenceMap = new map < string, integer > ();
   /*  list < Project_Name__c > SequenceForCustom = [select id, Name, OrderType__c, (select Sequence_ClickCount__c, Project_Name__c,
                                                  Sequence_for__c from Widget_Sequences__r where RecordType.name = 'Custom' ) from Project_Name__c ];

    for (Project_Name__c CustomWS: SequenceForCustom) {
        for (Widget_Sequence__c wSeq: CustomWS.Widget_Sequences__r) {
            system.debug('Widget_Sequences_ ===' + wSeq.Sequence_ClickCount__c);

            if (CustomSequenceMap.isEmpty() || (CustomSequenceMap.containsKey(CustomWS.id + '#&' + wSeq.Sequence_for__c) &&
                    CustomSequenceMap.get(CustomWS.id + '#&' + wSeq.Sequence_for__c) < Integer.ValueOf(wSeq.Sequence_ClickCount__c)))
                CustomSequenceMap.put(CustomWS.id + '#&' + wSeq.Sequence_for__c, Integer.ValueOf(wSeq.Sequence_ClickCount__c));
        }
    }*/
    for (Project_Name__c projectnames: trigger.new) {

        for (WidgetInfo__c Widgets: widgetnames) {

            EnableDisableWidget.add(new EnableDisable_widgets__c(Project_Name__c = projectnames.id, WidgetInfo__c = Widgets.id,
            isEnableForCustomer__c = ((widgets.Available_For__c == 'Both' || widgets.Available_For__c == 'CSS') ? true : false),
            isEnableForRM__c = ((widgets.Available_For__c == 'Both' || widgets.Available_For__c == 'RM') ? true : false)));
            
       // if (projectnames.OrderType__c == 'Custom'){
            if (Widgets.Available_For__c == 'RM' || Widgets.Available_For__c == 'Both') {
                        
                        widgetSeq.add(new Widget_Sequence__c(Sequence_for__c = 'RM',Project_Name__c=projectnames.id,
                            Sequence_ClickCount__c = CustomSequenceMap.containsKey(projectnames.id + '#&' + 'RM') ?
                                                            CustomSequenceMap.get(projectnames.id + '#&' + 'RM') + 1 :
                                                                1,
                            WidgetInfo__c = Widgets.id,
                            RecordTypeId = Schema.SObjectType.Widget_Sequence__c.getRecordTypeInfosByName().get('Custom').getRecordTypeId()
                        ));
                if(!CustomSequenceMap.containsKey(projectnames.id + '#&' + 'RM'))
                    CustomSequenceMap.put(projectnames.id + '#&' + 'RM', 1);
                else if(CustomSequenceMap.containsKey(projectnames.id + '#&' + 'RM'))
                    CustomSequenceMap.put(projectnames.id + '#&' + 'RM', CustomSequenceMap.get(projectnames.id + '#&' + 'RM') +1 ); 
            }
            if (Widgets.Available_For__c == 'CSS' || Widgets.Available_For__c == 'Both') {
                        
                        widgetSeq.add(new Widget_Sequence__c(Sequence_for__c = 'CSS',Project_Name__c=projectnames.id,
                            Sequence_ClickCount__c = CustomSequenceMap.containsKey(projectnames.id + '#&' + 'CSS') ?
                                                            CustomSequenceMap.get(projectnames.id + '#&' + 'CSS') + 1 :
                                                                1,
                            WidgetInfo__c = Widgets.id,
                            RecordTypeId = Schema.SObjectType.Widget_Sequence__c.getRecordTypeInfosByName().get('Custom').getRecordTypeId()
                        ));
                if(!CustomSequenceMap.containsKey(projectnames.id + '#&' + 'CSS'))
                    CustomSequenceMap.put(projectnames.id + '#&' + 'CSS', 1);
                else if(CustomSequenceMap.containsKey(projectnames.id + '#&' + 'CSS'))
                    CustomSequenceMap.put(projectnames.id + '#&' + 'CSS', CustomSequenceMap.get(projectnames.id + '#&' + 'CSS') +1 );   
            }
        }

    }
    
    if(EnableDisableWidget.size() > 0)
    	insert EnableDisableWidget;
    if(widgetSeq.size() > 0)
    	insert widgetSeq;

}