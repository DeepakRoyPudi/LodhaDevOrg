public class CM_SummaryReportHelper{
    

    public List<Case>filterCases(List<Case>caseList, DateTime startDateTime, DateTime endDateTime){
        System.debug('##########################');
        System.debug('CaseList received = ' + caseList + ', startDateTime Received => ' + startDateTime + ', endDateTime Received => ' + endDateTime);
        List<Case> filteredCaseList = new List<Case>();
    
        if (caseList != null && caseList.size() > 0){
            /* filtering cases created between given start date and end date */
            for(Case caseObj : caseList ){
                if (caseObj.createdDate >= startDateTime && caseObj.createdDate <= endDateTime){
                    filteredCaseList.add(caseObj);
                }
            }
        }
        System.debug('No of complaint cases created between << ' +  startDateTime +  ' >> and <<' +  endDateTime + '>> = ' + filteredCaseList.size());
    
        return filteredCaseList;
    }
    
    /*
    This method will generate a map which will contain account and booking details for diff accounts
    
        
                       
    */
    
    public Map<Id, List<String>> generateAccountMap(List<Case> caseList){
        Map<Id, List<String>> accountAndBookingDetailsMap;
        Set<Id> accountSet ;
        List<account> accountList;
        
        try{
            if (caseList != null && caseList.size() > 0){
                accountSet = new Set<Id>();
                accountAndBookingDetailsMap = new  Map<Id, List<String>>();
                for(Case caseObj: caseList ){
                    Account accTemp = null;
                    Booking_Details__c bookingObj= null;
                    accountSet.add(caseObj.account.Id);
                 }
                 System.debug('6.............................6...' + accountSet);
            }
            
            
            accountList = [select Id, name, Project_Name__c, owner.name, owner.email, owner.manager.name, owner.manager.email, CRN__c from Account where Id in : accountSet];
            System.debug('-------------4-------accountList -----------' + accountList );
            if (accountList != null && accountList.size() > 0){
                for(Account accObj : accountList ){
                    if (!accountAndBookingDetailsMap.containsKey(accObj.Id)){
                    
                        System.debug('~~~~~~~~~~~~~~~~~~accObj ' + accObj );
                       
                        List<String> accountAndBookingDetailsList = new List<String>();
                            /* adding project name [0] */
                        if (accObj != null && accObj.Project_Name__c != null)
                                accountAndBookingDetailsList .add(accObj.Project_Name__c);
                        else
                                accountAndBookingDetailsList .add(''); 
                         
                         
                         
                         ////////// [1]
                         
                         if (accObj != null && accObj .name != null)
                                accountAndBookingDetailsList .add(accObj.name);
                            else
                                accountAndBookingDetailsList .add('');
                                
                             /////////////////   [2]
                                
                        if (accObj != null && accObj .CRN__c!= null)
                                accountAndBookingDetailsList .add(accObj.CRN__c);
                            else
                                accountAndBookingDetailsList .add('');
                                
                                          
                        accountAndBookingDetailsMap.put(accObj.Id, accountAndBookingDetailsList );
                    }
                }
                
            }
            
            
            List<Booking_Details__c> bookingList = [ Select Name, CV_paid_New__c, Registration_Status__c, CLuster__c, Wing__c, Flat_No__c, Application_Date__c, Consideration_Value__c, account__c from Booking_details__c where Account__c in : accountSet ];
            System.debug('-------------4-------bookingList ' + bookingList );
            
             if (bookingList != null && bookingList .size() > 0){
                for(Booking_Details__c bookingObj : bookingList ){
                    if (bookingObj != null){
                        if (accountAndBookingDetailsMap.containsKey(bookingObj.account__c) ){
                            List<String> accountAndBookingDetailsList = accountAndBookingDetailsMap.get(bookingObj.account__c );
                          
                            if(bookingObj.CLuster__c != null)
                                accountAndBookingDetailsList.add(bookingObj.CLuster__c);
                            else
                                accountAndBookingDetailsList.add('');
                            
                           
                             if (bookingObj.Wing__c != null)
                                accountAndBookingDetailsList .add(bookingObj.Wing__c);
                            else
                                accountAndBookingDetailsList .add(''); 
                                    
                                                         
                          if (bookingObj != null && bookingObj.Flat_No__c != null)
                                accountAndBookingDetailsList .add(bookingObj.Flat_No__c);
                            else
                                accountAndBookingDetailsList .add(''); 
                                
                          
                         if (bookingObj != null && bookingObj.Application_Date__c != null)
                                accountAndBookingDetailsList .add(String.valueOf(bookingObj.Application_Date__c));
                            else
                                accountAndBookingDetailsList .add(''); 
                                                  
                          
                        
                           if (bookingObj != null && bookingObj.Registration_Status__c != null)
                                accountAndBookingDetailsList .add(bookingObj.Registration_Status__c);
                            else
                                accountAndBookingDetailsList .add('');
                                
                           
                                      
                           if (bookingObj != null && bookingObj.Consideration_Value__c != null)
                                accountAndBookingDetailsList .add(String.valueOf(bookingObj.Consideration_Value__c));
                            else
                                accountAndBookingDetailsList .add('');
                                
                            
                                            
                           if (bookingObj != null && bookingObj.CV_paid_New__c != null)
                                accountAndBookingDetailsList .add(String.valueOf(bookingObj.CV_paid_New__c));
                            else
                                accountAndBookingDetailsList .add('');   
                            
                            
                            
                               
                            accountAndBookingDetailsMap.put(bookingObj.account__c, accountAndBookingDetailsList);
                        }
                       
                    }
                }

             }
             
             System.debug('-------------7------accountAndBookingDetailsMap ' + accountAndBookingDetailsMap);
            
        }catch(Exception ex){
            System.debug('Exception = ' + ex);
        }
        
        return accountAndBookingDetailsMap ;
    }

    
    public void execute(List<Case> caseList, boolean caseCreateNotification, DateTime reportDate, String reportType, boolean isComplaintCase){
        String fromEmailId = '';
        String fromDisplayName = '';
        DateTime reportDateTime;
        Account accObj = new Account();
        Booking_Details__c bookingObj = new Booking_Details__c();
    
        String emailContents = '';
        String emailAttachment = '';
    
        fromDisplayName = 'Lodha Admin';
        fromEmailId = 'donotreply@lodhagroup.com';
        System.debug('fromDisplayName = ' + fromDisplayName + ', fromEmailId = ' + fromEmailId );
       
        Map<Id, List<String>> caseDetailMap = null;
        System.debug('List of cases = ' + caseList );
        if(caseList != null){
            System.debug('No of cases = ' + caseList.size() );
            caseDetailMap = generateAccountMap(caseList);
        }
        System.debug('~~~~~~~~~~~~~~~~~caseDetailMap  ' + caseDetailMap);
        
        
        Map<Id, List<Case>> childCasesMap = getChildCases(caseList);
        System.debug('~~~~~~~~~~~~~~~~~~~~~~childCasesMap  returned ' + childCasesMap );
        
        
        Map<Id, List<String>> activityHistoryMap = getActivityHistory(caseList);
        System.debug('~~~~~~~~~~~~~~~~~~~~~~activityHistoryMap returned ' + activityHistoryMap );
         
        /* Generating Email Table Data */
        emailContents = getEmailContentsForSummaryReport(caseList, accObj, bookingObj,reportDate );
        emailAttachment = getEmailAttachmentForSummaryReport(caseList, accObj, bookingObj , caseDetailMap, childCasesMap , activityHistoryMap );
        //System.debug('~~~~~~~~~In summary '+ ' ~~~~~~~ emailAttachment '+emailAttachment );
        
        
        if(emailAttachment != null && !emailAttachment.equals('')){
           //AKG 
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setHTMLBody(emailContents);
        
            //from details
            System.debug('before setting to mail ==> fromDisplayName = ' + fromDisplayName + ', fromEmailId =' + fromEmailId);
            mail.setSenderDisplayName(fromDisplayName );
            mail.setReplyTo(fromEmailId );
        
            //to details
            Set<String> toEmailIdSet = getToEmailIds();
            mail.setToAddresses(new List<String>(toEmailIdSet)); 
             
            //cc details
            Set<String> ccEmailIdSet = getCCEmailIds(caseList);
            System.debug('--------ccmEmailIdSet -----------' + ccEmailIdSet );
            mail.setCCAddresses(new List<String>(ccEmailIdSet));   

            //bcc details
            Set<String> bccEmailIdSet = getBccEmailIds();
            System.debug('--------bccEmailIdSet -----------' + bccEmailIdSet );
            mail.setBCCAddresses(new List<String>(bccEmailIdSet)); 
       
            //subject
            String subject = getSubject(accObj.project_name__c, accObj.name, reportDate, reportType, isComplaintCase);
            System.debug('--------subject -----------' + subject );
            mail.setSubject(subject );
        
            if (emailAttachment != null && !emailAttachment.equals('')){
                Messaging.EmailFileAttachment excelAttchment = new Messaging.EmailFileAttachment();
                blob excelBlob = Blob.valueOf(emailAttachment);
                
                String filename = 'Customer Complaints and Grievance Cases For ' + reportDate.day() + '-' + reportDate.month() + '-' + reportDate.year() + '.xls' ;
                System.debug('----------filename ------------' + filename );                        
                excelAttchment.setFileName(filename );
                
                excelAttchment.setBody(excelBlob );
                mail.setFileAttachments(new Messaging.EmailFileAttachment[]{excelAttchment});
            }
                    
           /* List<String> l = new List<String>();
            l.add('shruti.samant@capgemini.com');
            l.add('aalokkumar.gupta@capgemini.com'); 
            mail.setToAddresses(l); */
           
           System.debug('===== Sending Email');
           Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
           System.debug('===== Email Sent');
        } 
    }
    
               
    public  Set<String> getToEmailIds(){
        Set<String> toEmailIdSet = new Set<String>();
        
        for (CM_Reporting_EmailIds__c[] toEmailIdList :[SELECT email_Id__c FROM CM_Reporting_EmailIds__c WHERE To_CC_Bcc__c in ('to', 'TO', 'tO', 'To') and Report_Type__c = 'Summary']){
            for(CM_Reporting_EmailIds__c  emailId : toEmailIdList ){
                toEmailIdSet .add(emailId .email_Id__c );
            }
        }
        
        System.debug('--------toEmailIdSet -----------' + toEmailIdSet);
        return toEmailIdSet ;
    }
    
    
    /**
    This method will return email ids of case onwer and his TL
    */
    public Set<String> getCCEmailIds(List<Case> cases){
        Set<String> ccEmailIdSet = new Set<String>();
        
        for ( CM_Reporting_EmailIds__c[] ccEmailIdList : [SELECT Email_Id__c FROM CM_Reporting_EmailIds__c WHERE To_CC_Bcc__c in ('cc', 'CC', 'cC', 'Cc') and Report_Type__c = 'Summary']){
            for(CM_Reporting_EmailIds__c  emailId : ccEmailIdList ){
                ccEmailIdSet .add(emailId .email_Id__c );
            } 
        }
        
        if (cases != null && cases.size() > 0){
                System.debug('getCCEmailIds= 2....' );

                for(Case caseObj: cases){
                    System.debug('getCCEmailIds= 3....' );
    
                    if(caseObj != null && caseObj.TL_EmailId__c != null && !caseObj.TL_EmailId__c.equals('')){
//                        System.debug('getCCEmailIds= 5....' + caseObj.TL_EmailId__c);
                        ccEmailIdSet.add(caseObj.Tl_EmailId__c);
                    }
                    
                    if(caseObj != null && caseObj.PIC_EmailId__c != null && !caseObj.PIC_EmailId__c.equals('')){
//                        System.debug('getCCEmailIds= 6....' + caseObj.PIC_EmailId__c);
                        ccEmailIdSet.add(caseObj.PIC_EmailId__c);
                    } 
            }//for 
        }//if 
        
        System.debug('8.........................'  + ccEmailIdSet);
        return ccEmailIdSet ;
    }
    
    
   
    
    public Set<String> getBccEmailIds(){
        Set<String> bccEmailIdSet = new Set<String>();
        
        for ( CM_Reporting_EmailIds__c[] bccEmailIdList : [SELECT Email_Id__c FROM CM_Reporting_EmailIds__c WHERE To_CC_Bcc__c in ('BCC','Bcc','BCc','BcC','bCC','bcC','bCc','bcc') and Report_Type__c = 'Summary']){
            for(CM_Reporting_EmailIds__c  emailId : bccEmailIdList ){
                bccEmailIdSet .add(emailId .email_Id__c );
            } 
        }
        
        return bccEmailIdSet ;
    }
    
    public String getSubject(String projectName , String customerName, DateTime reportDate, String reportType, boolean isComplaintCase){
        String subject = '';
        if ( reportType != null && reportType.equals('Summary')){
            subject = 'Customer Complaints and Grievance Cases For ' + reportDate.day() + '-' + reportDate.month() + '-' + reportDate.year() ;
        }
        return subject;
    }
   
   public Map<Id, List<String>> getActivityHistory(List<Case> caseList){
        List<ActivityHistory> ahList = new List<ActivityHistory>();
        List<String> activityURLs = new List<String>();
        Set<Id> caseIdsSet = new Set<Id>();
        Case [] caseActivityList;
        Map<Id, List<String>> activityHistroryMap = new Map<Id, List<String>>();
        
        try{
            if (caseList != null && caseList.size() > 0){
                for(Case caseObj: caseList){
                    caseIdsSet.add(caseObj.Id);
                }
            }
            caseActivityList =  [SELECT Id, casenumber, ( SELECT Unique_Call_ID__c, ActivityType, WhatId FROM ActivityHistories ) FROM Case WHERE Id in : caseIdsSet];
            System.debug('------caseActivityList  ------------ = ' + caseActivityList  );
                
            if (caseActivityList != null && caseActivityList.size() > 0){
                for(Case caseObj: caseActivityList ){
                    activityURLs = new List<String>();
                    if (caseObj != null){
                        Id caseId = caseObj.Id;
                        ahList  = caseObj.getSObjects('ActivityHistories');
                        if(ahList != null && ahList.size() > 0){
                            for (ActivityHistory ah : ahList) {
                                System.debug('------------------Unique_Call_ID__c =' + ah.Unique_Call_ID__c);
                                if(ah.Unique_Call_ID__c != null && !ah.Unique_Call_ID__c.equals('')){
                                    activityURLs.add(ah.Unique_Call_ID__c);
                                }
                            }
                        }
                        if(activityURLs != null && activityURLs.size() > 0){
                            if (!activityHistroryMap.containsKey(caseId )){
                                activityHistroryMap.put(caseId , activityURLs);
                            }
                        }
                    }
                }
            }
        }catch(Exception ex){
            System.debug('Error in CM_CustomReportGenerator_MORN - getActivityHistory => ' + ex.getMessage());
        } 
        
        return activityHistroryMap;
} 
    
    
    
   public Map<Id, List<Case>> getChildCases(List<Case> parentCasesList){
    Set<Id> parentCasesSet = new Set<Id>();
    Map<Id, List<Case>> childCasesMap = new Map <Id, List<Case>>();
        
    try{
        if (parentCasesList != null && parentCasesList.size() > 0){
            for(Case parentCaseObj: parentCasesList){
                parentCasesSet.add(parentCaseObj.Id);
            }
        }
            
        List<Case> childCaseList = [Select Id, CaseNumber, CaseType__c, owner.Name, status, parent.Id from Case Where parent.Id in : parentCasesSet ];
        if (childCaseList != null && childCaseList.size() > 0){
            for(Case childCaseObj : childCaseList){
                Id parentCaseId = childCaseObj.parent.Id ;
                List<Case> childList = new List<Case>(); 
                if(childCasesMap.containsKey(parentCaseId)){
                    childList = childCasesMap.get(parentCaseId);
                    childList.add(childCaseObj);
                }else{
                    childList = new List<Case>();
                    childList.add(childCaseObj);
                }
                childCasesMap.put(parentCaseId, childList);
            }
        }
    }catch(Exception ex){
        System.debug('Error in CM_CustomReportGenerator_MORN - getChildCases => ' + ex.getMessage());
    }
    
    return childCasesMap;
} 
    
  
    
    public String getEmailContentsForSummaryReport(List<Case> caseList, Account accObj, Booking_Details__c bookingObj,DateTime reportDate ){
        String returnValue = '';
        if (caseList != null && caseList.size() > 0){
            returnValue  ='Dear All,<br><br> PFA the summary report of the “Complaint” Cases and “Grievance” Cases reported for '+reportDate.format('dd-MM-yyyy')+'. <br><br>Regards,<br>Admin IT<br><br>Note: This is a system generated report. Do not reply to this email. ';
        }
        return returnValue ;
        
    }


    public String getEmailAttachmentForSummaryReport(List<Case> caseList, Account accObj, Booking_Details__c bookingObj, Map<Id, List<String>> caseDetailMap, Map<Id, List<Case>> childCasesMap, Map<Id, List<String>> activityHistoryMap){
        String contents = '';

        String tabChar = '\t';
        String emptyChar = '-';
        
        System.debug('1.......................caseDetailMap ' + caseDetailMap);
        if (caseList != null && caseList.size() > 0){
            contents = 'Project Name\tCase Number\tDate and time stamp of case creation\tDate of Complaint / Date of Grievance\tProject Team Leader\tFlat details\tCustomer name\tBooking Date\tRegistration Status\tTotal CV amount\t% CV paid\tInteraction Mode\tNature of Request\tComplaint Type-L1\tComplaint Type-L2\tComplaint Type-L3\tTAT allowed for case closure\tCase Priority\tDependency on Internal Lodha Functions\tCase Status\tCustomer Email/Call Link\tCase Link in SFDC to view complete customer interaction history\tComplaint Summary\tComplaint Resolution\n';
            //system.debug('~~~~~~~~~~~~~~~~~~~~~~~~~~~~caseList order check '+caseList);
            for(Case caseObj: caseList){
                String projectName = '';
                String cluster = '';
                String wing = '';
                String flatNo = '';
                String accountName = '';
                String applicationDate = '';
                String registrationStatus = '';
                String considerationValue = '';
                String cvPaid= '';
                String crn = '';

                System.debug('2... ~~~~~~caseObj.Account.Id~~~~' + caseObj.Account.Id);
                if (caseDetailMap.containsKey(caseObj.Account.Id)){
                    system.debug('3.. in if....caseDetailMap.get(caseObj.Account.Id).get(1).........~~~~~'+caseDetailMap.get(caseObj.Account.Id).get(1));
                    // If the Account does not have booking details then assigning only account details - Asmita- 12/6
                    if(caseDetailMap.get(caseObj.Account.Id).size() <= 3){
                    	projectName = caseDetailMap.get(caseObj.Account.Id).get(0);
	                    accountName = caseDetailMap.get(caseObj.Account.Id).get(1);
	                    crn = caseDetailMap.get(caseObj.Account.Id).get(2);
                    }
                    else{
                    	
                    	projectName = caseDetailMap.get(caseObj.Account.Id).get(0);
	                    cluster = caseDetailMap.get(caseObj.Account.Id).get(3);
	                    wing = caseDetailMap.get(caseObj.Account.Id).get(4);
	                    flatNo = caseDetailMap.get(caseObj.Account.Id).get(5);
	                    accountName = caseDetailMap.get(caseObj.Account.Id).get(1);
	                    applicationDate = caseDetailMap.get(caseObj.Account.Id).get(6);
	                    registrationStatus = caseDetailMap.get(caseObj.Account.Id).get(7);
	                    considerationValue = caseDetailMap.get(caseObj.Account.Id).get(8);
	                    cvPaid = caseDetailMap.get(caseObj.Account.Id).get(9);
	                    crn = caseDetailMap.get(caseObj.Account.Id).get(2);
                    	
                    }
                    
                }  
                
                /* project name */          
                contents += projectName.toUpperCase();
                contents += tabChar ;
            
                // Case Number
                contents += caseObj.caseNumber ;
                contents += tabChar ;
    
                // Date and time stamp of case creation
                if (caseObj.createdDate != null){
                    contents += caseObj.createdDate.format('dd-MM-yyyy, hh:mm a') ;
                }else{
                    contents += '' ;
                }
                                    
                contents += tabChar ;
    
                //Date of Complaint or Date of Grievance 
                if (caseObj.Nature_of_Request__c!= null && caseObj.Nature_of_Request__c.equals('Complaint')){
                    if(caseObj.Date_of_Complaint__c != null && !((String.valueOf(caseObj.Date_of_Complaint__c)).equals(''))){
                        contents += caseObj.Date_of_Complaint__c.format('dd-MM-yyyy, hh:mm a') ;
                    }else{
                        contents += emptyChar ;
                    }
                }else if (caseObj.Nature_of_Request__c!= null && caseObj.Nature_of_Request__c.equals('Grievance')){
                    if(caseObj.Date_of_Grievance__c != null && !((String.valueOf(caseObj.Date_of_Grievance__c)).equals(''))){
                        contents += caseObj.Date_of_Grievance__c.format('dd-MM-yyyy, hh:mm a') ;
                    }else{
                        contents += emptyChar ;
                    }
                }else{
                    contents += emptyChar ;
                }
                contents += tabChar ;
                
                //Project Team Leader
                if (caseObj.TL__c != null){
                    contents +=  caseObj.TL__c;
                }else{
                    contents += emptyChar ;
                }
                contents += tabChar ;
    
                // Flat details
                contents +=  cluster + ' ' + wing + ' ' + flatNo;
                contents += tabChar ;        
    
                // Customer name
                contents += accountName+' , CRN- ' + crn ;
                contents += tabChar ;     
            
                // Booking Date
                contents += applicationDate;
                contents += tabChar ;  
                
                /* Registration status */
                contents +=  registrationStatus;
                contents += tabChar ;  
                  
                /* cv */
                contents += considerationValue;
                contents += '\t';          
                 
                /* % cv paid */
                contents +=  cvPaid;
                contents += tabChar ; 
    
                //Interaction Mode
                if (caseObj.Interaction_Mode__c != null){
                    contents += caseObj.Interaction_Mode__c;
                }else{
                    contents += emptyChar ;
                }
                contents += '\t';
                        
                //Nature of Request
                if (caseObj.Nature_of_Request__c!= null){
                    contents += caseObj.Nature_of_Request__c;
                }else{
                    contents += emptyChar ;
                }
                contents += tabChar ;
     
                //  Complaint Type-L1
                if(caseObj.Request_for_L1__c != null){
                    contents += caseObj.Request_for_L1__c;}
                else{
                    contents += emptyChar ;
                }
                contents += '\t';        
                            
                //  Complaint Type-L2
                if(caseObj.Request_for_L2__c != null){
                    contents += caseObj.Request_for_L2__c;
                }else{
                    contents +=emptyChar ;
                }
                contents += tabChar ;            
                            
                // Complaint Type-L3
                boolean flagL3A, flagL3B;
                String L3data = '';
                if (caseObj.Request_for_L3_a__c != null){
                    flagL3A = true;
                    L3data += caseObj.Request_for_L3_a__c;
                }
                if (caseObj.Request_for_L3__c != null){
                    flagL3B = true;
                    L3data += caseObj.Request_for_L3__c;
                }  
                if (flagL3A == false && flagL3B == false){
                    L3data = '-';
                }
                contents +=   L3data ;                
                contents += tabChar ;             
        
                //   TAT allowed for case closure
                if (caseObj.Remaining_Hours__c != null){
                    Integer remainingHours = Integer.valueOf(caseObj.Remaining_Hours__c);
                    contents += String.valueOf(remainingHours );
                    contents += ' ';
                    contents += 'Hours';
                }else{
                    contents +=  emptyChar ;  
                }
                contents += tabChar ;
                            
                //  Case Priority
                if (caseObj.priority != null){
                    contents += String.valueOf(caseObj.priority);
                }else{
                    contents += emptyChar ; 
                }
                contents += tabChar ;
                    
                //  Dependency on Internal Lodha Functions 
                boolean childCasesExists = false;
                boolean dependencyCommentsExist = false;
    
                String childCasesData = '';
                String dependencyCommentsData = '';
                String cellData = '';
                
                //Set<Case> childCasesList = getChildCases(caseObj);
                List<Case> childCasesList = new List<Case>();
                if(childCasesMap.containsKey(caseObj.Id)){
                    childCasesList = childCasesMap.get(caseObj.Id);
                }
                
                
                System.debug('-----------childCasesList --------------------------'+ childCasesList );
                
                
                if(childCasesList != null && childCasesList.size() > 0){
                    childCasesExists = true;
               
                    childCasesData += 'Case Number : Assignee : Status | ';
                
                    for(Case childCaseObj : childCasesList ){
                        childCasesData +=  childCaseObj.CaseNumber + ':';
                        childCasesData +=  childCaseObj.owner.Name + ':';
                        childCasesData += childCaseObj.status + '|';
                    }
                }
                System.debug('~~~~~childCasesData = ' + childCasesData );
                
                dependencyCommentsData  = caseObj.Dependency_on_Internal_functions__c;
                System.debug('~~~~~dependencyCommentsData  = ' + dependencyCommentsData  );

                if (dependencyCommentsData != null && !dependencyCommentsData .equals('')){
                    dependencyCommentsExist = true;
                }
                if (!childCasesExists && !dependencyCommentsExist ){
                    cellData = 'Nil';
                }
                if (!childCasesExists && dependencyCommentsExist ){
                    cellData = dependencyCommentsData;
                }
                if (childCasesExists && !dependencyCommentsExist ){
                    cellData = childCasesData;
                }
                if (childCasesExists && dependencyCommentsExist ){
                    cellData = childCasesData;
                    cellData += dependencyCommentsData ;
                }
                System.debug('cellData = ' + cellData );
                
                if (cellData != null){
                    contents += cellData ;
                }else{
                    contents += emptyChar ;
                }
            //    System.debug('......cellData =................' + cellData );
                contents += tabChar ; 
    
                //  Case Status
                if (caseObj.Status  != null){
                    contents += caseObj.Status ;
                }else{
                    contents += emptyChar ;
                }
                contents += tabChar ;           
                
                    
                //Customer Email/Call Link
   
              List<String> activityHistoryList;
                  if (activityHistoryMap.containsKey(caseObj.Id)){
                      activityHistoryList = activityHistoryMap.get(caseObj.Id);
                  }
                  
                if(activityHistoryList != null && activityHistoryList.size() > 0){
                    for(String ahObj : activityHistoryList ){
                        if (ahObj != null && !ahObj.equals('')){
                        
                            contents += ahObj ;
                            //contents += '=HYPERLINK("'+ ahObj + '")' ;
                            contents += '|' ;
                        }
                    }
                }else{
                    contents += emptyChar ;
                }
                contents += tabChar ;  
    
                /* case link */
                String hostname = 'https://';
                hostname += System.URL.getSalesforceBaseUrl().getHost();
               // System.debug('--------hostname = ----------------------------' + hostname );
                hostname += '/';
                hostname += caseObj.Id;
                
                contents +=   '=HYPERLINK("'+ hostname + '")'  ;          
                contents += tabChar ;        
    
                //Complaint Summary
                if (caseObj.Case_Summary__c != null){
                   
                     String replaceStr = caseObj.Case_Summary__c.replace('\r\n','. ');                  
                   
                    contents += replaceStr ;


                }else{
                    contents += emptyChar;
                }
                contents += tabChar ;
                        
                //Complaint Resolution
                String caseResolution = '';
                if (caseObj.Case_Resolution__c != null){
                   
                    String replaceStr = caseObj.Case_Resolution__c.replace('\r\n','. ');
                    contents += replaceStr;
                }else{
                    contents += emptyChar;
                }
                contents += '\n';
                   //System.debug('end of iteration.....................' + contents  );
            }
           // System.debug('after for.......================' +  contents);
        }
        System.debug('returning contents================' +  contents);
        return contents;
    }

}