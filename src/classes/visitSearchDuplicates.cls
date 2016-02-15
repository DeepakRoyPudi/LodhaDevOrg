public class visitSearchDuplicates{

        public String Phone{get;set;}
        public String Project{get;set;}
        public String ProjectName{get;set;}
        public Boolean showLeadList{get;set;}
        public Boolean showOppList{get;set;}
        public Boolean showAccList{get;set;}
        public Boolean showErrorMsg{get;set;}
        public Boolean isLeadListNull{get;set;}
        public Boolean isOppListNull{get;set;}
        public Boolean isAccListNull{get;set;}
        public List <Lead> lstExistingLead{get;set;}
        public List <Opportunity> lstExistingOpp{get;set;}
        public List <Account> lstExistingAcc{get;set;}
        List<Account> accountwithopportunity{get;set;}
        List<Account> accountwithoutopportunity{get;set;}
        public List <Project_Name__c> lstProjects{get;set;}
        public ApexPages.StandardController sc;
        public Lead myLead = new Lead();
        String cRTId = ApexPages.CurrentPage().getParameters().get('RecordType');
        public RecordType accrectype{get;set;}
        String cRTName = null;
        String actRTName = null;
        String pRTName = null;
                            
        public visitSearchDuplicates(ApexPages.StandardController ctr)
        {
           this.sc = ctr;                               
        }
        
        public void search()
        {
                
            showLeadList=false;
            showOppList=false;
            showAccList=false;
            showErrorMsg=false; 
            isLeadListNull=false;
            isOppListNull=false;
            isAccListNull=false;
            lstExistingLead = new List <Lead>();
            lstExistingOpp = new List <Opportunity>();
            lstExistingAcc = new List <Account>();
            accountwithopportunity = new List <Account>();
            accountwithoutopportunity= new List <Account>();
            list <RecordType> lstRecType = new list <RecordType>();
            list <RecordType> lstRecT = new list <RecordType>();
            list <Project_Name__c> lstPrj = new list <Project_Name__c>();
            myLead = (Lead) sc.getRecord();
            Project = myLead.Project_Name__c;
                        
            if (cRTId == null || cRTId == '')
            {              
              lstPrj = [Select Id, Record_Type__c, Name from Project_Name__c where Id =: Project limit 1];
              if (lstPrj.size()>0)
              {
                pRTName = lstPrj[0].Record_Type__c;
              }           
              lstRecT = [Select r.SobjectType, r.Name, r.Id From RecordType r where r.SobjectType = 'Lead' and r.Name=: pRTName Limit 1]; 
              if (lstRecT.size()>0)
              {
                cRTId = lstRecT[0].Id;
              }                
            }
            
            lstRecType = [Select r.SobjectType, r.Name, r.Id From RecordType r where r.SobjectType = 'Lead' and r.Id =: cRTId Limit 1];  
                    
            if (lstRecType.size()>0)
            {
                cRTName = lstRecType[0].Name;
                
                if (cRTName == 'Residential')
                {
                    actRTName = 'Person Account';
                }
                else
                {
                    actRTName = 'Business Account';
                }
            } 
            
            
            
            if(Project != null || Project != '')
            {
                lstProjects = [select Id, Name from Project_Name__c where Id =: Project limit 1];
                if(lstProjects.size()>0)                             
                {
                    ProjectName = lstProjects[0].Name;
                }                       
            }
             /*   Modified by CG Dev Team 19/10/2011
             *   Start:Changes to Search for the Phone and Project field before querying
             */ 
            if(Phone == null || Phone == '' || Project == null || Project == '')
            {
                showErrorMsg=true; 
                showLeadList=false;
                showOppList=false;
                showAccList=false;                              
                isLeadListNull=false;
                ApexPages.Message err = new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter both Mobile/Phone & Project and click Search');
                ApexPages.addMessage(err);                  
            }
            //Start:Changes to Search for the Phone and Project field before querying
            else
            {
            lstExistingLead = [select Id, Name, Mobile__c, LeadCreatedOn__c, LeadSource, Status, CreatedDate, Project_Interested__c, Project__c, Project_Name__r.Name, isConverted,Phone,Office_Phone__c,Mobile1__c,
                         ConvertedOpportunityId, ConvertedAccountId, ConvertedContactId, RecordTypeId, RecordType.Name, isDuplicate__c,
                         Existing_Lead__c, Existing_Opportunity__c, Existing_Account__c, Existing_Lead__r.RecordType.Name, 
                         Existing_Opportunity__r.RecordType.Name,  Existing_Account__r.RecordType.Name
                         from Lead where (Mobile__c =: Phone or Phone =: Phone or Office_Phone__c=: Phone or Mobile1__c =:Phone) and isConverted = false and isDuplicate__c = false and RecordTypeId =: cRTId order by CreatedDate Desc];     // Added by CG Dev Team 12/10/2011 include other phone fields to search
                         
            /*lstExistingOpp = [select Id, Name, Project_Name__c, Project_Name__r.Name, RecordTypeId, RecordType.Name, Account.Id, Account.Name, Account.Mobile_Phone__c, Account.Mobile1__pc,Account.Phone,Account.Office_Phone_cont__pc,
                  StageName, Date_of_Visit__c, Name_of_SM__c, Last_Call_Date__c, Last_Call_Attempt_Status__c, Last_Attempted_By__c,
                  Opportunity_Date_of_Visit__c, Opportunity_Last_Call_Date__c from Opportunity where (Account.Mobile_Phone__c =: Phone or Account.Mobile1__pc =: Phone or Account.Phone =: Phone or Account.Office_Phone_cont__pc =:Phone )and Account.recordtype.name !='Booked Account' and Project_Name__c =: Project and RecordType.Name =: cRTName order by CreatedDate Desc];     // Added by CG Dev Team 12/10/2011 include other phone fields to search
 
            Set<Id> AccountIdSet = new Set<Id>();
            for(Opportunity Opp :lstExistingOpp )
            {
                
                AccountIdSet.add(Opp.Account.Id);
            }*/
                       
            
            lstExistingAcc = [select Id, Name,Office_Phone_cont__pc, Mobile_Phone__c, Mobile1__pc,Phone,CreatedDate, CreatedDate_as_String__c, 
            LastModifiedById, LastModifiedBy.Name, RecordTypeId, RecordType.Name,
            (select Id, Name, Project_Name__c, Project_Name__r.Name, RecordTypeId, RecordType.Name,Account.Name, 
            StageName, Date_of_Visit__c, Name_of_SM__c, 
            Last_Call_Date__c,Last_Call_Attempt_Status__c, Last_Attempted_By__c,Opportunity_Date_of_Visit__c, Opportunity_Last_Call_Date__c 
            from Opportunities where Project_Name__c =: Project and RecordType.Name =: cRTName order by CreatedDate Desc)
            from Account where (Mobile_Phone__c =: Phone or Mobile1__pc =: Phone or Phone =: Phone or Office_Phone_cont__pc =:Phone) 
            and RecordType.Name =: actRTName and recordtype.name !='Booked Account' order by CreatedDate Desc]; 
            
            for(Account acclist: lstExistingAcc)
                {
                    if(!acclist.Opportunities.isEmpty())
                        {
                            accountwithopportunity.add(acclist);
                            lstExistingOpp.add(acclist.Opportunities);
                        }
                        else
                        {
                            accountwithoutopportunity.add(acclist);                            
                        }               
                }
            lstExistingAcc.clear();
            
           /* if(AccountIdSet.size() >= 0)
            
                lstExistingAcc = [select Id, Name,Office_Phone_cont__pc, Mobile_Phone__c, Mobile1__pc,Phone,CreatedDate, 
                CreatedDate_as_String__c, LastModifiedById, LastModifiedBy.Name, RecordTypeId, RecordType.Name 
                from Account where (Mobile_Phone__c =: Phone or Mobile1__pc =: Phone or Phone =: Phone or Office_Phone_cont__pc =:Phone)
                and RecordType.Name =: actRTName and recordtype.name !='Booked Account' and Id not in : AccountIdSet order by CreatedDate Desc];    
                // Added by CG Dev Team 12/10/2011 include other phone fields to search
                // End:Changes to include Lead,Account,opportunity in Search results*/  
              
                        
            system.debug('lstExistingLead: ' + lstExistingLead);
            
            system.debug('lstExistingOpp: ' + lstExistingOpp);
            
            system.debug('lstExistingAcc: ' + accountwithoutopportunity);
            
            if(lstExistingLead.size()>0)
            {
              for(Lead l : lstExistingLead)
              {
                l.LeadCreatedOn__c = l.CreatedDate.format();
              }
            }
            
            if(accountwithoutopportunity.size()>0)
            {
              for(Account a : accountwithoutopportunity)
              {
                a.CreatedDate_as_String__c = a.CreatedDate.date().format();
              }
              lstExistingAcc.addAll(accountwithoutopportunity);
            }
            
            if(lstExistingOpp.size()>0)
            {
              for(Opportunity o : lstExistingOpp)
              {
                if (o.Date_of_Visit__c != null)
                {
                  o.Opportunity_Date_of_Visit__c = o.Date_of_Visit__c.format();
                }
                if (o.Last_Call_Date__c != null)
                {
                  o.Opportunity_Last_Call_Date__c = o.Last_Call_Date__c.format();
                }
              }
            }
            
            /*   Added by CG Dev Team 12/10/2011
             *   Start:Changes to include Lead,Account,opportunity in Search results
             */  
            if(!lstExistingLead.isEmpty() ||   !lstExistingOpp.isEmpty() ||  !lstExistingAcc.isEmpty())
            {
                if(!lstExistingLead.isEmpty())
                {                        
                    showLeadList=true;
                    //showOppList=false;                                                                                                              
                    //showAccList=false;
                    showErrorMsg=false;
                    isLeadListNull=false;                                                  
                }       
                if(!lstExistingOpp.isEmpty())
                {
                    showOppList=true;
                    //showLeadList=false;
                    //showAccList=false;                      
                    showErrorMsg=false;
                    isOppListNull=false;
                }
                if(!lstExistingAcc.isEmpty() )
                {
                    showAccList=true;
                    //showLeadList=false;
                    /*if(showOppList)
                    {    showOppList=true;    
                         showAccList=false;                  
                    }*/    
                    showErrorMsg=false;
                    isAccListNull=false;
                } 
            } 
            //   End:Changes to include Lead,Account,opportunity in Search results
            else 
            {                   
                isLeadListNull=true;
                isOppListNull=true;
                isAccListNull=true;
                showLeadList=false;
                showOppList=false;
                showAccList=false;
                showErrorMsg=false; 
                ApexPages.Message info = new ApexPages.Message(ApexPages.Severity.INFO,'No matching records found');
                ApexPages.addMessage(info);
            }
           }     
        }
        
        public PageReference NewLead(){
                PageReference newLeadPage = ApexPages.currentPage();
                List<VisitorFormSettings__c> usermap = new List<VisitorFormSettings__c>();
                usermap = [select id from VisitorFormSettings__c where User__c =:UserInfo.getUserId() and RecordType.Name = 'Lead']; 
                if (!usermap.isEmpty())
                {
                    newLeadPage = new PageReference('/apex/visitorLeadPage');
                    newLeadPage.getParameters().put('ph',Phone);
                    return newLeadPage;
                }
                else
                {
                    newLeadPage = new PageReference('/00Q/e');
                    newLeadPage.getParameters().put('00N20000001SJmb',Phone);
                    newLeadPage.getParameters().put('CF00N20000002zX2u',ProjectName); 
                    newLeadPage.getParameters().put('00ND00000039gka',Project);
                    newLeadPage.getParameters().put('RecordType',cRTId);                
                    newLeadPage.getParameters().put('nooverride','1');
                    newLeadPage.getParameters().put('retURL','/00Q/o');                              
                    return newLeadPage;
                }
                
        } 
        
 static testMethod void testSearchDuplicates() {
        
        Project_Name__c pn1 = new Project_Name__c (Name = 'Lodha Aria', Record_Type__c = 'Residential');        // CG Dev Team 18/10/2011 Included Record_Type__c" picklist values as residential for code coverage 
        Project_Name__c pn2 = new Project_Name__c (Name = 'Unknown Project', Record_Type__c = 'Residential');   // CG Dev Team 18/10/2011 Included Record_Type__c" picklist values as residential for code coverage 
        list <Project_Name__c> lstPN = new list <Project_Name__c> ();
        lstPN.add(pn1);
        lstPN.add(pn2);
        insert lstPN;
        
        Lead l1=new Lead (Company='Company',Date_of_visit__c= datetime.now(),status = 'Follow up',Project_Interested__c='Lodha Aria', Project_Name__c = pn1.id ,Mobile__c='2345678926', LastName='LastName', LeadSource='Web', Allow_to_Save__c = False);
        Lead l2= new Lead (status='Follow up', Mobile__c='1234567892', LastName='LN', Interested__c='Yes', LeadSource = 'Web', Project_Name__c = pn2.id, Project_Interested__c = 'Unknown Project', OWNERID=UserInfo.getUserId(), Allow_to_Save__c = False);
        Lead l3= new Lead (status='Follow up', Mobile__c='7584632155', LastName='LastN', Interested__c='Yes', LeadSource = 'Web', Project_Name__c = pn2.id, Project_Interested__c = 'Lodha Aria', OWNERID=UserInfo.getUserId(), Allow_to_Save__c = False);
        list <Lead> lstLead = new list <Lead>();
        lstLead.add(l1);
        lstLead.add(l2);
        lstLead.add(l3);
        insert lstLead;
        
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(l1.id);
        lc.setConvertedStatus('Converted');
        lc.setOwnerId(UserInfo.getUserId());
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        
        ApexPages.StandardController ctr1 = new ApexPages.StandardController(l1);
        ApexPages.StandardController ctr2 = new ApexPages.StandardController(l2);
        ApexPages.StandardController ctr3 = new ApexPages.StandardController(l3);
        
        visitSearchDuplicates sd0 = new visitSearchDuplicates(ctr2);
        sd0.Phone = '1234567892';
        sd0.Project = pn2.Id;
        sd0.search();
        sd0.NewLead();
 
        Profile p = [select id from profile where name = 'IPad Profile' ];//Id='00eD0000001GLMM']; 
        User u = new User(alias = 'standt', email='standarduser@testorg.com', emailencodingkey='UTF-8',lastname='Testing', languagelocalekey='en_US',localesidkey='en_US', profileid = p.Id, timezonesidkey='America/Los_Angeles', username='test3standarduser123@testorg.com');        
        system.runas(u)
        {
        visitSearchDuplicates sd1 = new visitSearchDuplicates(ctr2);
        sd1.Phone = '1234567892';
        sd1.Project = pn2.Id;
        sd1.search();
        sd1.NewLead();
        
        visitSearchDuplicates sd2 = new visitSearchDuplicates(ctr2);
        sd2.Phone = '1234567892';
        sd2.Project = pn1.Id;
        sd2.search();
        sd2.NewLead();
        
        visitSearchDuplicates sd3 = new visitSearchDuplicates(ctr1);
        sd3.Phone = '234567892';
        sd3.Project = pn2.Id;
        sd3.search();
        sd3.NewLead();
        
        visitSearchDuplicates sd4 = new visitSearchDuplicates(ctr1);
        sd4.Phone = null;
        sd4.Project = null;
        sd4.search();
        sd4.NewLead();
        
        visitSearchDuplicates sd5 = new visitSearchDuplicates(ctr1);
        sd5.Phone = '1234563218';
        sd5.Project = pn2.id;
        sd5.search();
        sd5.NewLead();
        }
 
          
    }        
}