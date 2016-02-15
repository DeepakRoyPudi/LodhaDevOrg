/*
*        Description : Class Called from Case trigger and it checks if the Case origin is Email To Case if so the Case Origin should not be change.
*
*        Version     Date          Author             Description
*          1.0       19/06/2014    Asmita(Eternus)    Intial Draft
*/

public class RestrictCaseOriginUpdate {
	
	private static final String STRORIGINERROR = System.Label.CaseOriginUpdateError;
	
    public void checkCaseOrigin(Map<Id, Case> mapOldCase, Map<Id, Case> mapNewCase){
    
        for(Case oCase : mapNewCase.values()){
             
             // If Case Origin Values is changed and previously Email To Case
            if(mapOldCase.get(oCase.id).Origin != null){
                if(mapOldCase.get(oCase.id).Origin != mapNewCase.get(oCase.id).Origin && mapOldCase.get(oCase.id).Origin.equalsIgnoreCase('Email To Case')){ 
            	        oCase.addError(STRORIGINERROR);
                }
            }
        }// end of for
    }

}