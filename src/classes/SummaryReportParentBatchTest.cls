/*
*    Description: Test class for Summary report parent batch class 
*    
*    Version       Date            Name             Description
*    1.0           07/07/2014      Asmita Bubane    Initial Draft
*/

// System assumes that the cases created on one day prior so as to get the Case data


@isTest(seealldata = true)
public class SummaryReportParentBatchTest {

    static testMethod void summaryReportEmailTest() {
        
        Database.Querylocator qryLocator;
        Database.Batchablecontext bc;
        Case oCase = new Case();
        List<Case> listCase = new List<Case>();
        
        Test.startTest();
            SummaryReportParentBatch oSummaryReport = new SummaryReportParentBatch();
            qryLocator = oSummaryReport.start(bc);
            
            Database.Querylocatoriterator qryLocatorIterator = qryLocator.iterator();
            while(qryLocatorIterator.hasNext()){
                
                oCase = (Case)qryLocatorIterator.next();
                listCase.add(oCase);
                
            }// end of while
            
            oSummaryReport.execute(bc, listCase);
            oSummaryReport.finish(bc);
        Test.stopTest();
        
    }// end of summaryReportEmailTest()
}