@isTest(SeeAllData=true)
public class  Test_CM_CaseLatestComment  {
    
    public static testMethod  void testCaseLatestComment(){
        
        test.startTest(); 
        
        Profile p = [Select id from Profile where Name = 'Customer Care' LIMIT 1];
        
        User u = new User();
        u.LastName = 'TestUser';
        u.Alias = 'tuser';
        u.Email = 'test@test.in';
        u.Username = 'abc_123@test.com';
        u.CommunityNickname = 'Testuser';
        u.ProfileId = p.Id;
        u.TimeZoneSidKey = 'Asia/Kolkata';
        u.LocaleSidKey = 'en_IE_EURO';
        u.EmailEncodingKey = 'ISO-8859-1';
        u.LanguageLocaleKey = 'en_US';
        u.IsActive = true;
        insert u;
        
        system.debug('---------------1.............' + u);
                system.debug('---------------2.............' + u.IsActive );
       System.runAs(u){
        
        /* SAPBookingIDAgentMapping_del__c a=new SAPBookingIDAgentMapping_del__c(Agent_Name__c=u.id,Booking_ID__c='',Building_Name__c='MARINA',Flat_No__c='202',Project_Name__c='CASA Rio',Wing__c='d');
        insert a; */
        
        
        
        Case c = new Case(
        //origin = 'Web',
                               First_Name__c = 'testFirst'+'i',
                               Last_Name__c = 'testLast'+'i', 
                               Mobile__c = '1234567891',
                               Project__c = 'CASA Rio',
                               Buildings_Name__c = 'MARINA',
                               Wing__c = 'd',
                               Flat_No__c = '202',
                               //Ownerid = u.ID,
                               Communication_Type__c='Inbound',
                               Initial_Remarks__c='testing',
                               Interaction_Mode__c='Call',
                               Nature_of_Request__c='Request',
                               Request_for_L1__c='Document Related',
                               Request_for_L2__c='Customer wants duplicate document',
                               Request_for_L3_a__c='Lease NOC',
                               Request_for_L3__c='');
        insert c;
        system.debug('---------------2.............' + c);                  
        
        CaseComment comment = new CaseComment(parentid=c.id,CommentBody = 'Testing case comments1' );
        insert comment;
        }
        
        test.stopTest();  
    }
}