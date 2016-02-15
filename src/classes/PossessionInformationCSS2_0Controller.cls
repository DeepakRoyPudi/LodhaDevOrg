public class PossessionInformationCSS2_0Controller{

 
  public String CRN{get;set;}
 //Google Analytics variables
  
  public static String username{get;set;}
    public static String userCRN{get;set;}
   public static String userProject{get;set;}
   public static String userSeqment{get;set;}
   public static DateTime userLastLogin {get;set;}
   public String possession_info {get;	set;}
   public RMCSS2_0CustomSettingLinkController customlinks; 
	
   public PossessionInformationCSS2_0Controller()
   {
    //get CRN of logged in user from CreateQueryHelper class 
      String userId=Userinfo.getUserid();
      try
      {
        CRN= CreateQueryHelper.getCustomerCRN(userId);
      }
      catch(Exception e)
      {
        system.debug(e);
      }
      /* Google Analytics*/
        /*system.debug('possession_info before******'+possession_info);
		
        possession_info = customlinks.getDetailsOfPossessionProcess();
        system.debug('possession_info******'+possession_info);*/
		
        GoogleAnalyticsHelper.GetReportParameters(userId); 
        username = GoogleAnalyticsHelper.username;
        userCRN = GoogleAnalyticsHelper.userCRN ;
        userProject =GoogleAnalyticsHelper.userProject;
        userSeqment = GoogleAnalyticsHelper.userSeqment;   
       userLastLogin= GoogleAnalyticsHelper.userLastLogin; 
       	  
    }
}