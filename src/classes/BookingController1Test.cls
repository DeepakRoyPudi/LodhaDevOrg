@isTest(seeAllData=True)
private class BookingController1Test{    
    public static testMethod void BookingController1Test(){
         
         Booking_Details__c bd = [select id from Booking_Details__c where Consideration_Value__c != null AND Points_Allocated__c = true AND Education_Cess_rate__c!=null AND Service_Tax_Rate__c != null AND Secondary_and_Higher_Education_Cess_Rate__c != null AND Channel_Partner_Offer__c != null AND Channel_Partner__c != null LIMIT 1];
               
         PageReference s = new PageReference('apex/Invoice_with_Service_Tax?id='+bd.Id); 
         Test.setCurrentPage(s);
         BookingController1 controllerObj=new BookingController1();
            
            
               
        }
    }