trigger SpUpdateOpportunity on Booking_Information__c (after insert, after update) {

List<Booking_Information__c> booking_list = new List<Booking_Information__c>();
Map<Id, Opportunity> opp_Update_Map = new Map<Id, Opportunity>();
Map<Id, Flat__c> Flat_details = new Map<Id, Flat__c>();
Set<Id> flat_id = new Set<Id>();
Set<Id> opp_id = new Set<Id>();
Map<Id, String> SM_name_Map = new Map<Id, String>();
boolean cancel;
List<Flat__c> flatList = new List<Flat__c>();
set<Id> userIds=new set<Id>();
integer i=0; 

    for(Booking_Information__c b: Trigger.New) {
        system.debug('@@@@@@@@@@@@@@'+b.Sales_Person__c);
        if(b.Sales_Person__c != NULL){
            system.debug('@@@@@@@@@@@@@@inside'+b.Sales_Person__c);
            userIds.add(b.Sales_Person__c);
        }
    }
    system.debug('@@@@@@@@@@@@@@userIds'+userIds);
    Map<Id,User> userNameMap = new Map<Id,User>([select id,Name from User where id IN:userIds]);

    system.debug('@@@@@@@@@@@@@@userNameMap '+userNameMap);
    for(Booking_Information__c b: Trigger.New) {
        system.debug('@@@@@@@@@@@@@@userNameMap.get(b.Sales_Person__c)'+userNameMap.get(b.Sales_Person__c));
        if(b.Name_Of_Opportunity__c != NULL)
        {
             opp_id.add(b.Name_Of_Opportunity__c);
        }
        flat_id.add(b.Unique_booking_Id__c);
        if(b.Booking_Status__c == 'BOOKING') {
            if(userNameMap.get(b.Sales_Person__c) != NULL){
                SM_name_Map.put(b.id, userNameMap.get(b.Sales_Person__c).Name);
            }
            else{
                 if(test.isrunningtest()==false){ trigger.new[i].adderror('Sales person is not mentioned'); }
            }
        }
      i++;
    }

    Flat_details = new Map<Id, Flat__c>([Select Id, Name, Flat_Type__r.Name, Wing__c, Wing__r.Name, Wing__r.Project__c,View__c, Token_Amount_Rs__c,
                Wing__r.Cluster_hidden__c, Status__c, Stage_Completed__c, Salable_Area__c, Amount_Due_Rs__c, Floor__c,
                Flat_No__c, Oasys_Flat_code__c , Carpet_Area__c From Flat__c Where Id IN : flat_id]); 

    opp_Update_Map = new Map<Id, Opportunity>([select closedate, StageName, Reasons_for_lost__c ,Is_Booking_Cancelled__c, Id, OASYS_Status__c,Name, LeadSource ,A_Applicable_Waiver__c, A_Base_Rate__c,
                          A_Consideration__c,fame_status__c, A_Flat_Cost__c, A_Floor_Rise__c, A_Infrastructure__c,
                          Applicable_Waiver__c, Application_Date__c, A_Premium__c, A_Total_rate__c,
                          Base_Rate__c,Welcome_Call_Return_Date__c,Welcome_Call_Return_Remarks__c , Booked_by_SM__c, Booking_Source__c, Carpet_Area__c, Cluster_Name__c,
                          Confirmation_Date__c, Consideration__c, Contact_Number__c, Total_Consideration_Value__c,
                          CRN__c,Customer_Type__c, Booking_Date__c, Date_Of_Cancellation__c, Date_of_Visit__c,
                          Email__c, Flat_Cost__c, Flat_No__c, ProductType__c, Floor__c, Floor_Rise__c,
                          Infrastructure__c, Parking_2W__c, Parking_4W__c, Parking_Type__c, Premium__c,
                          Premium_View__c, Reason_for_Cancellation__c, Saleable_Area__c, Special_Offer__c,
                          Stage__c, Submit_Date__c, Total_Rate__c, Wing__c 
                          from Opportunity where Id IN : opp_id]);
 
 
     for(Booking_Information__c booking: Trigger.New) {
         if(!opp_Update_Map.isEmpty()){
            if(opp_Update_Map.get(booking.Name_Of_Opportunity__c) != NULL)
            {
                opp_Update_Map.get(booking.Name_Of_Opportunity__c).A_Applicable_Waiver__c = String.ValueOf(booking.Applicable_Waiver_Sq_ft_Actual_Rs__c);
                opp_Update_Map.get(booking.Name_Of_Opportunity__c).Applicable_Waiver__c = String.ValueOf(booking.Applicable_Waiver_Sq_ft_Rs__c);
                opp_Update_Map.get(booking.Name_Of_Opportunity__c).A_Base_Rate__c = String.ValueOf(booking.Base_Rate_Sq_ft_Actual_Rs__c);
                opp_Update_Map.get(booking.Name_Of_Opportunity__c).Base_Rate__c = booking.Base_Rate_Sq_ft_Rs__c;
                opp_Update_Map.get(booking.Name_Of_Opportunity__c).A_Consideration__c = booking.Consideration_Actual_Rs__c;
                opp_Update_Map.get(booking.Name_Of_Opportunity__c).Amount = booking.Consideration_Actual_Rs__c;
                if(SM_name_Map.containsKey(booking.Id)){
                    opp_Update_Map.get(booking.Name_Of_Opportunity__c).Booked_by_SM__c= SM_name_Map.get(booking.Id);
                }
                opp_Update_Map.get(booking.Name_Of_Opportunity__c).Consideration__c = booking.Consideration_Rs__c;
                opp_Update_Map.get(booking.Name_Of_Opportunity__c).A_Flat_Cost__c = booking.Flat_Cost_Actual_Rs__c;
                opp_Update_Map.get(booking.Name_Of_Opportunity__c).Flat_Cost__c = booking.flat_cost_rs__c;
                opp_Update_Map.get(booking.Name_Of_Opportunity__c).A_Floor_Rise__c = booking.Floor_rise_Sq_ft_Actual_Rs__c;
                opp_Update_Map.get(booking.Name_Of_Opportunity__c).Floor_Rise__c = booking.Floor_rise_Sq_ft_Rs__c;
                opp_Update_Map.get(booking.Name_Of_Opportunity__c).A_Total_rate__c = booking.Total_Rate_Sq_ft_Actual_Rs__c;
                opp_Update_Map.get(booking.Name_Of_Opportunity__c).Total_Rate__c = booking.Total_Rate_Sq_ft_Rs__c;
                opp_Update_Map.get(booking.Name_Of_Opportunity__c).A_Infrastructure__c = booking.Infrastructure_Cost_Actual_Rs__c;
                opp_Update_Map.get(booking.Name_Of_Opportunity__c).Infrastructure__c = booking.Infrastructure_Cost_Rs__c;
                opp_Update_Map.get(booking.Name_Of_Opportunity__c).A_Premium__c = booking.Premium_Sq_ft_Actual_Rs__c;
                opp_Update_Map.get(booking.Name_Of_Opportunity__c).Premium__c = String.ValueOf(booking.Premium_Sq_ft_Rs__c);
                opp_Update_Map.get(booking.Name_Of_Opportunity__c).Parking_2W__c = String.ValueOf(booking.Parking_Nos_2w__c);
                opp_Update_Map.get(booking.Name_Of_Opportunity__c).Parking_4W__c = String.ValueOf(booking.Parking_Nos_4w__c);
                opp_Update_Map.get(booking.Name_Of_Opportunity__c).Parking_Type__c = booking.Parking_Type__c;
                opp_Update_Map.get(booking.Name_Of_Opportunity__c).Application_Date__c = booking.Application_Date__c;
                opp_Update_Map.get(booking.Name_Of_Opportunity__c).Booking_Source__c = booking.Booking_By__c;
                opp_Update_Map.get(booking.Name_Of_Opportunity__c).Confirmation_Date__c = booking.Confirmation_Date__c;
                opp_Update_Map.get(booking.Name_Of_Opportunity__c).Contact_Number__c = booking.Contact_Nos__c;
                opp_Update_Map.get(booking.Name_Of_Opportunity__c).CRN__c = booking.CRN__c;
                opp_Update_Map.get(booking.Name_Of_Opportunity__c).Customer_Type__c = booking.Customer_Type__c;
                opp_Update_Map.get(booking.Name_Of_Opportunity__c).Booking_Date__c = booking.Booking_Date__c;
                opp_Update_Map.get(booking.Name_Of_Opportunity__c).Submit_Date__c = booking.Submit_Date__c;
                if(booking.Booking_By__c == 'Channel Partner'){            
                    opp_Update_Map.get(booking.Name_Of_Opportunity__c).Booking_Channel_Partner__c = booking.Reap_Id__c;
               }
               else{
                   opp_Update_Map.get(booking.Name_Of_Opportunity__c).Booking_Channel_Partner__c = null;
               }
               if(booking.Booking_By__c == 'referral' || booking.Booking_By__c == 'self-referral'){
                  opp_Update_Map.get(booking.Name_Of_Opportunity__c).LoyaltySourceId__c = booking.Loyalty_Source_Id__c;
               }
               else {
                   opp_Update_Map.get(booking.Name_Of_Opportunity__c).LoyaltySourceId__c = null;
               }
               /*
               if(booking.Customer_Type__c == 'Corporate'){
                   opp_Update_Map.get(booking.Name_Of_Opportunity__c).Corporate_Account__c = booking.Corporate_connection__c;
               }*/
               //opp_Update_Map.get(booking.Name_Of_Opportunity__c).Date_of_Visit__c = booking.Date_of_First_Visit__c;
               //opp_Update_Map.get(booking.Name_Of_Opportunity__c).Visit_Form_No__c = booking.Visitor_Form_No__c;
               opp_Update_Map.get(booking.Name_Of_Opportunity__c).LoyaltyID__c = booking.Loyalty_Id__c;

                // Flat Information Stored in Opportunity
                if(!Flat_details.isEmpty()){
                    opp_Update_Map.get(booking.Name_Of_Opportunity__c).Carpet_Area__c = Flat_details.get(booking.Unique_booking_Id__c).Carpet_Area__c;
                    opp_Update_Map.get(booking.Name_Of_Opportunity__c).Wing__c = Flat_details.get(booking.Unique_booking_Id__c).Wing__r.Name;
                    opp_Update_Map.get(booking.Name_Of_Opportunity__c).Stage__c = Flat_details.get(booking.Unique_booking_Id__c).Stage_Completed__c;
                    opp_Update_Map.get(booking.Name_Of_Opportunity__c).Saleable_Area__c = Flat_details.get(booking.Unique_booking_Id__c).Salable_Area__c;
                    opp_Update_Map.get(booking.Name_Of_Opportunity__c).Floor__c = String.valueOf(Flat_details.get(booking.Unique_booking_Id__c).Floor__c);
                    opp_Update_Map.get(booking.Name_Of_Opportunity__c).Premium_View__c= Flat_details.get(booking.Unique_booking_Id__c).View__c;
                    opp_Update_Map.get(booking.Name_Of_Opportunity__c).Flat_No__c = String.valueOf(Flat_details.get(booking.Unique_booking_Id__c).Flat_No__c);
                    opp_Update_Map.get(booking.Name_Of_Opportunity__c).ProductType__c = Flat_details.get(booking.Unique_booking_Id__c).Flat_Type__r.Name;
                    opp_Update_Map.get(booking.Name_Of_Opportunity__c).Cluster_Bldg_No__c = Flat_details.get(booking.Unique_booking_Id__c).Wing__r.Cluster_hidden__c;  
                    opp_Update_Map.get(booking.Name_Of_Opportunity__c).Oasys_Flat_Code__c = Flat_details.get(booking.Unique_booking_Id__c).Oasys_Flat_code__c;
                    system.debug('!!!!cancel'+booking.Booking_Status__c+'-'+booking.Cancellation_Type__c+'-'+booking.Is_the_customer_registered__c+'-'+booking.has_the_customer_initiated_deed_of_cance__c+'-'+booking.Confirmation_Remark__c+'-'+booking.Has_retention_efforts_been_carried_out__c+'-'+booking.Result_of_retention_efforts__c+'-'+booking.Cancel_Confirm_Date__c+'-'+booking.Approval_sought__c+'-'+booking.Approver_s_name__c+'-'+booking.Reason_for_Cancellation__c+'-'+booking.Cancellation_Date__c);
         
                    if(booking.Booking_Status__c == 'CANCELLATION' && booking.Cancellation_Type__c !=null && booking.Is_the_customer_registered__c != null && ((booking.Is_the_customer_registered__c == 'Yes' && booking.has_the_customer_initiated_deed_of_cance__c!=null) || (booking.Is_the_customer_registered__c == 'No' && booking.has_the_customer_initiated_deed_of_cance__c==null)) && ((booking.has_the_customer_initiated_deed_of_cance__c=='Yes' && (booking.Confirmation_Remark__c != null || booking.Confirmation_Remark__c == null)) || (booking.has_the_customer_initiated_deed_of_cance__c=='No' && booking.Confirmation_Remark__c != null) || booking.Is_the_customer_registered__c == 'No' ) && booking.Has_retention_efforts_been_carried_out__c!=null && ((booking.Has_retention_efforts_been_carried_out__c=='Yes' && booking.Result_of_retention_efforts__c !=null) || (booking.Has_retention_efforts_been_carried_out__c=='No' && booking.Result_of_retention_efforts__c ==null)) && ((booking.Result_of_retention_efforts__c == 'Positive' && booking.Cancel_Confirm_Date__c!=null) || (booking.Result_of_retention_efforts__c != 'Positive' && booking.Cancel_Confirm_Date__c==null)) && booking.Approval_sought__c != null && ((booking.Approval_sought__c == 'Yes' && booking.Approver_s_name__c !=null) || (booking.Approval_sought__c == 'No' && booking.Approver_s_name__c ==null)) && booking.Reason_for_Cancellation__c !=null)  {      
                        system.debug('!!!!!!!!!!cancel sap');
                        cancel=false;
                        opp_Update_Map.get(booking.Name_Of_Opportunity__c).Flat_No__c = '';
                        opp_Update_Map.get(booking.Name_Of_Opportunity__c).Oasys_Flat_Code__c = '';
                        opp_Update_Map.get(booking.Name_Of_Opportunity__c).Is_Booking_Cancelled__c = TRUE;
             
                        if(booking.Result_of_retention_efforts__c == 'Positive' && booking.Cancel_Confirm_Date__c!=null){
                            opp_Update_Map.get(booking.Name_Of_Opportunity__c).Date_Of_Cancellation__c =  booking.Cancel_Confirm_Date__c;
                        }            
                        else{
                           opp_Update_Map.get(booking.Name_Of_Opportunity__c).Date_Of_Cancellation__c =  booking.Cancellation_Date__c;
                        }
              
                        opp_Update_Map.get(booking.Name_Of_Opportunity__c).Reason_for_Cancellation__c =  booking.Reason_for_Cancellation__c;      
                    }
                    else if(booking.Booking_Status__c == 'CANCELLATION' && booking.Confirmation_Remark__c != null && booking.Cancel_Confirm_Date__c!= null){
                        system.debug('!!!!!!!!!!normal cancellll');
                        cancel=true;
                        opp_Update_Map.get(booking.Name_Of_Opportunity__c).Flat_No__c = '';
                        opp_Update_Map.get(booking.Name_Of_Opportunity__c).Oasys_Flat_Code__c = '';
                        opp_Update_Map.get(booking.Name_Of_Opportunity__c).Is_Booking_Cancelled__c = TRUE;
                        opp_Update_Map.get(booking.Name_Of_Opportunity__c).Date_Of_Cancellation__c =  booking.Cancel_Confirm_Date__c;
                        opp_Update_Map.get(booking.Name_Of_Opportunity__c).Reason_for_Cancellation__c =  booking.Reason_for_Cancellation__c;   
                    }
                    else {
                        system.debug('!!!!!!!!!!not cancelll');
                        opp_Update_Map.get(booking.Name_Of_Opportunity__c).Is_Booking_Cancelled__c = FALSE;
                        opp_Update_Map.get(booking.Name_Of_Opportunity__c).Date_Of_Cancellation__c = null;
                        opp_Update_Map.get(booking.Name_Of_Opportunity__c).Reason_for_Cancellation__c =  null;
                        opp_Update_Map.get(booking.Name_Of_Opportunity__c).FAME_Return_Date__c =  null;
                        opp_Update_Map.get(booking.Name_Of_Opportunity__c).FAME_Return_Remarks__c =  null;
                   } 
         
                   opp_Update_Map.get(booking.Name_Of_Opportunity__c).OASYS_Status__c = booking.Booking_Status__c;


                   /*if(opp_Update_Map.get(booking.Name_Of_Opportunity__c).OASYS_Status__c == 'BLOCKED' || opp_Update_Map.get(booking.Name_Of_Opportunity__c).OASYS_Status__c == 'BOOKING' || opp_Update_Map.get(booking.Name_Of_Opportunity__c).OASYS_Status__c == 'SCUD') {
                        opp_Update_Map.get(booking.Name_Of_Opportunity__c).StageName = 'Definite Closure';
                        opp_Update_Map.get(booking.Name_Of_Opportunity__c).Reasons_for_lost__c = null;
                    }*/
                    if(opp_Update_Map.get(booking.Name_Of_Opportunity__c).OASYS_Status__c == 'BLOCKED' || ( opp_Update_Map.get(booking.Name_Of_Opportunity__c).OASYS_Status__c == 'BOOKING' && opp_Update_Map.get(booking.Name_Of_Opportunity__c).Reasons_for_lost__c != 'Welcome Call Reject' ) || opp_Update_Map.get(booking.Name_Of_Opportunity__c).OASYS_Status__c == 'SCUD') {
                        opp_Update_Map.get(booking.Name_Of_Opportunity__c).StageName = 'Definite Closure';
                        opp_Update_Map.get(booking.Name_Of_Opportunity__c).Reasons_for_lost__c = null;
                    }
                    else if(opp_Update_Map.get(booking.Name_Of_Opportunity__c).OASYS_Status__c == 'BOOKED'){
                        opp_Update_Map.get(booking.Name_Of_Opportunity__c).StageName = 'Closed Book';
                       opp_Update_Map.get(booking.Name_Of_Opportunity__c).Reasons_for_lost__c = null;
                    }
                    else if(opp_Update_Map.get(booking.Name_Of_Opportunity__c).OASYS_Status__c == 'FAME RETURN'){
                        opp_Update_Map.get(booking.Name_Of_Opportunity__c).StageName = 'Closed Lost';
                        opp_Update_Map.get(booking.Name_Of_Opportunity__c).Reasons_for_lost__c = 'FAME Return';
                    }
                    else if(opp_Update_Map.get(booking.Name_Of_Opportunity__c).OASYS_Status__c == 'SCUD REJECT'){
                        opp_Update_Map.get(booking.Name_Of_Opportunity__c).StageName = 'Closed Lost';
                        opp_Update_Map.get(booking.Name_Of_Opportunity__c).Reasons_for_lost__c = 'SCUD Reject';
                    }
                    else if(opp_Update_Map.get(booking.Name_Of_Opportunity__c).OASYS_Status__c == 'CANCELLATION' && cancel==true){
                        system.debug('!!!!!!!!normal cancel'+cancel);
                        opp_Update_Map.get(booking.Name_Of_Opportunity__c).StageName = 'Cancelled';
                        opp_Update_Map.get(booking.Name_Of_Opportunity__c).Reasons_for_lost__c = null;
                    }
                    else if(opp_Update_Map.get(booking.Name_Of_Opportunity__c).OASYS_Status__c == 'CANCELLATION' && cancel==false){
                        system.debug('!!!!!!!!SAP cancel'+cancel);
                        //opp_Update_Map.get(booking.Name_Of_Opportunity__c).StageName = 'Closed Lost';
                        opp_Update_Map.get(booking.Name_Of_Opportunity__c).StageName = 'Cancelled';
                        opp_Update_Map.get(booking.Name_Of_Opportunity__c).Reasons_for_lost__c = null;
                    }
                    else if(opp_Update_Map.get(booking.Name_Of_Opportunity__c).OASYS_Status__c == 'SOLD'){
                        opp_Update_Map.get(booking.Name_Of_Opportunity__c).StageName = 'Closed Won';
                         opp_Update_Map.get(booking.Name_Of_Opportunity__c).Reasons_for_lost__c = null;
                    }
                    else if(opp_Update_Map.get(booking.Name_Of_Opportunity__c).OASYS_Status__c == 'WELCOME CALL PENDING'){
                        opp_Update_Map.get(booking.Name_Of_Opportunity__c).fame_status__c='';
                    }        
                    //new added for removing related work flow.
                    else if(opp_Update_Map.get(booking.Name_Of_Opportunity__c).OASYS_Status__c == 'OPEN'){
                        opp_Update_Map.get(booking.Name_Of_Opportunity__c).StageName = 'Closed Lost';
                        opp_Update_Map.get(booking.Name_Of_Opportunity__c).Oasys_Flat_Code__c = '';
                    }
                }
            }
        }
    }
 
    if(opp_Update_Map.size() > 0){
        //update opp_Update_Map.Values();
        try {
            update opp_Update_Map.Values();
        }catch(DMLException e) {
            system.debug('Upsert failed ' + e.getMessage());
        }
    }
}