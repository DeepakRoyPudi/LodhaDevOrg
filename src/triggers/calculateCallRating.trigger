trigger calculateCallRating on Call_Attempts__c (after insert, after update) {
    
    list <Call_Attempts__c> lstCA = new list <Call_Attempts__c>();          //Insert
    list <Call_Attempts__c> lstCALC = new list <Call_Attempts__c>();        //Lead Conversion
    map <id, Call_Attempts__c> mapCAOld = new map <id, Call_Attempts__c>();     //Update - trigger.oldMap
    map <id, Call_Attempts__c> mapCANew = new map <id, Call_Attempts__c>();     //Update - trigger.newMap
    
    
    if (trigger.isAfter && trigger.isInsert)
    {   
        for (Call_Attempts__c c : trigger.new)
        {
            if (c.Opportunity__c != null)
            {
                lstCA.add(c);
            }
        }
            
        if (lstCA.size()>0)
        {
            CalculateCallRating.CalculateCallRatingInsert(lstCA);
        }
    }
    
    ////////////////////////////////////////////////////////////////////
    
    if (trigger.isAfter && trigger.isUpdate)
    {   
        for (Call_Attempts__c c : trigger.new)
        {
            if (c.Opportunity__c != null && trigger.oldMap.get(c.Id).Opportunity__c == null) //Lead Conversion
            {
                lstCALC.add(c);
                system.debug('Came here and c is : ' + c);
            }
            
            else if (c.Opportunity__c != null && trigger.oldMap.get(c.Id).Opportunity__c != null) //Normal Update
            {
                if (c.Opportunity__c == trigger.oldMap.get(c.Id).Opportunity__c)
                {
                    mapCANew.put(c.id, c);
                    mapCAOld.put(c.id, trigger.oldMap.get(c.Id));
                    system.debug('Came here in map and c is : ' + c);
                }
            }
        } 
        
        system.debug('lstCALC is : ' + lstCALC);
        system.debug('mapCANew is : ' + mapCANew);
        system.debug('mapCAOld is : ' + mapCAOld);
            
        if (lstCALC.size()>0)
        {
            system.debug('CalculateCallRating.recursionControl is : ' + CalculateCallRating.recursionControl);
            system.debug('lstCALC size is : ' + lstCALC.size() + ' and list is : ' + lstCALC);
            if (CalculateCallRating.recursionControlLC && CalculateCallRating.recursionControl)
            {
                CalculateCallRating.recursionControlLC = false;
                CalculateCallRating.recursionControl = false;   
            }               
            CalculateCallRating.CalculateCallRatingUpdateLC(lstCALC);            
        }
        
        if (mapCANew.size()>0)
        {
            system.debug('CalculateCallRating.recursionControl is : ' + CalculateCallRating.recursionControl);
            system.debug('mapCANew size is : ' + mapCANew.size() + ' and map is : ' + mapCANew); 
            system.debug('mapCAOld size is : ' + mapCAOld.size() + ' and map is : ' + mapCAOld);               
            CalculateCallRating.CalculateCallRatingUpdate(mapCANew, mapCAOld);          
        }
    }
                
}