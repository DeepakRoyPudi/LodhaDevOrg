@isTest
public class Test_RestSendXmlAccountResponse{

    static testmethod void myTestMethod2() {
	account acc=new account(FirstName='Kum', LastName='Resan', PersonMobilePhone='9230517910', Mobile_Phone__c='9810517910', Personal_Email__pc='kum@gmail.com', PersonEmail='kum@gmail.com', RecordTypeId='012D0000000hZXJIA2');
	insert acc; 
	account acc1=new account(FirstName='Kum', LastName='Resan', PersonMobilePhone='9876543219', Mobile_Phone__c='9810517910', Personal_Email__pc='kum@gmail.com', PersonEmail='kum@gmail.com', RecordTypeId='0122000000098yAAAQ');
    insert acc1;	
	account acc11=new account(Name='kum', Mobile_Phone__c='9810517910',RecordTypeId='0122000000098svAAA');
    insert acc11;


	RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    RestContext.Request = req;
    RestContext.response = res;
    RestContext.response.addHeader('Content-Type', 'text/html');    
    Map<string,string> a= RestContext.request.params;
    a.put('mobileNo','9810517910');
    a.put('checkSum','82');
    List<Account> acct = [select Id, FirstName, LastName,Name,PersonMobilePhone, Mobile_Phone__c,IsPersonAccount, Personal_Email__pc, PersonEmail,  RecordTypeId from Account where Mobile_Phone__c = : a.get('mobileNo') or PersonMobilePhone = : a.get('mobileNo')];
    system.assert(acct != null);
    System.assertEquals(3,acct.size());
    RestSendXmlAccountResponse.doPost();
	
	
	RestRequest req1 = new RestRequest(); 
    RestResponse res1 = new RestResponse();
    RestContext.Request = req1;
    RestContext.response = res1;
    RestContext.response.addHeader('Content-Type', 'text/html');    
    Map<string,string> a1= RestContext.request.params;
    a1.put('mobileNo','9851299985');
    a1.put('checkSum','130');
    List<Account> acct1 = [select Id, FirstName, LastName,Name,PersonMobilePhone, Mobile_Phone__c,IsPersonAccount, Personal_Email__pc, PersonEmail,  RecordTypeId from Account where Mobile_Phone__c = : a1.get('mobileNo') or PersonMobilePhone = : a1.get('mobileNo')];
    system.assert(acct1 != null);
    System.assertEquals(0,acct1.size());
    RestSendXmlAccountResponse.doPost();
	
	RestRequest req2 = new RestRequest(); 
    RestResponse res2 = new RestResponse();
    RestContext.Request = req2;
    RestContext.response = res2;
    RestContext.response.addHeader('Content-Type', 'text/html');    
    Map<string,string> a2= RestContext.request.params;
    a2.put('mobileNo','9810517911');
    a2.put('checkSum','8');
    RestSendXmlAccountResponse.doPost();
	
	RestRequest Newreq3= new RestRequest(); 
    RestResponse Newres3 = new RestResponse();
    RestContext.Request = Newreq3;
    RestContext.response = Newres3;
    RestContext.response.addHeader('Content-Type', 'text/html');    
    Map<string,string> NewMap3= RestContext.request.params;
    RestSendXmlAccountResponse.doPost();	
	
	}
}