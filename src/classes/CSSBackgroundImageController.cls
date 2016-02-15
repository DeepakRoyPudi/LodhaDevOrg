/* ----------------------------------------------------------------------------------------------- 	
 *	Created By   	 Date 				Descripton
 * -----------------------------------------------------------------------------------------------
 * 	 Sneha P.	  15/04/2015 	  Controller for CSSBackgroundImage Page.
 *								  Set the type of Background image to Default or Project wise
 *	
 */
public with sharing class CSSBackgroundImageController {
	String isProjectWise ;
	 
	private List<CSSBackgroundImageSetting__c> backgroundImgSetting;
	
	private static final String INFOMSG = 'Changes saved succesfully ';
	
	public String getisProjectWise() {
        return isProjectWise;
    }
    
    public void setisProjectWise(String isProjectWise) { 
		this.isProjectWise = isProjectWise;
	}
	
	public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('false','Default')); 
        options.add(new SelectOption('true','Project Wise')); 
        return options; 
    }
    
	//Constructor
	public CSSBackgroundImageController() {
		
		backgroundImgSetting = CSSBackgroundImageSetting__c.getall().values();
    	
    	if(backgroundImgSetting.size() > 0) {
    		if(backgroundImgSetting[0].Project_Wise__c) 
    			isProjectWise = 'true';
    		else
    			isProjectWise = 'false';
    	}
	}
	
	public void save() {
		CSSBackgroundImageSetting__c objCS;
		
		if(backgroundImgSetting.size() > 0)
			objCS = backgroundImgSetting[0];
		
		if(objCS == null)
			objCS = new CSSBackgroundImageSetting__c(Name = 'CSS Background Image');
		
		if(isProjectWise == 'true')
			objCS.Project_Wise__c = true;
		else	
			objCS.Project_Wise__c = false;
			
		try {
			update objCS;
			
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,INFOMSG));
			
		} catch (Exception e) {
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error :'+e));
			return;
		}
	}
}