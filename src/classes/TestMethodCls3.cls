@isTest
private class TestMethodCls3 {

   /*  static testMethod void myTest1() {

        // This code runs as the system user
       test.starttest();
        /* User u1;

        try{
          u1 = [select Id from User WHERE IsActive=True AND Profile.Name = 'Customer Care'  LIMIT 1];
        } catch (QueryException qe){

        List<User> users = [SELECT Id, Profile.PermissionsModifyAllData FROM User WHERE IsActive = true LIMIT 1000];

        for(User u : users){
            if(u.Profile.PermissionsModifyAllData = true){
              u1 = u;
              break;
        }
        }

        } */
        
         /* User tu = [select Id from user where Id = '005D0000003MTQPIA4' LIMIT 1];
        

        System.debug(tu);

       //*****Create Queue 
       
       System.runAs(tu){
       
       Group testGroup = new Group ();
       testGroup.Name = 'TestQueue';
       testGroup.Type = 'Queue';
       insert testGroup;
       
       QueueSObject testQueue = new QueueSObject();
       testQueue.QueueId = testGroup.id;
       testQueue.SObjectType = 'Case';
       insert testQueue;

       // Second Queue       
       Group testGroup2 = new Group ();
       testGroup2.Name = 'TestQueue2';
       testGroup2.Type = 'Queue';
       insert testGroup2;
       
       QueueSObject testQueue2 = new QueueSObject();
       testQueue2.QueueId = testGroup2.id;
       testQueue2.SObjectType = 'Case';
       insert testQueue2;



        
        //Run test

        /* SAPBookingIDAgentMapping_del__c a=new SAPBookingIDAgentMapping_del__c(Agent_Name__c=u1.id,Booking_ID__c='',Building_Name__c='MARINA',Flat_No__c='202',Project_Name__c='CASA Rio',Wing__c='d');
        insert a; */
        
        //Assign Case with out any Assignment Groups
     /*    Case c1 = new Case (subject='testcase',tempOwnerID__c=testGroup2.id, 
                                OwnerID=tu.id, 
                                //origin = 'Web',
                               First_Name__c = 'testFirst'+'i',
                               Last_Name__c = 'testLast'+'i', 
                               Mobile__c = '1234567891',
                               Project__c = 'CASA Rio',
                               Buildings_Name__c = 'MARINA',
                               Wing__c = 'd',
                               Flat_No__c = '202'); //tempOwnerID__c=testGroup2.id,  
        insert c1;
        //update c1;
        
        
        //Create Assignment Group
        Assignment_Group_Name__c ag1 = new Assignment_Group_Name__c (Name='TestAG', Type__c = 'Case');
        insert ag1;

         
        //Add bad queue name
        Assignment_Group_Queues__c agqBad = new Assignment_Group_Queues__c(name='Bad Queue',Assignment_Group_Name__c = ag1.id );

        try {
            insert agqBad; 
        } catch (DmlException e){
             System.assert(e.getMessage().contains('CUSTOM_VALIDATION_EXCEPTION'), e.getMessage()); 
        
        } //catch
        }
        
        test.stoptest();
        
    } */
    
    /* static testMethod void myTest2() {
  test.starttest();
        // This code runs as the system user

        User u1;

       /* try{
          u1 = [select Id from User WHERE IsActive=True AND Profile.Name = 'Customer Care'  LIMIT 1];
        } catch (QueryException qe){

        List<User> users = [SELECT Id, Profile.PermissionsModifyAllData FROM User WHERE IsActive = true LIMIT 1000];

        for(User u : users){
            if(u.Profile.PermissionsModifyAllData = true){
              u1 = u;
              break;
        }
        }

        } */
        
       /*  User tu = [select Id from user where Id = '005D0000003MTQPIA4' LIMIT 1];

        System.debug(tu);

       //*****Create Queue 
       System.runAs(tu){
       Group testGroup = new Group ();
       testGroup.Name = 'TestQueue';
       testGroup.Type = 'Queue';
       insert testGroup;
       
       QueueSObject testQueue = new QueueSObject();
       testQueue.QueueId = testGroup.id;
       testQueue.SObjectType = 'Case';
       insert testQueue;

       // Second Queue       
       Group testGroup2 = new Group ();
       testGroup2.Name = 'TestQueue2';
       testGroup2.Type = 'Queue';
       insert testGroup2;
       
       QueueSObject testQueue2 = new QueueSObject();
       testQueue2.QueueId = testGroup2.id;
       testQueue2.SObjectType = 'Case';
       insert testQueue2;


     
        
        //Run test
       
        
        //Create Assignment Group
        Assignment_Group_Name__c ag1 = new Assignment_Group_Name__c (Name='TestAG', Type__c = 'Case');
        insert ag1;        

        //Add Good Queue to Assignment Group
        Assignment_Group_Queues__c agq1 = new Assignment_Group_Queues__c(name=testGroup.Name ,Assignment_Group_Name__c = ag1.id );
        insert agq1;
        
        
        //Add User to Assignment Groups Users
        Assignment_Groups__c agu1 = new Assignment_Groups__c (User__c = tu.id, Active__c='True', Group_Name__c = ag1.id, Last_Assignment__c = datetime.valueOf('2009-01-01 21:13:24') );
        insert agu1;

      /* SAPBookingIDAgentMapping_del__c a=new SAPBookingIDAgentMapping_del__c(Agent_Name__c=u1.id,Booking_ID__c='',Building_Name__c='MARINA',Flat_No__c='202',Project_Name__c='CASA Rio',Wing__c='d');
        insert a;*/
        
    /*     Case c2 = new Case (subject='testcase', tempOwnerID__c=testGroup2.id , 
        //OwnerID=testGroup.id, 
                                //origin = 'Web',
                               First_Name__c = 'testFirst'+'i',
                               Last_Name__c = 'testLast'+'i', 
                               Mobile__c = '1234567891',
                               Project__c = 'CASA Rio',
                               Buildings_Name__c = 'MARINA',
                               Wing__c = 'd',
                               Flat_No__c = '202'); //Set owner ID to Queue
        insert c2;
        //update c2;        
        }
        
        test.stoptest();
        
    } */
    

    /* static testMethod void myTest3() {

        // This code runs as the system user
test.starttest();
        User u1;


        /* try{
          u1 = [select Id from User WHERE IsActive=True AND Profile.Name = 'Customer Care'  LIMIT 1];
        } catch (QueryException qe){

        List<User> users = [SELECT Id, Profile.PermissionsModifyAllData FROM User WHERE IsActive = true LIMIT 1000];

        for(User u : users){
            if(u.Profile.PermissionsModifyAllData = true){
              u1 = u;
              break;
        }
        }

        }*/
        
     /*    User tu = [select Id from user where Id = '005D0000003MTQPIA4' LIMIT 1];

        System.debug(tu);

       //*****Create Queue 
       System.runAs(tu){
       Group testGroup = new Group ();
       testGroup.Name = 'TestQueue';
       testGroup.Type = 'Queue';
       insert testGroup;
       
       QueueSObject testQueue = new QueueSObject();
       testQueue.QueueId = testGroup.id;
       testQueue.SObjectType = 'Case';
       insert testQueue;

       
        
        //Run test        
        
        //Create Assignment Group
        Assignment_Group_Name__c ag1 = new Assignment_Group_Name__c (Name='TestAG', Type__c = 'Case');
        insert ag1;        

        //Add Good Queue to Assignment Group
        Assignment_Group_Queues__c agq1 = new Assignment_Group_Queues__c(name=testGroup.Name ,Assignment_Group_Name__c = ag1.id );
        insert agq1;
        
        
        //Add User to Assignment Groups Users
        Assignment_Groups__c agu1 = new Assignment_Groups__c (User__c = tu.id, Active__c='True', Group_Name__c = ag1.id, Last_Assignment__c = datetime.valueOf('2009-01-01 21:13:24') );
        insert agu1;      
 
        /* SAPBookingIDAgentMapping_del__c a=new SAPBookingIDAgentMapping_del__c(Agent_Name__c=u1.id,Booking_ID__c='',Building_Name__c='MARINA',Flat_No__c='202',Project_Name__c='CASA Rio',Wing__c='d');
        insert a;*/
 
     /*  Case c3 = new Case (subject='testcase', 
        //OwnerID=testGroup.id, 
        //origin = 'Web',
                               First_Name__c = 'testFirst'+'i',
                               Last_Name__c = 'testLast'+'i', 
                               Mobile__c = '1234567891',
                               Project__c = 'CASA Rio',
                               Buildings_Name__c = 'MARINA',
                               Wing__c = 'd',
                               Flat_No__c = '202'); //Set owner ID to Queue
        insert c3;
//        update c3;
        }

        test.stoptest();
        
    } */

    static testMethod void myTest4() {

        // This code runs as the system user

        test.starttest();
        User u1;

       /* try{
          u1 = [select Id from User WHERE IsActive=True AND Profile.Name = 'Customer Care'  LIMIT 1];
        } catch (QueryException qe){

        List<User> users = [SELECT Id, Profile.PermissionsModifyAllData FROM User WHERE IsActive = true LIMIT 1000];

        for(User u : users){
            if(u.Profile.PermissionsModifyAllData = true){
              u1 = u;
              break;
        }
        }

        } */
        
        User tu = [select Id from user where Id = '005D0000003MTQPIA4' LIMIT 1];

        System.debug(tu);

       //*****Create Queue 
       System.runAs(tu){
       Group testGroup = new Group ();
       testGroup.Name = 'TestQueue';
       testGroup.Type = 'Queue';
       insert testGroup;
       
       QueueSObject testQueue = new QueueSObject();
       testQueue.QueueId = testGroup.id;
       testQueue.SObjectType = 'Case';
       insert testQueue;
      

       
        
        //Run test

        //Create Assignment Group
        Assignment_Group_Name__c ag1 = new Assignment_Group_Name__c (Name='TestAG', Type__c = 'Case');
        insert ag1;        

        //Add Good Queue to Assignment Group
        Assignment_Group_Queues__c agq1 = new Assignment_Group_Queues__c(name=testGroup.Name ,Assignment_Group_Name__c = ag1.id );
        insert agq1;
        
          //Test for AG-Queues already assigned to another Assignment Group
        Assignment_Group_Queues__c agq2 = new Assignment_Group_Queues__c(name=testGroup.Name,Assignment_Group_Name__c = ag1.id );
        try {
            insert agq2;
        } catch (DmlException e){
             System.assert(e.getMessage().contains('CUSTOM_VALIDATION_EXCEPTION'), e.getMessage()); 
        } //catch
        }
        test.stoptest();
        
    }
}