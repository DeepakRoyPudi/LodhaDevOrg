trigger updateProjectNameonAccount on Booking_Details__c (before insert, before update) {
updateAccountsProject.updateProjectName(Trigger.New);

    }