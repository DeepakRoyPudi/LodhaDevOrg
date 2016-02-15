@istest(seealldata=false)
public class TestRestSmsLead{


Testmethod static void testRestResource(){
    ProjectCodes__c RelatedProjectNameObject=new ProjectCodes__c(Name='LA',Project_Name__c='Lodha Aqua');
    insert RelatedProjectNameObject;
    
    Project_Name__c SampleProject=new Project_Name__c(Name='Lodha Aqua',Record_Type__c='Residential',Project_Type__c='Hi End / Luxury',CRN_INIT__c='tst');
    insert SampleProject;

    RestRequest req =new RestRequest();
    RestResponse res =new RestResponse();
    RestContext.request=req;
    RestContext.response=res;
    Map<string,string> Pairvalues=RestContext.request.params;
    Pairvalues.put('mobileno','1111111111');
    Pairvalues.put('checksum','10');
    Pairvalues.put('projectcode','LA');
    RestSmsLead.doPost();
    
    RestRequest req1 =new RestRequest();
    RestResponse res1 =new RestResponse();
    RestContext.request=req1;
    RestContext.response=res1;
    Map<string,string> Pairvalues1=RestContext.request.params;
    Pairvalues1.put('mobileno','111111111');
    Pairvalues1.put('checksum','10');
    Pairvalues1.put('projectcode','LA');
    RestSmsLead.doPost();
    
    RestRequest req2 =new RestRequest();
    RestResponse res2 =new RestResponse();
    RestContext.request=req2;
    RestContext.response=res2;
    Map<string,string> Pairvalues2=RestContext.request.params;
    Pairvalues2.put('mobileno','1111111111');
    Pairvalues2.put('checksum','11');
    Pairvalues2.put('projectcode','LA');
    RestSmsLead.doPost();
    
    RestRequest req3 =new RestRequest();
    RestResponse res3 =new RestResponse();
    RestContext.request=req3;
    RestContext.response=res3;
    Map<string,string> Pairvalues3=RestContext.request.params;
    Pairvalues3.put('mobileno','1111111111');
    Pairvalues3.put('checksum','10');
    Pairvalues3.put('projectcode','');
    RestSmsLead.doPost();
    
    RestRequest req4 =new RestRequest();
    RestResponse res4 =new RestResponse();
    RestContext.request=req4;
    RestContext.response=res4;
    Map<string,string> Pairvalues4=RestContext.request.params;
    Pairvalues4.put('mobileno','1111111111');
    Pairvalues4.put('checksum','10');
    Pairvalues4.put('projectcode','LA');
    RestSmsLead.doPost();

}

}