@isTest
private class TestPortalUserLastLoginController{
    
    static testMethod void portalUserInitialLoginTest(){ 
        
        Profile p = [Select id from Profile where Name = 'System Administrator'];
        
        system.debug('## p : '+p.id);    
        
        User u = new User();
        u.LastName = 'TestUser';
        u.Alias = 'tuser';
        u.Email = 'test@test.in';
        u.Username = 'abc_123@test.com';
        u.CommunityNickname = 'Testuser';
        u.ProfileId = p.Id;
        //u.TimeZoneSidKey = 'Asia/Calcutta';
        u.TimeZoneSidKey = 'Asia/Kolkata';
        u.LocaleSidKey = 'en_IE_EURO';
        u.EmailEncodingKey = 'ISO-8859-1';
        u.LanguageLocaleKey = 'en_US';
        u.IsActive = true;
        insert u;
        id s=[select id,name from recordtype where name='Booked Account'].id;
        
        Account a = new Account();
        a.LastName = 'Test Account';
        a.PersonEmail = 'abc_123@test.com';
        a.Mobile_Phone__c = '9519516230';
        a.RecordtypeId = s;
        a.Project_Name__c = 'Casa Bella';
        insert a;
        
        Project_name__c pro = new Project_name__c(name = 'Casa Bella', Project_Type__c = 'Casa', Record_Type__c = 'Residential', CRN_INIT__c = '1');
        insert pro;
        
        System.runAs(u){
        	
        	Test.startTest();
            PortalUserLastLoginController obj = new PortalUserLastLoginController();
            obj.doGetPortalUserInfo();
            Test.stopTest();
            
            a.Project_Name__c='Casa Bella Gold';
            update a;
            pro.name='Casa Bella Gold';
            update pro;
            PortalUserLastLoginController obj1=new PortalUserLastLoginController();
            
            
            a.Project_Name__c='Casa Rio';
            update a;
            pro.name='Casa Rio';
            update pro;
            PortalUserLastLoginController obj2=new PortalUserLastLoginController();
            
            
            a.Project_Name__c='Lakeshore Greens';
            update a;
            pro.name='Lakeshore Greens';
            pro.Project_Type__c='Hi End / Luxury';
            update pro;            
            PortalUserLastLoginController obj3=new PortalUserLastLoginController();
            
            
            a.Project_Name__c='Lodha Imperia';
            update a;
            pro.name='Lodha Imperia';
            pro.Project_Type__c='Aspirational';
            update pro;            
            PortalUserLastLoginController obj4=new PortalUserLastLoginController();
            
            a.Project_Name__c = 'Lodha Supremus-WorliNaka';
            update a;
            pro.Name = 'Lodha Supremus - Worli Naka';
            pro.Project_Type__c = 'test';
            update pro;
            PortalUserLastLoginController obj5 = new PortalUserLastLoginController();
            
            PageReference objPageRef = obj.redirectHome();
        }
    }
}