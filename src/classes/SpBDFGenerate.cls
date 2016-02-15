public class SpBDFGenerate {

public String flat_Id{get;set;}
public List<Booking_Information__c> bookinglist{get;set;}
public final Booking_Information__c booking{get;set;}
public Flat__c flat{get;set;}
public decimal baserate_diff{get;set;}
public decimal floorrise_diff{get;set;}
public decimal premview_diff{get;set;}
public decimal waiver_diff{get;set;}
public decimal totalrate_diff{get;set;}
public String finalTotalRate{get; set;}
    
public decimal flatcost_diff{get;set;}
public decimal infra_diff{get;set;}
public decimal cv_diff{get;set;}
public String booking_date{get;set;}
public decimal Infrastructure_Charges{get;set;}
public decimal Infrastructure_Charges_Actual{get;set;}
public String Infrastructure_desc{get;set;}
public String corp_name{get;set;}
public String Details{get;set;}
public boolean paymentSchedule{get; set;}
public Integer alloted{get; set;}

//Siddharth 15/07/2014 Additional Variables for displaying calculated fields
public decimal decimalApprovedConsiderationValue {get; set;}
public decimal decimalActualConsiderationValue {get; set;}
    
public SpBDFGenerate(ApexPages.StandardController controller) {
  
  decimalApprovedConsiderationValue = 0;
  decimalActualConsiderationValue = 0;
  flat_Id = ApexPages.currentPage().getParameters().get('fid');
  String objectName = 'Booking_Information__c';  // modify as needed
  String query = 'SELECT';
  Details = '';
  paymentSchedule = True;
  Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
 
  // Grab the fields from the describe method and append them to the queryString one by one.
  for(String s : objectFields.keySet()) {
     
     if(s == 'Reap_Id__c')
     {
         s = 'Reap_Id__c, Reap_Id__r.REAP_ID__c, Reap_Id__r.Name';
         query += ' ' + s + ', ';
     }
     else if(s == 'Sales_Person__c')
     {
         s = 'Sales_Person__r.Name';
         query += ' ' + s + ', ';
     }
     else
     {
         query += ' ' + s + ', ';
     }
  }
  

  // Strip off the last comma if it exists.
  query = query.removeEnd(', ');
  
  query = query +', Block_for__r.Name, Corporate_connection__r.Name ';
  // Add FROM statement
  query += ' FROM ' + objectName;
 
  // Add on a WHERE/ORDER/LIMIT statement as needed
  query += ' WHERE Flat__c = \''+ flat_Id +'\''; // modify as needed 
  bookinglist = database.query(query); 
  booking = bookinglist.get(0);

  flat = [Select Id, Name, Wing__r.name,Flat_Type__r.Name,Wing__c, Wing__r.Project__c, Wing__r.Company__c, 
          Wing__r.Cluster_hidden__c,View__c, Total_Rate_Sq_Ft_Rs__c, Token_Amount_Rs__c,Status__c, 
          Stage_Completed__c, Salable_Area__c, Premium_Sq_Ft_Rs__c, Infrastructure_Incl_in_CV__c, 
          Infrastructure_Cost_Rs__c, Infrastructure_Cost2_Rs__c, Infrastructure2_Incl_in_CV__c, 
          Floor__c, Floor_Rise_Sq_Ft_Rs__c, Flat_Type__c, Flat_No__c, Flat_Cost_Rs__c, 
          DAM_Offer_Sq_Ft_Rs__c, Consideration_Rs__c, Club_Charges_Rs__c, Club_Charges_Incl_in_CV__c, 
          Carpet_Area__c, Base_Rate_Sq_Ft_Rs__c, Applicable_Waiver_Sq_Ft_Rs__c, Amount_Due_Rs__c From Flat__c 
          Where Id =:flat_Id];

    
    Infrastructure_Charges = 0;
    Infrastructure_desc = '';
    
    if(booking.Infrastructure_Incl_in_CV__c == 'Incl.in CV'){
      Infrastructure_Charges = booking.Infrastructure_Cost_Rs__c;
    }
    if(booking.Infrastructure2_Incl_in_CV__c == 'Incl.in CV'){
      Infrastructure_Charges = Infrastructure_Charges + booking.Infrastructure_Cost_2_Rs__c;
      
    }
    if(booking.Club_Charges_Incl_in_CV__c == 'Incl.in CV'){
      Infrastructure_Charges = Infrastructure_Charges + booking.Club_Charges_Rs__c;
    }
    
    Infrastructure_Charges_Actual= 0;
    if(booking.Infrastructure_Incl_in_CV__c == 'Incl.in CV') {
      Infrastructure_Charges_Actual= booking.Infrastructure_Cost_Actual_Rs__c;
      Infrastructure_desc = 'Infra1:'+ String.valueof(booking.Infrastructure_Cost_Actual_Rs__c) + '(incl.) ';
    }
        
    if(booking.Infrastructure2_Incl_in_CV__c == 'Incl.in CV') {
      Infrastructure_Charges_Actual= Infrastructure_Charges_Actual+ booking.Infrastructure_Cost_2Actual_Rs__c;
      Infrastructure_desc = Infrastructure_desc + 'Infra2:'+ String.valueof(booking.Infrastructure_Cost_2Actual_Rs__c) + '(incl.) ';
    }
    
    if(booking.Club_charges_Incl_in_CV__c == 'Incl.in CV') {
      Infrastructure_Charges_Actual= Infrastructure_Charges_Actual + booking.Club_charges_Actual_Rs__c;
      Infrastructure_desc = Infrastructure_desc + 'Club:'+ String.valueof(booking.Club_charges_Actual_Rs__c) + '(incl.) ';
    }
    
    //Siddharth
    decimalApprovedConsiderationValue = flat.Flat_Cost_Rs__c + Infrastructure_Charges;
    decimalActualConsiderationValue = booking.Flat_Cost_Actual_Rs__c + Infrastructure_Charges_Actual;
    
    baserate_diff = flat.Base_Rate_Sq_Ft_Rs__c - booking.Base_Rate_Sq_ft_Actual_Rs__c;
    floorrise_diff = flat.Floor_Rise_Sq_Ft_Rs__c - booking.Floor_rise_Sq_ft_Actual_Rs__c;
    premview_diff = flat.Premium_Sq_Ft_Rs__c- booking.Premium_Sq_ft_Actual_Rs__c;
    waiver_diff = booking.Applicable_Waiver_Sq_ft_Rs__c - booking.Applicable_Waiver_Sq_ft_Actual_Rs__c;
    totalrate_diff = flat.Total_Rate_Sq_Ft_Rs__c - booking.Total_Rate_Sq_ft_Actual_Rs__c;
    flatcost_diff = flat.Flat_Cost_Rs__c - booking.Flat_Cost_Actual_Rs__c;
    infra_diff = Infrastructure_Charges - Infrastructure_Charges_Actual;
    
    //Siddharth
    //cv_diff = flat.Consideration_Rs__c - booking.Consideration_Actual_Rs__c;
    cv_diff = decimalApprovedConsiderationValue - decimalActualConsiderationValue;   
    
    booking_date = booking.Booking_Date__c.format();
    if(booking.Corporate_connection__c != null || booking.Corporate_connection__c != '') {
      corp_name = booking.Corporate_connection__r.Name;
    }
    else {
      corp_name = null;
    }
    
    if(booking.Booking_By__c == 'Channel Partner' && booking.Reap_Id__c != NULL){
        Details = booking.Reap_Id__r.Name + ' / ' + booking.Reap_Id__r.REAP_ID__c;
        if(booking.Reap_Id__r.REAP_ID__c == '')
            Details.remove('/');
    }
    else if(booking.Booking_By__c == 'referral' || booking.Booking_By__c == 'self-referral')
    {
        List<Account> accountInfo = [Select LoyaltyId__c, Name, CRN__c From Account Where CRN__c =: booking.Referral_CRN__c];
        if(accountInfo.size() > 0){
            Details = accountInfo[0].Name + ' / ' + accountInfo[0].LoyaltyId__c + ' / ' + accountInfo[0].CRN__c;
        }
        else{
            Details = booking.Referral_CRN__c;
        }
    }
    List<SCUD_Information__c> scudinfo = [Select New_NPV__c, Original_NPV__c From SCUD_Information__c Where Booking_Information__c =: booking.Id ];

    if(scudinfo.size() > 0)
    {
        double npvdifference = scudinfo[0].New_NPV__c - scudinfo[0].Original_NPV__c;
        if(npvdifference == 0){
            paymentSchedule = True;
        }else{
            paymentSchedule = False;
        }
    }
    if(booking.Selected_discount_type__c != '' && booking.Selected_discount_type__c != NULL){
        finalTotalRate = booking.Selected_discount_type__c + ': ' + booking.DAM_Offer_Sq_ft_Actual_Rs__c + ' + ' + 'APP. WAIVER: ' + booking.Applicable_Waiver_Sq_ft_Actual_Rs__c;
    }else{
        finalTotalRate = 'APP. WAIVER: ' + booking.Applicable_Waiver_Sq_ft_Actual_Rs__c;
    }
    alloted = 0;
    if(booking.Parking_Nos_2W__c != NULL){
        alloted = integer.ValueOf(booking.Parking_Nos_2W__c);
    }
    if(booking.Parking_Nos_4w__c != NULL){
        alloted += integer.ValueOf(booking.Parking_Nos_4w__c);
    }
}



}