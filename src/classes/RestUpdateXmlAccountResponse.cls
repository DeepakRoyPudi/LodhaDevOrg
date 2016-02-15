@RestResource(urlmapping='/XmlAccountUpdateResponse/*')  
global class RestUpdateXmlAccountResponse{
                 
    @HttpPost 
    global static void  doPost(){   
        try
        {
            String mobileNo = RestContext.request.params.get('mobileNo');
            String checkSum = RestContext.request.params.get('checkSum');
            
            String accountId = RestContext.request.params.get('accountId');
            String firstName = RestContext.request.params.get('firstName');
            String lastName = RestContext.request.params.get('lastName');
            String email = RestContext.request.params.get('email');
            
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
                
                //if(Integer.ValueOf(ReverseNumber) > = 6){
                    remainder = math.mod(Integer.ValueOf(ReverseNumber),6);
                //}
                
                Finalnumber=SumNumber*remainder ;   
                
                if(Finalnumber==Integer.valueOF(checkSum)){
                    Checksumflag=true;    
                } 
            }
            if(mobileNo == '' || mobileNo.Length()<10){
                XmlWriter('Invalid MobileNo');
                Checksumflag=null;
                
            }
            else if(Checksumflag==false){
                XmlWriter('Invalid Checksum'); 
                        
            }
          
            
            if(Checksumflag == true){
            
                //Update operation
                Id recTypeA = [Select id, Name from Recordtype where Name = 'Booked Account'].Id;
                Id recTypeB = [Select id, Name from Recordtype where Name = 'Person Account'].Id;
                Id recTypeC = [Select id, Name from Recordtype where Name = 'Business Account'].Id;
                            
                if(accountId != null && accountId !='' && lastName != null && lastName != '' && email != null && email !=''){
                    Account acct = [select Id, FirstName, LastName,Name, PersonMobilePhone, Mobile_Phone__c, IsPersonAccount, Personal_Email__pc, PersonEmail, Email_acc__c, RecordTypeId from Account where id =: accountId];
                    if(acct != null){
                        if(acct.RecordTypeId == recTypeA){
                            
                            acct.FirstName = firstName;
                            acct.LastName = lastName;
                            acct.Personal_Email__pc = email;
                            
                            update acct;
                            
                        }else if(acct.RecordTypeId == recTypeB){
                            
                            acct.FirstName = firstName;
                            acct.LastName = lastName;
                            acct.PersonEmail = email;                        
                            update acct;
                        
                        }else if(acct.RecordTypeId == recTypeC){
                            
                            acct.Name = firstName +' '+ lastName;
                            acct.Email_acc__c = email;
                            update acct;                        
                        }
                        XmlWriter('Account got successfully updated..!!');                                        
                    }
                    
                }else{
                    XmlWriter('Account ID,LastName,email parameter cannot be Null..!!');
                }
            }
        }
        catch(Exception ex) {          
            XmlWriter('Bad Request :'+ex.getMessage());          
        }
    }    
       
    Public static void XmlWriter(string ResponseMesg){
        XmlStreamWriter w = new XmlStreamWriter();
            w.writeStartDocument(null, '1.0');
                w.writeStartElement(null, 'Response', null);             
                    w.writeCharacters(ResponseMesg);                    
                w.writeEndElement();        
            w.writeEndDocument();   

        //Converting XML to string.....
            String  xmlresponse= w.getXmlString();      
            RestContext.response.addHeader('Content-Type', 'text/html');
            RestContext.response.responseBody = Blob.valueOf(xmlresponse);          
    }                      
       
}