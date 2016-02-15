/*
*    Description : Apex Test Class for AgreementViewController
* 
*    Version            Date            Author                    Description
*    1.0                11/06/2014      Siddharth(Eternus)        Initial Draft
*/

@isTest
public class AgreementViewControllerTest {

    public static testMethod void sessionIdTest(){
        
        apexpages.currentPage().getParameters().put('sessionId','1234');
        AgreementViewController oAgreementViewController = new AgreementViewController();
    }
}