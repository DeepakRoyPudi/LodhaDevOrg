/* 
Description: Test Class For ReferralCSS2_0Controller
@Created by: Aditi Mulmule
@Created Date: 4/03/2015

--------------------------------------------------------------------------------
| Modified By      | Modified Date       | Version        | Description         |
--------------------------------------------------------------------------------
| Aditi Mulmule
---------------------------------------------------------------------------------
*/
@isTest
private class ReferralCSS2_0ControllerTest {
    
    static testMethod void ConstructorTest() {
        
        Account objAccount = CreateAccount();
        insert objAccount;
        
        Account insertedAccountwithcontact=[Select Id,
                                               Name,
                                               (select id from contacts ) 
                                        From account 
                                        Where id=:objAccount.Id];
        Id conid = insertedAccountwithcontact.contacts[0].Id ;
        
        User objUser = createUser(conid);
        insert objUser;
        
        CSSBackgroundImageSetting__c setting1 = new CSSBackgroundImageSetting__c (name='Background Image',
                                                                               Project_Wise__c=true);
        insert setting1;
        
        Project_Name__c objProject = new Project_Name__c();
        objProject.name='New Project';
        objProject.CSS_Background_Image_URL__c='https://c.cs7.content.force.com/servlet/servlet.FileDownload?file=00PM0000003RzGG';
        insert objProject;
        
        system.runAs(objUser){
                
                PageReference pageRef = Page.ReferralCSS2_0; 
                ReferralCSS2_0Controller ReferralObj = new ReferralCSS2_0Controller();
                system.Test.setCurrentPage(pageRef);
                ReferralObj.userId = objUser.Id;
                ReferralObj.contactName = 'New Contact';
                ReferralObj.std_code ='23';
                ReferralObj.isd_code ='91';
                ReferralObj.contactNumber = '1234567890';
                ReferralObj.emailId = 'abc@xyz.com';
                ReferralObj.selfReferred = false; 
                ReferralObj.salutationvalues ='Mr.';
                ReferralObj.send();
           
        }
        
    }
    
    static testMethod void NullCheckTest() {
        Account objAccount = CreateAccount();
        
        system.Test.startTest();
        insert objAccount;
        
        Account insertedAccountwithcontact=[Select Id,
                                                  Name,
                                                  (select id from contacts ) 
                                            From account 
                                            Where id=:objAccount.id];
        Id conid = insertedAccountwithcontact.contacts[0].id ;
        
        User objUser = createUser(conid);
        insert objUser;
        
        CSSBackgroundImageSetting__c setting1 = new CSSBackgroundImageSetting__c(name='Background Image',
                                                                               Project_Wise__c=true);
        insert setting1;
        
        Project_Name__c objProject = new Project_Name__c();
        objProject.name='New Project';
        objProject.CSS_Background_Image_URL__c='https://c.cs7.content.force.com/servlet/servlet.FileDownload?file=00PM0000003RzGG';
        insert objProject;
        
        system.runAs(objUser){
                
                PageReference pageRef = Page.ReferralCSS2_0; 
                
                ReferralCSS2_0Controller ReferralObj = new ReferralCSS2_0Controller();
                system.Test.setCurrentPage(pageRef);
                ReferralObj.userId = objUser.Id;
                
                ReferralObj.contactName = 'New Contact';
                ReferralObj.contactNumber = '1234567890';
                ReferralObj.std_code ='23';
                ReferralObj.isd_code ='91';
                ReferralObj.emailId = 'abc@xyz.com';
                ReferralObj.selfReferred = false; 
                ReferralObj.salutationvalues ='Mr.';
                ApexPages.currentPage().getParameters().put('relationParam','Other');
                ReferralObj.setRelationship();
                system.assertEquals('Other',ReferralObj.relationship);
                ReferralObj.send();
                // Contact name,Contact Number and Email Adress are blank
                ReferralObj.contactName = '';
                ReferralObj.contactNumber = '';
                ReferralObj.emailId = '';
                ReferralObj.selfReferred = false; 
                ReferralObj.send();
                system.assertEquals(false,ReferralObj.displayPopup);
                // Email Adress is blank
                ReferralObj.contactName = 'New Contact';
                ReferralObj.contactNumber = '1234567890';
                ReferralObj.emailId = '';
                ReferralObj.selfReferred = false; 
                ReferralObj.salutationvalues  = '-None-';
                ReferralObj.send();
                system.assertEquals(false,ReferralObj.displayPopup);
                //Contact Number  blank
                ReferralObj.contactName = 'New Contact';
                ReferralObj.contactNumber = '';
                ReferralObj.emailId = 'abc@xyz.com';
                ReferralObj.selfReferred = true; 
                ReferralObj.send();
                system.assertEquals(false,ReferralObj.displayPopup);
                //Contact name is Blank
                ReferralObj.contactName = '';
                ReferralObj.contactNumber = '1234567890';
                ReferralObj.emailId = 'abc@xyz.com';
                ReferralObj.selfReferred = true; 
                ReferralObj.send();
                system.assertEquals(false,ReferralObj.displayPopup);
                // Contact name and Contact Number are blank
                ReferralObj.contactName = '';
                ReferralObj.contactNumber = '';
                ReferralObj.emailId = 'abc@xyz.com';
                ReferralObj.selfReferred = false; 
                ReferralObj.send();
                system.assertEquals(false,ReferralObj.displayPopup);
                // Contact Number and Email Adress are blank
                ReferralObj.contactName = 'New Contact';
                ReferralObj.emailId = '';
                ReferralObj.selfReferred = true; 
                ReferralObj.send();
                system.assertEquals(false,ReferralObj.displayPopup);
                // Contact name and Email Adress are blank
                ReferralObj.contactName = '';
                ReferralObj.std_code ='';
                ReferralObj.isd_code ='';
                ReferralObj.contactNumber = '1234567890';
                ReferralObj.emailId = '';
                ReferralObj.selfReferred = false; 
                ReferralObj.send();
                system.assertEquals(false,ReferralObj.displayPopup);
                //All data is filled and valid
                ReferralObj.contactName = 'New Contact';
                ReferralObj.std_code ='23';
                ReferralObj.isd_code ='915';
                ReferralObj.contactNumber = '1234567890';
                ReferralObj.emailId = 'abc@xyz.com';
                ReferralObj.selfReferred = false; 
                ReferralObj.salutationvalues ='-None-';
                ReferralObj.options ='test1';
                ApexPages.currentPage().getParameters().put('relationParam','Friend');
                ReferralObj.setRelationship();
                system.assertEquals('Friend',ReferralObj.relationship);
                ReferralObj.CSS_DetailList[0].Owner.Email = 'abc@gmail.com';                
                ReferralObj.send();
                system.assertEquals(true,ReferralObj.displayPopup);
                ReferralObj.displayPopup = false;
                //new referral that is self referred
                ReferralObj.selfReferred = true; 
                ReferralObj.send();
                ReferralObj.closePopup();
                system.assertEquals(false,ReferralObj.displayPopup);
        }
        system.Test.stopTest();   
    }
    
    static testMethod void ValidateTest() {
        
        Account objAccount = CreateAccount();
        objAccount.Click_To_Call__c = '+91855789230';
        system.Test.startTest();
        insert objAccount;
        
        Project_Name__c objProject = new Project_Name__c();
        objProject.name='New Project';
        objProject.CSS_Background_Image_URL__c='https://c.cs7.content.force.com/servlet/servlet.FileDownload?file=00PM0000003RzGG';
        insert objProject;
        
        Account insertedAccountwithcontact=[Select Id,
                                                   Name,
                                                   (select Id,
                                                           Birthdate
                                                    from contacts ) 
                                            From account 
                                            Where Id=:objAccount.Id];
        Id conid = insertedAccountwithcontact.contacts[0].Id ;
        
        User objUser = createUser(conid);
        insert objUser;
        
        system.runAs(objUser){
                
                PageReference pageRef = Page.ReferralCSS2_0; 
                
                ReferralCSS2_0Controller ReferralObj = new ReferralCSS2_0Controller();
                system.Test.setCurrentPage(pageRef);
                
                ReferralObj.userId = objUser.Id;
               
                ReferralObj.contactName = 'New Contact';
                ReferralObj.contactNumber = '123456789011';
                ReferralObj.emailId = 'abc@xyz.com';
                ReferralObj.selfReferred = false; 
                ReferralObj.salutationvalues ='Mr.';
                ReferralObj.std_code ='25';
                ReferralObj.isd_code ='91';
                system.assertEquals('Relative',ReferralObj.relationship);
                ReferralObj.send();
                
                //Email Id is Invalid
                ReferralObj.contactName = 'New Contact';
                ReferralObj.contactNumber = '1234567890';
                ReferralObj.emailId = 'abc';
                ReferralObj.selfReferred = false; 
                ReferralObj.send();
                system.assertEquals(false,ReferralObj.displayPopup);
                
                ReferralObj.contactName = 'New Contact';
                ReferralObj.contactNumber = '1234567890';
                ReferralObj.emailId = 'abc@';
                ReferralObj.selfReferred = false; 
                ReferralObj.send();
                system.assertEquals(false,ReferralObj.displayPopup);
                
                ReferralObj.contactName = 'New Contact';
                ReferralObj.contactNumber = '1234567890';
                ReferralObj.emailId = 'abc@xyz';
                ReferralObj.selfReferred = false; 
                ReferralObj.send();
                system.assertEquals(false,ReferralObj.displayPopup);
                
                //Contact number and EmailId both Invalid
                ReferralObj.contactName = 'New Contact';
                ReferralObj.contactNumber = '123456789011';
                ReferralObj.emailId = 'abc@xyz';
                ReferralObj.selfReferred = false; 
                ReferralObj.send();
                system.assertEquals(false,ReferralObj.displayPopup);
                
                ReferralObj.contactName = 'New Contact';
                ReferralObj.contactNumber = '123456789011';
                ReferralObj.emailId = 'abc@xyz.';
                ReferralObj.selfReferred = false; 
                ReferralObj.send();
                system.assertEquals(false,ReferralObj.displayPopup);
                
                ReferralObj.contactName = 'New Contact';
                ReferralObj.contactNumber = '123456789011';
                ReferralObj.emailId = 'abc';
                ReferralObj.selfReferred = false; 
                ReferralObj.send();
                system.assertEquals(false,ReferralObj.displayPopup);
                
                //Name is absent and contact Number And Email are Invalid
                ReferralObj.contactName = '';
                ReferralObj.contactNumber = '123456789011';
                ReferralObj.emailId = 'abc';
                ReferralObj.selfReferred = false; 
                ReferralObj.send();
                system.assertEquals(false,ReferralObj.displayPopup);
                
                ReferralObj.contactName = '';
                ReferralObj.contactNumber = '123456789011';
                ReferralObj.emailId = 'abc@';
                ReferralObj.selfReferred = false; 
                ReferralObj.send();
                system.assertEquals(false,ReferralObj.displayPopup);
                
                ReferralObj.contactName = '';
                ReferralObj.contactNumber = '123456789011';
                ReferralObj.emailId = 'abc@xyz';
                ReferralObj.selfReferred = false; 
                ReferralObj.send();
                system.assertEquals(false,ReferralObj.displayPopup);
                
                ReferralObj.contactName = '';
                ReferralObj.contactNumber = '123456789011';
                ReferralObj.emailId = 'abc@xyz.';
                ReferralObj.selfReferred = false; 
                ReferralObj.send();
                
                //If Contact Name,Email Address are Empty and Contact Number Invalid
                ReferralObj.contactName = '';
                ReferralObj.contactNumber = '123456789011';
                ReferralObj.emailId = '';
                ReferralObj.selfReferred = false; 
                ReferralObj.send();
                system.assertEquals(false,ReferralObj.displayPopup);
                //If Contact no,Contact Name are Empty, throw Error
                ReferralObj.contactName = '';
                ReferralObj.contactNumber = '';
                ReferralObj.emailId = 'abc';
                ReferralObj.selfReferred = false; 
                ReferralObj.send();
                system.assertEquals(false,ReferralObj.displayPopup);
                
                ReferralObj.contactName = '';
                ReferralObj.contactNumber = '';
                ReferralObj.emailId = 'abc@b.';
                ReferralObj.selfReferred = false; 
                ReferralObj.send();
                system.assertEquals(false,ReferralObj.displayPopup);
                
                //Contact Name empty and Contact Number Invalid
                ReferralObj.contactName = '';
                ReferralObj.contactNumber = '111';
                ReferralObj.emailId = 'abc.';
                ReferralObj.selfReferred = false; 
                ReferralObj.send();
                system.assertEquals(false,ReferralObj.displayPopup);
                
                ReferralObj.contactName = '';
                ReferralObj.contactNumber = '111';
                ReferralObj.emailId = 'abc@xyz.com';
                ReferralObj.selfReferred = false; 
                ReferralObj.send();
                system.assertEquals(false,ReferralObj.displayPopup);
                
                ReferralObj.contactName = '';
                ReferralObj.contactNumber = '1234567890';
                ReferralObj.emailId = 'abc@xyz.';
                ReferralObj.selfReferred = false; 
                ReferralObj.send();
                system.assertEquals(false,ReferralObj.displayPopup);
                
                //Contact Name is blank and Email Id is Invalid
                ReferralObj.contactName = '';
                ReferralObj.contactNumber = '1234567890';
                ReferralObj.emailId = 'abc.';
                ReferralObj.selfReferred = false; 
                ReferralObj.send();
                system.assertEquals(false,ReferralObj.displayPopup);
                
                ReferralObj.contactName = '';
                ReferralObj.contactNumber = '1234567890';
                ReferralObj.emailId = 'abc';
                ReferralObj.selfReferred = false; 
                ReferralObj.send();
                system.assertEquals(false,ReferralObj.displayPopup);
                
                //Contact Number is blank and Email Id is Invalid
                ReferralObj.contactName = 'abc';
                ReferralObj.contactNumber = '';
                ReferralObj.emailId = 'abc.';
                ReferralObj.selfReferred = false; 
                ReferralObj.send();
                system.assertEquals(false,ReferralObj.displayPopup);
                
                ReferralObj.contactName = 'abc';
                ReferralObj.contactNumber = '';
                ReferralObj.emailId = 'xyz';
                ReferralObj.selfReferred = false; 
                ReferralObj.send();
                system.assertEquals(false,ReferralObj.displayPopup);
                
                ReferralObj.contactName = 'abc';
                ReferralObj.contactNumber = '';
                ReferralObj.emailId = 'xyz@c.';
                ReferralObj.selfReferred = false; 
                ReferralObj.send();
                system.assertEquals(false,ReferralObj.displayPopup);
                
                //Email Id ends with '.'
                ReferralObj.contactName = 'abc';
                ReferralObj.contactNumber = '1234567890';
                ReferralObj.emailId = 'xyz.';
                ReferralObj.selfReferred = false; 
                ReferralObj.send();
                system.assertEquals(false,ReferralObj.displayPopup);
                
                //Email Id is Invalid
                ReferralObj.contactName = 'abc#$%';
                ReferralObj.contactNumber = '1234567890';
                ReferralObj.emailId = 'xyz';
                ReferralObj.selfReferred = false; 
                ReferralObj.send();
                system.assertEquals(false,ReferralObj.displayPopup);
                
                //all data correct - Owner fields cannot be accessed in test class so directly email is assigned(Salesforce known bug)
                ReferralObj.contactName = ' abcd';
                ReferralObj.contactNumber = ' 1234567890';
                ReferralObj.emailId = ' xyz@abc.com';
                ReferralObj.selfReferred = false; 
                ReferralObj.CSS_DetailList[0].Owner.Email = 'abc@z.com';
                ReferralObj.send();
                system.assertEquals(true,ReferralObj.displayPopup);
                
                ReferralObj.getProjects();
                
                ReferralObj.selfReferred = true; 
                
                list<Account> accountList = new list<Account>();
                accountList = [Select Personal_Email__pc,
                                      Name,
                                      Click_To_Call__c 
                               from Account
                               where CRN__c =:objAccount.CRN__c];
                
                system.assertEquals(accountList[0].Click_To_Call__c,objAccount.Click_To_Call__c);
                system.assertEquals(accountList[0].Personal_Email__pc,objAccount.Personal_Email__pc);
                system.assertEquals(accountList[0].Name,objAccount.LastName);
                ReferralObj.send();
                
                ReferralObj.displayPopup = true;
                ReferralObj.closePopup();
        }
        system.Test.stopTest();   
    }
    
    
    
    
    
    
    // method to create an account
    private static Account CreateAccount() {
        
        Account objAccount = new Account();
        objAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Booked Account').getRecordTypeId();
        objAccount.LastName = 'Account 2';
        objAccount.CRN__c='1251333';
        objAccount.Project_Name__c='New Project';
        objAccount.Click_To_Call__c = '91855789230';
        objAccount.Personal_Email__pc='abc@xyz.com';
        return objAccount;
    }
    //method to create a user
    private static User createUser(ID conid) {
        
        User objUser = new User();
        objUser.ProfileID = [Select Id 
                             From Profile 
                             Where Name='Custom Overage High Volume Customer Portal'].Id;
        objUser.EmailEncodingKey = 'ISO-8859-1';
        objUser.LanguageLocaleKey = 'en_US';
        objUser.TimeZoneSidKey = 'America/New_York';
        objUser.LocaleSidKey = 'en_US';
        objUser.FirstName = 'first';
        objUser.LastName = 'last';
        objUser.Username = 'lodha@test.com';   
        objUser.CommunityNickname = 'testUser123';
        objUser.Alias = 't1';
        objUser.Email = 'no@email.com';
        objUser.IsActive = true;
        objUser.ContactId = conid;   
        return objUser;
        
    }
}