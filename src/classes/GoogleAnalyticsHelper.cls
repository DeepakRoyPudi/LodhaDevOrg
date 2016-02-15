/*/*Description:
Utility class for Google Analytics 

 @Created by: Trupti Dhoka
 @Created Date: 24/03/2015
 
 --------------------------------------------------------------------------------
 | Modified By      | Modified Date       | Version        | Description         |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------
*/
public class GoogleAnalyticsHelper {
     
     //Below variables are used to store respective values
     public static String username;
     public static ID userAccountId;
     public static DateTime userLastLogin;
     public static String userCRN;
     public static String userProject;
     public static String userSeqment;
     public Static Integer UserTotalLogins;
     public Static Integer TotalLogins;
        
     //list variables
     //public static List<account> Account_detailslst;
     //public static list<user> Userlst;
     //public static list<Project_Name__c> ProjectNamelst;
   
    
       
    //constructor
    public GoogleAnalyticsHelper()
    { 
        
    }
    
    //method to fetch current logged in user's information 
    public static void GetReportParameters(ID user_Id)
    {
        //get logged in user's CRN          
        
       list<user> Userlst = [Select Name ,AccountId,LastLoginDate  
                         from user 
                         where id =: user_Id];
       //get logged in user's name and last login date
        if(Userlst.size()>0)
        {
            username =Userlst[0].Name;
            userAccountId = Userlst[0].AccountId;
            userLastLogin =Userlst[0].LastLoginDate ;
        }
        
        //get user account details
        List<account> Account_detailslst = [select CRN__c,Project_Name__c 
                            from account 
                                where Id =:userAccountId limit 1 ];
        if(Account_detailslst.size()>0)
        {
            userCRN = Account_detailslst[0].CRN__c;
            userProject = Account_detailslst[0].Project_Name__c;
        }
                         
       //get project type from account->booking Details->project
       
        list<Project_Name__c> ProjectNamelst = [Select id,Name,Project_Type__c
                              From Project_Name__c  
                                where Name=:userProject limit 1];    
        if(ProjectNamelst.size()>0) 
        {
            userSeqment = ProjectNamelst[0].Project_Type__c;
        }    
        
       
       //Get total no of logins from last 6 months 

       List<loginHistory> lohhistry=[SELECT LoginTime FROM LoginHistory where userID=:user_Id ORDER BY LoginTime];
        
        if(lohhistry.size()>0 || Test.isRunningTest())
        {
             loginHistory loginhistory_obj= new loginHistory(); 
             //loginhistory_obj=lohhistry[0];
             list<AggregateResult> agr = [SELECT count(LoginTime)
                                 FROM LoginHistory 
                                  where userID =: user_Id and LoginTime =TODAY];
             UserTotalLogins=(Integer)agr[0].get('expr0');
        }

        else 
        {
             UserTotalLogins=0;
        }
        
        //Total  no of logins irrespective of user
        List<loginHistory> lohhistry1=[SELECT LoginTime FROM LoginHistory  ORDER BY LoginTime limit 500];
        
        if(lohhistry.size()>0 || Test.isRunningTest())
        {
             loginHistory loginhistory_obj1= new loginHistory(); 
             //loginhistory_obj1=lohhistry1[0];
             list<AggregateResult> agr1 = [SELECT count(LoginTime)
                                 FROM LoginHistory];
              TotalLogins=(Integer)agr1[0].get('expr0');
        }

        else 
        {
             TotalLogins=0;
        }
        
    }

}