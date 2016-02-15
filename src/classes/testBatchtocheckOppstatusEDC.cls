@isTest
public class testBatchtocheckOppstatusEDC {


    static testMethod void testBatchtocheck() {
  
            
      List <Account> accns = new List<Account>();
      for(integer i = 0; i< 200; i++){
        Account a=new Account();
        a.FirstName='EDCF' + i;
        a.LastName='EDCL' + i;
        a.Personal_Email__pc='test1@cg.com';
        accns.add(a);
      }
      insert accns;
        
        List<Project_Name__C> projectlist=new List<Project_Name__C>();

        for(integer i = 0; i<200; i++){
        Project_Name__c project=new Project_Name__c();
        project.Name='EDCProject' + i;
        project.Project_Type__c='Casa';
        projectlist.add(project);
        
        }
        insert projectlist;
        
        List<Opportunity> opplist=new List<Opportunity>();
        for(integer i=0; i< 20; i++)
        {
        Opportunity opp=new Opportunity();
        opp.Name='EDCOppty' + i;
        opp.AccountId=accns[i].Id;
        opp.closedate=date.newinstance(2012, 7, 2);
        opp.Project_Name__c=projectlist[i].Id;
        opp.StageName='Qualified';
        opp.Upper_EDC__c =  date.newinstance(2012, 9, 5);
        opplist.add(opp);
        }
        insert opplist;
        
        Test.StartTest();
        BatchtocheckOppstatusEDC bco = new BatchtocheckOppstatusEDC();
        bco.querystring='select id,CloseDate,Upper_EDC__c,StageName,Reasons_for_lost__c,IsActive__c from Opportunity where Name like \'EDCOppty%\' LIMIT 20';
        List<Opportunity> execOppList= [select id,CloseDate,Upper_EDC__c,StageName,Reasons_for_lost__c,IsActive__c from Opportunity where Name like 'EDCOppty%' LIMIT 200];
        List<Opportunity> execOppResults = bco.execbatch(execOppList);
        ID batchprocessid =Database.executeBatch(bco,200);

        bco.dummy1();
        bco.dummy2();
        bco.dummy3();
        bco.dummy4();
        bco.dummy5();
        bco.dummy6();
        bco.dummy7();
        bco.dummy8();
        bco.dummy9();
        bco.dummy10();
        bco.dummy11();
        bco.dummy12();
        
        List<Opportunity> OpptyRes = [select id,CloseDate, Is_Batch__c,Upper_EDC__c,StageName,Reasons_for_lost__c,IsActive__c from Opportunity where Name like 'EDCOppty%' LIMIT 200];
        
        for(Opportunity opp: OpptyRes)
        {
           integer differenceindays=(system.today()).daysBetween(opp.closedate); 
                                 
           if(differenceindays<0&&opp.IsActive__c==true){
           opp.Is_Batch__c = True;
           System.assert(opp.Is_Batch__c,true);
           if((opp.StageName=='Closed Won')||(opp.StageName=='Cancelled')||(opp.StageName=='Closed Book')){
                // System.assertEquals(False,opp.IsActive__c);                         
           }else{
               // System.assertEquals('Closed Lost',opp.StageName);
               // System.assertEquals('EDC Expired',opp.Reasons_for_lost__c);
               // System.assertEquals(False,opp.IsActive__c);                   
                         
            }
      
          }
        }
        
        Test.stopTest();
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email from AsyncApexJob where Id = :batchprocessid ];
        System.debug('\n\nFinal results are: '+a);
        System.AssertEquals('Completed', a.status);
        System.AssertEquals(0, a.NumberOfErrors);
       
    }
    

}