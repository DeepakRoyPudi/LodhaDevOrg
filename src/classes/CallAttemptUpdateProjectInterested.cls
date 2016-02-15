public class CallAttemptUpdateProjectInterested{
    public static void Updatemethod(Call_Attempts__c[] CA){      
        /* Creating a Call list for fetching the Previous data.               ////////////D/E/C//2/3//1/0//
        This is needed to update the Last Lead/Opportunity Call Attempt Status into the new field called Previous Call Attempt Status 
        */
        List<call_attempts__C> callList_temp=new List<call_attempts__C>();
        ID UniqueId=null;
        /* Above declaration is meant for fetching the Last Call Attempt status on Lead/Opportunity*/
        
        ////June 6 2011: The first Call Attempt at Opportunity was not updating the  Mobile Number at Call Attempt
        //Created the Opportunity object to address this issue
        List<Opportunity> opportunity_mobile=new List<Opportunity>();

        
        
        for (Call_Attempts__c C:CA) {

              ////////////D/E/C//2/3//1/0/////S/T/A/R/T////  Compro Code for upding the call attempt status 
         
              if(C.Opportunity__C!=null)
              {
                UniqueId=C.Opportunity__c;
              }
              else
              {
                UniqueId=C.Lead__c;
              }
              ////////////D/E/C//2/3//1/0///E/N/D////
              //Adding IsConverted into the query as excpetion was coming for the First Call Attempted Date after the lead is converted...
              Lead[] ld = [Select id,Status,First_Call_Attempted_Date__c,Project_Interested__c,Mobile__c, Isconverted from Lead where id =:C.Lead__c limit 1];
               if(ld.size() > 0)
               {
                   C.Project__c = ld[0].Project_Interested__c;
                   C.Mobile__c=ld[0].Mobile__c;
                   C.Lead_Status__c = ld[0].Status;
               }
               
           if(ld.size() > 0)
           {
               //Checking for NOT Converted Lead to update First Call Attempt date at Lead page...Exception was coming earlier for this...
               if((ld[0].First_Call_Attempted_Date__c == null) && (ld[0].Isconverted!=true))
               {
                   date myDate = date.today();
                   ld[0].First_Call_Attempted_Date__c = myDate;
                   update ld[0];
               }
           }
////////////D/E/C//2/3//1/0/////S/T/A/R/T////  Compro Code for upding the call attempt status 
            if(UniqueId!=null)
            {
                 if(C.Opportunity__C!=null)
                 {
                    ////Included the Opportuntiy Call Attempt in the query to update the Mobile number at Call Attempt with Opportunity Mobile Number. Refer to Lodha confirmation on 20 May 2011
                    callList_temp=[select id,Previous_Call_Attempt_Status__c, Call_Attempt_Status__c, Opportunity__r.Mobile_no__c, Opportunity__r.Call_Rating_ReadOnly__c  from call_attempts__C where Opportunity__c=: UniqueId  order by CreatedDate Desc limit 1];//Added by CGDev Team - 05/10/2011
                 }
                 else
                {
                    callList_temp=[select id,Previous_Call_Attempt_Status__c, Call_Attempt_Status__c  from call_attempts__C where lead__c=: UniqueId  order by CreatedDate Desc limit 1];
                 }
                if(callList_temp.size()>0)
                {
                    /*Updating the Call Attempt Status*/
                    //C.Call_Attempt_Status__c =callList_temp[0].Call_Attempt_Status__c ;
                    
                    /*Based on Lodha Mail of 05 January  2010 that it should update new field */
                    C.Previous_Call_Attempt_Status__c=callList_temp[0].Call_Attempt_Status__c ;
 
                    ////Update the Mobile number at Call Attempt with Opportunity Mobile Number. Refer to Lodha confirmation on 20 May 2011
                     if(C.Opportunity__C!=null)
                     {
                        C.Mobile__c=callList_temp[0].Opportunity__r.Mobile_no__c ;
                        C.Previous_Call_Attempt_Status_rating__c = callList_temp[0].Opportunity__r.Call_Rating_ReadOnly__c;   //Added by CGDev Team - 05/10/2011
                     }
                } 
//////////////////First the very first Call Attemtp Record at Opportunity, Mobile no was not getting updated. Appended the below code to address this issue
                else
                {
                ///Updating the First Call Attempt Record created for an Opportunity. After the first Call Attempt record, any new call Attempt record will be processed by the above condition 
                    if(C.Opportunity__C!=null)
                    {
                       opportunity_mobile=[select id, Mobile_no__c from Opportunity where Id=: UniqueId limit 1];
                       C.Mobile__c=opportunity_mobile[0].Mobile_no__c ;
                    }
                }
                ///////////////////////////////
                
              
            }
            ////////////D/E/C//2/3//1/0///E/N/D////

               //Integer CallCount;
               if(C.CampaignUsed__c != null){
               Campaign[] cc = [select Total_Call_Attempts__c from Campaign where id =:C.CampaignUsed__c Limit 1];
            if(cc.size() > 0){
               //Integer CCnt =[select count() from Call_Attempts__c where CampaignUsed__c =:C.CampaignUsed__c];             
              if(C.Counter__c == 0 && cc[0].Total_Call_Attempts__c != null){
               cc[0].Total_Call_Attempts__c = cc[0].Total_Call_Attempts__c + 1;
               C.Counter__c =1;
               update cc[0];}}
               }
              
            }
          }       

       
}