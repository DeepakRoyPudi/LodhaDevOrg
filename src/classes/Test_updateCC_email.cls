@istest(seealldata=true)
public class Test_updateCC_email{

public testmethod static void Test_updateCC_emailOnOppty(){

account a=[select id,name from account where recordtype.name='Person Account' limit 1];
List<Project_Name__c> p=[select id,name from Project_Name__c where isactive__c=true limit 2];
opportunity oppty=new opportunity(Name='Test',Accountid=a.id,Project_Name__c=p[0].id,CloseDate=date.today().adddays(3),stagename='Qualification');
insert oppty;

oppty.Name_of_CC_Associated__c=userinfo.getname();
oppty.CC_email__c=userinfo.getuseremail();
update oppty;

opportunity oppty1=new opportunity(Name='Test',Accountid=a.id,Name_of_CC_Associated__c=userinfo.getname(),CC_email__c=userinfo.getuseremail(),Project_Name__c=p[1].id,CloseDate=date.today().adddays(3),stagename='Qualification');
insert oppty1;

}

public testmethod static void Test_updateCC_emailOnLead(){

List<Project_Name__c> p=[select id,name from Project_Name__c where isactive__c=true and name != 'Lodha Bellezza' and  name !='Casa Univis' and  name !='Lodha Bellezza Sky Villa' and  name !='World One' and  name !='World Crest' and  name !='Lodha Bellezza Spa Villa' limit 2];

Lead oppty=new Lead (lastName='Test',Project_Name__c=p[0].id,Mobile__c='3334445567',Status='Open',LeadSource='Newspaper');
insert oppty;

oppty.Attended_by_Customer_Care__c=userinfo.getname();
oppty.CC_email__c=userinfo.getuseremail();
update oppty;

Lead oppty1=new Lead (lastName='Test',Attended_by_Customer_Care__c=userinfo.getname(),CC_email__c=userinfo.getuseremail(),Project_Name__c=p[1].id,Mobile__c='3334445567',Status='Open',LeadSource='Newspaper');
insert oppty1;

}


}