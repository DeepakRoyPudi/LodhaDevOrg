public class SpBookInventory{

public boolean price_edit_disabled{get;set;}
public boolean rep_id_display_visible{get;set;}
public boolean corp_display_visible{get;set;}
public boolean block_disabled{get;set;}
public boolean booking_edit_disabled{get;set;}
public boolean booking_cancel_disabled{get;set;}
public boolean ref_crn_display_visible{get;set;}

public final Booking_Information__c booking{get;set;}
public List<Booking_Information__c> bookinglist{get;set;}
public Project_Name__c projdet{get;set;}

public FAME__C fame{get;set;}
public final Opportunity opp{get;set;}

public string BlockForDays{get;set;}
public string BlockForMinute{get;set;}
public String flat_Id{get;set;}
public String selectedstatus{get;set;}

public String Dummystatus{get;set;}

public String selectedholdstatus{get;set;}
public String selectedcustomertype{get;set;}
public String selectedbookingbyvalue{get;set;}
public String selectedparkingtypevalue{get;set;}
public Id selected_block_sales_personId{get;set;}
public Id selected_booking_sales_personId{get;set;}
public Id wid{get;set;}
public Id opp_id{get;set;}
public Id PI_id{get;set;}

public String flattype{get;set;}
public String viewtype{get;set;}
public Decimal saleablearea{get;set;}
public Decimal carpetarea{get;set;}
public String stage_completed{get;set;}
public decimal token_amt{get;set;}
public decimal amt_due{get;set;}
public List<Flat__c> FlatPriceDetails{get;set;}

public PageReference updateStatus{get;set;}
public PageReference toggledisplay{get;set;}
public PageReference corpToggleDisplay{get;set;}

public PageReference inf_consideration_amt{get;set;}
public PageReference inf2_consideration_amt{get;set;}
public PageReference clb_consideration_amt{get;set;}
public PageReference calc_offer_amt{get;set;}
public PageReference calc_corp_discount{get;set;}

public PageReference generate_payment_plan{get;set;}
public String stage_desc{get;set;}

public String cluster_name{get;set;}
public String pi_name {get;set;}
public String discount_type{get;set;}
public String flat_no{get;set;}
public String wing_Name;
public decimal old_total_rate;
public String oasys_flat_code{get;set;}
public boolean isSaved {get; set;}
public boolean isSCUDCreated {get; set;}
public String beforeStatus {get; set;}
public boolean view_mode{get; set;}
public String role_name{get;set;}
public String profile_name{get;set;}

public boolean block_sales_person_visible{get;set;}
public boolean output_block_sales_person_visible{get;set;}
public boolean sales_person_visible{get;set;}
public boolean output_sales_person_visible{get;set;}
public boolean corp_disable{get;set;}
public boolean output_rep_id_visible{get;set;}
public boolean cancel_date_disable{get;set;}

public Opportunity accountLookup { get; set; }


public List<selectoption> getDummyStatusLst(){
    List<selectoption> Lst=new List<selectoption>();
    Lst.add(new selectoption('OPEN','OPEN'));
    Lst.add(new selectoption('BLOCKED','BLOCKED'));
    Lst.add(new selectoption('BOOKING','BOOKING'));
    Lst.add(new selectoption('CANCELLATION','CANCELLATION'));
    Lst.add(new selectoption('SCUD','SCUD'));
    Lst.add(new selectoption('SOLD','SOLD'));
    Lst.add(new selectoption('BOOKED','BOOKED'));
    Lst.add(new selectoption('SCUD REJECT','SCUD REJECT'));
    Lst.add(new selectoption('FAME RETURN','FAME RETURN'));
    return Lst;
}

public SpBookInventory() {
  Id role_id = UserInfo.getUserRoleId();
  UserRole role = [select Name from UserRole where Id=: UserInfo.getUserRoleId()];
  role_name = role.Name; // booking = new Booking_Information__c();
  profile_name = [Select Id, Name From Profile where Id=:UserInfo.getProfileId()].Name; 
  
  flat_Id = ApexPages.currentPage().getParameters().get('fid');
  opp_id = ApexPages.currentPage().getParameters().get('oppid');
  
  //Starts Here -Added by kumki for BUG fix in Sprint 1 
  string proj = ApexPages.currentPage().getParameters().get('proj');
  if(proj != null){
        system.debug('!!!!!bid11'+proj);
        pagereference s=new pagereference('/apex/SpSearchInventory?oppid='+opp_id+'&proj='+proj);
        String flatstatus=[select id,Status__c from Flat__c where id=:flat_Id].Status__c;
        system.debug('!!!!!bid'+flatstatus);
        if(flatstatus!='OPEN'){           
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'This flat is already in Booking Process linked to some other Opportunity. Please close this page and choose a flat with OPEN status for your current Opportunity'));
        }
   } 
  //Ends Here
  flattype = null;
  viewtype = null;
  stage_completed = null;
  selectedholdstatus = null;
  discount_type = null;
  isSaved = False;
  isSCUDCreated  = True;
  
  String objectName = 'Booking_Information__c';  // modify as needed
  String query = 'SELECT';
  Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
 
  // Grab the fields from the describe method and append them to the queryString one by one.
  for(String s : objectFields.keySet()) {
     if(s == 'Block_Sales_Person__c')
     {
         s = s + ', Block_Sales_Person__r.Email';
     }
    
     query += ' ' + s + ', ';
  }

  // Strip off the last comma if it exists.
  query = query.removeEnd(', ');

  // Add FROM statement
  query += ' FROM ' + objectName;
 
  // Add on a WHERE/ORDER/LIMIT statement as needed
  query += ' WHERE Flat__c = \''+ flat_Id + '\' AND InActive__c = FALSE'; // modify as needed 
  try{
    bookinglist = database.query(query);
  }catch(DMLException e) {
    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Invalid Flat Id or Inactive Booking Detail.'));
  }

  if(bookinglist.size() == 0){
    booking = new Booking_Information__c();
    booking.Booking_Status__c = 'OPEN';
    Dummystatus='OPEN';
  }
  else if(bookinglist.size() > 0) {
    booking = bookinglist.get(0);
    selectedstatus = booking.Booking_Status__c;    
    Dummystatus=booking.Booking_Status__c;
  }
  //discount_type = booking.Selected_discount_type__c;
  beforeStatus = booking.Booking_Status__c;  
  projdet = new Project_Name__c();
  
  getFlatDetails(flat_Id);
 
  price_edit_disabled = true;
  block_disabled = true;
  booking_edit_disabled = true;
  booking_cancel_disabled = true; 
  rep_id_display_visible = false;
  ref_crn_display_visible = false;
  corp_display_visible = false;
  block_sales_person_visible = false;
  output_block_sales_person_visible = false;
  output_sales_person_visible = false; 
  sales_person_visible = false;
  output_rep_id_visible = false;
  cancel_date_disable = true;
  if(booking.Customer_Type__c == 'Corporate') {
    corp_disable = false;
  }
  else {
    corp_disable = true;
  }
  if(booking.Confirmation_Remark__c == null && booking.Cancel_Confirm_Date__c == null && booking.Booking_Status__c == 'CANCELLATION'){
     booking_cancel_disabled = false;
  }
  
  getOpportunityDetails();
  //logic to calculate stage amount due display
  List<Stage_Details__c> stgdet = [select Actual_Completion_Date__c ,Name,Expected_Completion_Date__c,Description__c,Slab__c, Wing__c, Amount__c from Stage_Details__c where Wing__c =:wid Order By CreatedDate ASC ];
  decimal k;
  decimal sum = 0;
  for(Stage_Details__c s: stgdet) {
    if(s.Actual_Completion_Date__c != null) {   
      if(booking.Consideration_Actual_Rs__c != null) {
        k = (booking.Consideration_Actual_Rs__c * s.Slab__c)/100;
      }
      else {
        k = (booking.Consideration_Rs__c * s.Slab__c)/100;
      }    
      s.Amount__c = math.round(k);
      sum = sum + s.Amount__c;
      stage_completed = s.Description__c;      
    }
  }
  amt_due = sum;
  
  if(booking.Booking_By__c == 'referral' || booking.Booking_By__c == 'self-referral') {
     ref_crn_display_visible = true;
  }
  else if(booking.Booking_By__c == 'Channel Partner') {
    rep_id_display_visible = true;
  }
}


//function to open a window that shows payment plan pdf
public PageReference generate_payment_plan() {
  PageReference pr = new PageReference('/apex/SpPaymentPlanGenerate'); 
  pr.getParameters().put('wid',wid); 
  pr.getParameters().put('cost',String.ValueOf(booking.Consideration_Actual_Rs__c));
  pr.getParameters().put('fid',flat_Id);
  pr.setRedirect(true);               
  return pr;
}

//function to open a window that shows payment plan pdf
public PageReference generate_bdf_form() {
  PageReference pr = new PageReference('/apex/SpBDFGenerate'); 
  pr.getParameters().put('wid',wid); 
  pr.getParameters().put('fid',flat_Id);
  pr.setRedirect(true);               
  return pr;
}


//function to open a scud window
public PageReference open_scud_window() {
  save();
  if(isSCUDCreated && isSaved)
  {
      PageReference pr = new PageReference('/apex/SpScudApproval'); 
      pr.getParameters().put('bid',booking.Id); 
      pr.setRedirect(true);               
      return pr;
  }
  else
  {
  return null;
  }
}


//to get referral CRN
public PageReference getReferralCrn() {
 /* if(booking.Booking_By__c == 'referral') {
    Opportunity o = [Select LoyaltySourceId__c from Opportunity Where Id =: opp_id limit 1];
    booking.Loyalty_Source_Id__c = o.LoyaltySourceId__c;
    Account acc = [select CRN__c From Account Where LoyaltyID__c =: booking.Loyalty_Source_Id__c and RecordType.Name='Booked Account' limit 1];
    booking.Referral_CRN__c = acc.CRN__c;
  }
  if(booking.Booking_By__c == 'self-referral') {
    Opportunity o = [Select LoyaltyID__c from Opportunity Where Id =: opp_id limit 1];
    booking.Loyalty_Source_Id__c = o.LoyaltyID__c;
    Account acc = [select CRN__c From Account Where LoyaltyID__c =: booking.Loyalty_Source_Id__c and RecordType.Name='Booked Account' limit 1];
    booking.Referral_CRN__c = acc.CRN__c;
  }*/
  List<Account> acc = [select LoyaltyID__c From Account Where CRN__c =: booking.Referral_CRN__c and RecordType.Name='Booked Account' limit 1];
  if(acc.size() > 0)
      booking.Loyalty_Source_Id__c = acc[0].LoyaltyID__c;
      
  return null;
}  


//function to toggle visibility function of booking by
public PageReference toggledisplay() {
  booking.Loyalty_Source_Id__c = null;
  booking.Referral_CRN__c = null;
  booking.Reap_Id__c = null;
  if(booking.Booking_By__c == 'Channel Partner') {
    rep_id_display_visible = true;
    ref_crn_display_visible = false;
    booking.Loyalty_Source_Id__c = null;
    booking.Referral_CRN__c = null;
  }
  else if(booking.Booking_By__c == 'referral' || booking.Booking_By__c == 'self-referral') {
    rep_id_display_visible = false;
    ref_crn_display_visible = true;
    getReferralCrn();
    booking.Reap_Id__c = null;
  }
  else {
    ref_crn_display_visible = false;
    rep_id_display_visible = false;
  }
  return null;
}

public PageReference corpToggleDisplay() {
  booking.Applicable_Waiver_Sq_ft_Actual_Rs__c = 0; 
  adjust_total_rate();
  if(booking.Customer_Type__c == 'Corporate') {
    corp_disable = false; 
    booking.Corporate_connection__c = null;
  }
  else if(booking.Customer_Type__c == 'Armed Forces Personnel') {
    corp_display_visible = false;
    calc_waiver_amt(Integer.valueof(projdet.Armed_Personnel_Discount__c)); 
    corp_disable = true;
    booking.Corporate_connection__c = null;
  }
  else if(booking.Customer_Type__c == 'Employee') {
    corp_display_visible = false;
    calc_waiver_amt(Integer.valueof(projdet.Employee_Discount__c)); 
    booking.Corporate_connection__c = null;
    corp_disable = true;
  }
  else if(booking.Customer_Type__c == 'Physically challenged') {
    corp_display_visible = false; 
    calc_waiver_amt(Integer.valueof(projdet.Physically_Disabled_Discount__c));
    booking.Corporate_connection__c = null;
    corp_disable = true;
  }
  else {
   booking.Applicable_Waiver_Sq_ft_Actual_Rs__c = 0;
   corp_display_visible = false;
   booking.Corporate_connection__c = null;
   corp_disable = true;
  }
  return null;
}

public PageReference adjust_dam_amt() {
  if(booking.DAM_Offer_Sq_ft_Actual_Rs__c > projdet.DAM_Limit__c && booking.Selected_discount_type__c != 'SCUD' && booking.Selected_discount_type__c == 'DAM') {
    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'DAM value cannot be greater than specified DAM limit.'));
  }
  else if(booking.DAM_Offer_Sq_ft_Actual_Rs__c > projdet.Special_Offer__c && booking.Selected_discount_type__c != 'SCUD' && booking.Selected_discount_type__c == 'Sp_offer') {
    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Special offer value cannot be greater than specified Special offer limit.'));
  }
  
  if(booking.Selected_discount_type__c == 'SCUD') {
    //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'DAM value cannot be greater than specified DAM limit.'));
    booking.Selected_discount_type__c = 'SCUD';
    adjust_total_rate();
  }    
  else {
    booking.Selected_discount_type__c = booking.Selected_discount_type__c;
    adjust_total_rate();
  }
   
  return null;
}

public void adjust_total_rate() {
  if(booking.Customer_Type__c == 'General' || booking.Customer_Type__c == null) {
    booking.Applicable_Waiver_Sq_ft_Actual_Rs__c = 0; 
  }

  booking.Total_Rate_Sq_ft_Actual_Rs__c = booking.Base_Rate_Sq_ft_Actual_Rs__c + booking.Floor_rise_Sq_ft_Actual_Rs__c + booking.Premium_Sq_ft_Actual_Rs__c  - (booking.Applicable_Waiver_Sq_ft_Actual_Rs__c + booking.DAM_Offer_Sq_ft_Actual_Rs__c);
  booking.Flat_Cost_Actual_Rs__c =  booking.Total_Rate_Sq_ft_Actual_Rs__c * saleablearea;
  adjust_infra_cv();
}

public PageReference calc_offer_amt() {
  
  if(booking.Selected_discount_type__c == 'DAM') {
  
    booking.DAM_Offer_Sq_ft_Actual_Rs__c = Integer.valueof(projdet.DAM_Limit__c);
    booking.Total_Rate_Sq_ft_Actual_Rs__c = booking.Total_Rate_Sq_ft_Rs__c - (booking.DAM_Offer_Sq_ft_Actual_Rs__c + booking.Applicable_Waiver_Sq_ft_Actual_Rs__c);
    //booking.Total_Rate_Sq_ft_Rs__c = booking.Total_Rate_Sq_ft_Actual_Rs__c;
    booking.Flat_Cost_Actual_Rs__c =  booking.Total_Rate_Sq_ft_Actual_Rs__c * saleablearea;
    //booking.Flat_Cost_Rs__c =  booking.Flat_Cost_Actual_Rs__c;
    booking.Consideration_Actual_Rs__c = booking.Flat_Cost_Actual_Rs__c + booking.Infrastructure_Cost_Rs__c;
    //booking.Consideration_Rs__c = booking.Consideration_Actual_Rs__c;
    booking.Booking_Status__c = 'BOOKING';
    Dummystatus='BOOKING';
    adjust_infra_cv();
  }
  else if(booking.Selected_discount_type__c == 'Sp_offer') {
    booking.DAM_Offer_Sq_ft_Actual_Rs__c = Integer.valueof(projdet.Special_Offer__c);
    booking.Total_Rate_Sq_ft_Actual_Rs__c = booking.Total_Rate_Sq_ft_Rs__c - (booking.DAM_Offer_Sq_ft_Actual_Rs__c + booking.Applicable_Waiver_Sq_ft_Actual_Rs__c);
    //booking.Total_Rate_Sq_ft_Rs__c = booking.Total_Rate_Sq_ft_Actual_Rs__c;
    booking.Flat_Cost_Actual_Rs__c =  booking.Total_Rate_Sq_ft_Actual_Rs__c * saleablearea;
    //booking.Flat_Cost_Rs__c = booking.Flat_Cost_Actual_Rs__c;
    booking.Consideration_Actual_Rs__c= booking.Flat_Cost_Actual_Rs__c + booking.Infrastructure_Cost_Rs__c;
    //booking.Consideration_Rs__c = booking.Consideration_Actual_Rs__c;
    booking.Booking_Status__c = 'BOOKING';
    Dummystatus='BOOKING';
    adjust_infra_cv();
  }
  else if(booking.Selected_discount_type__c == 'SCUD')
  {
    //booking.DAM_Offer_Sq_ft_Actual_Rs__c = Integer.valueof(projdet.Special_Offer__c);
    booking.Total_Rate_Sq_ft_Actual_Rs__c = booking.Total_Rate_Sq_ft_Rs__c - (booking.DAM_Offer_Sq_ft_Actual_Rs__c + booking.Applicable_Waiver_Sq_ft_Actual_Rs__c);
    //booking.Total_Rate_Sq_ft_Rs__c = booking.Total_Rate_Sq_ft_Actual_Rs__c;
    booking.Flat_Cost_Actual_Rs__c =  booking.Total_Rate_Sq_ft_Actual_Rs__c * saleablearea;
    //booking.Flat_Cost_Rs__c = booking.Flat_Cost_Actual_Rs__c;
    booking.Consideration_Actual_Rs__c= booking.Flat_Cost_Actual_Rs__c + booking.Infrastructure_Cost_Rs__c;
    //booking.Consideration_Rs__c = booking.Consideration_Actual_Rs__c;
    booking.Booking_Status__c = 'SCUD';
    Dummystatus='SCUD';
    adjust_infra_cv();
  }
  
  old_total_rate = booking.Total_Rate_Sq_ft_Actual_Rs__c;
  return null;
}

public PageReference calc_corp_discount() {
 /* if(old_total_rate != booking.Total_Rate_Sq_ft_Actual_Rs__c) {
    adjust_total_rate();
  }*/
  if(booking.Corporate_connection__c != null){
      Corporate_connection__c corp = [select Applicable_Discount__c from Corporate_connection__c where Id=:booking.Corporate_connection__c Limit 1];
      calc_waiver_amt(Integer.valueof(corp.Applicable_Discount__c));
  }
  else{
      calc_waiver_amt(0);
  }
  //adjust_infra_cv();
  return null;
}


//function to calculate applicable waiver
public void calc_waiver_amt(Integer amt) { 
  booking.Applicable_Waiver_Sq_ft_Actual_Rs__c = amt;
  booking.Total_Rate_Sq_ft_Actual_Rs__c = booking.Total_Rate_Sq_ft_Rs__c - booking.Applicable_Waiver_Sq_ft_Actual_Rs__c;
  //booking.Total_Rate_Sq_ft_Rs__c = booking.Total_Rate_Sq_ft_Actual_Rs__c;
  booking.Flat_Cost_Actual_Rs__c =  booking.Total_Rate_Sq_ft_Actual_Rs__c * saleablearea;
  //booking.Flat_Cost_Rs__c = booking.Flat_Cost_Actual_Rs__c;
  //booking.Consideration_Actual_Rs__c= booking.Flat_Cost_Actual_Rs__c + booking.Infrastructure_Cost_Rs__c;
  //booking.Consideration_Rs__c = booking.Consideration_Actual_Rs__c;
  adjust_infra_cv();
}


//function to toggle display of various form blocks according to status
public PageReference updateStatus() {
  system.debug('@@@@@@@@@@@@@@@@@Status'+Dummystatus+booking.Booking_Status__c);
  booking.Booking_Status__c=Dummystatus;
  system.debug('@@@@@@@@@@@@@@@@@Status after assignment'+Dummystatus+booking.Booking_Status__c);
  if(booking.Booking_Status__c == 'BLOCKED') {
    block_disabled = false;
    price_edit_disabled = true;
    booking_edit_disabled  = true;
    booking_cancel_disabled = true;
    copyRateToActual();
    if(booking.Block_Sales_Person__c == null) {
      booking.Block_Sales_Person__c = UserInfo.getUserId();
    }
    booking.Block_For_Days__c = projdet.Max_Block_Days__c; 
    booking.Block_Date__c = date.today(); 
    booking.Block_For__c = opp_id;
    block_sales_person_visible = true;
    output_block_sales_person_visible = false;
    output_sales_person_visible = false; 
    sales_person_visible = false;
    output_rep_id_visible = true;
    rep_id_display_visible = false;
  }
  else if(booking.Booking_Status__c == 'BOOKING' || booking.Booking_Status__c == 'SCUD') {
    block_disabled = true;
    if(booking.Sales_Person__c == null) {
      booking.Sales_Person__c = UserInfo.getUserId();
    }
    price_edit_disabled = false;
    booking_edit_disabled  = false;
    booking_cancel_disabled = true;
    copyRateToActual();
    List<Booking_Information__c> tmpbooklist;
    if(booking.CRN__c == '' || booking.CRN__c == null){
      do {
        String crn_number = getCrnNumber(projdet.CRN_INIT__c);
        tmpbooklist = [select Id from Booking_Information__c Where CRN__c=:crn_number];
        booking.CRN__c=crn_number;
      }while(tmpbooklist.size() != 0);
    }
    block_sales_person_visible = false;
    output_block_sales_person_visible = true;
    output_sales_person_visible = false; 
    sales_person_visible = true;
    output_rep_id_visible = false;
     if(booking.Booking_By__c == 'Channel Partner') {
      rep_id_display_visible = true;
    }
  }
  else if(booking.Booking_Status__c == 'CANCELLATION') {
    booking_cancel_disabled = false;
    block_disabled = true;
    price_edit_disabled = true;
    booking_edit_disabled  = true;
    block_sales_person_visible = false;
    output_block_sales_person_visible = true;
    output_sales_person_visible = true; 
    sales_person_visible = false;  
    output_rep_id_visible = true;
    rep_id_display_visible = false;
    if(beforeStatus == 'SOLD') {
      cancel_date_disable = false;
    }
  }
  else {
    block_disabled = true;
    price_edit_disabled = true;
    booking_edit_disabled  = true;
    booking_cancel_disabled = true;
    block_sales_person_visible = false;
    output_block_sales_person_visible = true;
    output_sales_person_visible = true; 
    sales_person_visible = false;
    output_rep_id_visible = true;
    rep_id_display_visible = false;
  }
  
  return null;
}

public boolean get_access_permission_type() {
  String permission;
  SpAccessController spa = new SpAccessController();
  System.debug('-->role name:' + role_name);
  permission = spa.getBookingAccess(role_name, projdet.Id, beforeStatus, booking.Booking_Status__c);

  if(permission == 'View') {
    return true;
  }  
  else {
    return false;
  }
}



//save booking
public PageReference save() {
  boolean cancellationstatus=false;
  boolean cancel = FALSE;
  boolean booking_status = TRUE;
  
  System.debug('@@@status Dummystatus'+Dummystatus+booking.Booking_Status__c);
  booking.Booking_Status__c=Dummystatus;  
  
  view_mode = get_access_permission_type();
  if(role_name == 'Lodha Admin' || profile_name == 'System Administrator') {
    view_mode = false;
  } 
  if(view_mode == true) {   
    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Your role dont have permission to change the record.'));
    return null;
  }
  
  //Added for Transition for Booking Status.
   System.debug('@@@ Before status '+ beforeStatus+'@@ Current'+booking.Booking_Status__c );
    if(beforeStatus == 'OPEN' && (booking.Booking_Status__c == 'BOOKED' || booking.Booking_Status__c == 'SCUD REJECT' || booking.Booking_Status__c == 'CANCELLATION' || booking.Booking_Status__c == 'SOLD' || booking.Booking_Status__c == 'FAME RETURN' || booking.Booking_Status__c == 'SCUD'))
  {
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'This Status for OPEN is not allowed for Transition.'));
        return NULL;
  }else if(beforeStatus == 'BOOKED' && (booking.Booking_Status__c == 'OPEN' || booking.Booking_Status__c == 'BOOKING' || booking.Booking_Status__c == 'CANCELLATION' || booking.Booking_Status__c == 'SCUD' || booking.Booking_Status__c == 'SCUD REJECT' || booking.Booking_Status__c == 'BLOCKED'))
  {
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'This Status for BOOKED is not allowed for Transition.'));
        return NULL;
  }else if(beforeStatus == 'SCUD' && (booking.Booking_Status__c == 'OPEN' || booking.Booking_Status__c == 'BOOKED' || booking.Booking_Status__c == 'CANCELLATION' || booking.Booking_Status__c == 'SOLD' || booking.Booking_Status__c == 'BLOCKED' || booking.Booking_Status__c == 'FAME RETURN'))
  {
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'This Status for SCUD is not allowed for Transition.'));
        return NULL;
  } else if (beforeStatus == 'SOLD' && (booking.Booking_Status__c == 'OPEN' || booking.Booking_Status__c == 'BOOKING' || booking.Booking_Status__c == 'SCUD' || booking.Booking_Status__c == 'SCUD REJECT' || booking.Booking_Status__c == 'BOOKED' || booking.Booking_Status__c == 'BLOCKED' || booking.Booking_Status__c == 'FAME RETURN'))
  {
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'This Status for SOLD is not allowed for Transition.'));
        return NULL;
  } else if (beforeStatus == 'SCUD REJECT' && (booking.Booking_Status__c == 'BOOKING' || booking.Booking_Status__c == 'OPEN' || booking.Booking_Status__c == 'SOLD' || booking.Booking_Status__c == 'BOOKED' || booking.Booking_Status__c == 'BLOCKED' || booking.Booking_Status__c == 'FAME RETURN'))
  {
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'This Status for SCUD REJECTED is not allowed for Transition.'));
        return NULL;
  } else if (beforeStatus == 'FAME RETURN' && (booking.Booking_Status__c == 'OPEN' || booking.Booking_Status__c == 'SCUD' || booking.Booking_Status__c == 'SOLD' || booking.Booking_Status__c == 'SCUD REJECT' || booking.Booking_Status__c == 'BOOKED' || booking.Booking_Status__c == 'BLOCKED'))
  {
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'This Status for FAME RETURN is not allowed for Transition.'));
        return NULL;
  } else if (beforeStatus == 'BLOCKED' && (booking.Booking_Status__c == 'SCUD' || booking.Booking_Status__c == 'SOLD' || booking.Booking_Status__c == 'SCUD REJECT' || booking.Booking_Status__c == 'BOOKED' || booking.Booking_Status__c == 'FAME RETURN'))
  {
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'This Status for BLOCKED is not allowed for Transition.'));
        return NULL;
  } else if (beforeStatus == 'BOOKING' && (booking.Booking_Status__c == 'OPEN' || booking.Booking_Status__c == 'SOLD' || booking.Booking_Status__c == 'SCUD REJECT' || booking.Booking_Status__c == 'BLOCKED' || booking.Booking_Status__c == 'FAME RETURN'))
  {
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'This Status for BOOKING is not allowed for Transition.'));
        return NULL;
  }else if (beforeStatus == 'CANCELLATION' && (booking.Booking_Status__c == 'OPEN' || booking.Booking_Status__c == 'BOOKING' || booking.Booking_Status__c == 'BOOKED' || booking.Booking_Status__c == 'SCUD' || booking.Booking_Status__c == 'SOLD' || booking.Booking_Status__c == 'BLOCKED'))
  {
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'This Status for CANCELLATION is not allowed for Transition.'));
        return NULL;
  }
 
  if(beforeStatus == 'BOOKING' && booking.Booking_Status__c == 'BOOKED'){
      
      if(booking.Visitor_Form_No__c.length() != 9){
      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Visit form number should be 9 digits.'));
      return NULL;
      }
      if(booking.Loyalty_Id__c.isnumeric()==false){
      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Loyalty id should not be alpha numeric'));
      return NULL;      
      }
      else if(booking.Loyalty_Id__c.length() != 9){
          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Loyalty id should be 9 digits'));
          return NULL;
      }
      else if(booking.Loyalty_Id__c.substring(0,3) != '100'){
          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Loyalty id should starts with 100'));
          return NULL;
      }
      else if(booking.Loyalty_Id__c.substring(3,4) == '0'){
          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Loyalty id should not have \'0\' at 4th digit'));
          return NULL;
      }
  }

  If(booking.Booking_Status__c == 'CANCELLATION' && (booking.Cancel_Confirm_Date__c == NULL || booking.Reason_for_Cancellation__c == '' || booking.Reason_for_Cancellation__c == NULL || booking.Confirmation_Remark__c == '' || booking.Confirmation_Remark__c == NULL)){
      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please provide values for Confirm Date, Reason for Cancellation and Confirmation Remark when the Status is being changed to Cancellation.'));
      return NULL;
  }
  
  //auto populate submit date on booking -> booked
  if(beforeStatus == 'BOOKING' && booking.Booking_Status__c == 'BOOKED') {
    booking.Submit_Date__c = Date.today();
  }
  
  //Added for storing Opportunity ID to Name Of Opportunity field.
    booking.Name_Of_Opportunity__c = opp_id;
  
  //validation for manatory fields
  if(booking.Booking_Status__c == 'OPEN') {
    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Invalid Status'));
    return null;
  }
  if(booking.Booking_Status__c == 'BLOCKED') {
    if(booking.Block_For__c==NULL || booking.Block_Detail__c==NULL || booking.Block_For_Days__c==NULL ) {
      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Enter Block Details! Fields marked with # are mandatory'));
      return null;
    }
  }
 
 
  if(booking.Booking_Status__c == 'BOOKING' || booking.Booking_Status__c == 'SCUD') {
    
    if(booking.Name_of_Applicant__c==null || booking.Contact_Nos__c==null || booking.Booking_Date__c==null || booking.CRN__c==null || booking.Booking_By__c==null || booking.Visitor_Form_No__c==null || booking.Customer_Type__c==null || booking.Date_of_First_Visit__c==null || booking.Sales_Person__c==null || booking.Loyalty_Id__c==null || booking.Total__c == null) {
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Enter Booking Details! Fields marked with * are mandatory'));
      return null;
    }
    if(rep_id_display_visible == true && booking.Booking_By__c == 'Channel Partner' && booking.Reap_Id__c == null) {
      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Specify REAP ID.'));
      return null;
    }
    if(ref_crn_display_visible == true && (booking.Booking_By__c == 'referral' || booking.Booking_By__c == 'self-referral') && booking.Referral_CRN__c == null) {
      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Specify Referral CRN number.'));
      return null;
    }
    if(ref_crn_display_visible == true && (booking.Booking_By__c == 'referral' || booking.Booking_By__c == 'self-referral') && booking.Referral_CRN__c == null) {
      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Specify Referral CRN number.'));
      return null;
    }

    if(booking.Cheque_Rs__c != 0 && (booking.Cheque_Details__c == null || booking.Cheque_Details__c == '')) {
      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please provide cheque details'));
      return null;
    }
    if(booking.Other_Rs__c != 0  && (booking.Other_Details__c == null || booking.Other_Details__c =='')) {
      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please provide other details'));
      return null;
    }
    if(booking.Credit_Card_Rs__c != 0  && (booking.Credit_Card_Details__c == null || booking.Credit_Card_Details__c == '')) {
      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please provide credit card payment details'));
      return null;
    }  
  }
  if(booking.Booking_Status__c == 'BOOKING') {
    if(booking.Total__c < token_amt) {
      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'The token amount for any inventory cannot be less than that specified amount pricing details of inventory.'));
      return null;
    }
    
    if(booking.DAM_Offer_Sq_ft_Actual_Rs__c > projdet.DAM_Limit__c && booking.Selected_discount_type__c != 'SCUD' && booking.Selected_discount_type__c == 'DAM') {
      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'DAM value cannot be greater than specified DAM limit.'));
      return null;
    }
    else if(booking.DAM_Offer_Sq_ft_Actual_Rs__c > projdet.Special_Offer__c && booking.Selected_discount_type__c != 'SCUD' && booking.Selected_discount_type__c == 'Sp_offer') {
      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Special offer value cannot be greater than specified Special offer limit.'));
      return null;
    }  
  }
  
  Flat__c flat = [Select Actual_Consideration__c, Status__c,Total_Rate_Sq_Ft_Rs__c,Consideration_Rs__c, Wing__r.Hold__c, Wing__r.Cluster__r.Hold__c, Wing__r.Cluster__r.Project_Name__r.Hold__c from Flat__c where ID =:flat_Id];
  String blockSalesPersonEmail;
  if(booking.Block_Sales_Person__c != null) {
    blockSalesPersonEmail = [Select Email from User where ID =:booking.Block_Sales_Person__c].Email;
  }
  
  try {
  
    // added on during issues with sprint 1
        List<Booking_Information__c> bid=[select id,Name_Of_Opportunity__c from Booking_Information__c where Name_Of_Opportunity__c=:opp_id];
        String flatstatus=[select id,Status__c from Flat__c where id=:flat_Id ].Status__c;
        system.debug('!!!!!bid'+bid.size()+flatstatus);
        if(bid.size()==0 && flatstatus!='OPEN'){           
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'This flat has got linked to some other Opportunity for Booking Process. Please close this page and choose a flat with OPEN status for your current Opportunity'));
           return null;
        } 
    // ends 
    booking.Flat__c = flat_Id;
    booking.Unique_booking_Id__c = flat_Id;
    //booking cancellation
    if(booking.Confirmation_Remark__c != null && booking.Cancel_Confirm_Date__c!= null) {
      try {
        flat.Status__c = 'OPEN';
        booking.Flat__c = null;
        booking.InActive__c = TRUE;        
        booking.Confirmation_Date__c = null;
        Upsert booking;
        cancel = TRUE; 
        flat.Actual_Consideration__c = 0;
        //opp.Flat_No__c = NULL;
        
      }
      catch(DMLException e) {
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Booking Cancellation Failed' + e.getMessage()));
        System.debug('Booking Cancellation Failed' + e.getMessage());
      }   
     
    }
    else {
        if(booking.Booking_Status__c == 'Blocked' )
        {
            booking.Block_Sales_Person_Email__c = blockSalesPersonEmail;
        }
     
        if(flat.Status__c == 'HOLD')
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You cannot create/edit a booking against a flat on "Hold".'));
            return null;
        }
        else if(flat.Wing__r.Hold__c == 'Yes')
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You cannot create/edit a booking against a wing on "Hold".'));
            return null;
        }
        else if(flat.Wing__r.Cluster__r.Hold__c == 'Yes')
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You cannot create/edit a booking against a cluster on "Hold".'));
            return null;
        }
        else if(flat.Wing__r.Cluster__r.Project_Name__r.Hold__c == 'Yes')
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You cannot create/edit a booking against a project on "Hold".'));
            return null;
        }
        try {
          upsert booking ;
        }
        catch(DMLException e) {
          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Booking saving error:' + e.getMessage()));
          return null;
        }
        
        system.debug('bookingId:' + booking.Id);
        system.debug('bookingSalesPerEmail:' + booking.Block_Sales_Person_Email__c);
        booking_status = TRUE; 
        if(booking.Booking_Status__c == 'BOOKING' || booking.Booking_Status__c == 'SCUD'){        
           try{
                List<Stage_Details__c> wingStageDet = new List<Stage_Details__c>();     
                List<Stage_Payment_Details__c> stagePaymentInf = new List<Stage_Payment_Details__c>();
                // List<Stage_Payment_Details__c> stagePaymentDet = new List<Stage_Payment_Details__c>();   
                
                wingStageDet = [Select Name, due_status__c, Wing__c, Actual_Completion_Date__c, Amount__c, Description__c, Slab__c, Expected_Completion_Date__c From Stage_Details__c Where Wing__c =: wid Order by Expected_Completion_Date__c];
                if(wingStageDet.size() == 0)
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'No Stage Deatils record for this wing.'));
                    return null;
                }
                
                stagePaymentInf = [Select Id, name, Current_Date_Excepted__c, Payment_Description__c, Payment_Slab__c From Stage_Payment_Details__c Where Booking_Information__c = :booking.id Order by Name]; 
                
                List<SCUD_Information__c> scudinfo = new List<SCUD_Information__c> ();
             
                scudinfo = [select Booking_Information__c, Cluster__c, Flat_Number__c, Project__c, SCUD_Status__c from SCUD_Information__c where Booking_Information__c = :booking.id  AND SCUD_Status__c != 'Rejected'];
                
                boolean ScudProcess = False;
                if(scudinfo.size() == 0){
                    delete stagePaymentInf;
                    ScudProcess = True;
                }
                if(wingStageDet.size()!= 0 && ScudProcess){
                    for(Stage_Details__c sd: wingStageDet){
                        Stage_Payment_Details__c spd = new Stage_Payment_Details__c(
                            Name = sd.name,
                            Booking_Information__c = booking.id,
                            Current_Date_Excepted__c = sd.Expected_Completion_Date__c,
                            Payment_Description__c = sd.Description__c,
                            Payment_Slab__c = sd.Slab__c,
                            Actual_Completion_Date__c = sd.Actual_Completion_Date__c,
                            Current_Amount__c = booking.Consideration_Actual_Rs__c * ( sd.Slab__c/ 100)
                        );
                        insert spd;
                        // stagePaymentDet.add(spd);
                    }
                    //insert stagePaymentDet;
                } 
                /*
                else if(stagePaymentInf.size() > 0) {
                  for(Stage_Payment_Details__c sd: stagePaymentInf) {
                    sd.Current_Amount__c = booking.Consideration_Actual_Rs__c * ( sd.Payment_Slab__c/ 100) ;
                    sd.Requested_Amount__c  = sd.Current_Amount__c;
                  }
                  update stagePaymentInf;
                }
                */
            }
            catch(Exception e){
                System.debug(e);
            }      
        }
                //Added to validate SCUD uniqueness for each booking.
                if(booking.Booking_Status__c == 'BOOKED' || booking.Booking_Status__c == 'BOOKING')
                {
                    List<SCUD_Information__c> scudinfo = new List<SCUD_Information__c> ();
             
                    scudinfo = [select Booking_Information__c, Cluster__c, Flat_Number__c, Project__c, SCUD_Status__c from SCUD_Information__c where Booking_Information__c = :booking.id];
            
                    if(scudinfo.size() != 0 && scudinfo[0].SCUD_Status__c == 'Approved')
                    {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'New SCUD can\'t be created for this Booking.'));
                        isSCUDCreated = False;
                    }
                }
                else if (booking.Booking_Status__c == 'SCUD')
                {
                     List<SCUD_Information__c> scudinfo = new List<SCUD_Information__c> ();
             
                    scudinfo = [select Booking_Information__c, Cluster__c, Flat_Number__c, Project__c, SCUD_Status__c from SCUD_Information__c where Booking_Information__c = :booking.id];
            
                    if(scudinfo.size() != 0 && scudinfo[0].SCUD_Status__c != 'Rejected')
                    {
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'SCUD is in process, New SCUD can\'t be created for this Booking.'));
                        isSCUDCreated = False;
                    }
                }
    }  
  }
  catch(DMLException e) {
    booking_status = FALSE;
    System.debug('Booking Failed' + e.getMessage());
    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Booking Failed:' + e.getMessage()));
    return null;
  }
  
  if(!cancel) {
    if(booking_status) {
    try {  
      flat.Amount_Due_Rs__c = amt_due;      
      flat.Status__c = booking.Booking_Status__c;
      flat.Total_Rate_Sq_Ft_Rs__c = booking.Total_Rate_Sq_ft_Rs__c;
      flat.Actual_Consideration__c = booking.Consideration_Actual_Rs__c ;
      update flat;
    }  
    catch(DMLException e) {
      System.debug('Update Flat Failed' + e.getMessage());
      //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Booking saving error:' + e.getMessage()));
    }
    }
    
    if(booking.Booking_Status__c == 'BOOKED') {
      integer count = [Select Count() From Fame__c Where Booking_Information__c = :booking.id AND FAME_Status__c = NULL];
      if(count == 0){
        createfametask();
      }
    }
  }
  else {
    try {
      update flat;
      cancel = FALSE;
      cancellationstatus=true;
    }
    catch(DMLException e) {
      cancellationstatus=false;
      System.debug('Update Flat Failed' + e.getMessage());
    }
    
    try{
    System.debug('cancellationstatus1' + cancellationstatus);
          if(cancellationstatus==true){
              System.debug('went inside' +cancellationstatus);
              flat__c myflat=[select id,wing__c from flat__c where id=:flat_Id];
              wing__c mywing=[select id from wing__c where id=:myflat.Wing__c limit 1];
              System.debug('went inside1' +cancellationstatus+mywing);
              if(Test.isrunningtest()==false){
                  SpGenerateInventory generateInventer=new SpGenerateInventory(mywing);
                  generateInventer.generateInventory();  
              }            
          }
    }
    catch(DMLException e) {
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Booking Cancellation Failed1' + e.getMessage()));
        System.debug('Booking Cancellation Failed1' + e.getMessage());
    }
        
  }
  isSaved = True;

  PageReference pr = new PageReference('/apex/SpBookInventory'); 
  pr.getParameters().put('fid',flat_Id); 
  pr.getParameters().put('oppid',opp_id);
  pr.setRedirect(true);               
  return pr;
  //return null;
}


//function to get all flat details
public void getFlatDetails(String Fid) {
  String projname;
  for(Flat__c f : [Select Id, Name, Wing__r.name,Flat_Type__r.Name,Wing__c, Wing__r.Project__c,View__c, Total_Rate_Sq_Ft_Rs__c, Token_Amount_Rs__c,Status__c, Stage_Completed__c, Salable_Area__c, Premium_Sq_Ft_Rs__c,
                   Infrastructure_Incl_in_CV__c, Infrastructure_Cost_Rs__c, Infrastructure_Cost2_Rs__c, Infrastructure2_Incl_in_CV__c,
                   Floor__c, Floor_Rise_Sq_Ft_Rs__c, Flat_Type__c, Flat_No__c, Flat_Cost_Rs__c,Wing__r.Cluster_hidden__c,Wing__r.Project_Incharge_Relationship_Manager__c,
                   DAM_Offer_Sq_Ft_Rs__c, Consideration_Rs__c, Club_Charges_Rs__c, Club_Charges_Incl_in_CV__c, Carpet_Area__c, Base_Rate_Sq_Ft_Rs__c,Oasys_Flat_code__c,
                   Applicable_Waiver_Sq_Ft_Rs__c, Wing__r.Project_Incharge_Relationship_Manager__r.Name, Calculated_Total_SqFt_Rate__c,Amount_Due_Rs__c From Flat__c Where Id =:Fid]) {
     flat_no = String.valueof(f.Flat_No__c);
     wing_Name = f.Wing__r.Name;
     wid = f.Wing__c;
     flattype = f.Flat_Type__r.Name;
     viewtype = f.View__c;
     if(f.Salable_Area__c == NULL){
        saleablearea = 0;
     }else{
        saleablearea = f.Salable_Area__c;
     }
     carpetarea = f.Carpet_Area__c;
     amt_due = f.Amount_Due_Rs__c;
     token_amt = f.Token_Amount_Rs__c;
     stage_completed = f.Stage_Completed__c;
     cluster_name = f.Wing__r.Cluster_hidden__c;
     pi_name = f.Wing__r.Project_Incharge_Relationship_Manager__r.Name;
     oasys_flat_code = f.Wing__r.Project__c + '  ' + f.Wing__r.Cluster_hidden__c + '  ' + f.Wing__r.Name +  '  ' + String.valueOf(f.Flat_No__c);
     booking.Oasys_Flat_Code__c = f.Oasys_Flat_code__c;
     PI_id = f.Wing__r.Project_Incharge_Relationship_Manager__c;
     if(bookinglist.size() == 0 || f.Status__c == 'BLOCKED' || booking.Booking_Status__c == 'BLOCKED') {
         
          if(f.Base_Rate_Sq_ft_Rs__c == NULL){
            f.Base_Rate_Sq_ft_Rs__c = 0;
          }
          if(f.Floor_rise_Sq_ft_Rs__c == NULL){
            f.Floor_rise_Sq_ft_Rs__c = 0;
          }
          if(f.Premium_Sq_ft_Rs__c == NULL){
            f.Premium_Sq_ft_Rs__c = 0;
          }
          if(f.Applicable_Waiver_Sq_Ft_Rs__c == NULL){
            f.Applicable_Waiver_Sq_Ft_Rs__c = 0;
          }
          if(f.DAM_Offer_Sq_ft_Rs__c == NULL){
            f.DAM_Offer_Sq_ft_Rs__c = 0;
          }

          if(f.Infrastructure_Cost_Rs__c == NULL){
            f.Infrastructure_Cost_Rs__c = 0;
          }
          if(f.Infrastructure_Cost2_Rs__c == NULL){
            f.Infrastructure_Cost2_Rs__c = 0;
          }
          if(f.Club_Charges_Rs__c == NULL){
            f.Club_Charges_Rs__c = 0;
          }
          if(f.Consideration_Rs__c == NULL){
            f.Consideration_Rs__c = 0;
          }
       
       booking.Base_Rate_Sq_ft_Rs__c = f.Base_Rate_Sq_Ft_Rs__c;
       booking.Floor_rise_Sq_ft_Rs__c = f.Floor_Rise_Sq_Ft_Rs__c;
       booking.Premium_Sq_ft_Rs__c= f.Premium_Sq_Ft_Rs__c;
       booking.Applicable_Waiver_Sq_Ft_Rs__c = f.Applicable_Waiver_Sq_Ft_Rs__c;
       booking.DAM_Offer_Sq_ft_Rs__c = f.DAM_Offer_Sq_Ft_Rs__c;
       //booking.Total_Rate_Sq_ft_Rs__c = (booking.Base_Rate_Sq_ft_Rs__c + booking.Floor_rise_Sq_ft_Rs__c + booking.Premium_Sq_ft_Rs__c) + (booking.Applicable_Waiver_Sq_Ft_Rs__c + booking.DAM_Offer_Sq_ft_Rs__c);
       if(f.Calculated_Total_SqFt_Rate__c == NULL){
           booking.Total_Rate_Sq_ft_Rs__c = 0;
       }else{
           booking.Total_Rate_Sq_ft_Rs__c = f.Calculated_Total_SqFt_Rate__c;
       }
       booking.Flat_Cost_Rs__c = saleablearea  * booking.Total_Rate_Sq_ft_Rs__c;
       booking.Infrastructure_Cost_Rs__c = f.Infrastructure_Cost_Rs__c;
       booking.Infrastructure_Cost_2_Rs__c = f.Infrastructure_Cost2_Rs__c;
       booking.Club_charges_Rs__c = f.Club_Charges_Rs__c;
       booking.Consideration_Rs__c = f.Consideration_Rs__c;
     }
     projname = f.Wing__r.Project__c;
   }
   
   projdet = [select Id, Sales_Strategist__c, Site_Incharge__c, Site_Incharge__r.Name, Sales_Strategist__r.Name, Project_Incharge__c, Project_Incharge__r.Name , Max_Block_Days__c, CRN_INIT__c, Armed_Personnel_Discount__c, DAM_Limit__c, Employee_Discount__c, Physically_Disabled_Discount__c, Special_Offer__c from Project_Name__c where Name=: projname];
   booking.Project_Hidden__c = projname;
   booking.Site_Incharge_hidden__c = projdet.Site_Incharge__r.Name;
   booking.Sales_Strategist_Hidden__c = projdet.Sales_Strategist__r.Name;
}


public String getCrnNumber(String crn_init) {
  String crn=crn_init;
  String random_num;
  Integer random;
  String final_crn;
  do {
    random = Crypto.getRandomInteger();
    random_num = string.valueof(random).substring(0, 5);
  } while (random < 0);
  
  
  Datetime Dt = date.today();
  String now_Date = Dt.format('MMM d, yyyy'); 
  
  String now_mon = now_Date.substring(0, 3).toUpperCase();
  
  String now_year = now_Date.substringAfterLast(' ');
  Integer len = now_year.length();
  
  String year = now_year.substring((len-2), len);
  
  final_crn = crn+now_mon+year+random_num;
  return final_crn;
}


//get all related opportunity Id
public void getOpportunityDetails() {
  List<Opportunity> opplist = [select Channel_Partner__c, Account.Address1_R_cont__pc, Account.Name, LeadSource, Account.Address2_R_cont__pc, Account.Address3_R_cont__pc, Account.BillingState, Account.Pincode_R_cont__pc, Account.BillingCountry, Id,Name,Mobile_no__c,Email__c,LoyaltyID__c,Visit_Form_No__c,Date_of_Visit__c From Opportunity Where Id=:opp_id];
  
  for(Opportunity opp: opplist) {
    //booking.Block_For__c = opp.Id;
    if(booking.Email__c == null) {
      booking.Email__c = opp.Email__c;
    }
    if(opp.Account.Address1_R_cont__pc != null && booking.Address1__c == null) {
      booking.Address1__c = opp.Account.Address1_R_cont__pc;
    }
    
    if(opp.Account.Address2_R_cont__pc != null && booking.Address2__c == null) {
      booking.Address2__c = opp.Account.Address2_R_cont__pc;
    }
    if(opp.Account.Address3_R_cont__pc != null && booking.Address3__c == null) {
      booking.Address3__c = opp.Account.Address3_R_cont__pc;
    }
    if(opp.Account.Pincode_R_cont__pc != null && booking.Pincode__c == null) {
      booking.Pincode__c = String.Valueof(opp.Account.Pincode_R_cont__pc);
    }
       
    if(booking.Name_of_Applicant__c == null) {
      booking.Name_of_Applicant__c = opp.Account.Name;
    }
    if(booking.Loyalty_Id__c == null) {
      booking.Loyalty_Id__c = opp.LoyaltyID__c;
    }
    if(booking.Visitor_Form_No__c == null) {
      booking.Visitor_Form_No__c = opp.Visit_Form_No__c;
    }   
    if(booking.Date_of_First_Visit__c == null) {
      booking.Date_of_First_Visit__c = opp.Date_of_Visit__c ;
    }
    if(booking.Contact_Nos__c == null) {
      booking.Contact_Nos__c= opp.Mobile_no__c;
    }
   
  }
}


public void copyRateToActual() {
  if(booking.Base_Rate_Sq_ft_Actual_Rs__c == null || booking.Booking_Status__c == 'BLOCKED') {
    booking.Base_Rate_Sq_ft_Actual_Rs__c = booking.Base_Rate_Sq_ft_Rs__c;
  }
  if(booking.Floor_rise_Sq_ft_Actual_Rs__c == null || booking.Booking_Status__c == 'BLOCKED') {
    booking.Floor_rise_Sq_ft_Actual_Rs__c = booking.Floor_rise_Sq_ft_Rs__c;
  }
  if(booking.Premium_Sq_ft_Actual_Rs__c == null || booking.Booking_Status__c == 'BLOCKED') {  
    booking.Premium_Sq_ft_Actual_Rs__c = booking.Premium_Sq_ft_Rs__c;
  }
  if(booking.Applicable_Waiver_Sq_ft_Actual_Rs__c == null || booking.Booking_Status__c == 'BLOCKED') {  
    booking.Applicable_Waiver_Sq_ft_Actual_Rs__c = booking.Applicable_Waiver_Sq_ft_Rs__c;
  }
  if(booking.DAM_Offer_Sq_ft_Actual_Rs__c == null || booking.Booking_Status__c == 'BLOCKED') {
    booking.DAM_Offer_Sq_ft_Actual_Rs__c = booking.DAM_Offer_Sq_ft_Rs__c;
  }
   if(booking.Infrastructure_Cost_Actual_Rs__c == null || booking.Booking_Status__c == 'BLOCKED') {
    booking.Infrastructure_Cost_Actual_Rs__c = booking.Infrastructure_Cost_Rs__c;
   }
   if(booking.Infrastructure_Cost_2Actual_Rs__c == null || booking.Booking_Status__c == 'BLOCKED') {
     booking.Infrastructure_Cost_2Actual_Rs__c = booking.Infrastructure_Cost_2_Rs__c;
   }  
   if(booking.Club_charges_Actual_Rs__c == null || booking.Booking_Status__c == 'BLOCKED') {
    booking.Club_charges_Actual_Rs__c = booking.Club_charges_Rs__c;
   }  
   if(booking.Flat_Cost_Actual_Rs__c == null || booking.Booking_Status__c == 'BLOCKED') {
    booking.Flat_Cost_Actual_Rs__c = booking.Flat_Cost_Rs__c;
   } 
   if(booking.Total_Rate_Sq_ft_Actual_Rs__c == null || booking.Booking_Status__c == 'BLOCKED') {
    booking.Total_Rate_Sq_ft_Actual_Rs__c = booking.Total_Rate_Sq_ft_Rs__c;
   } 
   
  if(booking.Consideration_Actual_Rs__c == null || booking.Booking_Status__c == 'BLOCKED') {
    booking.Consideration_Actual_Rs__c =  booking.Consideration_Rs__c;
  }
}

public PageReference inf_consideration_amt() {
  system.debug('booking.Infrastructure_Incl_in_CV__c :' + booking.Infrastructure_Incl_in_CV__c);
  if(booking.Infrastructure_Incl_in_CV__c != null)
  {
      if(booking.Infrastructure_Incl_in_CV__c == 'Incl.in CV') {
        booking.Consideration_Actual_Rs__c = booking.Consideration_Actual_Rs__c + booking.Infrastructure_Cost_Actual_Rs__c;
        
        //JIRA PSMR-386 Adding the calculation logic to alter Card values
        booking.Consideration_Rs__c = booking.Consideration_Rs__c + booking.Infrastructure_Cost_Rs__c;
      }
      else if(booking.Infrastructure_Incl_in_CV__c == 'Excl.in CV') {
        booking.Consideration_Actual_Rs__c = booking.Consideration_Actual_Rs__c - booking.Infrastructure_Cost_Actual_Rs__c;
        
        //JIRA PSMR-386 Adding the calculation logic to alter Card values
        booking.Consideration_Rs__c = booking.Consideration_Rs__c - booking.Infrastructure_Cost_Rs__c;
      }
  }
  return null;
}


public PageReference inf2_consideration_amt() {
  if(booking.Infrastructure2_Incl_in_CV__c != null)
  {
      if(booking.Infrastructure2_Incl_in_CV__c == 'Incl.in CV') {
        booking.Consideration_Actual_Rs__c = booking.Consideration_Actual_Rs__c + booking.Infrastructure_Cost_2Actual_Rs__c;
        
        //JIRA PSMR-386 Adding the calculation logic to alter Card values
        booking.Consideration_Rs__c = booking.Consideration_Rs__c + booking.Infrastructure_Cost_2_Rs__c;
      }
      else if(booking.Infrastructure2_Incl_in_CV__c == 'Excl.in CV') {
        booking.Consideration_Actual_Rs__c = booking.Consideration_Actual_Rs__c - booking.Infrastructure_Cost_2Actual_Rs__c;
        
        //JIRA PSMR-386 Adding the calculation logic to alter Card values
        booking.Consideration_Rs__c = booking.Consideration_Rs__c - booking.Infrastructure_Cost_2_Rs__c;
      }
  }
  return null;
}  


public PageReference clb_consideration_amt() {
  if(booking.Club_charges_Incl_in_CV__c != null)
  {
      if(booking.Club_charges_Incl_in_CV__c == 'Incl.in CV') {
        booking.Consideration_Actual_Rs__c = booking.Consideration_Actual_Rs__c + booking.Club_charges_Actual_Rs__c;
        
        //JIRA PSMR-386 Adding the calculation logic to alter Card values
        booking.Consideration_Rs__c = booking.Consideration_Rs__c + booking.Club_charges_Rs__c;
      }
      else if(booking.Club_charges_Incl_in_CV__c == 'Excl.in CV') {
        booking.Consideration_Actual_Rs__c = booking.Consideration_Actual_Rs__c - booking.Club_charges_Actual_Rs__c;
        
        //JIRA PSMR-386 Adding the calculation logic to alter Card values
        booking.Consideration_Rs__c = booking.Consideration_Rs__c - booking.Club_charges_Rs__c;
      }
  }
  return null;
}

public PageReference cal_token_amt() {
  system.debug('!!!!!!!!!!!!!status'+DummyStatus+booking.Booking_Status__c);
  booking.Booking_Status__c=DummyStatus;
  decimal token;
  if(booking.Cash_Rs__c == null ) {
    booking.Cash_Rs__c = 0;
  }
  if(booking.Cheque_Rs__c == null ) {
    booking.Cheque_Rs__c = 0;
  }
  if(booking.Other_Rs__c == null ) {
    booking.Other_Rs__c = 0;
  }
  if(booking.Credit_Card_Rs__c == null ) {
    booking.Credit_Card_Rs__c = 0;
  }
  
  
  token = booking.Cash_Rs__c + booking.Credit_Card_Rs__c + booking.Cheque_Rs__c + booking.Other_Rs__c;
  booking.Total__c = token;
  if(booking.Booking_Status__c == 'BOOKING') {
    if(token < token_amt){
      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'The token amount for any inventory cannot be less than that specified amount pricing details of inventory.'));
    }
  }

  
  return null; 
}

public PageReference cal_infra_cost() {
  adjust_infra_cv();
  return null;
}


public void adjust_infra_cv() {
	
  decimal tmp_flat_cost = booking.Flat_Cost_Actual_Rs__c;
  decimal decCardFlatCost = booking.Flat_Cost_Rs__c;
  
  if(booking.Infrastructure_Incl_in_CV__c == 'Incl.in CV') {
    tmp_flat_cost  = tmp_flat_cost  + booking.Infrastructure_Cost_Actual_Rs__c;
    decCardFlatCost = (decCardFlatCost != NULL) ? (decCardFlatCost + booking.Infrastructure_Cost_Rs__c) : 0;
  }
  
  if(booking.Infrastructure2_Incl_in_CV__c == 'Incl.in CV') {
    tmp_flat_cost = tmp_flat_cost  + booking.Infrastructure_Cost_2Actual_Rs__c;
    decCardFlatCost = decCardFlatCost + booking.Infrastructure_Cost_2_Rs__c;
  }
  
  if(booking.Club_charges_Incl_in_CV__c == 'Incl.in CV') {
    tmp_flat_cost  = tmp_flat_cost  + booking.Club_charges_Actual_Rs__c;
    decCardFlatCost = decCardFlatCost + booking.Club_charges_Rs__c;
  }
  
  booking.Consideration_Actual_Rs__c = tmp_flat_cost ;
  booking.Consideration_Rs__c = decCardFlatCost;
}


public class SpBookingWrapper {

}

/*
public PageReference inititeSCUD(){
    PageReference pageRef = new PageReference('/apex/SpScudApproval?bid='+booking.id);
    pageRef.setRedirect(true);
    return pageRef;
    
}
*/

public void createfametask(){
   fame= new FAME__c();
   fame.Booking_Information__c = booking.id;
   fame.Unique_key__c = 'FAME' + flat_no + string.valueof(booking.id);
   fame.FAME_Task_Created_Date__c = date.today();
   insert fame;
   
   
  // String baseUrl = ApexPages.currentPage().getHeaders().get('Host');
   String baseUrl = System.URL.getSalesforceBaseUrl().getHost().remove('-api' );
   baseUrl = 'https://' + baseUrl.substring(2,6) + 'salesforce.com';
   
   String fame_url = baseUrl  + '/apex/SpFAMEApproval?booking='+ booking.id;   
   Id record_type_id = [Select Id from RecordType Where DeveloperName='Fame_Task'].Id;
   Task newTask = new Task(Description = 'FAME Approval For' + oasys_flat_code,                                        
                                        RecordTypeId = record_type_id,
                                        Priority = 'Normal', 
                                        Status = 'Under Action by Me', 
                                        Subject = 'FAME Initiated - ' + oasys_flat_code, 
                                        IsReminderSet = true,                                      
                                        ReminderDateTime = System.now()+6, 
                                        ActivityDate = date.today()+7,
                                        OwnerId = PI_id,
                                        WhatId =  fame.Id,
                                        FAME_CHECKLIST_Page_URL__c = fame_url);
                                        
   try {
     insert newTask;
   }
   catch(DMLException e) {   
     System.debug('Unable to create task' + e.getMessage());
   }
    
   String subject = 'New FAME Task created -' + oasys_flat_code;
   String SM_name = [Select Name from User where ID =:booking.Sales_Person__c].Name;     
   //send email to PI
   String html_body_1 = 'Hello ' + pi_name  + ','+ '<br/><br/> New Fame task has been created by '  + SM_name  + ' for '+ flat_no + ' of Wing: ' + wing_Name + ' of ' + cluster_name + ' of project ' + booking.Project_Hidden__c + '.<br/><br/> Please click on the following link to view the same.<br/>' + baseUrl + '/' + newTask.Id + '<br/><br/>Regards, <br/>Lodha Admin';
   send_email(subject, html_body_1 , PI_id); 
}


public void send_email(String subject, String html_body, Id receipient_id) {
  Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
  mail.setBccSender(false);
  mail.setUseSignature(false);
  mail.setTargetObjectId(receipient_id);
  mail.setSubject(subject);
  mail.setHtmlBody(html_body);
  mail.setReplyTo('noreplay@LodhaGroup.com');
  mail.setSenderDisplayName('Lodha Admin');
  mail.setSaveAsActivity(false); 
  Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
}



public List<selectOption> getCorpSelectionList() {
      List<selectOption> CorpOptions = new List<selectOption>();
       //new list for holding all of the picklist options
      CorpOptions.add(new selectOption('', 'Select')); 
      //add the first option of '- None -' in case the user doesn't
      // want to select a value or in case no values are
      // returned from query below
     
      for (Corporate_connection__c corp: [select ID, Name from Corporate_connection__c Where Project__c =: projdet.Id Order By Name]) { 
          //query for Account records 
          CorpOptions.add(new selectOption(corp.Id, corp.Name)); 
          //for all records found - add them to the picklist options
      }
      
      return CorpOptions; 
      //return the picklist options
}

public static void send_email2(String subject, String html_body, Id receipient_id) {
  Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
  mail.setBccSender(false);
  mail.setUseSignature(false);
  mail.setTargetObjectId(receipient_id);
  mail.setSubject(subject);
  mail.setHtmlBody(html_body);
  mail.setReplyTo('noreplay@LodhaGroup.com');
  mail.setSenderDisplayName('Lodha Admin');
  mail.setSaveAsActivity(false); 
  Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
}

}