public class CalculateCallRating {
    
    public static Boolean recursionControl = false;
    public static Boolean recursionControlLC = false;

    public static void CalculateCallRatingInsert(list <Call_Attempts__c> lstCA)
    {
    try
    {   
        map <string, string> mapStatusMapping = new map <string, string>();
        mapStatusMapping.put('Booking Done', 'Visit Done');
        mapStatusMapping.put('Follow up', 'Follow Up');
        mapStatusMapping.put('Lost', 'Lost');
        mapStatusMapping.put('Lost - Internal', 'Lost');
        mapStatusMapping.put('Meeting Done', 'Visit Done');
        mapStatusMapping.put('Meeting Fixed', 'Visit Confirmed');
        mapStatusMapping.put('No Show', 'No Show');
        mapStatusMapping.put('Open', 'Open');
        mapStatusMapping.put('Visit Confirmed', 'Visit Confirmed');
        mapStatusMapping.put('Visit Done', 'Visit Done');
        mapStatusMapping.put('Visit Proposed', 'Visit Proposed');
        
        ///////////////////////////////////////////////////////////////////////
        
        map <string, Call_Rating__c> mapCallRating = Call_Rating__c.getAll();
        system.debug('mapCallRating is : ' + mapCallRating);
        system.debug('mapCallRating keyset is : ' + mapCallRating.keyset());
        
        
        set <Id> setOppIds = new set <Id>();        
        list <Opportunity> lstOpp = new list <Opportunity>();
        set <Opportunity> setOpp = new set <Opportunity>(); 
        
        if (recursionControl == false)
        {
            recursionControl = true;            
        
            for (Call_Attempts__c ca : lstCA)
                {               
                    setOppIds.add(ca.Opportunity__c); 
                }
                
            lstOpp = [Select o.Name, o.Id, o.No_Show__c, o.Call_Rating__c, o.Call_Rating_ReadOnly__c, o.Last_Call_Date_New__c,
                        o.Follow_Up_Date_New__c, o.Call_Proposed_Date_of_Visit_New__c, o.Last_Call_Description_New__c,
                        o.Last_Call_Attempted_by_New__c, o.Last_Attempted_By_New__c, o.Last_Call_Attempt_Status_New__c, Send_Non_Contactable_SMS__c,
                            (Select Id, Name, Call_Attempt_Status__c, Attempted_By__c, Call_Attempted_by__c, Call_Date__c,
                                Description__c, Proposed_Date_of_Visit__c, Next_Action_Date__c, Call_Status__c
                                From R00NR0000000VhoWMAS__r order by CreatedDate desc) 
                        From Opportunity o where o.id in: setOppIds];
            
            for (Opportunity o : lstOpp)
                {
                    String lastCAS = null;
                    String currentCAS = null;
                    decimal current = null;
                    decimal change = null;
                    Call_Rating__c currentCR = null;
                    
                    if (o.Call_Rating_ReadOnly__c != null)
                    {
                        current = o.Call_Rating_ReadOnly__c;                    
                    }
                    
                    if (o.R00NR0000000VhoWMAS__r.size()==1)
                    {
                        lastCAS = 'Open';
                        current = 10;
                        system.debug('Came here 1');
                    }
                    else if (o.Last_Call_Attempt_Status_New__c != null)
                    {
                        lastCAS = o.Last_Call_Attempt_Status_New__c;
                        system.debug('Came here 2');                                            
                    }
                    else if (o.R00NR0000000VhoWMAS__r.size()>1)
                    {
                        lastCAS = o.R00NR0000000VhoWMAS__r[1].Call_Attempt_Status__c;   
                        system.debug('Came here 3');
                    }               
                    else
                    {
                        lastCAS = 'Open';
                        system.debug('Came here 4');
                    }
                    
                    system.debug('LastCAS is : ' + lastCAS);
                    currentCR = mapCallRating.get(mapStatusMapping.get(lastCAS));               
                                            
                    system.debug('currentCR : ' + currentCR);
                    
                    if (o.R00NR0000000VhoWMAS__r != null)
                    {
                        if (o.R00NR0000000VhoWMAS__r.size()>0)
                            {
                                system.debug('Opportunity is : ' + o + ' CAList is : ' + o.R00NR0000000VhoWMAS__r);
                                currentCAS = o.R00NR0000000VhoWMAS__r[0].Call_Attempt_Status__c;
                                o.Last_Call_Date_New__c = o.R00NR0000000VhoWMAS__r[0].Call_Date__c;
                                o.Follow_Up_Date_New__c = o.R00NR0000000VhoWMAS__r[0].Next_Action_Date__c;
                                o.Call_Proposed_Date_of_Visit_New__c = o.R00NR0000000VhoWMAS__r[0].Proposed_Date_of_Visit__c;
                                o.Last_Call_Description_New__c = o.R00NR0000000VhoWMAS__r[0].Description__c;
                                o.Last_Call_Attempted_by_New__c = o.R00NR0000000VhoWMAS__r[0].Call_Attempted_by__c;
                                o.Last_Attempted_By_New__c = o.R00NR0000000VhoWMAS__r[0].Attempted_By__c;
                                o.Last_Call_Attempt_Status_New__c = o.R00NR0000000VhoWMAS__r[0].Call_Attempt_Status__c;
                                o.No_Show__c = False;
                            }                       
                    }
                    system.debug('Current CAS : ' + currentCAS);
                    if (mapStatusMapping.get(currentCAS) == 'Open')
                            {   
                                change = currentCR.New_Status_Open__c;
                            }
                        else if (mapStatusMapping.get(currentCAS) == 'Follow Up')
                            {   
                                change = currentCR.New_Status_Follow_Up__c;
                            }
                        else if (mapStatusMapping.get(currentCAS) == 'Visit Proposed')
                            {   
                                change = currentCR.New_Status_VisitProposed__c;
                            }
                        else if (mapStatusMapping.get(currentCAS) == 'Visit Confirmed')
                            {   
                                change = currentCR.New_Status_VisitConfirmed__c;
                            }               
                        else if (mapStatusMapping.get(currentCAS) == 'Visit Done')
                            {   
                                change = currentCR.New_Status_VisitDone__c;
                            }
                        else if (mapStatusMapping.get(currentCAS) == 'Lost')
                            {   
                                change = currentCR.New_Status_Lost__c;
                            }
                        else if (mapStatusMapping.get(currentCAS) == 'No Show')
                            {   
                                change = currentCR.New_Status_No_Show__c;
                            }   
                            
                        //////////////////////////////////////////////////////////////////////////////
                            
                        if (change == 9)
                        {
                            o.Call_Rating__c = 0;
                        }
                        else if ((current + change)<0)
                        {
                            o.Call_Rating__c = 0;
                        }
                        else
                        {
                            o.Call_Rating__c = current + change;
                        }       
                    if(o.R00NR0000000VhoWMAS__r.size()>=2)
                    {
                        if(o.R00NR0000000VhoWMAS__r[0].Call_Status__c != 'Call Completed' && o.R00NR0000000VhoWMAS__r[1].Call_Status__c != 'Call Completed')
                        {
                            o.Send_Non_Contactable_SMS__c = True;
                        }
                        else
                        {
                            o.Send_Non_Contactable_SMS__c = False;
                        }
                    }

                 /*   if(o.R00NR0000000VhoWMAS__r[0].Call_Attempt_Status__c=='Visit Confirmed')
                    {
                        SendSMSController c = new SendSMSController();
                        c.scheduleSMS(o.Id, o.R00NR0000000VhoWMAS__r[0].Proposed_Date_of_Visit__c);
                    }
                 */
                }       
            
                if(lstOpp.size()>0)
                {           
                    setOpp.addAll(lstOpp);
                    lstOpp.clear();
                    lstOpp.addAll(setOpp);
                    database.update(lstOpp,false);
                }       
        }
        }
    catch (Exception e){
        system.debug('Generic Exception Caught : ' + e.getMessage());
        }
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public static void CalculateCallRatingUpdateLC(list <Call_Attempts__c> lstCALC)
    {
    try
    {
        map <string, string> mapStatusMapping = new map <string, string>();
        mapStatusMapping.put('Booking Done', 'Visit Done');
        mapStatusMapping.put('Follow up', 'Follow Up');
        mapStatusMapping.put('Lost', 'Lost');
        mapStatusMapping.put('Lost - Internal', 'Lost');
        mapStatusMapping.put('Meeting Done', 'Visit Done');
        mapStatusMapping.put('Meeting Fixed', 'Visit Confirmed');
        mapStatusMapping.put('No Show', 'No Show');
        mapStatusMapping.put('Open', 'Open');
        mapStatusMapping.put('Visit Confirmed', 'Visit Confirmed');
        mapStatusMapping.put('Visit Done', 'Visit Done');
        mapStatusMapping.put('Visit Proposed', 'Visit Proposed');
        
        ///////////////////////////////////////////////////////////////////////
        
        map <string, Call_Rating__c> mapCallRating = Call_Rating__c.getAll();
        
        set <Id> setOppIds = new set <Id>();        
        list <Opportunity> lstOpp = new list <Opportunity>();
        set <Opportunity> setOpp = new set <Opportunity>();     
                
        if (recursionControl == false)
        {
            recursionControl = true;
            recursionControlLC = true;
            
            for (Call_Attempts__c ca : lstCALC)
            {
                setOppIds.add(ca.Opportunity__c);           
            }
            
            lstOpp = [Select o.Name, o.Id, o.No_Show__c, o.Call_Rating__c, o.Call_Rating_ReadOnly__c, o.Last_Call_Date_New__c,
                o.Follow_Up_Date_New__c, o.Call_Proposed_Date_of_Visit_New__c, o.Last_Call_Description_New__c,
                o.Last_Call_Attempted_by_New__c, o.Last_Attempted_By_New__c, o.Last_Call_Attempt_Status_New__c,
                    (Select Id, Name, Call_Attempt_Status__c, Attempted_By__c, Call_Attempted_by__c, Call_Date__c,
                        Description__c, Proposed_Date_of_Visit__c , Next_Action_Date__c 
                        From R00NR0000000VhoWMAS__r order by CreatedDate desc) 
                From Opportunity o where o.id in: setOppIds];
            
            for (Opportunity o : lstOpp)
            {
                if (o.R00NR0000000VhoWMAS__r != null)
                    {
                        if (o.R00NR0000000VhoWMAS__r.size()>0)
                            {
                                o.Call_Rating__c = mapCallRating.get(mapStatusMapping.get(o.R00NR0000000VhoWMAS__r[0].Call_Attempt_Status__c)).Default__c;
                                o.Last_Call_Date_New__c = o.R00NR0000000VhoWMAS__r[0].Call_Date__c;
                                o.Follow_Up_Date_New__c = o.R00NR0000000VhoWMAS__r[0].Next_Action_Date__c;
                                o.Call_Proposed_Date_of_Visit_New__c = o.R00NR0000000VhoWMAS__r[0].Proposed_Date_of_Visit__c;
                                o.Last_Call_Description_New__c = o.R00NR0000000VhoWMAS__r[0].Description__c;
                                o.Last_Call_Attempted_by_New__c = o.R00NR0000000VhoWMAS__r[0].Call_Attempted_by__c;
                                o.Last_Attempted_By_New__c = o.R00NR0000000VhoWMAS__r[0].Attempted_By__c;
                                o.Last_Call_Attempt_Status_New__c = o.R00NR0000000VhoWMAS__r[0].Call_Attempt_Status__c;
                                o.No_Show__c = False;
                            }
                    }
            }
            
            if(lstOpp.size()>0)
                {           
                    setOpp.addAll(lstOpp);
                    lstOpp.clear();
                    lstOpp.addAll(setOpp);
                    database.update(lstOpp,false);
                }
        }
    }
    catch (Exception e){
        system.debug('Generic Exception Caught : ' + e.getMessage());
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    public static void CalculateCallRatingUpdate(map <id, Call_Attempts__c> mapCANew, map <id, Call_Attempts__c> mapCAOld)
    {
    try
    {   
        boolean Status_Flag = False;  //Added by CGDev Team - 03/10/2011
        string Prev_CA_Status;   //Added by CGDev Team - 05/10/2011
        string New_CA_Status;   //Added by CGDev Team - 03/10/2011
        
        map <string, string> mapStatusMapping = new map <string, string>();
        mapStatusMapping.put('Booking Done', 'Visit Done');
        mapStatusMapping.put('Follow up', 'Follow Up');
        mapStatusMapping.put('Lost', 'Lost');
        mapStatusMapping.put('Lost - Internal', 'Lost');
        mapStatusMapping.put('Meeting Done', 'Visit Done');
        mapStatusMapping.put('Meeting Fixed', 'Visit Confirmed');
        mapStatusMapping.put('No Show', 'No Show');
        mapStatusMapping.put('Open', 'Open');
        mapStatusMapping.put('Visit Confirmed', 'Visit Confirmed');
        mapStatusMapping.put('Visit Done', 'Visit Done');
        mapStatusMapping.put('Visit Proposed', 'Visit Proposed');
        
        ///////////////////////////////////////////////////////////////////////
        
        map <string, Call_Rating__c> mapCallRating = Call_Rating__c.getAll();
        system.debug('mapCallRating is : ' + mapCallRating);
        system.debug('mapCallRating keyset is : ' + mapCallRating.keyset());
        
        set <Id> setOppIds = new set <Id>();        
        list <Opportunity> lstOpp = new list <Opportunity>();
        set <Opportunity> setOpp = new set <Opportunity>(); 
        
        if (recursionControl == false)
        {
            recursionControl = true;            
        
            for (Call_Attempts__c ca : mapCANew.values())
                {               
                    setOppIds.add(ca.Opportunity__c);
                }
                
            lstOpp = [Select o.Name, o.Id, o.No_Show__c, o.Call_Rating__c, o.Call_Rating_ReadOnly__c, o.Last_Call_Date_New__c,
                        o.Follow_Up_Date_New__c, o.Call_Proposed_Date_of_Visit_New__c, o.Last_Call_Description_New__c,
                        o.Last_Call_Attempted_by_New__c, o.Last_Attempted_By_New__c, o.Last_Call_Attempt_Status_New__c,o.CA_StatusFlag__c,
                            (Select Id, Name, Call_Attempt_Status__c, Attempted_By__c, Call_Attempted_by__c, Call_Date__c,
                                Description__c, Proposed_Date_of_Visit__c , Next_Action_Date__c 
                                From R00NR0000000VhoWMAS__r order by CreatedDate desc) 
                        From Opportunity o where o.id in: setOppIds]; //Added CA_StatusFlag__c by CGDev Team - 05/10/2011
            
            for (Opportunity o : lstOpp)
                {
                    String lastCAS = null;
                    String currentCAS = null;
                    decimal current = null;
                    decimal change = null;
                    Call_Rating__c currentCR = null;
                    
                    if (o.Call_Rating_ReadOnly__c != null)
                    {
                        /* Changes by CG Dev Team
                         * Start: Changes to capture current Call Rating
                         */
                        
                        New_CA_Status = mapCANew.get(o.R00NR0000000VhoWMAS__r[0].Id).Call_Attempt_Status__c; 
                        Prev_CA_Status = mapCANew.get(o.R00NR0000000VhoWMAS__r[0].Id).Previous_Call_Attempt_Status__c; 
                        Decimal Prev_CA_Rating = mapCANew.get(o.R00NR0000000VhoWMAS__r[0].Id).Previous_Call_Attempt_Status_Rating__c; 
                        current = Prev_CA_Rating;
                        
                        if(Prev_CA_Status != New_CA_Status)
                        {
                            o.CA_StatusFlag__c = False;
                        }

                        /* End: Changes to capture current Call Rating */
                    }
                    
                    if (o.Last_Call_Attempt_Status_New__c != null)
                    {
                        //lastCAS = o.Last_Call_Attempt_Status_New__c;
                        lastCAS = Prev_CA_Status;           //Added by CGDev Team - 05/10/2011
                        system.debug('Came here update 1');                                         
                    }
                    else
                    {
                        lastCAS = mapCAOld.get(o.R00NR0000000VhoWMAS__r[0].Id).Call_Attempt_Status__c;  
                        system.debug('Came here update 2');
                    }               
                
                    
                    system.debug('LastCAS is : ' + lastCAS);
                    currentCR = mapCallRating.get(mapStatusMapping.get(lastCAS));               
                                            
                    system.debug('currentCR : ' + currentCR);
                    
                    if (mapCANew.containsKey(o.R00NR0000000VhoWMAS__r[0].Id))
                    {
                        if (o.R00NR0000000VhoWMAS__r != null) 
                        {
                                    system.debug('Opportunity is : ' + o + ' CAList is : ' + o.R00NR0000000VhoWMAS__r);
                                    currentCAS = mapCANew.get(o.R00NR0000000VhoWMAS__r[0].Id).Call_Attempt_Status__c;
                                    o.Last_Call_Date_New__c = o.R00NR0000000VhoWMAS__r[0].Call_Date__c;
                                    o.Follow_Up_Date_New__c = mapCANew.get(o.R00NR0000000VhoWMAS__r[0].Id).Next_Action_Date__c;
                                    o.Call_Proposed_Date_of_Visit_New__c = mapCANew.get(o.R00NR0000000VhoWMAS__r[0].Id).Proposed_Date_of_Visit__c;
                                    o.Last_Call_Description_New__c = mapCANew.get(o.R00NR0000000VhoWMAS__r[0].Id).Description__c;
                                    o.Last_Call_Attempted_by_New__c = mapCANew.get(o.R00NR0000000VhoWMAS__r[0].Id).Call_Attempted_by__c;
                                    o.Last_Attempted_By_New__c = mapCANew.get(o.R00NR0000000VhoWMAS__r[0].Id).Attempted_By__c;
                                    o.Last_Call_Attempt_Status_New__c = mapCANew.get(o.R00NR0000000VhoWMAS__r[0].Id).Call_Attempt_Status__c;
                                    o.No_Show__c = False;
                        }
                        system.debug('Current CAS : ' + currentCAS);
                        if (mapStatusMapping.get(currentCAS) == 'Open')
                                {   
                                    change = currentCR.New_Status_Open__c;
                                }
                            else if (mapStatusMapping.get(currentCAS) == 'Follow Up')
                                {   
                                    change = currentCR.New_Status_Follow_Up__c;
                                }
                            else if (mapStatusMapping.get(currentCAS) == 'Visit Proposed')
                                {   
                                    change = currentCR.New_Status_VisitProposed__c;
                                }
                            else if (mapStatusMapping.get(currentCAS) == 'Visit Confirmed')
                                {   
                                    change = currentCR.New_Status_VisitConfirmed__c;
                                }               
                            else if (mapStatusMapping.get(currentCAS) == 'Visit Done')
                                {   
                                    change = currentCR.New_Status_VisitDone__c;
                                }
                            else if (mapStatusMapping.get(currentCAS) == 'Lost')
                                {   
                                    change = currentCR.New_Status_Lost__c;
                                }
                            else if (mapStatusMapping.get(currentCAS) == 'No Show')
                                {   
                                    change = currentCR.New_Status_No_Show__c;
                                }                               
                                
                        system.debug('current : ' + current);
                        system.debug('change : ' + change);
                        //////////////////////////////////////////////////////////////////////////////
                            
                        if (change == 9)
                        {
                            o.Call_Rating__c = 0;
                        }
                        else if ((current + change)<0)
                        {
                            o.Call_Rating__c = 0;
                        }
                        /* Changes by CG Dev Team
                         * Start: Changes to retain old Call Rating
                         */
                        else if(!o.CA_StatusFlag__c)
                        {
                            
                            o.Call_Rating__c = current + change;
                            system.debug('o.Call_Rating__c' + o.Call_Rating__c);
                        }  
  
                        /* End: Changes to retain old Call Rating */
                    }
                    /* Changes by CG Dev Team
                     * Start: Changes to retain old Call Rating
                     */
                     
                    if(Prev_CA_Status != New_CA_Status)
                    {
                        o.CA_StatusFlag__c = False;
                    }
                    else{
                        o.CA_StatusFlag__c = True;
                    }
                    
                    /* End: Changes to retain old Call Rating */
                }       
                
                if(lstOpp.size()>0)
                {       
                    setOpp.addAll(lstOpp);
                    lstOpp.clear();
                    lstOpp.addAll(setOpp);
                    database.update(lstOpp,false);
                }       
            }
        }
    catch (Exception e){
        system.debug('Generic Exception Caught : ' + e.getMessage());
        }
    }

}