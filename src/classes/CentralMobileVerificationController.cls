public with sharing class CentralMobileVerificationController {
   
    public Boolean inputValue{get;set;}
    
    public CentralMobileVerificationController(){
    
        List<Project_Name__c> projList = [Select id, Allow_mobile_verification__c from Project_Name__c where Allow_mobile_verification__c = false];
        if(projList.size()==0){
            inputValue = true;
        }
    }
    
    public void mobileVerification() {
    
        List<Project_Name__c> projectList = [Select Record_Type__c,Project_Type__c,Allow_mobile_verification__c,Type_of_Accomodation__c,Allow_Call_Patching__c,Call_Patch_Category__c from Project_Name__c];
        
        for(integer i = 0 ; i < projectList.size() ; i++ )
        {
            projectList[i].Allow_mobile_verification__c = inputValue ;
        }
        
        update projectList;
        system.debug('>>>>??'+projectList);
    }  
    
    // Test methods
    @istest(seeAlldata=True)
    private static void testMobileVerification(){  
       Project_Name__c pname=new Project_Name__c();
    pname.name='Lodha Dummy';
    pname.Project_Type__c='CASA';
    pname.Record_Type__c='Residential';
    pname.Isactive__c=true;
    pname.Allow_mobile_verification__c=false;
    pname.Allow_Call_Patching__c=false;
    pname.City__c='Mumbai';
    pname.Call_Patch_Category__c = 'Dummy Call';
    pname.Type_of_Accomodation__c = '1 BHK';
    insert pname; 
    
    Project_Name__c pname2=new Project_Name__c();
    pname2.name='Lodha Dummy';
    pname2.Project_Type__c='COMMERCIAL';
    pname2.Record_Type__c='Residential';
    pname2.Isactive__c=true;
    pname2.Allow_mobile_verification__c=true;
    pname2.Allow_Call_Patching__c=true;
    pname2.City__c='Mumbai';
    pname2.Call_Patch_Category__c = 'Dummy Call';
    pname2.Type_of_Accomodation__c = '1 BHK';
    insert pname2;
    
      CentralMobileVerificationController mob = new CentralMobileVerificationController ();
      mob.inputValue = true;
      mob.mobileVerification();
    }
}