public class MailtoMissedTask
{
public static  void SendMailtomanager(Task[] ts)
{
if(ts[0].status != 'Completed'&& ts[0].Mail_Check_Flag__c == 'YES'){

string[] EmailIDs;
String emailText = '';
String EmailSubject = ts[0].Subject;

User userobj =[select Manager.Email,Name from User where Id=:ts[0].OwnerId];
//String[] toAddresses = new String[] {userobj.Manager.Email};
String[] toAddresses = new String[] {'rameshisnow@ureach.com'};
if(userobj.Manager.Email != null){
Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
mail.setSenderDisplayName('SalesForce  System');
mail.setSubject(EmailSubject);
mail.setToAddresses(toAddresses);
emailText += '<Strong>Please find the Task Information </Strong><BR>';
emailText += '<HR><BR>';
emailText += '<Strong>Subject :'+ts[0].Subject+'</Strong><BR>';
emailText += '<Strong>Task to be completed on :'+ts[0].TaskDateTime__c+'</Strong><BR>';
emailText += '<Strong>click the below URL to assign to someone else. </Strong><BR>';
emailText += '<Strong><a href="https://cs2.salesforce.com/'+ts[0].ID+'">https://cs2.salesforce.com/'+ts[0].ID+'</a></Strong><BR>';
emailText += '<Strong>Regards</Strong><BR>';
emailText += '<Strong>Lodha Admin</Strong><BR>';
mail.setHtmlBody(emailText);
Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
ts[0].Mail_Check_Flag__c = 'Mail Sent';
System.debug(mail);
}   
}
}
static testMethod void MailtoMissedTask()
{
Lead led = new Lead();
led.status='Visit Confirmed';
led.Mobile__c='1234567892';
led.LastName='XXXXXX';
led.Interested__c='Yes';
led.LeadSource = 'Web';
led.Project_Interested__c ='Marine';
led.Date_Of_Visit__c=Datetime.newInstance(2008, 10, 28, 1, 6, 8);
insert led;
Lead led1 = new Lead();
led1.status='Follow up';
led1.LeadSource = 'Web';
led1.Project_Interested__c ='Marine';
led1.Mobile__c='1234567893';
led1.LastName='XXXXXX';
led1.Interested__c='Yes';
led1.Follow_Up_Date__c=Datetime.newInstance(2008, 10, 28, 1, 6, 8);
insert led1;

Task[] ts = new Task[2];
ts[0] = new Task(WHOID=led.Id,OWNERID=UserInfo.getUserId(),Subject='Test',priority ='High',status = 'Not started',Mail_Check_Flag__c = 'YES');
insert ts[0];
ts[1] = new Task(WHOID=led1.Id,OWNERID=UserInfo.getUserId(),Subject='Test',priority ='High',status = 'Not started',Mail_Check_Flag__c = 'YES');
insert ts[1];
/*ts[1] = new Task(Subject='Test',priority ='High',status = 'Not started',Mail_Check_Flag__c = 'YES');
insert ts[1];*/
SendMailtomanager(ts);
}

}