@RestResource(urlmapping='/smslead/*')
global class RestSmsLead{

@HttpPost
global static void  doPost(){
 
    RestRequest req = RestContext.request;
    RestResponse res = RestContext.response;  
      
    String MobileNo = req.params.get('mobileno');
    String CheckSum = req.params.get('checksum');
    String ProjectCode= req.params.get('projectcode');
    boolean Securityflag;
    string ProjectName;
    lead NewLead;
    Boolean IsDuplicate;  
      
    if(MobileNo ==null || MobileNo.length() != 10)
         XmlWriter('Invalid MobileNo'); 
    else if(checksum == null || checksum == '')
        XmlWriter('Invalid checksum'); 
    else if(projectcode == null || projectcode =='')
        XmlWriter('Invalid projectcode'); 
    else {
        Securityflag=ValidateCheckSum(MobileNo,checksum);
        if(Securityflag ==false){
            XmlWriter('Invalid checksum'); 
            }
    }
    
    if(Securityflag == true && projectcode!=''){
        projectcode=projectcode.deleteWhitespace();
        projectcode=projectcode.toUpperCase();
        ProjectCodes__c RelatedProjectNameObject=ProjectCodes__c.getInstance(projectcode);
        if(RelatedProjectNameObject == null){
            XmlWriter('Invalid Project Code.');       
        }

        if(RelatedProjectNameObject != null){
            try{
                ProjectName=RelatedProjectNameObject.Project_Name__c.normalizeSpace();
                List<Project_Name__c> ProjectNameObject=[select Id,Record_Type__c,name from Project_Name__c where name=:ProjectName];
                if(ProjectNameObject != null && ProjectNameObject.size() ==1){  
                    Id rectypeId = RecordTypeHelper.getRecordTypeId('Lead',ProjectNameObject[0].Record_Type__c);              
                    NewLead=new Lead();
                    NewLead.Project_Name__c =ProjectNameObject[0].Id;
                    NewLead.LastName ='SMS';
                    NewLead.Mobile__c=MobileNo;
                    NewLead.LeadSource='SMS Enquiry';
                    NewLead.Lead_Source_Detail__c='Air to Web';
                    if(rectypeId != null){                   
                        NewLead.RecordTypeId=rectypeId;  
                    }                                 
                    insert NewLead;
                    IsDuplicate=[select id,isDuplicate__c from Lead where Id=:NewLead.Id].isDuplicate__c; 
                    if(IsDuplicate == true){
                        XmlWriter('Created Duplicate Lead with Id: '+NewLead.Id);
                        }
                    else if(IsDuplicate == false){
                        XmlWriter('Created Lead with Id: '+NewLead.Id); 
                        }
                    }
                else if( ProjectNameObject != null && ProjectNameObject.size() == 0 ){
                    XmlWriter('No ProjectName record found.'); 
                }
                else{
                    XmlWriter('One or more ProjectName record found.'); 
                }
             }
             catch(Exception e){  
                  XmlWriter('Bad Request:'+e);  
             }
                      
        }
           
    }    
}

Private static void XmlWriter(string ResponseMesg){
    XmlStreamWriter w = new XmlStreamWriter();
        w.writeStartDocument(null, '1.0');
            w.writeStartElement(null, 'Response', null);             
                w.writeCharacters(ResponseMesg);                    
            w.writeEndElement();        
        w.writeEndDocument();  
    //Converting XML to string.....
        String  xmlresponse= w.getXmlString();      
        RestContext.response.addHeader('Content-Type','text/html');
        RestContext.response.responseBody = Blob.valueOf(xmlresponse);          
}   
    
private static boolean ValidateCheckSum(string mobileNo,string checkSum){
    Integer Finalnumber;
    Integer remainder;
    Integer SumNumber;
    String ReverseNumber;
    Boolean Checksumflag=false;
    Integer i;
    
    if(mobileNo != '' && mobileNo.Length()==10 && checkSum !=''){
        SumNumber=0;
        for(i=0;i<mobileNo.Length();i++){
            SumNumber=SumNumber+Integer.valueOf(mobileNo.SUBSTRING(i,i+1));
        }                
        ReverseNumber=string.valueOF(SumNumber).reverse();
        remainder = math.mod(Integer.ValueOf(ReverseNumber),6);                
        Finalnumber=SumNumber*remainder ;                   
        if(Finalnumber==Integer.valueOf(checkSum)){
            Checksumflag=true;    
        } 
    }
    return Checksumflag;
    
    }    
               
}