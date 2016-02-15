/* Version  			Created By   	 Created Date       Description
 *
 * 	Initial Draft		Sneha P.         11/05/2015       Helper Class to get Background Image URL.
 *
 */
public with sharing class BackgroundImageHelper {
	
	public static Boolean isProjectWise;
	public static String imageUrl;
	
	//Constant 
	public static final String partialURL = '/servlet/servlet';
	
	/* Method to populate Background image Url 
	 */
	public static void populateBackgroundImgParam(String userCRN) {
		List<CSSBackgroundImageSetting__c> backgroundImgSetting = 
												CSSBackgroundImageSetting__c.getall().values();
        
        //If Custom setting record exist assign the preference to variable
        if(backgroundImgSetting.size() > 0) {
            isProjectWise = backgroundImgSetting[0].Project_Wise__c;
        } //else isProjectWise will be false and default image is to be displayed 
        else {
            isProjectWise = false;
        }
        
        //For project wise populate the image Url by querying the Project Name object 
        if(isProjectWise) {
            
            try{
	            //Query the Users Account 
	            list<Account> accList = [Select a.PersonMobilePhone, 
	                                     		a.CRN__c,
	                                     		Project_Name__c
	                                     From Account a where a.CRN__c =: userCRN ];
	            
	            if(accList.size() > 0) {
		            //Get the Image Url from Project that we have to display in Background
		            list<Project_Name__c> projectList = [Select Id,
								                                Name,
								                                OrderType__c, 
								                                CSS_Background_Image_URL__c
								                                From Project_Name__c p 
								                                where Name =: accList[0].Project_Name__c];
		            if(projectList != null && projectList.size() > 0 )
		              imageUrl = projectList[0].CSS_Background_Image_URL__c;
	            }
            }catch(Exception e) {
            	
            	system.debug('***Exception'+e);
            }
	            
            if(String.isNotBlank(imageUrl) && imageUrl.contains(partialURL)) {
            	
            	imageUrl = URL.getSalesforceBaseUrl().toExternalForm() + Site.getpathPrefix() + partialURL +
            					imageUrl.substringAfter(partialURL);
            }
        }
	}
}