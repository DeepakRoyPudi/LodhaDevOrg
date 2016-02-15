/* Description -
Apex class used for Loginpage 
@Created by: Trupti Dhoka
@Created Date: 15/03/2015

--------------------------------------------------------------------------------
| Modified By      | Modified Date       | Version        | Description         |
--------------------------------------------------------------------------------
|Trupti Dhoka       23/04/2015
--------------------------------------------------------------------------------
*/




Global class LoginPageCSS2_0Controller {

    Global String password { get; set; }
    Global String username { get; set; }
    //public Id  userId{get;set;}  //store ID of Loggedin user
    public string CRN {get; set;} //param from vf page url
      global PageReference forwardToCustomAuthPage() {
        return new PageReference( '/LoginPageCSS2_0'); 
    }
    
    public PageReference login() 
    {
           try
           {
               User userObj = [Select Id,Username from User where Username=:username];
               CRN = CreateQueryHelper.getCustomerCRN(userObj.Id);
           }
           
           catch(Exception e)
           {
               ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter valid Username'));
               return null;
           }
           
          
           if(String.isNotBlank(CRN))
           {  
              return Site.login(username,password,null);
           }  
           else
           {
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.label.CRNvalueNull));
           } 
        return null; 
    }

   
}