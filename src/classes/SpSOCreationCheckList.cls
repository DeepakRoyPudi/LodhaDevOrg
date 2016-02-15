public class SpSOCreationCheckList {
public SOCreation__c SOCreation{get;set;}
public Boolean showSFDCFieldsColumn {get; set;}
public Boolean AppNameCorrect{get; set;}
public Boolean ProjectCorrect{get; set;}
public Boolean ClusterCorrect{get; set;}
public Boolean FlatCorrect{get; set;}
public Boolean AppDateCorrect{get; set;}
public Boolean BasicCorrect{get; set;}
public Boolean FloorRiseCorrect{get; set;}
public Boolean InfrastructureCorrect{get; set;}
public Boolean DiscountCorrect{get; set;}
public Boolean CVCorrect{get; set;}
public Boolean SourceCorrect{get; set;}
public Boolean PremiumCorrect{get; set;}
Public Boolean issubmitted{get; set;}
public Boolean Direct_Source{get; set;}
public Boolean CRB_Source{get; set;}
public Boolean Broker_Source{get; set;}
public Boolean Others_Source{get; set;}
Public Boolean SelfRef_Source{get; set;}
public Id booking_id{get;set;}
public Booking_Information__c booking{get;set;}
public Project_Name__c projdet {get;set;}
public Wing__c wing {get;set;}
public Flat__c flat{get;set;}
public String flat_Id{get;set;}
Public Task SOTask;

Public SpSOCreationCheckList(){

}

public SpSOCreationCheckList(ApexPages.StandardController controller) 
{
    String Query='';
    booking_id = ApexPages.currentPage().getParameters().get('bookingid');
    booking = [select Name_Of_Opportunity__c,Flat__r.Wing__r.Cluster__r.Name,Flat__r.Wing__r.Cluster__r.Project_Name__r.Name,Flat__r.Flat_No__c,Total_Rate_Sq_ft_Actual_Rs__c,Total_Rate_Sq_ft_Rs__c,Flat__r.Wing__r.RM_Team_Lead__r.Name,Flat__r.Wing__r.RM_Team_Lead__c,Base_Rate_Sq_ft_Actual_Rs__c ,Premium_Sq_ft_Rs__c ,Premium_Sq_ft_Actual_Rs__c,Floor_rise_Sq_ft_Actual_Rs__c,Floor_rise_Sq_ft_Rs__c,Consideration_Actual_Rs__c ,Infrastructure_Cost_Rs__c ,Infrastructure_Cost_Actual_Rs__c,Applicable_Waiver_Sq_ft_Rs__c ,Flat__c,Name_of_Applicant__c, Oasys_Flat_Code__c,Flat__r.Wing__c,Flat__r.Wing__r.name, Flat__r.Flat_no_text__c, Sales_Person__c, Sales_Person__r.Name, Project_Hidden__c, booking_status__c, Booking_By__c, Selected_discount_type__c, Customer_Type__c,CreatedById ,CreatedBy.FirstName, CreatedBy.LastName, Application_Date__c from Booking_Information__c  where Id=:booking_id ];
    projdet = [select Name, Project_Incharge__c,Sap_mapper__c,Site_Incharge__c, Site_Incharge__r.Name, Project_Incharge__r.Name, Project_Type__c from Project_Name__c where Name=: booking.Project_Hidden__c];
    wing = [select Project__c, Cluster_hidden__c, Name, Project_Incharge_Relationship_Manager__c, Project_Incharge_Relationship_Manager__r.Name from Wing__c where Id=:booking.Flat__r.Wing__c];
    flat = [Select Id, Name, Wing__r.name,Flat_Type__r.Name,Wing__c, Wing__r.Project__c, Wing__r.Company__c, 
      Wing__r.Cluster_hidden__c,View__c, Total_Rate_Sq_Ft_Rs__c, Token_Amount_Rs__c,Status__c, 
      Stage_Completed__c, Salable_Area__c, Premium_Sq_Ft_Rs__c, Infrastructure_Incl_in_CV__c, 
      Infrastructure_Cost_Rs__c, Infrastructure_Cost2_Rs__c, Infrastructure2_Incl_in_CV__c, 
      Floor__c, Floor_Rise_Sq_Ft_Rs__c, Flat_Type__c, Flat_No__c, Flat_Cost_Rs__c, 
      DAM_Offer_Sq_Ft_Rs__c, Consideration_Rs__c, Club_Charges_Rs__c, Club_Charges_Incl_in_CV__c, 
      Carpet_Area__c, Base_Rate_Sq_Ft_Rs__c, Applicable_Waiver_Sq_Ft_Rs__c, Amount_Due_Rs__c From Flat__c 
      Where Id =:booking.Flat__c]; 
      
    query = getObjectQuery('SOCreation__c', 'Booking_Information__c', String.valueof(booking_id));
    query = query + ' Order By CreatedDate DESC limit 1';
    SOCreation = database.query(query);
    
    system.debug('!!!!!booking '+booking );
    system.debug('!!!!!projdet '+projdet );
    system.debug('!!!!!wing '+wing );
    system.debug('!!!!!flat '+flat );
    showSFDCFieldsColumn=false;
    AppNameCorrect=false;
    ProjectCorrect=false;
    ClusterCorrect=false;
    FlatCorrect=false;
    AppDateCorrect=false;
    BasicCorrect=false;
    FloorRiseCorrect=false;
    InfrastructureCorrect=false;
    DiscountCorrect=false;
    CVCorrect=false;
    SourceCorrect=false;
    PremiumCorrect=false;
    

    if(SOCreation.Source_Details_By_Page__c=='Direct'){
        Direct_Source=true;    
    }
    else if(SOCreation.Source_Details_By_Page__c=='CRB'){
        CRB_Source=true;
    }
    else if(SOCreation.Source_Details_By_Page__c=='Broker'){
        Broker_Source=true;
    }
    else if(SOCreation.Source_Details_By_Page__c=='Self-Referral'){
        SelfRef_Source=true;
    }
    else if(SOCreation.Source_Details_By_Page__c=='Others'){
        Others_Source=true;
    }
    
    SOTask = [select id,status,Remarks__c from task where whatid=:SOCreation.id order by createddate DESC limit 1];
    if(SOCreation.Issubmitted__c==true){
        issubmitted=true;
    }
    else{
        issubmitted=false;
    }
}

Public pagereference submit(){
    
    try{
    if(projdet.Sap_mapper__c != Userinfo.getuserId()){
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Dont have access to do this.');
        ApexPages.addMessage(myMsg);
        return null;
    }
    
    
    FAME__c fame = [select id,DATE_OF_FORM_LOGIN_IN_SAP__c from FAME__c where Booking_Information__c=:booking_id Order By Createddate DESC Limit 1];
    SOCreation__c a=[select id,Issubmitted__c,SO_Last_Rejected_Date__c,SO_Status__c from SOCreation__c where Booking_Information__c=:booking_id Order By CreatedDate DESC Limit 1];
    showSFDCFieldsColumn=true;
    
    if(Direct_Source==true){
        SOCreation.Source_Details_By_Page__c='Direct';    
    }
    else if(CRB_Source==true){
        SOCreation.Source_Details_By_Page__c='CRB';
    }
    else if(Broker_Source==true){
        SOCreation.Source_Details_By_Page__c='Broker';
    }
    else if(SelfRef_Source==true){
        SOCreation.Source_Details_By_Page__c='Self-Referral';
    }
    else if(Others_Source==true){
        SOCreation.Source_Details_By_Page__c='Others';
    }
    else{
        SOCreation.Source_Details_By_Page__c='';
    }
        
        if(Direct_Source==true){
            system.debug('!!!!!Direct');
            if(booking.Booking_By__c =='Direct' || booking.Booking_By__c =='Email' || booking.Booking_By__c =='Newspaper' || booking.Booking_By__c =='Web' || booking.Booking_By__c =='Online'){
                SOCreation.Source_Details__c=booking.Booking_By__c;
                SourceCorrect=true;
            }
            else{
                SourceCorrect=false;
            }
        }      
        else if(CRB_Source==true){
            system.debug('!!!!!CRB_Source');
            if(booking.Booking_By__c =='referral'){
                SOCreation.Source_Details__c=booking.Booking_By__c;
                SourceCorrect=true;
            }
            else{
                SourceCorrect=false;
            }
        }
        else if(Broker_Source==true){
            system.debug('!!!!!Broker_Source');
            if(booking.Booking_By__c =='Channel Partner'){
                SOCreation.Source_Details__c=booking.Booking_By__c;
                SourceCorrect=true;
            }
            else{
                SourceCorrect=false;
            }
        }
        
        else if(SelfRef_Source==true){
            system.debug('!!!!!SelfRef_Source');
            if(booking.Booking_By__c =='self-referral'){
                SOCreation.Source_Details__c=booking.Booking_By__c;
                SourceCorrect=true;
            }
            else{
                SourceCorrect=false;
            }
        }
                
        else if(Others_Source==true){
            system.debug('!!!!!Others_Source');
            if(booking.Booking_By__c !='self-referral' && booking.Booking_By__c !='referral' && booking.Booking_By__c !='Channel Partner' && booking.Booking_By__c !='Direct' && booking.Booking_By__c !='Email' && booking.Booking_By__c !='Newspaper' && booking.Booking_By__c !='Web' && booking.Booking_By__c !='Online'){
                system.debug('!!!!!Others_Source1'+booking.Booking_By__c);
                SOCreation.Source_Details__c=booking.Booking_By__c;
                SourceCorrect=true;
            }
            else{
                system.debug('!!!!!Others_Source2'+booking.Booking_By__c);
                SourceCorrect=false;
            }
        }
                       
        
        else{
             system.debug('!!!!!nothing has selected');
             SourceCorrect=false;
        }

        
    if(string.valueOf(SOCreation.Applicant_Name__c) == booking.Name_of_Applicant__c){
         AppNameCorrect=true;
    }
    else{
        AppNameCorrect=false;
    }
    
    if(string.valueOf(SOCreation.Project__c) == booking.Flat__r.Wing__r.Cluster__r.Project_Name__r.Name){
         ProjectCorrect=true;
    }
    else{
        ProjectCorrect=false;
    }
    
    if(SOCreation.Cluster__c != null && string.valueOf(SOCreation.Cluster__c).startswith(string.ValueOf(booking.Flat__r.Wing__r.Cluster__r.Name)) && string.valueOf(SOCreation.Cluster__c).Endswith(string.ValueOf(booking.Flat__r.Wing__r.Name)) ){
         system.debug('@@@@@@@inside cluster');
         ClusterCorrect=true;
    }
    else{
        ClusterCorrect=false;
    }
    
    //system.debug('@@@@@@@flat field value'+flat.Flat_No__c+'-'+string.valueOf(flat.Flat_No__c)+'-'+flat.Flat_No__c.format()+'-'+SOCreation.Flat_No__c+'-'+SOCreation.Flat_No__c.replaceall(',','').trim());
    if(SOCreation.Flat_No__c != null && SOCreation.Flat_No__c != '' && SOCreation.Flat_No__c.replaceall(',','').trim() == string.valueOf(flat.Flat_No__c)){
         system.debug('@@@@@@@inside flat');
         FlatCorrect=true;
    }
    else{
        system.debug('@@@@@@@inside flat1');
        FlatCorrect=false;
    }
    
    if(SOCreation.Application_Date__c == booking.Application_Date__c){
         AppDateCorrect=true;
    }
    else{
        AppDateCorrect=false;
    }
    
    if(SOCreation.Rate_Details_Basic__c == booking.Base_Rate_Sq_ft_Actual_Rs__c){
         BasicCorrect=true;
    }
    else{
        BasicCorrect=false;
    }
    
    if(SOCreation.Rate_Details_Floor_Rise__c == booking.Floor_rise_Sq_ft_Actual_Rs__c){
         FloorRiseCorrect=true;
    }
    else{
        FloorRiseCorrect=false;
    }
    
    system.debug('@@@@@@@@@'+booking.Total_Rate_Sq_ft_Rs__c+'-'+booking.Total_Rate_Sq_ft_Actual_Rs__c);
    if(SOCreation.Rate_Details_Discount__c == (booking.Total_Rate_Sq_ft_Rs__c-booking.Total_Rate_Sq_ft_Actual_Rs__c)){
         DiscountCorrect=true;
         system.debug('@@@@@@@@@dc');
    }
    else{
        DiscountCorrect=false;
        system.debug('@@@@@@@@@df');
    }
    
    if(SOCreation.Rate_Details_Premium__c== booking.Premium_Sq_ft_Actual_Rs__c){
         PremiumCorrect=true;
         
    }
    else{
        PremiumCorrect=false;
         
    }
    
    if(SOCreation.Rate_Details_Infrastructure__c == booking.Infrastructure_Cost_Actual_Rs__c){
         InfrastructureCorrect=true;
    }
    else{
        InfrastructureCorrect=false;
    }
    
    if(SOCreation.Total_Consideration__c == booking.Consideration_Actual_Rs__c){
         CVCorrect=true;
    } 
    else{
        CVCorrect=false;
    }  
    
    
        if(a.Issubmitted__c==false){  
            
            if(AppNameCorrect==true && ProjectCorrect==true && ClusterCorrect==true && FlatCorrect==true && AppDateCorrect==true && BasicCorrect==true && FloorRiseCorrect==true && DiscountCorrect==true && PremiumCorrect==true && InfrastructureCorrect==true && CVCorrect==true && SourceCorrect==true){
                SOCreation.SO_Task_Submitted_Date_time__c=system.now();
                SOCreation.Issubmitted__c=true;
                SOCreation.SO_Status__c='Accept';
                update SOCreation;            
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Record Getting saved Successfully.');
                ApexPages.addMessage(myMsg);
                
                
                SOTask.status='completed';
                SOTask.Remarks__c=SOCreation.Remarks__c;
                update SOTask;
                
        
                issubmitted=true;
                
                //ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.INFO,'Generate SO Creation has been done successfully.');
                //ApexPages.addMessage(myMsg1);  
        
                       
            }
            else{           
                SOTask.Remarks__c=SOCreation.Remarks__c;
                if(SOTask.SO_Last_Rejected_Date__c == null){
                    SOTask.SO_Last_Rejected_Date__c=system.now();
                }                
                update SOTask; 
                
                
                if(SOCreation.SO_Last_Rejected_Date__c == null){
                    SOCreation.SO_Last_Rejected_Date__c=system.now();              
                }                
                SOCreation.SO_Status__c='Reject';
                update SOCreation;
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error:Invalid Input found in some fields. Please check.');
                ApexPages.addMessage(myMsg);        
            }
            
            
        }
        else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error:Doesn\'t allow to re-submit');
            ApexPages.addMessage(myMsg);     
        }
    }
    catch(exception e){    
        system.debug('!!!!!!!!!!!!!exception in SO Creation'+e);
        
        if(SOCreation.SO_Last_Rejected_Date__c == null){
            SOCreation.SO_Last_Rejected_Date__c=system.now();
            SOCreation.SO_Status__c='Reject';
            update SOCreation;
            
            SOTask.Remarks__c=SOCreation.Remarks__c;
            SOTask.SO_Last_Rejected_Date__c=system.now();
            update SOTask;
        }
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error:Invalid Input found in some fields. Please check.');
        ApexPages.addMessage(myMsg);
    } 
    
    return null;
}

public String getObjectQuery(String Object_Name, String Where_param, String Where_param_value) {
  String objectName = Object_Name;  // modify as needed
  String sqlquery = 'SELECT';
  Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
 
  // Grab the fields from the describe method and append them to the queryString one by one.
  for(String s : objectFields.keySet()) {    
     sqlquery += ' ' + s + ', ';
  }

  // Strip off the last comma if it exists.
     sqlquery = sqlquery.removeEnd(', ');

  // Add FROM statement
  sqlquery += ' FROM ' + objectName;
 
  // Add on a WHERE/ORDER/LIMIT statement as needed
  sqlquery += ' WHERE ' + Where_param + ' = \''+ Where_param_value +'\''; // modify as needed 
  system.debug('sqlquery : ' + sqlquery);
  return sqlquery;
}

public void send_email(String subject, String html_body, Id receipient_id) {
  system.debug('Subject: ' + subject + ' Html_body' + html_body + ' Id: ' + receipient_id);
  Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
  mail.setBccSender(false);
  mail.setUseSignature(false);
  mail.setTargetObjectId(receipient_id);
  mail.setSubject(subject);
  mail.setHtmlBody(html_body);
  mail.setReplyTo('noreplay@LodhaGroup.com');
  mail.setSenderDisplayName('Lodha Admin');
  mail.setSaveAsActivity(false); 
  if(Test.isRunningtest()==false){
      Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
  }
}

public void send_email1(String subject, String html_body,string receipient_id) {
  system.debug('Subject: ' + subject + ' Html_body' + html_body + ' Id: ' + receipient_id);
  Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
  string[] toaddress=new string[]{receipient_id};
  mail.setBccSender(false);
  mail.setUseSignature(false);
  mail.setSubject(subject);
  mail.setHtmlBody(html_body);
  mail.setReplyTo('noreplay@LodhaGroup.com');
  mail.setSenderDisplayName('Lodha Admin');
  mail.setSaveAsActivity(false); 
  mail.settoaddresses(toaddress);
  if(Test.isRunningtest()==false){
      Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
  }
}


}