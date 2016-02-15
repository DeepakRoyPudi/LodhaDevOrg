global class SPbatchSendNotificationEmail implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
    global SPbatchSendNotificationEmail(){

    }

    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'select Id, Unique_booking_Id__c, Block_For_Days__c, Block_Date__c, Block_Sales_Person__c, Block_Sales_Person__r.Name, Booking_Status__c, Flat__c, Flat__r.Name  from Booking_Information__c Where Booking_Status__c = \'BLOCKED\'';
        system.debug('querys:'+query);
        return Database.getQueryLocator(query);
    }
         
    global void execute(Database.BatchableContext BC, List<Booking_Information__c> BookingInformation){
        if(BookingInformation.size() > 0){
            List<Booking_Information__c> emailBookingList = new List<Booking_Information__c>();
            List<Flat__c> FlatList = new List<Flat__c>();
            List<Booking_Information__c> BookingInformationList = new List<Booking_Information__c>();
            for(Booking_Information__c booking: BookingInformation){
                if(booking.Block_Date__c.addDays(integer.ValueOf(booking.Block_For_Days__c)-1) == system.today()){
                    emailBookingList.add(booking);
                }
                else if(booking.Block_Date__c.addDays(integer.ValueOf(booking.Block_For_Days__c)) == system.today()){
                    if(Booking.Flat__c != NULL)
                    {
                        Flat__c Flat = new Flat__c(Id = Booking.Flat__c, Status__c = 'OPEN');
                        FlatList.add(Flat);
                    }
                      booking.Flat__c = null;
                      booking.InActive__c = TRUE;
                      
                      BookingInformationList.add(booking);
                }
            }
            system.debug('FlatList: ' + FlatList);
            system.debug('BookingInformationList: ' + BookingInformationList);
            system.debug('emailBookingList: ' + emailBookingList);
            if(FlatList.size() > 0)
            {
                update FlatList;
            }
            if(BookingInformationList.size() > 0)
            {
                //delete BookingInformationList;
                Upsert BookingInformationList;
            }
            if(emailBookingList.size() > 0)
            {
                List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
                for(Booking_Information__c emailBooking:emailBookingList)
                {
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setBccSender(false);
                    mail.setUseSignature(false);
                    mail.setTargetObjectId(emailBooking.Block_Sales_Person__c);
                    mail.setSubject('Notification Email');
                    mail.setHtmlBody('Hi ' + emailBooking.Block_Sales_Person__r.Name +',' + '<br/> <br/>         Your blocked Flat No:' + emailBooking.Flat__r.Name + ' going to re-open');
                    mail.setReplyTo('noreplay@LodhaGroup.com');
                    mail.setSenderDisplayName('Lodha Admin');
                    mail.setSaveAsActivity(false); 
                    mailList.add(mail);
                    
                }
                Messaging.sendEmail(mailList);
            }
        }
    
    }

    global void finish(Database.BatchableContext BC){
        // send batch execution email;      
    }
    
    
    static testMethod void testSPbatchSendNotificationEmail(){
        
          Test.startTest();
          
          List<Booking_Information__c> bookingList = new List<Booking_Information__c>();
          
          SpTestInsertions spTestInsertions = new SpTestInsertions();
        
          Account accountTest = new Account(recordtypeid =Schema.SObjectType.Account.getRecordTypeInfosByName().get('Booked Account').getRecordTypeId(),LastName ='Test Last Name',Mobile_Phone__c ='456872934');
          insert accountTest;
    
          Project_Name__c projectNameTest = spTestInsertions.createProjectName();
          insert projectNameTest;    
    
          Cluster__c clusterTest = spTestInsertions.createCluster(projectNameTest);
          insert clusterTest;
      
    
          //Stage__c stageTest = spTestInsertions.createStage();
         // insert stageTest;
    
          Wing__c wingTest = spTestInsertions.createWing(clusterTest);
          insert wingTest;
    
    
          Flat_Type__c flatTypeTest = spTestInsertions.createFlatType(wingTest);
          insert flatTypeTest;
    
          Stage_Details__c stageDetailsTest = spTestInsertions.createStageDetails(wingTest);
          insert stageDetailsTest;
        
          View_type_Assignment__c viewTypeAssignTest1 = new View_type_Assignment__c(Wing__c=wingTest.Id,Flat_Type__c=flatTypeTest.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('Flat Type Record').getRecordTypeId(),Pattern__c ='All', Column_Index__c = '1');
          insert viewTypeAssignTest1;
          
          View_type_Assignment__c viewTypeAssignTest2 = new View_type_Assignment__c(Wing__c=wingTest.Id,Flat_Type__c=flatTypeTest.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('Flat Type Record').getRecordTypeId(),Pattern__c ='All', Column_Index__c = '2');
          insert viewTypeAssignTest2;
    
          View_type_Assignment__c viewTypeAssignTest3 = new View_type_Assignment__c(Wing__c=wingTest.Id,Flat_Type__c=flatTypeTest.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('View Type Record').getRecordTypeId(),Pattern__c ='All',View__c='Sea View', Column_Index__c = '1');
          insert viewTypeAssignTest3;
          
          View_type_Assignment__c viewTypeAssignTest4 = new View_type_Assignment__c(Wing__c=wingTest.Id,Flat_Type__c=flatTypeTest.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('View Type Record').getRecordTypeId(),Pattern__c ='All',View__c='Sea View', Column_Index__c = '2');
          insert viewTypeAssignTest4;
    
          Rate_Card__c rateCardTest1 = new Rate_Card__c (Wing__c=wingTest.Id,recordtypeid=Schema.SObjectType.Rate_Card__c.getRecordTypeInfosByName().get('Premium View Rate Record').getRecordTypeId(),Flat_Type__c=flatTypeTest.Id,Premium_View__c='Sea View',View_Rate_Sq_Ft__c=20);
          insert rateCardTest1;
    
          Rate_Card__c rateCardTest2 = new Rate_Card__c (Wing__c=wingTest.Id,recordtypeid=Schema.SObjectType.Rate_Card__c.getRecordTypeInfosByName().get('Floor Rise Rate').getRecordTypeId(),Flat_Type__c=flatTypeTest.Id,Floor_From__c=1,Floor_To__c=2,Floor_Rise_Sq_Ft__c=20);
          insert rateCardTest2;
    
    
           ApexPages.StandardController stc = new ApexPages.StandardController(wingTest); 
           SpGenerateInventory testSpGenerateInventory = new SpGenerateInventory(stc);
            testSpGenerateInventory.generateInventory();
 
          Flat__c FlatTest = [select Id,Salable_Area__c from Flat__c Where Wing__c=:wingTest.Id limit 1]; 
    
        
         Opportunity opportunityTest = new Opportunity(Name='Test Opportunity',recordtypeid =Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Residential').getRecordTypeId(),Account = accountTest,CloseDate=System.now().date()+20,Project_Name__c = projectNameTest.id,StageName = 'Qualified',Servicing_Team__c='Presales',IsActive__c=true);
         insert opportunityTest; 
        
        
        
         Booking_Information__c bookingInformationTest= new Booking_Information__c(Booking_Status__c='BLOCKED',Block_Date__c=System.now().date()-9,Block_For__c=opportunityTest.id,Block_For_Days__c=10,Block_Sales_Person__c=UserInfo.getUserId(),Name_Of_Opportunity__c=opportunityTest.id,Unique_booking_Id__c=FlatTest.id,Flat__c=FlatTest.id,Block_Detail__c='Test Block Details',Consideration_Actual_Rs__c=10000,Infrastructure_Incl_in_CV__c='Incl.in CV',Infrastructure2_Incl_in_CV__c='Incl.in CV',Club_Charges_Incl_in_CV__c='Incl.in CV',Infrastructure_Cost_Rs__c=100,Infrastructure_Cost_2_Rs__c=100,Club_Charges_Rs__c=100,Infrastructure_Cost_2Actual_Rs__c=100,Infrastructure_Cost_Actual_Rs__c=150,Club_charges_Actual_Rs__c=100,Base_Rate_Sq_ft_Actual_Rs__c=120,Floor_rise_Sq_ft_Actual_Rs__c=120,Premium_Sq_ft_Actual_Rs__c=120,Applicable_Waiver_Sq_ft_Actual_Rs__c=120,Total_Rate_Sq_ft_Actual_Rs__c=120,Flat_Cost_Actual_Rs__c=120,Applicable_Waiver_Sq_ft_Rs__c=100,Booking_Date__c=System.now().date());
         insert bookingInformationTest;
         
         Booking_Information__c bookingInformationTest1= new Booking_Information__c(Booking_Status__c='BLOCKED',Block_Date__c=System.now().date()-10,Block_For__c=opportunityTest.id,Block_For_Days__c=10,Block_Sales_Person__c=UserInfo.getUserId(),Name_Of_Opportunity__c=opportunityTest.id,Unique_booking_Id__c=FlatTest.id,Flat__c=FlatTest.id,Block_Detail__c='Test Block Details',Consideration_Actual_Rs__c=10000,Infrastructure_Incl_in_CV__c='Incl.in CV',Infrastructure2_Incl_in_CV__c='Incl.in CV',Club_Charges_Incl_in_CV__c='Incl.in CV',Infrastructure_Cost_Rs__c=100,Infrastructure_Cost_2_Rs__c=100,Club_Charges_Rs__c=100,Infrastructure_Cost_2Actual_Rs__c=100,Infrastructure_Cost_Actual_Rs__c=150,Club_charges_Actual_Rs__c=100,Base_Rate_Sq_ft_Actual_Rs__c=120,Floor_rise_Sq_ft_Actual_Rs__c=120,Premium_Sq_ft_Actual_Rs__c=120,Applicable_Waiver_Sq_ft_Actual_Rs__c=120,Total_Rate_Sq_ft_Actual_Rs__c=120,Flat_Cost_Actual_Rs__c=120,Applicable_Waiver_Sq_ft_Rs__c=100,Booking_Date__c=System.now().date());
         insert bookingInformationTest1;
         
         
         bookingList.add(bookingInformationTest);
         bookingList.add(bookingInformationTest1);
         
         Id admId = [Select Id from Profile where Name =:'System Administrator' limit 1].id;
         User adm = [Select Id from User Where profileId =: admId AND isActive = true limit 1];
         
          system.Runas(adm){
            //execute batch class
            Database.BatchableContext BC;
            SPbatchSendNotificationEmail testsPbatchSendNotificationEmail  = new SPbatchSendNotificationEmail();
            testsPbatchSendNotificationEmail.start(BC);
            Database.executeBatch(testsPbatchSendNotificationEmail);
            testsPbatchSendNotificationEmail.execute(BC, bookingList);
            }
            
              Test.stopTest();
         
        
    }
}