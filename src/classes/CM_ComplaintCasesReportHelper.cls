public class CM_ComplaintCasesReportHelper{
    List<Case> caseList;

    
    public List<Case>filterCases(List<Case>caseList, DateTime startDateTime, DateTime endDateTime){
        System.debug('CaseList received = ' + caseList + ', startDateTime Received => ' + startDateTime + ', endDateTime Received => ' + endDateTime);
        List<Case> filteredCaseList = new List<Case>();
    
        if (caseList != null && caseList.size() > 0){
        /* filtering cases created between given strt date and end date */
            for(Case caseObj : caseList ){
                //DateTime caseCreateDateGmt = DateTime.newInstancegmt(caseObj.createdDate.date(), caseObj.createdDate.time());
                //System.debug('id = ' + caseObj.Id + ', created date in DB=> ' + caseObj.createdDate + ', caseCreateDate gmt= ' +  caseCreateDateGmt );
                if (caseObj.createdDate >= startDateTime && caseObj.createdDate <= endDateTime){
                    filteredCaseList.add(caseObj);
                }
            }
        }
        System.debug('No of complaint cases created between << ' +  startDateTime +  ' >> and <<' +  endDateTime + '>> = ' + filteredCaseList.size());
    
        return filteredCaseList;
    }
    
        
    ////////////////////////////////////////////////////////////////////////////////
    /* this method will get all eligible complaint cases 
    either from scheduler or from trigger */
    ////////////////////////////////////////////////////////////////////////////////
    public void execute(List<Case> complaintCasesList, boolean caseCreateNotification, DateTime reportDate, String reportType, boolean isComplaintCase){
        System.debug('1...............................................................' );
        
        //map cases according to CRN.
        Map<String, List<Case>> crnCasesMap = generateCustomersToCasesMap(complaintCasesList);
        System.debug('crnCasesMap  =>>>>>>>> ' + crnCasesMap );
    
        ///for every CRN
        if(crnCasesMap != null && crnCasesMap .size() > 0 ){
        for (String crn : crnCasesMap .keySet()){
            String fromEmailId = '';
            String fromDisplayName = '';
            DateTime reportDateTime;
            Account accObj = new Account();
            Booking_Details__c bookingObj = new Booking_Details__c();
    
            System.debug('Key = ' + crn );
    
            /* get details for account object*/
            try{
                accObj = [ select Id, name, Project_Name__c, crn__c, owner.name, owner.email, owner.manager.name, owner.manager.email from account where crn__c =: crn LIMIT 1];
                System.debug('accObj = ' + accObj  );

                fromDisplayName = accObj.owner.manager.name;
                fromEmailId = accObj.owner.manager.email;
                System.debug(' fromDisplayName = ' + fromDisplayName + ', fromEmailId = ' + fromEmailId);
            }catch(Exception ex){
                System.debug('Error in CM_ComplaintCasesReportHelper -> execute=>' + ex);
            }
            
                
            /* get details for booking object*/
            try{
                System.debug('accObj.Id = ' + accObj.Id);
                bookingObj = [ Select Name, CV_paid_New__c, Registration_Status__c, CLuster__c, Wing__c, Flat_No__c, Application_Date__c, Consideration_Value__c from Booking_details__c where Account__c =: accObj.Id LIMIT 1 ];
                System.debug('bookingObj = ' + bookingObj );
            }catch(Exception ex){
                System.debug('Error in CM_ComplaintCasesReportHelper -> execute=>' + ex);
            }
    
           
    
            List<Case> caseList = crnCasesMap.get(crn);
            System.debug('List of cases = ' + caseList );
            System.debug('No of cases = ' + caseList.size() );
    
            if(caseCreateNotification){
            /* get other case details */
                for(Case caseObj : caseList){
                    Case tmpCaseObj = [select Date_of_Complaint__c, TL_EmailId__c, Interaction_Mode__c,
                    Priority, Case_Summary__c, Case_Resolution__c, 
                    Dependency_on_Internal_functions__c, Owner_EmailId__c, Owner.name
                    from Case 
                    where Id =: caseObj.Id ];
                    
                    caseObj.Date_of_Complaint__c= tmpCaseObj.Date_of_Complaint__c;
                    //caseObj.TL__c= tmpCaseObj.TL__c;
                    caseObj.Interaction_Mode__c = tmpCaseObj.Interaction_Mode__c;
                    caseObj.Priority= tmpCaseObj.Priority;
                    caseObj.Case_Summary__c= tmpCaseObj.Case_Summary__c;
                    caseObj.Case_Resolution__c = tmpCaseObj.Case_Resolution__c ;
                    caseObj.Case_Resolution__c = tmpCaseObj.Case_Resolution__c ;
                    caseObj.Dependency_on_Internal_functions__c = tmpCaseObj.Dependency_on_Internal_functions__c ;
            
                    if (caseCreateNotification){
                        System.debug('@@@@@@@@@@@@@@@ from details >>>>> if caseCreateNotification is true..............');
                        fromEmailId = tmpCaseObj.Owner_EmailId__c;
                        fromDisplayName = tmpCaseObj.Owner.name;
                        System.debug('fromEmailId...' +  fromEmailId + ', fromDisplayName...' +  fromDisplayName);
                        reportDateTime = caseObj.createdDate;
                    }
                }
            }
    
            /* Generating Email Table Data */
            String emailContents = '';

                emailContents = getEmailContents(caseList, accObj, bookingObj );

            
            if(emailContents != null){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setHTMLBody(emailContents);
            
                //from details
                System.debug('before setting to mail ==> fromDisplayName = ' + fromDisplayName + ', fromEmailId =' + fromEmailId);
                mail.setSenderDisplayName(fromDisplayName );
                mail.setReplyTo(fromEmailId );
            
            
                //to details
                Set<String> toEmailIdSet = getToEmailIds(caseCreateNotification, reportType, caseList);
                System.debug('--------toEmailIdSet -----------' + toEmailIdSet );
                mail.setToAddresses(new List<String>(toEmailIdSet)); 
            
                //cc details
                Set<String> ccEmailIdSet = getCCEmailIds(caseCreateNotification, reportType, caseList);
                System.debug('--------ccmEmailIdSet -----------' + ccEmailIdSet );
                mail.setCCAddresses(new List<String>(ccEmailIdSet)); 
            
                //bcc details
                Set<String> bccEmailIdSet = getBccEmailIds(caseCreateNotification, reportType);
                System.debug('--------bccEmailIdSet -----------' + bccEmailIdSet );
                mail.setBCCAddresses(new List<String>(bccEmailIdSet)); 
            
                //subject
                String subject = getSubject(accObj.project_name__c, accObj.name, reportDate, reportType, isComplaintCase);
                System.debug('--------subject -----------' + subject );
                mail.setSubject(subject );
            
                
                        
                /*List<String> l = new List<String>();
                l.add('shruti.samant@capgemini.com');
                mail.setToAddresses(l); */ 
            
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                System.debug('Mail sent!!!**********************');
            }
        }   
    } 
    }
    
    public  Set<String> getToEmailIds(boolean caseCreateNotification, String reportType, List<Case> cases){
        Set<String> toEmailIdSet = new Set<String>();
        List<CM_Reporting_EmailIds__c> toEmailIdList;
        
        if (caseCreateNotification){
            if (cases != null && cases.size() > 0){
                System.debug('getCCEmailIds= 2....' );
                for(Case caseObj: cases){
                    System.debug('getCCEmailIds= 3....' );
                    if(caseObj != null && caseObj.TL_EmailId__c != null && !caseObj.TL_EmailId__c.equals('')){
                        System.debug('getCCEmailIds= 5....' + caseObj.TL_EmailId__c);
                        toEmailIdSet .add(caseObj.Tl_EmailId__c);
                    }
                    if(caseObj != null && caseObj.PIC_EmailId__c != null && !caseObj.PIC_EmailId__c.equals('')){
                        System.debug('getCCEmailIds= 6....' + caseObj.PIC_EmailId__c);
                        toEmailIdSet .add(caseObj.PIC_EmailId__c);
                    }
                }
            }
        }else{
            
            if(reportType != null && reportType.equals('Director')){
                toEmailIdList = [SELECT Id, Email_Id__c FROM CM_Reporting_EmailIds__c WHERE To_CC_Bcc__c in ('to', 'TO', 'tO', 'To') and Report_Type__c = 'Director'];  
            }
        }
        
        if (toEmailIdList != null && toEmailIdList .size() > 0){
            for(CM_Reporting_EmailIds__c toEmailsObj : toEmailIdList ){
                toEmailIdSet .add(toEmailsObj .Email_Id__c);
            }
        }
        return toEmailIdSet ;
    }
    
    
    /**
    This method will return email ids of case onwer and his TL
    */
    public Set<String> getCCEmailIds(boolean caseCreateNotification, String reportType, List<Case> cases){
        Set<String> ccEmailIdSet = new Set<String>();
        
        System.debug('getCCEmailIds= 1....' + cases);
        if(caseCreateNotification){
            List<CM_Reporting_EmailIds__c> ccEmailIdList = [SELECT Id, Email_Id__c FROM CM_Reporting_EmailIds__c WHERE To_CC_Bcc__c in ('cc', 'CC', 'cC', 'Cc') and Report_Type__c = 'Quality'];  
                if (ccEmailIdList != null && ccEmailIdList.size() > 0){
                    for(CM_Reporting_EmailIds__c ccEmailsObj : ccEmailIdList ){
                        ccEmailIdSet.add(ccEmailsObj.Email_Id__c);
                    }
                }
                
                ccEmailIdList = [SELECT Id, Email_Id__c FROM CM_Reporting_EmailIds__c WHERE To_CC_Bcc__c in ('cc', 'CC', 'cC', 'Cc') and Report_Type__c = 'Audit'];  
                if (ccEmailIdList != null && ccEmailIdList.size() > 0){
                    for(CM_Reporting_EmailIds__c ccEmailsObj : ccEmailIdList ){
                        ccEmailIdSet.add(ccEmailsObj.Email_Id__c);
                    }
                }
        
        }else{
            List<CM_Reporting_EmailIds__c> ccEmailIdList;
            if (reportType != null && reportType.equals('Summary')){
               ccEmailIdList = [SELECT Id, Email_Id__c FROM CM_Reporting_EmailIds__c WHERE To_CC_Bcc__c in ('cc', 'CC', 'cC', 'Cc') and Report_Type__c = 'Summary'];  
            }
        
            if (reportType != null && reportType.equals('Director')){
                 ccEmailIdList = [SELECT Id, Email_Id__c FROM CM_Reporting_EmailIds__c WHERE To_CC_Bcc__c in ('cc', 'CC', 'cC', 'Cc') and Report_Type__c = 'Director'];  
            }
            if (ccEmailIdList != null && ccEmailIdList.size() > 0){
                for(CM_Reporting_EmailIds__c ccEmailsObj : ccEmailIdList ){
                    ccEmailIdSet.add(ccEmailsObj.Email_Id__c);
                }
            }
            if (cases != null && cases.size() > 0){
                System.debug('getCCEmailIds= 2....' );

                for(Case caseObj: cases){
                    System.debug('getCCEmailIds= 3....' );
    
                    if(caseObj != null && caseObj.TL_EmailId__c != null && !caseObj.TL_EmailId__c.equals('')){
                        System.debug('getCCEmailIds= 5....' + caseObj.TL_EmailId__c);
                        ccEmailIdSet.add(caseObj.Tl_EmailId__c);
                    }
                    
                    if(caseObj != null && caseObj.PIC_EmailId__c != null && !caseObj.PIC_EmailId__c.equals('')){
                        System.debug('getCCEmailIds= 6....' + caseObj.PIC_EmailId__c);
                        ccEmailIdSet.add(caseObj.PIC_EmailId__c);
                    }
                }//for 
            }//if 
        } //else
        
        return ccEmailIdSet ;
    }
    
    
   
    
    public Set<String> getBccEmailIds(boolean caseCreateNotification, String reportType){
    
    Set<String> bccEmailIdSet = new Set<String>();
    if(caseCreateNotification){
        List<CM_Reporting_EmailIds__c> bccEmailIdList = [SELECT Id, Email_Id__c FROM CM_Reporting_EmailIds__c WHERE To_CC_Bcc__c in ('bcc', 'Bcc', 'BCC', 'BCc') and Report_Type__c = 'Audit'];  
        if (bccEmailIdList != null && bccEmailIdList .size() > 0){
            for(CM_Reporting_EmailIds__c bccEmailsObj : bccEmailIdList ){
                bccEmailIdSet .add(bccEmailsObj .Email_Id__c);
            }
        }
        bccEmailIdList = [SELECT Id, Email_Id__c FROM CM_Reporting_EmailIds__c WHERE To_CC_Bcc__c in ('bcc', 'Bcc', 'BCC', 'BCc') and Report_Type__c = 'Quality'];  
        if (bccEmailIdList != null && bccEmailIdList .size() > 0){
            for(CM_Reporting_EmailIds__c bccEmailsObj : bccEmailIdList ){
                bccEmailIdSet .add(bccEmailsObj .Email_Id__c);
            }
        }
        }else{
            List<CM_Reporting_EmailIds__c> bccEmailIdList;
           
            if (reportType != null && reportType.equals('Director')){
                bccEmailIdList = [SELECT Id, Email_Id__c FROM CM_Reporting_EmailIds__c WHERE To_CC_Bcc__c in ('bcc', 'Bcc', 'BCC', 'BCc') and Report_Type__c = 'Director'];  
            }

            if (bccEmailIdList != null && bccEmailIdList .size() > 0){
                for(CM_Reporting_EmailIds__c bccEmailsObj : bccEmailIdList ){
                    bccEmailIdSet .add(bccEmailsObj .Email_Id__c);
                }
            }
        }
        return bccEmailIdSet ;
    }
    
    
 
    
    
    public String getSubject(String projectName , String customerName, DateTime reportDate, String reportType, boolean isComplaintCase){
        String subject = '';
        if ( reportType != null && reportType.equals('Director')){
                subject = projectName + ' | Complaint For ' + reportDate.day() + '-' + reportDate.month() + '-' + reportDate.year() + ' | ' + customerName;
        }
        
        if ( reportType != null && reportType == ''){
            if(isComplaintCase){
                subject = projectName + ' | Complaint For ' + reportDate.day() + '-' + reportDate.month() + '-' + reportDate.year() + ' | ' + customerName;
            }else{
               subject = projectName + ' | Grievance For ' + reportDate.day() + '-' + reportDate.month() + '-' + reportDate.year() + ' | ' + customerName;
            }
        }
        return subject;
        
    }
    
    
    
   /* This method generates email contents which give dtails about complaint cases */ 
    public String getEmailContents(List<Case> caseList, Account accObj, Booking_Details__c bookingObj){
        String emailData= '';
        String space= '&nbsp;';
        String font = '<font face="calibri">';
        String startTD = '<td style="border:0.1px dotted black;padding:0px;">&nbsp;';
        String endTD = '</td>';
        String startTH = '<th style="border:0.1px solid;">';
        String endTH = '</th>';
        String startTR = '<tr>';
        String endTR = '</tr>';
        String startTable = '<table style="border:0.1px dotted black;padding:0px;">';
        String endTable = '</table>';
        //Booking_details__c bookingObj;
        Case tempCaseObj;
        
        String createdDateLocal = '' ;
        String complaintDateLocal = '-';
        String projectTL = '-';
        String projectName = '-';
        String flatDetails = '-';
        String accountName = '-';
        String bookingDate = '-';
        String bookingStatus = '-';
        String totalCVAmount = '-';
        String cvPaid = '-';
        String interactionMode = '-';
        String natureOfRequest = '-';
        String requestForL1= '-';
        String requestForL2= '-';
        String L3data = '';
        boolean flagL3A, flagL3B;
        String tat = '-';
        String priority = '-';
        String status = '-';
        String crn = '-';
        String cluster, wing, flatNo, cv, registrationStatus, applicationDate ;
        
        
        try{
        

        
            if(accObj != null){
                if (accObj.name != null){
                            accountName = accObj.name;
                }
                if (accObj.Project_Name__c!= null){
                        projectName = accObj.Project_Name__c;
                }
                if (accObj.crn__c != null){
                            crn = accObj.crn__c ;
                            accountName += ', CRN –';
                            accountName += space;
                            accountName += crn ;
                }
            }
             if(bookingObj!= null){
             
             if (bookingObj.CLuster__c != null){
                        cluster = bookingObj.CLuster__c;
             }

             if (bookingObj.Wing__c!= null){
                        wing= bookingObj.Wing__c;
             }
             if (bookingObj.Flat_No__c!= null){
                        flatNo= bookingObj.Flat_No__c;
             }
            if (bookingObj.Application_Date__c!= null){
                        applicationDate= String.valueOf(bookingObj.Application_Date__c);
             }
               if (bookingObj.Registration_Status__c!= null){
                        registrationStatus = bookingObj.Registration_Status__c;
             }
             if (bookingObj.Consideration_Value__c!= null){
                        cv= String.valueOf(bookingObj.Consideration_Value__c);
             }
             if (bookingObj.CV_paid_New__c!= null){
                        cvPaid= String.valueOf(bookingObj.CV_paid_New__c);
             }
        }
        
            if (caseList != null && caseList.size() > 0){
               emailData = '<html><body><br>';
               
                for(Case caseObj: caseList){
                    
                    flagL3A = false;
                    flagL3B = false;
                    
                    /* created date */
                    createdDateLocal = caseObj.createdDate.format('dd-MM-yyyy, hh:mm a') ;

                    /* complaint date  */                    
                    if(caseObj.Date_of_Complaint__c != null){
                        complaintDateLocal = caseObj.Date_of_Complaint__c.format('dd-MM-yyyy, hh:mm a') ;
                    }
                    /* project team lead */
                    if (caseObj.TL__c != null){
                        projectTL = caseObj.TL__c;
                    }
               if (bookingObj.CLuster__c != null) {
                   flatDetails = bookingObj.CLuster__c;
               }
               flatDetails += ' ';
               if (bookingObj.Wing__c != null) {
                   flatDetails += bookingObj.Wing__c;
               }
               flatDetails += ' ';  
               if (bookingObj.Flat_No__c != null) {
                   flatDetails += bookingObj.Flat_No__c;
               }
                   
                   
                    System.debug('!!!!flatDetails = !!!!!!!!!!' + flatDetails);
                    
                    
                    
                     if (bookingObj != null && bookingObj.Application_Date__c != null){
                        DateTime dt = DateTime.newInstance(bookingObj.Application_Date__c.year(), bookingObj.Application_Date__c.month(),bookingObj.Application_Date__c.day());
                       // bookingDate = bookingObj.Application_Date__c.format();
                        bookingDate = dt.format('dd-MM-yyyy') ;
                    }
                    
                    
                      if (bookingObj != null && bookingObj.Registration_Status__c != null){
                        bookingStatus = bookingObj.Registration_Status__c;
                    }
                    System.debug('!!!!bookingStatus = !!!!!!!!!!' + bookingStatus );
                    
                    
                    
                    
                    
                       if (bookingObj != null && bookingObj.Consideration_Value__c!= null){
                        totalCVAmount = String.valueOf(bookingObj.Consideration_Value__c);
                       // System.debug('!!!!!!!!!!!-------cvPaid = -----------------' +  cvPaid );
                    }
                    
                    
                    if (bookingObj != null && bookingObj.CV_paid_New__c != null){
                        cvPaid = String.valueOf(bookingObj.CV_paid_New__c);
                       // System.debug('!!!!!!!!!!!-------cvPaid = -----------------' +  cvPaid );
                    } 
                    
                    
                 

                    System.debug('3........................................');
                    
                    
                    
                    
                   
                System.debug('4........................................');
                
                /* Table Header */
                    emailData += startTable + font;
                    emailData += '<tr bgcolor="E3D8DA">';
                    emailData += startTH + 'Field' + endTH;
                    emailData += startTH + 'Description of the complaint in detail' + endTH ;
                    emailData += endTR;
                    System.debug('5........................................');
                    
                    /* Created date */                                   
                    emailData += startTR;
                    emailData += startTD;
                    emailData += 'Date and time stamp of case creation';
                    emailData += endTD;
                    emailData += startTD;
                    emailData += createdDateLocal;
                    emailData += endTD;
                    emailData += endTR;
                    System.debug('6........................................');                    
                   
                    /* Date of complain */     
                 
                    emailData += startTR;
                    emailData += startTD;
                    emailData += 'Date of Complaint';
                    emailData += endTD;
                    emailData += startTD;
                    emailData += complaintDateLocal;
                    emailData += endTD;
                    emailData += endTR;
                    System.debug('7........................................');                  
                    
                    /* project lead */
                    
                    emailData += startTR;
                    emailData += startTD;
                    emailData += 'Project Team Leader';
                    emailData += endTD;
                    emailData += startTD;
                    emailData += projectTL;
                    emailData += endTD;
                    emailData += endTR;
                    
                    
                    /* project name */
                    
                    
                    
                    emailData += startTR;
                    emailData += startTD;
                    emailData += 'Project Name';
                    emailData += endTD;
                    emailData += startTD;
                    emailData += projectName;
                    emailData += endTD;
                    emailData += endTR;
                    
                     System.debug('!!!!@@@@@@@@@@@@@@!!!!!!!!!!-------');
                     

                     //Booking_details__c bookingObj;
                      try{
                    
                   // System.debug('!!!!@@@@@@@@@@@@@@!!!!!!!!!!-------bookingObj = -----------------' +  bookingObj );
                    /* flat details */
                    
                    
                    }catch(Exception ex){
                        flatDetails  = '-';
                        System.debug('!exception -Booking_details__c -----' + ex);
                    }
                    emailData += startTR;
                    emailData += startTD;
                    emailData += 'Flat details';
                    emailData += endTD;
                    emailData += startTD;
                    emailData += flatDetails;
                    emailData += endTD;
                    emailData += endTR;
                    
                     /* acount name */
                  
                    
                    emailData += startTR;
                    emailData += startTD;
                    emailData += 'Customer name';
                    emailData += endTD ;
                    emailData += startTD;
                    emailData += accountName;
                    emailData += endTD;
                    emailData += endTR;


                    /* String complaintDateLocal = '-';
                    if(caseObj.Date_of_Complaint__c != null){
                        complaintDateLocal = caseObj.Date_of_Complaint__c.format('dd-MM-yyyy, hh:mm a') ;
                    }*/
                    


                   
                    emailData+= startTR;
                    emailData += startTD;
                    emailData += 'Booking Date';
                    emailData += endTD;
                    emailData += startTD;
                    emailData += bookingDate;
                    emailData += endTD;
                    emailData += endTR;
                    

                  
                    emailData+= startTR;
                    emailData += startTD;
                    emailData += 'Registration Status';
                    emailData += endTD  ;
                    emailData += startTD;
                    emailData += bookingStatus;
                    emailData += endTD;
                    emailData += endTR;
                    

                 
                    emailData+= startTR;
                    emailData += startTD;
                    emailData += 'Total CV amount';
                    emailData += endTD  ;
                    emailData += startTD;
                    emailData += totalCVAmount;
                    emailData += endTD;
                    emailData += endTR;
                    

                    
                    System.debug('!!!!cvPaid = !!!!!!!!!!' + cvPaid );
                    emailData+= startTR;
                    emailData += startTD;
                    emailData += '% CV paid';
                    emailData += endTD ;
                    emailData += startTD;
                    emailData += cvPaid;
                    emailData += endTD;
                    emailData += endTR;
                    
                     /* interaction mode */

                    if (caseObj.Interaction_Mode__c != null){
                        interactionMode = caseObj.Interaction_Mode__c;
                    }
                    emailData+= startTR;
                    emailData += startTD;
                    emailData += 'Interaction Mode';
                    emailData +=  endTD  ;
                    emailData += startTD;
                    emailData += interactionMode;
                    emailData += endTD;
                    emailData += endTR;
                    
                    
                    /* nature of request */

                    if (caseObj.Nature_of_Request__c != null){
                        natureOfRequest = caseObj.Nature_of_Request__c;
                    }
                    emailData+= startTR;
                    emailData += startTD;
                    emailData += 'Nature of Request';
                    emailData += endTD  ;
                    emailData += startTD;
                    emailData += natureOfRequest;
                    emailData += endTD;
                    emailData += endTR;
                    
                    
                    /* Request type L1 */

                    if (caseObj.Request_for_L1__c != null){
                        requestForL1= caseObj.Request_for_L1__c;
                    }
                   emailData+= startTR;
                   emailData += startTD;
                   emailData += 'Complaint Type-L1';
                   emailData += endTD;
                    emailData += startTD;
                    emailData += requestForL1;
                    emailData += endTD;
                    emailData += endTR;
                    
                    
                    /* Request type L2 */

                    if (caseObj.Request_for_L2__c != null){
                        requestForL2= caseObj.Request_for_L2__c;
                    }
                    emailData+= startTR;
                    emailData += startTD;
                    emailData += 'Complaint Type-L2' ;
                    emailData += endTD;
                    emailData += startTD;
                    emailData += requestForL2;
                    emailData += endTD;
                    emailData += endTR;
                   
                    
                     /* Request type L3 */
                    System.debug('caseObj.Request_for_L3_a__c = ' +  caseObj.Request_for_L3_a__c);
                    System.debug('caseObj.Request_for_L3__c = ' +  caseObj.Request_for_L3__c);

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
                    emailData+= startTR;
                    emailData +=  startTD;
                    emailData +=  'Complaint Type-L3';
                    emailData +=  endTD  ;
                    emailData += startTD;
                    emailData += L3data;
                    emailData += endTD;
                    emailData += endTR;
                   
                    
                   
                    
                    /* tat */

                    if (caseObj.Remaining_Hours__c != null){
                        tat = String.valueOf(caseObj.Remaining_Hours__c );
                         tat += space;
                          tat += 'Hours';
                    }
                   emailData+= startTR;
                   emailData +=  startTD;
                   emailData += 'TAT allowed for case closure';
                   emailData += endTD;
                    emailData += startTD;
                    emailData += tat;
                    emailData += endTD;
                    emailData += endTR;
                   
                    
                    /* priority */

                    if (caseObj.priority != null){
                        priority = String.valueOf(caseObj.priority);
                    }
                    emailData+= startTR;
                    emailData += startTD;
                    emailData += 'Case Priority';
                    emailData += endTD  ;
                    emailData += startTD;
                    emailData +=  priority;
                    emailData += endTD;
                    emailData += endTR;
                   
                   
                   
                   /* child cases and action items */
                    emailData+= '<tr><td style="border:0.1px dotted;">&nbsp;Dependency on Internal Lodha Functions&nbsp;</td>';
                    
                    boolean childCasesExists = false;
                    boolean dependencyCommentsExist = false;
                    
                    String childCasesData = '';
                    String dependencyCommentsData = '';
                    String cellData = '';
                    
                    List<Case> childCasesList = getChildCases(caseObj);
                    if(childCasesList != null && childCasesList.size() > 0){
                        childCasesExists = true;
                        childCasesData = startTD + startTable +  font;
                        childCasesData += '<tr>' + startTH + 'Case Number' + endTH + startTH + 'Assignee' + endTH + startTH + 'Status' + endTH + '</tr>';
                        for(Case childCaseObj : childCasesList ){
                            childCasesData += '<tr>' + startTD  + childCaseObj.CaseNumber + endTD ;
                            childCasesData += startTD  + childCaseObj.owner.Name + endTD ;
                            childCasesData += startTD  + childCaseObj.status+ endTD + '</tr>';
                        }
                    }
                    System.debug('childCasesData = ' + childCasesData );
                    
                    dependencyCommentsData  = caseObj.Dependency_on_Internal_functions__c;
                    System.debug('dependencyCommentsData  = ' + dependencyCommentsData  );
                    
                    if (dependencyCommentsData != null && !dependencyCommentsData .equals('')){
                        dependencyCommentsExist = true;
                    }
                    
                    if (!childCasesExists && !dependencyCommentsExist ){
                        cellData = '<td style="border:0.1px dotted;" >&nbsp;Nil</td></tr>';
                    }
                    if (!childCasesExists && dependencyCommentsExist ){
                        cellData = '<td style="border:0.1px dotted;" >&nbsp;' + dependencyCommentsData + '</td></tr>';
                    }
                    if (childCasesExists && !dependencyCommentsExist ){
                        cellData = childCasesData + endTable + '</td></tr>';
                    }
                    if (childCasesExists && dependencyCommentsExist ){
                        cellData = childCasesData;
                        cellData += '<tr>' + startTD  + dependencyCommentsData + endTD + '</tr></table></td></tr>';
                    }
                    System.debug('cellData = ' + cellData );
                     
                    emailData += cellData;
                    
                    
                        
                    
                   
                   
                   
                   
                   

                    if (caseObj.Status  != null){
                        status = caseObj.Status ;
                    }
                   emailData+= startTR;
                   emailData +=  startTD;
                   emailData +=  'Case Status';
                   emailData += endTD;
                    emailData += startTD;
                    emailData +=   status;
                    emailData += endTD;
                    emailData += endTR;
                     
                     
                     
                     
                     /* activity history */
                    emailData+= '<tr>' + startTD + 'Customer Email/Call Link' + endTD + startTD;
                    
                    List<String> activityHistoryList = getActivityHistory(caseObj);
                    if(activityHistoryList != null && activityHistoryList.size() > 0){
                        emailData+= startTable + font;
                        for(String ahObj : activityHistoryList ){
                            if (ahObj != null && !ahObj.equals('')){
                                emailData += '<tr>' + startTD  + ahObj + endTD + '</tr>';
                            }
                        }
                        emailData += '</font>' + endTable;
                    }else{
                        emailData += space + '-';
                    }
                    emailData+= '</td></tr>';
                    emailData+= '</font>' + endTable;
                                      
                    emailData += endTable;
                    
                    /* case link */
                    String hostname = System.URL.getSalesforceBaseUrl().getHost();
                    hostname += '/';
                    hostname += caseObj.Id;
                   // System.debug('---hostname ' + hostname + '------caseObj.Id = ' +  caseObj.Id + '-------' + hostname );
                    emailData += font + '<br><a href="' + hostname + '">Case Link in SFDC to view complete customer interaction history </a><br>';
                   
                   
                    /* summary */
                    String caseSummary = '';
                    if (caseObj.Case_Summary__c != null){
                        caseSummary = caseObj.Case_Summary__c;
                    }
                    emailData+= '<br><br><u>Complaint Summary</u> :<br>' + caseSummary  + '</br>';
                    
                    
                      
                    /* resolution */
                    String caseResolution = '';
                    if (caseObj.Case_Resolution__c != null){
                        caseResolution = caseObj.Case_Resolution__c;
                    }
                    emailData+= '<br><u>Resolution provided</u> :<br>' + caseResolution + '<br>';
                    emailData += '<br><br><br></font>';
                }
                
                 emailData += '</font></body></html>';
                    
            } //end of if
        }//end of try
        catch(Exception ex){
            System.debug('Error in CM_CustomReportGenerator_MORN - generateEmailContents => ' + ex.getMessage());
        }
        
        System.debug('Cases table data = ' + emailData );
                        
        return emailData;
    }

          /* This method will return a map with
    CRN as key and List of complaint cases against the customer as data */
    public Map<String, List<Case>> generateCustomersToCasesMap(List<Case> caseList){
        Map<String, List<Case>> customerMap = new Map<String, List<Case>>();
        List<Case> customerCasesList;
        
        System.debug('Complaint case List Received = ' + caseList);
        
        try{
            for(Case caseObj: caseList){
                 Case caseObjTemp = [select Id, account.CRN__c from case where Id =: caseObj.Id];
                 if (caseObjTemp.account != null && caseObjTemp.account.CRN__c != null){
                    String key = caseObjTemp.account.CRN__c;
                    System.debug('key  = ' + key);
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
    
    
    
}