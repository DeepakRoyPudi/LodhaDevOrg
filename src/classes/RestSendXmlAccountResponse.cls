@RestResource(urlmapping='/XmlAccountResponse/*')  
global class RestSendXmlAccountResponse{
    
    public static string strFormatter(string val){
        if (val == null || val == ''){
            val = 'null';
        }
        return val;
    }
    
    @HttpPost
    
    //Post method expecting a parameter MobileNo
    global static void  doPost(){  
    
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
     
        String name;
        String fname;
        String lname;
        String mobNoBkAcct;
        String emailBkAcct;
        String mobNoAcct;
        String emailPAcct;
        String emailBAcct;
        
        String mobileNo = req.params.get('mobileNo');
        String checkSum = req.params.get('checkSum');
        
        Integer Finalnum;
        Integer remainder;
        integer num;
        string newNum;
        Boolean flag=false;
        Integer i;
            
        try{
            if(mobileNo.Length()==10){
                num=0;
                
                for(i=0;i<mobileNo.Length();i++){
                    num=num+Integer.valueOf(mobileNo.SUBSTRING(i,i+1));
                }
                
                newNum=string.valueOF(num).reverse();
                
                //if(Integer.ValueOf(newNum) > = 6){
                    remainder = math.mod(Integer.ValueOf(newNum),6);
               // }
                
                Finalnum=num*remainder ;   
                
                if(Finalnum==Integer.valueOF(checkSum)){
                    flag=true;    
                } 
            }
            
            
            if(flag == true){
                
                Id recTypeA = [Select id, Name from Recordtype where Name = 'Booked Account'].Id;
                Id recTypeB = [Select id, Name from Recordtype where Name = 'Person Account'].Id;
                Id recTypeC = [Select id, Name from Recordtype where Name = 'Business Account'].Id;
                            
                List<Account> accList = [select Id, FirstName, LastName, Name, PersonMobilePhone, Mobile_Phone__c, Personal_Email__pc, PersonEmail, Email_acc__c, RecordTypeId from Account where Mobile_Phone__c = : mobileNo or PersonMobilePhone = : mobileNo];
                
                
                        
                if(accList.size()!=0){
                
                    //code to create a XML Response starts here...
                    XmlStreamWriter w = new XmlStreamWriter();
                    w.writeStartDocument(null, '1.0');
                        w.writeStartElement(null, 'Accounts', null);
                            
                            
                            //In your case u cud fetch account details from Salesforce for the specific mobile number
                            // and use the below code
                           
                               
                            for(Account a: accList) //accList contains the list of accounts
                            {
                                name = strFormatter(a.Name);
                                fname = strFormatter(a.FirstName);
                                lname = strFormatter(a.LastName);
                                mobNoBkAcct = strFormatter(a.PersonMobilePhone);
                                emailBkAcct = strFormatter(a.Personal_Email__pc);
                                mobNoAcct = strFormatter(a.Mobile_Phone__c);
                                emailPAcct = strFormatter(a.PersonEmail);
                                emailBAcct = strFormatter(a.Email_acc__c);
                                
                                if(a.RecordtypeId == recTypeA){    
                                
                                    w.writeStartElement(null, 'Account', null);                
                                        
                                        w.writeStartElement(null, 'AccountId', null);
                                            w.writeCharacters(a.Id);
                                        w.writeEndElement();
                                        
                                        w.writeStartElement(null, 'FirstName', null);
                                            w.writeCharacters(fname);
                                        w.writeEndElement();  
                                           
                                        w.writeStartElement(null, 'LastName', null);
                                            w.writeCharacters(lname);
                                        w.writeEndElement();  
                                        
                                        w.writeStartElement(null, 'Mobile', null);
                                            w.writeCharacters(mobNoBkAcct);
                                        w.writeEndElement();
                                        
                                        w.writeStartElement(null, 'Email', null);
                                            w.writeCharacters(emailBkAcct);
                                        w.writeEndElement();
                                        
                                    w.writeEndElement();
                                
                                }if(a.RecordtypeId == recTypeB){
                                
                                    w.writeStartElement(null, 'Account', null);                
                                        
                                        w.writeStartElement(null, 'AccountId', null);
                                            w.writeCharacters(a.Id);
                                        w.writeEndElement();
                                        
                                        w.writeStartElement(null, 'FirstName', null);
                                            w.writeCharacters(fname);
                                        w.writeEndElement();  
                                           
                                        w.writeStartElement(null, 'LastName', null);
                                            w.writeCharacters(lname);
                                        w.writeEndElement();  
                                        
                                        w.writeStartElement(null, 'Mobile', null);
                                            w.writeCharacters(mobNoAcct);
                                        w.writeEndElement();
                                        
                                        w.writeStartElement(null, 'Email', null);
                                            w.writeCharacters(emailPAcct);
                                        w.writeEndElement();
                                        
                                    w.writeEndElement();
                                
                                }else if(a.RecordtypeId == recTypeC){
                                
                                    w.writeStartElement(null, 'Account', null);                
                                        
                                        w.writeStartElement(null, 'AccountId', null);
                                            w.writeCharacters(a.Id);
                                        w.writeEndElement();
                                        
                                        w.writeStartElement(null, 'FirstName', null);
                                            w.writeCharacters('null');
                                        w.writeEndElement();  
                                           
                                        w.writeStartElement(null, 'LastName', null);
                                            w.writeCharacters(name);
                                        w.writeEndElement();  
                                        
                                        w.writeStartElement(null, 'Mobile', null);
                                            w.writeCharacters(mobNoAcct);
                                        w.writeEndElement();
                                        
                                        w.writeStartElement(null, 'Email', null);
                                            w.writeCharacters(emailBAcct);
                                        w.writeEndElement();
                                        
                                    w.writeEndElement();
                                
                                
                                }
                            }
                              
                        w.writeEndElement();        
                    w.writeEndDocument();               
                    
                    //Converting XML to string.....
                    String  xmlresponse= w.getXmlString();
                    res.addHeader('Content-Type', 'text/html');
                    
                    //Sending Response...
                    res.responseBody = Blob.valueOf(xmlresponse); 
                
                } else {
                
                    XmlStreamWriter w = new XmlStreamWriter();
                    w.writeStartDocument(null, '1.0');
                        w.writeStartElement(null, 'Response', null);
                        
                            w.writeCharacters('There are no Accounts related to this mobile no : '+MobileNo); 
                            
                        w.writeEndElement();        
                    w.writeEndDocument();             
                    
                    //Converting XML to string.....
                    String  xmlresponse= w.getXmlString();
                    res.addHeader('Content-Type', 'text/html');
                    
                    //Sending Response...
                    res.responseBody = Blob.valueOf(xmlresponse); 
                }
                
            }else{
            
                XmlStreamWriter w = new XmlStreamWriter();
                w.writeStartDocument(null, '1.0');
                    w.writeStartElement(null, 'Response', null);
                    
                        w.writeCharacters('Bad Request..!!'); 
                        
                    w.writeEndElement();        
                w.writeEndDocument();             
                
                //Converting XML to string.....
                String  xmlresponse= w.getXmlString();
                res.addHeader('Content-Type', 'text/html');
                
                //Sending Response...
                res.responseBody = Blob.valueOf(xmlresponse); 
            
            }
            
        }
        catch(Exception ex) {
            
            XmlStreamWriter w = new XmlStreamWriter();
            w.writeStartDocument(null, '1.0');
                w.writeStartElement(null, 'Response', null);
                
                    w.writeCharacters('Bad Request..!!'+ex); 
                    
                w.writeEndElement();        
            w.writeEndDocument();             
                
            //Converting XML to string.....
            String  xmlresponse= w.getXmlString();
            res.addHeader('Content-Type', 'text/html');
            
            //Sending Response...
            res.responseBody = Blob.valueOf(xmlresponse);           
        }
        
    }
}