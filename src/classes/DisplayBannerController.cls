/* Version              Created By       Created Date       Description
 *
 *  Initial Draft       Sneha P.         27//04/2015       Controller for DisplayBannerCSS Page
 *
 */
public with sharing class DisplayBannerController {
    public Banner__c banner {get; set;}

    // Private Variables
    Banner_Type_Setting__c selectedAdminBanner;
    
    @testVisible private static final String SINGLE_BANNER = 'Single Banner for all customers';
    @testVisible private static final String NO_BANNER = 'No Banner';
    @testVisible private static final String PERCENT_CV_PAID = '% of CV Paid';
    @testVisible private static final String PROJECT_WISE = 'Project Wise';
    @testVisible private static final String REGISTERED_NONREGISTERED = 'Registered / Non Registered';
    private static final String REGISTERED = 'Registered';
    private static final String NONREGISTERED = 'Non Registered';
    private static final String ONE_MOREPROPERTIES = 'One or more Properties';
    private static final String ONE_Project  = 'One Project';
    private static final String MORE_Project  = 'More than one Project';
    private static final String NRI_NONNRI  = 'NRI / Non NRI';
    private static final String NRI  = 'NRI';
    private static final String NON_NRI  = 'Non NRI';
    
    //Constructor
    public DisplayBannerController() {
        
    }
    
    //Init Method
    public PageReference init() {
        
        PageReference pageRef = null;
        
        pageRef = AuthenticateCommuntiyUserHelper.forwardToCustomAuthPage();
        if(pageRef != null)
            return pageRef;     
            
        List<Banner_Type_Setting__c> bannerAdminSettings = Banner_Type_Setting__c.getAll().values();
            for (Banner_Type_Setting__c bannerAdminInstance : bannerAdminSettings) {
            if (bannerAdminInstance.isSelected__c) {
                selectedAdminBanner = bannerAdminInstance;
                break;
            }
        }
        if(selectedAdminBanner != null)
            processBannerType(selectedAdminBanner);
        if(banner == null)
             pageRef = redirectToHome();
        return pageRef;     
    }
    
    //Function to assign value to Banner depending on the different criteria
    private void processBannerType(Banner_Type_Setting__c selectedAdminBanner) {
        list<Banner_Type__c> selectedBannerList;
        //If Single banner is selected then display same banner to all user 
        if (selectedAdminBanner.Name.equalsIgnoreCase(SINGLE_BANNER)) {
            selectedBannerList = getBannerBasedOnType(SINGLE_BANNER);
           
            if(selectedBannerList != null && selectedBannerList.size() > 0 &&
               selectedBannerList[0].Banner__r != null) {
                banner = selectedBannerList[0].Banner__r;
            }
            return;
        } else if (selectedAdminBanner.Name.equalsIgnoreCase(NO_BANNER)) {
           return;
        } else if (selectedAdminBanner.Name.equalsIgnoreCase(PROJECT_WISE)) {
            list<User> currentUser = getCurrentUser();
            if(currentUser != null && currentUser.size() > 0) { 
                list<Account> userAccount = getUserAccount(currentUser[0].AccountId);
                if(userAccount != null && userAccount.size() > 0) {
                    Project_Name__c userProject = new Project_Name__c();
                    List<Project_Name__c> userProjectlist = [SELECT Id, Banner__c, Banner__r.Image__c FROM Project_Name__c WHERE Name =: userAccount[0].Project_Name__c];
                    if(userProjectlist.size()>0){
                        userProject  = userProjectlist[0];
                    }
                    if(userProject != null && userProject.Banner__r != null)
                        banner = userProject.Banner__r;
                }
            }
            return;
        } else if (selectedAdminBanner.Name.equalsIgnoreCase(PERCENT_CV_PAID)) {
            list<User> currentUser = getCurrentUser();
            if(currentUser != null && currentUser.size() > 0) { 
                list<Account> userAccount = getUserAccount(currentUser[0].AccountId);
                if(userAccount != null && userAccount.size() > 0) { 
                Booking_Details__c bookingDetails = [SELECT Id, CV_paid_New__c FROM Booking_Details__c WHERE Account__c =: userAccount[0].Id];
                    selectedBannerList =
                        [
                            SELECT
                                Id,Banner__r.Image__c, Highest_Percent__c, Lowest_Percent__c, Type__c, Sub_Type__c
                            FROM
                                Banner_Type__c
                            WHERE
                                Type__c =: PERCENT_CV_PAID
                                AND ( ( Highest_Percent__c != null AND
                                        Highest_Percent__c >=: bookingDetails.CV_paid_New__c
                                        AND Lowest_Percent__c <: bookingDetails.CV_paid_New__c
                                       ) OR
                                        (
                                            Lowest_Percent__c <: bookingDetails.CV_paid_New__c
                                            AND Highest_Percent__c = null 
                                        )
                                    )
                                
                            LIMIT 1
                        ];
                    if(selectedBannerList != null && selectedBannerList.size() > 0 &&
                       selectedBannerList[0].Banner__r != null) 
                        banner = selectedBannerList[0].Banner__r;
                }
            }
            return;
        } else if (selectedAdminBanner.Name.equalsIgnoreCase(REGISTERED_NONREGISTERED)) {
            list<User> currentUser = getCurrentUser();
            if(currentUser != null && currentUser.size() > 0) { 
                list<Account> userAccount = getUserAccount(currentUser[0].AccountId);
                if(userAccount != null && userAccount.size() > 0) {
                    
                    Booking_Details__c bookingDetails = [SELECT Id, Registration_Status__c FROM Booking_Details__c WHERE Account__c =: userAccount[0].Id];
                    
                    String subType = '';
                    if(bookingDetails.Registration_Status__c != '' &&
                        bookingDetails.Registration_Status__c != null && bookingDetails.Registration_Status__c.EqualsIgnoreCase(REGISTERED)) 
                        subType = REGISTERED;
                    else    
                        subType = NONREGISTERED;
                    selectedBannerList = this.getBannerType(REGISTERED_NONREGISTERED, subType);
                    
                    if(selectedBannerList != null && selectedBannerList.size() > 0 &&
                       selectedBannerList[0].Banner__r != null) 
                        banner = selectedBannerList[0].Banner__r;
                }
            }
            return;
        } else if (selectedAdminBanner.Name.equalsIgnoreCase(NRI_NONNRI)) {
            list<User> currentUser = getCurrentUser();
            if(currentUser != null && currentUser.size() > 0) { 
            
                list<Account> userAccount = getUserAccount(currentUser[0].AccountId);
                if(userAccount != null && userAccount.size() > 0) {
                    String subType = '';
                    if(userAccount != null && userAccount[0].Client_Type__c != null && 
                                              userAccount[0].Client_Type__c != '' && 
                                              userAccount[0].Client_Type__c.EqualsIgnoreCase(NRI)) {
                        subType = NRI;
                    }else {
                        subType = NON_NRI;
                    }
                    selectedBannerList = this.getBannerType(NRI_NONNRI, subType);
                     if(selectedBannerList != null && selectedBannerList.size() > 0 &&
                                                      selectedBannerList[0].Banner__r != null) 
                        banner = selectedBannerList[0].Banner__r;    
                }     
            }  
            return;
        } 
        else if(selectedAdminBanner.Name.equalsIgnoreCase(ONE_MOREPROPERTIES)) {
            // get Pan No of user       
            list<User> currentUser = getCurrentUser();
            if(currentUser != null && currentUser.size() > 0) {
                list<Account> userAccount = getUserAccount(currentUser[0].AccountId);
                id RTId = [Select id from RecordType where Name = 'Booked Account'].id;
                
                list<Account> dupAccountList = [Select Id, Primary_PAN_number__c 
                                            from Account where Primary_PAN_number__c =:userAccount[0].Primary_PAN_number__c
                                                and Id !=: userAccount[0].Id and RecordTypeId =: RTId
                                            ];
                String subType = '';
                if(dupAccountList != null && dupAccountList.size() > 0) 
                    subType = MORE_Project;
                else
                    subType = ONE_Project;  
                
                selectedBannerList = this.getBannerType(ONE_MOREPROPERTIES, subType);
                if(selectedBannerList != null && selectedBannerList.size() > 0 &&
                                                  selectedBannerList[0].Banner__r != null) 
                    banner = selectedBannerList[0].Banner__r; 
            }
            return;         
        }
    }
    
    //Function to query banner type record based on type and subtype parameters
    private list<Banner_Type__c> getBannerType(String pType, String pSubType) {
        return [
                    SELECT
                        Id,Banner__r.Image__c, Highest_Percent__c, Lowest_Percent__c, Type__c, Sub_Type__c
                    FROM
                        Banner_Type__c
                    WHERE
                        Type__c =: pType
                        AND Sub_Type__c =: pSubType
                    LIMIT 1
                ];
                        
    }
    
    // Function to query current User Account
    private list<Account> getUserAccount(Id accId) {
        return [SELECT Id, Client_Type__c,Primary_PAN_number__c, Project_Name__c FROM Account WHERE Id =: accId]    ;   
    }
    
    // Function to query logged in user
    private list<User> getCurrentUser() {
        return [SELECT Id, AccountId FROM User WHERE Id =: UserInfo.getUserId()];       
    }
    
    // Function to query Banner type
    private list<Banner_Type__c> getBannerBasedOnType(String bannerType) {
        List<Banner_Type__c> bannerTypes =
            [SELECT id, Banner__r.Image__c, Highest_Percent__c, Lowest_Percent__c, Sub_Type__c, Type__c FROM Banner_Type__c WHERE Type__c =: bannerType];
        if (bannerTypes != null && !bannerTypes.isEmpty()) {
            return bannerTypes;
        }
        return null;
    }

    //Function to redirect to home Page from Banner
    public PageReference redirectToHome() {
        PageReference objPgRefHome = Page.HomeCSS2_0; 
        objPgRefHome.setRedirect(true);
        return objPgRefHome;
    }
}