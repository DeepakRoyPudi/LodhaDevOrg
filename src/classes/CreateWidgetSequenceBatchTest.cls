@isTest
public with sharing class CreateWidgetSequenceBatchTest {
	
	public static testMethod void testWidgetSequenceInsertion(){ 
		//Create WidgetInfo records
		WidgetInfo__c widgetInfo = new WidgetInfo__c(Name ='Recent Activity Widget',
													 Available_For__c = 'Both');
		insert widgetInfo;
		
		//Create Customer portal Users
		User objUser = createUser();
		insert objUser;
		
		Test.startTest();
			//Exceute the batch
			CreateWidgetSequenceBatch c = new CreateWidgetSequenceBatch();
	        Database.executeBatch(c);
			
		Test.stopTest();
		
		//Query Widget Sequence records
		list<Widget_Sequence__c> widgetSeqList = [Select Id, 
														 WidgetInfo__c,
														 User__c 
												  From Widget_Sequence__c where User__c =:objUser.Id];
		system.assertEquals(2 , widgetSeqList.size());
	}
	
	/* Method to create Customer portal User records
	*/
	private static User createUser() {
		
		Account objAccount1 = new Account( 
								RecordTypeId = 
        						  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId(),
 								Name ='Test Account',
 								Mobile_Phone__c ='8554884329');
     	insert objAccount1;
     
   		Contact con = new Contact( AccountId = objAccount1.Id,
   								   Birthdate = Date.newInstance(2015 , 10 ,20),
   								   LastName ='Test Contact'); 
   		insert con;
   
		User objUser = new User(EmailEncodingKey = 'ISO-8859-1',
				                LanguageLocaleKey = 'en_US',
								TimeZoneSidKey = 'America/New_York',
								LocaleSidKey = 'en_US',
								FirstName = 'first',
								LastName = 'last',
								Username = 'test@appirio.com',
								CommunityNickname = 'testUser123',
								Alias = 't1',
								Email = 'no@email.com',
								IsActive = true,
								ContactId = con.id);
		
		objUser.ProfileID = [Select Id 
							 		From Profile 
							 Where Name = 'Custom Overage High Volume Customer Portal'].id;
		
		return objUser;
	}  
}