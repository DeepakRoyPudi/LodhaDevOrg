/*
    To update Email id on user object if Personal email is changed on booked Account.

*/

public class UpdateAccountUserEmailHelper{
    
    Set<Id> userIdSet = new set<id>();
    List<User> userList = new List<User>();
    public List<Account> lstNewAcc = new List<Account>();
    public List<Account> lstOldAcc = new List<Account>();  
    public List<User>  lstUser= new List<User>();    
    public map<id,string> emailmap = new map<id,string> ();
    
    //update user email id 
    
    @TestVisible private static Boolean blnIsExecuted = false;
    
    public void updateUser(map<id,Account> accOldMap,map<id,Account> accNewMap){
    
    if(!blnIsExecuted){
    
    Set<Id> accIds = new Set<Id>();  
    
    //record id
    //Schema.RecordTypeInfo rtInfo = Account.SObjectType.getDescribe().getRecordTypeInfosByName().get('Person Account');
    Id recTypeAcc = Account.SObjectType.getDescribe().getRecordTypeInfosByName().get('Booked Account').getRecordTypeId();
    
    //Id  recTypeAcc = [SELECT Id,Name FROM RecordType WHERE Name = 'Booked Account' LIMIT 1].Id;
    
    //compare old and new personal id from old and new map and create map to put new email id wrt account id 
    for( Account oldacc : accOldMap.values()){
       
            Account newAcc = accNewMap.get(oldacc.id);
            
            if(newAcc.RecordTypeId == recTypeAcc && newAcc.Personal_Email__pc != null && newAcc.Personal_Email__pc != '' && oldacc.Personal_Email__pc != newAcc.Personal_Email__pc ){
                {
                    accIds.add(newAcc.id);
                    emailmap.put(newAcc.id,newAcc.Personal_Email__pc);
                }
            }
       }

// filter on user object to update Email
        if(!accIds.isEmpty()){
    
        lstUser =[SELECT ContactId,
                         AccountId,
                         name,
                         id,
                         Email
                  FROM User 
                  where AccountId IN: accIds];
    
        for(User usr:lstUser){           
            usr.Email =  emailmap.get(usr.AccountId);           
        }
        if(!lstUser.isEmpty())
            update lstUser ;
        }
    
    blnIsExecuted = true;
    }
    }//updateUser
}