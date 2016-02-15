/*
Description:
class is used as controller in VFcomponent name Rmsidebar component 
and this class object is created in LandingPageCSS2_0Controller,registiondetailscontroller for acceessing the methods 
the class contains methods which access custom setting records url and convert it with the http prefix
 
@Created by: Sudeep Kumar Dube 
 @Created Date: 27/03/2015
 
 --------------------------------------------------------------------------------
 | Modified By      | Modified Date       | Version        | Description         |
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------
 | Aditi Mulmule     04/06/2015             1.2             1.Changes in Registration 
                                                               Details Popup for Resheduling Dates
                                                               by user and mail functionality to
                                                               send email to RM
 | Aditi Mulmule     17/06/2015             1.3             Changed Universal Standard to
                                                            Universal Standard and Responses.
                                                            Removed Responses Link.                                                            
 --------------------------------------------------------------------------------

*/

public class RMCSS2_0CustomSettingLinkController {

    //constant declaration and definitions 
    public static final String CDI_Info = 'CDI_Info';
    public static final String WelcomeGuide = 'WelcomeGuide';
    public static final String FAQs = 'FAQs';
    public static final String ServiceOfferings = 'ServiceOfferings';
    public static final String DetailsOfPossessionProcess = 'DetailsOfPossessionProcess';
    public static final String MyMailbox = 'MyMailbox';
    public static final String CircularsAndNotifications = 'CircularsAndNotifications';
    public static final String DocumentTemplates = 'DocumentTemplates';
    public static final String PolicyAndProcessDoc = 'PolicyAndProcessDoc';
    public static final String ProductFeatures = 'ProductFeatures';
    public static final String ProjectPage = 'ProjectPage';
    //public static final String Responses = 'Responses';
    public static final String UniversalStandardAndResponses = 'UniversalStandardAndResponses';
    public static final String RegistrationGuidelines = 'RegistrationGuidelines';
    public static final String RegisteredAgreementLink ='RegisteredAgreementLink';
    public string CRNval {get;set;}
    
    //constructor
    public RMCSS2_0CustomSettingLinkController() {
     
    }

    //all below methods acces custom setting links 
    //check if not http or https prefix and then it add into the URL and return it 

    public String getCDIInfo() {

        return createUrl(CDI_Info);
    }


    public String getWelcomeGuide() {

        return createUrl(WelcomeGuide);
    }

    public String getFaqs() {

        return createUrl(FAQs);
    }

    public String getServiceOfferings() {

        return createUrl(ServiceOfferings);
    }

    public String getDetailsOfPossessionProcess() {

        return createUrl(DetailsOfPossessionProcess);
    }
    public String getMyinbox() {

        return createUrl(MyMailbox);
    }

    public String getCirculars_and_Notifications() {

        return createUrl(CircularsAndNotifications);
    }

    public String getDocument_Templates() {

        return createUrl(DocumentTemplates);
    }


    public String getPolicy_and_Process_Doc() {

        return createUrl(PolicyAndProcessDoc);
    }


    public String getProduct_Features() {

        return createUrl(ProductFeatures);
    }


    public String getProject_Page() {

        return createUrl(ProjectPage);
    }

  
    public String getUniversal_Standard() {


        return createUrl(UniversalStandardAndResponses);
    }
    
     public String getRegistrationLink() {

        return createUrl(RegistrationGuidelines);

    }
     public String getRegisteredAgreementLink() {

        return createUrl(RegisteredAgreementLink);

    }
    

    public string createUrl(string urlfor) {
        Customer360AndCSS2_0Links01__c Customer360AndCSS2_0Links01_obj = 
                    Customer360AndCSS2_0Links01__c.getvalues(urlfor);
        String url;

        if (Customer360AndCSS2_0Links01_obj != null && !String.isBlank(Customer360AndCSS2_0Links01_obj.Links__c)) {
            url = Customer360AndCSS2_0Links01_obj.Links__c;
           
        }
        if (String.isBlank(url)) {
            url = '#';
            return url;
        } else {
            if (!(url.startsWith('http://') || url.startsWith('https://'))) {

                url = 'http://' + url;
            }
            return url;
        }
    }
}