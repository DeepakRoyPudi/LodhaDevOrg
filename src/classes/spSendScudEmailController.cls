public class spSendScudEmailController{

    public SCUD_Information__c ScudInfo {get; set;}
    public boolean sendEmail {get; set;}
    public String scudStatus {get; set;}
    Id emailTemplate;
    Id emailTemplateForSM;
    Id emailTemplateForSI;
    Id emailTemplateForRM;
    Id emailTemplateForPI;
    
    public spSendScudEmailController(ApexPages.StandardController controller) {
        scudStatus = 'Approve';
        errorMessage = False;
        SCUD_Information__c ScudId = (SCUD_Information__c)controller.getRecord();
        ScudInfo = [Select Id, SCUD_Status__c, Sales_Strategist_Comments__c, CreatedById, Level_1_SI__c, Booking_Information__r.Flat__r.Wing__r.Project_Incharge_Relationship_Manager__c, Booking_Information__r.Name_Of_Opportunity__r.Project_Name__r.Project_Incharge__c From SCUD_Information__c Where Id=:ScudId.Id];
        ScudInfo.Sales_Strategist_Comments__c = '';
        if(ScudInfo.SCUD_Status__c == 'Submitted to SCUD Committee'){
            sendEmail = False;
        }else{
            sendEmail = True;
        }
    }
    boolean errorMessage;
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('Approve','Approve') ); 
        options.add(new SelectOption('Reject','Reject')); 
        return options;
    }

    public Pagereference send_email() {
        Map<String, Id> EmailIds = new Map<String, Id>();
        List<String> EmailNames = new List<String> {'SCUD Committee Accepted Template', 'SCUD Committee Rejected Template', 'SCUD Committee Accepted Template SM', 'SCUD Committee Rejected Template SM', 'SCUD Committee Accepted Template SI', 'SCUD Committee Rejected Template SI', 'SCUD Committee Accepted Template RM', 'SCUD Committee Accepted Template PI'};
        List<EmailTemplate> emailTempList = [Select Id, Name From EmailTemplate where Name IN :EmailNames];
        for(EmailTemplate EmailTemplates : emailTempList){
            EmailIds.put(EmailTemplates.Name, EmailTemplates.Id);
        }
        if(scudStatus == 'Approve'){
            emailTemplate = EmailIds.get('SCUD Committee Accepted Template');
            emailTemplateForSM = EmailIds.get('SCUD Committee Accepted Template SM');
            emailTemplateForSI = EmailIds.get('SCUD Committee Accepted Template SI');
            emailTemplateForRM = EmailIds.get('SCUD Committee Accepted Template RM');
            emailTemplateForPI = EmailIds.get('SCUD Committee Accepted Template PI');
            ScudInfo.SCUD_Status__c = 'Approved';
        }else{
            emailTemplate = EmailIds.get('SCUD Committee Rejected Template');
            emailTemplateForSM = EmailIds.get('SCUD Committee Rejected Template SM');
            emailTemplateForSI = EmailIds.get('SCUD Committee Rejected Template SI');
            ScudInfo.SCUD_Status__c = 'Rejected';
        }
        update ScudInfo;
        
        Id pGroup = [select Id from Group where Type='Regular' and DeveloperName='SCUD_Users'].Id;
        List<GroupMember> gMember = [select UserOrGroupId from GroupMember Where GroupId = :pGroup];
        
        List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
        // Sending mail to Scud Committee Members
        for(GroupMember GM: gMember){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setBccSender(false);
            mail.setUseSignature(false);
            mail.setTargetObjectId(GM.UserOrGroupId);
            mail.setTemplateId(emailTemplate);
            mail.setwhatId(ScudInfo.Id);
            mail.setReplyTo('noreplay@LodhaGroup.com');
            mail.setSenderDisplayName('Lodha Admin');
            mail.setSaveAsActivity(false); 
            mailList.add(mail);
        }
        if(!errorMessage){
            Messaging.sendEmail(mailList);
        }
        
        // Sending mail to SI
        Messaging.SingleEmailMessage SIMail = new Messaging.SingleEmailMessage();
        SIMail.setBccSender(false);
        SIMail.setUseSignature(false);
        SIMail.setTargetObjectId(ScudInfo.Level_1_SI__c);
        SIMail.setTemplateId(emailTemplateForSI);
        SIMail.setwhatId(ScudInfo.Id);
        SIMail.setReplyTo('noreplay@LodhaGroup.com');
        SIMail.setSenderDisplayName('Lodha Admin');
        SIMail.setSaveAsActivity(false); 
        system.debug('SIMail:' + SIMail);
        if(!errorMessage){
            Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ SIMail });
        }
        
        // Sending mail to SM
        Messaging.SingleEmailMessage SMMail = new Messaging.SingleEmailMessage();
        SMMail.setBccSender(false);
        SMMail.setUseSignature(false);
        SMMail.setTargetObjectId(ScudInfo.CreatedById);
        SMMail.setTemplateId(emailTemplateForSM);
        SMMail.setwhatId(ScudInfo.Id);
        SMMail.setReplyTo('noreplay@LodhaGroup.com');
        SMMail.setSenderDisplayName('Lodha Admin');
        SMMail.setSaveAsActivity(false); 
        if(!errorMessage){
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { SMMail });
        }
        if(scudStatus == 'Approve'){
            // Sending mail to RM
            Messaging.SingleEmailMessage RMMail = new Messaging.SingleEmailMessage();
            RMMail.setBccSender(false);
            RMMail.setUseSignature(false);
            RMMail.setTargetObjectId(ScudInfo.Booking_Information__r.Flat__r.Wing__r.Project_Incharge_Relationship_Manager__c);
            RMMail.setTemplateId(emailTemplateForRM);
            RMMail.setwhatId(ScudInfo.Id);
            RMMail.setReplyTo('noreplay@LodhaGroup.com');
            RMMail.setSenderDisplayName('Lodha Admin');
            RMMail.setSaveAsActivity(false); 
            if(!errorMessage){
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { RMMail });
            }
            
            // Sending mail to PI
            Messaging.SingleEmailMessage PIMail = new Messaging.SingleEmailMessage();
            PIMail.setBccSender(false);
            PIMail.setUseSignature(false);
            PIMail.setTargetObjectId(ScudInfo.Booking_Information__r.Name_Of_Opportunity__r.Project_Name__r.Project_Incharge__c);
            PIMail.setTemplateId(emailTemplateForPI);
            PIMail.setwhatId(ScudInfo.Id);
            PIMail.setReplyTo('noreplay@LodhaGroup.com');
            PIMail.setSenderDisplayName('Lodha Admin');
            PIMail.setSaveAsActivity(false); 
            if(!errorMessage){
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { PIMail });
            }
        }
        
      return null;
    }
    @istest(seealldata=false)
    private static void TestspSendScudEmailController(){
        SpTestInsertions spTestInsertions = new SpTestInsertions();
        
        //test scenario to check when the fame status is Reject
        
        Account accountTest = new Account(recordtypeid =Schema.SObjectType.Account.getRecordTypeInfosByName().get('Booked Account').getRecordTypeId(),LastName ='Test Last Name',Mobile_Phone__c ='456872934');
        insert accountTest;
    
        Project_Name__c projectNameTest = spTestInsertions.createProjectName();
        insert projectNameTest;    
    
        Cluster__c clusterTest = spTestInsertions.createCluster(projectNameTest);
        insert clusterTest;
      
    
    
        Wing__c wingTest = spTestInsertions.createWing(clusterTest);
        wingTest.Project_Incharge_Relationship_Manager__c = projectNameTest.Project_Manager__c;
        insert wingTest;
    
    
        Flat_Type__c flatTypeTest = spTestInsertions.createFlatType(wingTest);
        insert flatTypeTest;
    
        Stage_Details__c stageDetailsTest = spTestInsertions.createStageDetails(wingTest);
        insert stageDetailsTest;
        
        View_type_Assignment__c viewTypeAssignTest1 = new View_type_Assignment__c(Wing__c=wingTest.Id,Flat_Type__c=flatTypeTest.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('Flat Type Record').getRecordTypeId(),Pattern__c ='All', Column_Index__c  = '1');
        insert viewTypeAssignTest1;
        
        View_type_Assignment__c viewTypeAssignTest2 = new View_type_Assignment__c(Wing__c=wingTest.Id,Flat_Type__c=flatTypeTest.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('Flat Type Record').getRecordTypeId(),Pattern__c ='All', Column_Index__c = '2');
        insert viewTypeAssignTest2;
    
        View_type_Assignment__c viewTypeAssignTest3 = new View_type_Assignment__c(Wing__c=wingTest.Id,Flat_Type__c=flatTypeTest.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('View Type Record').getRecordTypeId(),Pattern__c ='All',View__c='Sea View', Column_Index__c  ='1');
        insert viewTypeAssignTest3;
        
        View_type_Assignment__c viewTypeAssignTest4 = new View_type_Assignment__c(Wing__c=wingTest.Id,Flat_Type__c=flatTypeTest.Id,recordtypeid=Schema.SObjectType.View_type_Assignment__c.getRecordTypeInfosByName().get('View Type Record').getRecordTypeId(),Pattern__c ='All',View__c='Sea View', Column_Index__c  = '2');
        insert viewTypeAssignTest4;
    
        Rate_Card__c rateCardTest1 = new Rate_Card__c (Wing__c=wingTest.Id,recordtypeid=Schema.SObjectType.Rate_Card__c.getRecordTypeInfosByName().get('Premium View Rate Record').getRecordTypeId(),Flat_Type__c=flatTypeTest.Id,Premium_View__c='Sea View',View_Rate_Sq_Ft__c=20);
       insert rateCardTest1;
    
       Rate_Card__c rateCardTest2 = new Rate_Card__c (Wing__c=wingTest.Id,recordtypeid=Schema.SObjectType.Rate_Card__c.getRecordTypeInfosByName().get('Floor Rise Rate').getRecordTypeId(),Flat_Type__c=flatTypeTest.Id,Floor_From__c=1,Floor_To__c=2,Floor_Rise_Sq_Ft__c=20);
       insert rateCardTest2;
    
    
        ApexPages.StandardController stc = new ApexPages.StandardController(wingTest); 
        SpGenerateInventory testSpGenerateInventory = new SpGenerateInventory(stc);
        testSpGenerateInventory.generateInventory();
 
        Flat__c FlatTest = [select Id,Salable_Area__c,Flat_no_text__c from Flat__c Where Wing__c=:wingTest.Id limit 1]; 
    
              
        Opportunity opportunityTest = new Opportunity(Name='Test Opportunity',recordtypeid =Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Residential').getRecordTypeId(),Account = accountTest,CloseDate=System.now().date()+20,Project_Name__c = projectNameTest.id,StageName = 'Qualified',Servicing_Team__c='Presales',IsActive__c=true);
        insert opportunityTest; 
        
        
        Booking_Information__c bookingInformationTest= new Booking_Information__c(Name_Of_Opportunity__c=opportunityTest.id,Unique_booking_Id__c=FlatTest.id,Flat__c=FlatTest.id,Block_Detail__c='Test Block Details',Consideration_Actual_Rs__c=10000,Infrastructure_Incl_in_CV__c='Incl.in CV',Infrastructure2_Incl_in_CV__c='Incl.in CV',Club_Charges_Incl_in_CV__c='Incl.in CV',Infrastructure_Cost_Rs__c=100,Infrastructure_Cost_2_Rs__c=100,Club_Charges_Rs__c=100,Infrastructure_Cost_2Actual_Rs__c=100,Infrastructure_Cost_Actual_Rs__c=150,Club_charges_Actual_Rs__c=100,Base_Rate_Sq_ft_Actual_Rs__c=120,Floor_rise_Sq_ft_Actual_Rs__c=120,Premium_Sq_ft_Actual_Rs__c=120,Applicable_Waiver_Sq_ft_Actual_Rs__c=120,Total_Rate_Sq_ft_Actual_Rs__c=120,Flat_Cost_Actual_Rs__c=120,Applicable_Waiver_Sq_ft_Rs__c=100,Booking_Date__c=System.now().date(),Project_Hidden__c='Test Project Name', Booking_Status__c='Booking', Sales_Person__c = UserInfo.getUserId());
        insert bookingInformationTest;
        
        SCUD_Information__c SI = new SCUD_Information__c(Booking_Information__c=bookingInformationTest.Id , SCUD_Status__c = 'Submitted to SCUD Committee', Sales_Strategist_Comments__c = '', Level_1_SI__c = UserInfo.getUserId());
        insert SI;
        ApexPages.StandardController controller = new ApexPages.StandardController(SI);
        spSendScudEmailController SendScudEmailController = new spSendScudEmailController(controller);
        SendScudEmailController.getItems();
        SendScudEmailController.errorMessage = True;
        SendScudEmailController.send_email();
        SendScudEmailController.scudStatus = 'Reject';
        SendScudEmailController.errorMessage = True;
        SendScudEmailController.send_email();
    }
}