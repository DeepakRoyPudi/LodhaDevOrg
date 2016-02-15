public class SpWelcomeCallExtension {

public Id booking_id{get;set;}
public Booking_Information__c booking{get;set;}
public Project_Name__c projdet {get;set;}
public Wing__c wing {get;set;}
public opportunity opp {get; set;}
public account PersonAccount {get; set;}
public Flat__c flat {get; set;}
public Stage_Payment_Details__c paylst {get; set;}
public String customer_name_details{get;set;}
public String flat_details{get;set;}
Public string Address {get; set;}
Public string ApplicationCombination {get; set;}
Public FAME__C fame {get; set;}
Public string ChannelPartner{get; set;}
Public string carpetarea{get; set;}
Public string considerationvalue{get; set;}
Public string ParkingCombination {get; set;}
Public Date Expecteddate {get; set;}
Public string rolename;
Public Welcome_Call_Details__c welcomecall{get; set;}
public Boolean Isnotallow{get; set;}
Public Task FameTask;
    public SpWelcomeCallExtension(ApexPages.StandardController controller) {
        string Query='';
        booking_id= ApexPages.currentPage().getParameters().get('booking');
        if(booking_id != null) {
            Query=getObjectQuery('Welcome_Call_Details__c', 'Booking_Information__c',String.valueof(booking_id));
            Query= Query+ ' Order By CreatedDate DESC limit 1';
            welcomecall=Database.Query(Query);
            getBookingInfo();
            customer_name_details = booking.Name_of_Applicant__c ;
            flat_details = wing.Project__c + '   ' + wing.Cluster_hidden__c + '   ' + wing.Name + '   ' + booking.Flat__r.Flat_no_text__c;
            
        }
        id s=[select id,name,profile.name,UserRoleId from user where id=:UserInfo.getUserId()].UserRoleId;
        rolename = [select id,DeveloperName from UserRole where id=:s].DeveloperName;
        FameTask = [Select Id, OwnerId,RM_Last_Hold_Date__c,PI_Last_Hold_Date__c,Welcome_Call_Details_Submitted_Date__c,Welcome_Call_Checklist_Page_URL__c from Task where WhatId =:welcomecall.id Order By CreatedDate ASC limit 1];
        if(FameTask.OwnerId == UserInfo.getUserId() || UserInfo.getprofileid()==[select profileid,profile.name from user where profile.name='System Administrator' limit 1].profileid){
            Isnotallow=false;
        }
        else{
            Isnotallow=true;
        }        
        
    }
    
    public void getBookingInfo() {
        ParkingCombination='';
        booking = [select Name_Of_Opportunity__c,COAPPLICANT_RELATIONSHIP__c,Title_of_Applicant__c,City__c,Pincode__c,City_of_Co_applicant__c,PAN_Number_of_Co_Applicant__c,Country_of_Co_applicant__c,Country_of_Applicant__c,Title_of_Co_Applicant__c,PAN_Number_of_Applicant__c,Parking_Nos_2W__c,Parking_Nos_4w__c,Parking_Type__c,Consideration_Rs__c,Consideration_Actual_Rs__c,Secondary_Applicant__c,Contact_Nos__c,Email__c,Address1__c,Address2__c,Address3__c,Application_Date__c,Name_Of_Opportunity__r.accountid, Flat__c,Name_of_Applicant__c, Oasys_Flat_Code__c,Flat__r.Wing__c, Flat__r.Flat_no_text__c, Sales_Person__c, Sales_Person__r.Name, Project_Hidden__c, booking_status__c, Booking_By__c,Booking_Date__c,Selected_discount_type__c, Customer_Type__c,CreatedById ,CreatedBy.FirstName, CreatedBy.LastName from Booking_Information__c  where Id=:booking_id ];
        projdet = [select Name, Project_Incharge__c, Site_Incharge__c, Site_Incharge__r.Name, Project_Incharge__r.Name, Project_Type__c from Project_Name__c where Name=: booking.Project_Hidden__c];
        wing = [select Project__c, Cluster_hidden__c, Name, Project_Incharge_Relationship_Manager__c, Project_Incharge_Relationship_Manager__r.Name from Wing__c where Id=:booking.Flat__r.Wing__c];
        PersonAccount = [select id,name,Mobile_Phone__c,PersonEmail,Address2_O_cont__pc,Address2_R_cont__pc,Address1_O_cont__pc,Address1_R_cont__pc,Address3_O_cont__pc,Address3_R_cont__pc,
        City_O_cont__pc,
        City_cont__pc,
        Pincode_O_cont__pc,Pincode_R_cont__pc,Zone_O_cont__pc,Zone_R_cont__pc,State_O_cont__pc,State_R_cont__pc,Other_City_O_cont__pc,Other_City_cont__pc,Preferred_Correspondence_Address__c,ispersonAccount,Country_O_cont__pc,Country_R_cont__pc from account where id=:booking.Name_Of_Opportunity__r.accountid];
        flat = [select Flat_No__c,Carpet_Area__c,Flat_no_text__c,Flat_Type__c,Flat_Type_Text__c,Floor__c,Status__c from Flat__c where Id=: booking.Flat__c];
        paylst =[select id,Booking_Information__c,Payment_Description__c,Requested_Date_Expected__c,Actual_Completion_Date__c from Stage_Payment_Details__c where Booking_Information__c=:booking.id order by Actual_Completion_Date__c DESC limit 1];
        //fame=[select id,Channel_Partner_Name__c,Channel_Partner_Name_NA__c from fame_by_sales__c where Booking_Information__c=:booking.id Order By CreatedDate DESC Limit 1];
        fame=[select id,Channel_Partner_Name__c,Channel_Partner_Name_NA__c from fame__c where Booking_Information__c=:booking.id Order By CreatedDate DESC Limit 1];
        
        welcomecall.Application_Date__c=booking.Application_Date__c;
        
        if(welcomecall.Title_of_Applicant__c==null || welcomecall.Title_of_Applicant__c==''){
            welcomecall.Title_of_Applicant__c=booking.Title_of_Applicant__c;
        }
        if(welcomecall.PAN_Number_of_Applicant__c==null || welcomecall.PAN_Number_of_Applicant__c==''){
            welcomecall.PAN_Number_of_Applicant__c=booking.PAN_Number_of_Applicant__c;
        }
        
        if(welcomecall.Address_Line_1__c==null || welcomecall.Address_Line_1__c==''){
            welcomecall.Address_Line_1__c=booking.Address1__c;
        }
        
        if(welcomecall.Address_Line_2__c==null || welcomecall.Address_Line_2__c==''){
            welcomecall.Address_Line_2__c=booking.Address2__c;
        }
        
        if(welcomecall.Address_Line_3__c==null || welcomecall.Address_Line_3__c==''){
            welcomecall.Address_Line_3__c=booking.Address3__c;
        }
        
        if(welcomecall.City_of_Applicant__c==null || welcomecall.City_of_Applicant__c==''){
            welcomecall.City_of_Applicant__c=booking.City__c;
        }
        
        if(welcomecall.Pin_code__c==null || welcomecall.Pin_code__c==''){
            welcomecall.Pin_code__c=booking.Pincode__c;
        }
        
        if(welcomecall.Country_of_Applicant__c==null || welcomecall.Country_of_Applicant__c==''){
            welcomecall.Country_of_Applicant__c=booking.Country_of_Applicant__c;
        }
        
        if(welcomecall.Title_of_Co_Applicant__c==null || welcomecall.Title_of_Co_Applicant__c==''){
            welcomecall.Title_of_Co_Applicant__c=booking.Title_of_Co_Applicant__c;
        }
        
        if(welcomecall.Relationship_of_Co_Applicant_New__c ==null || welcomecall.Relationship_of_Co_Applicant_New__c ==''){
            welcomecall.Relationship_of_Co_Applicant_New__c=booking.COAPPLICANT_RELATIONSHIP__c;
        }
        
        if(welcomecall.PAN_Number_of_Co_Applicant__c==null || welcomecall.PAN_Number_of_Co_Applicant__c==''){
            welcomecall.PAN_Number_of_Co_Applicant__c=booking.PAN_Number_of_Co_Applicant__c;
        }
        
        if(welcomecall.City_of_Co_applicant__c==null || welcomecall.City_of_Co_applicant__c==''){
            welcomecall.City_of_Co_applicant__c=booking.City_of_Co_applicant__c;
        }
        
        if(welcomecall.Country_of_Co_applicant__c==null || welcomecall.Country_of_Co_applicant__c==''){
        welcomecall.Country_of_Co_applicant__c=booking.Country_of_Co_applicant__c;
        }        

        welcomecall.Application_towards_Project_Cluster_Wing__c=booking.Project_Hidden__c+' / '+wing.Cluster_hidden__c+' / '+wing.name+' / '+booking.Flat__r.Flat_no_text__c;
        if(fame.Channel_Partner_Name_NA__c==false){
            welcomecall.Source_of_Booking__c='ChannelPartner -'+fame.Channel_Partner_Name__c;        
        }
        else{
            welcomecall.Source_of_Booking__c=booking.Booking_By__c;
        }
        welcomecall.Carpet_Area_Square_Feet__c=flat.Carpet_Area__c+' Sq.ft';
        welcomecall.Consideration_Value__c=booking.Consideration_Actual_Rs__c+' /-';
        
        if(booking.Parking_Nos_4w__c != null){
            welcomecall.Number_of_parking_slots_included_with_th__c=booking.Parking_Nos_4w__c +' 4 Wheeler ,';
        }
        
        if(booking.Parking_Nos_2W__c!= null){
            welcomecall.Number_of_parking_slots_included_with_th__c+=booking.Parking_Nos_2W__c+' 2 Wheeler ';
        }      
        
        if(booking.Parking_Type__c != null){
            welcomecall.Number_of_parking_slots_included_with_th__c+='- '+booking.Parking_Type__c+' Type';
        }
        //if(welcomecall.Number_of_parking_slots_included_with_th__c.contains(',-')){
        //welcomecall.Number_of_parking_slots_included_with_th__c=welcomecall.Number_of_parking_slots_included_with_th__c.replace(',-','-');
        //}
        welcomecall.Current_stage_of_construction__c=paylst.Payment_Description__c;
        welcomecall.Type_of_Unit__c=flat.Flat_Type_Text__c;
        
        if(welcomecall.Primary_Applicant_s_Name__c == null || welcomecall.Primary_Applicant_s_Name__c == ''){
            welcomecall.Primary_Applicant_s_Name__c=booking.Name_of_Applicant__c;
        }
        if(welcomecall.Co_Applicant_s_Name__c == null || welcomecall.Co_Applicant_s_Name__c == ''){
            welcomecall.Co_Applicant_s_Name__c=booking.Secondary_Applicant__c;
        }
        if(welcomecall.Telephone_Number__c == null || welcomecall.Telephone_Number__c == ''){
            welcomecall.Telephone_Number__c=PersonAccount.Mobile_Phone__c;
        }
        if(welcomecall.Email_address__c == null || welcomecall.Email_address__c == ''){
            welcomecall.Email_address__c=PersonAccount.PersonEmail;
        }

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
    
    Public PageReference hold(){
        if(welcomecall.IsSubmitted_By_RM__c ==false && welcomecall.IsSubmitted_By_PI__c ==false){
            
            if(welcomecall.Telephone_Number__c.length() != PersonAccount.Mobile_Phone__c.length()){
                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Telephone number is invalid.'));
                 return null;
            }
            
            if(rolename.toLowerCase().startswith('relationship_manager')==true){
                welcomecall.RM_Last_Hold_Date__c=date.today();
                FameTask.RM_Last_Hold_Date__c=date.today();
            }
            else{
                welcomecall.PI_Last_Hold_date__c=date.today();
                FameTask.PI_Last_Hold_Date__c=date.today();
            }
            try{                            
                    update welcomecall;
                    update FameTask;
            }
            catch(exception e){
                system.debug('!!!!!!!!!!!update failed'+e);
            }
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Welcome call details Saved successfully.'));
            return null;
        }
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Should not allow to save already submitted record.'));
            return null;
        }
    }
    
    Public PageReference submit(){
        system.debug('!!!!!!!!'+rolename.toLowerCase().startswith('relationship_manager')+'-'+rolename.toLowerCase());      
        String baseUrl = System.URL.getSalesforceBaseUrl().getHost().remove('-api' );
        baseUrl = 'https://' + baseUrl.substring(2,6) + 'salesforce.com';
        String welcomecallChecklist_url = baseUrl  + '/apex/SpWelcomeCallCheckList?booking='+ booking.id;  

        if(welcomecall.IsSubmitted_By_RM__c ==false && welcomecall.IsSubmitted_By_PI__c == false){
        
            if(welcomecall.Expected_Date_of_start_of_fit_outs__c==null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please fill Expected date of start of fit-outs'));
                return null;        
            }
            
            if(welcomecall.Primary_Applicant_s_Name__c ==null || welcomecall.Telephone_Number__c == null || welcomecall.Email_address__c == null || welcomecall.Title_of_Applicant__c==null || welcomecall.Address_Line_1__c==null || welcomecall.Address_Line_2__c==null || welcomecall.Address_Line_3__c==null || welcomecall.City_of_Applicant__c==null || welcomecall.Pin_code__c==null || welcomecall.Country_of_Applicant__c==null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please fill all primary applicant related mandatory fields.'));
                return null;        
            }
            
            if(welcomecall.Co_Applicant_s_Name__c != null && ( welcomecall.Title_of_Co_Applicant__c==null || welcomecall.Relationship_of_Co_Applicant_New__c==null || welcomecall.Country_of_Co_applicant__c==null || welcomecall.City_of_Co_applicant__c==null)){
                system.debug('@@@@@@@'+welcomecall.Co_Applicant_s_Name__c+'-'+welcomecall.Title_of_Co_Applicant__c+'-'+welcomecall.Relationship_of_Co_Applicant_New__c+'-'+welcomecall.Country_of_Co_applicant__c+'-'+welcomecall.City_of_Co_applicant__c);
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please fill all Co-Applicant applicant related mandatory fields.'));
                return null; 
            }
            
            if(welcomecall.Telephone_Number__c.length() != PersonAccount.Mobile_Phone__c.length()){
                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Telephone number is invalid.'));
                 return null;
            }
            /*if(welcomecall.Email_address__c.indexof('@')<1 || welcomecall.Email_address__c.lastindexof('.')<welcomecall.Email_address__c.indexof('@')+2 || welcomecall.Email_address__c.lastindexof('.')+2>=welcomecall.Email_address__c.length()){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error,'Invalid Email Address.'));
                return null;
            }*/

            booking.Name_of_Applicant__c=welcomecall.Primary_Applicant_s_Name__c;
            booking.Secondary_Applicant__c=welcomecall.Co_Applicant_s_Name__c;
            PersonAccount.Mobile_Phone__c=welcomecall.Telephone_Number__c;
            booking.Contact_Nos__c=welcomecall.Telephone_Number__c;
            PersonAccount.PersonEmail=welcomecall.Email_address__c;
            booking.Email__c=welcomecall.Email_address__c;
            
            booking.Title_of_Applicant__c=welcomecall.Title_of_Applicant__c;
            booking.PAN_Number_of_Applicant__c=welcomecall.PAN_Number_of_Applicant__c;
            booking.Address1__c=welcomecall.Address_Line_1__c;
            booking.Address2__c=welcomecall.Address_Line_2__c;
            booking.Address3__c=welcomecall.Address_Line_3__c;
            booking.City__c=welcomecall.City_of_Applicant__c;
            booking.Pincode__c=welcomecall.Pin_code__c;
            booking.Country_of_Applicant__c=welcomecall.Country_of_Applicant__c;
            booking.Title_of_Co_Applicant__c=welcomecall.Title_of_Co_Applicant__c;
            booking.COAPPLICANT_RELATIONSHIP__c=welcomecall.Relationship_of_Co_Applicant_New__c;
            booking.PAN_Number_of_Co_Applicant__c=welcomecall.PAN_Number_of_Co_Applicant__c;
            booking.City_of_Co_applicant__c=welcomecall.City_of_Co_applicant__c;
            booking.Country_of_Co_applicant__c=welcomecall.Country_of_Co_applicant__c;


            welcomecall.Submitted_Date__c=date.today();
            if(rolename.toLowerCase().startswith('relationship_manager')==true){
                welcomecall.IsSubmitted_By_RM__c=true;                                               
            }
            else{
                welcomecall.IsSubmitted_By_PI__c=true;                             
            }
            try{
                update welcomecall;  
                update booking;
                update PersonAccount;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Welcome call details submitted successfully.'));
               }
            catch(exception e){
                system.debug('!!!!!!!!!!!!!!Update failed'+e);
            }   
            
            FameTask.Welcome_Call_Checklist_Page_URL__c=welcomecallChecklist_url;
            FameTask.Welcome_Call_Details_Submitted_Date__c=date.today();
            update FameTask;
            return null;
        } 
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Should not allow to re-submit.'));
            return null;
        }       
    }

}