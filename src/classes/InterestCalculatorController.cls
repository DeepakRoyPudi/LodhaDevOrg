public class InterestCalculatorController {
    public InterestCalculatorController(ApexPages.StandardController controller) {

    }
    public InterestCalculatorController() {             
    
    }


    public double noOfDays;
    public Double outstandingAmount { get; set; }
    
    Interest_Calculations__c intCalc = new Interest_Calculations__c();
        
        public Interest_Calculations__c getProxyObject()
        { 
            return intCalc; 
        }
        
    public String getInterestAmount(){
                
        decimal InterestAmount;
        string InterestAmountstr;
        if(outstandingAmount != null){
            noOfDays = intCalc.demand_date__c.daysBetween(intCalc.payment_date__c);
            system.debug('noOfDays: '+noOfDays);
            InterestAmount = (outstandingAmount*noOfDays*18)/(365*100);
            InterestAmount = InterestAmount.setScale(2);
            InterestAmountstr = InterestAmount.format();
        }
        return InterestAmountstr;
    }
}