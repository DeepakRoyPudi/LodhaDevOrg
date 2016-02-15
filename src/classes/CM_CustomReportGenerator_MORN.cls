/**********************************************************************************
Name: CM_CustomReportGenerator_MORN
Copyright © 2012 Lodha Group
===================================================================================
===================================================================================
Purpose:
-------
Class to send Emails for Escalated cases
===================================================================================
===================================================================================
History
-------
VERSION AUTHOR DATE DETAIL 
1.0 - CG Dev Team 05/12/2013 INITIAL DEVELOPMENT
**********************************************************************************/

/*********************************************************************
Purpose : To Send custom email
Parameters : None
Returns : None
**********************************************************************/ 


global class CM_CustomReportGenerator_MORN implements Database.Batchable <sObject> {

    List<CM_Reporting_EmailIds__c> toEmailIdList = [SELECT Id, Name, Email_Id__c, Report_Type__c, To_CC_Bcc__c FROM CM_Reporting_EmailIds__c WHERE To_CC_Bcc__c = 'To' and Report_Type__c = 'Director'];    
    List<CM_Reporting_EmailIds__c> ccEmailIdList = [SELECT Id, Name, Email_Id__c, Report_Type__c, To_CC_Bcc__c FROM CM_Reporting_EmailIds__c WHERE To_CC_Bcc__c = 'cc' and Report_Type__c = 'Director'];    
    //List<CM_Reporting_EmailIds__c> bccEmailIdList = [SELECT Id, Name, Email_Id__c, Report_Type__c, To_CC_Bcc__c FROM CM_Reporting_EmailIds__c WHERE To_CC_Bcc__c = 'bcc'and Report_Type__c = 'Director' ];    

    String emailCCRM = '';
    String emailCCRMTL = '';
    String subject = '';
    public List<Case> caseList;
    DateTime startDate;
    DateTime endDate;
    public String query= '';
    
    /* start */
    global Database.QueryLocator start(Database.BatchableContext obj){
       
        try{
            query = 'Select CreatedDate, Flat_Details__c, Interaction_Mode__c, Nature_of_Request__c, Request_for_L1__c, Request_for_L2__c, Request_for_L3_a__c, Request_for_L3__c, Latest_Comment__c, Case_Summary__c, Case_Resolution__c, Status, account.name, TAT__c, CRN__r.CV_paid__c, CRN__r.CLuster__c, account.CRN__c, TL_EmailId__c, Owner_EmailId__c, TL__c, priority, account.Project_Name__c, account.Id from case where Nature_of_Request__c =\'Complaint\' ';
            System.debug('Query = ' + query );
        }catch(Exception ex){
            System.debug('Error in CM_CustomReportGenerator_MORN -> Start => '+ ex);
        }
        
        return Database.getQueryLocator(query);
    }
    
    /* execute */
    global void execute(Database.BatchableContext obj, List<Case> caseList){
        System.debug('List of complaint cases retrived = ' + caseList);
        
        Map<String, List<Case>> customerMap = new Map<String, List<Case>>() ;
        
        if (caseList != null && caseList.size() > 0){
            System.debug('Total no of complaint cases retrieved = '+ caseList.size());
            
            /* filtering only those complaint cases created between yesterday 8 am and 3 pm */
            List<Case> tempCaseList = filterCases(caseList);
            System.debug('Complaint cases created between yesterday 8 am and 3 pm = ' + tempCaseList );
            
            /* Mapping cases to customers */
            if (tempCaseList != null && tempCaseList .size() > 0){
                customerMap = mapCasesToCustomers(tempCaseList);
                System.debug('CustomerMap created = ' + customerMap );
            }

            if(customerMap != null){
                for (String customerKey : customerMap.keySet()){
                    System.debug('Key = ' + customerKey);
            
                    List<Case> cases = customerMap.get(customerKey);
                    System.debug('List of cases = ' + cases );
                    System.debug('No of cases = ' + cases.size() );
        
                    /* Generating Email Table Data */
                    String emailContents = '';
                    emailContents += generateTableData(cases);
                
                    System.debug('Overall table data = ' + emailContents);
                
                    String projectName = '-';
                    if(cases[0].account.Project_Name__c != null){
                        projectName = cases[0].account.Project_Name__c;
                    }
                    
                    String clusterName = '-';
                    if(cases[0].CRN__r != null && cases[0].CRN__r.CLuster__c != null){
                        clusterName = cases[0].CRN__r.CLuster__c;
                    }
                    
                    String customerName = '-';
                    if(cases[0].account != null && cases[0].account.name != null){
                        customerName = cases[0].account.name;
                    }
                    
                   Set<String> rm_TL_emailIdSet = getCCEmailIds(cases);
                    
                   sendEmail(rm_TL_emailIdSet, emailContents, projectName, clusterName, customerName); 

                }//end of for */
            }//end of customerMap != null
        }
    }        

    global void finish(Database.BatchableContext obj){
    }
    
    
    /**
    This method will return email ids of case onwer and his TL
    */
    public Set<String> getCCEmailIds(List<Case> cases){
        Set<String> ccEmailIdSet = new Set<String>();
        
        System.debug('getCCEmailIds= 1....' + cases);

        if (cases != null && cases.size() > 0){
            System.debug('getCCEmailIds= 2....' );

            for(Case caseObj: cases){
                System.debug('getCCEmailIds= 3....' );
                if(caseObj != null && caseObj.Owner_EmailId__c != null && !caseObj.Owner_EmailId__c.equals('')){
                    System.debug('getCCEmailIds= 4....' + caseObj.Owner_EmailId__c);
                    ccEmailIdSet.add(caseObj.Owner_EmailId__c);
                }

                if(caseObj != null && caseObj.TL_EmailId__c != null && !caseObj.TL_EmailId__c.equals('')){
                    System.debug('getCCEmailIds= 5....' + caseObj.TL_EmailId__c);
                    ccEmailIdSet.add(caseObj.Tl_EmailId__c);
                }
            }
        }
        
        return ccEmailIdSet ;
    }
    
    
    
    /* This method will return all complaint cases created
        between yesterday 8 am and 3 pm */
    public List<case> filterCases(List<Case> caseList ){
        List<case> tempList = new List<Case>();
        
        /* Creating date instance for YESTERDAY 8 AM */
        Time startTime  = Time.newInstance(8,0,0,0);
        startDate = DateTime.newInstancegmt((Date.today()).addDays(-1), startTime);
        System.debug('startDate => ' + startDate );

        /* Creating date instance for YESTERDAY 3 PM */
        Time endTime  = Time.newInstance(15,0,0,0);
        endDate = DateTime.newInstancegmt((Date.today()).addDays(-1), endTime );
        System.debug('endDate => ' + endDate );

        /* filtering cases created between yesterday 8 am and 3 pm */
        for(Case caseObj : caseList ){
            DateTime caseCreateDate = DateTime.newInstancegmt(caseObj.createdDate.date(), caseObj.createdDate.time());
            //System.debug('id = ' + caseObj.Id + '-------- created date => ' + caseObj.createdDate + '----caseCreateDate = ' +  caseCreateDate );

            if (caseCreateDate >= startDate && caseCreateDate <= endDate ){
                tempList.add(caseObj);
             }
        }
        System.debug('No of complaint cases created between yesterday 8 am & 3 pm = ' +  tempList.size());
        
        return tempList ;
        
    }
    
    
    
    
    /* This method will return a map with
    CRN as key and List of complaint cases against the customer as data */
    public Map<String, List<Case>> mapCasesToCustomers(List<Case> caseList){
        Map<String, List<Case>> customerMap = new Map<String, List<Case>>();
        List<Case> customerCasesList;
        
        System.debug('Complaint case List Received = ' + caseList);
        
        try{
            for(Case caseObj: caseList){
                 if (caseObj.account != null && caseObj.account.CRN__c != null){
                    String key = caseObj.account.CRN__c;
                    if(customerMap.containsKey(key)){
                        customerCasesList = (LIST<Case>)customerMap.get(key);
                        customerCasesList.add(caseObj);
                        customerMap.put(key, customerCasesList);
                    }else{
                        customerCasesList = new List<Case>();
                        customerCasesList.add(caseObj);
                        customerMap.put(key, customerCasesList);
                    }
                }
            }
        }catch(Exception ex){
            System.debug('Error in CM_CustomReportGenerator_MORN - mapCasesToCustomers => ' +  ex.getMessage());
        }
        
        return customerMap;
    }
    
    
    /* This method generates Data for the cases table */ 
    public String generateTableData(List<Case> caseList){
        String emailData= '';
        String style = 'style="border:0.1px dotted;"';
        
        try{
            if (caseList != null && caseList.size() > 0){
                emailData += '<html><body><font face="calibri"><h1>Escalation for ' + startDate.day() + '-' + startDate.month() + '-' + startDate.year() + '</h1>';
               
                for(Case caseObj: caseList){
                    emailData += '<br><table style="border:0.1px solid;" cellspacing="0" cellpadding="0"><font face="calibri">';
                    emailData += '<tr bgcolor="E3D8DA"><th style="border:0.1px solid;" >Field</th><th style="border:0.1px solid;">Description of the complaint in detail</th></tr>';
                    
                    /* Created date */
                    String createdDateLocal = caseObj.createdDate.format('dd-MM-yyyy, hh-mm a') ;
                    
                    emailData+= '<tr><td style="border:0.1px dotted black;padding:0px;">&nbsp;Date and time stamp of case creation</td><td style="border:0.1px dotted black;padding:0px;">&nbsp;' + createdDateLocal + '</td></tr>';
                    
                    /* project lead */
                    String projectTL = '';
                    if (caseObj.TL__c != null){
                        projectTL = caseObj.TL__c;
                    }

                    emailData+= '<tr><td style="border:0.1px dotted black;padding:0px;">&nbsp;Project Team Leader</td><td style="border:0.1px dotted;">&nbsp;' + projectTL  + '</td></tr>';
                    
                    /* project name */
                    String projectFormula = '';
                    if (caseObj.account.Project_Name__c != null){
                        projectFormula = caseObj.account.Project_Name__c;
                    }
                    emailData+= '<tr><td style="border:0.1px dotted;padding:0px; spacing:0px">&nbsp;Project Name</td><td style="border:0.1px dotted;">&nbsp;' + projectFormula + '</td></tr>';
                    
                    /* flat details */
                    String flatDetails = '';
                    if (caseObj.Flat_Details__c != null){
                        flatDetails = caseObj.Flat_Details__c;
                    }
                    emailData+= '<tr><td style="border:0.1px dotted;">&nbsp;Flat details</td><td style="border:0.1px dotted;">&nbsp;' + flatDetails  + '</td></tr>';
                    
                    /* acount name */
                    String accountName = '';
                    if (caseObj.account.name != null){
                        accountName = caseObj.account.name;
                    }
                    emailData+= '<tr><td style="border:0.1px dotted;">&nbsp;Customer name</td><td style="border:0.1px dotted;">&nbsp;' + accountName + '</td></tr>';
                    
                    
                    Booking_details__c bookingObj = [ Select Name, CV_paid__c, Registration_Status__c from Booking_details__c where Account__c =: caseObj.account.Id LIMIT 1 ];
                    System.debug('!!!!!!!!!!!!!!-------bookingObj = -----------------' +  bookingObj );
                   
                   
                    /* Registration status */
                    String bookingStatus = '';
                    if (bookingObj != null && bookingObj.Registration_Status__c != null){
                        bookingStatus = bookingObj.Registration_Status__c;
                    }
                    emailData+= '<tr><td style="border:0.1px dotted;">&nbsp;Registration Status</td><td style="border:0.1px dotted;">&nbsp;' + bookingStatus  + '</td></tr>';
                    
                    /* CV paid */
                    String cvPaid = '';
                   /* if (caseObj.CRN__r != null && caseObj.CRN__r.CV_paid__c != null){
                        cvPaid = String.valueOf(caseObj.CRN__r.CV_paid__c);
                    }*/
                    if (bookingObj != null && bookingObj.CV_paid__c != null){
                        cvPaid = String.valueOf(bookingObj.CV_paid__c);
                        System.debug('!!!!!!!!!!!-------cvPaid = -----------------' +  cvPaid );
                    }                    
                    emailData+= '<tr><td style="border:0.1px dotted;">&nbsp;% CV paid</td><td style="border:0.1px dotted;">&nbsp;' + cvPaid  + '</td></tr>';
                    
                    /* interaction mode */
                    String interactionMode = '';
                    if (caseObj.Interaction_Mode__c != null){
                        interactionMode = caseObj.Interaction_Mode__c;
                    }
                    emailData+= '<tr><td style="border:0.1px dotted;">&nbsp;Interaction Mode</td><td style="border:0.1px dotted;">&nbsp;' + interactionMode + '</td></tr>';
                    
                    /* nature of request */
                    String natureOfRequest = '';
                    if (caseObj.Nature_of_Request__c != null){
                        natureOfRequest = caseObj.Nature_of_Request__c;
                    }
                    emailData+= '<tr><td style="border:0.1px dotted;">&nbsp;Nature of Request</td><td style="border:0.1px dotted;">&nbsp;' + natureOfRequest  + '</td></tr>';
                    
                    /* Request type L1 */
                    String requestForL1= '';
                    if (caseObj.Request_for_L1__c != null){
                        requestForL1= caseObj.Request_for_L1__c;
                    }
                    emailData+= '<tr><td style="border:0.1px dotted;">&nbsp;Complaint Type-L1</td><td style="border:0.1px dotted;">&nbsp;' + requestForL1 + '</td></tr>';
                    
                    /* Request type L2 */
                    String requestForL2= '';
                    if (caseObj.Request_for_L2__c != null){
                        requestForL2= caseObj.Request_for_L2__c;
                    }
                    emailData+= '<tr><td style="border:0.1px dotted;">&nbsp;Complaint Type-L2</td><td style="border:0.1px dotted;">&nbsp;' + requestForL2 + '</td></tr>';
                    
                     /* Request type L3 */
                    System.debug('caseObj.Request_for_L3_a__c = ' +  caseObj.Request_for_L3_a__c);
                    System.debug('caseObj.Request_for_L3__c = ' +  caseObj.Request_for_L3__c);
                    String L3data = '';
                    if (caseObj.Request_for_L3_a__c != null){
                        L3data += caseObj.Request_for_L3_a__c;
                    }
                    if (caseObj.Request_for_L3__c != null){
                        L3data += caseObj.Request_for_L3__c;
                    }  
                    emailData+= '<tr><td style="border:0.1px dotted;">&nbsp;Complaint Type-L3</td><td style="border:0.1px dotted;">&nbsp;' + L3data  + '</td></tr>';
                    
                    /* latest comment */
                    /* String latestComment = '';
                    if (caseObj.Latest_Comment__c != null){
                        latestComment = caseObj.Latest_Comment__c;
                    }
                    emailData+= '<td>' + latestComment  + '</td>';*/
                    
                    /* tat */
                    String tat = '';
                    if (caseObj.TAT__c != null){
                        tat = String.valueOf(caseObj.TAT__c);
                    }
                    emailData+= '<tr><td style="border:0.1px dotted;">&nbsp;TAT allowed for case closure</td><td style="border:0.1px dotted;">&nbsp;' + tat + '</td></tr>';
                    
                    /* priority */
                    String priority = '';
                    if (caseObj.priority != null){
                        priority = String.valueOf(caseObj.priority);
                    }
                    emailData+= '<tr><td style="border:0.1px dotted;">&nbsp;Case Priority</td><td style="border:0.1px dotted;">&nbsp;' + priority + '</td></tr>';
                    
                    /* child cases and action items */
                    emailData+= '<tr><td style="border:0.1px dotted;">&nbsp;Dependency on Internal Lodha Functions&nbsp;</td><td style="border:0.1px dotted;">';
                    
                    List<Case> childCasesList = getChildCases(caseObj);
                    if(childCasesList != null && childCasesList.size() > 0){
                        emailData+= '<table style="border:0.1px dotted;" bordercolor="black" width="100%"  cellspacing="0" cellpadding="0"><font face="calibri">';
                        emailData += '<tr><th cellspacing="0" cellpadding="0">Case Number</th><th cellspacing="0" cellpadding="0">Assignee</th><th cellspacing="0" cellpadding="0">Status</th></tr>';
                        for(Case childCaseObj : childCasesList ){
                            emailData += '<tr><td style="border:0.1px dotted;" align="center" cellspacing="0" cellpadding="0">' + childCaseObj.CaseNumber + '</td>';
                            emailData += '<td style="border:0.1px dotted;" align="center" cellspacing="0" cellpadding="0">' + childCaseObj.owner.Name + '</td>';
                            emailData += '<td style="border:0.1px dotted;" align="center" cellspacing="0" cellpadding="0">' + childCaseObj.status+ '</td></tr>';
                        }
                        emailData += '</font></table>';
                    }else{
                        emailData += '&nbsp;-';
                    }
                    
                    emailData+= '</td></tr>';
                    
                    /* status */                    
                    String status = '';
                    if (caseObj.Status  != null){
                        status = caseObj.Status ;
                    }
                    emailData+= '<tr><td style="border:0.1px dotted;">&nbsp;Case Status</td><td style="border:0.1px dotted;">&nbsp;' + status  + '</td></tr>';
                    
                    
                    /* activity history */
                    emailData+= '<tr><td style="border:0.1px dotted;">&nbsp;Customer Email/Call Link</td><td style="border:0.1px dotted;">';
                    
                    List<String> activityHistoryList = getActivityHistory(caseObj);
                    if(activityHistoryList != null && activityHistoryList.size() > 0){
                        emailData+= '<table style="border:1px dotted;" bordercolor="black" width="100%" cellspacing="0" cellpadding="0"><font face="calibri">';
                        for(String ahObj : activityHistoryList ){
                            if (ahObj != null && !ahObj.equals('')){
                                emailData += '<tr><td align="center" style="border:0.1px dotted;" >' + ahObj + '</td></tr>';
                            }
                        }
                        emailData += '</font></table>';
                    }else{
                        emailData += '&nbsp;-';
                    }
                    emailData+= '</td></tr>';
                    emailData+= '</font></table>';
                    
                    /* summary */
                    String caseSummary = '';
                    if (caseObj.Case_Summary__c != null){
                        caseSummary = caseObj.Case_Summary__c;
                    }
                    emailData+= '<br><font face="calibri"><u>Complaint Summary</u> :<br>' + caseSummary  + '</br>';
                    
                    /* case link */
                    String hostname = System.URL.getSalesforceBaseUrl().getHost();
                    hostname += '/';
                    hostname += caseObj.Id;
                    System.debug('---hostname ' + hostname + '------caseObj.Id = ' +  caseObj.Id + '-------' + hostname );
                    emailData += '<br><br><a href="' + hostname + '">Case Link in SFDC to view complete customer interaction history </a><br><br>';
                   
                      
                    /* resolution */
                    String caseResolution = '';
                    if (caseObj.Case_Resolution__c != null){
                        caseResolution = caseObj.Case_Resolution__c;
                    }
                    emailData+= '<br><u>Resolution provided</u> :<br>' + caseResolution + '</br>';
                    emailData += '<br><br>';
                    emailData += '</font></body></html>';
                  }//end of for
            } //end of if
        }//end of try
        catch(Exception ex){
            System.debug('Error in CM_CustomReportGenerator_MORN - generateEmailContents => ' + ex.getMessage());
        }
        
        System.debug('Cases table data = ' + emailData );
                        
        return emailData;
    }

    
    
    /* This mehod sends complain case's email */
    public void sendEmail(Set<String> RM_TL_EmailIdSet, String emailContent, String projectName, String clusterName, String customerName){
        
        Set<String> toEmailIdSet = new Set<String>();
        Set<String> ccEmailIdSet = new Set<String>();
        //Set<String> bccEmailIdSet = new Set<String>();
        
        try{
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
           
            System.debug('toEmailIds  = ' + toEmailIdList);
            System.debug('ccEmailIdList  = ' + ccEmailIdList);
           // System.debug('bccEmailIdList  = ' + bccEmailIdList);

            if (toEmailIdList != null && toEmailIdList.size() > 0){
                for(CM_Reporting_EmailIds__c reportingToObj : toEmailIdList ){
                    toEmailIdSet.add(reportingToObj.Email_Id__c);
                }
                mail.setToAddresses(new List<String>(toEmailIdSet)); 
            }
            
            /* adding RM & TL in CC */
            if (RM_TL_EmailIdSet != null && RM_TL_EmailIdSet.size() > 0){
                ccEmailIdSet.addAll(RM_TL_EmailIdSet);
            }
            System.debug('ccEmailIdSet= ' + ccEmailIdSet);

            if (ccEmailIdList != null && ccEmailIdList.size() > 0){
                for(CM_Reporting_EmailIds__c reportingCCObj : ccEmailIdList ){
                    ccEmailIdSet.add(reportingCCObj.Email_Id__c);
                }
            }
            mail.setCCAddresses(new List<String>(ccEmailIdSet)); 

            
            
            
            /* if (bccEmailIdList != null && bccEmailIdList.size() > 0){
                for(CM_Reporting_EmailIds__c reportingBCCObj : bccEmailIdList ){
                    bccEmailIdSet.add(reportingBCCObj.Email_Id__c);
                }
                mail.setBCCAddresses(new List<String>(bccEmailIdSet)); 
            } */
            
            mail.setSenderDisplayName('Lodha Group');
            String subject = projectName + ' - Complaint For ' + startDate.day() + '-' + startDate.month() + '-' + startDate.year() + ' - | ' + customerName;
            mail.setSubject(subject);
            mail.setBccSender(false);
            mail.setUseSignature(false);
            mail.setHTMLBody(emailContent);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }catch(Exception ex){
            System.debug('Error in EmailSender - sendEmail => ' + ex.getMessage());
        }
    }
    
    public List<Case> getChildCases(Case parentCase){
        List<Case> childCasesList = new List<Case>();
        
        try{
            childCasesList = [Select Id, CaseNumber, CaseType__c, owner.Name, status from Case Where parent.Id =: parentCase.Id ];
            System.debug('childCasesList -----------' +  childCasesList);
            if(childCasesList != null){
                System.debug('childCasesList ---size--------' +  childCasesList.size());
            }
            
            if (childCasesList != null && childCasesList.size() > 0){
                for(Case caseObj: childCasesList){
                    System.debug('------------------id = ' + caseObj.Id + '-----CaseNumber----= ' + caseObj.CaseNumber + ' owner = ' + caseObj.owner.Name + '--------CaseType__c = ------' + caseObj.CaseType__c +  '----status ----' +  caseObj.status);
                }
            }
        }catch(Exception ex){
            System.debug('Error in CM_CustomReportGenerator_MORN - getChildCases => ' + ex.getMessage());
        }
        
        return childCasesList;
    }
    
  
  public List<String> getActivityHistory(Case parentCase){
        List<Case> caseList = new List<Case>();
        List<ActivityHistory> ahList = new List<ActivityHistory>();
        List<String> activityURLs = new List<String>();


        try{
            caseList = [ SELECT Id, casenumber, ( SELECT Unique_Call_ID__c, ActivityType, WhatId FROM ActivityHistories )
                    FROM Case WHERE Id =: parentCase.Id ] ;
            System.debug('caseList -----------' +  caseList );
            if(caseList != null){
                System.debug('caseList ---size--------= ' +  caseList .size());
            }
            
            if (caseList != null && caseList .size() > 0){
                for(Case caseObj: caseList ){
                    System.debug('------------------id = ' + caseObj.Id + '-----CaseNumber----= ' + caseObj.caseNumber);
                    ahList  = caseObj.getSObjects('ActivityHistories');
                    if(ahList != null && ahList.size() > 0){
                        for (ActivityHistory ah : ahList) {
                            System.debug('------------------Unique_Call_ID__c =' + ah.Unique_Call_ID__c);
                            if(ah.Unique_Call_ID__c != null && !ah.Unique_Call_ID__c.equals('')){
                                activityURLs.add(ah.Unique_Call_ID__c);
                            }
                        }
                    }
                }
            }
            
        }catch(Exception ex){
            System.debug('Error in CM_CustomReportGenerator_MORN - getActivityHistory => ' + ex.getMessage());
        }
        
        return activityURLs;
    } 
    
      
}