/*
*    Description : Apex Controller Class for 'Sp2Booking' visualforce page
*
*    Version        Date                Author                Description
*    1.0                                Anonymous
*    1.1            20/03/2014          Deepak Pudi            Code fixes for preview Invoice functionality
*    
*/

public class BookingController1{

    public Booking_Details__c book{get;set;}
    public String amountInWordsWithTax {get;set;}
    public String amountInWordsWithoutTax {get;set;}
    public BookingController1(){
        try{
        String bookingId = ApexPages.currentPage().getParameters().get('id');
            
        book =[Select Wing__c,Customer_Code__c, b.Project__c, b.Flat_No__c, b.Co_Applicant__c, b.Customer_Group__c,b.Primary_Applicant__c, Channel_Partner__r.Name,Channel_Partner__r.Mobile_Phone__c ,Channel_Partner__r.City__c,Channel_Partner__r.Email__c,Channel_Partner__r.Webpage__c,Channel_Partner__r.REAP_ID__c,Channel_Partner__r.Address__c,
                                                                    b.CLuster__c, b.Application_Date__c,b.Consideration_Value__c,(select Demand_amount__c from Demands__r),b.Flat_Cost__c,b.Service_Tax_Cess__c,b.Project_Name__r.Company_Name__r.Name,b.Project_Name__r.Company_Address__c,b.Company_Name_New__c,
                                                                    b.Invoice_Received_Date__c,b.Service_Tax_Rate__c,b.Status__c, b.Total_Brokerage__c ,b.Basic_Brokerage_amount__c ,b.Secondary_and_Higher_Education_Cess__c,b.Secondary_and_Higher_Education_Cess_Rate__c,b.Education_Cess_amount__c,b.Education_Cess_rate__c,b.Service_tax_amount__c
                                                                    From Booking_Details__c b where id =: bookingId];
                                                                    //b.Total_Brokerage__c
                     
                                                                  //b.Basic_Brokerage_Amount__c
        if(book.Total_Brokerage__c!=null)        
            amountInWordsWithTax = getWords(string.valueof(book.Total_Brokerage__c));  
            amountInWordsWithoutTax = getWords(string.valueof(book.Basic_Brokerage_amount__c));       
            // book= [select Wing__c from Booking_Details__c where id=:bookingId];
            }catch(Exception ex){
                System.debug('-------BookingController1----------------' + ex);
            }
        }

        private String getWords(String numericNumber){
       
            System.debug('-------------numericNumber>>>>>>>>>>>>>>>' + numericNumber); 

            String alphaNumber = ''; 
             try{
            String afterDecimal = '';
            String dummy='';
            numericNumber = numericNumber.replace(',','');
            numericNumber=numericNumber.replace(' ','');
            if(numericNumber.contains('.')){
                afterDecimal =numericNumber.substringAfter('.');
                afterDecimal = afterDecimal.substring(0,2);
            }else{
                afterDecimal+='00';
            }
            numericNumber =numericNumber.substringBefore('.');
    
            List<string> numericNumbers = new list <string>(); 
            Numericnumbers.add('0'+afterDecimal); 
            for(integer i=numericNumber.length(); i>0; i-=3){ 
                Integer n=0; 
                If(i>3){ 
                    n = i-3; 
                } 
                String substring = Numericnumber.substring(n,i);
                Numericnumbers.add(substring); 
                break;
                    If(I<3){break;} 
                } 
                For(integer i=numericNumber.length()-3; i>0; i-=2){ 
                Integer n=0; 
                System.debug('----------------------integer n,i ' + n+'.....'+i); 
                If(I>2){ 
                    n = i-2; 
                } 
    
                String substring = Numericnumber.substring(n,i); 
                If(substring.length()==2){ 
                    Substring = '0'+substring; 
                }else if(substring.length()==1){ 
                    Substring = '00'+ substring; 
                }  
                Numericnumbers.add(substring); 
                If(I<3){
                    break;
                } 
            } 
            System.debug('@@@@@@@@@@@ numericNumbers = '+ numericNumbers ); 

            for(integer I=0;I<numericnumbers.size();I++){
            
                if(afterDecimal == '' && I==0){ 
                    break;
                }
                String ngroup = numericnumbers.get(I); 
                System.debug('-----ngroup = -------------' +  ngroup );

                if(ngroup != null && !ngroup.equals('')){
                    /* String ones = ngroup.substring(2,3); 
                   String tens = ngroup.substring(1,2); 
                  String hundreds = ngroup.substring(0,1);
                  */
                  //Deepak Pudi 1.1
                   
                    String ones = '';
                    String tens = '';
                    String hundreds = '';
                    if(ngroup.length()>=3){
                         ones = ngroup.substring(2,3); 
                         tens = ngroup.substring(1,2); 
                        hundreds = ngroup.substring(0,1);
                    }else if ((ngroup.length()<=2)) {                       
                          tens = ngroup.substring(1,2); 
                         hundreds = ngroup.substring(0,1);
                    }else if (ngroup.length()<=1){                            
                         hundreds = ngroup.substring(0,1);    
                    }
            
                    if(I==2){
                        alphanumber = ' Thousand '+alphanumber;
                    }else if(I==3){
                        alphanumber = ' Lakh '+alphanumber;
                    }else if(I==4){
                        alphanumber = ' Crore '+alphanumber;
                    }
                    System.debug('-----1111111-------------alphanumber  ' +  alphanumber );
                    if(tens == '1' && ones != '0'){ 
                        if(ones =='1'){alphanumber = 'Eleven' + alphanumber;} 
                        else if(ones == '2'){alphanumber = 'Twelve '+alphanumber;} 
                        else if(ones == '3'){alphanumber = 'Thirteen '+alphanumber;} 
                        else if(ones == '4'){alphanumber = 'Fourteen ' + alphanumber;} 
                        else if(ones == '5'){alphanumber = 'Fifteen ' + alphanumber;} 
                        else if(ones == '6'){alphanumber = 'Sixteen ' + alphanumber;} 
                        else if(ones == '7'){alphanumber = 'Seventeen ' + alphanumber;} 
                        else if(ones == '8'){alphanumber = 'Eighteen ' + alphanumber;} 
                        else if(ones == '9'){alphanumber = 'Nineteen ' + alphanumber;} 
                    }else if(tens == '1' && ones == '0'){ 
                        Alphanumber = 'Ten ' + alphanumber; 
                    }else if(ones != '0'){ 
                        String o = underTen(ones); 
                        Alphanumber = o +' '+ alphanumber; 
                    }
                    System.debug('----2222222--------------alphanumber  ' +  alphanumber );

                    if(tens != '0' && tens != '1'){ 
                        if(tens == '2'){alphanumber = 'Twenty ' + alphanumber;} 
                        else if(tens =='3'){alphanumber = 'Thirty ' + alphanumber;} 
                        else if(tens == '4'){alphanumber = 'Forty ' + alphanumber;} 
                        else if(tens =='5'){alphanumber = 'Fifty ' +alphanumber;} 
                        else if(tens == '6'){alphanumber = 'Sixty ' + alphanumber;} 
                        else if(tens == '7'){alphanumber = 'Seventy ' + alphanumber;} 
                        else if(tens == '8'){alphanumber = 'Eighty ' + alphanumber;} 
                        else if(tens == '9'){alphanumber = 'Ninety ' + alphanumber;} 
                    }
                     system.debug('-----33333333333-------------alphanumber  ' +  alphanumber );
    
                    if(hundreds != '0'){ 
                        String h = underten(hundreds); 
                        Alphanumber = h+' Hundred and ' + alphanumber+' Rupees'; 
                    }
                    System.debug('-----44444444-------------alphanumber  ' +  alphanumber );
    
                    if(I==0 && alphanumber!='0'){
                        dummy = ' and '+alphanumber+' Paise Only';
                        alphanumber='';
                    }
                    System.debug('------55555555555------------alphanumber  ' +  alphanumber );
                }
            }//end of for 
            System.debug('1---------------------dummy = ' +  dummy);
            if(dummy!=null && dummy.trim()!=''){
                Alphanumber+=dummy;
            }else{
                Alphanumber+=' Zero Only';
            }
            System.debug('1---------------------Alphanumber = ' +  Alphanumber);

            Alphanumber.capitalize(); 
            
             }catch(Exception ex){
                System.debug('---------getWords--------------' + ex);
            }
            return Alphanumber;
        }
    
         private string underTen(string num){ 
          try{
            if(num =='1'){
                num = 'One';
            } else if(num == '2'){
                num = 'Two';
            } else if(num == '3'){
                num = 'Three';
            } else if(num == '4'){
                num = 'Four';
            } else if(num == '5'){
                num = 'Five';
            } else if(num == '6'){
                num = 'Six';
            } else if(num == '7'){
                num = 'Seven';
            } else if(num == '8'){
                num = 'Eight';
            } else if(num == '9'){
                num = 'Nine';
            } 
            }
            catch(Exception ex){
            System.debug('----------underTen-------------------' + ex);
            }
            
            return num; 
        }        
}