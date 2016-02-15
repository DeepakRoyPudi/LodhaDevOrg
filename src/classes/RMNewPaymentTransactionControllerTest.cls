@Istest(seealldata=false)
Public class RMNewPaymentTransactionControllerTest{
  
public static testmethod void testRMNewTransactionController(){
 
String clickToCall='9856825465';
String AccoutnbookingCRN1='1210055';
String plant1='TestPlant';

Project_Name__c project1=RMNewPaymentTransactionControllerTest.createProject();
Account acc1=RMFavouringDetailsControllerTest.createAccount(project1,clickToCall,AccoutnbookingCRN1);
Booking_Details__c booking_details1=RMNewPaymentTransactionControllerTest.createBookingDetail( project1, acc1,plant1);     


PageReference pageRef_1 = new PageReference('/apex/RMNewPaymentTransaction?crn='+AccoutnbookingCRN1);
Test.setCurrentPage(pageRef_1);
ApexPages.StandardController controller = new ApexPages.StandardController(new Booking_Payment_Transaction__c());

//Scenario-1 With all the valid data
RMNewPaymentTransactionController objRMPTC1 = new RMNewPaymentTransactionController(controller); 
objRMPTC1.fetch();       
objRMPTC1.bpt.Type_of_Transaction_del__c='RTGS';
       objRMPTC1.bpt.UTR_Code__c='dddddddddddddddddddddd';  
        objRMPTC1.bpt.Bank_Account_Holders_Name__c='Test';
        objRMPTC1.bpt.Amount_Transferred__c=1200;
        objRMPTC1.bpt.Remitted_to_Account__c='test';
        objRMPTC1.bpt.Transaction_Date__c= date.newinstance(2013,5,2);
        objRMPTC1.bpt.Bank_Name__c='Andhra Bank';
        objRMPTC1.addAttachment();
        objRMPTC1.lstAttachment = RMNewPaymentTransactionControllerTest.createAttachment(5);
        objRMPTC1.UploadFile();
        objRMPTC1.addAttachment();
        objRMPTC1.lstAttachment = RMNewPaymentTransactionControllerTest.createAttachment(4);
        objRMPTC1.bptSave();
        


//Scenario -2 When with no data in required field except which field are filled by fetch method 
        objRMPTC1.fetch();       
        objRMPTC1.bptSave();

//Scenario -3 With Same Utr Code Which is all ready exist
        objRMPTC1.fetch();  
        objRMPTC1.bpt.Type_of_Transaction_del__c='RTGS';
        objRMPTC1.bpt.UTR_Code__c='dddddddddddddddddddddd';  
        objRMPTC1.bpt.Bank_Account_Holders_Name__c='Test';
        objRMPTC1.bpt.Amount_Transferred__c=1200;
        objRMPTC1.bpt.Remitted_to_Account__c='test';
        objRMPTC1.bpt.Transaction_Date__c= date.newinstance(2013,5,2);
        objRMPTC1.bpt.Bank_Name__c='Andhra Bank';
        objRMPTC1.bptSave();

//Scenario -4 When not any input the data and directlty call addAttachment will give a error on page So below scenario cove it  
        objRMPTC1.fetch();       
        objRMPTC1.addAttachment();

//Scenario -5 With Type of Transaction : Direct Cheque and MT940__c: null
        objRMPTC1.fetch();  
        objRMPTC1.bpt.Type_of_Transaction_del__c='Direct Cheque';
        objRMPTC1.bpt.UTR_Code__c='sdfsd32423423423423423';  
        objRMPTC1.bpt.Bank_Account_Holders_Name__c='Test';
        objRMPTC1.bpt.Amount_Transferred__c=1200;
        objRMPTC1.bpt.Remitted_to_Account__c='test';
        objRMPTC1.bpt.Transaction_Date__c= date.newinstance(2013,5,2);
        objRMPTC1.bpt.Bank_Name__c='Andhra Bank';
        objRMPTC1.bpt.MT940__c=null;
        objRMPTC1.bptSave();

//Scenario -6 With Type of Transaction : Direct Cheque and MT940__c: null
         objRMPTC1.bpt.Type_of_Transaction_del__c = 'RTGS';
         objRMPTC1.bpt.UTR_Code__c='12345';
         objRMPTC1.bptSave();


//Scenario -7 With Type of Transaction : Direct Cheque and MT940__c: null UTR Code 000
        objRMPTC1.fetch();  
        objRMPTC1.bpt.Type_of_Transaction_del__c='Direct Cheque';
        objRMPTC1.bpt.UTR_Code__c='000000000000000000000';  
        objRMPTC1.bpt.Bank_Account_Holders_Name__c='Test';
        objRMPTC1.bpt.Amount_Transferred__c=1200;
        objRMPTC1.bpt.Remitted_to_Account__c='test';
        objRMPTC1.bpt.Transaction_Date__c= date.newinstance(2013,5,2);
        objRMPTC1.bpt.Bank_Name__c='Andhra Bank';
        objRMPTC1.bpt.MT940__c=null;
        objRMPTC1.bptSave();

//Scenario -3 With Same Utr Code Which is all ready exist
        objRMPTC1.fetch();  
        objRMPTC1.bpt.Type_of_Transaction_del__c='RTGS';
        objRMPTC1.bpt.UTR_Code__c='dddddddddddddddddddddd';  
        objRMPTC1.bpt.Bank_Account_Holders_Name__c='Test';
        objRMPTC1.bpt.Amount_Transferred__c=1200;
        objRMPTC1.bpt.Remitted_to_Account__c='test';
        objRMPTC1.bpt.Transaction_Date__c= date.newinstance(2013,5,2);
        objRMPTC1.bpt.Bank_Name__c='Andhra Bank';
        objRMPTC1.bptSave();
              


}
    

public static Project_Name__c createProject(){

 Project_Name__c p1 = new Project_Name__c();
        p1.name = 'ProjectTest1';
        p1.Project_Type__c = 'Casa';
        p1.Record_Type__c = 'Residential';
        //p1.CurrencyIsoCode='INR - Indian Rupee';
        p1.OrderType__c = 'Default';
        insert p1;
        
        
        return p1;  
}  
    
public static Account createAccount(Project_Name__c p1,String clickToCall,String AccoutnbookingCRN1 ){
 
 
   Account a1 =new Account();
   a1.Primary_PAN_number__c='KLKL45127M';
   a1.AccountSource='Business Development';
   a1.CRN__c=AccoutnbookingCRN1;
   a1.lastname='testAccount1'+math.random();
   a1.recordtypeid=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Booked Account').getRecordTypeId();
   a1.Click_To_Call__c=clickToCall;
   a1.Preferred_Mode_of_Contact__c='Phone';
   a1.TDS_Related__c='Authorized Lodha to pay';
   a1.BillingCountry='India';
   a1.TRAI_DND__c=true;
   a1.Alternate_Designation__c='Manager';
   a1.Occupation_acc__c='Salaried';
   a1.Type_of_Home__c='2 bhk';
   a1.Industry='IT Services';
   a1.Specify_Residences_owned_at_Lodha_group__c='15';
   a1.Other_residences_owned_at_Lodha_Group_CC__c=15;
   a1.Club_Membership__pc='cm';
   a1.Car_s_Owned__c='5';
   a1.Assets_Owned_Homes__c=15;
   a1.Current_Home_ownership__c='Owned';
   a1.Hobbies__c='Dancing';
   a1.Purpose_of_Purchase__c='Second Home';
   a1.Children_Names__c='aaa | bbbb';
   a1.Children_s_DOB__c='12/01/1999 | 13/01/2001';
   a1.No_of_children__c=2;
   a1.DOB_of_Spouse__c= date.newInstance(1970, 1, 1);
   a1.Spouse_Name__c='testspouce';
   a1.Anniversary_Date__c= date.newInstance(1997, 1, 1);
   a1.Age__c=46;
   a1.Ethinicity__c='Bengali';
   a1.DOB_Of_Client__c= date.newInstance(1969, 1, 1);
   a1.PersonEmail='test@lodhauser.com';
   a1.Person_email_from_trigger__c='testuser@mylodhamail.com';
   a1.Co_Applicant__c='PURNIMA SAGAR SHAH';
   a1.project_name__c=p1.name;
   insert a1;
   account a=[select id,project_name__c from account where id=:a1.id];
   system.assertEquals(a.id,a1.id);
   System.debug('***project_name__c::'+a1.project_name__c+'::'+a.project_name__c);
   
   System.debug('***accListTest::'+a1.id+':: '+a1.CRN__c);
   
   return a1; 
}
public static Booking_Details__c  createBookingDetail(Project_Name__c p1,Account a1,String plant1){

   Booking_Details__c bd1=new Booking_Details__c ();
   bd1.Account__c=a1.id;
   bd1.CRN__c=a1.CRN__c;
   bd1.Allotment_Date__c=Date.Today();
   bd1.Consideration_Value__c=123000000;
   bd1.Project_Name__c=p1.id;
              //formula field bd1.CV_paid_New__c =
   bd1.Flat_ID__c='ABCD11000';
   
   bd1.Plant__c=plant1;
     
   insert bd1;
   Booking_Details__c bd=[select id from Booking_Details__c where id=:bd1.id];
   system.assertEquals(bd.id,bd1.id);
   
   return bd1;
}

public static List<Attachment> createAttachment(Integer recordCount){
         List<Attachment> lstAttachment = new List<Attachment>();
        
         for(Integer i = 1 ; i <= recordCount; i++)
         {
             Attachment objAttachment = new Attachment();
             objAttachment.Name = 'Test Attachment';
             objAttachment.Body = Blob.valueOf('Test Data');
             lstAttachment.add(objAttachment);
         }
         return lstAttachment;
     }
}