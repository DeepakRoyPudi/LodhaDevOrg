/* Version              Created By       Created Date       Description
 *
 *  Initial Draft       Sneha P.          9/3/2015       Helper class to query the respective 
 *                                                       object using fieldset
    1.1                 Trupti D          15/07.2015     Added fieldsets for Demands in crisp view
 
 *
 */
public class CreateQueryHelper {
    /* CSS Variables*/
    
    public static DateTime frmdate;
    public static DateTime todate;
    public static String documentName;
    
    public static Date docfrmdate;
    public static Date doctodate;
    
    public static Date frmDispatchdate;
    public static Date toDispatchdate;
    
    public static Date frmDispatchdate1;
    public static Date toDispatchdate1; 
   
     //Variables for Recent Activity
     public static final String RecentActivityCrispCSS ='RecentActivityCrispView_CSS2_0';
     public static final String RecentActivityDetailCSS ='RecentActivityDetailView_CSS2_0';
     
     //Variables for documents/sms/dispatch
     public static final String RecentDocumentCrispCSS ='DocumentCrispView_CSS2_0';
     public static final String RecentSMSCrispCSS ='SMSCrispView_CSS2_0';
     public static final String RecentDispatchCrispCSS ='DispatchCrispView_CSS2_0';
     //public static final String RecentDocumentDetailCSS ='DocumentDetailView_CSS2_0';
    
    
     public static final String RecentDocumentDetailCSS ='DocumentDetailView_CSS2_0';
     public static final String RecentSMSDetailCSS ='SMSDetailView_CSS2_0';
     public static final String RecentDespatchDetailCSS ='DispatchDetailView_CSS2_0';
     
     
    // public static final String BookingDetailView_CSS ='BookingDetailView_CSS2_0';
     
     public static final String RecentActivityCrispRM ='RecentActivityCrispView_RM';
     public static final String RecentActivityDetailRM ='RecentActivityDetailView_RM';
     
     /*RM Variables*/
     //Variables for Document
     public static final String RecentDocsDetailRM ='DocumentDetailView_RM';
     public static final String RecentDocsCrispRM ='DocumentCrispView_RM';
     
     //Variables for SMS
     public static final String RecentSMSDetailRM ='SMSDetailView_RM';
     public static final String RecentSMSCrispRM ='SMSCrispView_RM';
     
     //Variales for Dispatch
     public static final String RecentDispatchCrispRM ='DispatchCrispViewRM';
     public static final String RecentDispatchDetailRM ='DispatchDetailViewRM';   
     
     
     //Variables for Booking Payments Transactions
     public static final String BookingPaymnetsTransCrispRM ='BookingPaymentsTransationCrispRM';
     public static final String BookingPaymnetsTransDetailRM ='BookingPaymentsTransationDetailRM';   
     
     
     //variable for milestone outstandin
     public static final String MilestoneOutstandingCSS = 'MilestoneOutstandingCSS2_0';
     
     //variable for payment received
     public static final String MilestonePaidCSS2_0 = 'MilestonePaidCSS2_0';
     /* Method to return Fieldset name depending on the variable
      */
     public static List<Schema.FieldSetMember> getFields(String fieldsetName) {
        
        if(fieldsetName == RecentActivityCrispCSS)
            return SObjectType.Case.FieldSets.RecentActivityCrispView_CSS2_0.getFields();
            
        else if(fieldsetName == RecentActivityDetailCSS ){
              return SObjectType.Case.FieldSets.RecentActivityDetailView_CSS2_0.getFields();
        }
        //sms/document/dispatch Crisp view
        else if(fieldsetName == RecentDocumentCrispCSS ){
              return SObjectType.Documents__c.FieldSets.DocumentCrispView_CSS2_0.getFields();
        }
        
        else if(fieldsetName == RecentSMSCrispCSS ){
              return SObjectType.SMS_History__c.FieldSets.SMSCrispView_CSS2_0.getFields();
        }
        
        else if(fieldsetName == RecentDispatchCrispCSS ){
              return SObjectType.Despatch__c.FieldSets.DispatchCrispView_CSS2_0.getFields();
        }
        
        //sms/document/dispatch Detail view
        
        else if(fieldsetName == RecentDocumentDetailCSS ){
              return SObjectType.Documents__c.FieldSets.DocumentDetailView_CSS2_0.getFields();
        }
        
        else if(fieldsetName == RecentSMSDetailCSS ){
              return SObjectType.SMS_History__c.FieldSets.SMSDetailView_CSS2_0.getFields();
        }
        else if(fieldsetName == RecentDespatchDetailCSS ){
              return SObjectType.Despatch__c.FieldSets.DispatchDetailView_CSS2_0.getFields();
        }
        
        //mistone outstanding
        else if(fieldsetName == MilestoneOutstandingCSS) {
            return SObjectType.Demands__c.FieldSets.MilestoneOutstandingCSS2_0.getFields();
        }
        
        //Milestone Received
        else if(fieldsetName == MilestonePaidCSS2_0 ){
            return SObjectType.Demands__c.FieldSets.MilestonePaidCSS2_0.getFields();
        }
        else if(fieldsetName == RecentActivityCrispRM)
            return SObjectType.Case.FieldSets.RecentActivityCrispView_RM.getFields();
            
        else if(fieldsetName == RecentActivityDetailRM ){
              return SObjectType.Case.FieldSets.RecentActivityDetailView_RM.getFields();
        }
        else if(fieldsetName == RecentDocsDetailRM)
            return SObjectType.Documents__c.FieldSets.DocumentDetailView_RM.getFields();   
            
        else if(fieldsetName == RecentDocsCrispRM)
            return SObjectType.Documents__c.FieldSets.DocumentCrispView_RM.getFields();  
        
        else if(fieldsetName == RecentSMSDetailRM)
            return SObjectType.SMS_History__c.FieldSets.SMSDetailView_RM.getFields();  
            
        else if(fieldsetName == RecentSMSCrispRM)
            return SObjectType.SMS_History__c.FieldSets.SMSCrispView_RM.getFields();  
            
        else if(fieldsetName == RecentDispatchDetailRM)
            return SObjectType.Despatch__c.FieldSets.DispatchDetailViewRM.getFields();
            
        else if(fieldsetName == RecentDispatchCrispRM)
            return SObjectType.Despatch__c.FieldSets.DispatchCrispViewRM.getFields();
        
        else if(fieldsetName == BookingPaymnetsTransCrispRM)
            return SObjectType.Booking_Payment_Transaction__c.FieldSets.BookingPaymentsTransactionCrisp_RM.getFields(); 
        
        else if(fieldsetName == BookingPaymnetsTransDetailRM)
            return SObjectType.Booking_Payment_Transaction__c.FieldSets.BookingPaymentsTransactionsDetail_RM.getFields();   
            
        return null;
    }
    
    /* Method to form and execute query using dynamic parameters and return list of 
     * sObject  
     */
    public static list<sObject> getRecords(String objectname, String strFields,
                                           String whereClause, String fieldsetName, 
                                           String strOrder,String strLimit) {
        
        
        String query = 'SELECT ';
        
        for(Schema.FieldSetMember f : getFields(fieldsetName)) {
            query += f.getFieldPath()+' , ' ;
        }
        query += strFields+' FROM '+objectname;
       
        if(whereClause != '')
            query += ' '+whereClause;   
            
        if(strOrder != '')
            query +=' '+strOrder;
       
        if(strLimit != '')
            query += ' '+strLimit;
        
        system.debug('*query***'+query);
        return (Database.query(query));
    }
    
    public static String getCustomerCRN(String userId) 
    {
            User u = [Select AccountId from user where id =: userId];
            String CRN = [select CRN__c from account where Id =:u.AccountId limit 1 ].CRN__c;
                return CRN;
    }

}