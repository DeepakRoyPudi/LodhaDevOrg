/*    Description: Test Class for FutureClassForConsumingPalavaWebserviceTest
*    
*    Version            Date            Author                    Description
*    1.0                10/11/2014      Asmita(Eternus)           Initial Draft
*/

@isTest
private class FutureClassToConsumePalavaWebserviceTest {

    static testMethod void sendOasysFlatCodeTest() {
        String strOasysFlatCode = 'Test Project Test Cluster Test Wing 101';
        
        // Setting MockCallout class which will call respond method of MochHttpResponseForAftership
        Test.setMock(HttpCalloutMock.class, new MockupResponseForReturningStatusPalava());
        
        // Call to the method which is making callout to Palava webservice
        Test.startTest();
            FutureClassForConsumingPalavaWebservice.sendOasysCode(strOasysFlatCode);
        Test.stopTest();
    }
}