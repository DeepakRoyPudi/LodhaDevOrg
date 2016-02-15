@istest(seealldata=true)
public class Test_IdentifyStdFlat{
    
    public static testMethod void Test_IdentifyStdFlat1(){
        
        Wing__c W = [select id from Wing__c LIMIT 1];
        
        PageReference pageRef = Page.IdentifyStdFlatPage;
        Test.setCurrentPageReference(pageRef);
        
        flat__c f = new flat__c(status__c='test',wing__c=w.id,Flat_No__c=1000);
        insert f;
        
        
        ApexPages.CurrentPage().getparameters().put('id', f.id);
        ApexPages.StandardController sc = new ApexPages.standardController(f);
        
        IdentifyStdFlat a = new IdentifyStdFlat(sc);
        a.save();
    
    }
    
    
    
    
    }