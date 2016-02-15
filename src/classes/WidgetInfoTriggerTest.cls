/* 
Description:
test class for cover WidgetInfoTrigger and its helper class WidgetInfoTriggerHelper
 

 @Created by: Sudeep Dube
 @Created Date: 31/03/2015
 
 --------------------------------------------------------------------------------
 | Modified By      | Modified Date       | Version        | Description         |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------
*/


@isTest(SeeAllData = false)
public class WidgetInfoTriggerTest {


    //main test method it insert data into the widgetinfo object 
    public testmethod static void createTestData() {

        //below code call create project static method which insert project records
        WidgetInfoTriggerTest.createprojectData();

        //create list of widget info object 
        list < WidgetInfo__c > wlist1 = new list < WidgetInfo__c > ();

        //create objects of widgetinfo  and add to widget info list
        WidgetInfo__c w1 = new WidgetInfo__c();
        w1.name = 'Recent Activitywlist1';
        w1.Available_For__c = 'Both';
        wlist1.add(w1);


        WidgetInfo__c w2 = new WidgetInfo__c();
        w2.name = 'Booking Payments Transactionswlist1';
        w2.Available_For__c = 'RM';
        wlist1.add(w2);

        WidgetInfo__c w3 = new WidgetInfo__c();
        w3.name = 'Booking Detailswlist1';
        w3.Available_For__c = 'CSS';
        wlist1.add(w3);

        //insert widget info list records 
        insert wlist1;


        //create another list for test below scenario functionality
        //scenario: when the record are exist and then we insert list of records 
        list < WidgetInfo__c > wlist2 = new list < WidgetInfo__c > ();

        WidgetInfo__c w4 = new WidgetInfo__c();
        w4.name = 'Payments Receivedwlist2';
        w4.Available_For__c = 'Both';
        wlist2.add(w4);

        WidgetInfo__c w5 = new WidgetInfo__c();
        w5.name = 'Booking Payments Transactions1wlist2';
        w5.Available_For__c = 'RM';
        wlist2.add(w5);


        WidgetInfo__c w6 = new WidgetInfo__c();
        w6.name = 'Booking Details2wlist2';
        w6.Available_For__c = 'CSS';
        wlist2.add(w6);

        insert wlist2;
       
       //test schenario where the insert with empty values trigger should add error
         list < WidgetInfo__c > wlist3 = new list < WidgetInfo__c > ();

        WidgetInfo__c w7 = new WidgetInfo__c();
        w7.name = 'Payments Receivedwlist3';
       // w7.Available_For__c = 'Both';
        wlist3.add(w7);

        WidgetInfo__c w8 = new WidgetInfo__c();
        w8.name = 'Booking Payments Transactions1wlist3';
        w8.Available_For__c = 'RM';
        wlist3.add(w8);


        WidgetInfo__c w9 = new WidgetInfo__c();
        w9.name = 'Booking Details2wlist3';
        w9.Available_For__c = 'CSS';
        wlist3.add(w9);
        
        try{    
        insert wlist3; 
        }catch(Exception e){
        System.debug(e.getMessage());
        }
        
          //test schenario where the insert with empty values trigger should add error
         list < WidgetInfo__c > wlist4 = new list < WidgetInfo__c > ();

        WidgetInfo__c w10 = new WidgetInfo__c();
        //w10.name = 'Payments Receivedwlist4';
        w10.Available_For__c = 'Both';
        wlist4.add(w10);

        WidgetInfo__c w11 = new WidgetInfo__c();
        w11.name = 'Booking Payments Transactions1wlist4';
        w11.Available_For__c = 'RM';
        wlist4.add(w11);


        WidgetInfo__c w12 = new WidgetInfo__c();
        w12.name = 'Booking Details2wlist4';
        w12.Available_For__c = 'CSS';
        wlist4.add(w12);
        
        try{    
        insert wlist4; 
        }catch(Exception e){
        System.debug(e.getMessage());
        }
        
        
        //test schenario where the insert with empty values trigger should add error
         list < WidgetInfo__c > wlist5 = new list < WidgetInfo__c > ();

        WidgetInfo__c w13 = new WidgetInfo__c();
        w13.name = 'Payments Receivedwlist5';
        w13.Available_For__c = '   ';
        wlist5.add(w13);

        WidgetInfo__c w14 = new WidgetInfo__c();
        w14.name = 'Booking Payments Transactions1wlist5';
        w14.Available_For__c = 'RM';
        wlist5.add(w14);


        WidgetInfo__c w15 = new WidgetInfo__c();
        w15.name = 'Booking Details2wlist5';
        w15.Available_For__c = 'CSS';
        wlist5.add(w15);
        
        try{    
        insert wlist5; 
        }catch(Exception e){
        System.debug(e.getMessage());
        }
        
           //test schenario where the insert with same name field value 
         list < WidgetInfo__c > wlist6 = new list < WidgetInfo__c > ();
        //this below widhet contains name field same as wlist 1 name field  
        WidgetInfo__c w16 = new WidgetInfo__c();
        w16.name = '';
        w16.Available_For__c = 'Both';
        wlist6.add(w16);

        WidgetInfo__c w17 = new WidgetInfo__c();
        w17.name = 'Booking Payments Transactions1wlist6';
        w17.Available_For__c = 'RM';
        wlist6.add(w17);


        WidgetInfo__c w18 = new WidgetInfo__c();
        w18.name = 'Booking Details2wlist6';
        w18.Available_For__c = 'CSS';
        wlist6.add(w18);
        
        try{    
        insert wlist6; 
        }catch(Exception e){
        System.debug(e.getMessage());
        }
       
        
            //test schenario where the insert with empty values trigger should add error
         list < WidgetInfo__c > wlist7 = new list < WidgetInfo__c > ();
             //w19 name same as name wlist.w1 so it create the schenario where duplicasy can be checked   
        WidgetInfo__c w19 = new WidgetInfo__c();
        w19.name = 'Recent Activitywlist1';
        w19.Available_For__c = 'Both';
        wlist7.add(w19);

        WidgetInfo__c w20 = new WidgetInfo__c();
        w20.name = 'Booking Payments Transactions1wlist6';
        w20.Available_For__c = 'RM';
        wlist7.add(w20);


        WidgetInfo__c w21 = new WidgetInfo__c();
        w21.name = 'Booking Details2wlist6';
        w21.Available_For__c = 'CSS';
        wlist7.add(w21);
        
        try{    
        insert wlist7; 
        }catch(Exception e){
        System.debug(e.getMessage());
        }
       
        
    }//end of the method


    //method create test data records for project object
    public static void createprojectData() {
        list < Project_Name__c > plist = new list < Project_Name__c > ();

        Project_Name__c p1 = new Project_Name__c();
        p1.name = 'ProjectTest1';
        p1.Project_Type__c = 'Casa';
        p1.Record_Type__c = 'Residential';
        //p1.CurrencyIsoCode='INR - Indian Rupee';
        p1.OrderType__c = 'Default';
        plist.add(p1);

        Project_Name__c p2 = new Project_Name__c();
        p2.name = 'ProjectTest2';
        p2.Project_Type__c = 'Casa';
        p2.Record_Type__c = 'Residential';
        //p2.CurrencyIsoCode='INR - Indian Rupee';
        p2.OrderType__c = 'Default';
        plist.add(p2);

        Project_Name__c p3 = new Project_Name__c();
        p3.name = 'ProjectTest3';
        p3.Project_Type__c = 'Casa';
        p3.Record_Type__c = 'Residential';
        //p3.CurrencyIsoCode='INR - Indian Rupee';
        p3.OrderType__c = 'Default';
        plist.add(p3);

        insert plist;



    }

}