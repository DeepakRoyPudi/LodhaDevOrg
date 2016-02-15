/*Description:
An apex page controller that exposes the site forgot password functionality

 @Created by: Trupti Dhoka
 @Created Date:18/04/2015
 
 --------------------------------------------------------------------------------
 | Modified By      | Modified Date       | Version        | Description         |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------
*/
 
public  class ForgotPasswordControllerCSS2_0 {
    //public String username {get; set;}   
    public String crn {get;set;}  
    public list<account> acc {get;set;}
    public list<user> usr{get;set;}
    public ForgotPasswordControllerCSS2_0 () 
    
    {
        acc= new list<account>();
        usr= new list<user>();
    }
  
    public PageReference forgotPassword()
     {
          if((crn == '') || (crn == null))
          {
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,' Please enter CRN.');
             ApexPages.addMessage(myMsg);
             return null;
          }
          
          try
          { 
            acc = [Select id,Personal_Email__pc From Account where CRN__c =: crn limit 1];
          }
          catch(Exception e)
          {
            system.debug(e);
          }
          //get user details with above email id;
          if(acc.size() == 0)
          {
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,' Please enter valid CRN.');
             ApexPages.addMessage(myMsg);
             return null;
          }
          {
              try
              {
                usr = [select id,accountId, Email,Username
                        from user 
                            where accountId =: acc[0].id];
                        
              }
              catch(Exception e)
              {
                system.debug(e);
              }
              if(usr.size() >= 1) 
              {     
                String username = usr[0].Username;
                boolean success = Site.forgotPassword(username);
                PageReference pr = Page.ForgotPasswordConfirmCSS2_0;
                pr.setRedirect(true);
              
                  if (success) {        
                    return pr;
                  }
              }
              else
              {
                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,' Please contact your respective RM.');
                 ApexPages.addMessage(myMsg);
                 return null;
              }
          }
      return null;
    }
    
    /* public static testMethod void testForgotPasswordController() {
      // Instantiate a new controller with all parameters in the page
      ForgotPasswordController controller = new ForgotPasswordController();
      controller.username = 'test@salesforce.com';       
    
      System.assertEquals(controller.forgotPassword(),null); 
    }*/
}