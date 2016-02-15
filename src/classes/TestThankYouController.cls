@IsTest(seealldata=false)
Public class TestThankYouController{

Public testmethod static void TestThankYouController(){
    Project_Name__c pro=new Project_Name__c (Name='The Park',Project_Type__c='Hi End / Luxury',Record_Type__c='Residential',CRN_INIT__c='');
    insert pro;
    Project_Name__c pro1=new Project_Name__c (Name='Lodha Fiorenza',Project_Type__c='Hi End / Luxury',Record_Type__c='Residential',CRN_INIT__c='');
    insert pro1;
    Project_Name__c pro2=new Project_Name__c (Name='New Cuffe Parade',Project_Type__c='Hi End / Luxury',Record_Type__c='Residential',CRN_INIT__c='');
    insert pro2;
    
    String page = '/apex/ThankYouPage'+'?pid=' + pro.id;                  
    PageReference pageRef = new PageReference(page);        
    Test.setCurrentPage(pageRef);    
    ThankYouController ctrl =  new ThankYouController();    
    
    String page1 = '/apex/ThankYouPage'+'?pid=' + pro1.id;                  
    PageReference pageRef1 = new PageReference(page1);        
    Test.setCurrentPage(pageRef1);    
    ThankYouController ctrl1 =  new ThankYouController();  
    
    String page2 = '/apex/ThankYouPage'+'?pid=' + pro2.id;                  
    PageReference pageRef2 = new PageReference(page2);        
    Test.setCurrentPage(pageRef2);    
    ThankYouController ctrl2 =  new ThankYouController();               

}

}