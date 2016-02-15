/* Version  			Created By   	 Created Date       Description
 *
 * 	Initial Draft		Sneha P.         12/05/2015       Helper to check if guest User is trying to access community Page, 
 *														  redirect him to Login Page of Community
 *
 */
public with sharing class AuthenticateCommuntiyUserHelper {
	
	//Method to redirect to Login Page for Guest User 
	public static PageReference forwardToCustomAuthPage() {
        if(UserInfo.getUserType() == 'Guest'){
            return new PageReference( '/LoginPageCSS2_0');
        }
        else{
            return null;
        }
    }
    
}