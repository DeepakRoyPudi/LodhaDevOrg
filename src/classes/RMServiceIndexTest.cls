/* 
Description:
test class for cover the RMServiceIndex controller class which is used in RM landing page as show service index informaion

 @Created by: Sudeep Dube
 @Created Date: 26/march/2015
 
 --------------------------------------------------------------------------------
 | Modified By      | Modified Date       | Version        | Description         |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------
*/

@isTest(SeeAllData = false)
public class RMServiceIndexTest {

    //main test method
    public testmethod static void CoverRMServiceIndex() {

        String PanNo = 'NNHSP6592M';
        //call data factory method which create accounts cases 
        RMServiceIndexTest.createAccountForServiceIndex(PanNo);

        // call for test 
        RMServiceIndex rmI1 = new RMServiceIndex();
        RMServiceIndex rmI2 = new RMServiceIndex(PanNo);

        System.assertNotEquals(rmI2.service_index_CustomerSpecific, null);
        System.assertEquals(rmI2.service_index_BookingSpecific.size(), 3);


        String PanNo2 = 'MNHSP6592N';
        //call data factory method which create accounts and 0 cases (case not created in account) 
        RMServiceIndexTest.createAccountWithoutCasesForServiceIndex(PanNo2);
        RMServiceIndex rmI3 = new RMServiceIndex();
        RMServiceIndex rmI4 = new RMServiceIndex(PanNo2);
        System.assertEquals(rmI4.service_index_CustomerSpecific, 100);
        System.assertEquals(rmI4.service_index_BookingSpecific.size(), 3);
    }


    //this is data factory method which create the data for Account and insert multiple cases related to accounts 
    public static void createAccountForServiceIndex(String panno) {


        //create Account and add to list and Insert
        list < Account > acclist = new list < Account > ();

        String AccoutnbookingCRN1 = '1245845';
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

        insert acclist;
        //End create Account and add to list and Insert 

        //Create Cases of the above inserted Accounts which have created above. 
        list < Case > caseList = new list < Case > ();

        list < string > Nature_request_list = new list < string > {
            'Complaint', 'Grievance', 'Request', 'Query'
        };
        list < string > status_list = new list < string > {
            'Closed Satisfied', 'Closed UnSatisfied', 'New ', 'Open'
        };

        for (account a: acclist) {
            for (string nature: Nature_request_list) {
                for (string status: status_list) {
                    Case c1 = new Case();
                    c1.AccountID = a.id;
                    c1.Interaction_Mode__c = 'Email';
                    c1.Communication_Type__c = 'Outbound';
                    c1.Nature_of_Request__c = nature;
                    c1.Status = status;
                    c1.recordtypeid = 
                        Schema.SObjectType.Case.getRecordTypeInfosByName().get('CSS Cases').getRecordTypeId();
                    c1.Case_Resolution__c = 'testResolution';
                    c1.Case_Summary__c = 'testSummary';
                    c1.Date_of_Complaint__c = Date.Today();
                    //    c1.Request_for_L1__c='Brokerage related';
                    //     c1.Request_for_L2__c='Brokerage related';
                    //     c1.Request_for_L3__c='Customer not contactable';
                    caseList.add(c1);
                }
            }
        }
        insert caselist;

    }



    //method create account withous cases in related list.
    public static void createAccountWithoutCasesForServiceIndex(String panno) {



        //create Account and add to list and Insert
        list < Account > acclist = new list < Account > ();

        String AccoutnbookingCRN1 = '1345845';
        Account a1 = new Account();
        a1.Primary_PAN_number__c = panno;
        a1.AccountSource = 'Business Development';
        a1.CRN__c = AccoutnbookingCRN1;
        a1.lastname = 'testAccount1';
        a1.recordtypeid = 
            Schema.SObjectType.Account.getRecordTypeInfosByName().get('Booked Account').getRecordTypeId();
        acclist.add(a1);

        String AccoutnbookingCRN2 = '1345846';
        Account a2 = new Account();
        a2.Primary_PAN_number__c = panno;
        a2.AccountSource = 'Email';
        a2.CRN__c = AccoutnbookingCRN2;
        a2.lastname = 'testAccount2';
        a2.recordtypeid = 
            Schema.SObjectType.Account.getRecordTypeInfosByName().get('Booked Account').getRecordTypeId();
        acclist.add(a2);

        String AccoutnbookingCRN3 = '1345847';
        Account a3 = new Account();
        a3.Primary_PAN_number__c = panno;
        a3.AccountSource = 'Email';
        a3.CRN__c = AccoutnbookingCRN3;
        a3.lastname = 'testAccount2';
        a3.recordtypeid = 
            Schema.SObjectType.Account.getRecordTypeInfosByName().get('Booked Account').getRecordTypeId();
        acclist.add(a3);

        insert acclist;
        //End create Account and add to list and Insert 


    }

}