public class TestRMCustomerLifeCycleController {
    
    

    public List<MileStoneWrapper> finalmilestoneList {get;set;}
    RestAPICalloutPayment RestAPICalloutPayment_obj;
    RestAPICalloutController RestAPICalloutController_obj;
    RestAPICalloutController.CustomerInformationWrapper RestAPICallout_wrapper_obj;
    
    public List<MileStoneWrapper> appmoneyList;
   
    public List<MileStoneWrapper> finalList{get;set;}
    
    public TestRMCustomerLifeCycleController() {
        
       // calling payment and customer info web services 
        RestAPICalloutPayment_obj = new RestAPICalloutPayment('1400780');
        RestAPICalloutController_obj = new RestAPICalloutController();
        RestAPICallout_wrapper_obj = new RestAPICalloutController.CustomerInformationWrapper();
        RestAPICallout_wrapper_obj = RestAPICalloutController_obj.parseCustomerInformationJSON('1210055');

       
       //calling methods to set customer Life cycle; 
       //in this method two argument have been passes first is the customer info webservice record and second one is the uniform paymnet list.
       createmilestones(RestAPICallout_wrapper_obj, RestAPICalloutPayment_obj.paymentInfoList);
       setcolortoMilestones();
       system.debug('FinalMile stone List :::::'+finalmilestoneList );
       createSublists();
       
    
    }


   
    
    // method to sort mile stones without dates alphabetically 
    public list<MileStoneWrapper> sortmilestonesAlphabetically(list<MileStoneWrapper> Unsortedmilestonelist) {
        for(integer i=0; i<Unsortedmilestonelist.size(); i++) {
            for (integer j=1; j<(Unsortedmilestonelist.size()-i); j++ ){
            
                if(Unsortedmilestonelist[j-1].milestone_title.compareTo(Unsortedmilestonelist[j].milestone_title) == 1) {
                    MileStoneWrapper temp = new MileStoneWrapper();
                    temp.milestone_title = Unsortedmilestonelist[j-1].milestone_title;
                    temp.milestone_date = Unsortedmilestonelist[j-1].milestone_date;
                    temp.milestone_color = Unsortedmilestonelist[j-1].milestone_color;
                    temp.hover_data = Unsortedmilestonelist[j-1].hover_data;
                    Unsortedmilestonelist[j-1].milestone_title = Unsortedmilestonelist[j].milestone_title;
                    Unsortedmilestonelist[j-1].milestone_date = Unsortedmilestonelist[j].milestone_date;
                    Unsortedmilestonelist[j-1].milestone_color = Unsortedmilestonelist[j].milestone_color;
                    Unsortedmilestonelist[j-1].hover_data = Unsortedmilestonelist[j].hover_data;
                    Unsortedmilestonelist[j].milestone_title = temp.milestone_title;
                    Unsortedmilestonelist[j].milestone_date = temp.milestone_date;
                    Unsortedmilestonelist[j].milestone_color = temp.milestone_color;
                    Unsortedmilestonelist[j].hover_data = temp.hover_data;  
                }
    
            }
        }
        system.debug('Sorted List ::::::::'+Unsortedmilestonelist);
        return Unsortedmilestonelist; // unsorted list ofter sorting 
    }
    
    
    // method to sort mile stones with dates 
    public list<MileStoneWrapper> sortmilestones(list<MileStoneWrapper> Unsortedmilestonelist)  {
        for(integer i=0; i<Unsortedmilestonelist.size(); i++) {
            for (integer j=1; j<(Unsortedmilestonelist.size()-i); j++ ){
            
                if(getdate(Unsortedmilestonelist[j-1].milestone_date).daysBetween(getdate(Unsortedmilestonelist[j].milestone_date))<0) {
                    MileStoneWrapper temp = new MileStoneWrapper();
                    temp.milestone_title = Unsortedmilestonelist[j-1].milestone_title;
                    temp.milestone_date = Unsortedmilestonelist[j-1].milestone_date;
                    temp.milestone_color = Unsortedmilestonelist[j-1].milestone_color;
                    temp.hover_data = Unsortedmilestonelist[j-1].hover_data;
                    Unsortedmilestonelist[j-1].milestone_title = Unsortedmilestonelist[j].milestone_title;
                    Unsortedmilestonelist[j-1].milestone_date = Unsortedmilestonelist[j].milestone_date;
                    Unsortedmilestonelist[j-1].milestone_color = Unsortedmilestonelist[j].milestone_color;
                    Unsortedmilestonelist[j-1].hover_data = Unsortedmilestonelist[j].hover_data;
                    Unsortedmilestonelist[j].milestone_title = temp.milestone_title;
                    Unsortedmilestonelist[j].milestone_date = temp.milestone_date;
                    Unsortedmilestonelist[j].milestone_color = temp.milestone_color;
                    Unsortedmilestonelist[j].hover_data = temp.hover_data;  
                }
        
            }
        
        }
        system.debug('Sorted List ::::::::'+Unsortedmilestonelist);
        return Unsortedmilestonelist;
    
    }
    
     // list which holds all milestones
    
    
    // method to culb all mile stones together
    public void createmilestones(RestAPICalloutController.CustomerInformationWrapper  RestAPICalloutController_obj, List<RestAPICalloutPayment.paymentInfo> paymentInfo_lst) {  
      
        List<MileStoneWrapper> milestoneListWithdate = new List<MileStoneWrapper>();
        List<MileStoneWrapper> milestoneListWithoutdate = new List<MileStoneWrapper>();
        finalmilestoneList = new List<MileStoneWrapper>();
        
        MileStoneWrapper m_obj; 
        
        //Milestones from web service A (customer info)
        if(RestAPICalloutController_obj.welcome_onboard!=null && RestAPICalloutController_obj.welcome_onboard!='') {
            m_obj = new MileStoneWrapper();
            m_obj.milestone_title='Welcome Onboard';
            m_obj.milestone_date = RestAPICalloutController_obj.welcome_onboard;
            milestoneListWithdate.add(m_obj);
        }
         if(RestAPICalloutController_obj.allotment_letter!=null && RestAPICalloutController_obj.allotment_letter!='') {
            m_obj = new MileStoneWrapper();
            m_obj.milestone_title='Allotment Letter Date';
            m_obj.milestone_date = RestAPICalloutController_obj.allotment_letter;
            milestoneListWithdate.add(m_obj);
        }
        
         if(RestAPICalloutController_obj.registration_challan_date !=null && RestAPICalloutController_obj.registration_challan_date !='') {
            m_obj = new MileStoneWrapper();
            m_obj.milestone_title='Registration Challan Date ';
            m_obj.milestone_date = RestAPICalloutController_obj.registration_challan_date ;
            milestoneListWithdate.add(m_obj);
        }
        
         if(RestAPICalloutController_obj.registration_date !=null && RestAPICalloutController_obj.registration_date !='') {
            m_obj = new MileStoneWrapper();
            m_obj.milestone_title='Registration Date';
            m_obj.milestone_date = RestAPICalloutController_obj.registration_date ;
            milestoneListWithdate.add(m_obj);
        }
        
         if(RestAPICalloutController_obj.loan_sanctioned_letter_date !=null && RestAPICalloutController_obj.loan_sanctioned_letter_date!='') {
            m_obj = new MileStoneWrapper();
            m_obj.milestone_title='Loan Sanctioned Letter Date ';
            m_obj.milestone_date = RestAPICalloutController_obj.loan_sanctioned_letter_date;
            m_obj.hover_data = 'Funding Status: ' + RestAPICalloutController_obj.funding_status +' Disbursal Amount: ' + RestAPICalloutController_obj.disbursal_amount + ' NOC/ROC: ' +RestAPICalloutController_obj.noc_roc_date ;
            milestoneListWithdate.add(m_obj);
        }
        
         if(RestAPICalloutController_obj.offer_for_fitout_possession !=null && RestAPICalloutController_obj.offer_for_fitout_possession !='') {
            m_obj = new MileStoneWrapper();
            m_obj.milestone_title='Offer For Fitout Possession ';
            m_obj.milestone_date = RestAPICalloutController_obj.offer_for_fitout_possession;
            milestoneListWithdate.add(m_obj);
        }
        
         if(RestAPICalloutController_obj.possession_date  !=null && RestAPICalloutController_obj.possession_date  !='') {
            m_obj = new MileStoneWrapper();
            m_obj.milestone_title='Possession Date';
            m_obj.milestone_date = RestAPICalloutController_obj.possession_date;
            milestoneListWithdate.add(m_obj);
        }
        
        if(RestAPICalloutController_obj.key_handover_date  !=null && RestAPICalloutController_obj.key_handover_date  !='') {
            m_obj = new MileStoneWrapper();
            m_obj.milestone_title='Key Handover Date';
            m_obj.milestone_date = RestAPICalloutController_obj.key_handover_date;
            milestoneListWithdate.add(m_obj);
        }
        
        // list to hold appmoney 1 and 2 or time bound 21 days and 42 days if the come with null bill date
        appmoneyList = new List<MileStoneWrapper>();
                        
        //Milestones from web service B (Payment info)
        for(RestAPICalloutPayment.paymentInfo paymentInfo_obj : paymentInfo_lst) {
            if(paymentInfo_obj.payment_mileStone!='Earnest Money'){ 
            
                // identifying app money 1 and app money 2 to select its position 
                if((paymentInfo_obj.payment_mileStone=='Application money-1' && (paymentInfo_obj.bill_date== null ||paymentInfo_obj.bill_date== '')) ||
                    (paymentInfo_obj.payment_mileStone=='Application money-2' && (paymentInfo_obj.bill_date== null ||paymentInfo_obj.bill_date== '')) ||
                    (paymentInfo_obj.payment_mileStone=='Timebound Demand 21Days' && (paymentInfo_obj.bill_date== null ||paymentInfo_obj.bill_date== '')) ||
                    (paymentInfo_obj.payment_mileStone=='Timebound Demand 42Days' && (paymentInfo_obj.bill_date== null ||paymentInfo_obj.bill_date== ''))){
                        m_obj = new MileStoneWrapper();
                        m_obj.milestone_title = paymentInfo_obj.payment_mileStone;
                        m_obj.milestone_date = paymentInfo_obj.bill_date;
                        appmoneyList.add(m_obj);
                }
                //if app money 1 and app money 2 bill dates ate available
                else {
                
                    // if data contains bill date 
                    if(paymentInfo_obj.bill_date != null && paymentInfo_obj.bill_date != '') {
                        m_obj = new MileStoneWrapper();
                        m_obj.milestone_title = paymentInfo_obj.payment_mileStone;
                        m_obj.milestone_date = paymentInfo_obj.bill_date;
                        milestoneListWithdate.add(m_obj);
                    }
                    //if data do not contains bill date 
                    else {
                        m_obj = new MileStoneWrapper();
                        m_obj.milestone_title = paymentInfo_obj.payment_mileStone;
                        m_obj.milestone_date = paymentInfo_obj.bill_date;
                        milestoneListWithoutdate.add(m_obj);
                    }
                }
                
           }
        }
        
        
        //adding Earnest Money at first position
        for(RestAPICalloutPayment.paymentInfo paymentInfo_obj : paymentInfo_lst) {
            if(paymentInfo_obj.payment_mileStone=='Earnest Money') {
                m_obj = new MileStoneWrapper();
                m_obj.milestone_title = paymentInfo_obj.payment_mileStone;
                m_obj.milestone_date = paymentInfo_obj.bill_date;
                m_obj.milestone_color = '#2f76d2';
                finalmilestoneList.add(m_obj);
            }
        }
        
        //adding all milestones with date to final list
        for(MileStoneWrapper mile_obj : sortmilestones(milestoneListWithdate)){    
            finalmilestoneList.add(mile_obj);
        }
        // adding all milestones without date to final list
        for(MileStoneWrapper mile_obj :sortmilestonesAlphabetically(milestoneListWithoutdate)) {
            finalmilestoneList.add(mile_obj);
        }
        // adding possession date at last position
        m_obj = new MileStoneWrapper();
        m_obj.milestone_title='Possession Date ';
        m_obj.milestone_date = RestAPICalloutController_obj.possession_date ;
        finalmilestoneList.add(m_obj);
        
        system.debug('finalmilestoneList :::::: '+finalmilestoneList);
        
        
        
        
    }
    
    
    
  // method to change date formate for calculation  
    public Date getdate(String mydate){
     
       System.debug('ingetdate:::::1'+mydate);   
        String s = mydate.normalizeSpace();
        s = s.trim();
        List<string> datesplit = new List<string>();
        datesplit = s.split(' ');
        if(datesplit.size() == 3) {
            if(datesplit[1] == 'Jan') {
                datesplit[1] = '-01-';
            }
            else if(datesplit[1] == 'Feb') {
                datesplit[1] = '-02-';
            }
            else if(datesplit[1] == 'Mar') {
                datesplit[1] = '-03-';
            }
            else if(datesplit[1] == 'Apr') {
                datesplit[1] = '-04-';
            }
            else if(datesplit[1] == 'May') {
                datesplit[1] = '-05-';
            }
            else if(datesplit[1] == 'Jun') {
                datesplit[1] = '-06-';
            }
            else if(datesplit[1] == 'Jul') {
                datesplit[1] = '-07-';
            }
            else if(datesplit[1] == 'Aug') {
                datesplit[1] = '-08-';
            }
            else if(datesplit[1] == 'Sep') {
                datesplit[1] = '-09-';
            }
            else if(datesplit[1] == 'Oct') {
                datesplit[1] = '-10-';
            }
            else if(datesplit[1] == 'Nov') {
                datesplit[1] = '-11-';
            }
            else if(datesplit[1] == 'Dec') {
                datesplit[1] = '-12-';
            }
            
            s = datesplit[2]+datesplit[1]+datesplit[0];
            
             system.debug('Date::::::::::::::::::::'+Date.valueOf(s));
            return Date.valueOf(s);
        }
        else {
        
                System.debug('ingetdate:::::1'+mydate);
                return Date.valueOf(mydate);
        }
    }
    
    
    // method that sets color code according to multiple conditions 
    public void setcolortoMilestones() {
        boolean greenfound = false;
       
        
        //if slab List has green color then  set color to remaining mile stone 
   
            setColorCode(finalmilestoneList);
        
 
        
        //adding app money 1 and 2 in list
        if(appmoneyList.size()!=0){
            List<MileStoneWrapper> templist = new List<MileStoneWrapper>();
            for(MileStoneWrapper f_milestone :finalmilestoneList){
                if(f_milestone.milestone_title.contains('Slab')){
                    
                    MileStoneWrapper appm1 = new MileStoneWrapper();
                    MileStoneWrapper appm2 = new MileStoneWrapper();
                    appm1.milestone_title = appmoneyList[0].milestone_title;
                    templist.add(appm1);
                    appm2.milestone_title = appmoneyList[1].milestone_title;
                    templist.add(appm2);
                    break;
                }
                else {
                    templist.add(f_milestone);
                }
            }
            finalmilestoneList.clear();
            for(MileStoneWrapper f_milestone :templist) {
                finalmilestoneList.add(f_milestone);    
            }
        }
    }
    
    
     
    // Method thta conatins logic for color code allocation
    public void setColorCode(list<MileStoneWrapper> colormilestonelist){
     boolean flag = true;
       // iterate over the milestones to set milestone color
       for(integer i=0; i<colormilestonelist.size();i++) {
           if(colormilestonelist[i].milestone_date != null && colormilestonelist[i].milestone_date != '') {
           
               if(getdate(colormilestonelist[i].milestone_date)>= Date.today() && flag==true) {
                    if(getdate(colormilestonelist[i].milestone_date)== Date.today()){
                          colormilestonelist[i].milestone_color='#7fe484';
                          flag = false;
                    
                    }
                    else {
                          colormilestonelist[i-1].milestone_color='#7fe484';
                          colormilestonelist[i].milestone_color='#dbdbdb';
                          flag = false;
                    }
               }
               else if((getdate(colormilestonelist[i].milestone_date)> Date.today() || colormilestonelist[i].milestone_date=='null') && flag==false) {
                      colormilestonelist[i].milestone_color='#dbdbdb';
               }
            }
            else  {
                if(colormilestonelist[i].milestone_title != 'Earnest money') {
                    colormilestonelist[i].milestone_color='#dbdbdb';
                }
            }
           
       }
      
   
    }
    
    
     public void createSublists()  {
     finalList = new MileStoneWrapper[15];
          
        
        // if no of milestone are greater than 15 
        if(finalmilestoneList.size()>15) {
             System.debug('interin more than 15');
             // stores index of green milestones 
             integer greenindex;
             
             // shows whether green milestone is present or not 
             boolean greenfound = false;
             
             // search for green miloestone
             for(integer i =0 ; i<finalmilestoneList.size();i++) {
                if(finalmilestoneList[i].milestone_color=='#7fe484') { 
                    greenindex = i;
                    greenfound = true;
                }
             }
             System.debug('greenfound::::'+greenfound);
             // if green milestone is present 
             if(greenfound) {
             System.debug('interin greefound');
             List<MileStoneWrapper> forwardList = new List<MileStoneWrapper>();
             List<MileStoneWrapper> backwardList = new List<MileStoneWrapper>();
             List<MileStoneWrapper> forward_backwardList = new List<MileStoneWrapper>();
                
                // add backward milestones of greenindex
                integer backwardboundry ;
                for(integer gi=greenindex; gi>=0&&gi>=greenindex-3 ; gi--) {
                    backwardList.add(finalmilestoneList[gi]);
                    backwardboundry = gi;
                }
                
                // add forward milestones of greenindex
                integer forwardboundry ;
                for(integer gi=greenindex; gi<=finalmilestoneList.size()-1 && gi<=greenindex+3 ; gi++) {
                    forwardList.add(finalmilestoneList[gi]); 
                    forwardboundry = gi;
                }
                
                //stores size of greenList
                integer greenlistsize = forwardList.size() + backwardList.size();
                
                // List that holds list of milestone with green color 
                List<MileStoneWrapper> greenlist = new List<MileStoneWrapper>();
                
                // combine forward and backward milestone 
                // add backward elements
                for(integer i=backwardList.size(); i>0 ; i--) {
                    greenlist.add(backwardList[i]);
                }
                // add forward elements
                for(integer i=0 ; i<forwardList.size() ; i++) {
                    greenlist.add(forwardList[i]);
                }
                
                //if greenlist sets at start or end 
                if(greenlistsize<=6) {
                    
                    //if greenlist sets at start 
                    if(greenindex<=6) {
                        for(MileStoneWrapper greenListobj :greenlist) {
                            finalList.add(greenListobj);
                        }
                        
                    }
                    
                    // if greenList sets at end 
                    if(greenindex>=finalmilestoneList.size()-7) {
                        integer x=14;
                        for(integer i=finalmilestoneList.size()-1; i>=((finalmilestoneList.size()-1)+greenlistsize); i--) {
                            finalList[x]=finalmilestoneList[i];
                            x=x-1;
                        }
                        
                        
                    }
                }
              
                // if greenList  size is equal to 7   
                else if(greenlistsize==7) {
                System.debug('interin greeflist 7');
                    //if backwardboundry is at zero
                    if(backwardboundry==0) {
                        for(MileStoneWrapper greenListobj :greenlist) {
                            finalList.add(greenListobj);
                        }
                        integer mid = finalmilestoneList.size()/2;
                        finalList[14] =  finalmilestoneList[finalmilestoneList.size()-1];
                        finalList[13] =  finalmilestoneList[finalmilestoneList.size()-2];
                        finalList[12] =  finalmilestoneList[finalmilestoneList.size()-3];
                        finalList[10] =  finalmilestoneList[mid+2];
                        finalList[9] =  finalmilestoneList[mid+1];
                        finalList[8] =  finalmilestoneList[mid];
                        for(integer i=7;i<mid;i++) {
                            MileStoneSublistWrapper sublist1 = new MileStoneSublistWrapper();
                            sublist1.milestone_title=finalmilestoneList[i].milestone_title;
                            sublist1.milestone_date=finalmilestoneList[i].milestone_date;
                            sublist1.milestone_color=finalmilestoneList[i].milestone_color;
                            sublist1.hover_data=finalmilestoneList[i].hover_data;
                            finalList[7].MileStoneSublist.add(sublist1);
                        }
                        for(integer i=mid+3; i<finalmilestoneList.size()-3; i++) {
                            MileStoneSublistWrapper sublist1 = new MileStoneSublistWrapper();
                            sublist1.milestone_title=finalmilestoneList[i].milestone_title;
                            sublist1.milestone_date=finalmilestoneList[i].milestone_date;
                            sublist1.milestone_color=finalmilestoneList[i].milestone_color;
                            sublist1.hover_data=finalmilestoneList[i].hover_data;
                            finalList[11].MileStoneSublist.add(sublist1);
                        }
                    }
                    
                    // if backwardboundry is graeter than zero 
                    if(backwardboundry>0){
                        if(backwardboundry<3) {
                               System.debug('interin greeflist backboundry');
                            for(integer i=0; i<backwardboundry; i++) {
                                finalList[i]=finalmilestoneList[i];
                            }
                            for(MileStoneWrapper greenListobj :greenlist) {
                                finalList.add(greenListobj);
                            }
                            //by sudeep: add after the green list last index to 10th elment element of final list not assigned yet, so add the element forward+1 to last finallist index to y=the 10th element location of  final list  
                            integer fb=forwardboundry+1;
                            for(integer i=finalList.size();i<11;i++){
                            finalList[i]=finalmilestoneList[fb];
                            fb=fb+1;
                            }
                            for(integer i=fb;i<finalmilestoneList.size()-3;i++) {
                                MileStoneSublistWrapper sublist1 = new MileStoneSublistWrapper();
                                sublist1.milestone_title=finalmilestoneList[i].milestone_title;
                                sublist1.milestone_date=finalmilestoneList[i].milestone_date;
                                sublist1.milestone_color=finalmilestoneList[i].milestone_color;
                                sublist1.hover_data=finalmilestoneList[i].hover_data;
                                finalList[11].MileStoneSublist.add(sublist1);
                            }
                            finalList[14] =  finalmilestoneList[finalmilestoneList.size()-1];
                            finalList[13] =  finalmilestoneList[finalmilestoneList.size()-2];
                            finalList[12] =  finalmilestoneList[finalmilestoneList.size()-3];
                        }
                        
                    }
                    
                    // if forwardboundry is last
                    if(forwardboundry==finalmilestoneList.size()-1) {
                                               
                       for(integer i=0; i<3;i++ ) {
                             finalList[i]=finalmilestoneList[i];
                            //finalList.add(finalmilestoneList[i]);
                        }
                    
                        /*by sudeep : commented because i think the code copy green-list to final-list from the gren list last index to 0 index and copy to same 
                          and the updated code for the same is just below of the commented code 
                        integer y = greenlist.size()-1;
                        for(integer i=finalmilestoneList.size()-1; i<greenlist.size();i--) {
                            finalList.add(greenlist[y]);
                            y=y-1;
                        }*/
                        integer y = 14;
                        for(integer i=greenlist.size()-1;i>=0;i--){
                        finalList[y]=greenlist[i];
                        y=y-1;
                        }
                        
                        /*by sudeep commented: why do this it is as  above the  commneted code so i comment it here 
                        for(integer i=0; i<3;i++) {
                            finalList[i]=finalmilestoneList[i];
                        }*/
                        
                        for(integer i=3;i<backwardboundry-4;i++) {
                                MileStoneSublistWrapper sublist1 = new MileStoneSublistWrapper();
                                sublist1.milestone_title=finalmilestoneList[i].milestone_title;
                                sublist1.milestone_date=finalmilestoneList[i].milestone_date;
                                sublist1.milestone_color=finalmilestoneList[i].milestone_color;
                                sublist1.hover_data=finalmilestoneList[i].hover_data;
                                finalList[3].MileStoneSublist.add(sublist1);
                        }
                        finalList[4]=finalmilestoneList[backwardboundry-4];
                        finalList[5]=finalmilestoneList[backwardboundry-3];
                        finalList[6]=finalmilestoneList[backwardboundry-2];
                        finalList[7]=finalmilestoneList[backwardboundry-1];
                        
                        
                        
                    }
                    
                    //forward boundary is not last means list contains element after the greenlist in right side
                    if(forwardboundry<finalmilestoneList.size()-1){
                     //add first three element as it is         3    
                     for(integer i=0; i<3;i++ ) {
                             finalList[i]=finalmilestoneList[i];
                            //finalList.add(finalmilestoneList[i]);
                        }
                            
                    
                     //add before the the green list element using backword boundary start from 4th(index 3) element to backward-10     1
                      for(integer i=3;i<backwardboundry;i++) {
                                MileStoneSublistWrapper sublist1 = new MileStoneSublistWrapper();
                                sublist1.milestone_title=finalmilestoneList[i].milestone_title;
                                sublist1.milestone_date=finalmilestoneList[i].milestone_date;
                                sublist1.milestone_color=finalmilestoneList[i].milestone_color;
                                sublist1.hover_data=finalmilestoneList[i].hover_data;
                                finalList[3].MileStoneSublist.add(sublist1);
                        }
                     //add green list    7
                     for(integer i=0;i<greenList.size();i++){
                        finalList.add(finalmilestoneList[i]);      
                      }
                     integer element_diff=finalmilestoneList.size()-(forwardboundry+1);
                     if(element_diff>4){
                      for(integer i=forwardboundry+1;i<finalmilestoneList.size()-3;i++){
                         MileStoneSublistWrapper sublist1 = new MileStoneSublistWrapper();
                                sublist1.milestone_title=finalmilestoneList[i].milestone_title;
                                sublist1.milestone_date=finalmilestoneList[i].milestone_date;
                                sublist1.milestone_color=finalmilestoneList[i].milestone_color;
                                sublist1.hover_data=finalmilestoneList[i].hover_data;
                                finalList[11].MileStoneSublist.add(sublist1);   
                       }
                         finalList[14] =  finalmilestoneList[finalmilestoneList.size()-1];
                         finalList[13] =  finalmilestoneList[finalmilestoneList.size()-2];
                         finalList[12] =  finalmilestoneList[finalmilestoneList.size()-3];
                     }else{
                        
                        for(integer i=forwardboundry+1;i<finalmilestoneList.size();i++){
                           finalList.add(finalmilestoneList[i]); 
                        }       
                     }
                      
                    }
                }
                
            
            }
        
            
             
             // if green not found
             
             else {
               System.debug('greenfoundFalse::::'+greenfound);
                // find mid of list
                integer mid = finalmilestoneList.size()/2;
                system.debug('enterin notgreenfound');
                // set milestone to desired locations 
                finalList[0] =  finalmilestoneList[0];
                finalList[1] =  finalmilestoneList[1];
                finalList[2] =  finalmilestoneList[2];
                finalList[14] =  finalmilestoneList[finalmilestoneList.size()-1];
                finalList[13] =  finalmilestoneList[finalmilestoneList.size()-2];
                finalList[12] =  finalmilestoneList[finalmilestoneList.size()-3];
                finalList[7] =  finalmilestoneList[mid];
                finalList[8] =  finalmilestoneList[mid+1];
                finalList[9] =  finalmilestoneList[mid+2];
                finalList[10] =  finalmilestoneList[mid+3];
                finalList[6] =  finalmilestoneList[mid-1];
                finalList[5] =  finalmilestoneList[mid-2];
                finalList[4] =  finalmilestoneList[mid-3];
                
                //shruti add two lines this code when any where the folowing condition
                finalList[3] =  finalmilestoneList[3];
                finalList[3].MileStoneSublist=new list<MileStoneSublistWrapper>();
                for(integer i=3;i<mid-3;i++) {
                    MileStoneSublistWrapper sublist1 = new MileStoneSublistWrapper();
                    sublist1.milestone_title=finalmilestoneList[i].milestone_title;
                    sublist1.milestone_date=finalmilestoneList[i].milestone_date;
                    sublist1.milestone_color=finalmilestoneList[i].milestone_color;
                    sublist1.hover_data=finalmilestoneList[i].hover_data;
                
                    finalList[3].MileStoneSublist.add(sublist1);
                 }
                    //shruti add two lines this code when any where the folowing condition
                 finalList[11] =  finalmilestoneList[mid+4];
                 finalList[11].MileStoneSublist=new list<MileStoneSublistWrapper>();
                 for(integer i=mid+4;i<finalmilestoneList.size()-3;i++) {
                    MileStoneSublistWrapper sublist1 = new MileStoneSublistWrapper();
                    sublist1.milestone_title=finalmilestoneList[i].milestone_title;
                    sublist1.milestone_date=finalmilestoneList[i].milestone_date;
                    sublist1.milestone_color=finalmilestoneList[i].milestone_color;
                    sublist1.hover_data=finalmilestoneList[i].hover_data;
                    finalList[11].MileStoneSublist.add(sublist1);
                 }
             }
             
         
         }
         else  
         {
            for(MileStoneWrapper m_obj : finalmilestoneList) {
                finalList.add(m_obj);
            }
         }
        
    }
    
    
    

    
    
    //wrapper class which clubs milestone data
    public class MileStoneWrapper {
    
        public string milestone_title {get; set;} //stores title of milestone
        public string milestone_date {get; set;} //stores date of milestone
        public string milestone_color {get; set;} //stores color of milestone
        public string hover_data {get;set;} //stores hover data of milestone
        public List<MileStoneSublistWrapper> MileStoneSublist {get; set;} // list of sublist of a mile stone 
        
        // default constructor of milestone
        public MileStoneWrapper() {
        
              milestone_color='#2f76d2';   // default color for all milestone
        
        }
    
    }
    
     public class MileStoneSublistWrapper {
    
        public string milestone_title {get; set;} //stores title of milestone
        public string milestone_date {get; set;} //stores date of milestone
        public string milestone_color {get; set;} //stores color of milestone
        public string hover_data {get;set;} //stores hover data of milestone
     
        
        // default constructor of milestone
        public MileStoneSublistWrapper () {
        
              milestone_color='#2f76d2';   // default color for all milestone
        
        }
    

    }

}







/*
RestAPICalloutPayment obj1 = new RestAPICalloutPayment('1400780');

RestAPICalloutController RestAPICalloutController_obj = new RestAPICalloutController();
RestAPICalloutController.CustomerInformationWrapper RestAPICallout_wrapper_obj = new RestAPICalloutController.CustomerInformationWrapper();
RestAPICallout_wrapper_obj = RestAPICalloutController_obj.parseCustomerInformationJSON('1210055');


CustomerLifeCycleController obj = new CustomerLifeCycleController(RestAPICallout_wrapper_obj,obj1.paymentInfoList);



*/