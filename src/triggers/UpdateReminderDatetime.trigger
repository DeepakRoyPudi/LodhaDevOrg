trigger UpdateReminderDatetime on Task (before insert, before delete) {
    if(trigger.IsInsert){
        Update_Task_ReminderDatetime.Updatemethod(Trigger.New);
    }
    if(trigger.IsDelete){
    
    Profile p = [Select id from Profile WHERE Name = 'Customer Care' LIMIT 1];
        if(UserInfo.getProfileId() == P.Id)
        {
            for(Task t: trigger.old)
            {
                t.addError('You do not have permission to delete any Task, please contact your administrator');
            }
        }
    }
}