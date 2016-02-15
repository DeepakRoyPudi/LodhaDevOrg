/**********************************************************************************
Name:  TaskCreateController
Copyright © 2012  Lodha Group
===================================================================================
===================================================================================
Purpose:
-------
To Create Task for Customer care profile
===================================================================================
===================================================================================
History
-------
VERSION    AUTHOR                DATE             DETAIL              
1.0 -   CG Dev Team          28/06/2012      INITIAL DEVELOPMENT
**********************************************************************************/
public class TaskCreateController {

  


    public Boolean Iseditform{get;set;}
    public Boolean Issaveform{get;set;}

    public Boolean Ispaymentrelated{get;set;}
    public Boolean Isdocumentrelated{get;set;}
    public Boolean Ispossessionrelated{get;set;}
    public Boolean Isleadrelated{get;set;}
    public Boolean Iscustomerrelated{get;set;}
    public Boolean Iscancellationrelated{get;set;}
    public Boolean Iswelcomecallrelated{get;set;}
    public Boolean IsTDSAuthorizationrelated{get;set;}

    
    public String paymentrelatedpick{get;set;}
    public String documentrelatedpick{get;set;}
    public String possessionrelatedpick{get;set;}
    public String leadrelatedpick{get;set;}
    public String customerrelatedpick{get;set;}
    public String cancellationrelatedpick{get;set;}
    public String welcomecallrelatedpick{get;set;}
    public String TDSAuthorizationPickValue{get;set;}
    public Map<String,Id> recordtypemap{get;set;}
    public Task newtask{get;set;}   
    public List<String> tempList {get;set;}
    public String AccountId{get;set;}
    public Boolean customeraware{get;set;}
    
    public String paymentcomment{get;set;}
    public String documentcomment{get;set;}
    public String possessioncomment{get;set;}
    public String leadcomment{get;set;}
    public String customercomment{get;set;}
    public String cancellationcomment{get;set;}
    public String welcomecallcomment{get;set;}
    public String TDSAuthorizationcomment{get;set;}
    
    public List<SelectOption> subjectpicklist{get;set;}
    public string subjectpickval{get;set;}
    
    public String crn {get;set;}
       
       public boolean Isneft{get;set;}
       public boolean Isptp{get;set;}
       public boolean Ispaymentmade{get;set;}
       public boolean Isinterestrelated{get;set;}
       public boolean Isservicerelated{get;set;}
       public boolean Iswillpay{get;set;}
       
       public boolean reminderset{get;set;}
    public TaskCreateController() {
            
            AccountId=ApexPages.currentPage().getParameters().get('id');
            
                    initmethod();
    }

public void initmethod(){
            newtask=new Task();   
            Iseditform=true;
            Issaveform=false;
            if(AccountId!=null){
                Account acc=[select id, name, OwnerId, CRN__c from Account where id=:AccountId]; 
                crn = acc.CRN__c;               
                newtask.OwnerId=acc.OwnerId; 
                
            }  
            customeraware=false;
                 
            Ispaymentrelated=false;
            Isdocumentrelated=false;
            Ispossessionrelated=false;
            Isleadrelated=false;
            Iscustomerrelated=false;
            Iscancellationrelated=false;
            Iswelcomecallrelated=false;
            IsTDSAuthorizationrelated=false;
            recordtypemap=new Map<String,Id>();
            
               Isneft=false;
               Isptp=false;
               Ispaymentmade=false;
               Isservicerelated=false;
               Isinterestrelated=false;
               Iswillpay=false;
            Taskrecordtypes();
            //Describesubjectpiclist();
}
/*********************************************************************
Purpose     : To get Record types for Task Object 
Parameters  : None
Returns     : None
**********************************************************************/    
     public void Taskrecordtypes(){
      try{
         
          List<RecordType> recordtypelist=[select Name,Id from RecordType where sobjectType=:'Task'];
          for(RecordType recodtype: recordtypelist){          
              recordtypemap.put(recodtype.Name,recodtype.Id);
          }
                  
      }catch(Exception e){
      }

      }
      
/*********************************************************************
Purpose     : To Describe picklist fields
Parameters  : String parameter
Returns     : None
**********************************************************************/        
    public void Describepicklist(String fieldname){
    
        Schema.sObjectType sobject_type =Task.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe =sobject_type.getDescribe(); 
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); 
        List<Schema.PicklistEntry> pick_list_values = field_map.get(fieldname).getDescribe().getPickListValues();
        tempList = new List<String>();
        
        for (Schema.PicklistEntry a : pick_list_values) {   
              
             tempList.add(a.getvalue());
             }
              
    }
/*********************************************************************
Purpose     : To Describe subject picklist field
Parameters  : none
Returns     : None
**********************************************************************/       
    public List<SelectOption> getDescribesubjectpiclist(){
       List<SelectOption> subjectpicklist= new List<SelectOption>();
        Schema.sObjectType sobject_type =Task.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe =sobject_type.getDescribe(); 
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); 
        List<Schema.PicklistEntry> pick_list_values = field_map.get('Subject').getDescribe().getPickListValues();
        for(Schema.PicklistEntry a : pick_list_values){
        
            subjectpicklist.add(new SelectOption(a.getvalue(),a.getvalue()));
        }
        return subjectpicklist;
    }
    
/*********************************************************************
Purpose     : To render the section based on piclist values in VF page
Parameters  : none
Returns     : None
**********************************************************************/    
    public void onchange(){
    
    try{
     System.debug('subjectpickval '+subjectpickval);
     newtask.Query_Sub_Type_Payment_Related__c=null;
     newtask.Query_Sub_Type_Cancellation_Related__c=null;
 //    newtask.Mode_of_payment_Made__c=null;
            paymentcomment=null;
            documentcomment=null;
            possessioncomment=null;
            leadcomment=null;
            customercomment=null;
            cancellationcomment=null;
            customeraware=false;
            welcomecallcomment=null;
            TDSAuthorizationcomment=null;
             
            Describepicklist('Query_Type__c');
            Ispaymentrelated=false;
            Isdocumentrelated=false;
            Ispossessionrelated=false;
            Isleadrelated=false;
            Iscustomerrelated=false;
            Iscancellationrelated=false;
            Iswelcomecallrelated=false;
            IsTDSAuthorizationrelated=false;
            List<Boolean> boolenlist=new  List<Boolean>();
            
            boolenlist.add(false);
            boolenlist.add(false);
            boolenlist.add(false);
            boolenlist.add(false);
            boolenlist.add(false);
            boolenlist.add(false);
            boolenlist.add(false);
            boolenlist.add(false);
            
           List<String> querystringlist=new  List<String>();
            
            querystringlist.add(null);
            querystringlist.add(null);
            querystringlist.add(null);
            querystringlist.add(null);
            querystringlist.add(null);
            querystringlist.add(null);
            querystringlist.add(null);
            querystringlist.add(null);
                                         
            if(newtask.Query_Type__c!=null){
                String[] picklistvalues= newtask.Query_Type__c.split(';');    
            if(picklistvalues!=null){   
            
                for(Integer i=0;i<tempList.size();i++) {                                                            
                   for(String pickvalue: picklistvalues){ 
                                 
                   if(pickvalue==tempList[i]){
                   
                         boolenlist[i]=true;
                         querystringlist[i]=pickvalue;
                    }                   
                  }
               }
            }
          }
                        Ispaymentrelated=boolenlist[0];
                        paymentrelatedpick=querystringlist[0];
                        
                        Isdocumentrelated=boolenlist[1];
                        documentrelatedpick=querystringlist[1];
                        
                        Ispossessionrelated=boolenlist[2];
                        possessionrelatedpick=querystringlist[2];
                        
                        Isleadrelated=boolenlist[3];
                        leadrelatedpick=querystringlist[3];
                        
                        Iscustomerrelated=boolenlist[4]; 
                        customerrelatedpick=querystringlist[4];
                        
                        Iscancellationrelated=boolenlist[5]; 
                        cancellationrelatedpick=querystringlist[5];
                        
                        Iswelcomecallrelated=boolenlist[6]; 
                        welcomecallrelatedpick=querystringlist[6];
                        
                        IsTDSAuthorizationrelated=boolenlist[7];
                        TDSAuthorizationPickValue=querystringlist[7];
                        
                        OnchangePaymentRelated();  
                        OnchangecancelRelated(); 
                        OnchangeSubPaymentRelated();      
         }catch(Exception e){
         
         }
            
       }

/*********************************************************************
Purpose     : To render the section based on piclist values in VF page
Parameters  : none
Returns     : None
**********************************************************************/         
       public void OnchangePaymentRelated(){
           try{
               Describepicklist('Query_Sub_Type_Payment_Related__c');
               
               Isptp=false;
               Ispaymentmade=false;
               Iswillpay=false;
               
               
               List<Boolean> boolenlist=new  List<Boolean>();
               boolenlist.add(false);
               boolenlist.add(false);
               boolenlist.add(false);
               boolenlist.add(false);
               boolenlist.add(false);
               boolenlist.add(false);
               
               system.debug('!!!!!!!lst start'+boolenlist);
               system.debug('!!!!!!!temp lst'+tempList);
               if(newtask.Query_Sub_Type_Payment_Related__c!=null){
                String[] picklistvalues= newtask.Query_Sub_Type_Payment_Related__c.split(';');
                if(picklistvalues!=null){ 
                 
                for(Integer i=0;i<tempList.size();i++) {
                
                 for(String pickvalue: picklistvalues){ 
                    if(pickvalue==tempList[i]){
                        boolenlist[i]=true;
                    }
                   }
                    
                }  
              }                            
              }
              system.debug('!!!!!!!lst final'+boolenlist);
              Isptp=boolenlist[0];
              Ispaymentmade=boolenlist[1];
              Isinterestrelated=boolenlist[2];
              Isservicerelated=boolenlist[3];
              Iswillpay=boolenlist[4];
              
              
              
           }catch(Exception e){
               system.debug('!!!!!!!debug'+e.getmessage()+e.getLineNumber());
           }
       }
      public Boolean Iscancel{get;set;}
      public Boolean Iscontinue{get;set;}
      public Boolean Isretentioncall{get;set;}
      
   
      
/*********************************************************************
Purpose     : To render the section based on piclist values in VF page
Parameters  : none
Returns     : None
**********************************************************************/   
    public void OnchangeSubPaymentRelated(){
    
    
        try{
            
            system.debug('## Inside OnchangeSubPaymentRelated ');
            system.debug('###Isptp: '+Isptp);
            system.debug('###newtask.Mode_of_payment_Made__c: '+newtask.Mode_of_payment_Made__c);
            system.debug('###Isneft: '+Isneft);
            
            if(Isptp==true){
                if(newtask.Mode_of_payment_Made__c!=null){
                    String picklistvalues= newtask.Mode_of_payment_Made__c;
                    
                    if(picklistvalues!='RTGS/NEFT'){
                        Isneft=false;
                    }else{
                        Isneft=true;
                }
            }
            system.debug('###Isneft: '+Isneft);
            }
            
        }catch(Exception e){
        
        }
    
    }
    
 
/*********************************************************************
Purpose     : To render the section based on piclist values in VF page
Parameters  : none
Returns     : None
**********************************************************************/       
      public void OnchangecancelRelated(){
           try{
           
            Describepicklist('Query_Sub_Type_Cancellation_Related__c');
            
            Isretentioncall=false;

               if(newtask.Query_Sub_Type_Cancellation_Related__c!=null){
               List<String> picklistvalues= newtask.Query_Sub_Type_Cancellation_Related__c.split(';'); 
               
               for(String pickval:picklistvalues){
               
                   if(pickval=='Retention efforts'){
                       Isretentioncall=true;
                   }
               
                }  
              }
           }catch(Exception e){
           
           }
      }    
/*********************************************************************
Purpose     : To Create Task records
Parameters  : none
Returns     : None
**********************************************************************/   
     
      
     public pagereference Createtask(){
     
         try{
          system.debug('newtaskpaymentrelated: '+Ispaymentrelated);
          system.debug('Isdocumentrelated: '+Isdocumentrelated);
          system.debug('Ispossessionrelated: '+Ispossessionrelated);
          system.debug('Isleadrelated: '+Isleadrelated);
          system.debug('Iscustomerrelated: '+Iscustomerrelated);
          system.debug('@@Iswelcomecallrelated: '+Iswelcomecallrelated);
          system.debug('@@IsTDSAuthorizationrelated: '+IsTDSAuthorizationrelated);
          

    if(newtask.Query_Type__c!=null){
    
        DateTime reminderdatetime=null;
        Boolean reminderset=false;
         List<Task> newtasklist=new List<Task>();
         
         if(newtask.ReminderDate__c!=null){
          reminderset=true;
             if(newtask.ReminderTime__c!=null){
                 String finalTime = String.valueof(newTask.ReminderDate__c) + ' ' +String.valueof(newTask.ReminderTime__c)+':00';
                 system.debug('+++++finalTime '+finalTime); 
                 reminderdatetime= datetime.valueof(finalTime);
                 system.debug('+++++finalTimeAfterCon '+reminderdatetime);
             }else{
                 String finalTime = String.valueof(newTask.ReminderDate__c) + ' 00:00:00'; 
                 system.debug('+++++finalTime '+finalTime);
                 reminderdatetime = datetime.valueof(finalTime);
                 system.debug('+++++finalTimeAfterCon '+reminderdatetime);
             }

             
         }
        
         if(Ispaymentrelated){
          system.debug('Inside newtaskpaymentrelated');
             Task newtaskpaymentrelated=new Task(); 
             system.debug('NewTASKINSTANCE'+recordtypemap.get('Payment Related'));  
             if(Isptp&&Isneft&&(!customeraware)){
                  ApexPages.Message err = new ApexPages.Message(ApexPages.Severity.ERROR,'Customer Aware decleration is not checked for PTP');
                  ApexPages.addMessage(err);
                  return null; 
             }else{
             newtaskpaymentrelated.RecordTypeId=recordtypemap.get('Payment Related');
            
             newtaskpaymentrelated.OwnerId=newtask.OwnerId;
             newtaskpaymentrelated.Status=newtask.Status;
             newtaskpaymentrelated.WhatId=AccountId;
             newtaskpaymentrelated.ActivityDate=System.Today();
             newtaskpaymentrelated.Task_Submission_Date__c=System.Today();
             newtaskpaymentrelated.Subject=subjectpickval;
             newtaskpaymentrelated.ReminderDateTime=reminderdatetime;
             newtaskpaymentrelated.IsReminderSet=reminderset;
             newtaskpaymentrelated.Communication_Type__c=newtask.Communication_Type__c;
             newtaskpaymentrelated.Call_sType__c=newtask.Call_sType__c;
             newtaskpaymentrelated.Target_Completion_Date__c=newtask.Target_Completion_Date__c;
             newtaskpaymentrelated.Query_Type__c=paymentrelatedpick;
             newtaskpaymentrelated.Description=newtask.Description;      
             
             newtaskpaymentrelated.Query_Sub_Type_Payment_Related__c=newtask.Query_Sub_Type_Payment_Related__c;
             newtaskpaymentrelated.Pick_up_Date__c=newtask.Pick_up_Date__c;
             newtaskpaymentrelated.Amount__c=newtask.Amount__c;
             newtaskpaymentrelated.Arrange_Pick_up__c=newtask.Arrange_Pick_up__c;
             newtaskpaymentrelated.Customer_Aware__c=customeraware;
             
             newtaskpaymentrelated.Date_of_Payment__c=newtask.Date_of_Payment__c;
             newtaskpaymentrelated.Mode_of_payment_Made__c=newtask.Mode_of_payment_Made__c;
             newtaskpaymentrelated.Amt_to_be_paid__c=newtask.Amt_to_be_paid__c;
             newtaskpaymentrelated.Amt_already_paid__c=newtask.Amt_already_paid__c;
             //newtaskpaymentrelated.Sub_query_Type_1_Payment_Related__c=newtask.Sub_query_Type_1_Payment_Related__c;
             newtaskpaymentrelated.Sub_query_Type_2_Payment_Related__c=newtask.Sub_query_Type_2_Payment_Related__c;
             //newtaskpaymentrelated.Sub_query_Type_3_Payment_Related__c=newtask.Sub_query_Type_3_Payment_Related__c;
             newtaskpaymentrelated.Interest_Related__c=newtask.Interest_Related__c;
             newtaskpaymentrelated.Service_Tax_Related__c=newtask.Service_Tax_Related__c;
             if(paymentcomment.length()>255){             
                  ApexPages.Message err = new ApexPages.Message(ApexPages.Severity.ERROR,'Payment Related Comment max length=255');
                  ApexPages.addMessage(err);
                  return null; 
             }else{
                // newtaskpaymentrelated.Payment_Related_Comment__c=paymentcomment;
                   newtaskpaymentrelated.Customised_Comments__c=paymentcomment;
             }
           }
             newtasklist.add(newtaskpaymentrelated);
             
         }
         if(Isdocumentrelated){
             Task newtaskdocumentrelated=new Task();
             newtaskdocumentrelated.RecordTypeId=recordtypemap.get('Document Related');             
             newtaskdocumentrelated.Query_Type__c=documentrelatedpick; 
             newtaskdocumentrelated.OwnerId=newtask.OwnerId;
             newtaskdocumentrelated.Status=newtask.Status;
             newtaskdocumentrelated.WhatId=AccountId;
             newtaskdocumentrelated.Task_Submission_Date__c=System.Today();
             newtaskdocumentrelated.Subject=subjectpickval;
             newtaskdocumentrelated.ReminderDateTime=reminderdatetime;
             newtaskdocumentrelated.IsReminderSet=reminderset;
             newtaskdocumentrelated.Communication_Type__c=newtask.Communication_Type__c;
             newtaskdocumentrelated.Call_sType__c=newtask.Call_sType__c;
             newtaskdocumentrelated.Description=newtask.Description;
             
             newtaskdocumentrelated.ActivityDate=System.Today();
             newtaskdocumentrelated.Target_Completion_Date__c=newtask.Target_Completion_Date__c;
             newtaskdocumentrelated.Query_Sub_Type_Document_Information__c=newtask.Query_Sub_Type_Document_Information__c;
             
             if(documentcomment.length()>255){             
                  ApexPages.Message err = new ApexPages.Message(ApexPages.Severity.ERROR,'Document Related Comment max length=255');
                  ApexPages.addMessage(err);
                  return null; 
             }else{
                 //newtaskdocumentrelated.Document_Related_Comment__c=documentcomment;
                 newtaskdocumentrelated.Customised_Comments__c=documentcomment;
             }
             
             newtasklist.add(newtaskdocumentrelated);
            
         }
         
         if(Iswelcomecallrelated){
             Task newtaskwelcomecallrelated=new Task();
             newtaskwelcomecallrelated.RecordTypeId=recordtypemap.get('Welcome Call Related');  
             newtaskwelcomecallrelated.Query_Type__c=welcomecallrelatedpick;            
             newtaskwelcomecallrelated.OwnerId=newtask.OwnerId;
             newtaskwelcomecallrelated.Status=newtask.Status;
             newtaskwelcomecallrelated.WhatId=AccountId;
             newtaskwelcomecallrelated.Task_Submission_Date__c=System.Today();
             newtaskwelcomecallrelated.Subject=subjectpickval;
             newtaskwelcomecallrelated.ReminderDateTime=reminderdatetime;
             newtaskwelcomecallrelated.IsReminderSet=reminderset;
             newtaskwelcomecallrelated.Communication_Type__c=newtask.Communication_Type__c;
             newtaskwelcomecallrelated.Call_sType__c=newtask.Call_sType__c;
             newtaskwelcomecallrelated.Description=newtask.Description;
             
             newtaskwelcomecallrelated.ActivityDate=System.Today();
             newtaskwelcomecallrelated.Target_Completion_Date__c=newtask.Target_Completion_Date__c;
             
             if(welcomecallcomment.length()>255){             
                  ApexPages.Message err = new ApexPages.Message(ApexPages.Severity.ERROR,'Welcomecall Related Comment max length=255');
                  ApexPages.addMessage(err);
                  return null; 
             }else{
                 //newtaskwelcomecallrelated.Document_Related_Comment__c=welcomecallcomment;
                 newtaskwelcomecallrelated.Customised_Comments__c=welcomecallcomment;
             }
             
             system.debug('@@newtaskwelcomecallrelated :' +newtaskwelcomecallrelated);
             
             newtasklist.add(newtaskwelcomecallrelated);
            
         }
         
         system.debug('Ispossessionrelated'+Ispossessionrelated);
         if(Ispossessionrelated){
             Task newtaskpossessionrelated=new Task();
             newtaskpossessionrelated.RecordTypeId=recordtypemap.get('Possession Related');
             system.debug('RecordTypeId'+newtaskpossessionrelated.RecordTypeId);
             system.debug('possessionrelatedpick'+possessionrelatedpick);
             newtaskpossessionrelated.Query_Type__c=possessionrelatedpick; 
             newtaskpossessionrelated.OwnerId=newtask.OwnerId;
             newtaskpossessionrelated.Status=newtask.Status;
             newtaskpossessionrelated.WhatId=AccountId;
             newtaskpossessionrelated.Subject=subjectpickval;
             newtaskpossessionrelated.ReminderDateTime=reminderdatetime;
             newtaskpossessionrelated.IsReminderSet=reminderset;
             newtaskpossessionrelated.Communication_Type__c=newtask.Communication_Type__c;
             newtaskpossessionrelated.Call_sType__c=newtask.Call_sType__c;
             newtaskpossessionrelated.Target_Completion_Date__c=newtask.Target_Completion_Date__c;
             newtaskpossessionrelated.ActivityDate=System.Today();
             newtaskpossessionrelated.Task_Submission_Date__c=System.Today();
             newtaskpossessionrelated.Description=newtask.Description;
             
             newtaskpossessionrelated.Query_Sub_Type_Possession_Related__c=newtask.Query_Sub_Type_Possession_Related__c;
             if(possessioncomment.length()>255){             
                  ApexPages.Message err = new ApexPages.Message(ApexPages.Severity.ERROR,'Possession Related Comment max length=255');
                  ApexPages.addMessage(err);
                  return null; 
             }else{
                 //newtaskpossessionrelated.Possession_Related_Comment__c=possessioncomment;
                 newtaskpossessionrelated.Customised_Comments__c=possessioncomment;
             }       
             
             newtasklist.add(newtaskpossessionrelated);
           
         }
         if(Isleadrelated){         
             Task newtaskleadrelated=new Task();
             newtaskleadrelated.RecordTypeId=recordtypemap.get('Lead Related');
             newtaskleadrelated.Query_Type__c=leadrelatedpick; 
             newtaskleadrelated.OwnerId=newtask.OwnerId;
             newtaskleadrelated.Status=newtask.Status;
             newtaskleadrelated.WhatId=AccountId;
             newtaskleadrelated.ActivityDate=System.Today();
             newtaskleadrelated.Subject=subjectpickval;
             newtaskleadrelated.ReminderDateTime=reminderdatetime;
             newtaskleadrelated.IsReminderSet=reminderset;
             newtaskleadrelated.Communication_Type__c=newtask.Communication_Type__c;
             newtaskleadrelated.Call_sType__c=newtask.Call_sType__c;
             newtaskleadrelated.Target_Completion_Date__c=newtask.Target_Completion_Date__c;
             newtaskleadrelated.Task_Submission_Date__c=System.Today();
             newtaskleadrelated.Description=newtask.Description;
             newtaskleadrelated.Query_Type_Lead_Generation__c=newtask.Query_Type_Lead_Generation__c;
                          
             if(leadcomment.length()>255){             
                  ApexPages.Message err = new ApexPages.Message(ApexPages.Severity.ERROR,'Lead Related Comment max length=255');
                  ApexPages.addMessage(err);
                  return null; 
             }else{
                 //newtaskleadrelated.Lead_Related_Comment__c=leadcomment;
                 newtaskleadrelated.Customised_Comments__c=leadcomment;
             }
             
             newtasklist.add(newtaskleadrelated);
         }
         
         if(Iscustomerrelated){
             Task newtaskcustomerrelated=new Task();
             newtaskcustomerrelated.RecordTypeId=recordtypemap.get('Customer Related');
             newtaskcustomerrelated.Query_Type__c=customerrelatedpick; 
             newtaskcustomerrelated.OwnerId=newtask.OwnerId;
             newtaskcustomerrelated.Status=newtask.Status;
             newtaskcustomerrelated.WhatId=AccountId;
             newtaskcustomerrelated.Subject=subjectpickval;
             newtaskcustomerrelated.ReminderDateTime=reminderdatetime;
             newtaskcustomerrelated.IsReminderSet=reminderset;
             newtaskcustomerrelated.Communication_Type__c=newtask.Communication_Type__c;
             newtaskcustomerrelated.Call_sType__c=newtask.Call_sType__c;
             newtaskcustomerrelated.Target_Completion_Date__c=newtask.Target_Completion_Date__c;
             newtaskcustomerrelated.ActivityDate=System.Today();
             newtaskcustomerrelated.Task_Submission_Date__c=System.Today();
             newtaskcustomerrelated.Description=newtask.Description;
             
             newtaskcustomerrelated.Query_Sub_Type_System_Related__c=newtask.Query_Sub_Type_System_Related__c;
             newtaskcustomerrelated.Sub_query_Type_Customer_Related__c=newtask.Sub_query_Type_Customer_Related__c;
             if(customercomment.length()>255){             
                  ApexPages.Message err = new ApexPages.Message(ApexPages.Severity.ERROR,'Customer Related Comment max length=255');
                  ApexPages.addMessage(err);
                  return null; 
             }else{
                 //newtaskcustomerrelated.System_Related_Comment__c=customercomment;
                 newtaskcustomerrelated.Customised_Comments__c=customercomment;
             }
             
             newtasklist.add(newtaskcustomerrelated);
            
         }
         if(Iscancellationrelated){
           Task newtaskcancelationrelated=new Task();
           newtaskcancelationrelated.RecordTypeId=recordtypemap.get('Cancellation Related');
           newtaskcancelationrelated.Query_Type__c=cancellationrelatedpick; 
           newtaskcancelationrelated.OwnerId=newtask.OwnerId;
           newtaskcancelationrelated.Status=newtask.Status;
           newtaskcancelationrelated.WhatId=AccountId;
           newtaskcancelationrelated.ActivityDate=System.Today();
           newtaskcancelationrelated.Subject=subjectpickval;
           newtaskcancelationrelated.ReminderDateTime=reminderdatetime;
           newtaskcancelationrelated.IsReminderSet=reminderset;
           newtaskcancelationrelated.Communication_Type__c=newtask.Communication_Type__c;
           newtaskcancelationrelated.Call_sType__c=newtask.Call_sType__c;
           newtaskcancelationrelated.Target_Completion_Date__c=newtask.Target_Completion_Date__c;
           newtaskcancelationrelated.Task_Submission_Date__c=System.Today();
           newtaskcancelationrelated.Description=newtask.Description;
           newtaskcancelationrelated.Query_Sub_Type_Cancellation_Related__c=newtask.Query_Sub_Type_Cancellation_Related__c;
           newtaskcancelationrelated.Query_Sub_Type_1_Cancellation_Related__c=newtask.Query_Sub_Type_1_Cancellation_Related__c;
           newtaskcancelationrelated.Reason_for_Cancellation__c=newtask.Reason_for_Cancellation__c;
           newtaskcancelationrelated.Customer_wishes_to_continue__c=newtask.Customer_wishes_to_continue__c;
           newtaskcancelationrelated.Result_of_retention_call__c=newtask.Result_of_retention_call__c;
           
           if(cancellationcomment.length()>255){             
                  ApexPages.Message err = new ApexPages.Message(ApexPages.Severity.ERROR,'Cancellation Related Comment max length=255');
                  ApexPages.addMessage(err);
                  return null; 
             }else{
                 //newtaskcancelationrelated.Cancellation_Related_Comment__c=cancellationcomment;
                  newtaskcancelationrelated.Customised_Comments__c=cancellationcomment;
             }
                     
           newtasklist.add(newtaskcancelationrelated);
         }
         
          system.debug('IsTDSAuthorizationrelated'+IsTDSAuthorizationrelated);
         if(IsTDSAuthorizationrelated){
             Task newtaskTDSAuthorizationrelated=new Task();
             newtaskTDSAuthorizationrelated.RecordTypeId=recordtypemap.get('TDS Related');
             system.debug('RecordTypeId'+newtaskTDSAuthorizationrelated.RecordTypeId);
             system.debug('TDSAuthorizationPickValue'+TDSAuthorizationPickValue);
             newtaskTDSAuthorizationrelated.Query_Type__c=TDSAuthorizationPickValue; 
             newtaskTDSAuthorizationrelated.OwnerId=newtask.OwnerId;
             newtaskTDSAuthorizationrelated.Status=newtask.Status;
             newtaskTDSAuthorizationrelated.WhatId=AccountId;
             newtaskTDSAuthorizationrelated.Subject=subjectpickval;
             newtaskTDSAuthorizationrelated.ReminderDateTime=reminderdatetime;
             newtaskTDSAuthorizationrelated.IsReminderSet=reminderset;
             newtaskTDSAuthorizationrelated.Communication_Type__c=newtask.Communication_Type__c;
             newtaskTDSAuthorizationrelated.Call_sType__c=newtask.Call_sType__c;
             newtaskTDSAuthorizationrelated.Target_Completion_Date__c=newtask.Target_Completion_Date__c;
             newtaskTDSAuthorizationrelated.ActivityDate=System.Today();
             newtaskTDSAuthorizationrelated.Task_Submission_Date__c=System.Today();
             newtaskTDSAuthorizationrelated.Description=newtask.Description;
             
             newtaskTDSAuthorizationrelated.TDS_Related__c=newtask.TDS_Related__c;
                if(TDSAuthorizationcomment.length() >255){
                    ApexPages.Message err = new ApexPages.Message(ApexPages.Severity.ERROR,'TDSAuthorization Related Comment max length=255');
                    ApexPages.addMessage(err);
                    return null;
                }
                else{
                    newtaskTDSAuthorizationrelated.Customised_Comments__c=TDSAuthorizationcomment;
                    } 
            newtasklist.add(newtaskTDSAuthorizationrelated);    

        }           
            /*Iseditform=false;
            Issaveform=true;*/
            system.debug('LISTOFTASKCRETAED '+newtasklist);
            Insert newtasklist;
             pagereference p=new pagereference('/'+AccountId);
             return p;
          }else{
          
           system.debug('Inside ELSE ');
           
           String errmsg='Query Type cannot be blank, Please enter a value.';
            ApexPages.Message err =new ApexPages.Message(ApexPages.Severity.ERROR,'Query Type cannot be blank, Please enter a value.');
            ApexPages.addMessage(err); 
                  return null;
          
          }
             
            
         
         }catch(Exception e){
             string errMsg = 'ERROR in Inserting Task ' + e.getMessage();
            ApexPages.addMessages(e);
             return null;
         }
         
         
         return null;

     }
     
     public pagereference Cancel(){
     
         pagereference p=new pagereference('/'+AccountId);
         return p;
     }
}