trigger WelcomeEmailTaskEmailTrigger on Task (Before update) {
string Subject;
String html_body_new;
Map<id,Task> taskmap=new Map<id,Task>();
set<id> bookingisset=new set<id>();
Id RecordTypeId=[select id,name from recordtype where name='Welcome Email Task'].id;
for(Task a:Trigger.Old){
    taskmap.put(a.id,a);
    System.debug('!!!!!!!old task map'+a);
}

for(Task a:trigger.new){
    bookingisset.add(a.booking_id__c);
}
Map<id,string> LFCStatus=new Map<id,string>();
Map<id,SOCreation__c > SOUpdateMap=new Map<id,SOCreation__c >();
SpSOCreationCheckList mail=new SpSOCreationCheckList();

Map<id,Booking_Information__c> BookingMap=new Map<id,Booking_Information__c>([select id,City__c,Pincode__c,SALESORDER_NO__c,Address1__c,Address2__c,Address3__c,Name_of_Applicant__c,Base_Rate_Sq_ft_Rs__c,Base_Rate_Sq_ft_Actual_Rs__c,Application_Date__c,Oasys_Flat_Code__c,Flat__r.Wing__r.Project_Incharge_Relationship_Manager__r.name,Flat__r.Wing__r.Cluster__r.Project_Name__r.name,Flat__r.Wing__r.FAME_Back_end_RM__r.name,Flat__r.Wing__r.FAME_Back_end_RM__c,CRN_Number_SAP__c from Booking_Information__c where id IN:bookingisset]);
List<Welcome_Call_CheckList__c> WelcomeChecklistList=new List<Welcome_Call_CheckList__c>([select id,Booking_Information__c,Introduction_to_LFC__c,Welcome_Call_Status__c from Welcome_Call_CheckList__c where Booking_Information__c IN:bookingisset and Welcome_Call_Status__c='Accept']);
List<SOCreation__c> SoLst=[select id,Booking_Information__c,Welcome_Email_Task_Completed_Date__c,Issubmitted__c from SOCreation__c where Booking_Information__c IN:bookingisset and Issubmitted__c=true];
for(Welcome_Call_CheckList__c a:WelcomeChecklistList){
    LFCStatus.put(a.Booking_Information__c,a.Introduction_to_LFC__c);
}

for(SOCreation__c a:SoLst){
SOUpdateMap.put(a.Booking_Information__c,a);
}

System.debug('!!!!!!!BookingMap'+BookingMap);

for(Task a:trigger.new){
    System.debug('!!!!!!!inside for loop'+a);
    if(a.recordtypeid==RecordTypeId && a.status=='Completed' && taskmap.get(a.id).status != 'Completed'){
        System.debug('!!!!!!!inside for if loop'+a);
        //Email triggers....
        SOUpdateMap.get(a.booking_Id__c).Welcome_Email_Task_Completed_Date__c=date.today();
        Subject = 'Welcome Kit for SAP Id '+ BookingMap.get(a.booking_id__c).CRN_Number_SAP__c ; 
        html_body_new = 'Hello ' + BookingMap.get(a.booking_id__c).Flat__r.Wing__r.FAME_Back_end_RM__r.name + ','+ '<br/><br/>Customer <b>'+BookingMap.get(a.booking_id__c).Name_of_Applicant__c+'</b> with booking in '+BookingMap.get(a.booking_id__c).Oasys_Flat_Code__c+' in Project '+BookingMap.get(a.booking_id__c).Flat__r.Wing__r.Cluster__r.Project_Name__r.name+' on '+Date.ValueOf(BookingMap.get(a.booking_id__c).Application_Date__c)+' has been logged in SAP & his id is '+ BookingMap.get(a.booking_id__c).CRN_Number_SAP__c +'. <br/> We have committed 3 working days for receipt of his/her welcome kit. <br/><br/> Please dispatch the same to '+ BookingMap.get(a.booking_id__c).Address1__c+', '+ BookingMap.get(a.booking_id__c).Address2__c+', '+ BookingMap.get(a.booking_id__c).Address3__c+', '+BookingMap.get(a.booking_id__c).City__c+', '+BookingMap.get(a.booking_id__c).Pincode__c+' and confirm to us with POD number.<br/><br/>Regards, <br/>Lodha RM';
        mail.send_email(subject,html_body_new,BookingMap.get(a.booking_id__c).Flat__r.Wing__r.FAME_Back_end_RM__c); 
        if(LFCStatus.get(a.booking_id__c)=='Correct'){
            //Subject = 'Bank Funding for '+BookingMap.get(a.booking_id__c).Oasys_Flat_Code__c; 
            Subject = 'SAP ID -'+BookingMap.get(a.booking_id__c).SALESORDER_NO__c +' Bank Funding Customer'; 
            //html_body_new = sangeeta.parab@lodhagroup.com.sprint2'Hello ' + BookingMap.get(a.booking_id__c).Flat__r.Wing__r.FAME_Back_end_RM__r.name + ','+ '<br/><br/>Customer '+BookingMap.get(a.booking_id__c).Name_of_Applicant__c+' with booking in '+BookingMap.get(a.booking_id__c).Oasys_Flat_Code__c+' in Project '+BookingMap.get(a.booking_id__c).Flat__r.Wing__r.Cluster__r.Project_Name__r.name+' on '+BookingMap.get(a.booking_id__c).Application_Date__c+' is need bank funding.<br/><br/>Regards, <br/>Lodha RM';
            html_body_new = 'Hello Sangeeta,parab,<br/><br/>' +'Customer '+ BookingMap.get(a.booking_id__c).Name_of_Applicant__c +' with booking in '+BookingMap.get(a.booking_id__c).Oasys_Flat_Code__c+' , in '+BookingMap.get(a.booking_id__c).Flat__r.Wing__r.Cluster__r.Project_Name__r.name+' <br/>date '+BookingMap.get(a.booking_id__c).Application_Date__c+' has been logged in SAP & his id is '+BookingMap.get(a.booking_id__c).SALESORDER_NO__c +'.  During the Welcome Call the client has confirmed that the purchase of property would be funded by bank.<br/>You may take it up from here.<br/><br/>Regards, <br/>Lodha RM';
            //mail.send_email(subject,html_body_new,BookingMap.get(a.booking_id__c).Flat__r.Wing__r.FAME_Back_end_RM__c); 
            system.debug('@@@@@@@@@@@'+sp_2_email_user_config__c.getinstance('LFC_bank_funding_email').User_Id__c);
            mail.send_email(subject,html_body_new,sp_2_email_user_config__c.getinstance('LFC_bank_funding_email').User_Id__c);
            //mail.send_email1(subject,html_body_new,'kumaresan.m@capgemini.com');
        }
    }

}
Update SOUpdateMap.values();
}