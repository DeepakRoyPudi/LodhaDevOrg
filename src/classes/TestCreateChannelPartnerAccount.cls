@istest(seealldata=true)
public class TestCreateChannelPartnerAccount{


public testmethod static void TestCreateChannelPartnerAccount(){

    List<Channel_Partner__c> c=[select id,Activation_status__c,reap_id__c,name ,Email__c from Channel_Partner__c  limit 5];
    
    for(Channel_Partner__c v:c){
        v.name = 'Test CP1';
        v.Activation_status__c='Active';
    }
    update c;
}

}