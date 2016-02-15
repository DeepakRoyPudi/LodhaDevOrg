trigger MissedTask_SendMailtomanager on Task(before update) {
MailtoMissedTask.SendMailtomanager(Trigger.New);
}