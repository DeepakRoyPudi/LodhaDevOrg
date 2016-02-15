/* @Test(SeeAllData=true)
public class Test_CM_ComplaintCasesReportHelper{
    public static testMethod void testCM_ComplaintCasesReportHelper(){
        try{
        
        test.startTest();
        
        Profile p = [Select id from Profile where Name = 'System Administrator'];
        
        User u1 = new User();
        u1.LastName = 'TestUser1';
        u1.Alias = 'tuser1';
        u1.Email = 'test1@test.in';
        u1.Username = 'abc_123@test.com';
        u1.CommunityNickname = 'Testuser';
        u1.ProfileId = p.Id;
        u1.TimeZoneSidKey = 'Asia/Kolkata';
        u1.LocaleSidKey = 'en_IE_EURO';
        u1.EmailEncodingKey = 'ISO-8859-1';
        u1.LanguageLocaleKey = 'en_US';
        u1.IsActive = true;
        insert u1;
        
        User u2 = new User();
        u2.LastName = 'TestUser2';
        u2.Alias = 'tuser2';
        u2.Email = 'test2@test.in';
        u2.Username = 'xyz_456@test.com';
        u2.CommunityNickname = 'Testuser2';
        u2.ProfileId = p.Id;
        u2.TimeZoneSidKey = 'Asia/Kolkata';
        u2.LocaleSidKey = 'en_IE_EURO';
        u2.EmailEncodingKey = 'ISO-8859-1';
        u2.LanguageLocaleKey = 'en_US';
        u2.IsActive = true;
        insert u2;
        
        User u3 = new User();
        u3.LastName = 'TestUser3';
        u3.Alias = 'tuser3';
        u3.Email = 'test3@test.in';
        u3.Username = 'xyz_789@test.com';
        u3.CommunityNickname = 'Testuser3';
        u3.ProfileId = p.Id;
        u3.TimeZoneSidKey = 'Asia/Kolkata';
        u3.LocaleSidKey = 'en_IE_EURO';
        u3.EmailEncodingKey = 'ISO-8859-1';
        u3.LanguageLocaleKey = 'en_US';
        u3.IsActive = true;
        insert u3;
        
        u1.manager = u2;
        u2.manager = u3;
        
        Id RTId = [Select id from RecordType where Name = 'Booked Account'].id; 
        
        Account acc = new Account(FirstName = 'testingFirstacc',
            LastNAme = 'testingLastacc',
            Recordtypeid = RTId ,     
            PersonMobilePhone = '1234567890',
            PersonEmail = 'testing@test.com',
            CRN__c='999000',
            Project_Name__c = 'Casa Rio',
            //name = 'TestAccount123',
            owner = u1
        );
        insert acc; 
        
        Account acc1 = new Account(FirstName = 'testingFirstacc1',
            LastNAme = 'testingLastacc1',
            Recordtypeid = RTId ,     
            PersonMobilePhone = '1234567890',
            PersonEmail = 'testing1@test.com',
            CRN__c='999001',
            Project_Name__c = 'Casa Rio',
            //name = 'TestAccount123',
            owner = u1
        );
        insert acc1; 
       
        
        Booking_details__c bookingObj = new Booking_details__c (
            //CV_paid_New__c=9000000, 
            Registration_Status__c='registered', 
            CLuster__c='c', 
            Wing__c='w', 
            Flat_No__c='A101', 
            Application_Date__c= Date.today(), 
            Consideration_Value__c= 9000000,
            Account__c = acc.Id,
            Flat_ID__c='1234', 
            CRN__c = '999000'
        );
        insert bookingObj;
        
        Demands__c d1 = new Demands__c(Account__c = acc.Id, Amount_received__c=400000.00, Flat_ID__c = bookingObj.Id);
        Demands__c d2 = new Demands__c(Account__c = acc.Id, Amount_received__c=80000.00, Flat_ID__c = bookingObj.Id);
        Demands__c d3 = new Demands__c(Account__c = acc.Id, Amount_received__c=900000.00, Flat_ID__c = bookingObj.Id);
        List<Demands__c> demandsList = new List<Demands__c>();
        insert demandsList;
        
        
        Case c1 = new Case(origin = 'Web',  
                       First_Name__c = 'testFirst'+'i',
                       Last_Name__c = 'testLast'+'i', 
                       Mobile__c = '1234567891',
                       Project__c = 'CASA Rio',
                       Buildings_Name__c = 'MARINA',
                       Wing__c = 'd',
                       Flat_No__c = '202',
                       Ownerid = u1.ID,
                       account=acc, 
                       communication_type__c = 'inbound', 
                       interaction_mode__c='Email', 
                       Nature_of_Request__c='Complaint',
                       Case_Summary__c='Test', 
                       Case_Resolution__c='Test',
                       Request_for_L1__c='Document Related', 
                       Request_for_L2__c='Customer wants original document', 
                       Request_for_L3_a__c='ROC',
                       date_of_complaint__c = DateTime.now(),
                       Remaining_Hours__c=24,
                       status = 'Open',
                       Needs_approval_from_director__c = 'YES');
        
        Case c2 = new Case(origin = 'Web',  
                       First_Name__c = 'testFirst'+'i',
                       Last_Name__c = 'testLast'+'i', 
                       Mobile__c = '1234567892',
                       Project__c = 'CASA Rio',
                       Buildings_Name__c = 'MARINA',
                       Wing__c = 'd',
                       Flat_No__c = '202',
                       Ownerid = u1.ID,
                       account=acc, 
                       communication_type__c = 'inbound', 
                       interaction_mode__c='Email', 
                       Nature_of_Request__c='Complaint',
                       //Case_Summary__c='Test', 
                       //Case_Resolution__c='Test',
                       Request_for_L1__c='Document Related', 
                       Request_for_L2__c='Customer wants original document', 
                       Request_for_L3_a__c='ROC',
                       date_of_complaint__c = DateTime.now(),
                       Remaining_Hours__c=24,
                       status = 'Open',
                       Needs_approval_from_director__c = 'YES'
                       );
                       
        Case c3 = new Case(origin = 'Web',  
                       First_Name__c = 'testFirst'+'i',
                       Last_Name__c = 'testLast'+'i', 
                       Mobile__c = '1234567892',
                       Project__c = 'CASA Rio',
                       Buildings_Name__c = 'MARINA',
                       Wing__c = 'd',
                       Flat_No__c = '202',
                       Ownerid = u1.ID,
                       account=acc1, 
                       communication_type__c = 'inbound', 
                       interaction_mode__c='Email', 
                       Nature_of_Request__c='Complaint',
                       //Case_Summary__c='Test', 
                       //Case_Resolution__c='Test',
                       Request_for_L1__c='Document Related', 
                       Request_for_L2__c='Customer wants original document', 
                       Request_for_L3_a__c='ROC',
                       date_of_complaint__c = DateTime.now(),
                       Remaining_Hours__c=24,
                       status = 'Open',
                       Needs_approval_from_director__c = 'YES',
                       ParentCaseType__c = 'Dummy Parent');
                       
        List<Case> caseList = new List<Case>();
        caseList.add(c1);
        caseList.add(c2);       
        caseList.add(c3);  
        insert caseList;
                          
        CM_ComplaintCasesReportHelper helpObj = new CM_ComplaintCasesReportHelper();
        helpObj.filterCases(caseList, Date.today().addDays(-2), Date.today().addDays(2));        
        helpObj.execute(caseList , false, DateTime.now(), 'Director', true);
        
        test.stopTest();
        }catch(Exception ex){
            System.debug('Error!!!!!!!!!!!!!!!!!!!....................' +  ex);
        }
    }
} */






@isTest(SeeAllData=true)
public class Test_CM_ComplaintCasesReportHelper{
    public static testMethod void testCM_ComplaintCasesReportHelper(){
        try{
            test.startTest();
        
            List<Case> caseList = [ Select CreatedDate, Nature_of_Request__c, 
                    Request_for_L1__c, Request_for_L2__c, Request_for_L3_a__c, Request_for_L3__c,              Status, TL_EmailId__c, Owner_EmailId__c, TL__c, PIC_EmailId__c,     Remaining_Hours__c, Owner.name, createdBy.email, Date_of_Complaint__c, Interaction_Mode__c, Priority, Case_Summary__c, Case_Resolution__c, Dependency_on_Internal_functions__c from case  where Nature_of_Request__c ='Complaint' and isClosed = false ];
            System.debug('caseList ' +  caseList );
            if( caseList != null){
                System.debug('caseList size==' +  caseList.size());
            }
                                    
            CM_ComplaintCasesReportHelper helpObj = new CM_ComplaintCasesReportHelper();
            
            List<Case> filterCaseList = helpObj.filterCases(caseList , DateTime.newInstance(2014,3,28,0,0,0), DateTime.newInstance(2014,4,1,0,0,0));        
            System.debug('filterCaseList ' +  filterCaseList );
            if( filterCaseList != null){
                System.debug('filterCaseList size==' +  filterCaseList .size());
            }
            //helpObj.execute(caseList, true, DateTime.now());
//            helpObj.execute(filterCaseList , false, DateTime.now());
         helpObj.execute(filterCaseList , false, DateTime.now(), 'Director', true);
    
            
        
        
       
        
        
        
        
            test.stopTest();
        }catch(Exception ex){
            System.debug('Error!!!!!!!!!!!!!!!!!!!....................' +  ex);
        }
    }
}