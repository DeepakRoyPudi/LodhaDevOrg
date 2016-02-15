global class SessionTrackController{
 public static SessionDetail__c session{get;set;}
 public static SessionAction__c sessionaction{get;set;}
 public static List<SessionDetail__c> sessionlist{get;set;}


 @RemoteAction
 global static void addsessiondetails(String url, String action, String button_name){
   sessionlist = [select Name, Session_ID__c from SessionDetail__c where Session_ID__c =: UserInfo.getSessionId()];
   if(sessionlist.size() == 0){
     String fname = UserInfo.getFirstName();
     String lname = UserInfo.getLastName();   
     session = new SessionDetail__c();
     session.Session_ID__c = UserInfo.getSessionId();
     session.Customer_Name__c = fname + ' '+ lname;
     try {
       upsert session Session_ID__c;
     }
     catch (DmlException e) {
       System.debug('Upsert Failed' + e.getMessage());
     }
     sessionlist = [select Id, Name, Session_ID__c from SessionDetail__c where Session_ID__c =: UserInfo.getSessionId()];
   } 
   for(SessionDetail__c  s: sessionlist) {  
     sessionaction = new SessionAction__c();
     addaction(url, button_name, action, s.Id);
   }
 }
 
 public static void addaction(string url, string button_name, string action, String Id) {
   sessionaction.Page_URL__c = url;
   sessionaction.SessionDetail__c = Id;
   sessionaction.Time__c = datetime.now();
   sessionaction.Button_Name__c = button_name;
   sessionaction.Action__c = action;
   try {
     insert sessionaction;
   }
   catch (DmlException e) {
      System.debug('insert Failed' + e.getMessage());
    }  
 }
 //Test Method
 public static testMethod void test_addsessiondetails() {
 
   test.startTest();
   SessionTrackController.addsessiondetails('https://cs8.salesforce.com' , 'Button click', 'Refer a Friend');
   test.stopTest();
   
   List<SessionAction__c > actionlist = [select id from SessionAction__c where Action__c =: 'Button click'];
   System.assertEquals(actionlist.size(), 1);
 }
}