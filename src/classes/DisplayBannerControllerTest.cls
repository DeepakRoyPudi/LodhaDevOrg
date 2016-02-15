/* Version  			Created By   	 Created Date       Description
 *
 * 	Initial Draft		Sneha P.         08/05/2015       Test Class for DisplayBannerController
 *
 */
@isTest
private class DisplayBannerControllerTest {
	
	/*Test Method to check when single banner is selected then same Banner will be displayed to all 
	 * the Customers
	 */
    static testMethod void sameBannerTest() {
    	//Create Custom setting records
    	createBannerTypeSetting('Single Banner for all customers', true);
    	
    	//Create Banner Record
    	Banner__c banner = createBanner('Same','Same Image');
    	
    	// Create Banner type
    	createBannerType('Single Banner for all customers',banner.Id,'Single Banner for all customers' );
    	
    	Pagereference displayBannerPage = Page.DisplayBannerCSS;
    	test.setCurrentPageReference(displayBannerPage);
    	
    	DisplayBannerController objController = new DisplayBannerController();
    	objController.init();
    	
    	system.assertEquals(objController.banner.Id, banner.Id);
    }
    
    /* Test Method to check when there is no Banner selected
     */
    static testMethod void noBannerTest() {
    	//Create Custom setting records
    	createBannerTypeSetting('No Banner', true);
    	
    	Pagereference displayBannerPage = Page.DisplayBannerCSS;
    	test.setCurrentPageReference(displayBannerPage);
    	
    	DisplayBannerController objController = new DisplayBannerController();
    	objController.init();
    	
    	system.assertEquals(objController.banner, null);
    }
    
    static testMethod void registeredUserBannerTest() {
    	//Create Custom setting records
    	createBannerTypeSetting('Registered / Non Registered', true);
    	
    	//Create Banner Record for registered user
    	Banner__c bannerRegistered = createBanner('Registered / Non Registered','Registered / Non Registered');
    	
    	// Create Banner type
    	createBannerType('Registered / Non Registered',bannerRegistered.Id,'Registered' );
    	
    	Project_Name__c objProject = createProject(bannerRegistered.Id);
    	insert objProject;
    	
    	Account objAccount = createAccount('NRI', 'ABCD1234');
    	
    	Contact objContact = createContact(objAccount.Id);
    	
    	Booking_Details__c objBooking = createBooking(objAccount.Id,'Registered');
    	
    	User objUser = createUser(objContact.Id);
    	
        System.runAs(objUser) {
	    	Pagereference displayBannerPage = Page.DisplayBannerCSS;
	    	test.setCurrentPageReference(displayBannerPage);
	    	
	    	DisplayBannerController objController = new DisplayBannerController();
	    	objController.init();
	    	
	    	//system.assertEquals(objController.banner.Id, bannerRegistered.Id);
	    	
        }
        
        objBooking.Registration_Status__c = 'Non-Registered';
        update objBooking;
        
        
    	//Create Banner Record
    	Banner__c bannerNonRegistered = createBanner('Registered / Non Registered','Registered / Non Registered');
    	
    	// Create Banner type
    	createBannerType('Registered / Non Registered',bannerNonRegistered.Id,'Non Registered' );
    	
        System.runAs(objUser) {
	    	Pagereference displayBannerPage = Page.DisplayBannerCSS;
	    	test.setCurrentPageReference(displayBannerPage);
	    	
	    	DisplayBannerController objController = new DisplayBannerController();
	    	objController.init();
	    	
	    	//system.assertEquals(objController.banner.Id, bannerNonRegistered.Id);
        }
    	
    }
    
   static testMethod void nriUserBannerTest() {
    	//Create Custom setting records
    	createBannerTypeSetting('NRI / Non NRI', true);
    	
    	//Create NRI Banner Record
    	Banner__c NRIBanner = createBanner('NRI','NRI');
    	
    	//Create Non NRI Banner Record
    	Banner__c NonNRIBanner = createBanner('Non NRI','Non NRI');
    	
    	
    	// Create Banner type
    	createBannerType('NRI / Non NRI',NRIBanner.Id,'NRI' );
    	
    	// Create Banner type
    	createBannerType('NRI / Non NRI',NonNRIBanner.Id,'Non NRI' );
    	
    	
    	Project_Name__c objProject = createProject(NRIBanner.Id);
    	insert objProject;
    	
    	Account objAccount = createAccount('NRI', 'ABCD1234');
    	
    	Contact objContact = createContact(objAccount.Id);
    	
    	User objUser = createUser(objContact.Id);
    	
        System.runAs(objUser) {
    	
	    	Pagereference displayBannerPage = Page.DisplayBannerCSS;
	    	test.setCurrentPageReference(displayBannerPage);
	    	
	    	DisplayBannerController objController = new DisplayBannerController();
	    	objController.init();
	    	
        }
    	
    	objAccount.Client_Type__c = 'Non NRI';
    	update objAccount;
    	
    	System.runAs(objUser) {
    	
	    	Pagereference displayBannerPage = Page.DisplayBannerCSS;
	    	test.setCurrentPageReference(displayBannerPage);
	    	
	    	DisplayBannerController objController = new DisplayBannerController();
	    	objController.init();
	    	//TODO write asserts
	    	
        }
    }
    
    static testMethod void oneOrMorePropertyUserBannerTest() {
    	//Create Custom setting records
    	createBannerTypeSetting('One or more Properties', true);
    	
    	Account objAccount = createAccount('NRI', 'ABCD1234');
    	Account objAccount2 = createAccount('NRI', 'ABCD1234');
    	
    	Contact objContact = createContact(objAccount.Id);
    	
    	User objUser = createUser(objContact.Id);
    	
        System.runAs(objUser) {
		    	
			Pagereference displayBannerPage = Page.DisplayBannerCSS;
			test.setCurrentPageReference(displayBannerPage);
			
			DisplayBannerController objController = new DisplayBannerController();
			objController.init();
        }
        
        delete objAccount2;
        
        System.runAs(objUser) {
		    	
			Pagereference displayBannerPage = Page.DisplayBannerCSS;
			test.setCurrentPageReference(displayBannerPage);
			
			DisplayBannerController objController = new DisplayBannerController();
			objController.init();
        }
    }
    
    static testMethod void projectWiseBannerTest() {
    	//Create Custom setting records
    	createBannerTypeSetting('Project Wise', true);
    	
    	//Create Banner Record
    	Banner__c banner = createBanner('Project','Project');
    	
    	
    	Project_Name__c objProject = createProject(banner.Id);
    	insert objProject;
    	
    	Account objAccount = createAccount('NRI', 'ABCD1234');
    	
    	Contact objContact = createContact(objAccount.Id);
    	
    	User objUser = createUser(objContact.Id);
    	
        System.runAs(objUser) {
		    	
			Pagereference displayBannerPage = Page.DisplayBannerCSS;
			test.setCurrentPageReference(displayBannerPage);
			
			DisplayBannerController objController = new DisplayBannerController();
			objController.init();
        }
        
    }
    
    static testMethod void cvPaidUserBannerTest() {
    	//Create Custom setting records
    	createBannerTypeSetting('% of CV Paid', true);
    	
    	//Create Banner Record
    	Banner__c banner = createBanner('CV','CV');
    	
    	Project_Name__c objProject = createProject(banner.Id);
    	insert objProject;
    	
    	Account objAccount = createAccount('NRI', 'ABCD1234');
    	
    	Contact objContact = createContact(objAccount.Id);
    	
    	Booking_Details__c objBooking = createBooking(objAccount.Id,'Registered');
    	
    	Demands__c objDemand = new Demands__c(Amount_received__c = 100, Flat_ID__c = objBooking.Id, ExternalID__c = '1236');
    	insert objDemand;
    	
    	User objUser = createUser(objContact.Id);
    	
        System.runAs(objUser) {
	    	Pagereference displayBannerPage = Page.DisplayBannerCSS;
	    	test.setCurrentPageReference(displayBannerPage);
	    	
	    	DisplayBannerController objController = new DisplayBannerController();
	    	objController.init();
        }
    	
    	//TODO Write asserts
    }  
    
    static User createUser(Id objContactId) {
    	User objUser = new User();
        objUser.ProfileID = [Select Id From Profile Where Name='Custom Overage High Volume Customer Portal'].id;
        objUser.EmailEncodingKey = 'ISO-8859-1';
        objUser.LanguageLocaleKey = 'en_US';
        objUser.TimeZoneSidKey = 'America/New_York';
        objUser.LocaleSidKey = 'en_US';
        objUser.FirstName = 'first';
        objUser.LastName = 'last';
        objUser.Username = 'test@appirio.com';   
        objUser.CommunityNickname = 'testUser123';
        objUser.Alias = 't1';
        objUser.Email = 'no@email.com';
        objUser.IsActive = true;
        objUser.ContactId = objContactId;

        insert objUser;
        return objUser;
    }
    
    static Booking_Details__c createBooking(Id accountId, String status) {
    	Booking_Details__c objBooking = new Booking_Details__c(Registration_Status__c = status,
    														   CRN__c = '121',
    														   Flat_Id__c = 'ABCD1234',
    														   Account__c = accountId,
    														   Consideration_Value__c = 10);
    	insert objBooking;
    	return objBooking;
    }
    
    //Method to create Contact record
    public static Contact createContact(Id accountId) {
    	Contact objContact = new Contact(FirstName = 'Test', LastName = 'User', AccountId = accountId);
    	insert objContact;
    	return objContact;
    }
    
    //Method to craete Account record
    public static Account createAccount(String clientType, String panNo) {
    	Account objAccount = new Account (Name= 'Test Account', Project_Name__c = 'Casa Project',
    									  Client_Type__c = clientType, 
    									  Primary_PAN_number__c = panNo);
    	insert objAccount;
    	return objAccount;
    }
    
    //Method to create Banner Type record
    public static Banner_Type__c createBannerType(String name, Id bannerId, String typeOfBanner) {
    	Banner_Type__c bannerType = new Banner_Type__c(Name=name, 
    												   Banner__c = bannerId,
    												   Type__c = typeOfBanner);
    	insert bannerType;
    	return bannerType;
    }
    
    //Method to create Banner record
    public static Banner__c createBanner(String name, String image) {
    	Banner__c banner = new Banner__c(Name=name, Image__c = image);
    	insert banner;
    	return banner;
    }
    
    //Method to create Custom setting record
    public static Banner_Type_Setting__c createBannerTypeSetting(String name, boolean isSelected) {
    	Banner_Type_Setting__c bannerType = new Banner_Type_Setting__c(Name = name, isSelected__c = isSelected);
    	insert bannerType;
    	return bannerType;
    	
    }
    
    //Method to craete a project
    public static Project_Name__c createProject(Id bannerId) {
    	Project_Name__c objProject = new Project_Name__c();
    	objProject.Name = 'Casa Project';
    	objProject.Project_Type__c = 'Aspirational' ;
    	objProject.Banner__c = bannerId;
    	//insert objProject;
    	return objProject;
    }
}