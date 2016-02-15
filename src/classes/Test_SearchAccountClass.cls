@isTest(seeAllData=false)
public class Test_SearchAccountClass {    
        
    public static testMethod void TestSearchAccountClass () {
        id RTId = [Select id from RecordType where Name = 'Booked Account'].id;
        
        Project_Name__c pname=new Project_Name__c();
                pname.name='LODHAARISTO';
                pname.Project_Type__c='CASA';
                pname.Loyalty_Type__c='Preferati';
                pname.Record_Type__c='Residential';
                pname.Isactive__c=true;
                pname.Allow_mobile_verification__c=true;
                pname.Allow_Call_Patching__c=true;
                pname.City__c='Mumbai';
                pname.Call_Patch_Category__c = 'Dummy Call';
                pname.Type_of_Accomodation__c = '1 BHK';
                insert pname;
        
        Account a = new Account(FirstName = 'testFirstacc',
                            LastNAme = 'testLastacc',
                            Recordtypeid = RTId,
                            Status__c = 'Created',
                            PersonMobilePhone = '1234567890',
                            Project_Name__c=pname.id,
                            Cluster__c='Cluster A',
                            Wing__c='Wing A',
                            Flat_No__c='101',
                            Mobile_Phone__c='7676247977',
                            PersonEmail = 'testtest@test.com',
                            CRN__c = '12345678',
                            //Loyalty_Details__c=LY.id,
                            LoyaltyID__c='100023456',
                            Personal_Email__pc = 'testtest1@test.com'
                            //isViaCP__c=false
                            );
       insert a;
       
       SearchAccountClass test=new SearchAccountClass ();
       test.Accvar='testLastacc';
       test.Search();
       test.linkvar='Name';
       test.dynamicsearch();
       
       test.Accvar='LODHA*';
       test.Search();
       test.linkvar='Project_Name__c';
       test.dynamicsearch();
       
       test.Accvar='*A';
       test.Search();
       test.linkvar='Cluster__c';
       test.dynamicsearch();
       
       test.Accvar='*Wing*';
       test.Search();
       test.linkvar='Wing__c';
       test.dynamicsearch();
       
       test.Accvar='1*1';
       test.Search();
       test.linkvar='Flat_No__c';
       test.dynamicsearch();
       
       test.Accvar='7676*';
       test.Search();
       test.linkvar='Mobile_Phone__c';
       test.dynamicsearch();
       
       test.Accvar='*3*';
       test.Search();
       test.linkvar='CRN__c';
       test.dynamicsearch();
       
       test.Accvar='*3*';
       test.Search();
       test.linkvar='LoyaltyID__c';
       test.dynamicsearch();       
  
       
    }
        
}