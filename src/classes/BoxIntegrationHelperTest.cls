@isTest

/*    Description: Test Class for Consuming Box Integration Webservice
*    
*    Version            Date            Author                    Description
*    1.0                10/06/2014      Asmita(Eternus)           Initial Draft
*/


global class BoxIntegrationHelperTest{
    
    @isTest static void generateSessionUrlTest(){
    	
    	// Setting MockCallout class
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
    	
        BoxIntegrationHelper oBoxIntegrationHelper = new BoxIntegrationHelper();
    	
        // Making callout to the webservice
        // Calling a class methods and Verifying the response
        System.assertEquals('12345', oBoxIntegrationHelper.generateDocumentId('https://view-api.box.com'));
        System.assertEquals('12345', oBoxIntegrationHelper.generateSessionUrl('12345'));
    }
}