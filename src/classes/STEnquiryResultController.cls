/*
Purpose - Controller for STEnquiryResult Page
Developer - Jayant
Date Last Modified - 30/06/2011
*/

public class STEnquiryResultController {

    public PageReference goBack() {
        PageReference returnURL = Page.STEnquiry;
        returnURL.setRedirect(true);
        return returnURL;
    }

public string ErrMsg{set;get;}
    public STEnquiryResultController() {
        ErrMsg = '';
        lstres = [select Amount_Recd__c, Amt_Received_Per__c, Balance_Due_CS__c, Balance_Due_FR__c, Balance_Due_PR__c, Base__c,
                    Building_Name__c, Customer_ID__c, Customer_Name__c, CV__c, Demand_Raised_Per__c, Eligible_Exemption__c, 
                    Eligible_Exemption_Per__c, Flat_No__c, FR__c, Net_Payable_Service_Tax__c, Net_Value_FR__c,
                    Net_Value_Inst__c, Net_Value_PR__c, POC_Rs__c, POC_Per__c, PR__c, Project_Name__c, Rate_CS__c, Rate_FR__c,
                    Rate_PR__c, Service_Tax_FR__c, Service_Tax_Inst__c, Service_Tax_PR__c, Service_Tax_Collected_CS__c,
                    Service_Tax_Collected_FR__c, Service_Tax_Collected_PR__c, Total__c, Amount_TS__c, Total_Demand_Raised__c, Name 
                from STDesc__c where Customer_ID__c =: CustID and Flat_No__c =: FlatNo LIMIT 1 ];
        if(lstres.size()==0){
            ErrMsg = 'No matching records found.';
        }        
    }


    public STDesc__c res = new STDesc__c();
    public list<STDesc__c> lstres = new list<STDesc__c>();
    public String CustID = System.currentPageReference().getParameters().get('CustID');
    public String FlatNum = System.currentPageReference().getParameters().get('FlatNum');
    Integer FlatNo = Integer.ValueOf(FlatNum);
    public Date tillDate = Date.Today();

     
    public String getTillDate() {
        return tillDate.format();
    }



    public STDesc__c getResult() {
        if(lstres.size()>0){
            return lstres[0];
        }else{
            return null;
        }        
        
    }
}