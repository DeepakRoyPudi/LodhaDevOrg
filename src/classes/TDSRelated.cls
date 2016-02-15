public class TDSRelated{
    
    //Validation method for CC users
    public static void validationForCCUsers(List<Account> acctOld){
        
        User u = [SELECT Id, Name, Username, ProfileId from User Where id =: userinfo.getUserId()];
        Profile p = [Select Id, Name From Profile where Name = 'Customer Care'];
        
        integer i=0;
        
        if(u.ProfileId == p.Id){
        
        for(Account a :acctOld)
        {
            if(a.TDS_related__c != null){
                Trigger.New[i].addError('CC users dont have access to edit TDS Related Fields');
            }
            if(a.Primary_PAN_number__c != null){
                Trigger.New[i].addError('CC users dont have access to edit TDS Related Fields2');
            }

        }
        
        }
        
    }
}