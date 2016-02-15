/* 
Description:
test class for cover the RMSegmentIndicator class which is used in RM landing page as show Segment informaion

 @Created by: Sudeep Dube
 @Created Date: 02/04/2015
 
 --------------------------------------------------------------------------------
 | Modified By      | Modified Date       | Version        | Description         |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------
*/



@isTest(SeeAllData = false)
public class RMSegmentIndicatorTest {

    //main test method
    public testmethod static void CoverRMSegmentIndicator() {

        String PanNo = 'NNHSP6592M';
        //call data factory method which create account booking detail and demands in booking details 
        RMSegmentIndicatorTest.createAccountForSegmentIndicator(PanNo);

        // call for test 
        RMSegmentIndicator rms1 = new RMSegmentIndicator();
        RMSegmentIndicator rms2 = new RMSegmentIndicator(PanNo, '1245845855', 'YES');
        System.assertNotEquals(rms2.CurrentBookingSegment, null);
        System.assertEquals(rms2.booking_Segments.size(), 4);
    }

    //data factory method create data records of project , account and booking   
    public static void createAccountForSegmentIndicator(String panno) {


        list < Project_Name__c > plist = new list < Project_Name__c > ();

        Project_Name__c p1 = new Project_Name__c();
        p1.Name = 'testProject1';
        p1.Project_Type__c = 'Hi End / Luxury';
        p1.Record_Type__c = 'Residential';
        //p1.Currency ='INR - Indian Rupee';   
        plist.add(p1);

        Project_Name__c p2 = new Project_Name__c();
        p2.Name = 'testProject2';
        p2.Project_Type__c = 'Casa';
        p2.Record_Type__c = 'Residential';
        //p2.Currency ='INR - Indian Rupee';   
        plist.add(p2);

        Project_Name__c p3 = new Project_Name__c();
        p3.Name = 'testProject3';
        p3.Project_Type__c = 'Commercial';
        p3.Record_Type__c = 'Residential';
        //p3.Currency ='INR - Indian Rupee';  
        plist.add(p3);

        insert plist;



        //create Account and add to list and Insert
        list < Account > acclist = new list < Account > ();

        String AccoutnbookingCRN1 = '1245845855';
        Account a1 = new Account();
        a1.Primary_PAN_number__c = panno;
        a1.AccountSource = 'Business Development';
        a1.CRN__c = AccoutnbookingCRN1;
        a1.lastname = 'testAccount1';
        a1.recordtypeid = 
            Schema.SObjectType.Account.getRecordTypeInfosByName().get('Booked Account').getRecordTypeId();
        acclist.add(a1);

        String AccoutnbookingCRN2 = '1245846';
        Account a2 = new Account();
        a2.Primary_PAN_number__c = panno;
        a2.AccountSource = 'Email';
        a2.CRN__c = AccoutnbookingCRN2;
        a2.lastname = 'testAccount2';
        a2.recordtypeid = 
            Schema.SObjectType.Account.getRecordTypeInfosByName().get('Booked Account').getRecordTypeId();
        acclist.add(a2);

        String AccoutnbookingCRN3 = '1245847';
        Account a3 = new Account();
        a3.Primary_PAN_number__c = panno;
        a3.AccountSource = 'Email';
        a3.CRN__c = AccoutnbookingCRN3;
        a3.lastname = 'testAccount2';
        a3.recordtypeid = 
            Schema.SObjectType.Account.getRecordTypeInfosByName().get('Booked Account').getRecordTypeId();
        acclist.add(a3);

        String AccoutnbookingCRN4 = '1245848';
        Account a4 = new Account();
        a4.Primary_PAN_number__c = panno;
        a4.AccountSource = 'Email';
        a4.CRN__c = AccoutnbookingCRN4;
        a4.lastname = 'testAccount2';
        a4.recordtypeid = 
            Schema.SObjectType.Account.getRecordTypeInfosByName().get('Booked Account').getRecordTypeId();
        acclist.add(a4);
        
        String AccoutnbookingCRN5 = '1245849';
        Account a5 = new Account();
        a5.Primary_PAN_number__c = panno;
        a5.AccountSource = 'Email';
        a5.CRN__c = AccoutnbookingCRN5;
        a5.lastname = 'testAccount2';
        a5.recordtypeid = 
            Schema.SObjectType.Account.getRecordTypeInfosByName().get('Booked Account').getRecordTypeId();
        acclist.add(a5);

        insert acclist;
        //End create Account and add to list and Insert 

        //Create Booking details of Account which have created above.   
        //only one account contain only one booking details so only one record created of booking in account related 
        list < Booking_Details__c > bdList = new list < Booking_Details__c > ();

        //for first accout booking details 
        Booking_Details__c bd1 = new Booking_Details__c();
        bd1.Account__c = acclist[0].id;
        bd1.CRN__c = acclist[0].CRN__c;
        bd1.Allotment_Date__c = Date.Today();
        bd1.Consideration_Value__c = 123000000;
        bd1.Project__c = plist[0].name;
        //formula field bd1.CV_paid_New__c =
        bd1.Flat_ID__c = 'ABCD11000';

        bdlist.add(bd1);

        //for Second accout booking details 
        Booking_Details__c bd2 = new Booking_Details__c();
        bd2.Account__c = acclist[1].id;
        bd2.CRN__c = acclist[1].CRN__c;
        bd2.Allotment_Date__c = Date.Today();
        bd2.Consideration_Value__c = 123000000;
        bd2.Project__c = plist[1].name;
        //formula field bd1.CV_paid_New__c =
        bd2.Flat_ID__c = 'ABCD12000';

        bdlist.add(bd2);

        //for third accout booking details 
        Booking_Details__c bd3 = new Booking_Details__c();
        bd3.Account__c = acclist[2].id;
        bd3.CRN__c = acclist[2].CRN__c;
        bd3.Allotment_Date__c = Date.Today();
        bd3.Consideration_Value__c = 123000000;
        bd3.Project__c = plist[2].name;
        //formula field bd1.CV_paid_New__c =
        bd3.Flat_ID__c = 'ABCD13000';


        bdlist.add(bd3);

        Booking_Details__c bd4 = new Booking_Details__c();
        bd4.Account__c = acclist[3].id;
        bd4.CRN__c = acclist[3].CRN__c;
        bd4.Allotment_Date__c = Date.Today();
        bd4.Consideration_Value__c = 123000000;
        //bd4.Project__c = plist[2].name;
        //formula field bd1.CV_paid_New__c =
        bd4.Flat_ID__c = 'ABCD13000';


        bdlist.add(bd4);
        
        insert bdlist;
        //End Of booking Details creattion

        list < Account > acctest = [select id from Account];
        list < Booking_Details__c > bdtest = [select id from Booking_Details__c];
        list < Project_Name__c > projtest = [select id from Project_Name__c];
        System.assertEquals(acctest.size(), 5);
        System.assertEquals(bdtest.size(), 4);
        System.assertEquals(projtest.size(), 3);
    }

}