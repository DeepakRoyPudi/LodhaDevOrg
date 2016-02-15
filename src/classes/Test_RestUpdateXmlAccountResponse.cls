@isTest
Public class Test_RestUpdateXmlAccountResponse{

static testmethod void myTestMethod1() {
    account acc=new account(FirstName='Kum', LastName='Resan', PersonMobilePhone='9876543219', Mobile_Phone__c='9876543219', Personal_Email__pc='kum@gmail.com', PersonEmail='kum@gmail.com', RecordTypeId='012D0000000hZXJIA2');
    insert acc;    
    account acc1=new account(FirstName='Kum', LastName='Resan', PersonMobilePhone='9876543219', Mobile_Phone__c='9876543219', Personal_Email__pc='kum@gmail.com', PersonEmail='kum@gmail.com', RecordTypeId='0122000000098yAAAQ');
    insert acc1;
    account acc11=new account(Name='kum', Mobile_Phone__c='9876543219',RecordTypeId='0122000000098svAAA');
    insert acc11;
    account acc2=new account(Name='kum', Mobile_Phone__c='9876543219',RecordTypeId='0122000000098svAAA');
    insert acc2;
    account acc3=new account(Name='kum', Mobile_Phone__c='9876543219',RecordTypeId='0122000000098svAAA');
    insert acc3;
    
    RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();
    RestContext.Request = req;
    RestContext.response = res;
    RestContext.response.addHeader('Content-Type', 'text/html');    
    Map<string,string> a= RestContext.request.params;
    a.put('mobileNo','9810517910');
    a.put('checkSum','82');
    a.put('firstName','My');    
    a.put('accountId',acc.id);
    a.put('lastName','Name');
    a.put('email','mech@gmail.com');
    Account acct = [select Id, FirstName, LastName, PersonMobilePhone, Mobile_Phone__c,IsPersonAccount, Personal_Email__pc, PersonEmail,  RecordTypeId from Account where id =:a.get('accountId')];
    system.assert(acct != null);
    System.assertEquals(a.get('accountId'),acct.id);
    RestUpdateXmlAccountResponse.XmlWriter('mesg');
    RestUpdateXmlAccountResponse.doPost();
    

    Map<string,string> a1= RestContext.request.params;
    a1.put('mobileNo','9810517910');
    a1.put('checkSum','82');
    a1.put('firstName','My');    
    a1.put('accountId',acc1.id);
    a1.put('lastName','Name');
    a1.put('email','mech@gmail.com');
    Account acct1 = [select Id, FirstName, LastName, PersonMobilePhone, Mobile_Phone__c,IsPersonAccount, Personal_Email__pc, PersonEmail,  RecordTypeId from Account where id =:a1.get('accountId')];
    system.assert(acct1 != null);
    System.assertEquals(a1.get('accountId'),acct1.id);
    RestUpdateXmlAccountResponse.XmlWriter('mesg1');
    RestUpdateXmlAccountResponse.doPost();
    

    Map<string,string> a11= RestContext.request.params;
    a11.put('mobileNo','9810517910');
    a11.put('checkSum','82');
    a11.put('firstName','My');    
    a11.put('accountId',acc11.id);
    a11.put('lastName','Name');
    a11.put('email','mech@gmail.com');
    Account acct11 = [select Id, FirstName, LastName, PersonMobilePhone, Mobile_Phone__c,IsPersonAccount, Personal_Email__pc, PersonEmail,  RecordTypeId from Account where id =:a11.get('accountId')];
    system.assert(acct11 != null);
    System.assertEquals(a11.get('accountId'),acct11.id);
    RestUpdateXmlAccountResponse.XmlWriter('mesg11');
    RestUpdateXmlAccountResponse.doPost();
    
    Map<string,string> a2= RestContext.request.params;
    a2.put('mobileNo','981051791');
    a2.put('checkSum','82');
    a2.put('firstName','My');    
    a2.put('accountId',acc2.id);
    a2.put('lastName','Name');
    a2.put('email','mech@gmail.com');
    RestUpdateXmlAccountResponse.XmlWriter('mesg2');
    RestUpdateXmlAccountResponse.doPost();
    
    Map<string,string> a3= RestContext.request.params;
    a3.put('mobileNo','9810517917');
    a3.put('checkSum','82');
    a3.put('firstName','My');    
    a3.put('accountId',acc3.id);
    a3.put('lastName','Name');
    a3.put('email','mech@gmail.com');
    RestUpdateXmlAccountResponse.XmlWriter('mesg3');
    RestUpdateXmlAccountResponse.doPost();
    
    Map<string,string> a4= RestContext.request.params;
    a4.put('mobileNo','9810517910');
    a4.put('checkSum','82');
    a4.put('accountId','21321');
    a4.put('firstName','My');    
    a4.put('lastName','Name');
    a4.put('email','mech@gmail.com');
    RestUpdateXmlAccountResponse.XmlWriter('mesg4');
    RestUpdateXmlAccountResponse.doPost();
    
    Map<string,string> a5= RestContext.request.params;
    a5.put('mobileNo','9810517910');
    a5.put('checkSum','82');
    a5.put('accountId',null);
    a5.put('firstName','My');    
    a5.put('lastName','');
    a5.put('email','mech@gmail.com');
    RestUpdateXmlAccountResponse.XmlWriter('mesg5');
    RestUpdateXmlAccountResponse.doPost();

	}

}