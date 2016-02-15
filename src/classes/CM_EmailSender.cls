/**********************************************************************************
Name: EmailSender
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


global class CM_EmailSender implements Database.Batchable <sObject> {

    
    String emailFrom = '';
    String emailTo ='shruti.samant@capgemini.com';
    String emailCCRM = '';
    String emailCCRMTL = '';
    String subject = '';
    List<Case> caseList;
    //Map<String, List<Case>> customerMap = null;
    DateTime today;
    DateTime yesterday;
    public String query= '';
    
    global Database.QueryLocator start(Database.BatchableContext obj){
//        String query='';
        
        try{
            query = 'Select CreatedDate, Project_Formula__c, Flat_Details__c, Booking_status__c, CRN__c, Interaction_Mode__c, Nature_of_Request__c, Request_for_L1__c, Request_for_L2__c, Request_for_L3_a__c, Request_for_L3__c, Latest_Comment__c, Case_Summary__c, Case_Resolution__c, Status, account.name, TAT__c,CRN__r.CRN__c, CRN__r.CV_paid__c, CRN__r.CLuster__c, account.CRN__c, TL_EmailId__c, Owner_EmailId__c, TL__c from case where Nature_of_Request__c =\'Complaint\' ';
            //query = '';
            System.debug('Query = ' + query );
        }catch(Exception ex){
            System.debug('Error in EmailSender-> Start => '+ ex);
        }
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext obj, List<Case> caseList){
        System.debug('List of complaint cases retrived = ' + caseList);
        
        Map<String, List<Case>> customerMap = new Map<String, List<Case>>() ;
        
        if (caseList != null && caseList.size() > 0){
            System.debug('Total no of complaint cases retrieved = '+ caseList.size());
            
            /* filtering only those complaint cases created between yesterday 6 pm and today 6 pm */
            List<Case> tempCaseList = filterCases(caseList);
            System.debug('Complaint cases created between yesterday 6 pm and today 6 pm = ' + tempCaseList );
            
            /* Mapping cases to customers */
            if (tempCaseList != null && tempCaseList .size() > 0){
                //Map<String, List<Case>> customerMap = new Map<String, List<Case>>();
                customerMap = mapCasesToCustomers(tempCaseList);
                System.debug('CustomerMap created = ' + customerMap );
            }

            if(customerMap != null){
                for (String customerKey : customerMap.keySet()){
                    System.debug('Key = ' + customerKey);
            
                    List<Case> cases = customerMap.get(customerKey);
                    System.debug('List of cases = ' + cases );
                    System.debug('No of cases = ' + cases.size() );
        
                    /* Generating Email Table Header */
                    //String emailContents= generateTableHeader();
                    String emailContents = '';
                    
                    /* Generating Email Table Data */
                    emailContents += generateTableData(cases);
                
                    System.debug('Overall table data = ' + emailContents);
                
                    String projectName = '-';
                    if(cases[0].Project_Formula__c != null){
                        projectName = cases[0].Project_Formula__c;
                    }
                    
                    String clusterName = '-';
                    if(cases[0].CRN__r != null && cases[0].CRN__r.CLuster__c != null){
                        clusterName = cases[0].CRN__r.CLuster__c;
                    }
                    
                    String customerName = '-';
                    if(cases[0].account != null && cases[0].account.name != null){
                        customerName = cases[0].account.name;
                    }
                    
                    String toEmailId = 'abhinandan.lodha@lodhagroup.com';
                    //String ccEmailId1 = '';
                    List<String> ccEmailIdList = getCCEmailIds(cases);
                    
                    ccEmailIdList.add('Ankur.Kapoor@lodhagroup.com');
                    ccEmailIdList.add('Surendran.Nair@lodhagroup.com');
                    ccEmailIdList.add('Maninder.Chhabra@lodhagroup.com');
                    ccEmailIdList.add('Victoria.Rebello@lodhagroup.com');
                    ccEmailIdList.add('QAT.CC@lodhagroup.com');
                    ccEmailIdList.add('audit.customercomplaint@lodhagroup.com');

                    System.debug('ccEmailIdList = ' + ccEmailIdList);

                    //String ccEmailId2 = '';

                    sendEmail(toEmailId, ccEmailIdList, emailContents, projectName, clusterName, customerName);
                }//end of for
            }//end of customerMap != null
        }
    }        

    global void finish(Database.BatchableContext obj){
    }
    
    
    public List<String> getCCEmailIds(List<Case> cases){
        List<String> ccEmailIdList = new List<String>();
        
        System.debug('getCCEmailIds= 1....' + cases);

        if (cases != null && cases.size() > 0){
        System.debug('getCCEmailIds= 2....' );


            for(Case caseObj: cases){
            System.debug('getCCEmailIds= 3....' );
                if(caseObj != null && caseObj.Owner_EmailId__c != null && !caseObj.Owner_EmailId__c.equals('')){
                    System.debug('getCCEmailIds= 4....' + caseObj.Owner_EmailId__c);

                    ccEmailIdList.add(caseObj.Owner_EmailId__c);
                }

                if(caseObj != null && caseObj.TL_EmailId__c != null && !caseObj.TL_EmailId__c.equals('')){
                System.debug('getCCEmailIds= 5....' + caseObj.TL_EmailId__c);


                    ccEmailIdList.add(caseObj.Tl_EmailId__c);
                }
            }
        }
        
        return ccEmailIdList ;
    }
    /* This method will return all complaint cases created
        between yesterday 6 pm and today 6 pm */
    public List<case> filterCases(List<Case> caseList ){
        List<case> tempList = new List<Case>();
        
        /* Creating date instance for TODAY 6 PM */
        Time timeToday  = Time.newInstance(18,0,0,0);
        today = DateTime.newInstancegmt(Date.today(), timeToday);
        System.debug('Today => ' + today );

        /* Creating date instance for YESTERDAY 6 PM */
        Time timeYesterday  = Time.newInstance(18,1,0,0);
//        Date tempDate = Date.today();
        Date tempDate1 = (Date.today()).addDays(-1);
        yesterday = DateTime.newInstancegmt(tempDate1, timeYesterday);
        System.debug('Yesterday => ' + yesterday );

        /* filtering cases created between yesterday 6 pm and today 6 pm */
        for(Case caseObj : caseList ){
            if (caseObj.createdDate >= yesterday && caseObj.createdDate <= today){
                tempList.add(caseObj);
             }
        }
        System.debug('No of complaint cases created between yesterday & today 6 pm = ' +  tempList.size());
        
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
              //  if (caseObj.CRN__r != null && caseObj.CRN__r.CRN__c != null){
                 if (caseObj.account != null && caseObj.account.CRN__c != null){
                    //String key = caseObj.CRN__r.CRN__c;
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
            System.debug('Error in EmailSender - mapCasesToCustomers => ' +  ex.getMessage());
        }
        
        return customerMap;
    }
    
    
    /* This method generates Data for the cases table */ 
    public String generateTableData(List<Case> caseList){
        String emailData= '';
        
        try{
            if (caseList != null && caseList.size() > 0){
                emailData = '<body><h1>Escalation for ' + today.day() + '-' + today.month() + '-' + today.year() + '</h1>';
                //emailData += '<table border="1" bordercolor="blue">';
               
                for(Case caseObj: caseList){
                    emailData += '<br><br><table border="1" bordercolor="blue">';

                    emailData+= '<tr><td>Date and time stamp of case creation</td><td>' + caseObj.createdDate + '</td></tr>';
                    
                    String projectTL = '';
                    if (caseObj.TL__c != null){
                        projectTL = caseObj.TL__c;
                    }

                    emailData+= '<tr><td>Project Team Leader</td><td>' + projectTL  + '</td></tr>';
                    
                    String projectFormula = '';
                    if (caseObj.Project_Formula__c != null){
                        projectFormula = caseObj.Project_Formula__c;
                    }
                    emailData+= '<tr><td>Project Name</td><td>' + projectFormula + '</td></tr>';
                    
                    String flatDetails = '';
                    if (caseObj.Flat_Details__c != null){
                        flatDetails = caseObj.Flat_Details__c;
                    }
                    emailData+= '<tr><td>Flat details</td><td>' + flatDetails  + '</td></tr>';
                    
                    String accountName = '';
                    if (caseObj.account.name != null){
                        accountName = caseObj.account.name;
                    }
                    emailData+= '<tr><td>Customer name</td><td>' + accountName + '</td></tr>';
                    
                    String bookingStatus = '';
                    if (caseObj.Booking_status__c != null){
                        bookingStatus = caseObj.Booking_status__c;
                    }
                    emailData+= '<tr><td>Registration Status</td><td>' + bookingStatus  + '</td></tr>';
                    
                    String cvPaid = '';
                    if (caseObj.CRN__r != null && caseObj.CRN__r.CV_paid__c != null){
                        cvPaid = String.valueOf(caseObj.CRN__r.CV_paid__c);
                    }
                    emailData+= '<tr><td>% CV paid</td><td>' + cvPaid  + '</td></tr>';
                    
                    String interactionMode = '';
                    if (caseObj.Interaction_Mode__c != null){
                        interactionMode = caseObj.Interaction_Mode__c;
                    }
                    emailData+= '<tr><td>Interaction Mode</td><td>' + interactionMode + '</td></tr>';
                    
                    String natureOfRequest = '';
                    if (caseObj.Nature_of_Request__c != null){
                        natureOfRequest = caseObj.Nature_of_Request__c;
                    }
                    emailData+= '<tr><td>Nature of Request</td><td>' + natureOfRequest  + '</td></tr>';
                    
                    String requestForL1= '';
                    if (caseObj.Request_for_L1__c != null){
                        requestForL1= caseObj.Request_for_L1__c;
                    }
                    emailData+= '<tr><td>Complaint Type-L1</td><td>' + requestForL1 + '</td></tr>';
                    
                    String requestForL2= '';
                    if (caseObj.Request_for_L2__c != null){
                        requestForL2= caseObj.Request_for_L2__c;
                    }
                    emailData+= '<tr><td>Complaint Type-L2</td><td>' + requestForL2 + '</td></tr>';
                    
                    System.debug('caseObj.Request_for_L3_a__c = ' +  caseObj.Request_for_L3_a__c);
                    System.debug('caseObj.Request_for_L3__c = ' +  caseObj.Request_for_L3__c);
                    String L3data = '';
                    if (caseObj.Request_for_L3_a__c != null){
                        L3data += caseObj.Request_for_L3_a__c;
                    }
                    if (caseObj.Request_for_L3__c != null){
                        L3data += caseObj.Request_for_L3__c;
                    }  
                    //content+= '<td>' + caseObj.Request_for_L3_a__c + '-' + caseObj.Request_for_L3__c  + '</td>';
                    emailData+= '<tr><td>Complaint Type-L3</td><td>' + L3data  + '</td></tr>';
                    
                    /* String latestComment = '';
                    if (caseObj.Latest_Comment__c != null){
                        latestComment = caseObj.Latest_Comment__c;
                    }
                    emailData+= '<td>' + latestComment  + '</td>';*/
                    
                    String tat = '';
                    if (caseObj.TAT__c != null){
                        tat = String.valueOf(caseObj.TAT__c);
                    }
                    emailData+= '<tr><td>TAT allowed for case closure</td><td>' + tat + '</td></tr>';
                    
                    /* String caseSummary = '';
                    if (caseObj.Case_Summary__c != null){
                        caseSummary = caseObj.Case_Summary__c;
                    }
                    emailData+= '<tr><td>Complaint Summary</td><td>' + caseSummary  + '</td></tr>';
                    
                   
                    String caseResolution = '';
                    if (caseObj.Case_Resolution__c != null){
                        caseResolution = caseObj.Case_Resolution__c;
                    }
                    emailData+= '<tr><td>Resolution provided</td><td>' + caseResolution + '</td></tr>';
                    */
                    
                    String status = '';
                    if (caseObj.Status  != null){
                        status = caseObj.Status ;
                    }
                    emailData+= '<tr><td>Case Status</td><td>' + status  + '</td></tr></table>';
                    
                    String caseSummary = '';
                    if (caseObj.Case_Summary__c != null){
                        caseSummary = caseObj.Case_Summary__c;
                    }
                    emailData+= '<br>Complaint Summary :<br>' + caseSummary  + '</br>';
                    
                   
                    String caseResolution = '';
                    if (caseObj.Case_Resolution__c != null){
                        caseResolution = caseObj.Case_Resolution__c;
                    }
                    emailData+= '<br>Resolution provided :<br>' + caseResolution + '</br>';

                    
                    emailData += '<br><br>';
                    
                    
                    emailData += '</body>';

                   // emailData+= '</tr>';
                  }//end of for
                  //emailData += '</table></body>';
            } //end of if
        }//end of try
        catch(Exception ex){
            System.debug('Error in EmailSender - generateEmailContents => ' + ex.getMessage());
        }
        
        System.debug('Cases table data = ' + emailData );
                        
        return emailData;
    }

    
    /* This method generates Header for the cases table */
    public String generateTableHeader(){
        String headerData = '';
        
        try{
            headerData = '<body><h1>Escalation for ' + today.day() + '-' + today.month() + '-' + today.year() + '</h1>';
            headerData += '<table border="1" bordercolor="blue">';
            headerData += '<tr>';
            headerData += '<th>Created Date</th>';
            headerData += '<th>Project Team Leader</th>';
            headerData += '<th>Project Name</th>';
            headerData += '<th>Flat Details</th>';
            headerData += '<th>Customer name</th>';
            headerData += '<th>Registration Status</th>';
            headerData += '<th>% CV paid</th>';
            headerData += '<th>Interaction Mode</th>';
            headerData += '<th>Nature of Request</th>';
            headerData += '<th>Request Type-L1</th>';
            headerData += '<th>Request Type-L2</th>';
            headerData += '<th>Request Type-L3</th>';
           // headerData += '<th>Comments</th>';
            headerData += '<th>TAT allowed for case closure</th>';
            headerData += '<th>Complaint Summary</th>';
            headerData += '<th>Resolution provided</th>';
            headerData += '<th>Case Status</th>';
            headerData += '</tr>';
                
        }catch(Exception ex){
            system.debug('Error in EmailSender - generateEmailHeader()=> ' + ex.getMessage() );
        }
        
        System.debug('Cases Header data = = ' + headerData );
        
        return headerData ;
    }
    
    /* This mehod sends complain case's email */
    public void sendEmail(String toEmailId, List<String> ccEmailIdList, String emailContent, String projectName, String clusterName, String customerName){
        try{
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toEmailRecipients = new String[]{toEmailId};
            mail.setToAddresses(toEmailRecipients);

           // String[] ccEmailRecipients = new String[]{ccEmailId1, ccEmailId2};
            mail.setCCAddresses(ccEmailIdList);

            mail.setSenderDisplayName('Lodha Group');
            String subject = 'Escalation for ' + today.day() + '-' + today.month() + '-' + today.year() + ' : ' + projectName+ ' | ' + clusterName + ' | ' + customerName;
            mail.setSubject(subject);
            mail.setBccSender(false);
            mail.setUseSignature(false);
            mail.setHTMLBody(emailContent);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }catch(Exception ex){
            System.debug('Error in EmailSender - sendEmail => ' + ex.getMessage());
        }
    }
    
    
}