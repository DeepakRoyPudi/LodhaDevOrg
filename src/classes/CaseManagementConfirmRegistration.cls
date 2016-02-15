/*
*        Description : Case Trigger Handler
*
*        Version     Date          Author             Description
*        1.0         18/11/2014    Anupam Agrawal     Case Mangement validation on "Date Confirm Registration"
*        1.1         26/11/2014    Siddharth          
*/

public class CaseManagementConfirmRegistration 
{
    //Class variables
    private Set<Date> setHolidayDate = new Set<Date>();
    private final String REGISTRATION_RELATED = 'Registration Related';
    private final String SCHEDULING_SDR_ALREADY_PAID = 'Scheduling (SDR already paid)';
    private final String CONFIRM_TIME_PLACE_OF_REGISTRATION = 'Confirm Time & place of Registration';
    
    //Invoke from onBeforeInsertHandler Method to validate all the new case registration date.
    public void confirmRegistrationDate(List<Case> lstNewCase)
    { 
        //Execute each case record.
        for(Case objCase : lstNewCase)
        {
            //Check the condition to confirm L1, L2, L3 combination and Registraion Date value.
            Boolean isValueAvailable = (!String.isBlank(objCase.Request_for_L1__c)) && objCase.Request_for_L1__c.contains(REGISTRATION_RELATED) && 
                                       (!String.isBlank(objCase.Request_for_L2__c)) && objCase.Request_for_L2__c.contains(SCHEDULING_SDR_ALREADY_PAID) &&
                                       (!String.isBlank(objCase.Request_for_L3__c)) && objCase.Request_for_L3__c.contains(CONFIRM_TIME_PLACE_OF_REGISTRATION) && 
                                       objCase.Date_Confirm_Time_place_of_Registratio__c != null;
                                       
            //all the required value entred.
            if(isValueAvailable)
            {
                //Get the correct date
                DateTime correctDate = getCorrectRegistrationDate();
                
                //Correct date is not match with Case registration date than show error message.
                //if(correctDate.date() != objCase.Date_Confirm_Time_place_of_Registratio__c.date())
                displayError(objCase, objCase.Date_Confirm_Time_place_of_Registratio__c, correctDate);
            }
        }
    }
    
    //Invoke from onBeforeUpdateHandler Method to validate all the new case registration date.
    public void confirmRegistrationDate(Map<Id, Case> mapOldIdToCase, Map<Id, Case> mapNewIdToCase)
    {
        List<Case> lstCase = new List<Case>();
        //Execute each case record and get the case those values meet the condition.
        for(Case objNewCase : mapNewIdToCase.values())
        {
            Case objOldCase = mapOldIdToCase.get(objNewCase.Id);
            
            //Check the condition to confirm L1, L2, L3 combination and Registraion Date value.                        
            Boolean isNewCaseCombination1 = (!String.isBlank(objNewCase.Request_for_L1__c)) && objNewCase.Request_for_L1__c.contains(REGISTRATION_RELATED) && 
                                            (!String.isBlank(objNewCase.Request_for_L2__c)) && objNewCase.Request_for_L2__c.contains(SCHEDULING_SDR_ALREADY_PAID) && 
                                            (!String.isBlank(objNewCase.Request_for_L3__c)) && objNewCase.Request_for_L3__c.contains(CONFIRM_TIME_PLACE_OF_REGISTRATION) &&
                                            (objNewCase.Date_Confirm_Time_place_of_Registratio__c != null &&
                                            objNewCase.Date_Confirm_Time_place_of_Registratio__c != objOldCase.Date_Confirm_Time_place_of_Registratio__c);
                                         
            //Check the condition to confirm L1, L2, L3 combination and Registraion Date value.                            
            Boolean isNewCaseCombination2 = (!String.isBlank(objNewCase.Request_for_L1__c)) && objNewCase.Request_for_L1__c.contains(REGISTRATION_RELATED) && 
                                            (!String.isBlank(objNewCase.Request_for_L2__c)) && objNewCase.Request_for_L2__c.contains(SCHEDULING_SDR_ALREADY_PAID) && 
                                            (!String.isBlank(objNewCase.Request_for_L3__c)) && objNewCase.Request_for_L3__c.contains(CONFIRM_TIME_PLACE_OF_REGISTRATION) &&                                            
                                            (String.isBlank(objOldCase.Request_for_L3__c) || !objOldCase.Request_for_L3__c.contains(CONFIRM_TIME_PLACE_OF_REGISTRATION)) &&
                                            objNewCase.Date_Confirm_Time_place_of_Registratio__c != null ;
            //Collect the case record.
            if(isNewCaseCombination1 || isNewCaseCombination2)
                lstCase.add(objNewCase);
        }
        
        //Process each case record and check registration date.
        for(Case objCase : lstCase)
        {
            DateTime correctDate = getCorrectRegistrationDate();
            displayError(objCase, objCase.Date_Confirm_Time_place_of_Registratio__c, correctDate);
            //if(correctDate.date() != objCase.Date_Confirm_Time_place_of_Registratio__c.date())
        }
        
    }
    
    private void displayError(Case objCase, DateTime registrationDate, DateTime correctDate)
    {
        if( registrationDate.date() < correctDate.date())
        {
            objCase.addError('Registration Date cannot be less than ' + correctDate.format('dd/MM/yyyy'));
        }
        else 
        {
            String dayOfWeek = registrationDate.format('E');
            Integer weekOfMonth = Integer.valueOf(registrationDate.format('W'));
            
            if(setHolidayDate.contains(registrationDate.date()) ||
                (dayOfWeek.equalsIgnoreCase('Sat') && (weekOfMonth == 2 || weekOfMonth == 4)) || 
                 dayOfWeek.equalsIgnoreCase('Sun'))
             objCase.addError('Registration Date cannot be ' + registrationDate.format('dd/MM/yyyy') + '. Please enter working date only.');   
        }
        
    }
    //Retrun corrct datetime value as per required condition
    public DateTime getCorrectRegistrationDate()
    {
        Map<String, Holiday_Information__c> mapNameToHolidayInfo = Holiday_Information__c.getAll();
        
        //Collect Holiday date list.
        for(Holiday_Information__c objHI : mapNameToHolidayInfo.values())
            if(objHI.Active__c)
                setHolidayDate.add(objHI.Holiday_Date__c);
          
        DateTime nextDateTime = DateTime.now();
        
        for(Integer i = 1; i <= 5; i++)
            nextDateTime = adjustDateTime(nextDateTime.addDays(1)) ;
            
        return nextDateTime;
    }
    
    private DateTime adjustDateTime(DateTime nextDateTime)
    {
        String dayOfWeek = nextDateTime.format('E');
        Integer weekOfMonth = Integer.valueOf(nextDateTime.format('W'));
        
        Date nextDate = nextDateTime.date();
        if(setHolidayDate.contains(nextDate))
          nextDateTime  = adjustDateTime(nextDateTime + 1);
    
        if((dayOfWeek.equalsIgnoreCase('Sat') && (weekOfMonth == 2 || weekOfMonth == 4)) || dayOfWeek.equalsIgnoreCase('Sun'))
            nextDateTime  = adjustDateTime(nextDateTime + 1);
        
        return nextDateTime ;
    }
}