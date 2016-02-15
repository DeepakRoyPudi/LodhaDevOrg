/*Description:
This class is used for homeCSS2_0 which contains all the crisp view Components

 @Created by: Trupti Dhoka
 @Created Date:16/3/2015 
 
 --------------------------------------------------------------------------------
 | Modified By      | Modified Date       | Version        | Description         |
 --------------------------------------------------------------------------------
 |Trupti Dhoka      20/03/2015                      1.1        Added crisp components
 ----------------------------------------------------------------------------------------
 |Sneha p                                       1.2           Logic for widget sequencing
 ---------------------------------------------  -------------------------------------------
*/



public class HomeCSS2_0Controller {

    public String CRN             {get;  set;}
    public String userId;
    //Google Analytics variables
    public static String username     {get;  set;}
    public static String userCRN     {get;  set;}
    public static String userProject   {get;  set;}
    public static String userSeqment   {get;  set;}
    public static DateTime userLastLogin {get;  set;}
    public static Integer userTotallogins{get;  set;}    
    public String firstDiv          {get;  set;}
    public String secondDiv        {get;  set;}
    public String thirdDiv          {get;  set;}
    public String fourthDiv        {get;  set;}
    
    public boolean isProjectWise      {get;  set;}
    // public Project_Name__c prjct      {get;  set;}
    public string imageUrl         {get;  set;}
    public string strProjectImageName    {get;  set;}
    
    // Code which will invoke on page load.
    public PageReference forwardToCustomAuthPage() {
        if(UserInfo.getUserType() == 'Guest'){
            return new PageReference( '/LoginPageCSS2_0');
        }
        else{
            return null;
        }
    }

    //Constructor
    public HomeCSS2_0Controller()
    {
        init();
    }

    public void init(){
        //get CRN of logged in user from CreateQueryHelper class 
        try
        {
            userId=Userinfo.getUserid();
        }
        catch(Exception e) 
        {
            system.debug(e);
        }
        CRN= CreateQueryHelper.getCustomerCRN(userId);
        if(string.isNotblank(CRN))
        {
	        /* Google Analytics*/
	        GoogleAnalyticsHelper.GetReportParameters(userId); 
	        username = GoogleAnalyticsHelper.username;
	        userCRN = GoogleAnalyticsHelper.userCRN ;
	        userProject =GoogleAnalyticsHelper.userProject;
	        userSeqment = GoogleAnalyticsHelper.userSeqment;   
	        userLastLogin= GoogleAnalyticsHelper.userLastLogin;   
	        userTotallogins  =GoogleAnalyticsHelper.TotalLogins;
	        this.checkBackgroundImage();
	        this.setWidgetSequence();
	        strProjectImageName = 'CB_Mailer';
        }
    }

    // Function to decide the widget sequence
    public void setWidgetSequence(){
        list<String> seqList = new list<String>();
        
        //query the widgets for that project
        list<Account> accList = [Select a.PersonMobilePhone, 
                                        a.CRN__c,
                                        Project_Name__c
                                 From Account a 
                                 where a.CRN__c =: userCRN ];
 
        if(accList.size() > 0 && 
           (accList[0].Project_Name__c != null || accList[0].Project_Name__c != '')) {
            
            list<Project_Name__c> prjctName = new list<Project_Name__c>();
            //query enable disable
            if(accList[0].Project_Name__c != null && accList[0].Project_Name__c != '')
              prjctName = [Select Id,
                                    Name,
                                    OrderType__c, 
                                    CSS_Background_Image_URL__c,
                                   (Select Id, 
                                           Name,
                                           WidgetInfo__c,
                                           WidgetInfo__r.Name,
                                           isEnableForRM__c,
                                           isEnableForCustomer__c 
                                    From EnableDisable_widgets__r) 
                             From Project_Name__c p where Name =: accList[0].Project_Name__c];

            map<Id, EnableDisable_widgets__c > enableDisableMap = new map<Id, EnableDisable_widgets__c>();
            
            if(prjctName.size() > 0 && prjctName[0].EnableDisable_widgets__r.size() > 0) {
                for(EnableDisable_widgets__c EDWidget : prjctName[0].EnableDisable_widgets__r) {
                    enableDisableMap.put(EDWidget.WidgetInfo__c, EDWidget);                     
                }
            }
                   
            list<Widget_Sequence__c> widgetSeqList = new list<Widget_Sequence__c>();                   
            if(prjctName.size() > 0){
                if(prjctName[0].OrderType__c != null && prjctName[0].OrderType__c != '' &&
                   prjctName[0].OrderType__c == 'Dynamic') {
                    
                    //Get the User record for that Account
                    list<User> userList = [Select Username, FirstName, ContactId, AccountId 
                                            From User where AccountId =: accList[0].Id];
                    
                    widgetSeqList = [Select Project_Name__c, Project_Name__r.Name,
                                                                 Sequence_ClickCount__c,Sequence_for__c,WidgetInfo__c ,
                                                                 WidgetInfo__r.Name,
                                                                 User__c from 
                                             Widget_Sequence__c where 
                                             RecordTypeId =: Schema.SObjectType.Widget_Sequence__c.getRecordTypeInfosByName().get('Dynamic').getRecordTypeId()
                                             AND User__c =: userList[0].id 
                                             Order by Sequence_ClickCount__c DESC];
                    
                }
                else if(prjctName[0].OrderType__c != null && prjctName[0].OrderType__c != '' && prjctName[0].OrderType__c == 'Custom') 
                {
                    // Query the sequence from 'Widget Sequence' object where record type is default 
                    widgetSeqList = [Select Project_Name__c, Project_Name__r.Name,
                                                                 Sequence_ClickCount__c,Sequence_for__c,WidgetInfo__c ,
                                                                 WidgetInfo__r.Name,
                                                                 User__c from 
                                             Widget_Sequence__c where Sequence_for__c =: 'CSS' AND
                                             Project_Name__c =: prjctName[0].Id AND
                                             RecordTypeId =: Schema.SObjectType.Widget_Sequence__c.getRecordTypeInfosByName().get('Custom').getRecordTypeId()
                                             Order by Sequence_ClickCount__c];
                }

                if( (prjctName[0].OrderType__c != null && 
                    prjctName[0].OrderType__c != '' && 
                    prjctName[0].OrderType__c == 'Default')
                    || widgetSeqList.size() == 0){
                    
                    // Query the sequence from 'Widget Sequence' object where record type is default 
                    widgetSeqList = [Select Project_Name__c, Project_Name__r.Name,
                                                                 Sequence_ClickCount__c,Sequence_for__c,WidgetInfo__c ,
                                                                 WidgetInfo__r.Name,
                                                                 User__c from 
                                             Widget_Sequence__c where Sequence_for__c =: 'CSS' AND
                                             RecordTypeId =: Schema.SObjectType.Widget_Sequence__c.getRecordTypeInfosByName().get('Default').getRecordTypeId()
                                             Order by Sequence_ClickCount__c];


                }

                for(Widget_Sequence__c widgetSeq: widgetSeqList) {
                            
                    if(!enableDisableMap.isEmpty() && enableDisableMap.containsKey(widgetSeq.WidgetInfo__c) &&
                        enableDisableMap.get(widgetSeq.WidgetInfo__c).isEnableForCustomer__c) {

                        seqList.add(widgetSeq.WidgetInfo__r.Name);
                    }
                }
            }
        }
        //set the widget Sequence
        if(seqList.size() > 0)
            firstDiv = seqList[0];
        if(seqList.size() > 1)
            secondDiv = seqList[1];
        if(seqList.size() > 2)
            thirdDiv = seqList[2];
        if(seqList.size() > 3)
            fourthDiv = seqList[3];
            
        //END   
    }

     /* Function to determine if the Background image will be displayed project wise 
        or the Default image will be displayed.*/
    public void checkBackgroundImage() {
      
        BackgroundImageHelper.populateBackgroundImgParam(userCRN);
        isProjectWise = BackgroundImageHelper.isProjectWise;
        imageUrl = BackgroundImageHelper.imageUrl;
    }

}