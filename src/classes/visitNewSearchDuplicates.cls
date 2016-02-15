public class visitNewSearchDuplicates {

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
        public List <Project_Name__c> lstProjects{get;set;}
        List<Account> accountwithopportunity{get;set;}
        List<Account> accountwithoutopportunity{get;set;}
        public ApexPages.StandardController sc;
        public Lead myLead = new Lead();
        public RecordType accrectype{get;set;}
        String cRTId = ApexPages.CurrentPage().getParameters().get('RecordType');
        String cRTName = null;
        String actRTName = null;
        String pRTName = null;
        public String rectyname{get;set;}
                            
        public visitNewSearchDuplicates(ApexPages.StandardController ctr)
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
            accrectype=new  RecordType();
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
            
            else
            {
            lstExistingLead = [select Id, Name, Mobile__c, LeadCreatedOn__c, LeadSource, Status, CreatedDate, Project_Interested__c, Project__c, Project_Name__r.Name, isConverted,Phone,Office_Phone__c,Mobile1__c,
                         ConvertedOpportunityId, ConvertedAccountId, ConvertedContactId, RecordTypeId, RecordType.Name, isDuplicate__c,
                         Existing_Lead__c, Existing_Opportunity__c, Existing_Account__c, Existing_Lead__r.RecordType.Name, 
                         Existing_Opportunity__r.RecordType.Name,  Existing_Account__r.RecordType.Name
                         from Lead where (Mobile__c =: Phone or Phone =: Phone or Office_Phone__c=: Phone or Mobile1__c =:Phone) and isConverted = false and isDuplicate__c = false and RecordTypeId =: cRTId order by CreatedDate Desc];     // Added by CG Dev Team 12/10/2011 include other phone fields to search
                         
           List<Contact> con=[select account.id,account.Mobile_Phone__c,account.Phone,                   
                        account.RecordType.Name,Office_Phone_cont__c,Mobile1__c from Contact where
                        (account.Mobile_Phone__c =: Phone or Mobile1__c =: Phone or Phone =: Phone or Office_Phone_cont__c =:Phone)
                        and account.RecordType.Name =: actRTName and account.recordtype.name !='Booked Account' order by CreatedDate Desc];
                        
                        Set<Id> accountId=new Set<Id>();
                            
                            for(Contact c: con)
                            {
                                    accountId.add(c.account.Id);
                            
                            }
            
             lstExistingAcc = [select Id, Name, Mobile_Phone__c,CreatedDate, CreatedDate_as_String__c, 
                                LastModifiedById, LastModifiedBy.Name, RecordTypeId, RecordType.Name,
                                (select Id, Name, Project_Name__c, Project_Name__r.Name, RecordTypeId, RecordType.Name,Account.Name, 
                                StageName, Date_of_Visit__c, Name_of_SM__c,IsActive__c, 
                                Last_Call_Date__c,Last_Call_Attempt_Status__c, Last_Attempted_By__c,Opportunity_Date_of_Visit__c, 
                                Opportunity_Last_Call_Date__c from Opportunities where Project_Name__c =: Project and RecordType.Name =: cRTName order by CreatedDate Desc)
                                from Account where Id in: accountId order by CreatedDate Desc];  
            
            for(Account acclist: lstExistingAcc)
                {
                    if(!acclist.Opportunities.isEmpty())
                        {
                            accountwithopportunity.add(acclist);
                            lstExistingOpp.addAll(acclist.Opportunities);
                        }
                        else
                        {
                            accountwithoutopportunity.add(acclist);                            
                        }               
                }
            lstExistingAcc.clear();
            
                  
            system.debug('lstExistingLead: ' + lstExistingLead);
            
            system.debug('lstExistingOpp: ' + lstExistingOpp);
            
            system.debug('lstExistingAcc: ' + lstExistingAcc);
            
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
            
            if(!lstExistingLead.isEmpty() ||   !lstExistingOpp.isEmpty() ||  !lstExistingAcc.isEmpty())
            {
                if(!lstExistingLead.isEmpty())
                {                        
                    showLeadList=true;                    
                    showErrorMsg=false;
                    isLeadListNull=false;                                                  
                }       
                if(!lstExistingOpp.isEmpty())
                {
                    showOppList=true;                                          
                    showErrorMsg=false;
                    isOppListNull=false;
                }
                if(!lstExistingAcc.isEmpty() )
                {
                    showAccList=true;                        
                    showErrorMsg=false;
                    isAccListNull=false;
                } 
            } 
           
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
                list <Profile> proName = new list <Profile> ();
                proName = [select Id, Name from Profile where Id =: UserInfo.getProfileId() LIMIT 1];
                PageReference newLeadPage = ApexPages.currentPage();
                if ( proName[0].Name == 'IPad Profile' )
                {
                    list <Project_Name__c> lstFiorenza = new list <Project_Name__c>(); 
                    lstFiorenza = [select Id, Name from Project_Name__c where Name =: 'Lodha Fiorenza' limit 1];
                    newLeadPage = new PageReference('/apex/LeadPage');
                    if(lstFiorenza!=null&&lstFiorenza.size()>0)
                    {
                     newLeadPage.getParameters().put('pid', lstFiorenza[0].Id);
                    }
                    newLeadPage.getParameters().put('ph',Phone);
                    return newLeadPage;
                }
                
                
                else if( proName[0].Name == 'IPad Wadala Profile')
                {
                    newLeadPage = new PageReference('/apex/LeadPage');
                    newLeadPage.getParameters().put('pid', VisitorFormGlobalVariables__c.getInstance().ProjectId__c);
                    newLeadPage.getParameters().put('ph',Phone);
                    return newLeadPage;
                }

                else if( proName[0].Name == 'IPad WorldTowers Profile' )
                {
                    newLeadPage = new PageReference('/apex/LeadPage');
                    newLeadPage.getParameters().put('pid', VisitorFormGlobalVariables__c.getInstance().ProjectId__c);
                    newLeadPage.getParameters().put('ph',Phone);
                    return newLeadPage;                     
                }
                else if( proName[0].Name == 'IPad WorldCrest Profile' )
                {
                    newLeadPage = new PageReference('/apex/LeadPage');
                    newLeadPage.getParameters().put('pid', VisitorFormGlobalVariables__c.getInstance().ProjectId__c);
                    newLeadPage.getParameters().put('ph',Phone);
                    return newLeadPage;
                }
                else if( proName[0].Name == 'IPad ThePark Profile' )
                {
                    newLeadPage = new PageReference('/apex/LeadPage');
                    newLeadPage.getParameters().put('pid', VisitorFormGlobalVariables__c.getInstance().ProjectId__c);
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


}