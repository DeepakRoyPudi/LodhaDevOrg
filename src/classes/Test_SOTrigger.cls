@istest(seealldata=true)

public class Test_SOTrigger{
    
    /*
    public testmethod static void Test_SOTrigger(){
      
        List<Booking_Information__c> Book = [SELECT Project_Hidden__c
                                             FROM Booking_Information__c 
                                             WHERE Booking_Status__c='SOLD' AND 
                                                   Name_Of_Opportunity__c != null AND 
                                                   Name_Of_Opportunity__r.stagename != 'Closed Lost' AND 
                                                   SALESORDER_NO__c = null AND 
                                                   CRN_Number_SAP__c = null 
                                                   limit 1];

        if(!Book.isEmpty()){
        
        List<Project_Name__c> Proj=[select id, IsSp2__c
                                    from Project_Name__c 
                                    where name=: Book[0].Project_Hidden__c];            
        }
        
        //Proj.isSP2__c = true;
        //update Proj;

        //Book.SALESORDER_NO__c = '1234567';
        //Book.CRN_Number_SAP__c = '1234567';
        //update Book;
    }
    */
}