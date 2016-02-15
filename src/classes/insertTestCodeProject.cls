@isTest(SeeAllData=false)
public class insertTestCodeProject{
public testmethod static void createProject()
{

       
list<Project_Name__c> plist =new list<Project_Name__c>();

Project_Name__c p1=new Project_Name__c();
p1.name='ProjectTest1';
p1.Project_Type__c='Casa';
p1.Record_Type__c='Residential';
//p1.CurrencyIsoCode='INR - Indian Rupee';
p1.OrderType__c='Default';
plist.add(p1);

Project_Name__c p2=new Project_Name__c();
p2.name='ProjectTest2';
p2.Project_Type__c='Casa';
p2.Record_Type__c='Residential';
//p2.CurrencyIsoCode='INR - Indian Rupee';
p2.OrderType__c='Default';
plist.add(p2);

Project_Name__c p3=new Project_Name__c();
p3.name='ProjectTest3';
p3.Project_Type__c='Casa';
p3.Record_Type__c='Residential';
//p3.CurrencyIsoCode='INR - Indian Rupee';
p3.OrderType__c='Default';
plist.add(p3);

insert plist;


}
}