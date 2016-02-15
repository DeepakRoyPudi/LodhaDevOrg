/* 
Description : Controller class for customer Life cycle 
 @Created by: Shruti Nikam
 @Created Date: 9/4/2015
 
 --------------------------------------------------------------------------------
 | Modified By      | Modified Date       | Version        | Description         |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------

*/

public class RMCustomerLifeCycleController {

    // final list for final arrangement of milestones in life cycle 
    public List < MileStoneWrapper > finalMilestoneList {get;set;}
    public String PARAM_CRN {get;set;}

    //customer info web service objects
    RestAPICalloutPayment restAPICalloutPayment_Obj;
    RestAPICalloutController restAPICalloutController_Obj;
    RestAPICalloutController.CustomerInformationWrapper restAPICallout_wrapper_Obj;

    // list which holds color codes of life cycle 
    public List < string > colorList {get;set;}

    public List < MileStoneWrapper > appMoneyList;
    //variable to find mid of list 
    public integer mid;
    // final list to be shown on life cycle    
    public List < MileStoneWrapper > finalList {get;set;}

    //Constants for custom setting  
    public Static final String completed = 'Completed';
    public Static final String upcoming = 'Upcoming';
    public Static final String current = 'Current';

    //constants used in code 
    public Static final String welcome_Onboard = 'Welcome Onboard';
    public Static final String allotmentLetterDate = 'Allotment Letter Date';
    public Static final String registrationChallanDate = 'Registration Challan Date';
    public Static final String registrationDate = 'Registration Date';
    public Static final String loanSanctionedLetterDate = 'Loan Sanctioned Letter Date';
    public Static final String offerForFitoutPossession = 'Offer For Fitout Possession';
    public Static final String keyHandoverDate = 'Key Handover Date';
    public Static final String earnestMoney = 'Earnest Money';
    public Static final String applicationMoney1 = 'Application money-1';
    public Static final String applicationMoney2 = 'Application money-2';
    public Static final String timeboundDemand21Days = 'Timebound Demand 21Days';
    public Static final String timeboundDemand42Days = 'Timebound Demand 42Days';
    public Static final String possessionDate = 'Possession Date';
    public Static final String slab = 'Slab';
    // instances for cutome settings
    public LifeCycleColorCode__c Completed_setting_obj = LifeCycleColorCode__c.getvalues(completed);
    public LifeCycleColorCode__c Upcoming_setting_obj = LifeCycleColorCode__c.getvalues(upcoming);
    public LifeCycleColorCode__c Current_setting_obj = LifeCycleColorCode__c.getvalues(current);

    public RMCustomerLifeCycleController() {

    }

    public String getPreInitialize() {

        //calling payment and customer info web services '1400780'
        //in place of static paremter 
        //pass dynamic crn which is PARAM_CRN before deploy to production
        restAPICalloutPayment_Obj = new RestAPICalloutPayment(PARAM_CRN);
        restAPICalloutController_Obj = new RestAPICalloutController();
        restAPICallout_wrapper_Obj = new RestAPICalloutController.CustomerInformationWrapper();
        restAPICallout_wrapper_Obj = restAPICalloutController_Obj.parseCustomerInformationJSON(PARAM_CRN);

        //calling methods to set customer Life cycle; 
        /*in this method two argument have been passes first is the customer 
        info webservice record and second one is the uniform paymnet list.*/
        createmilestones(restAPICallout_wrapper_Obj, restAPICalloutPayment_Obj.paymentInfoList);

        //set color code to respective milestones 
        setcolortoMilestones();
        // create sublist for collapsable milestone 
        createSublists();

        //add all colors to list from custome setting 
        addcolorstoList();
        return '';
    }

    // method to sort mile stones without dates alphabetically 

    // method to sort mile stones without dates alphabetically 
    public list < MileStoneWrapper > sortmilestonesAlphabetically(list < MileStoneWrapper > unsortedMilestoneList) {
        for (integer i = 0; i < unsortedMilestoneList.size(); i++) {
            for (integer j = 1; j < (unsortedMilestoneList.size() - i); j++) {
                // check titles are not equal 
                if (!(unsortedMilestoneList[j - 1].milestone_title.equalsIgnoreCase(unsortedMilestoneList[j].milestone_title))) {
                    // slipt titles to perform indexwise sorting 
                    List < String > milestoneTitle_List1 = unsortedMilestoneList[j - 1].milestone_title.split(' ');
                    List < String > milestoneTitle_List2 = unsortedMilestoneList[j].milestone_title.split(' ');



                    // for loop till min of size of list
                    for (integer k = 0; k < math.min(milestoneTitle_List1.size(), milestoneTitle_List2.size()); k++) {
                        if (milestoneTitle_List1[k].compareTo(milestoneTitle_List2[k]) != 0) {
                            boolean isnumber1 = milestoneTitle_List1[k].isNumeric();
                            boolean isnumber2 = milestoneTitle_List2[k].isNumeric();
                            if (isnumber1 == true && isnumber2 == true) {
                                if (integer.valueOf(milestoneTitle_List1[k]) > integer.valueOf(milestoneTitle_List2[k])) {
                                    swapMilestone(unsortedMilestoneList[j - 1], unsortedMilestoneList[j]);
                                    break;
                                }
                            } else if (isnumber1 == false && isnumber2 == true) {
                                swapMilestone(unsortedMilestoneList[j - 1], unsortedMilestoneList[j]);
                                break;
                            } else if (isnumber1 == false && isnumber2 == false) {
                                if (milestoneTitle_List1[k].compareTo(milestoneTitle_List2[k]) > 0) {
                                    swapMilestone(unsortedMilestoneList[j - 1], unsortedMilestoneList[j]);
                                    break;
                                }
                            }
                        }
                    }
                }

            }
        }
        return unsortedMilestoneList; // unsorted list ofter sorting 
    }


    public void swapMilestone(MileStoneWrapper milestone1, MileStoneWrapper milestone2) {
        // j-1 is milestone 1
        //j is milestone 2
        MileStoneWrapper tempMilesonesObj = new MileStoneWrapper();
        tempMilesonesObj.milestone_title = milestone1.milestone_title;
        tempMilesonesObj.milestone_date = milestone1.milestone_date;
        tempMilesonesObj.milestone_color = milestone1.milestone_color;
        tempMilesonesObj.hover_data = milestone1.hover_data;
        milestone1.milestone_title = milestone2.milestone_title;
        milestone1.milestone_date = milestone2.milestone_date;
        milestone1.milestone_color = milestone2.milestone_color;
        milestone1.hover_data = milestone2.hover_data;
        milestone2.milestone_title = tempMilesonesObj.milestone_title;
        milestone2.milestone_date = tempMilesonesObj.milestone_date;
        milestone2.milestone_color = tempMilesonesObj.milestone_color;
        milestone2.hover_data = tempMilesonesObj.hover_data;
    }

    // method to sort mile stones with dates 
    public list < MileStoneWrapper > sortmilestones(list < MileStoneWrapper > unsortedMilestoneList) {
        for (integer i = 0; i < unsortedMilestoneList.size(); i++) {
            for (integer j = 1; j < (unsortedMilestoneList.size() - i); j++) {

                if (restAPICalloutPayment_Obj.getdate(unsortedMilestoneList[j - 1].milestone_date).daysBetween(restAPICalloutPayment_Obj.getdate(unsortedMilestoneList[j].milestone_date)) < 0) {
                    MileStoneWrapper tempMilesonesObj = new MileStoneWrapper();
                    tempMilesonesObj.milestone_title = unsortedMilestoneList[j - 1].milestone_title;
                    tempMilesonesObj.milestone_date = unsortedMilestoneList[j - 1].milestone_date;
                    tempMilesonesObj.milestone_color = unsortedMilestoneList[j - 1].milestone_color;
                    tempMilesonesObj.hover_data = unsortedMilestoneList[j - 1].hover_data;
                    unsortedMilestoneList[j - 1].milestone_title = unsortedMilestoneList[j].milestone_title;
                    unsortedMilestoneList[j - 1].milestone_date = unsortedMilestoneList[j].milestone_date;
                    unsortedMilestoneList[j - 1].milestone_color = unsortedMilestoneList[j].milestone_color;
                    unsortedMilestoneList[j - 1].hover_data = unsortedMilestoneList[j].hover_data;
                    unsortedMilestoneList[j].milestone_title = tempMilesonesObj.milestone_title;
                    unsortedMilestoneList[j].milestone_date = tempMilesonesObj.milestone_date;
                    unsortedMilestoneList[j].milestone_color = tempMilesonesObj.milestone_color;
                    unsortedMilestoneList[j].hover_data = tempMilesonesObj.hover_data;
                }

            }

        }
        return unsortedMilestoneList;
    }

    // list which holds all milestones
    // method to culb all mile stones together
    public void createmilestones(RestAPICalloutController.CustomerInformationWrapper restAPICalloutController_Obj,
    List < RestAPICalloutPayment.paymentInfo > paymentInfo_lst) {

        List < MileStoneWrapper > milestoneListWithdate = new List < MileStoneWrapper > ();
        List < MileStoneWrapper > milestoneListWithoutdate = new List < MileStoneWrapper > ();
        finalMilestoneList = new List < MileStoneWrapper > ();

        MileStoneWrapper m_obj;

        //Milestones from web service A (customer info)
        if (!String.isBlank(restAPICalloutController_Obj.welcome_onboard)) {
            m_obj = new MileStoneWrapper();
            m_obj.milestone_title = welcome_Onboard;
            m_obj.milestone_date = restAPICalloutController_Obj.welcome_onboard;
            milestoneListWithdate.add(m_obj);
        }
        if (!String.isBlank(restAPICalloutController_Obj.allotment_letter)) {
            m_obj = new MileStoneWrapper();
            m_obj.milestone_title = allotmentLetterDate;
            m_obj.milestone_date = restAPICalloutController_Obj.allotment_letter;
            milestoneListWithdate.add(m_obj);
        }

        if (!String.isBlank(restAPICalloutController_Obj.registration_challan_date)) {
            m_obj = new MileStoneWrapper();
            m_obj.milestone_title = registrationChallanDate;
            m_obj.milestone_date = restAPICalloutController_Obj.registration_challan_date;
            milestoneListWithdate.add(m_obj);
        }

        if (restAPICalloutController_Obj.registration_date != null 
            && restAPICalloutController_Obj.registration_date != '') {
            m_obj = new MileStoneWrapper();
            m_obj.milestone_title = registrationDate;
            m_obj.milestone_date = restAPICalloutController_Obj.registration_date;
            milestoneListWithdate.add(m_obj);
        }

        if (!String.isBlank(restAPICalloutController_Obj.loan_sanctioned_letter_date)) {
            m_obj = new MileStoneWrapper();
            m_obj.milestone_title = loanSanctionedLetterDate;
            m_obj.milestone_date = restAPICalloutController_Obj.loan_sanctioned_letter_date;
            m_obj.hover_data = 'Funding Status: ' + restAPICalloutController_Obj.funding_status +
                '&#13;Disbursal Amount: ' + restAPICalloutController_Obj.disbursal_amount +
                '&#13;NOC/ROC: ' + restAPICalloutController_Obj.noc_roc_date;
            m_obj.hover_data = m_obj.hover_data.remove('null');
            milestoneListWithdate.add(m_obj);
        }

        if (!String.isBlank(restAPICalloutController_Obj.offer_for_fitout_possession)) {
            m_obj = new MileStoneWrapper();
            m_obj.milestone_title = offerForFitoutPossession;
            m_obj.milestone_date = restAPICalloutController_Obj.offer_for_fitout_possession;
            milestoneListWithdate.add(m_obj);
        }

        if (!String.isBlank(restAPICalloutController_Obj.key_handover_date)) {
            m_obj = new MileStoneWrapper();
            m_obj.milestone_title = keyHandoverDate;
            m_obj.milestone_date = restAPICalloutController_Obj.key_handover_date;
            milestoneListWithdate.add(m_obj);
        }
            
            //dummy data for testing 
           /* m_obj = new MileStoneWrapper();
            m_obj.milestone_title = 'Slab 40';
            m_obj.milestone_date = '28 Jul 2015';
            milestoneListWithdate.add(m_obj);*/

        // list to hold appmoney 1 and 2 or time bound 21 days and 42 days if the come with null bill date
        appMoneyList = new List < MileStoneWrapper > ();

        //Milestones from web service B (Payment info)
        for (RestAPICalloutPayment.paymentInfo paymentInfo_obj: paymentInfo_lst) {
            if (paymentInfo_obj.payment_mileStone != earnestMoney) {

                // identifying app money 1 and app money 2 to select its position 
                if ((paymentInfo_obj.payment_mileStone == applicationMoney1 
                    && (String.isBlank(paymentInfo_obj.bill_date))) 
                    || (paymentInfo_obj.payment_mileStone == applicationMoney2 
                    && (String.isBlank(paymentInfo_obj.bill_date))) 
                    || (paymentInfo_obj.payment_mileStone == timeboundDemand21Days 
                    && (String.isBlank(paymentInfo_obj.bill_date))) 
                    || (paymentInfo_obj.payment_mileStone == timeboundDemand42Days 
                    && (String.isBlank(paymentInfo_obj.bill_date)))) {

                    m_obj = new MileStoneWrapper();
                    m_obj.milestone_title = paymentInfo_obj.payment_mileStone;
                    m_obj.milestone_date = paymentInfo_obj.bill_date;
                    appMoneyList.add(m_obj);
                }
                //if app money 1 and app money 2 bill dates ate available
                else {

                    // if data contains bill date 
                    if (!String.isBlank(paymentInfo_obj.bill_date)) {
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
        for (RestAPICalloutPayment.paymentInfo paymentInfo_obj: paymentInfo_lst) {
            if (paymentInfo_obj.payment_mileStone == earnestMoney) {
                m_obj = new MileStoneWrapper();
                m_obj.milestone_title = paymentInfo_obj.payment_mileStone;
                m_obj.milestone_date = paymentInfo_obj.bill_date;
                if (Completed_setting_obj != null && Completed_setting_obj.ColorCode__c != null) {
                    m_obj.milestone_color = Completed_setting_obj.ColorCode__c;
                }
                finalMilestoneList.add(m_obj);

            }
        }

        //adding all milestones with date to final list
        for (MileStoneWrapper mile_obj: sortmilestones(milestoneListWithdate)) {
            finalMilestoneList.add(mile_obj);
        }
        // adding all milestones without date to final list
        for (MileStoneWrapper mile_obj: sortmilestonesAlphabetically(milestoneListWithoutdate)) {
            finalMilestoneList.add(mile_obj);
        }

        // adding possession date at last position
        m_obj = new MileStoneWrapper();
        m_obj.milestone_title = possessionDate;
        m_obj.milestone_date = restAPICalloutController_Obj.possession_date;
        finalMilestoneList.add(m_obj);
    }

    //method to add colors from custom setting to List
    public void addcolorstoList() {
        colorList = new List < string > ();
        if (Completed_setting_obj != null 
            && Completed_setting_obj.ColorCode__c != null 
            && Current_setting_obj != null 
            && Current_setting_obj.ColorCode__c != null 
            && Upcoming_setting_obj != null 
            && Upcoming_setting_obj.ColorCode__c != null) {

            colorList.add(Completed_setting_obj.ColorCode__c);
            colorList.add(Current_setting_obj.ColorCode__c);
            colorList.add(Upcoming_setting_obj.ColorCode__c);
        }
    }

    // method that sets color code according to multiple conditions 
    public void setcolortoMilestones() {
        //adding app money 1 and 2 in list
        if (appMoneyList.size() != 0) {
            boolean slabfound = false;
            List < MileStoneWrapper > milesonestempList = new List < MileStoneWrapper > ();
            for (MileStoneWrapper f_milestone: finalMilestoneList) {
                if (f_milestone.milestone_title.contains(slab) && slabfound == false) {

                    MileStoneWrapper appm1 = new MileStoneWrapper();
                    MileStoneWrapper appm2 = new MileStoneWrapper();
                    appm1.milestone_title = appMoneyList[0].milestone_title;
                    milesonestempList.add(appm1);
                    appm2.milestone_title = appMoneyList[1].milestone_title;
                    milesonestempList.add(appm2);
                    milesonestempList.add(f_milestone);
                    slabfound = true;
                } else {
                    milesonestempList.add(f_milestone);
                }
            }
            finalMilestoneList.clear();
            for (MileStoneWrapper f_milestone: milesonestempList) {
                finalMilestoneList.add(f_milestone);
            }
        }
        setColorCode();
    }



    // Method thta conatins logic for color code allocation
    public void setColorCode() {
        //flag to identify first greater date not found=true other wise false
        boolean flag = true;
        // iterate over the milestones to set milestone color
        for (integer i = 0; i < finalMilestoneList.size(); i++) {
            if (Current_setting_obj != null && 
                Current_setting_obj.ColorCode__c != null && 
                Upcoming_setting_obj != null && 
                Upcoming_setting_obj.ColorCode__c != null) {

                if (!String.isBlank(finalMilestoneList[i].milestone_date)) {

                    if ((restAPICalloutPayment_Obj.getdate(finalMilestoneList[i].milestone_date) > Date.today() 
                        || restAPICalloutPayment_Obj.getdate(finalMilestoneList[i].milestone_date).daysBetween(Date.today()) == 0) 
                            && flag == true) {

                        if (restAPICalloutPayment_Obj.getdate(finalMilestoneList[i].milestone_date).daysBetween(Date.today()) == 0) {
                            finalMilestoneList[i].milestone_color = Current_setting_obj.ColorCode__c;
                            flag = false;

                        } else {
                            if (i > 0) {
                                finalMilestoneList[i - 1].milestone_color = Current_setting_obj.ColorCode__c;
                                finalMilestoneList[i].milestone_color = Upcoming_setting_obj.ColorCode__c;
                                flag = false;
                            } else {
                                finalMilestoneList[i].milestone_color = Current_setting_obj.ColorCode__c;
                                flag = false;
                            }
                        }
                    } else if ((restAPICalloutPayment_Obj.getdate(finalMilestoneList[i].milestone_date) > Date.today() 
                        || finalMilestoneList[i].milestone_date == null) && flag == false) {
                        finalMilestoneList[i].milestone_color = Upcoming_setting_obj.ColorCode__c;
                    }
                } else {
                    if (finalMilestoneList[i].milestone_title != earnestMoney) {
                        finalMilestoneList[i].milestone_color = Upcoming_setting_obj.ColorCode__c;
                    }
                }
            }
        }


    }
    //method to arrange milestones when forward boundry of greenlist is 3 and green list size is less than 6
    public void forwardBoundryPosition3() {
        finalList[14] = finalMilestoneList[finalMilestoneList.size() - 1];
        finalList[13] = finalMilestoneList[finalMilestoneList.size() - 2];
        finalList[12] = finalMilestoneList[finalMilestoneList.size() - 3];
        finalList[5] = finalMilestoneList[mid - 2];
        finalList[6] = finalMilestoneList[mid - 1];
        finalList[7] = finalMilestoneList[mid];
        finalList[8] = finalMilestoneList[mid + 1];
        finalList[9] = finalMilestoneList[mid + 2];
        finalList[10] = finalMilestoneList[mid + 3];

        finalList[4] = new MileStoneWrapper();
       
        finalList[4].milestone_title = finalMilestoneList[4].milestone_title + ' to <p>' + 
            finalMilestoneList[mid - 3].milestone_title + '</p>';
        finalList[4].milestone_date = ' ';
        finalList[4].MileStoneSublist = new list < MileStoneSublistWrapper > ();
        for (integer i = 4; i < mid - 2; i++) {
            MileStoneSublistWrapper subList1 = new MileStoneSublistWrapper();
            subList1.milestone_title = finalMilestoneList[i].milestone_title;
            subList1.milestone_date = finalMilestoneList[i].milestone_date;
            subList1.milestone_color = finalMilestoneList[i].milestone_color;
            subList1.hover_data = finalMilestoneList[i].hover_data;
            finalList[4].MileStoneSublist.add(subList1);
        }
        finalList[11] = new MileStoneWrapper();
        finalList[11].milestone_title = finalMilestoneList[mid + 4].milestone_title + ' to <p>' + 
            finalMilestoneList[finalMilestoneList.size() - 4].milestone_title + '</p>';
        finalList[11].milestone_date = ' ';
        finalList[11].MileStoneSublist = new list < MileStoneSublistWrapper > ();
        for (integer i = mid + 4; i < finalMilestoneList.size() - 3; i++) {
            MileStoneSublistWrapper subList1 = new MileStoneSublistWrapper();
            subList1.milestone_title = finalMilestoneList[i].milestone_title;
            subList1.milestone_date = finalMilestoneList[i].milestone_date;
            subList1.milestone_color = finalMilestoneList[i].milestone_color;
            subList1.hover_data = finalMilestoneList[i].hover_data;
            finalList[11].MileStoneSublist.add(subList1);
        }

    }

    //method to arrange milestones when forward boundry of greenlist is 4 and green list size is less than 6
    public void forwardBoundryPosition4() {
        finalList[14] = finalMilestoneList[finalMilestoneList.size() - 1];
        finalList[13] = finalMilestoneList[finalMilestoneList.size() - 2];
        finalList[12] = finalMilestoneList[finalMilestoneList.size() - 3];
        finalList[6] = finalMilestoneList[mid - 1];
        finalList[7] = finalMilestoneList[mid];
        finalList[8] = finalMilestoneList[mid + 1];
        finalList[9] = finalMilestoneList[mid + 2];
        finalList[10] = finalMilestoneList[mid + 3];

        finalList[5] = new MileStoneWrapper();
        finalList[5].milestone_title = finalMilestoneList[mid + 4].milestone_title + ' to <p>' + 
            finalMilestoneList[mid - 4].milestone_title + '</p>';
        finalList[5].milestone_date = ' ';
        finalList[5].MileStoneSublist = new list < MileStoneSublistWrapper > ();
        for (integer i = 5; i < mid - 1; i++) {
            MileStoneSublistWrapper subList1 = new MileStoneSublistWrapper();
            subList1.milestone_title = finalMilestoneList[i].milestone_title;
            subList1.milestone_date = finalMilestoneList[i].milestone_date;
            subList1.milestone_color = finalMilestoneList[i].milestone_color;
            subList1.hover_data = finalMilestoneList[i].hover_data;
            finalList[5].MileStoneSublist.add(subList1);
        }
        finalList[11] = new MileStoneWrapper();
        finalList[11].milestone_title = finalMilestoneList[mid + 4].milestone_title + ' to <p>' + 
            finalMilestoneList[finalMilestoneList.size() - 4].milestone_title + '</p>';
        finalList[11].milestone_date = ' ';
        finalList[11].MileStoneSublist = new list < MileStoneSublistWrapper > ();
        for (integer i = mid + 4; i < finalMilestoneList.size() - 3; i++) {
            MileStoneSublistWrapper subList1 = new MileStoneSublistWrapper();
            subList1.milestone_title = finalMilestoneList[i].milestone_title;
            subList1.milestone_date = finalMilestoneList[i].milestone_date;
            subList1.milestone_color = finalMilestoneList[i].milestone_color;
            subList1.hover_data = finalMilestoneList[i].hover_data;
            finalList[11].MileStoneSublist.add(subList1);
        }

    }

    //method to arrange milestones when forward boundry of greenlist is 5 and green list size is less than 6
    public void forwardBoundryPosition5() {

        finalList[14] = finalMilestoneList[finalMilestoneList.size() - 1];
        finalList[13] = finalMilestoneList[finalMilestoneList.size() - 2];
        finalList[12] = finalMilestoneList[finalMilestoneList.size() - 3];
        finalList[7] = finalMilestoneList[mid];
        finalList[8] = finalMilestoneList[mid + 1];
        finalList[9] = finalMilestoneList[mid + 2];
        finalList[10] = finalMilestoneList[mid + 3];
        finalList[6] = new MileStoneWrapper();
        finalList[6].milestone_title = finalMilestoneList[6].milestone_title + ' to <p>' + 
            finalMilestoneList[mid - 3].milestone_title + '</p>';
        finalList[6].milestone_date = ' ';
        finalList[6].MileStoneSublist = new list < MileStoneSublistWrapper > ();
        for (integer i = 6; i < mid; i++) {
            MileStoneSublistWrapper subList1 = new MileStoneSublistWrapper();
            subList1.milestone_title = finalMilestoneList[i].milestone_title;
            subList1.milestone_date = finalMilestoneList[i].milestone_date;
            subList1.milestone_color = finalMilestoneList[i].milestone_color;
            subList1.hover_data = finalMilestoneList[i].hover_data;
            finalList[6].MileStoneSublist.add(subList1);
        }
        finalList[11] = new MileStoneWrapper();
        finalList[11].milestone_title = finalMilestoneList[mid + 4].milestone_title + ' to <p>' + 
            finalMilestoneList[finalMilestoneList.size() - 4].milestone_title + '</p>';
        finalList[11].milestone_date = ' ';
        finalList[11].MileStoneSublist = new list < MileStoneSublistWrapper > ();
        for (integer i = mid + 4; i < finalMilestoneList.size() - 3; i++) {
            MileStoneSublistWrapper subList1 = new MileStoneSublistWrapper();
            subList1.milestone_title = finalMilestoneList[i].milestone_title;
            subList1.milestone_date = finalMilestoneList[i].milestone_date;
            subList1.milestone_color = finalMilestoneList[i].milestone_color;
            subList1.hover_data = finalMilestoneList[i].hover_data;
            finalList[11].MileStoneSublist.add(subList1);
        }
    }

    //method to arrange milestones when backward boundry of greenlist is last 4th and green list size is less than 6
    public void backwardBoundryPositionLast4() {
        finalList[0] = finalMilestoneList[0];
        finalList[1] = finalMilestoneList[1];
        finalList[2] = finalMilestoneList[2];
        finalList[7] = finalMilestoneList[mid];
        finalList[6] = finalMilestoneList[mid - 1];
        finalList[5] = finalMilestoneList[mid - 2];
        finalList[4] = finalMilestoneList[mid - 3];
        finalList[8] = finalMilestoneList[mid + 1];
        finalList[9] = finalMilestoneList[mid + 2];
        finalList[3] = new MileStoneWrapper();
        finalList[3].milestone_title = finalMilestoneList[3].milestone_title + ' to <p>' + 
            finalMilestoneList[mid - 4].milestone_title + '</p>';
        finalList[3].milestone_date = ' ';
        finalList[3].MileStoneSublist = new list < MileStoneSublistWrapper > ();
        for (integer i = 3; i < mid - 3; i++) {
            MileStoneSublistWrapper subList1 = new MileStoneSublistWrapper();
            subList1.milestone_title = finalMilestoneList[i].milestone_title;
            subList1.milestone_date = finalMilestoneList[i].milestone_date;
            subList1.milestone_color = finalMilestoneList[i].milestone_color;
            subList1.hover_data = finalMilestoneList[i].hover_data;
            finalList[3].MileStoneSublist.add(subList1);
        }
        finalList[10] = new MileStoneWrapper();
        finalList[10].milestone_title = finalMilestoneList[mid + 3].milestone_title + ' to <p>' + 
            finalMilestoneList[finalMilestoneList.size() - 5].milestone_title + '</p>';
        finalList[10].milestone_date = ' ';
        finalList[10].MileStoneSublist = new list < MileStoneSublistWrapper > ();
        for (integer i = mid + 3; i < finalMilestoneList.size() - 4; i++) {
            MileStoneSublistWrapper subList1 = new MileStoneSublistWrapper();
            subList1.milestone_title = finalMilestoneList[i].milestone_title;
            subList1.milestone_date = finalMilestoneList[i].milestone_date;
            subList1.milestone_color = finalMilestoneList[i].milestone_color;
            subList1.hover_data = finalMilestoneList[i].hover_data;
            finalList[10].MileStoneSublist.add(subList1);
        }

    }

    //method to arrange milestones when backward boundry of greenlist is last 5th and green list size is less than 6
    public void backwardBoundryPositionLast5() {
        finalList[0] = finalMilestoneList[0];
        finalList[1] = finalMilestoneList[1];
        finalList[2] = finalMilestoneList[2];
        finalList[7] = finalMilestoneList[mid];
        finalList[6] = finalMilestoneList[mid - 1];
        finalList[5] = finalMilestoneList[mid - 2];
        finalList[4] = finalMilestoneList[mid - 3];
        finalList[8] = finalMilestoneList[mid + 1];
        finalList[3] = new MileStoneWrapper();
        finalList[3].milestone_title = finalMilestoneList[3].milestone_title + ' to <p>' +
            finalMilestoneList[mid - 4].milestone_title + '</p>';
        finalList[3].milestone_date = ' ';
        finalList[3].MileStoneSublist = new list < MileStoneSublistWrapper > ();
        for (integer i = 3; i < mid - 3; i++) {
            MileStoneSublistWrapper subList1 = new MileStoneSublistWrapper();
            subList1.milestone_title = finalMilestoneList[i].milestone_title;
            subList1.milestone_date = finalMilestoneList[i].milestone_date;
            subList1.milestone_color = finalMilestoneList[i].milestone_color;
            subList1.hover_data = finalMilestoneList[i].hover_data;
            finalList[3].MileStoneSublist.add(subList1);
        }
        finalList[9] = new MileStoneWrapper();
        finalList[9].milestone_title = finalMilestoneList[mid + 2].milestone_title + ' to <p>' + 
            finalMilestoneList[finalMilestoneList.size() - 6].milestone_title + '</p>';
        finalList[9].milestone_date = ' ';
        finalList[9].MileStoneSublist = new list < MileStoneSublistWrapper > ();
        for (integer i = mid + 2; i < finalMilestoneList.size() - 5; i++) {
            MileStoneSublistWrapper subList1 = new MileStoneSublistWrapper();
            subList1.milestone_title = finalMilestoneList[i].milestone_title;
            subList1.milestone_date = finalMilestoneList[i].milestone_date;
            subList1.milestone_color = finalMilestoneList[i].milestone_color;
            subList1.hover_data = finalMilestoneList[i].hover_data;
            finalList[9].MileStoneSublist.add(subList1);
        }
    }
    //method to arrange milestones when backward boundry of greenlist is last 6th and green list size is less than 6
    public void backwardBoundryPositionLast6() {
        finalList[0] = finalMilestoneList[0];
        finalList[1] = finalMilestoneList[1];
        finalList[2] = finalMilestoneList[2];
        finalList[7] = finalMilestoneList[mid];
        finalList[6] = finalMilestoneList[mid - 1];
        finalList[5] = finalMilestoneList[mid - 2];
        finalList[4] = finalMilestoneList[mid - 3];
        finalList[3] = new MileStoneWrapper();
        finalList[3].milestone_title = finalMilestoneList[3].milestone_title + ' to <p>' + 
            finalMilestoneList[mid - 4].milestone_title + '</p>';
        finalList[3].milestone_date = ' ';
        finalList[3].MileStoneSublist = new list < MileStoneSublistWrapper > ();
        for (integer i = 3; i < mid - 3; i++) {
            MileStoneSublistWrapper subList1 = new MileStoneSublistWrapper();
            subList1.milestone_title = finalMilestoneList[i].milestone_title;
            subList1.milestone_date = finalMilestoneList[i].milestone_date;
            subList1.milestone_color = finalMilestoneList[i].milestone_color;
            subList1.hover_data = finalMilestoneList[i].hover_data;
            finalList[3].MileStoneSublist.add(subList1);
        }
        finalList[8] = new MileStoneWrapper();
        finalList[8].milestone_title = finalMilestoneList[mid + 1].milestone_title + ' to <p>' + 
            finalMilestoneList[finalMilestoneList.size() - 7].milestone_title + '</p>';
        finalList[8].milestone_date = ' ';
        finalList[8].MileStoneSublist = new list < MileStoneSublistWrapper > ();
        for (integer i = mid + 1; i < finalMilestoneList.size() - 6; i++) {
            MileStoneSublistWrapper subList1 = new MileStoneSublistWrapper();
            subList1.milestone_title = finalMilestoneList[i].milestone_title;
            subList1.milestone_date = finalMilestoneList[i].milestone_date;
            subList1.milestone_color = finalMilestoneList[i].milestone_color;
            subList1.hover_data = finalMilestoneList[i].hover_data;
            finalList[8].MileStoneSublist.add(subList1);
        }
    }
     //method to arrange milestones when backward boundry of greenlist is 0 and green list size is greater than 6
    public void backwardBoundryPosition0() {
        finalList[14] = finalMilestoneList[finalMilestoneList.size() - 1];
        finalList[13] = finalMilestoneList[finalMilestoneList.size() - 2];
        finalList[12] = finalMilestoneList[finalMilestoneList.size() - 3];
        finalList[10] = finalMilestoneList[mid + 2];
        finalList[9] = finalMilestoneList[mid + 1];
        finalList[8] = finalMilestoneList[mid];
        finalList[7] = new MileStoneWrapper();
        finalList[7].milestone_title = finalMilestoneList[mid + 3].milestone_title + ' to <p>' + 
            finalMilestoneList[mid + 1].milestone_title + '</p>';
        finalList[7].milestone_date = ' ';
        finalList[7].MileStoneSublist = new list < MileStoneSublistWrapper > ();
        for (integer i = 7; i < mid; i++) {
            MileStoneSublistWrapper subList1 = new MileStoneSublistWrapper();
            subList1.milestone_title = finalMilestoneList[i].milestone_title;
            subList1.milestone_date = finalMilestoneList[i].milestone_date;
            subList1.milestone_color = finalMilestoneList[i].milestone_color;
            subList1.hover_data = finalMilestoneList[i].hover_data;
            finalList[7].MileStoneSublist.add(subList1);
        }

        finalList[11] = new MileStoneWrapper();
        finalList[11].milestone_title = finalMilestoneList[mid + 3].milestone_title + ' to <p>' + 
            finalMilestoneList[finalMilestoneList.size() - 4].milestone_title + '</p>';
        finalList[11].milestone_date = ' ';
        finalList[11].MileStoneSublist = new list < MileStoneSublistWrapper > ();
        for (integer i = mid + 3; i < finalMilestoneList.size() - 3; i++) {
            MileStoneSublistWrapper subList1 = new MileStoneSublistWrapper();
            subList1.milestone_title = finalMilestoneList[i].milestone_title;
            subList1.milestone_date = finalMilestoneList[i].milestone_date;
            subList1.milestone_color = finalMilestoneList[i].milestone_color;
            subList1.hover_data = finalMilestoneList[i].hover_data;
            finalList[11].MileStoneSublist.add(subList1);
        }
    }
    
    //method to arrange milestones when backward boundry of greenlist is greater than 3 and green list size is greater than 6
    public void backwardBoundryPositionGreaterThan3(integer fb) {
        for (integer i = finalList.size(); i < 11; i++) {
            finalList[i] = finalMilestoneList[fb];
            fb = fb + 1;
        }
        finalList[11] = new MileStoneWrapper();
        finalList[11].milestone_title = finalMilestoneList[fb].milestone_title + ' to <p>' + 
            finalMilestoneList[finalMilestoneList.size() - 4].milestone_title + '</p>';
        finalList[11].milestone_date = ' ';
        finalList[11].MileStoneSublist = new list < MileStoneSublistWrapper > ();
        for (integer i = fb; i < finalMilestoneList.size() - 3; i++) {
            MileStoneSublistWrapper subList1 = new MileStoneSublistWrapper();
            subList1.milestone_title = finalMilestoneList[i].milestone_title;
            subList1.milestone_date = finalMilestoneList[i].milestone_date;
            subList1.milestone_color = finalMilestoneList[i].milestone_color;
            subList1.hover_data = finalMilestoneList[i].hover_data;
            finalList[11].MileStoneSublist.add(subList1);
        }
        finalList[14] = finalMilestoneList[finalMilestoneList.size() - 1];
        finalList[13] = finalMilestoneList[finalMilestoneList.size() - 2];
        finalList[12] = finalMilestoneList[finalMilestoneList.size() - 3];
    }

    //method to arrange milestones when forward boundry of greenlist is last and green list size is greater than 6
    public void forwardBoundryPositionLast(integer backwardBoundry) {
        finalList[3] = new MileStoneWrapper();
        finalList[3].milestone_title = finalMilestoneList[3].milestone_title + ' to <p>' + 
            finalMilestoneList[backwardBoundry - 5].milestone_title + '</p>';
        finalList[3].milestone_date = ' ';
        finalList[3].MileStoneSublist = new list < MileStoneSublistWrapper > ();
        for (integer i = 3; i < backwardBoundry - 4; i++) {
            MileStoneSublistWrapper subList1 = new MileStoneSublistWrapper();
            subList1.milestone_title = finalMilestoneList[i].milestone_title;
            subList1.milestone_date = finalMilestoneList[i].milestone_date;
            subList1.milestone_color = finalMilestoneList[i].milestone_color;
            subList1.hover_data = finalMilestoneList[i].hover_data;
            finalList[3].MileStoneSublist.add(subList1);
        }
        finalList[4] = finalMilestoneList[backwardBoundry - 4];
        finalList[5] = finalMilestoneList[backwardBoundry - 3];
        finalList[6] = finalMilestoneList[backwardBoundry - 2];
        finalList[7] = finalMilestoneList[backwardBoundry - 1];
    }

    //method to arrange milestones when forward boundry of greenlist not present
    public void greenIndexNotPresent() {
        // set milestone to desired locations 
        finalList[0] = finalMilestoneList[0];
        finalList[1] = finalMilestoneList[1];
        finalList[2] = finalMilestoneList[2];
        finalList[14] = finalMilestoneList[finalMilestoneList.size() - 1];
        finalList[13] = finalMilestoneList[finalMilestoneList.size() - 2];
        finalList[12] = finalMilestoneList[finalMilestoneList.size() - 3];
        finalList[7] = finalMilestoneList[mid];
        finalList[8] = finalMilestoneList[mid + 1];
        finalList[9] = finalMilestoneList[mid + 2];
        finalList[10] = finalMilestoneList[mid + 3];
        finalList[6] = finalMilestoneList[mid - 1];
        finalList[5] = finalMilestoneList[mid - 2];
        finalList[4] = finalMilestoneList[mid - 3];
        //finalList[3] = finalMilestoneList[3];
        finalList[3] = new MileStoneWrapper(); 
        finalList[3].milestone_title = finalMilestoneList[3].milestone_title + ' to <p>' + 
            finalMilestoneList[mid - 4].milestone_title + '</p>';
        finalList[3].milestone_date = ' ';
        finalList[3].MileStoneSublist = new list < MileStoneSublistWrapper > ();
        for (integer i = 3; i < mid - 3; i++) {
            MileStoneSublistWrapper subList1 = new MileStoneSublistWrapper();
            subList1.milestone_title = finalMilestoneList[i].milestone_title;
            subList1.milestone_date = finalMilestoneList[i].milestone_date;
            subList1.milestone_color = finalMilestoneList[i].milestone_color;
            subList1.hover_data = finalMilestoneList[i].hover_data;
            finalList[3].MileStoneSublist.add(subList1);
        }

        //finalList[11] = finalMilestoneList[mid + 4];
        finalList[11] = new MileStoneWrapper();
        finalList[11].milestone_title = finalMilestoneList[mid + 4].milestone_title + ' to <p>' + 
            finalMilestoneList[finalMilestoneList.size() - 4].milestone_title + '</p>';
        finalList[11].milestone_date = '';
        finalList[11].MileStoneSublist = new list < MileStoneSublistWrapper > ();
        for (integer i = mid + 4; i < finalMilestoneList.size() - 3; i++) {
            MileStoneSublistWrapper subList1 = new MileStoneSublistWrapper();
            subList1.milestone_title = finalMilestoneList[i].milestone_title;
            subList1.milestone_date = finalMilestoneList[i].milestone_date;
            subList1.milestone_color = finalMilestoneList[i].milestone_color;
            subList1.hover_data = finalMilestoneList[i].hover_data;
            finalList[11].MileStoneSublist.add(subList1);
        }
    }

    public void createSublists() {
        finalList = new MileStoneWrapper[15];
        mid = (finalMilestoneList.size() - 1) / 2;

        // if no of milestone are greater than 15 
        if (finalMilestoneList.size() > 15) {

            // stores index of green milestones 
            integer greenindex;

            // shows whether green milestone is present or not 
            boolean greenfound = false;

            // search for green miloestone
            for (integer i = 0; i < finalMilestoneList.size(); i++) {
                if (Current_setting_obj != null && Current_setting_obj.ColorCode__c != null) {
                    if (finalMilestoneList[i].milestone_color.equalsIgnoreCase(Current_setting_obj.ColorCode__c)) {
                        greenindex = i;
                        greenfound = true;
                    }
                }
            }
            // if green milestone is present 
            if (greenfound) {

                List < MileStoneWrapper > forwardList = new List < MileStoneWrapper > ();
                List < MileStoneWrapper > backwardList = new List < MileStoneWrapper > ();
                List < MileStoneWrapper > forward_backwardList = new List < MileStoneWrapper > ();

                // add backward milestones of greenindex
                integer backwardBoundry;
                for (integer gi = greenindex; gi >= 0 && gi >= greenindex - 3; gi--) {
                    backwardList.add(finalMilestoneList[gi]);
                    backwardBoundry = gi;
                }

                // add forward milestones of greenindex
                integer forwardboundry = greenindex;
                for (integer gi = greenindex + 1; gi <= finalMilestoneList.size() - 1 && gi <= greenindex + 3; gi++) {
                    forwardList.add(finalMilestoneList[gi]);
                    forwardboundry = gi;
                }

                //stores size of greenList
                integer greenlistsize = forwardList.size() + backwardList.size();

                // List that holds list of milestone with green color 
                List < MileStoneWrapper > greenlist = new List < MileStoneWrapper > ();

                // combine forward and backward milestone 
                // add backward elements
                for (integer i = backwardList.size() - 1; i >= 0; i--) {
                    greenlist.add(backwardList[i]);
                }
                // add forward elements
                for (integer i = 0; i < forwardList.size(); i++) {
                    greenlist.add(forwardList[i]);
                }

                //if greenlist sets at start or end 
                if (greenlistsize <= 6) {
                    //if greenlist sets at start 
                    if (backwardBoundry == 0) {
                        for (MileStoneWrapper greenListobj: greenlist) {
                            finalList.add(greenListobj);
                        }
                        if (forwardboundry == 3) {
                            forwardBoundryPosition3();
                        }
                        if (forwardboundry == 4) {
                            forwardBoundryPosition4();
                        }
                        if (forwardboundry == 5) {
                            forwardBoundryPosition5();
                        }
                    }

                    // if greenList sets at end 
                    if (forwardboundry == finalMilestoneList.size() - 1) {
                        integer x = 14;
                        for (integer i = finalMilestoneList.size() - 1; i > ((finalMilestoneList.size() - 1) - greenlistsize); i--) {
                            finalList[x] = finalMilestoneList[i];
                            x = x - 1;
                        }
                        if (backwardBoundry == finalMilestoneList.size() - 4) {
                            backwardBoundryPositionLast4();
                        }

                        if (backwardBoundry == finalMilestoneList.size() - 5) {
                            backwardBoundryPositionLast5();
                        }


                        if (backwardBoundry == finalMilestoneList.size() - 6) {
                            backwardBoundryPositionLast6();
                        }
                    }
                }


                // if greenList  size is equal to 7   
                else if (greenlistsize == 7) {
                    //if backwardBoundry is at zero
                    if (backwardBoundry == 0) {
                        for (MileStoneWrapper greenListobj: greenlist) {
                            finalList.add(greenListobj);
                        }
                        backwardBoundryPosition0();
                    }

                    // if backwardBoundry is graeter than zero 
                    if (backwardBoundry > 0) {
                        if (backwardBoundry < 3) {

                            for (integer i = 0; i < backwardBoundry; i++) {
                                finalList[i] = finalMilestoneList[i];
                            }
                            for (MileStoneWrapper greenListobj: greenlist) {
                                finalList.add(greenListobj);
                            }
                            /*by sudeep: add after the green list last index to 10th elment element 
                            of final list not assigned yet, so add the element forward+1 to last 
                            finallist index to y=the 10th element location of  final list  */
                            integer fb = forwardboundry + 1;
                            backwardBoundryPositionGreaterThan3(fb);
                        }

                    }

                    // if forwardboundry is last
                    if (forwardboundry == finalMilestoneList.size() - 1) {

                        for (integer i = 0; i < 3; i++) {
                            finalList[i] = finalMilestoneList[i];
                            //finalList.add(finalMilestoneList[i]);
                        }
                        integer y = 14;
                        for (integer i = greenlist.size() - 1; i >= 0; i--) {
                            finalList[y] = greenlist[i];
                            y = y - 1;
                        }
                        forwardBoundryPositionLast(backwardBoundry);
                    }

                    //forward boundary is not last means list contains element after the greenlist in right side
                    if (forwardboundry < finalMilestoneList.size() - 1) {

                        //add first three element as it is         3    
                        for (integer i = 0; i < 3; i++) {
                            finalList[i] = finalMilestoneList[i];
                            //finalList.add(finalMilestoneList[i]);
                        }

                        //add before the the green list element using backword boundary start from 4th(index 3) element to backward-10     
                        finalList[3] = new MileStoneWrapper();
                        finalList[3].milestone_title = finalMilestoneList[3].milestone_title + ' to <p>' + finalMilestoneList[backwardBoundry + 1].milestone_title + '</p>';
                        finalList[3].milestone_date = ' ';
                        finalList[3].MileStoneSublist = new list < MileStoneSublistWrapper > ();

                        for (integer i = 3; i < backwardBoundry; i++) {
                            MileStoneSublistWrapper subList1 = new MileStoneSublistWrapper();
                            subList1.milestone_title = finalMilestoneList[i].milestone_title;
                            subList1.milestone_date = finalMilestoneList[i].milestone_date;
                            subList1.milestone_color = finalMilestoneList[i].milestone_color;
                            subList1.hover_data = finalMilestoneList[i].hover_data;
                            finalList[3].MileStoneSublist.add(subList1);
                        }
                        //add green list    7
                        for (integer i = 0; i < greenList.size(); i++) {
                            finalList.add(finalMilestoneList[i]);
                        }
                        integer element_diff = finalMilestoneList.size() - (forwardboundry + 1);
                        if (element_diff > 4) {
                            finalList[11] = new MileStoneWrapper();
                            finalList[11].milestone_title = finalMilestoneList[forwardboundry + 1].milestone_title + ' to <p>' + finalMilestoneList[finalMilestoneList.size() - 4].milestone_title + '</p>';
                            finalList[11].milestone_date = ' ';
                            finalList[11].MileStoneSublist = new list < MileStoneSublistWrapper > ();
                            for (integer i = forwardboundry + 1; i < finalMilestoneList.size() - 3; i++) {
                                MileStoneSublistWrapper subList1 = new MileStoneSublistWrapper();
                                subList1.milestone_title = finalMilestoneList[i].milestone_title;
                                subList1.milestone_date = finalMilestoneList[i].milestone_date;
                                subList1.milestone_color = finalMilestoneList[i].milestone_color;
                                subList1.hover_data = finalMilestoneList[i].hover_data;
                                finalList[11].MileStoneSublist.add(subList1);
                            }
                            finalList[14] = finalMilestoneList[finalMilestoneList.size() - 1];
                            finalList[13] = finalMilestoneList[finalMilestoneList.size() - 2];
                            finalList[12] = finalMilestoneList[finalMilestoneList.size() - 3];
                        } else {

                            for (integer i = forwardboundry + 1; i < finalMilestoneList.size(); i++) {
                                finalList.add(finalMilestoneList[i]);
                            }
                        }
                    }
                }
            }

            // if green not found
            else {
                greenIndexNotPresent();
            }
        } else {
            for (MileStoneWrapper m_obj: finalMilestoneList) {
                finalList.add(m_obj);
            }
        }
    }


    //wrapper class which clubs milestone data
    public class MileStoneWrapper {

        public string milestone_title {get;set;} //stores title of milestone
        public string milestone_date {get;set;} //stores date of milestone
        public string milestone_color {get;set;} //stores color of milestone
        public string hover_data {get;set;} //stores hover data of milestone
        public List < MileStoneSublistWrapper > MileStoneSublist {get;set;} // list of sublist of a mile stone  

        // default constructor of milestone
        public MileStoneWrapper() {
            if (LifeCycleColorCode__c.getvalues(completed) != null && LifeCycleColorCode__c.getvalues(completed).ColorCode__c != null) {

                // default color for all milestone
                milestone_color = LifeCycleColorCode__c.getvalues(completed).ColorCode__c;
            }
        }
    }

    // milestone formate wrapper class 
    public class MileStoneSublistWrapper {

        public string milestone_title {get;set;} //stores title of milestone
        public string milestone_date {get;set;} //stores date of milestone
        public string milestone_color {get;set;} //stores color of milestone
        public string hover_data {get;set;} //stores hover data of milestone

        // default constructor of milestone
        public MileStoneSublistWrapper() {

            if (LifeCycleColorCode__c.getvalues(completed) != null && LifeCycleColorCode__c.getvalues(completed).ColorCode__c != null) {
                milestone_color = LifeCycleColorCode__c.getvalues(completed).ColorCode__c; // default color for all milestone
            }

        }


    }

}