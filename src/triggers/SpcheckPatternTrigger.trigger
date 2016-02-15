trigger SpcheckPatternTrigger on View_type_Assignment__c (before insert, before update) {
public list<View_type_Assignment__c> ListOfAssignment  = new list<View_type_Assignment__c>();
Set<Id> WingID = new Set<Id>();
Map<String, View_type_Assignment__c> old_view = new Map<String, View_type_Assignment__c>();
  for (View_type_Assignment__c vta: Trigger.New) {
           if(vta.Wing__c != null)
           {
             WingID.add(vta.Wing__c);
           }
        }    
        ListOfAssignment=[select id, RecordTypeId, Pattern__c, Column_Index__c, From__c, To__c, Wing__c from View_type_Assignment__c where Wing__c=:WingID] ;
        for (View_type_Assignment__c vta_old: ListOfAssignment) {
            old_view.put(vta_old.Column_Index__c + vta_old.Wing__c, vta_old);
        }
        
        system.debug('ListOfAssignment -->' + ListOfAssignment.size());
    
        integer i = 0;
        for (View_type_Assignment__c vta_new : Trigger.New) {  
            if(old_view.get(vta_new.Column_Index__c + vta_new.Wing__c) != NULL){
                if(old_view.get(vta_new.Column_Index__c + vta_new.Wing__c).Pattern__c == 'Range' && vta_new.Pattern__c == 'Range' && old_view.get(vta_new.Column_Index__c + vta_new.Wing__c).RecordTypeId == vta_new.RecordTypeId && old_view.get(vta_new.Column_Index__c + vta_new.Wing__c).Column_Index__c == vta_new.Column_Index__c) {
                    if((vta_new.From__c >= old_view.get(vta_new.Column_Index__c + vta_new.Wing__c).From__c && vta_new.To__c <= old_view.get(vta_new.Column_Index__c + vta_new.Wing__c).From__c) || (vta_new.From__c >= old_view.get(vta_new.Column_Index__c + vta_new.Wing__c).To__c && vta_new.To__c <= old_view.get(vta_new.Column_Index__c + vta_new.Wing__c).To__c))
                    {
                        Trigger.New[i].addError('Please avoid overlapping Floor range.');
                    }
                }
            }
            i++;
        }
}