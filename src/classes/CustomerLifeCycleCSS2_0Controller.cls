public class CustomerLifeCycleCSS2_0Controller {
/*

    public MileStoneWrapper MileStoneWrapperobj {get; set;} //wrapper class object
    public RestAPICalloutController.CustomerInformationWrapper RestAPICallout_wrapper_obj {get;set;}
    public RestAPICalloutController RestAPICalloutController_obj;
    public Id  userId{get;set;}
    public String Customer_Name {get;set;}
    public String CRN {get;set;}
    public list<Account> RM_DetailsList {get;set;}
    public List<MileStoneWrapper> MileStoneWrapperlst {get; set;}
    public list<MileStoneWrapper> DateList ;
    public list<Integer> PositionList ;
    //public Integer i;
    //public Integer j;
    
    
    
    
    public CustomerLifeCycleCSS2_0Controller(){
        try
        {
            userId=Userinfo.getUserid();
            
            Customer_Name = [Select Name 
                             from user 
                             where id =: Userinfo.getUserid()].name;//get logged in users name
        }
        catch(Exception e)
        {
            system.debug(e);
        }
        RM_DetailsList = new list<Account>();
        CRN= CreateQueryHelper.getCustomerCRN(userId);
        //get RM details
        RM_DetailsList =[Select CRN__c,Owner.Email From Account where CRN__c =:CRN];
        
        MileStoneWrapperobj = new   MileStoneWrapper();   //milestone wraper class object initialised
        MileStoneWrapperlst = new List<MileStoneWrapper>();
        
        RestAPICalloutController_obj = new RestAPICalloutController();
        RestAPICallout_wrapper_obj = new RestAPICalloutController.CustomerInformationWrapper();
        RestAPICallout_wrapper_obj = RestAPICalloutController_obj.parseCustomerInformationJSON(CRN);
        setMilestoneColor();    
        
        
    }
    
      public void setMilestoneColor() {
       
       
       MileStoneWrapper MileStoneW_obj1 = new MileStoneWrapper();
       MileStoneW_obj1.milestone_title = 'welcome_onboard'; 
       MileStoneW_obj1.milestone_date = RestAPICallout_wrapper_obj.welcome_onboard  ;
       MileStoneWrapperlst.add(MileStoneW_obj1);
       system.debug('MileStoneWrapperlst<<<<<<<<<<<'+MileStoneWrapperlst);
       MileStoneWrapper MileStoneW_obj2 = new MileStoneWrapper();
       MileStoneW_obj2.milestone_title = 'timebound_demand_21days'; 
       MileStoneW_obj2.milestone_date = RestAPICallout_wrapper_obj.timebound_demand_21days  ;
       MileStoneWrapperlst.add(MileStoneW_obj2);
       system.debug('MileStoneWrapperlst<<<<<<<<<<<'+MileStoneWrapperlst);
       MileStoneWrapper MileStoneW_obj3 = new MileStoneWrapper();
       MileStoneW_obj3.milestone_title = 'allotment_letter'; 
       MileStoneW_obj3.milestone_date = RestAPICallout_wrapper_obj.allotment_letter  ;
       MileStoneWrapperlst.add(MileStoneW_obj3);
       system.debug('MileStoneWrapperlst<<<<<<<<<<<'+MileStoneWrapperlst);
       MileStoneWrapper MileStoneW_obj4 = new MileStoneWrapper();
       MileStoneW_obj4.milestone_title = 'timebound_demand_42days'; 
       MileStoneW_obj4.milestone_date = RestAPICallout_wrapper_obj.timebound_demand_42days;
       MileStoneWrapperlst.add(MileStoneW_obj4);
       system.debug('MileStoneWrapperlst<<<<<<<<<<<'+MileStoneWrapperlst);
       MileStoneWrapper MileStoneW_obj5 = new MileStoneWrapper();
       MileStoneW_obj5.milestone_title = 'registration_challan_date'; 
       MileStoneW_obj5.milestone_date = RestAPICallout_wrapper_obj.registration_challan_date;
       MileStoneWrapperlst.add(MileStoneW_obj5);
       system.debug('MileStoneWrapperlst<<<<<<<<<<<'+MileStoneWrapperlst);
       MileStoneWrapper MileStoneW_obj6 = new MileStoneWrapper();
       MileStoneW_obj6.milestone_title = 'registration_date'; 
       MileStoneW_obj6.milestone_date = RestAPICallout_wrapper_obj.registration_date;
       MileStoneWrapperlst.add(MileStoneW_obj6);
       system.debug('MileStoneWrapperlst<<<<<<<<<<<'+MileStoneWrapperlst);
       MileStoneWrapper MileStoneW_obj7 = new MileStoneWrapper();
       MileStoneW_obj7.milestone_title = 'loan_sanctioned_letter_date'; 
       MileStoneW_obj7.milestone_date = RestAPICallout_wrapper_obj.loan_sanctioned_letter_date;
       MileStoneWrapperlst.add(MileStoneW_obj7);
       system.debug('MileStoneWrapperlst<<<<<<<<<<<'+MileStoneWrapperlst);
       MileStoneWrapper MileStoneW_obj8 = new MileStoneWrapper();
       MileStoneW_obj8.milestone_title = 'basis'; 
       MileStoneW_obj8.milestone_date = '2015-04-01';
       MileStoneWrapperlst.add(MileStoneW_obj8); 
       system.debug('MileStoneWrapperlst<<<<<<<<<<<'+MileStoneWrapperlst);
       MileStoneWrapper MileStoneW_obj9 = new MileStoneWrapper();
       MileStoneW_obj9.milestone_title = 'offer_for_fitout_possession'; 
       MileStoneW_obj9.milestone_date = RestAPICallout_wrapper_obj.offer_for_fitout_possession;
       MileStoneWrapperlst.add(MileStoneW_obj9);
       system.debug('MileStoneWrapperlst<<<<<<<<<<<'+MileStoneWrapperlst);
       MileStoneWrapper MileStoneW_obj10 = new MileStoneWrapper();
       MileStoneW_obj10.milestone_title = 'possession_date';
       RestAPICallout_wrapper_obj.possession_date=''; 
       if(RestAPICallout_wrapper_obj.possession_date!='' && RestAPICallout_wrapper_obj.possession_date!=null){
       MileStoneW_obj10.milestone_date = RestAPICallout_wrapper_obj.possession_date;
       //MileStoneW_obj10.milestone_date = String.valueOf( Date.valueOf('0000-00-00'));
       }
       MileStoneWrapperlst.add(MileStoneW_obj10);
       
       MileStoneWrapper MileStoneW_obj11 = new MileStoneWrapper();
       MileStoneW_obj11.milestone_title = 'key_handover_date'; 
       MileStoneW_obj11.milestone_date = RestAPICallout_wrapper_obj.key_handover_date;
       MileStoneWrapperlst.add(MileStoneW_obj11);
       
       system.debug('MileStoneWrapperlst<<<<<<<<<<<'+MileStoneWrapperlst);
       ///
         system.debug('MileStoneWrapperlst<<<<<<<<<<<'+MileStoneWrapperlst);
       //Added by aditi
       //
       //
       PositionList = new List<Integer>();
       DateList = new list<MileStoneWrapper>();
       Integer j=0;
        for(MileStoneWrapper m_obj : MileStoneWrapperlst) {
           
           if(m_obj.milestone_date!=null && m_obj.milestone_date.trim()!=''){
              
              
               PositionList.add(j);
               DateList.add(m_obj);
               
           
           }
        j++;
       }
     
     
      Map<String, MileStoneWrapper> MilestoneMap = new Map<String,MileStoneWrapper>(); // Reversed for sorting
      List<String> sortList = new List<String>();
    // system.debug('*****DateListbefore****'+DateList);
     //DateList.sort();
    // system.debug('*****DateListAfter****'+DateList);
    /* MileStoneWrapper MilestoneTemp = new MileStoneWrapper();
      for(Integer i=0;i<Datelist.size();i++)
      {
          if(Datelist[i].milestone_date>Datelist[i+1].milestone_date)
          {
              MilestoneTemp = Datelist[i];
              Datelist[i]=Datelist[i+1];
              Datelist[i+1]=MilestoneTemp;
          
          }
      
      
      }*/
       /*system.debug('*****DateListbefore****'+DateList);
     for(MileStoneWrapper m_obj :DateList)
      {
      
           MilestoneMap.put(m_obj.milestone_date,m_obj); // For simplicity in this example, we assume the name is unique
           sortList.add(m_obj.milestone_date);     
      }
      
      sortList.sort();
      system.debug('*****sortList****'+sortList);
      DateList.clear();
      for(String s : sortList)
        {
               
           Datelist.add(MilestoneMap.get(s));
        }
      
       //system.debug('*****DateListAfter****'+DateList);
                     
       ////
      /* boolean flag = true;
           for(integer i=0; i<Datelist.size();i++) {
           if(date.valueOf(Datelist[i].milestone_date)>= Date.today() && flag==true) {
             if(date.valueOf(Datelist[i].milestone_date)== Date.today()){
             
                Datelist[i].milestone_color='#7fe484';
             
             
             }
             else{
                  Datelist[i-1].milestone_color='#7fe484';
                  Datelist[i].milestone_color='#dbdbdb';
                  flag = false;
                  }
           }
           else if((date.valueOf(Datelist[i].milestone_date)>= Date.today() || Datelist[i].milestone_date=='null') && flag==false) {
                  Datelist[i].milestone_color='#dbdbdb';
           }
           
       }
     /*  for(integer i=0; i<MileStoneWrapperlst.size();i++) {
           system.debug('MileStoneWrapperlstaftercolor<<<<<<<<<<<'+MileStoneWrapperlst[i]);
           if(MileStoneWrapperlst[i].milestone_title=='loan_sanctioned_letter_date'
            && MileStoneWrapperlst[i].milestone_date==null 
            && RestAPICallout_wrapper_obj.funding_status=='self' && MileStoneWrapperlst[i-1].milestone_color=='#2f76d2' )
            {
                MileStoneWrapperlst[i].milestone_color='#2f76d2';
            }
       
       }*/
     /*   system.debug('*****DateList****'+DateList);
        for(Integer i=0;i<DateList.size();i++)
        {
           system.debug('***PositionList[i]***'+PositionList[i]);
          MileStoneWrapperlst[PositionList[i]] = DateList[i];
        
        }
        system.debug('MileStoneWrapperlst<<<<<<<<<<<'+MileStoneWrapperlst);
       //
    
    }
    
    
    
    //wrapper class for customer life cycle 
    public class MileStoneWrapper {
        public string milestone_title {get; set;}
        public string milestone_date {get; set;}
        public string milestone_color {get; set;}
   
        
        public MileStoneWrapper() {
        
            milestone_color='#2f76d2';
            milestone_date='';
        
        }

          
    }*/
    
    
}