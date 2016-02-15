public class CaseIntermediateController {

    public String retURL;
    case obj;
    
    public CaseIntermediateController(ApexPages.StandardController controller) {
        this.obj= (Case)controller.getRecord();      
        retURL = ApexPages.currentPage().getParameters().get('retURL');    
    }
    
    public PageReference  autoAssignment(){
    
        PageReference fieldpage ;
        string rcdId = System.currentPageReference().getParameters().get('RecordType');
        String Utype = UserInfo.getUserType();
		
		Schema.DescribeSObjectResult d = Schema.SObjectType.Case;
		Map<Id,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosById();
		String availableRcdType ='';
		
		if(rtMapByName.get(rcdId)!=null){			
			availableRcdType = rtMapByName.get(rcdId).getName(); 	
		}
		else{
			for(Schema.RecordTypeInfo rcdInfo : rtMapByName.Values())
                {
                        if(rcdInfo.IsAvailable() && rcdInfo.isDefaultRecordTypeMapping())
                        {
                        	availableRcdType = rcdInfo.getName();    
                            rcdId = rcdInfo.getRecordTypeId();                        
                        }
				}
		
		}
			
		if(Utype !='Standard')
			{
			fieldpage = new pagereference('/apex/CSSCaseCreatePage?retURL='+retURL+'&RecordType='+rcdId);
			fieldpage.setredirect(true);
			}
		else if(Utype =='Standard')
			{
				if (availableRcdType == 'Master')
		            {
		                fieldpage = new pagereference('/500/e?retURL=%2F500%2Fo&nooverride=0');
		                fieldpage.setredirect(true);
		            }
			else if (availableRcdType.length()>0)
		            {
		                fieldpage = new pagereference('/500/e?retURL=%2F500%2Fo&nooverride=0&RecordType='+rcdId);
		                fieldpage.setredirect(true);
		            }
			}
		
		return fieldpage;
 
    }   
}