public class AccountInformation{
public static void pullmethod(Referrals__c[] r)
 {                              
for (Referrals__c rf:r) {

/*Update Email Field from Account Object*/
           
          if(rf.Emails__c == null){
         
          Account[] AC = [select Email_acc__c,PersonEmail from Account where id =:rf.Referral_Name__c Limit 1];
         if(AC.size()>0){
          IF(AC[0].Email_acc__c == null){
          rf.Emails__c = AC[0].PersonEmail;
          }
          else if(AC[0].PersonEmail == null){
          rf.Emails__c =AC[0].Email_acc__c;
          }
          }       
          //Update rf;
          }   
          IF(rf.Opportunity__c != null){
          Opportunity Op = [Select Project_Interested__c from Opportunity where id=:rf.Opportunity__c Limit 1];
          rf.Project__c = Op.Project_Interested__c;      
          }         
       }
   }
static testMethod void AccountInformation()
{   
Account[] acc =new Account[]
{
new Account(LastName='XYZ',PersonEmail='xyz@gmail.com', Email_acc__c='xyz@gmail.com')
};
Insert acc;
acc=[select Email_acc__c from account where id=:acc[0].id];
acc[0].Email_acc__c=null;
update acc;
Referrals__c[] ref=new Referrals__c[]
{
new Referrals__c(Referral_Name__c=acc[0].id)
};
Insert ref;
ref=[select Emails__c from referrals__c where id=:ref[0].Id];
IF(acc[0].Email_acc__c == null){
ref[0].Emails__c=acc[0].PersonEmail;
update ref;
}
AccountInformation.pullmethod(ref);
}
}