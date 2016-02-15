@isTest(seealldata=false)
Public class Test_CM_BatchClass_Opp_Case_Transfer{

Public testmethod static void CM_BatchClass_Opp_Case_Transfer(){
Project_Name__c projectNameTest = new Project_Name__c(Name='Test Project Name',CRN_INIT__c= 'LCP', Project_Type__c = 'Test Casa',Record_Type__c='Test Residential');
insert projectNameTest; 

//Account accountTest = new Account(firstname='Testtest',CRN__c='1231567',LoyaltyID__c ='1234',Status__c='Active',PersonEmail='ssss@gmail.com',Personal_Email__pc='ssss@gmail.com',recordtypeid =Schema.SObjectType.Account.getRecordTypeInfosByName().get('Booked Account').getRecordTypeId(),LastName ='Test Last Name',Mobile_Phone__c ='1234567890');
//insert accountTest;

id RTId = [Select id from RecordType where Name = 'Booked Account'].id;
    Account a = new Account(FirstName = 'wedert',
                            LastNAme = 'wedert',
                            Recordtypeid = RTId,
                            Status__c = 'Created',
                            PersonMobilePhone = '2222222222',
                            PersonEmail = 'wwwww@test.com',
                            CRN__c = '1231567',
                            Personal_Email__pc = 'wwwww@test.com'
                            );
    insert a;   
    
    a.Status__c = 'Active';
    update a;
    
Account accountTest1 = new Account(firstname='Testtest',LoyaltyID__c ='1234',PersonEmail='ssss@gmail.com',Personal_Email__pc='ssss@gmail.com',recordtypeid =Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId(),LastName ='Test Last Name',Mobile_Phone__c ='1234567890');
insert accountTest1;
     
Opportunity opportunityTestNew = new Opportunity(Name='Test Opportunity',recordtypeid =Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Commercial and Retail').getRecordTypeId(),Account = accountTest1,CloseDate=System.now().date()+20,Project_Name__c = projectNameTest.id,StageName = 'Qualified',Servicing_Team__c='Presales',Name_of_PSC__c='Amarjyot Kaur',IsActive__c=true,Walk_in_Source__c='Newspaper',LoyaltyID__c='LoyaltyID',Visit_Form_No__c='V19857678');
insert opportunityTestNew;

Cluster__c clusterTest = new Cluster__c(Name='Test Cluster3',Project_Name__c = projectNameTest.Id);
insert clusterTest;

Wing__c wingTest = new Wing__c(Name='Test Wing',Cluster__c=clusterTest.Id,No_of_Floors__c=3,No_of_flats_floor__c=2);
wingTest.Project_Incharge_Relationship_Manager__c = projectNameTest.Project_Manager__c;
insert wingTest;
   
Flat__c f1 = new Flat__c(Wing__c=wingTest.Id,Flat_No__c=232,Status__c='SOLD');
insert f1;

Booking_Information__c bookingInformationTest= new Booking_Information__c(Name_Of_Opportunity__c=opportunityTestNew.id,Unique_booking_Id__c=f1.id,flat__c=f1.id,CRN_Number_SAP__c='1234567',Booking_Status__c='SOLD',Block_Detail__c='Test Block Details',Consideration_Actual_Rs__c=10000,Infrastructure_Incl_in_CV__c='Incl.in CV',Infrastructure2_Incl_in_CV__c='Incl.in CV',Club_Charges_Incl_in_CV__c='Incl.in CV',Infrastructure_Cost_Rs__c=100,Infrastructure_Cost_2_Rs__c=100,Club_Charges_Rs__c=100,Infrastructure_Cost_2Actual_Rs__c=100,Name_of_Applicant__c='Test Opportunity',Infrastructure_Cost_Actual_Rs__c=150,Club_charges_Actual_Rs__c=100,Base_Rate_Sq_ft_Actual_Rs__c=120,Floor_rise_Sq_ft_Actual_Rs__c=120,Premium_Sq_ft_Actual_Rs__c=120,Applicable_Waiver_Sq_ft_Actual_Rs__c=120,Total_Rate_Sq_ft_Actual_Rs__c=120,Flat_Cost_Actual_Rs__c=120,Applicable_Waiver_Sq_ft_Rs__c=100,Booking_Date__c=System.now().date(),DAM_Offer_Sq_ft_Actual_Rs__c=20,Selected_discount_type__c ='DAM',CRN__c= 'CRN',Booking_By__c= 'News Paper',Customer_Type__c= 'Corporate',Sales_Person__c=UserInfo.getUserId(),Total__c = 1050000,Contact_Nos__c='1234567890',Total_Rate_Sq_ft_Rs__c=1500,Date_of_First_Visit__c=System.now().date());
insert bookingInformationTest;

CM_Tat_Calculation__c cw1=new CM_Tat_Calculation__c(CaseType__c='Parent',Legal__c=1,Non_Legal__c =1,Name='Parent');
insert cw1;
CM_Tat_Calculation__c cw2=new CM_Tat_Calculation__c(CaseType__c='Child',Legal__c=1,Non_Legal__c =1,Name='Child');
insert cw2;
CM_Tat_Calculation__c cw3=new CM_Tat_Calculation__c(CaseType__c='AIFTM',Legal__c=1,Non_Legal__c =1,Name='AIFTM');
insert cw3;
CM_Tat_Calculation__c cw4=new CM_Tat_Calculation__c(CaseType__c='AISPOC',Legal__c=1,Non_Legal__c =1,Name='AISPOC');
insert cw4;

Case c1 = new Case( Mobile__c = '1234567891',
                   Project__c = 'CASA Rio',
                   Buildings_Name__c = 'MARINA',
                   Wing__c = 'd',
                   Flat_No__c = '202',
                   Interaction_Mode__c='Call',
                   Communication_Type__c='Inbound',
                   Status='Working',
                   Nature_of_Request__c='Request',
                   Request_for_L1__c='Document Related',
                   Request_for_L2__c='Customer wants original document',
                   Request_for_L3_a__c='NOC',
                   Request_for_L3__c='',Related_Booking__c=bookingInformationTest.id,
                   Opportunity__c=opportunityTestNew.id
                   ); 
                               
//insert c1;

CM_BatchClass_Opp_Case_Transfer batch=new CM_BatchClass_Opp_Case_Transfer ();
ID batchprocessid=Database.executeBatch(batch);
}

}