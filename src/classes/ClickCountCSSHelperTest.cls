/* Version  			Created By   	 Created Date       Description
 *
 * 	Initial Draft		Sneha P.         1/04/2015       Test Class for ClickCountCSSHelper
 *
 */
@isTest
private class ClickCountCSSHelperTest {

    static testMethod void widgetNameRecentActivity() {
    	
        Account objAccount = new Account();
        objAccount.CRN__c='154215';
        objAccount.Name='Madan';
        insert objAccount;

        Contact objContact = new Contact();
        objContact.LastName='Khadka';
        objContact.AccountId=objAccount.Id;
        insert objContact;

        User objUser = new User();
        objUser.ProfileID = [Select Id From Profile Where Name='Custom Overage High Volume Customer Portal'].id;
        objUser.EmailEncodingKey = 'ISO-8859-1';
        objUser.LanguageLocaleKey = 'en_US';
        objUser.TimeZoneSidKey = 'America/New_York';
        objUser.LocaleSidKey = 'en_US';
        objUser.FirstName = 'first';
        objUser.LastName = 'last';
        objUser.Username = 'test@appirio.com';   
        objUser.CommunityNickname = 'testUser123';
        objUser.Alias = 't1';
        objUser.Email = 'no@email.com';
        objUser.IsActive = true;
        objUser.ContactId = objContact.Id;

        insert objUser;
        
        WidgetInfo__c objWidgetInfo = new WidgetInfo__c();
        objWidgetInfo.Name='Recent Activity';
        objWidgetInfo.Available_For__c = 'Both';
        insert objWidgetInfo;
        
        List<Widget_Sequence__c> lstWidget_Sequence = new List<Widget_Sequence__c>();
        for(Integer i = 0; i < 10; i++){
             Widget_Sequence__c objWidget_Sequence = new Widget_Sequence__c();
             objWidget_Sequence.Sequence_ClickCount__c= 0;
             objWidget_Sequence.WidgetInfo__c=objWidgetInfo.id;
             objWidget_Sequence.User__c = objUser.Id ;
             lstWidget_Sequence.add(objWidget_Sequence);
         } 
        insert lstWidget_Sequence;
        
        String WidgetName ='Recent Activity';
        System.runAs(objUser){
        test.startTest();
            
        ClickCountCSSHelper.incrementCount(WidgetName);
        list<Widget_Sequence__c>widgetSeqList = [Select WidgetInfo__c, 
                                                        WidgetInfo__r.Name, 
                                                        User__c,
                                                        Sequence_ClickCount__c, 
                                                        Name, 
                                                        Id 
                                                 From   Widget_Sequence__c 
                                                 where  User__c =: UserInfo.getUserId() and 
                                                        WidgetInfo__r.Name =: WidgetName ];
            system.assertEquals(0.00000001,widgetSeqList[0].Sequence_ClickCount__c);
            
            
        test.stopTest();
        }
    }
}