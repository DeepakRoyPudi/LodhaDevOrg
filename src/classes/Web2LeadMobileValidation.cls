public class Web2LeadMobileValidation{

    public static void CheckLeadLandline(List<Lead> leadlist){
        for(Lead l: leadlist)
        {
            if(l.LeadSource == 'AskMe' && (l.Mobile__c.subString(0,2) == '22' || l.Mobile__c.subString(0,2) == '20' || l.Mobile__c.subString(0,2) == '40' || l.Mobile__c.subString(0,2) == '80'))
            {
                l.Mobile__c = '0' + l.Mobile__c;
                l.Landline__c = True;
            }    
        }
    }
}