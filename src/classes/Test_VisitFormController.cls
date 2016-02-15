@istest(seealldata=false)
private class Test_VisitFormController{

public testmethod static void TestVisitFormController(){
    Id Personaccid=[select id,name from recordtype where name='Person Account'].id;
    Id Bookaccid=[select id,name from recordtype where name='Booked Account'].id;
    
    Account Accobj=new Account(recordtypeid=Personaccid,lastname='Test',
                               firstname='Test',
                               salutation='Mr',
                               DOB_Of_Client__c=date.today(),
                               Address1_R_cont__pc='Test',
                               Address2_R_cont__pc='Test',
                               Address3_R_cont__pc='Test',
                               Zone_R_cont__pc='Test', 
                               City_cont__pc='Test', 
                               Country_R_cont__pc='Test',
                               Other_City_cont__pc='Test',
                               State_R_cont__pc='Test',
                               Pincode_R_cont__pc='345678',
                               Occupation_acc__c='Test',
                               Lead_Company_Name_cont__pc='Test',
                               Alternate_Designation__c='Test',
                               Designation__pc='Test',
                               Address3_O_cont__pc='Test',
                               Pincode_O_cont__pc='234789',
                               Phone='9098765678',
                               Office_Phone_cont__pc='9098765678',
                               PersonEmail='test@capgemini.com',
                               Personal_Email__pc='test@capgemini.com',
                               Mobile_Phone__c='2345678989',
                               Type_of_Home__c='Test',
                               Current_Home_ownership__c='Rented',
                               Car_s_Owned__c ='Maruti');
    insert Accobj;
    
    Account BookAcc=new Account (RecordTypeId=Bookaccid,lastname='test',Mobile_Phone__c='2345678989');
    insert BookAcc;
    
    Project_Name__c ProjObj=new Project_Name__c(Name='Test',Project_Type__c='Casa',Record_Type__c='Residential',CRN_INIT__c='566');
    insert Projobj;
    
    Opportunity obj=new Opportunity(StageName='Open',closedate=date.today(),name='Test',Project_Name__c=ProjObj.id,IsActive__c=true,Project_Interested__c='Casa Bella',Walk_in_Source__c='Email',Referred_Booked_Account__c=BookAcc.id,AccountId=Accobj.id,Walk_in_Referred_Booked_Account__c=BookAcc.id,Visit_Form_No__c='sddffffff',Visiting_on_behalf_of__c='Self',LeadSource='email');
    insert obj;
    
    VisitFormController each=new VisitFormController();
    each.actionmethod();
    
    System.currentPageReference().getParameters().put('oppid',obj.id);
    VisitFormController each1=new VisitFormController();
    each1.actionmethod();
    
    obj.Visiting_on_behalf_of__c='Family';
    update obj;
    VisitFormController each2=new VisitFormController();
    each2.actionmethod();
    
    obj.Visiting_on_behalf_of__c='Friends/Colleague';
    update obj;
    VisitFormController each3=new VisitFormController();
    each3.actionmethod();
    
}

}