/*
Author - Jayant
Class Name - FlagDuplicateLead
Date Created - 28th July 2011
Date Last Modified - 15th Sept 2011
Purpose - This class contains the method that is called from LeadProcess trigger on Lead object.
It identifies and flags a lead record as duplicate based on criteria like Mobile Number, Record Type, and Project Name.
*/

public class FlagDuplicateLead {
  
/*
method findDuplicates begins
Author - Jayant
Invocation - this method is called from LeadProcess trigger on Before Insert event
Date Created - 28th July 2011
Date Last Modified - 15th Sept 2011
Input - trigger.new
Output - void
Purpose - sets a lead record as duplicate based on criteria like Mobile Number, Record Type, and Project Name.
*/

  public static void findDuplicates(list <Lead> lstLead){
  try
  {  
    Id recType = null;
    list <RecordType> lstRecType = new list <RecordType>();
    set <Lead> setLeads =  new set <Lead>();
    list <Lead> lstExtLeads = new list <Lead>();
    list <Opportunity> lstExtOpps = new list <Opportunity>();
    list <Account> lstExtAccs = new list <Account>();
    string leadQuery = '';
    string oppQuery = '';
    string accQuery = '';
    integer size = null;
    integer index = null;
    map <Id, string> mapRecTypes = new map <Id, string>();
    boolean projCheck = True;
    
   
    
    for (Lead l : lstLead)
    {
    
    system.debug('## Line 44 ' +l.Project_Name__c);
    system.debug('## Line 44 ' +l.ExistingProjectID__c);
    
      if (l.Project_Name__c == null && l.ExistingProjectID__c == null)
      {
        projCheck = False;
      }
    }
    
    system.debug('## Line 56 ' +projCheck );
    
    if (projCheck == True)
    {      
      lstRecType = [Select r.SobjectType, r.Name, r.Id From RecordType r where r.SobjectType = 'Lead'];
          
      if(lstRecType.size()>0)
      {
        //recType = lstRecType[0].Id;
        for (RecordType r : lstRecType)
        {
          if (r.Name == 'Duplicate')
          {
            recType = r.Id;
          }
          mapRecTypes.put(r.Id, r.Name);
        }
      }
    
      setLeads.addAll(lstLead);
      size = setLeads.size();
      index = 1;
      
      
      
      leadQuery = 'select ' + 
            'Id, Name, Mobile__c, Project_Interested__c, ExistingProjectID__c, Project__c, Project_Name__r.Name, RecordTypeId, RecordType.Name, isConverted ' +
            'from Lead ' +
            'where ' +
            'isConverted = false and isDuplicate__c != true and (' ;

      oppQuery = 'select ' +
             'Id, Name, Project_Name__c, Project_Name__r.Name, RecordTypeId, RecordType.Name, Account.Id, Account.Name, Account.Mobile_Phone__c ' +
             'from Opportunity ' +
             'where IsActive__c=true and ' +
             '( ' ;
             
      accQuery = 'select ' +
             'Id, Name, Mobile_Phone__c, RecordTypeId, RecordType.Name ' +
             'from Account ' +
             'where ' +
             '( ' ;
      
    system.debug('## leadQuery  ' +leadQuery );
    system.debug('## oppQuery ' +oppQuery );
    system.debug('## accQuery ' +accQuery );
      
      
                 
      if (size > 1)
      {
        for (Lead l : setLeads)
        {
          string likePhone = '\'' + l.Mobile__c + '\'';
          string pName = null;
          if (l.Project_Name__c != null)
          {
            pName = '\'' + l.Project_Name__c + '\'';
          }
          else
          {
            pName = '\'' + l.ExistingProjectID__c + '\'';
          }
          if (index<size)
          {

            leadQuery += 'Mobile__c = ' + likePhone + ' or ';
            
            oppQuery += '(Account.Mobile_Phone__c = ' + likePhone + ' and Project_Name__c = ' + pName + ' )' + ' or ';
            
            accQuery += 'Mobile_Phone__c = ' + likePhone + ' or ';
            
            index++;
          }
          else
          {

            leadQuery += 'Mobile__c = ' + likePhone + ' ) ' + 'order by CreatedDate Desc';
            
            oppQuery += '(Account.Mobile_Phone__c = ' + likePhone + ' and Project_Name__c = ' + pName + ' )' + ' ) ' + 'order by CreatedDate Desc';  
                      
            accQuery += 'Mobile_Phone__c = ' + likePhone + ' ) ' + 'order by CreatedDate Desc';    
          }
        }
      }
      else
      {
        for (Lead l : setLeads)
        {
          string likePhone = '\'' + l.Mobile__c + '\'';
          string pName = null;
          if (l.Project_Name__c != null)
          {
            pName = '\'' + l.Project_Name__c + '\'';
          }
          else
          {
            pName = '\'' + l.ExistingProjectID__c + '\'';
          }
          leadQuery += 'Mobile__c = ' + likePhone + ' ) ' + 'order by CreatedDate Desc';
          
          oppQuery += '(Account.Mobile_Phone__c = ' + likePhone + ' and Project_Name__c = ' + pName + ' )' + ' ) ' + 'order by CreatedDate Desc';
                  
          accQuery += 'Mobile_Phone__c = ' + likePhone + ' ) ' + 'order by CreatedDate Desc';
        }  
      }
      
      system.debug('@@## oppQuery is : ' + oppQuery + ' and leadQuery is : ' + leadQuery + ' accQuery is : ' + accQuery);
      lstExtLeads = Database.query(leadQuery);
      lstExtOpps = Database.query(oppQuery);
      lstExtAccs = Database.query(accQuery);
      
    system.debug('## lstExtLeads ' +lstExtLeads );
    system.debug('## lstExtOpps ' +lstExtOpps );
    system.debug('## lstExtAccs ' +lstExtAccs );
      
      
      for (Lead ld: lstExtLeads)
      {
      system.debug('## inside lead logic 1lstExtLeads ' +lstExtLeads );
      
        for (Lead l : lstLead)
        
        {
          //system.debug('ext type: ' + ld.RecordTypeId + ' new type: ' + l.RecordTypeId);
          
    system.debug('## Inside Lead FromVisitorForm__c  ' +l.FromVisitorForm__c);
    system.debug('## ld.Mobile__c  ' +ld.Mobile__c);
    system.debug('## l.Mobile__c ' +l.Mobile__c );
    system.debug('## ld.RecordTypeId ' +ld.RecordTypeId );
    system.debug('## l.RecordTypeId ' +l.RecordTypeId );
          
          if (l.FromVisitorForm__c == False && ld.Mobile__c == l.Mobile__c && ld.RecordTypeId == l.RecordTypeId)
          {
            l.RecordTypeId = recType;
            l.Existing_Lead__c = ld.Id;   
            l.isDuplicate__c = True;
          }
          
        }
      }
      
      
      
      for (Opportunity opp: lstExtOpps)
      {
        system.debug('Came here and lstExtOpps is : ' +lstExtOpps );
        for (Lead l : lstLead)
        {
          //system.debug('Opp ' + opp.RecordType.Name + ' Lead ' + l.RecordType.Name + ' map value ' + mapRecTypes.get(l.RecordTypeId));
          //if (opp.Account.Mobile_Phone__c == l.Mobile__c && opp.RecordType.Name == l.RecordType.Name)
          if (l.FromVisitorForm__c == False && opp.Account.Mobile_Phone__c == l.Mobile__c && opp.RecordType.Name == mapRecTypes.get(l.RecordTypeId))
          {
            l.RecordTypeId = recType;
            l.Existing_Opportunity__c = opp.Id;   
            l.isDuplicate__c = True;
          }
        }
      }
      
      for (Account acc: lstExtAccs)
      {
        for (Lead l : lstLead)
        {
          //system.debug('Acc ' + acc.RecordType.Name + ' Lead ' + l.RecordType.Name + ' map value ' + mapRecTypes.get(l.RecordTypeId));
          //if (acc.Mobile_Phone__c == l.Mobile__c && ((l.RecordType.Name == 'Residential' && acc.RecordType.Name == 'Person Account') || (l.RecordType.Name == 'Commercial and Retail' && acc.RecordType.Name == 'Business Account')))
          if (l.FromVisitorForm__c == False && acc.Mobile_Phone__c == l.Mobile__c && ((mapRecTypes.get(l.RecordTypeId) == 'Residential' && acc.RecordType.Name == 'Person Account') || (mapRecTypes.get(l.RecordTypeId) == 'Commercial and Retail' && acc.RecordType.Name == 'Business Account')))
          {
            l.RecordTypeId = recType;
            l.Existing_Account__c = acc.Id;   
            l.isDuplicate__c = True;
          }
        }
      }
      
      for (Lead l : lstLead)
      {
        Boolean isDuplicate = False;
        for (Lead dupLead : setLeads)
        {
            if(l.isDuplicate__c == False && isDuplicate == False && dupLead.FromVisitorForm__c == False && l.Mobile__c == dupLead.Mobile__c && l.RecordTypeId == dupLead.RecordTypeId)
            {
                isDuplicate = True;
            }
            else if (l.isDuplicate__c == False && isDuplicate == True && dupLead.FromVisitorForm__c == False && l.Mobile__c == dupLead.Mobile__c && l.RecordTypeId == dupLead.RecordTypeId)
              {
                l.RecordTypeId = recType;
                l.Existing_Lead__c = dupLead.Id;   
                l.isDuplicate__c = True;
              }
        }
      }
      
    }
  }
  catch (Exception e){
    system.debug('Generic Exception Caught : ' + e.getMessage());
  }
  }
  
  //method findDuplicates ends

/**************************** ADDED BY CG DEV TEAM ***************************************/
  @future  
  public static void findDuplicateLeads(set<Id> lstLeadIds){
  try
  {  
    Id recType = null;
    list <Lead> lstLead = new List<Lead>();
    list <RecordType> lstRecType = new list <RecordType>();
    set <Lead> setLeads =  new set <Lead>();
    list <Lead> lstExtLeads = new list <Lead>();
    list <Opportunity> lstExtOpps = new list <Opportunity>();
    list <Account> lstExtAccs = new list <Account>();
    string leadQuery = '';
    string oppQuery = '';
    string accQuery = '';
    integer size = null;
    integer index = null;
    map <Id, string> mapRecTypes = new map <Id, string>();
    boolean projCheck = True;
    set<string> leadmobilesset = new set<string>();
    set<Id> leadProjectset = new set<Id>();
      lstLead = [select Id,FromVisitorForm__c, Name, Mobile__c, Project_Interested__c, ExistingProjectID__c, Project__c, Project_Name__r.Name, RecordTypeId, RecordType.Name, isConverted from lead where id in:lstLeadIds];
      setLeads.addAll(lstLead);
      size = setLeads.size();
      index = 1;
   
    for (Lead l : lstLead)
    {
      if (l.Project_Name__c == null && l.ExistingProjectID__c == null)
      {
        projCheck = False;
      }
      leadmobilesset.add(l.Mobile__c);
      leadProjectset.add(l.Project_Name__c);
      leadProjectset.add(l.ExistingProjectID__c);     
    }
    
    if (projCheck == True)
    {      
      lstRecType = [Select r.SobjectType, r.Name, r.Id From RecordType r where r.SobjectType = 'Lead'];
          
      if(lstRecType.size()>0)
      {
        //recType = lstRecType[0].Id;
        for (RecordType r : lstRecType)
        {
          if (r.Name == 'Duplicate')
          {
            recType = r.Id;
          }
          mapRecTypes.put(r.Id, r.Name);
        }
      }

      String lstLeadIdsString = '(';
      for(Id s:lstLeadIds){
            lstLeadIdsString += '\''+s+'\',';
      }
      lstLeadIdsString +=')';

      leadQuery = 'select ' + 
            'Id, Name, Mobile__c, Project_Interested__c, ExistingProjectID__c, Project__c, Project_Name__r.Name, RecordTypeId, RecordType.Name, isConverted ' +
            'from Lead ' +
            'where ' +
            'id not in  '+lstLeadIdsString+' and '+
            'isConverted = false and isDuplicate__c != true and (' ;
            
      oppQuery = 'select ' +
             'Id, Name, Project_Name__c, Project_Name__r.Name, RecordTypeId, RecordType.Name, Account.Id, Account.Name, Account.Mobile_Phone__c ' +
             'from Opportunity ' +
             'where ' +
             '( ' ;
             
      accQuery = 'select ' +
             'Id, Name, Mobile_Phone__c, RecordTypeId, RecordType.Name ' +
             'from Account ' +
             'where ' +
             '( ' ;
                 
      if (size > 1)
      {
        for (Lead l : setLeads)
        {
          string likePhone = '\'' + l.Mobile__c + '\'';
          string pName = null;
          if (l.Project_Name__c != null)
          {
            pName = '\'' + l.Project_Name__c + '\'';
          }
          else
          {
            pName = '\'' + l.ExistingProjectID__c + '\'';
          }
          if (index<size)
          {
            leadQuery += 'Mobile__c = ' + likePhone + ' or ';
            
            oppQuery += '(Account.Mobile_Phone__c = ' + likePhone + ' and Project_Name__c = ' + pName + ' )' + ' or ';
            
            accQuery += 'Mobile_Phone__c = ' + likePhone + ' or ';
            
            index++;
          }
          else
          {
            leadQuery += 'Mobile__c = ' + likePhone + ' ) ' + 'order by CreatedDate Desc';
            
            oppQuery += '(Account.Mobile_Phone__c = ' + likePhone + ' and Project_Name__c = ' + pName + ' )' + ' ) ' + 'order by CreatedDate Desc';  
                      
            accQuery += 'Mobile_Phone__c = ' + likePhone + ' ) ' + 'order by CreatedDate Desc';    
          }
        }
      }
      else
      {
        for (Lead l : setLeads)
        {
          string likePhone = '\'' + l.Mobile__c + '\'';
          string pName = null;
          if (l.Project_Name__c != null)
          {
            pName = '\'' + l.Project_Name__c + '\'';
          }
          else
          {
            pName = '\'' + l.ExistingProjectID__c + '\'';
          }
          leadQuery += 'Mobile__c = ' + likePhone + ' ) ' + 'order by CreatedDate Desc';
          
          oppQuery += '(Account.Mobile_Phone__c = ' + likePhone + ' and Project_Name__c = ' + pName + ' )' + ' ) ' + 'order by CreatedDate Desc';
                  
          accQuery += 'Mobile_Phone__c = ' + likePhone + ' ) ' + 'order by CreatedDate Desc';
        }  
      }
      
      system.debug('oppQuery is : ' + oppQuery + ' and leadQuery is : ' + leadQuery + ' accQuery is : ' + accQuery);
      //lstExtLeads = Database.query(leadQuery);
      lstExtLeads = [select Id, Name, Mobile__c, Project_Interested__c, ExistingProjectID__c, Project__c, Project_Name__r.Name, RecordTypeId, RecordType.Name, isConverted from Lead where id not in : lstLeadIds and isConverted = false and isDuplicate__c != true and Mobile__c in:leadmobilesset order by CreatedDate Desc];
      //lstExtOpps = Database.query(oppQuery);
      lstExtOpps = [select Id, Name, Project_Name__c, Project_Name__r.Name, RecordTypeId, RecordType.Name, Account.Id, Account.Name, Account.Mobile_Phone__c from Opportunity where Account.Mobile_Phone__c in:leadmobilesset and Project_Name__c in:leadProjectset order by CreatedDate Desc];
      //lstExtAccs = Database.query(accQuery);
      lstExtAccs = [select Id, Name, Mobile_Phone__c, RecordTypeId, RecordType.Name from Account where  Mobile_Phone__c in:leadmobilesset order by CreatedDate Desc];
      for (Lead ld: lstExtLeads)
      {
        for (Lead l : lstLead)
        {
          //system.debug('ext type: ' + ld.RecordTypeId + ' new type: ' + l.RecordTypeId);
          if (l.FromVisitorForm__c == False && ld.Mobile__c == l.Mobile__c && ld.RecordTypeId == l.RecordTypeId )
          {

                    l.RecordTypeId = recType;
                    l.Existing_Lead__c = ld.Id;   
                    l.isDuplicate__c = True;            
          }
        }
      }
      
      for (Opportunity opp: lstExtOpps)
      {
        //system.debug('Came here and lstExtOpps is : ' +lstExtOpps );
        for (Lead l : lstLead)
        {
          //system.debug('Opp ' + opp.RecordType.Name + ' Lead ' + l.RecordType.Name + ' map value ' + mapRecTypes.get(l.RecordTypeId));
          //if (opp.Account.Mobile_Phone__c == l.Mobile__c && opp.RecordType.Name == l.RecordType.Name)
          if (l.FromVisitorForm__c == False && opp.Account.Mobile_Phone__c == l.Mobile__c && opp.RecordType.Name == mapRecTypes.get(l.RecordTypeId))
          {
            l.RecordTypeId = recType;
            l.Existing_Opportunity__c = opp.Id;   
                    l.isDuplicate__c = True;
          }
        }
      }
      
      for (Account acc: lstExtAccs)
      {
        for (Lead l : lstLead)
        {
          //system.debug('Acc ' + acc.RecordType.Name + ' Lead ' + l.RecordType.Name + ' map value ' + mapRecTypes.get(l.RecordTypeId));
          //if (acc.Mobile_Phone__c == l.Mobile__c && ((l.RecordType.Name == 'Residential' && acc.RecordType.Name == 'Person Account') || (l.RecordType.Name == 'Commercial and Retail' && acc.RecordType.Name == 'Business Account')))
          if (l.FromVisitorForm__c == False && acc.Mobile_Phone__c == l.Mobile__c && ((mapRecTypes.get(l.RecordTypeId) == 'Residential' && acc.RecordType.Name == 'Person Account') || (mapRecTypes.get(l.RecordTypeId) == 'Commercial and Retail' && acc.RecordType.Name == 'Business Account')))
          {
            l.RecordTypeId = recType;
            l.Existing_Account__c = acc.Id;   
                    l.isDuplicate__c = True;
          }
        }
      }
    
        //UPDATE THE FLAG CHANGES
        update lstLead;
    }
    
    
  }
  catch (Exception e){
    system.debug('Generic Exception Caught : ' + e.getMessage());
  }
  }
  
  //method findDuplicates ends
  
}