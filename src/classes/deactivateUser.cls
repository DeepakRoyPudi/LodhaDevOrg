public class deactivateUser {

    @future public static void deactivatePortalUser(ID[] accountidList){        
    //public static void deactivatePortalUser(ID[] accountidList){                       
        String subject;
        String Body;
        User[] userList = [Select id,IsPortalEnabled,firstname,lastname from User where Accountid IN:accountidList];
        List<USer> portalUserList = new List<User>();
        system.debug('!!!!!!!!!!!userlist'+userList+'-'+accountidList);
        if(userList.size()!= 0){  
            system.debug('!!!!!!!!!!!userlist111'+userList.size());
            for(User u:userList){  
                system.debug('!!!!!!!!!!!userlist222'+u.ISPORTALENABLED);              
                u.ISPORTALENABLED = false;
                system.debug('!!!!!!!!!!!userlist222111'+u.ISPORTALENABLED);      
                portalUserList.add(u);
            }              
        try{              
            update portalUserList;
            for(User a:portalUserList){
                Subject='Customer Portal User '+a.firstname+','+a.lastname+' disabled with UserId- '+a.id;
                Body='Hello CC Admin<br/><br/>Customer Portal user <b>'+a.firstname+','+a.lastname+'</b> with userid- '+a.id+' disabled in SFDC. Please Block his my lodha mailbox.<br/><br/>Regards,<br/>Lodha CC Admin.';
                send_email1(Subject,Body,sp_2_email_user_config__c.getinstance('Customer_portal_deactivation').User_Id__c);
            }
            
            System.debug('### Portal User Record Updated ###'+portalUserList); 
            
          }  
        catch(DMLException e){
              //system.assert(false,'Error updating portal User:'+e.getDMLMessage(0));
              system.assertNotEquals(e,null);
              System.debug('### Portal User Record Updated ###11'+e); 
          }
        }                             
    }
    
    @future public static void activatePortalUser(ID[] accountidList)
    {
        Id pId = [Select id from Profile where Name = 'Custom Overage High Volume Customer Portal'].id;              
        List<USer> portalUserList = new List<User>();
        List<Id> portalContactIds = new List<Id>();
        List<Id> portalUserIds = new List<Id>();
        map<id,Contact> accIdRecmapping = new Map<id,Contact>();
        map<id,Account> accIdAccRecmapping = new Map<id,Account>();
        List<Contact> contList = [Select id,accountid, email, firstname, lastname, mobilephone, Personal_Email__c  from Contact where Accountid IN:accountidList];
        Map<Id,Id> accIdConIdmapping = new Map<id,id>();        
        List<Account> accList = [Select id,CRN__c,Name from Account where id IN:accountidList]; 
        
        for(Account a:accList){
            accIdAccRecmapping.put(a.id,a);
            a.IsCustomerPortal = true;
        }       
        for(Contact c:contList){
            accIdConIdmapping.put(c.accountid,c.id);
            accIdRecmapping.put(c.accountid,c);
        }       
        if(accountidList.size()!= 0){
            for(Integer i = 0; i<accountidList.size();i++){
                User u = new User();
                u.Username = accIdRecmapping.get(accountidList[i]).Email;
                if(accIdRecmapping.get(accountidList[i]).firstName != null){
                u.LastName = accIdRecmapping.get(accountidList[i]).firstName + accIdRecmapping.get(accountidList[i]).LastName;
                }else{
                u.LastName = accIdRecmapping.get(accountidList[i]).LastName;
                }
                u.Email = accIdRecmapping.get(accountidList[i]).Personal_Email__c;
                u.profileid = pId;
                u.contactid = accIdConIdmapping.get(accountidList[i]);
                if((accIdRecmapping.get(accountidList[i]).lastName).length() > 4){
                u.alias = (accIdRecmapping.get(accountidList[i]).lastName).substring(0,4);
                }else{
                u.alias = (accIdRecmapping.get(accountidList[i]).lastName);
                }
                u.CommunityNickname = accIdAccRecmapping.get(accountidList[i]).CRN__c+'new';
                system.debug('u.accIdAccRecmapping '+accIdAccRecmapping);
                system.debug('u.CommunityNickname '+u.CommunityNickname);
                u.MobilePhone = accIdRecmapping.get(accountidList[i]).MobilePhone;
                u.TimeZoneSidKey = 'Asia/Kolkata';
                u.LocaleSidKey = 'en_IE_EURO';
                u.EmailEncodingKey = 'ISO-8859-1';
                u.LanguageLocaleKey = 'en_US';
                u.IsActive = true;
                //u.ISPORTALENABLED = true;
                portalUserList.add(u);
            }
        }              
        try{              
            insert portalUserList;
            for(User uList:portalUserList){
            portalContactIds.add(uList.ContactId);
            portalUserIds.add(uList.Id);
            System.resetPassword(uList.Id, true);
           }
            System.debug('### Portal User Record inserted ###'); 
          }  
        catch(DMLException e){
              system.assert(false,'Error inserting portal User:'+e.getDMLMessage(0));
          }
    }
    
    public static void send_email1(String subject, String html_body,string receipient_id) {
        system.debug('Subject: ' + subject + ' Html_body' + html_body + ' Id: ' + receipient_id);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        string[] toaddress=new string[]{receipient_id};
        mail.setBccSender(false);
        mail.setUseSignature(false);
        mail.setSubject(subject);
        mail.setHtmlBody(html_body);
        mail.setReplyTo('noreplay@LodhaGroup.com');
        mail.setSenderDisplayName('Lodha Admin');
        mail.setSaveAsActivity(false); 
        mail.settoaddresses(toaddress);
        if(Test.isRunningtest()==false){
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
}