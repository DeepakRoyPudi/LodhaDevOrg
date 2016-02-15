@istest(seealldata=false)
public class Test_UpdateDNDonPersonAccounts{

public testmethod static void Test_DNDUpdateOnAccounts(){
   id BARecordtypeId=[select id,name from recordtype where name='Booked Account'].Id;
   id PARecordtypeId=[select id,name from recordtype where name='Person Account'].Id;
   
   account a=new account(recordtypeid=PARecordtypeId,lastname='Test CG',Mobile_phone__c='8431413309');
   insert a;
   
   account a1=new account(recordtypeid=BARecordtypeId,lastname='Test CG',PersonMobilePhone='8431413309',TRAI_DND__c=true);
   insert a1;
   
   account a2=new account(recordtypeid=BARecordtypeId,lastname='Test CG',PersonMobilePhone='8431413309');
   insert a2;
   
   a2.TRAI_DND__c=true;
   update a2; 
   
   a2.TRAI_DND__c=false;
   update a2; 
   
   Database.executeBatch(new DNDUpdateOnAccounts());
}

}