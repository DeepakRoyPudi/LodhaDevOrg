/*
 This Class has the test methods for the class LeadTriggersClass.cls and also it does test the class FlagDuplicateLead.cls
 
 Version    Date         Auther             Description
  1.1      08/20/2014    Asmita(Eternus)    Modified the code as the Too Many SOQL exception was occuring while deploying the Lead related components
  1.2      08/20/2014    Asmita(Eternus)    Added the fields required while inserting the lead as test code execution was giving error for it.
  1.3      08/20/2014    Asmita(Eternus)    Added some code to increase test code coverage which is currently 50%
 */
@isTest
private class LeadTriggers_TestClass {

    static testMethod void testUpdateProjectDetails() 
    {
        Project_Name__c pn1 = new Project_Name__c (Name = 'Lodha Aria');
        Project_Name__c pn2 = new Project_Name__c (Name = 'Unknown Project');
        list <Project_Name__c> lstPN = new list <Project_Name__c> ();
        lstPN.add(pn1);
        lstPN.add(pn2);
        insert lstPN;           
        
        Projects__c p1= new Projects__c(Name='Lodha Aria', URL__c = 'Lodha Aria', WebSite_Project_Name__c='Lodha Aria', Budget__c=100000);
        Projects__c p2= new Projects__c(Name='Unknown Project', URL__c = 'Unknown Project', WebSite_Project_Name__c='Unknown Project', Budget__c=200000);
        list <Projects__c> lstProj = new list <Projects__c> ();
        lstProj.add(p1);
        lstProj.add(p2);
        insert lstProj;  
        
        // 1.2 - Asmita
        Lead l1=new Lead (Company='Company',Date_of_visit__c= datetime.now(),status = 'Follow up',Project_Interested__c='Lodha Aria', Project_Name__c = lstPN[0].id ,Mobile__c='2345678927', LastName='LastName', LeadSource='Web', Allow_to_Save__c = False, Address_r1__c = 'test road', Address2_R__c = 'test Road2', City_R__c = 'Mumbai', Address_3_R__c = 'Mumbai', Pincode_R__c = '123456', State_R__c = 'Maharashtra', Country_R__c = 'India', FirstName = 'lead1', ExistingProjectID__c = lstPN[0].Id);
        Lead l2= new Lead (status='Follow up', Mobile__c='1234567892', LastName='LN', Interested__c='Yes', LeadSource = 'Web', Project_Name__c = null, Project_Interested__c = 'Unknown Project', OWNERID=UserInfo.getUserId(), Allow_to_Save__c = False, Address_r1__c = 'test road', Address2_R__c = 'test Road2', City_R__c = 'Mumbai', Address_3_R__c = 'Mumbai', Pincode_R__c = '123456', State_R__c = 'Maharashtra', Country_R__c = 'India');
        list <Lead> lstLead = new list <Lead>();
        lstLead.add(l1);
        lstLead.add(l2);
        // 1.1 - Asmita
        test.startTest();
            insert lstLead;
        test.stopTest();
    }
    
    
    static testMethod void testRestrictChangeOwnership() 
    {
        Project_Name__c pn1 = new Project_Name__c (Name = 'Lodha Aria');
        Project_Name__c pn2 = new Project_Name__c (Name = 'Unknown Project');
        list <Project_Name__c> lstPN = new list <Project_Name__c> ();
        lstPN.add(pn1);
        lstPN.add(pn2);
        insert lstPN;           
        
        Projects__c p1= new Projects__c(Name='Lodha Aria', URL__c = 'Lodha Aria', WebSite_Project_Name__c='Lodha Aria', Budget__c=100000);
        Projects__c p2= new Projects__c(Name='Unknown Project', URL__c = 'Unknown Project', WebSite_Project_Name__c='Unknown Project', Budget__c=200000);
        list <Projects__c> lstProj = new list <Projects__c> ();
        lstProj.add(p1);
        lstProj.add(p2);
        insert lstProj;
        
        Project_Executive__c pe1 =new Project_Executive__c(Executive__c=UserInfo.getUserId(), Project__c=p1.id, Role_Name__c='Sales Executive');
        Project_Executive__c pe2 =new Project_Executive__c(Executive__c=UserInfo.getUserId(), Project__c=p2.id, Role_Name__c='Site Incharge');
        list <Project_Executive__c> lstProjExec = new list <Project_Executive__c> ();
        lstProjExec.add(pe1);
        lstProjExec.add(pe2);
        insert lstProjExec;
        
        // 1.2 - Asmita
        Lead l1=new Lead (Company='Company',Date_of_visit__c= datetime.now(),status = 'Follow up',Project_Interested__c='Lodha Aria', Project_Name__c = pn1.id ,Mobile__c='2345678926', LastName='LastName', LeadSource='Web', Address_r1__c = 'test road', Address2_R__c = 'test Road2', City_R__c = 'Mumbai', Address_3_R__c = 'Mumbai', Pincode_R__c = '123456', State_R__c = 'Maharashtra', Country_R__c = 'India');
        Lead l2= new Lead (Status='Follow up', Mobile__c='1234567892', LastName='LN', Interested__c='Yes', LeadSource = 'Web', Project_Name__c = pn2.id , OWNERID=UserInfo.getUserId(), Address_r1__c = 'test road', Address2_R__c = 'test Road2', City_R__c = 'Mumbai', Address_3_R__c = 'Mumbai', Pincode_R__c = '123456', State_R__c = 'Maharashtra', Country_R__c = 'India');
        list <Lead> lstLead = new list <Lead>();
        lstLead.add(l1);
        lstLead.add(l2);
        
        // 1.1 - Asmita
        test.startTest();
            insert lstLead; 
        
        l1.Company = 'Lodha Group';
        l2.Date_of_visit__c = DateTime.Now();
        lstLead.clear();
        lstLead.add(l1);
        lstLead.add(l2);
            update lstLead;
        test.stopTest();         
    }
    
    
    static testMethod void testInsertUpdateReferral() 
    {
        Projects__c p1= new Projects__c(Name='Lodha Aria', URL__c = 'Lodha Aria', WebSite_Project_Name__c='Lodha Aria', Budget__c=100000);
        Projects__c p2= new Projects__c(Name='Lodha Primero', URL__c = 'Lodha Primero', WebSite_Project_Name__c='Lodha Primero', Budget__c=200000);
        list <Projects__c> lstProj = new list <Projects__c> ();
        lstProj.add(p1);
        lstProj.add(p2);
        insert lstProj; 
        
        Project_Name__c pn1 = new Project_Name__c (Name = 'Lodha Aria');
        Project_Name__c pn2 = new Project_Name__c (Name = 'Lodha Primero');
        list <Project_Name__c> lstPN = new list <Project_Name__c> ();
        lstPN.add(pn1);
        lstPN.add(pn2);
        insert lstPN;   
        
        Account acc =new Account (LastName='XYZ', Email_Acc__c='xyz@gmail.com',Payment_Made__c = False, Opportunity_Stage__c= 'Booked');
        insert acc;
        
        Channel_Partner__c cp = new Channel_Partner__c (Name='CP1', Type_of_Channel_Partner__c='Domestic', Email__c='xyz@hotmail.com');
        insert cp;
        
        list <Payout_Master__c> lstPM = new list <Payout_Master__c> ();
        lstPM = [select Property_Type__c, Channel_Partner_Type__c from Payout_Master__c where Property_Type__c = 'Aspirational' and Channel_Partner_Type__c = 'Domestic'];  
        
        if (lstPM.isEmpty())
        {
            Payout_Master__c pm  = new Payout_Master__c (Property_Type__c = 'Aspirational', Payout_Percentage__c = 2, Channel_Partner_Type__c = 'Domestic');
            insert pm;
        }
        // 1.3 - Asmita
        /*Payout_Master__c pm1  = new Payout_Master__c (Property_Type__c = 'Casa', Payout_Percentage__c = 2, Channel_Partner_Type__c = 'Domestic');
        insert pm1;
        lstPM.add(pm1);*/
        
        // 1.2 - Asmita
        Lead l1 = new Lead (Status = 'Follow Up', Project_Interested__c='Lodha Aria', Project_Name__c = pn1.id, Mobile__c='2345678912', LastName='last', Interested__c='yes', LeadSource = 'Existing Customer', Referral_Name__c = acc.id, Date_Of_Visit__c = Datetime.newInstance(2011, 10, 28, 1, 6, 8), Project_Type__c = 'Aspirational', Address_r1__c = 'test road', Address2_R__c = 'test Road2', City_R__c = 'Mumbai', Address_3_R__c = 'Mumbai', Pincode_R__c = '123456', State_R__c = 'Maharashtra', Country_R__c = 'India');
        Lead l2 = new Lead (Status = 'Follow Up', Project_Interested__c='Lodha Primero', Project_Name__c = pn2.id, Mobile__c='2345678967', LastName='last', Interested__c='yes', LeadSource = 'Channel Partner', Channel_Partner__c = cp.id, Date_Of_Visit__c = Datetime.newInstance(2011, 10, 28, 1, 6, 8), Project_Type__c = 'Aspirational', Address_r1__c = 'test road', Address2_R__c = 'test Road2', City_R__c = 'Mumbai', Address_3_R__c = 'Mumbai', Pincode_R__c = '123456', State_R__c = 'Maharashtra', Country_R__c = 'India');
        list <Lead> lstLead = new list <Lead>();
        lstLead.add(l1);
        lstLead.add(l2);
        
        // 1.1 - Asmita
        test.startTest();
            insert lstLead;
        
            Referrals__c ref = new Referrals__c (Referral_Name__c = acc.id, Referred_Customer__c = lstLead[0].Id);
            insert ref;
        
            Payout_percentage__c objPayoutPtage = new Payout_percentage__c(Lead__c = lstLead[0].Id, Channel_Partner__c = cp.Id);
            insert objPayoutPtage;
        
            Map<Id, Lead> mapLead = new Map<Id, Lead>();
            mapLead.putAll(lstLead);
        
            LeadTriggersClass.InsertUpdateReferral(lstLead, mapLead);
        test.stopTest();
            
    }
    
    
    static testMethod void testCallAttemptToOppOnConversion() 
    {
        Project_Name__c pn1=new Project_Name__c(name='Lodha Aria');
        Project_Name__c pn2=new Project_Name__c(name='Lodha Primero');
        list <Project_Name__c> lstPN = new list <Project_Name__c> ();
        lstPN.add(pn1);
        lstPN.add(pn2);
        insert lstPN;   
        
        // 1.3 - Asmita - added firstname
        Lead l=new Lead(Project_Name__c=pn1.Id, Company='Lodha Group', Project_Interested__c='Lodha Aria', Mobile__c='2345678912', LastName='Test', LeadSource='Web', firstName = 'test');
        insert l;
    
        Account acc=new account(Name='test');
        insert acc;

        Call_Attempts__c ca1 = new Call_Attempts__c (Project_Name__c = pn1.id, Lead__c=l.id, Project_Interested__c='Lodha Aria', Mobile__c=l.Mobile__c, Attempted_By__c='CEO', Call_Attempted_by__c='test', Call_Attempt_Status__c='Open', Call_Type__c='Outbound');
        Call_Attempts__c ca2 = new Call_Attempts__c (Project_Name__c = pn2.id, Lead__c=l.id, Project_Interested__c='Lodha Primero', Mobile__c=l.Mobile__c, Attempted_By__c='CEO', Call_Attempted_by__c='test', Call_Attempt_Status__c='Open', Call_Type__c='Outbound');
        list <Call_Attempts__c> lstCA = new list <Call_Attempts__c> ();
        lstCA.add(ca1);
        lstCA.add(ca2);
        insert lstCA;
        
         // 1.1 - Asmita
        test.startTest();
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(l.id);
        lc.setConvertedStatus('Converted');
        lc.setOwnerId(UserInfo.getUserId());
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        test.stopTest();
    }   
    
}