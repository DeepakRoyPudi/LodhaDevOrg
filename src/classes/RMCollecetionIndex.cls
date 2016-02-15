/* 
Description : Controller class for calculating collection index 
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

public class RMCollecetionIndex {

    public RestAPICalloutPayment RestAPICalloutPayment_obj; // fetch payments web service 
    public RestAPICalloutMygain RestAPICalloutMygain_obj; // fetch mygain web service
    decimal x_index; // holds x index
    decimal xavg; // hold x average 
    decimal y_index; // holds y index
    decimal yavg; // hold y average
    decimal z_index; // holds z index
    decimal ztotal; // holds z average
   
    // spot index to be displayed on page 
    public decimal spot_index { get;set;}
    // LifecycleIndex to be displayed on page
    public decimal LifecycleIndex { get;set;}

    public RMCollecetionIndex(String CRN) {
        spot_index = 0;
        LifecycleIndex = 0;
        // payments web service object initialisation 
        RestAPICalloutPayment_obj = new RestAPICalloutPayment(CRN);
        // different methods to cal calculate x index, y index, and z index
        calculate_x_index();
        calculate_xavg();
        calculate_y_index();
        calculate_yavg();
        RestAPICalloutMygain_obj = new RestAPICalloutMygain(CRN);
        calculate_z_index(CRN);
        calculate_CI();
    }
    
    // method to calculate x index 
    public void calculate_x_index() {
       
        decimal PaymentReceived_noofdays = 0;
        x_index = 0;
       
        for (RestAPICalloutPayment.PaymentReceived payment_obj: RestAPICalloutPayment_obj.PaymentReceivedList) {
            if ((String.isNotBlank(payment_obj.received_date)) && (String.isNotBlank(payment_obj.due_date))) {
                if (payment_obj.payment_mileStone.contains('Slab') && 
                    RestAPICalloutPayment_obj.getdate(payment_obj.bill_date).daysbetween(Date.today()) <= 90) {
                    PaymentReceived_noofdays += 
                    RestAPICalloutPayment_obj.getdate(payment_obj.due_date).daysBetween(RestAPICalloutPayment_obj.getdate(payment_obj.received_date));
               
                }
            }
        }
        decimal demanded_noofdays = 0;
     
        for (RestAPICalloutPayment.paymentInfo payment_obj: RestAPICalloutPayment_obj.paymentInfoList) {
            if (payment_obj.payment_mileStone.contains('Slab') && String.isNotBlank(payment_obj.bill_date)) {
                if (RestAPICalloutPayment_obj.getdate(payment_obj.bill_date).daysbetween(Date.today()) <= 90) {
                    demanded_noofdays = demanded_noofdays + 1;
                }
            }
        }
        if (demanded_noofdays > 0) {
            x_index = PaymentReceived_noofdays / demanded_noofdays;
        } 
    }


    // method to calculate x average  
    public void calculate_xavg() {
        xavg = 0;
        decimal PaymentReceived_noofdays = 0;
        for (RestAPICalloutPayment.PaymentReceived payment_obj: RestAPICalloutPayment_obj.PaymentReceivedList) {
            if (payment_obj.payment_mileStone.contains('Slab')) {
                if (String.isNotBlank(payment_obj.received_date) && String.isNotBlank(payment_obj.due_date)) {
                    PaymentReceived_noofdays += 
                        RestAPICalloutPayment_obj.getdate(payment_obj.due_date).daysBetween(RestAPICalloutPayment_obj.getdate(payment_obj.received_date));
                }
            }
        }
        decimal demanded_noofdays = 0;
        for (RestAPICalloutPayment.paymentInfo payment_obj: RestAPICalloutPayment_obj.paymentInfoList) {
            if (payment_obj.payment_mileStone.contains('Slab') && 
                String.isNotBlank(payment_obj.bill_date)) {
                demanded_noofdays = demanded_noofdays + 1;
            }
        }
        if (demanded_noofdays > 0) {
            xavg = PaymentReceived_noofdays / demanded_noofdays;
        } 
    }

    // method to calculate y index 
    public void calculate_y_index() {

        decimal payments_last90days = 0;
        y_index = 0;

        for (RestAPICalloutPayment.PaymentReceived payment_obj: RestAPICalloutPayment_obj.PaymentReceivedList) {
            if (String.isNotBlank(payment_obj.received_date) && String.isNotBlank(payment_obj.payments_received)) {
                if (RestAPICalloutPayment_obj.getdate(payment_obj.received_date).daysbetween(Date.today()) < 90) {
                    payments_last90days += decimal.valueOf(payment_obj.payments_received);
                }
            }
        }
        for (RestAPICalloutPayment.PaymentReceived payment_obj: RestAPICalloutPayment_obj.PaymentReceivedList) {
            if ((String.isNotBlank(payment_obj.received_date)) && (String.isNotBlank(payment_obj.due_date))&& 
                (String.isNotBlank( payment_obj.principal_outstanding)) && (String.isNotBlank(payment_obj.payments_received))) {
                if (RestAPICalloutPayment_obj.getdate(payment_obj.due_date) > Date.today() - 90) {

                    y_index = ((decimal.valueOf(payment_obj.payments_received) * 
                        (RestAPICalloutPayment_obj.getdate(payment_obj.received_date).daysbetween(RestAPICalloutPayment_obj.getdate(payment_obj.due_date)))) * 
                            0.18 / 365) - payments_last90days;
                    if (RestAPICalloutPayment_obj.getdate(payment_obj.due_date).daysbetween(Date.today()) > 90) {
                        y_index = y_index + ((decimal.valueOf(payment_obj.principal_outstanding) * 
                            RestAPICalloutPayment_obj.getdate(payment_obj.due_date).daysbetween(Date.today())) * 
                                0.18) / 365;
                    } else {
                        y_index = y_index + ((decimal.valueOf(payment_obj.principal_outstanding) * 
                            90) * 0.18) / 365;
                    }
                } else {
                    y_index = ((decimal.valueOf(payment_obj.payments_received) * 
                        (RestAPICalloutPayment_obj.getdate(payment_obj.received_date).daysbetween(Date.today() - 90))) * 
                            0.18 / 365) - payments_last90days;
                    if (RestAPICalloutPayment_obj.getdate(payment_obj.due_date).daysbetween(Date.today()) > 90) {
                        y_index = y_index + ((decimal.valueOf(payment_obj.principal_outstanding) * 
                            RestAPICalloutPayment_obj.getdate(payment_obj.due_date).daysbetween(Date.today())) * 0.18) / 365;
                    } else {
                        y_index = y_index + ((decimal.valueOf(payment_obj.principal_outstanding) * 90) * 0.18) / 365;
                    }
                }
            }
        }
   
    

    }

    // method to calculate y average 
    public void calculate_yavg() {
        decimal yn = 0;
        decimal n = 0;
        yavg = 0;
        for (RestAPICalloutPayment.PaymentReceived payment_obj: RestAPICalloutPayment_obj.PaymentReceivedList) {
            if ((String.isNotBlank(payment_obj.received_date)) && (String.isNotBlank(payment_obj.due_date) && 
                (String.isNotBlank( payment_obj.principal_outstanding)) && (String.isNotBlank(payment_obj.payments_received)))) {
                if (RestAPICalloutPayment_obj.getdate(payment_obj.received_date).daysbetween(RestAPICalloutPayment_obj.getdate(payment_obj.due_date)) > 0) {
                    
                    yn += ((decimal.valueOf(payment_obj.principal_outstanding) * 
                        (Date.today().daysbetween(RestAPICalloutPayment_obj.getdate(payment_obj.due_date))) * 
                        0.18) / 365) + (decimal.valueOf(payment_obj.payments_received)) * 
                        (RestAPICalloutPayment_obj.getdate(payment_obj.received_date).daysbetween(RestAPICalloutPayment_obj.getdate(payment_obj.due_date))) * 0.18 / 365;
                    n = n + 1;

                } else {
                    yn += ((decimal.valueOf(payment_obj.principal_outstanding) * 
                    (Date.today().daysbetween(RestAPICalloutPayment_obj.getdate(payment_obj.due_date))) * 0.18) / 365);
                    n = n + 1;

                }
            }
            yavg = yn / n;

        }
  
    }

    // method to calculate z index 
    public void calculate_z_index(String CRN) {
        decimal mygainin_Last90days = 0;
        decimal totalreceived =0;
        z_index = 0;
        ztotal = 0;
        List < Booking_Details__c > bookingList = [select CV_paid_New__c from Booking_Details__c where CRN__c = : CRN limit 1];
        if (bookingList.size() > 0) {
            for (RestAPICalloutMygain.Mygaincomplete mygainobj: RestAPICalloutMygain_obj.MygaincompleteRecords) {
                if (String.isNotBlank(mygainobj.Instrument_Receive_Date)&& (String.isNotBlank(mygainobj.My_Gain_Amt_Receive))) {
                    if (RestAPICalloutPayment_obj.getdate(mygainobj.Instrument_Receive_Date) <= Date.today() - 90) {
                        mygainin_Last90days += decimal.valueOf(mygainobj.My_Gain_Amt_Receive);
                    }
                    totalreceived += decimal.valueOf(mygainobj.My_Gain_Amt_Receive);
                }
            }
            if(bookingList[0].CV_paid_New__c!=0) {
                z_index = mygainin_Last90days / bookingList[0].CV_paid_New__c;
                ztotal = totalreceived / bookingList[0].CV_paid_New__c;
            }
        }
   
    
    }


    // calculate CI using x y and z index an x yx and z avg   
    public void calculate_CI() {
        spot_index = 0.80 * x_index + 0.20 * y_index + 0.20 * z_index;
        LifecycleIndex = 0.80 * xavg + 0.20 * yavg + 0.20 * ztotal;
        spot_index = spot_index.setscale(2);
        LifecycleIndex = LifecycleIndex.setscale(2);

    }

}