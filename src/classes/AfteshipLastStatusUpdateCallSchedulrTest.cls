/*
 *    Description : Test class for AftershipLastStatusUpdateCallScheduler
 *    
 *    Vesrion     Date            Author           Description   
 *     1.0      16/09/2014    Asmita (Eternus)    Initial Draft  
 */
 
@isTest
private class AfteshipLastStatusUpdateCallSchedulrTest {

    static testMethod void DespatchLastStatusUpdateCallTest() {
        
        // Setting MockCallout class which will call respond method of MochHttpResponseForAftership
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseForAftershipLastDelivery());
        
        Test.startTest();
        
            SchedulableContext sc;
            AftershipLastStatusUpdateCallScheduler updatlaststatusCall = new AftershipLastStatusUpdateCallScheduler();
            updatlaststatusCall.execute(sc);
        Test.stopTest();
    }
}