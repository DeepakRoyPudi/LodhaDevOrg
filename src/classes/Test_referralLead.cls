@isTest(seealldata=false)
Public class Test_referralLead{

    Testmethod Static void referralLead()
    {
        Project_Name__c p = new Project_Name__c(Name = 'Test Project', Contact_Center_No__c = '8892103311', Project_Type__c = 'Casa', Record_Type__c = 'Residential', CRN_INIT__c = 'Tes', Send_SMS__c = True, Thank_You_Sms__c = True, Non_Contactable_Sms__c = True, Visit_Confirmed_Sms__c = True, Date_Time__c = True, Thank_You_Sms_Template__c = 'Thank You', Non_Contactable_Sms_Template__c = 'Non Contactable', Visit_Confirmed_Sms_Template__c = 'Visit Confirmed' );
        insert p;
        
        Loyalty_Detail__c s=new Loyalty_Detail__c(Loyalty_Id__c='dsasd');
        insert s;
        
        Id recTypeA = [Select id, Name from Recordtype where Name = 'Booked Account'].Id;
        
        Account newAcc=new Account(LastName='NewTest',Mobile_Phone__c='8765432123',Loyalty_Details__c=s.Id,RecordTypeId=recTypeA );
        insert newAcc;
        
        List<Lead> aa=new List<Lead>();
        Lead newlead=new Lead(LastName='Test',Project_Name__c=p.Id,LeadSource='Internal Referral',Referred_Booked_Account__c=newAcc.Id,Mobile__c='9876543217');
        insert newlead;
        aa.add(newlead);
    
        referralLead.insertReferralObject(aa);
    
    }

}