public class updateInferenceOverOpportunity{

public static List<opportunity> UpdateInferences(List<opportunity> oppLst){
    List<opportunity> ratinglst=new List<opportunity>();
    for(opportunity a:oppLst){
            ratinglst.add(Calculate(a));
        }
    return oppLst;
        
}

public static opportunity Calculate(opportunity num){
    if(num.Customer_Rating__c >= 4.8)
        num.Inference_New__c='Likely Closure-Hot';
    else if(num.Customer_Rating__c < 4.8 && num.Customer_Rating__c >= 4.5)
        num.Inference_New__c='Under Consideration - Warm';
    else if(num.Customer_Rating__c < 4.5 && num.Customer_Rating__c >= 4.0)
        num.Inference_New__c='Multiple follow up required -  Site head interaction mandatory';
    else if(num.Customer_Rating__c < 4.0 && num.Customer_Rating__c >= 3.5)
        num.Inference_New__c='Focus on (higher rating ones) - Push revisit';
    else if(num.Customer_Rating__c < 3.5 && num.Customer_Rating__c >= 2.5)
        num.Inference_New__c='Sort issues (lower rating ones) & follow up atleast once';
    else if(num.Customer_Rating__c < 2.5 && num.Customer_Rating__c > 0.00)
        num.Inference_New__c='Not interested/Lost';
    else
        num.Inference_New__c='';           
    return num;
}

}