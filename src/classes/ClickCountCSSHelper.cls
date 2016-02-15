/* Version  			Created By   	 Created Date       Description
 *
 * 	Initial Draft		Sneha P.         31/03/2015       Helper Class to increment the User clicks on 
 *   													 click of View Detail link of widgets
 *
 */
public with  sharing  class ClickCountCSSHelper {

	/* Method to increment widget click count by  0.00000001 for logged in user
	 */  
	public static void incrementCount(String widgetName) {
		//Query dynamic record for current User
	    list<Widget_Sequence__c>widgetSeqList = [Select WidgetInfo__c, 
			                                            WidgetInfo__r.Name, 
								                        User__c,
								                        Sequence_ClickCount__c, 
								                        Name, 
								                        Id 
								                 From   Widget_Sequence__c 
								                 where  User__c =: UserInfo.getUserId() and 
								                        WidgetInfo__r.Name =: widgetName];
		if(widgetSeqList.size() > 0) {
			widgetSeqList[0].Sequence_ClickCount__c = widgetSeqList[0].Sequence_ClickCount__c + 0.00000001;
			update widgetSeqList[0]; 		
		}
	}
}