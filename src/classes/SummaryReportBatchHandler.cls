/*
*    Description: Handler Class for Summary Report Batch Class to develop an Email along with attachments
*    
*    Version       Date            Name             Description
*    1.0           07/07/2014      Asmita           Initial Draft 
*    1.1           06/09/2014      Siddharth        Changes made in method getEmailContents to rectify
*                                                   the Summary displayed in Email
*    1.2           11/11/2014      Asmita           Modified the code for adding TL Email Address in CC
*    1.3           21/11/2014      Anupam Agrawal   Bug related to Gmail report format
*/

public class SummaryReportBatchHandler{
    
    private static final String STRFROMDISPLAYNAME = 'Lodha Admin';
    private static final String STRREPLYTOID = 'donotreply@lodhagroup.com';
    
    private static final String STRSUBJECT1 = 'Standard complaints: ';
    private static final String STRSUBJECT2 = ' - Complaints for ';
    private static final String STRDATESEPARATOR = '/';
    
    private static final String STREMAILCONTENT1 = 'Dear All,<br><br> PFA the summary report of the “Complaint” Cases and “Grievance” Cases reported for  ';
    private static final String STREMAILCONTENT2 = '. <br><br>';
    private static final String STREMAILCONTENT3 = '<br><br>Regards,<br>Admin IT<br><br>Note: This is a system generated report. Do not reply to this email.';
    private static final String STRCOMPLAINTTYPEJOIN = ' - ';
    //1.3 inline css on table tag
    private static final String STRSUMMARYCONTENTSTYLE = '<br><br><style type= "text/css"> table { width: 400px; font-family: Arial, Helvetica, sans-serif;} table, td, th {  border: 1px solid black; background-color:#E0EEEE; text-align:center;} th {background-color: #71A4E6; text-align: center; font-size: 12px} td{font-size: 12px}</style>'+
                                                         '<table border="1" style="background-color:#E0EEEE;">';
    private static final String STRCOMPLAINTHEADER = 'Summary Report For Complaint Cases ';
    //1.3 inline css on tr tag
    private static final String STRCOMPLAINTTABLE = '<tr style="background-color: #71A4E6;"><th>Date of Complaint</th><th>Project Name</th><th>Complaint Type</th>'+
                                                     '<th># of Complaints</th></tr>';
    private static final String STRGRIEVANCEHEADER = 'Summary Report For Grievance Cases ';
    private static final String STRGRIEVANCETABLE = '<tr style="background-color: #71A4E6;"><th>Date of Grievance</th><th>Project Name</th><th>Complaint Type</th><th># of Complaints</th></tr>';
    
    private static final String STREMAILATTACHMENTSTYLE = '<style>table {border-collapse: collapse; width: auto;}table, td, th {border: 1px solid black;} th {background-color: #71A4E6; text-align: center; font-size: 14px;} td {font-size: 14px;}</style><table><tr>';
    private static final String STREMAILATTACHMENTFILENAME1 = 'Customer Complaints Cases For ';
    private static final String STREMAILATTACHMENTFILENAME2 = 'Customer Grievance Cases For ';
    private static final String STREMAILATTACHMENTFILEEXTENSION = '.html';
    private static final String STRDATESEPARATOR1 = '-';
    
    private static final String STRCOMPLAINT = 'Complaint';
    private static final String STRGRIEVANCE = 'Grievance';
    
    private static final String STRTO = 'to';
    private static final String STRCC = 'Cc';
    private static final String STRBCC = 'Bcc';
    private static final String STRSUMMARY = 'Summary';
    
    Map<String, CM_Reporting_EmailIds__c> mapEmailIdCustomSetting = new Map<String, CM_Reporting_EmailIds__c>();

    // Sending and Email per project
    public void sendSummaryReportEmail(List<Case> pListCase, String pStrProjectName){
        
        Set<String> setToAddress = new Set<String>();
        Set<String> setCcAddress = new Set<String>();
        Set<String> setBccAddress = new Set<String>();
        
        List<Case> listComplaintCase = new List<Case>();
        List<Case> listGrievanceCase = new List<Case>();
        
        String strFromAddress = '';
        String strSubject = '';
        String strEmailContents = '';
        String strEmailAttachment = '';
        String STRCOMPLAINTAttachment = '';
        String STRGRIEVANCEAttachment = '';
        String STRCOMPLAINTSummaryContents = '';
        String STRGRIEVANCESummaryContents = '';
        
        blob excelBlobForComplaints;
        blob excelBlobForGrievance;
        
        if(!pListCase.isEmpty()){
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            // Setting From Address
            //strFromAddress = getFromAddress(pListCase);
            mail.setSenderDisplayName(STRFROMDISPLAYNAME);
            mail.setReplyTo(STRREPLYTOID);          
            
            // Setting To Address
            setToAddress = getToAddresses();
            if(!setToAddress.isEmpty())
                mail.setToAddresses(new List<String>(setToAddress));                
                
            // Setting CC Address
            setCcAddress = getCcAddresses(pListCase);
            System.debug('CC address set after getting all CC ::::: ' + setCcAddress);
            if(!setCcAddress.isEmpty())
                mail.setCcAddresses(new List<String>(setCcAddress));                
                
            // Setting BCC Address
            setBccAddress = getBccAddresses();
            if(!setBccAddress.isEmpty())
                mail.setBccAddresses(new List<String>(setBccAddress));              
                
            // Setting Email Subject
            strSubject = STRSUBJECT1 + pStrProjectName + STRSUBJECT2 + (Date.today().addDays(-1)).day() + STRDATESEPARATOR1;
            strSubject = strSubject + (Date.today().addDays(-1)).month() + STRDATESEPARATOR1 + (Date.today().addDays(-1)).year();
            mail.setSubject(strSubject);

            //Creating two separate case list for Complaint and Grievance
            for(Case oCase : pListCase){
                
                if(oCase.Nature_of_Request__c != null){
                    if(oCase.Nature_of_Request__c.equalsIgnoreCase(STRCOMPLAINT))
                        listComplaintCase.add(oCase);
                    else if(oCase.Nature_of_Request__c.equalsIgnoreCase(STRGRIEVANCE))
                        listGrievanceCase.add(oCase);
                }
            }           
            
            // Setting Email Contents
            strEmailContents = STREMAILCONTENT1 + Date.today().addDays(-1).day() + STRDATESEPARATOR1 + Date.today().addDays(-1).month();
            strEmailContents = strEmailContents + STRDATESEPARATOR1 + Date.today().addDays(-1).year() +STREMAILCONTENT2;
            
            // Summary Report for Complaint cases
            if(!listComplaintCase.isEmpty()){
                
                STRCOMPLAINTSummaryContents = getEmailContents(listComplaintCase, STRCOMPLAINT, pStrProjectName);
                if(!String.isBlank(STRCOMPLAINTSummaryContents))
                    strEmailContents = strEmailContents +  STRCOMPLAINTSummaryContents;
            }
            
            // Summary Report for Grievance Cases
            if(!listGrievanceCase.isEmpty()){
                
                STRGRIEVANCESummaryContents = getEmailContents(listGrievanceCase, STRGRIEVANCE, pStrProjectName);
                if(!String.isBlank(STRGRIEVANCESummaryContents))
                     strEmailContents = strEmailContents +  STRGRIEVANCESummaryContents;
            }
            
            strEmailContents = strEmailContents + STREMAILCONTENT3;             
            mail.setHTMLBody(strEmailContents);

            // Setting Attachments
            // Complaint Cases Attachment           
            List<Messaging.EmailFileAttachment> htmlAttchment = new List<Messaging.EmailFileAttachment>();
            
            if(!listComplaintCase.isEmpty()){
                STRCOMPLAINTAttachment = getAttachmentContents(listComplaintCase, pStrProjectName, STRCOMPLAINT);
                if(!String.isBlank(STRCOMPLAINTAttachment)){
    
                    Messaging.EmailFileAttachment excelAttchmentForComplaint = new Messaging.EmailFileAttachment();
                    
                    STRCOMPLAINTAttachment = STREMAILATTACHMENTSTYLE + STRCOMPLAINTAttachment;
                    excelBlobForComplaints = Blob.valueOf(STRCOMPLAINTAttachment);
                    
                    String filename = STREMAILATTACHMENTFILENAME1 + Date.today().addDays(-1).day() + STRDATESEPARATOR1 + Date.today().addDays(-1).month();
                    fileName = fileName + STRDATESEPARATOR1 + Date.today().addDays(-1).year() + STREMAILATTACHMENTFILEEXTENSION;                     
                    excelAttchmentForComplaint.setFileName(filename);
                    
                    excelAttchmentForComplaint.setBody(excelBlobForComplaints);
                    htmlAttchment.add(excelAttchmentForComplaint);
                }
            }
            
            // Grievance Cases Attachment
            if(!listGrievanceCase.isEmpty()){
                STRGRIEVANCEAttachment = getAttachmentContents(listGrievanceCase, pStrProjectName, STRGRIEVANCE);
                if(!String.isBlank(STRGRIEVANCEAttachment)){
    
                    Messaging.EmailFileAttachment excelAttchmentForGrievance = new Messaging.EmailFileAttachment();
                    
                    STRGRIEVANCEAttachment = STREMAILATTACHMENTSTYLE + STRGRIEVANCEAttachment;
                    excelBlobForGrievance = Blob.valueOf(STRGRIEVANCEAttachment);
                    
                    String filename = STREMAILATTACHMENTFILENAME2 + Date.today().addDays(-1).day() + STRDATESEPARATOR1 + Date.today().addDays(-1).month();
                    fileName = fileName + STRDATESEPARATOR1 + Date.today().addDays(-1).year() + STREMAILATTACHMENTFILEEXTENSION;                     
                    excelAttchmentForGrievance.setFileName(filename );
                    
                    excelAttchmentForGrievance.setBody(excelBlobForGrievance);
                    htmlAttchment.add(excelAttchmentForGrievance);
                }
            }
                        
            if(!htmlAttchment.isEmpty()){               
                mail.setFileAttachments(htmlAttchment);
            }       
                
            // Sending an email
            if(!Test.isRunningTest())
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            
        }// end of pList isEmpty if
        
    }// end of sendSummaryReportEmail()
    
    // Method to get the List of To Addresses
    public Set<String> getToAddresses(){

        Set<String> setEmailToAddress = new Set<String>();
        mapEmailIdCustomSetting = new Map<String, CM_Reporting_EmailIds__c>();
        
        mapEmailIdCustomSetting = CM_Reporting_EmailIds__c.getAll();
        
        if(!mapEmailIdCustomSetting.isEmpty()){
            for(CM_Reporting_EmailIds__c setting : mapEmailIdCustomSetting.values()){
                if(setting.To_CC_Bcc__c != null && setting.Report_Type__c != null)
                    if(setting.To_CC_Bcc__c.equalsIgnoreCase(STRTO) && setting.Report_Type__c.equalsIgnoreCase(STRSUMMARY))
                        setEmailToAddress.add(setting.Email_Id__c);
            }
        }
        
        return setEmailToAddress;
    }
    
    
    // Method to get the List of CC Addresses
    public Set<String> getCcAddresses(List<Case> pListCase){
    
        Set<String> setEmailCcAddress = new Set<String>();
        mapEmailIdCustomSetting = new Map<String, CM_Reporting_EmailIds__c>();
        
        mapEmailIdCustomSetting = CM_Reporting_EmailIds__c.getAll();
        
        // Getting CC Email Addresses from the Custom Setting Data
        if(!mapEmailIdCustomSetting.isEmpty()){
            for(CM_Reporting_EmailIds__c setting : mapEmailIdCustomSetting.values()){
                if(setting.To_CC_Bcc__c != null && setting.Report_Type__c != null)
                    if(setting.To_CC_Bcc__c.equalsIgnoreCase(STRCC) && setting.Report_Type__c.equalsIgnoreCase(STRSUMMARY))
                        setEmailCcAddress.add(setting.Email_Id__c);
            }
        }
        System.debug('CC address set after custom setting ::::: ' + setEmailCcAddress);
        
         // 1.2 Asmita
        // Getting Email Address of RM's Manager which is stored in TL_EmailId field in Case, to set as CC
        if(!pListCase.isEmpty()){
            for(Case oCase : pListCase){
                if(!String.isBlank(oCase.TL_EmailId__c)){
                    setEmailCcAddress.add(oCase.TL_EmailId__c);
                }
            }
        }
        System.debug('CC address set with TL ::::: ' + setEmailCcAddress);
        
        // Commented for testing
        // Getting Email Address of RM's Manager's Manager which is stored in PIC_EmailId field in Case, to set as CC
        if(!pListCase.isEmpty()){
            for(Case oCase : pListCase){
                if(!String.isBlank(oCase.PIC_EmailId__c)){
                    setEmailCcAddress.add(oCase.PIC_EmailId__c);
                }
            }
        }
        System.debug('CC address set with PIC ::::: ' + setEmailCcAddress);
        
        // adding address for testing
        //setEmailCcAddress.add('asmitab.eternus@lodhagroup.com');
        
        return setEmailCcAddress;
    }
    
    
    // Method to get the List of BCC Addresses
    public Set<String> getBccAddresses(){
        
        Set<String> setEmailBccAddress = new Set<String>();
        mapEmailIdCustomSetting = new Map<String, CM_Reporting_EmailIds__c>();
        
        mapEmailIdCustomSetting = CM_Reporting_EmailIds__c.getAll();
        
        if(!mapEmailIdCustomSetting.isEmpty()){
            for(CM_Reporting_EmailIds__c setting : mapEmailIdCustomSetting.values()){
                if(setting.To_CC_Bcc__c != null && setting.Report_Type__c != null)
                    if(setting.To_CC_Bcc__c.equalsIgnoreCase(STRBCC) && setting.Report_Type__c.equalsIgnoreCase(STRSUMMARY))
                        setEmailBccAddress.add(setting.Email_Id__c);
            }
        }
        
        return setEmailBccAddress;
    }
    
    // Method to generate the Email Content Summary of Complaint anf Grievance Cases
    public String getEmailContents(List<Case> pListCase, String pComplaintType, String pStrProjectName){
        
        String STRCOMPLAINTSummary = '';
        String STRGRIEVANCESummary = '';
        String STRCOMPLAINTType = '';
        String strEmailContent = '';
        
        Date dCaseDate = null;
        
        Set<String> setComplaintType = new Set<String>();
        Set<Date> setCaseDate = new Set<Date>();

        List<Case> listComplaintTypeCase = new List<Case>();        
        
        Map<Date, Set<String>> mapComplaintDateComplaintType = new Map<Date, Set<String>>();
        Map<Date, List<Case>> mapComplaintDateCase = new Map<Date, List<Case>>();
        
        //Siddharth 1.1
        Map<Date, List<Case>> mapDateWiseCases = new Map<Date, List<Case>>();
        String strEmailTableContent = '';
        
        //Siddharth 1.1
        for(Case oCase : pListCase){
            
            if(pComplaintType.equalsIgnoreCase(STRCOMPLAINT)){
            	
            	if(oCase.Date_of_Complaint__c != NULL){
            	    
            	    if(!mapDateWiseCases.containsKey(oCase.Date_of_Complaint__c.date())){
                	    List<Case> tempCaseList = new List<Case>();
                	    tempCaseList.add(oCase);
                        mapDateWiseCases.put(oCase.Date_of_Complaint__c.date(), tempCaseList);
                    }
                    else{
                        List<Case> tempCaseList = mapDateWiseCases.get(oCase.Date_of_Complaint__c.date());
                        tempCaseList.add(oCase);
                        mapDateWiseCases.put(oCase.Date_of_Complaint__c.date(), tempCaseList);
                    }
            	}
            }
            if(pComplaintType.equalsIgnoreCase(STRGRIEVANCE)){
            	
            	if(oCase.Date_of_Grievance__c != NULL){
            	
            	    if(!mapDateWiseCases.containsKey(oCase.Date_of_Grievance__c.date())){
                    	List<Case> tempCaseList = new List<Case>();
                	    tempCaseList.add(oCase);
                        mapDateWiseCases.put(oCase.Date_of_Grievance__c.date(), tempCaseList);
                    }
                    else{
                        List<Case> tempCaseList = mapDateWiseCases.get(oCase.Date_of_Grievance__c.date());
                        tempCaseList.add(oCase);
                        mapDateWiseCases.put(oCase.Date_of_Grievance__c.date(), tempCaseList);
                    }
            	}
            }
        } 
        if(pComplaintType.equalsIgnoreCase(STRCOMPLAINT)){
            strEmailTableContent = strEmailTableContent + STRCOMPLAINTHEADER + STRSUMMARYCONTENTSTYLE + STRCOMPLAINTTABLE;
        }
        else if(pComplaintType.equalsIgnoreCase(STRGRIEVANCE)){
        
            strEmailTableContent = strEmailTableContent + STRGRIEVANCEHEADER + STRSUMMARYCONTENTSTYLE + STRGRIEVANCETABLE;
        }
        
        //Siddharth 1.1
        //Iterate over mapDateWiseCases Map
        for(List<Case> caseList : mapDateWiseCases.values()){
        
            Map<String, Integer> mapL1L2Cases = new Map<String, Integer>();
            
            for(Case oCase : caseList){
                
                String strL1L2 = oCase.Request_for_L2__c != null ? oCase.Request_for_L1__c + STRCOMPLAINTTYPEJOIN + oCase.Request_for_L2__c : oCase.Request_for_L1__c;
                if(!mapL1L2Cases.containsKey(strL1L2)){
                    mapL1L2Cases.put(strL1L2, 1);
                }
                else{
                    mapL1L2Cases.put(strL1L2, (mapL1L2Cases.get(strL1L2) + 1));
                }
            }
            
            Datetime dtTemp = pComplaintType.equalsIgnoreCase(STRCOMPLAINT) ? caseList[0].Date_of_Complaint__c : caseList[0].Date_of_Grievance__c;
            
            for(String strL1L2 : mapL1L2Cases.keySet()){
                //1.3 fix the html formation and added inline css on tr tag
                strEmailTableContent =  strEmailTableContent +'<tr style="text-align:center;">' + '<td>' + dtTemp.day() + STRDATESEPARATOR1 + dtTemp.month();
                strEmailTableContent = strEmailTableContent + STRDATESEPARATOR1 +  dtTemp.year() + '</td>';
                strEmailTableContent = strEmailTableContent + '<td>' + pStrProjectName + '</td>';
                strEmailTableContent = strEmailTableContent + '<td>' + strL1L2 + '</td>';
                strEmailTableContent = strEmailTableContent + '<td>' + mapL1L2Cases.get(strL1L2) + '</td></tr>'; 
            }
        }
        return strEmailTableContent + '</table><br><br>';
    }// end of getEmailContents()
    
    
    // Method to generate the attachment contents for Complaint and Grievance Cases
    public String getAttachmentContents(List<Case> caseList, String pStrProjectName, String STRCOMPLAINTType){
        
        String contents = '';
        String tabChar = '</td><td>';
        String nextLine = '</td></tr><tr>';
        String emptyChar = '-';
        
        if (caseList != null && caseList.size() > 0){
            
            String cluster = '';
            String wing = '';
            String flatNo = '';
            String accountName = '';
            String crn = '';
            String strFieldName = '<th style="padding: 0px 50px 0px 50px">Field Name</th>';
            String projectName = '<td>Project Name';
            String caseNumber = '<td>Case Number';
            String createdDate = '<td>Date and time stamp of case creation';
            
            String dateOfComplaintGrievance;
            if(STRCOMPLAINTType == STRCOMPLAINT)
                dateOfComplaintGrievance = '<td>Date of Complaint';
            else if(STRCOMPLAINTType == STRGRIEVANCE)
                dateOfComplaintGrievance = '<td>Date of Grievance';
                
            String tl = '<td>Project Team Leader';
            String flatDetails = '<td>Flat details';
            String customerName = '<td>Customer name';
            String applicationDate = '<td>Booking Date';
            String registrationStatus = '<td>Registration Status';
            String considerationValue = '<td>Total CV amount';
            String cvPaid= '<td>% CV paid';            
            String interactionMode ='<td>Interaction Mode';
            String natureOfRequest = '<td>Nature of Request';
            String requestForL1 = '<td>Complaint Type-L1';
            String requestForL2 = '<td>Complaint Type-L2';
            String L3data = '<td>Complaint Type-L3';
            String tatAllowedForCaseClosure = '<td>TAT allowed for case closure';
            String priority = '<td>Case Priority';
            String dependenciesOnInternalFunctions = '<td>Dependency on Internal Lodha Functions';
            String caseStatus = '<td>Case Status'; 
            String emailCallLink = '<td>Customer Email/Call Link';
            String caseLink = '<td>Case Link in SFDC to view complete customer interaction history';
            String complaintsSummary = '<td>Complaint Summary';
            String complaintResolution = '<td>Complaint Resolution';
            
            Map<Id, List<String>> caseDetailMap = new Map<Id, List<String>>();
            Map<Id, List<Case>> childCasesMap = new Map<Id, List<Case>>();
            Map<Id, List<String>> activityHistoryMap = new Map<Id, List<String>>();
            
            caseDetailMap = generateAccountMap(caseList);
            childCasesMap = getChildCases(caseList); 
            activityHistoryMap = getActivityHistory(caseList);
            
            for(Integer i=0; i<caseList.size(); i++){

                strFieldName = strFieldName + '<th>' + 'Case' + (i + 1) + '</th>';
                
                if (caseDetailMap.containsKey(caseList[i].Account.Id)){
                    
                    // If the Account does not have booking details then assigning only account details
                    if(caseDetailMap.get(caseList[i].Account.Id).size() <= 3){
                        
                        // Project Name
                        projectName = (caseDetailMap.get(caseList[i].Account.Id).get(0) != null) ? (projectName + tabChar + caseDetailMap.get(caseList[i].Account.Id).get(0).toUpperCase()) : (projectName + tabChar + emptyChar);                  
                            
                        // Account Name
                        accountName = (caseDetailMap.get(caseList[i].Account.Id).get(1) != null) ? (caseDetailMap.get(caseList[i].Account.Id).get(1)) : (accountName = emptyChar);
                            
                        // CRN
                        crn = (caseDetailMap.get(caseList[i].Account.Id).get(2) != null && !caseDetailMap.get(caseList[i].Account.Id).get(2).equals('')) ? (caseDetailMap.get(caseList[i].Account.Id).get(2)) : (emptyChar);
                            
                        // Completing the <td> tag for applicationDate, registrationDate, considerationValue, CvPaid  as it will not enter in else
                        applicationDate = applicationDate + tabChar + emptyChar;
                        registrationStatus = registrationStatus + tabChar + emptyChar;
                        considerationValue = considerationValue + tabChar + emptyChar;
                        cvPaid = cvPaid + tabChar + emptyChar;
                    }
                    else{
                        
                        // ----- Project Name ----
                        projectName = (caseDetailMap.get(caseList[i].Account.Id).get(0) != null) ? (projectName + tabChar + caseDetailMap.get(caseList[i].Account.Id).get(0).toUpperCase()) : (projectName + tabChar + emptyChar);

                        // Cluster
                        cluster = (caseDetailMap.get(caseList[i].Account.Id).get(3) != null && !caseDetailMap.get(caseList[i].Account.Id).get(3).equals('')) ? (caseDetailMap.get(caseList[i].Account.Id).get(3)) : (emptyChar);
                        
                        // Wing
                        wing = (caseDetailMap.get(caseList[i].Account.Id).get(4) != null && !caseDetailMap.get(caseList[i].Account.Id).get(4).equals('')) ? (caseDetailMap.get(caseList[i].Account.Id).get(4)) : (emptyChar);
                        
                        //Flat
                        flatNo = (caseDetailMap.get(caseList[i].Account.Id).get(5) != null && !caseDetailMap.get(caseList[i].Account.Id).get(5).equals('')) ? (caseDetailMap.get(caseList[i].Account.Id).get(5)) : (emptyChar);
                            
                        // Account Name
                        accountName = (caseDetailMap.get(caseList[i].Account.Id).get(1) != null) ? (caseDetailMap.get(caseList[i].Account.Id).get(1)) : (emptyChar);
                         
                        // ---- Booking Date ----   
                        // Application Date
                        applicationDate = (caseDetailMap.get(caseList[i].Account.Id).get(6) != null && !String.valueOf(caseDetailMap.get(caseList[i].Account.Id).get(6)).equals('')) ? (applicationDate + tabChar + caseDetailMap.get(caseList[i].Account.Id).get(6)) : (applicationDate + tabChar + emptyChar);
                        
                        // ---- Registration Status ----
                        registrationStatus = (caseDetailMap.get(caseList[i].Account.Id).get(7) != null && !caseDetailMap.get(caseList[i].Account.Id).get(7).equals('')) ? (registrationStatus + tabChar + caseDetailMap.get(caseList[i].Account.Id).get(7)) : (registrationStatus + tabChar + emptyChar);
                            
                        // ---- Consideration Value ----
                        considerationValue = (caseDetailMap.get(caseList[i].Account.Id).get(8) != null && !String.valueOf(caseDetailMap.get(caseList[i].Account.Id).get(8)).equals('')) ? (considerationValue + tabChar + caseDetailMap.get(caseList[i].Account.Id).get(8)) : (considerationValue + tabChar + emptyChar);
                            
                        // ---- CV Paid ----
                        cvPaid = (caseDetailMap.get(caseList[i].Account.Id).get(9) != null && !String.valueOf(caseDetailMap.get(caseList[i].Account.Id).get(9)).equals('')) ? (cvPaid + tabChar + caseDetailMap.get(caseList[i].Account.Id).get(9)) : (cvPaid + tabChar + emptyChar);
                            
                        // CRN
                        crn = (caseDetailMap.get(caseList[i].Account.Id).get(2) != null && !caseDetailMap.get(caseList[i].Account.Id).get(2).equals('')) ? (caseDetailMap.get(caseList[i].Account.Id).get(2)) : (emptyChar);

                    }
                }// end of if
                
                // ----- Case Number -----
                caseNumber = caseNumber + tabChar + caseList[i].caseNumber;                
                
                // ---- Date and time stamp of case creation ----
                createdDate = (caseList[i].createdDate != null) ? (createdDate + tabchar + caseList[i].createdDate.format('dd-MM-yyyy, hh:mm a')) : (createdDate + tabChar + '');
                
                // ---- Date of Complaint / Date og Grievance
                if(strComplaintType == STRCOMPLAINT){
                    
                    if (caseList[i].Nature_of_Request__c!= null && caseList[i].Nature_of_Request__c.equals(STRCOMPLAINT)){
                        dateOfComplaintGrievance = (caseList[i].Date_of_Complaint__c != null && !((String.valueOf(caseList[i].Date_of_Complaint__c)).equals(''))) ? (dateOfComplaintGrievance + tabchar + caseList[i].Date_of_Complaint__c.format('dd-MM-yyyy, hh:mm a')) : (dateOfComplaintGrievance + tabChar + emptyChar);
                    }
                }
                else if(strComplaintType == STRGRIEVANCE){
                    
                    if (caseList[i].Nature_of_Request__c!= null && caseList[i].Nature_of_Request__c.equals(STRGRIEVANCE)){
                        dateOfComplaintGrievance = (caseList[i].Date_of_Grievance__c != null && !((String.valueOf(caseList[i].Date_of_Grievance__c)).equals(''))) ? (dateOfComplaintGrievance + tabChar + caseList[i].Date_of_Grievance__c.format('dd-MM-yyyy, hh:mm a')) : (dateOfComplaintGrievance + tabChar + emptyChar);
                    }
                }
                else{
                    dateOfComplaintGrievance = dateOfComplaintGrievance + tabChar + emptyChar ;
                }
                
                
                // ---- Project Team Leader ----
                tl = (caseList[i].TL__c != null) ? (tl + tabChar + caseList[i].TL__c) : (tl + tabChar + emptyChar);
                
                // ---- Flat details ----
                flatDetails =  flatDetails + tabChar + cluster + ' ' + wing + ' ' + flatNo;
                
                
                // ---- Customer name ----
                customerName = customerName + tabChar + accountName+' , CRN- ' + crn ;
                                
                
                // ---- Interaction Mode ----
                interactionMode = (caseList[i].Interaction_Mode__c != null) ? (interactionMode + tabChar + caseList[i].Interaction_Mode__c) : (interactionMode + tabChar + emptyChar);                
                
                // ---- Nature of Request ----
                natureOfRequest = (caseList[i].Nature_of_Request__c!= null) ? (natureOfRequest + tabChar + caseList[i].Nature_of_Request__c) : (natureOfRequest + tabChar + emptyChar);
                
                // ---- Complaint Type-L1 ----
                requestForL1 = (caseList[i].Request_for_L1__c != null) ? (requestForL1 + tabChar + caseList[i].Request_for_L1__c) : (requestForL1 + tabChar + emptyChar);                
                
                // ---- Complaint Type-L2 ----
                requestForL2 = (caseList[i].Request_for_L2__c != null) ? (requestForL2 + tabChar + caseList[i].Request_for_L2__c) : (requestForL2 + tabChar + emptyChar);
                
                // ----- Complaint Type-L3 ---- 
                boolean flagL3A = false;
                boolean flagL3B = false;
                
                //String L3data = '';
                if (caseList[i].Request_for_L3_a__c != null){
                    flagL3A = true;
                    L3data = L3data + tabChar + caseList[i].Request_for_L3_a__c;
                }
                if (caseList[i].Request_for_L3__c != null){
                    flagL3B = true;
                    L3data = L3data + tabChar + caseList[i].Request_for_L3__c;
                }  
                if (flagL3A == false && flagL3B == false){
                    L3data = L3data + tabChar + emptyChar;
                }
                
                
                // ---- TAT allowed for case closure ----
                if (caseList[i].Remaining_Hours__c != null){
                    Integer remainingHours = Integer.valueOf(caseList[i].Remaining_Hours__c);
                    tatAllowedForCaseClosure = tatAllowedForCaseClosure + tabchar + String.valueOf(remainingHours ) + ' Hours';
                }else{
                    tatAllowedForCaseClosure = tatAllowedForCaseClosure + tabchar + emptyChar ;  
                }
                
                
                // ---- Case Priority ----
                priority =  (caseList[i].priority != null) ? (priority + tabChar + String.valueOf(caseList[i].priority)) : (priority + tabChar + emptyChar );
                
                // ---- Dependency on Internal Lodha Functions ----
                boolean childCasesExists = false;
                boolean dependencyCommentsExist = false;
    
                String childCasesData = '';
                String dependencyCommentsData = '';
                String cellData = '';

                List<Case> childCasesList = new List<Case>();
                
                if(childCasesMap.containsKey(caseList[i].Id)){
                    childCasesList = childCasesMap.get(caseList[i].Id);
                }       
                if(!childCasesList.isEmpty()){
                    childCasesExists = true;
               
                    childCasesData += 'Case Number : Assignee : Status | ';
                
                    for(Case childCaseObj : childCasesList ){
                        childCasesData +=  childCaseObj.CaseNumber + ':';
                        childCasesData +=  childCaseObj.owner.Name + ':';
                        childCasesData += childCaseObj.status + '|';
                    }
                }
                
                dependencyCommentsData  = caseList[i].Dependency_on_Internal_functions__c;

                if (dependencyCommentsData != null && !dependencyCommentsData.equals('')){
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

                if (cellData != null){
                    dependenciesOnInternalFunctions = dependenciesOnInternalFunctions + tabChar + cellData ;
                }else{
                    dependenciesOnInternalFunctions = dependenciesOnInternalFunctions + tabChar + emptyChar ;
                }
                
                
                // ---- Case Status ----
                if (caseList[i].Status  != null){
                    caseStatus = caseStatus + tabChar + caseList[i].Status ;
                }else{
                    caseStatus = caseStatus + tabChar + emptyChar ;
                }    
                
                
                // ---- Customer Email/Call Link ----
                List<String> activityHistoryList;
                if (activityHistoryMap.containsKey(caseList[i].Id)){
                      activityHistoryList = activityHistoryMap.get(caseList[i].Id);
                  }
                  
                if(activityHistoryList != null && activityHistoryList.size() > 0){
                    for(String ahObj : activityHistoryList ){
                        if (ahObj != null && !ahObj.equals('')){
                        
                            emailCallLink = emailCallLink + tabChar + ahObj + '|';
                        }
                    }
                }else{
                    emailCallLink = emailCallLink + tabChar + emptyChar ;
                }
                
                
                // ---- Case Link in SFDC to view complete customer interaction history ----
                String hostname = 'https://';
                hostname += System.URL.getSalesforceBaseUrl().getHost();
                hostname += '/';
                hostname += caseList[i].Id;
                
                caseLink = caseLink + tabchar +  '<a href=" ' + hostname + ' ">'+ hostname + '</a>' ; 
                
                
                // ---- Complaint Summary ----
                if (caseList[i].Case_Summary__c != null){
                    
                    String replaceStr = caseList[i].Case_Summary__c.replace('\r\n','. ');               
                    complaintsSummary = complaintsSummary + tabChar + replaceStr ;
                    
                }else{
                    complaintsSummary = complaintsSummary + tabChar + emptyChar;
                }
                
                
                // ---- Complaint Resolution ----
                String caseResolution = '';
                if (caseList[i].Case_Resolution__c != null){                   
                    String replaceStr = caseList[i].Case_Resolution__c.replace('\r\n','. ');
                    complaintResolution = complaintResolution + tabChar + replaceStr;
                }else{
                    complaintResolution = complaintResolution + tabChar + emptyChar;
                }
                   
            }// end of caseList for
            
            // adding the data to Contents of attachment
            contents = strFieldName + '</tr><tr>' + projectName + nextLine + caseNumber + nextLine + createdDate + nextLine + dateOfComplaintGrievance + nextLine + tl + nextLine + flatDetails + nextLine + customerName + nextLine + applicationDate + nextLine + registrationStatus + nextLine + considerationValue + nextLine + cvPaid + nextLine + interactionMode + nextLine + natureOfRequest + nextLine + requestForL1 + nextLine + requestForL2 + nextLine + L3data + nextLine + tatAllowedForCaseClosure + nextLine + priority + nextLine + dependenciesOnInternalFunctions + nextLine + caseStatus + nextLine + emailCallLink + nextLine + caseLink + nextLine + complaintsSummary + nextLine + complaintResolution + '</td></tr></table>'; 
        }// end of if caseList not null
        
        return contents;
        
    }// end of getAttachmentContents()
    
    
    // Method to create a Map of Related Account and Booking Details
    public Map<Id, List<String>> generateAccountMap(List<Case> caseList){

        Map<Id, List<String>> accountAndBookingDetailsMap = new Map<Id, List<String>>();
        Set<Id> accountSet = new Set<Id>();
        List<Account> accountList = new List<Account>();
        
        try{
            if (!caseList.isEmpty()){
                for(Case caseObj: caseList ){
                    accountSet.add(caseObj.account.Id);
                 }
            }
            
            // getting the account details related to the Case List
            accountList = [select Id, 
                                  name, 
                                  Project_Name__c, 
                                  owner.name, 
                                  owner.email, 
                                  owner.manager.name, 
                                  owner.manager.email, 
                                  CRN__c 
                           from Account 
                           where Id in : accountSet];

            if (!accountList.isEmpty()){
                for(Account accObj : accountList ){
                    if (!accountAndBookingDetailsMap.containsKey(accObj.Id)){
                    
                        List<String> accountAndBookingDetailsList = new List<String>();
                        
                        /* adding project name [0] */
                        if (accObj != null && accObj.Project_Name__c != null)
                            accountAndBookingDetailsList.add(accObj.Project_Name__c);
                        else
                            accountAndBookingDetailsList.add(''); 
                         
                        if (accObj != null && accObj.name != null)
                            accountAndBookingDetailsList.add(accObj.name);
                        else
                            accountAndBookingDetailsList.add('');
                                
                        if (accObj != null && accObj.CRN__c!= null)
                            accountAndBookingDetailsList.add(accObj.CRN__c);
                        else
                            accountAndBookingDetailsList.add('');
                                              
                        accountAndBookingDetailsMap.put(accObj.Id, accountAndBookingDetailsList );
                    }
                }
                
            }
            
            // getting booking details related to the account
            List<Booking_Details__c> bookingList = [ Select Name, 
                                                            CV_paid_New__c, 
                                                            Registration_Status__c, 
                                                            CLuster__c, 
                                                            Wing__c, 
                                                            Flat_No__c, 
                                                            Application_Date__c, 
                                                            Consideration_Value__c, 
                                                            account__c 
                                                     from Booking_details__c 
                                                     where Account__c in : accountSet ];
            
            if (!bookingList.isEmpty()){
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
                } // end of Booking Details for

            } // end of if
            
        }catch(Exception ex){
            System.debug('Exception = ' + ex);
        }
        
        return accountAndBookingDetailsMap ;
    }// end of generateAccountMap()
    
    
    // Method to get the Child Cases
    public Map<Id, List<Case>> getChildCases(List<Case> parentCasesList){
        
        Set<Id> parentCasesSet = new Set<Id>();
        Map<Id, List<Case>> childCasesMap = new Map <Id, List<Case>>();
        List<Case> childcaseList = new List<Case>();
        List<Case> childList = new List<Case>();
        Id parentCaseId;
            
        try{
            if (!parentCasesList.isEmpty()){
                for(Case parentCaseObj: parentCasesList){
                    parentCasesSet.add(parentCaseObj.Id);
                }
            }
            
            if(!parentCasesSet.isEmpty())
                childcaseList = [Select Id, CaseNumber, CaseType__c, owner.Name, status, parent.Id from Case Where parent.Id in : parentCasesSet ];
            
            if (!childcaseList.isEmpty()){
                for(Case childCaseObj : childcaseList){
                
                    parentCaseId = childCaseObj.parent.Id ;
                    childList = new List<Case>(); 
                    
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
        
    } // end of getChildCases()
    
    
    // Getting Related Activity History List
    public Map<Id, List<String>> getActivityHistory(List<Case> pCaseList){
    
        List<ActivityHistory> ahList = new List<ActivityHistory>();
        List<String> activityURLs = new List<String>();
        Set<Id> caseIdsSet = new Set<Id>();
        Case [] caseActivityList;
        Map<Id, List<String>> activityHistroryMap = new Map<Id, List<String>>();
        
        try{
            if (!pCaseList.isEmpty()){
                for(Case caseObj: pCaseList){
                    caseIdsSet.add(caseObj.Id);
                }
            }
            caseActivityList =  [SELECT Id, 
                                        casenumber, 
                                        (SELECT Unique_Call_ID__c, 
                                                ActivityType, 
                                                WhatId 
                                         FROM ActivityHistories ) 
                                 FROM Case 
                                 WHERE Id in : caseIdsSet];
                
            if (!caseActivityList.isEmpty()){
                for(Case caseObj: caseActivityList){
                    activityURLs = new List<String>();
                    if (caseObj != null){
                        Id caseId = caseObj.Id;
                        ahList  = caseObj.getSObjects('ActivityHistories');
                        if(ahList != null && ahList.size() > 0){
                            for (ActivityHistory ah : ahList) {
                                if(ah.Unique_Call_ID__c != null && !String.isBlank(ah.Unique_Call_ID__c)){
                                    activityURLs.add(ah.Unique_Call_ID__c);
                                }
                            }
                        }
                        if(!activityURLs.isEmpty()){
                            if (!activityHistroryMap.containsKey(caseId )){
                                activityHistroryMap.put(caseId , activityURLs);
                            }
                        }
                    }
                }
            }
        }catch(Exception ex){
            System.debug('Error getActivityHistory : ' + ex.getMessage());
        } 
        
        return activityHistroryMap;
        
    } // end of getActivityHistory() 
}