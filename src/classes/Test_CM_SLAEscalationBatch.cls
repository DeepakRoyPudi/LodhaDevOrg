@isTest
public class Test_CM_SLAEscalationBatch{

    /*public static testMethod  void testSLAEscalationBatch (){
        test.startTest();

        CM_Tat_Calculation__c q=new CM_Tat_Calculation__c(Name='Parent',CaseType__c='Parent',Legal__c=144,Non_Legal__c=72);
        insert q;
        CM_Tat_Calculation__c q1=new CM_Tat_Calculation__c(Name='Child',CaseType__c='Child',Legal__c=144,Non_Legal__c=72);
        insert q1;
        CM_Tat_Calculation__c q2=new CM_Tat_Calculation__c(Name='AIFTM',CaseType__c='AIFTM',Legal__c=144,Non_Legal__c=72);
        insert q2;
        CM_Tat_Calculation__c q3=new CM_Tat_Calculation__c(Name='AISPOC',CaseType__c='AISPOC',Legal__c=144,Non_Legal__c=72);
        insert q3; 

        Case  c = new Case(IsDuplicate__c=false,Status= 'open',IsEscalated= true, Communication_Type__c='Inbound',Initial_Remarks__c='testing',Interaction_Mode__c='Email',Nature_of_Request__c='Request',Request_for_L1__c='Document Related',Request_for_L2__c='Customer wants original document',Request_for_L3_a__c='Welcome Email',Request_for_L3__c='');
        // c.account=a;
        insert c;

        
        CM_SLAEscalationBatch obj = new CM_SLAEscalationBatch  (); 
        database.executebatch(obj );
    
        test.stopTest();

    }*/
    
    
     public static testMethod void testEmailSenderScheduler(){ 
     
     test.startTest();
     CM_SLAEscalationBatch c = new CM_SLAEscalationBatch();
     //c.query= 'Select CaseNumber,Status,IsEscalated,IsClosed,IsDuplicate__c, BusinessHoursId,ClosedDate,CreatedDate,CM_TAT__c from Case Where IsClosed = false and IsDuplicate__c = false and IsEscalated = false';
     
          Database.BatchableContext bc;        
          c.start(bc);
          
          List<Case> caseList = [Select CaseNumber,Status,IsEscalated,IsClosed,IsDuplicate__c, BusinessHoursId,ClosedDate,CreatedDate,CM_TAT__c from Case Where IsClosed = false and IsDuplicate__c = false and IsEscalated = false];
          
          c.execute(bc, caseList); 
          
          c.finish(bc);       
           test.stopTest();
         
     }
     }