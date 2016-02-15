/*
*    Description : This class is a helper for integrating Box environment with Salesforce
*                  The Apex Controller is used to generate the session URL to display it in iFrame
* 
*    Version            Date            Author                    Description
*    1.0                11/06/2014      Siddharth(Eternus)        Initial Draft
*/

public class AgreementViewController {

    public String strRequestUrl {get; set;}
    
    String strSessionId;
    
    public AgreementViewController(){
        
        strSessionId = '';
        if(Apexpages.currentPage().getParameters().containsKey('sessionId')){
            
            strSessionId = Apexpages.currentPage().getParameters().get('sessionId');
        }
        if(!String.isBlank(strSessionId)){
            
            strRequestUrl = 'https://view-api.box.com/1/sessions/' + strSessionId + '/view?theme=dark';
        }
    }
}