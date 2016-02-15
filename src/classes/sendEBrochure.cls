public with sharing class sendEBrochure {
    
    public String email{get;set;}
    public Boolean mailStatus{get;set;}
    public Boolean errorStatus{get;set;}
    public Boolean sendingStatus{get;set;}
    public String projectName{get;set;}
    public String accountName{get;set;}
    public String eBody{get;set;}
    public Project_Name__c projName{get;set;}
   
    public sendEBrochure (){
        mailStatus = false;
        errorStatus = false;
        sendingStatus = true;
        email=ApexPages.currentPage().getParameters().get('email');
        projectName=ApexPages.currentPage().getParameters().get('project');
        accountName=ApexPages.currentPage().getParameters().get('acc');
    }

    public void sendmail(){
        
        
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'donotreply@lodhagroup.com'];
        if ( owea.size() > 0 ) {
            mail.setOrgWideEmailAddressId(owea.get(0).Id);
        }
        
        String[] toAddresses = new String[] {email};        
        projName=[Select id,name,Project_Type__c,E_Brochure_Links__c,E_Brochure_Phone_No__c from Project_Name__c where name=:projectName limit 1];
        
        eBody = '<div style=\"font-family: Calibri;\">Dear  '+accountName+',<br/><br/>Greetings from Lodha Group ! Thank you for your interest in '+projName.name+'.<br/> As requested please find below the link to download the E - Brochure for '+projName.name+'.<br/><br/>'+projName.E_Brochure_Links__c+'<br/><br/>Please feel free to call us on '+projName.E_Brochure_Phone_No__c +' for any further queries. <br/><br/> Warm Regards, <br/> Lodha Group<br/><br/>This is an auto generated mail, Kindly do not reply to this mail.</div>';
        
        if(projName!=null && projName.E_Brochure_Links__c!=null){
            
        mail.setHtmlBody(ebody);          
        mail.setToAddresses(toAddresses);
        //mail.setReplyTo('noreply@lodhagroup.com');
       // mail.setSenderDisplayName('Lodha Group');
       // mail.setOrgWideEmailAddressId('0D2D000000000wo');
       // mail.setSenderDisplayName('Lodha Group');
        mail.setSubject('Lodha Group: E-Brochure Link for '+projName.name);        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        mailStatus = true;
        sendingStatus = false;
        
        }
        else{
         errorStatus = true;
         sendingStatus = false;
        }
       
    }
  @isTest
  static void testProjectImage(){
       Account a=new Account();
        a.FirstName='Test';
        a.LastName='One';
        a.PersonEmail='test1@cg.com';
        insert a;
        
        Project_Name__c project=new Project_Name__c();
        project.Name='Test';
        project.Project_Type__c='Casa';
        //project.CRN_INIT__c='Tes';
        project.E_Brochure_Links__c = '123';
        insert project;
        
        Opportunity opp=new Opportunity();
        opp.Name='Test';
        opp.AccountId=a.Id;
        opp.closedate=date.newinstance(2012, 7, 2);
        opp.Date_of_Visit__c = date.newinstance(2012, 7, 20);
        opp.IsActive__c=true;
        opp.Visit_Form_No__c = '765423234';
        opp.Walk_in_Source__c = 'ClubCASA';
        opp.Project_Name__c=project.Id;
        opp.StageName='Qualified';
        opp.Upper_EDC__c =  date.newinstance(2012, 9, 5);
        insert opp;
        
        Apexpages.currentPage().getParameters().put('email',a.PersonEmail);
        Apexpages.currentPage().getParameters().put('project',project.name);
        Apexpages.currentPage().getParameters().put('acc',a.name);
        SendEBrochure se = new sendEBrochure();
        se.sendmail();
  }
}