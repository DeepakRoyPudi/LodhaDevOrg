/**
 * An apex page controller that exposes the site forgot password functionality
 */
public  class ForgotPasswordCustomController {
    public String username {get; set;}   
       
    public ForgotPasswordCustomController() {}
  
    public PageReference forgotPassword() {
      boolean success = Site.forgotPassword(username);
      PageReference pr = Page.ForgotPasswordCustomConfirm;
      pr.setRedirect(true);
      
      if (success) {        
        return pr;
      }
      return null;
    }
    
     public static testMethod void testForgotPasswordController() {
      // Instantiate a new controller with all parameters in the page
      ForgotPasswordCustomController controller = new ForgotPasswordCustomController();
      controller.username = 'test@salesforce.com';       
    
      System.assertEquals(controller.forgotPassword(),null); 
    }
}