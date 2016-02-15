public with sharing class wrapperControllerRM {
   
    public wrappercustomer wrapperobj {get; set;} //wrapper class object
    public string CRN {get; set;} //param from vf page url
    
    public string MOBILE {get; set;} //param from vf page url
    
    public String test_Variable {get; set;}
    
    
    
    /* Logic to implement sequencing
    */
    
    public String firstDiv {get; set;}
    public String secondDiv {get; set;}
    public String thirdDiv {get; set;}
    public String fourthDiv {get; set;}
    public String fifthDiv {get; set;}
    
    public static final String RECENTACTIVITY = 'RecentActivity';
    
    /* End
    */ 
    public wrapperControllerRM() {
        //wraper class object initialised
        wrapperobj = new  wrappercustomer();
         CRN = ApexPages.currentPage().getParameters().get('CRN');
         MOBILE = ApexPages.currentPage().getParameters().get('Mobile');
        system.debug('<<<<<<<'+CRN);
        
        test_Variable = 'RecentActivityRM';
        
         this.setWidgetSequence();
    } 
    
    public void setWidgetSequence(){
    	//START sequencing 
    	
    	CRN = ApexPages.currentPage().getParameters().get('CRN');
        // MOBILE = ApexPages.currentPage().getParameters().get('Mobile');
         
    	list<String> seqList = new list<String>();
    	
        //query the widgets for that project
        list<Account> accList = [Select a.PersonMobilePhone, 
        								a.CRN__c,
        								Project_Name__c
        						 From Account a where a.CRN__c =: CRN ];
      	
      	if(accList[0].Project_Name__c != null || accList[0].Project_Name__c != '') {
      		
	    	//query enable disable
	    	list<Project_Name__c> prjctName = [Select Id,
	    											  Name,
	    											  OrderType__c, 
								    				 (Select Id, 
								    				 		 Name,
								    				 		 WidgetInfo__c,
								    				 		 WidgetInfo__r.Name,
								    				 		 isEnableForRM__c,
								    				 		 isEnableForCustomer__c 
								    				  From EnableDisable_widgets__r) 
								    		   From Project_Name__c p where Name =: accList[0].Project_Name__c];
			
			map<Id, EnableDisable_widgets__c > enableDisableMap = new map<Id, EnableDisable_widgets__c>();
			
			if(prjctName[0].EnableDisable_widgets__r.size() > 0) {
				for(EnableDisable_widgets__c EDWidget : prjctName[0].EnableDisable_widgets__r) {
					enableDisableMap.put(EDWidget.WidgetInfo__c, EDWidget);						
				}
			}
					
			list<Widget_Sequence__c> widgetSeqList = new list<Widget_Sequence__c>();	    		   
			if(prjctName.size() > 0){
				
				
				if(prjctName[0].OrderType__c == 'Dynamic') {
					//Get the User record fo rthat Account
					list<User> userList = [Select Username, FirstName, ContactId, AccountId 
											From User where AccountId =: accList[0].Id];
					
					widgetSeqList = [Select Project_Name__c, Project_Name__r.Name,
																 Sequence_ClickCount__c,Sequence_for__c,WidgetInfo__c ,
																 WidgetInfo__r.Name,
																 User__c from 
											 Widget_Sequence__c where Sequence_for__c =: 'RM' AND
											 RecordTypeId =: Schema.SObjectType.Widget_Sequence__c.getRecordTypeInfosByName().get('Dynamic').getRecordTypeId()
											 AND User__c =: userList[0].id 
											 Order by Sequence_ClickCount__c DESC];
					
				}else if(prjctName[0].OrderType__c == 'Custom') {
					// Query the sequence from 'Widget Sequence' object where record type is default 
					widgetSeqList = [Select Project_Name__c, Project_Name__r.Name,
																 Sequence_ClickCount__c,Sequence_for__c,WidgetInfo__c ,
																 WidgetInfo__r.Name,
																 User__c from 
											 Widget_Sequence__c where Sequence_for__c =: 'RM' AND
											 Project_Name__c =: prjctName[0].Id AND
											 RecordTypeId =: Schema.SObjectType.Widget_Sequence__c.getRecordTypeInfosByName().get('Custom').getRecordTypeId()
											 Order by Sequence_ClickCount__c];
				}
				
				if(prjctName[0].OrderType__c == 'Default' || widgetSeqList.size() == 0){
					
					// Query the sequence from 'Widget Sequence' object where record type is default 
					widgetSeqList = [Select Project_Name__c, Project_Name__r.Name,
																 Sequence_ClickCount__c,Sequence_for__c,WidgetInfo__c ,
																 WidgetInfo__r.Name,
																 User__c from 
											 Widget_Sequence__c where Sequence_for__c =: 'RM' AND
											 RecordTypeId =: Schema.SObjectType.Widget_Sequence__c.getRecordTypeInfosByName().get('Default').getRecordTypeId()
											 Order by Sequence_ClickCount__c];
						
						
				}
				
				for(Widget_Sequence__c widgetSeq: widgetSeqList) {
							
					if(!enableDisableMap.isEmpty() && enableDisableMap.containsKey(widgetSeq.WidgetInfo__c) &&
						enableDisableMap.get(widgetSeq.WidgetInfo__c).isEnableForRM__c) {
						
						seqList.add(widgetSeq.WidgetInfo__r.Name);
					}
				}
			}
	    }
        //set the widget Sequence
        if(seqList.size() > 0)
        	firstDiv = seqList[0];
        if(seqList.size() > 1)
        	secondDiv = seqList[1];
        if(seqList.size() > 2)
        	thirdDiv = seqList[2];
        if(seqList.size() > 3)
        	fourthDiv = seqList[3];
        if(seqList.size() > 4)
        	fifthDiv = seqList[4];
     	//END  	
    	
    }
    
    //wrapper class for profile detials 
    public class wrappercustomer {
        public string name{get; set; } // sets name of cutomer
        public string profile_completion{get; set; } // sets profile status in percent
        public string email{get; set; } // sets customer email address in personal details tab
        public String phone{get; set; } // sets customer ph no of customer 
        public string profileimage {get; set; } // sets customer profile image url
        public string pan_no {get; set; } //sets customer pan no of customer
        public string Billing_addr {get; set; } // sets customer billing address 
        public string special_instr {get; set; } //sets special intructions by RM
        public string instr_by_hod {get; set; } // sets instructions by hod
        public string prefered_time {get; set; } // sets customer's preferred time of communication
        public string perfered_comm {get; set; } // sets prefered commmunication mode
        public boolean TDS {get; set; } // other flags 
        public boolean DND {get; set; } // other flags 
        public boolean LA {get; set; } // other flags 
        public boolean CIP {get; set; } // other flags 
        public boolean LAP {get; set; } // other flags 
        public boolean MB {get; set; } // other flags 
        public boolean mygain {get; set; } // renders mygain
        
        public wrappercustomer() {
            name = 'Sudeep Kumar Dube';
            email = 'ab@c.com';
            phone = '9999911111';
            profileimage = 'https://lh5.googleusercontent.com/-k6QUAwgDsK0/VHNoVKyrvbI/AAAAAAAAOSQ/KwEGvX86L-Q/h128-no/empty_profile.jpg';
            profile_completion = '50%';
            pan_no = '1212ABV12';
            Billing_addr = 'XXXXX XXXX';
            special_instr = 'XXX XXXXX XXX';
            instr_by_hod = 'XXXXXX XXXXXX XXXXXX';
            prefered_time = 'XXXXX';
            perfered_comm = 'XXXXX ';
            TDS=true;
            DND=false;
            LA=true;
            CIP=false;
            LAP=false;
            MB=true;
            mygain=true;
        } 
    }
    


}