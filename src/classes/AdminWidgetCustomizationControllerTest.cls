/*@Created by: Deepak Pudi 
     @Created Date:  6/3/2015 -->
 
 -- ------------------------------------------------------------------------------
 | Modified By      | Modified Date       | Version        | Description         |
 --------------------------------------------------------------------------------
 |Deepak Pudi           28/4/2015            1.0          Test class for AdminWidgetCustomizationController
 --------------------------------------------------------------------------------
 |
 --------------------------------------------------------------------------------*/
@isTest
Public with sharing class AdminWidgetCustomizationControllerTest {
    
    public static testMethod void  WidgetCustomization(){
        Account acc=AdminWidgetCustomizationControllerTest.createAccount();
            insert acc;
        user user = AdminWidgetCustomizationControllerTest.createUser(acc);
            insert user;
        map < string, integer > CustomSequenceMap = new map < string, integer > (); 
            CustomSequenceMap=null;
       
        Project_Name__c PNmae =AdminWidgetCustomizationControllerTest.createProject();
            insert PNmae;
            
        WidgetInfo__c widInfo =AdminWidgetCustomizationControllerTest.CreateRmWidInfo();
            insert widInfo;
        WidgetInfo__c widInfo1 =AdminWidgetCustomizationControllerTest.CreateCSSWidInfo();
            insert widInfo1;
        WidgetInfo__c widInfo2 =AdminWidgetCustomizationControllerTest.CreateBothWidInfo();
            insert widInfo2;
        CSS2_0TabEnableDisableSetting__c tabEnableDisableSetting = new CSS2_0TabEnableDisableSetting__c(name='Disable Account Ledger');
            insert tabEnableDisableSetting;

    AdminWidgetCustomizationController  adminCustCont=new AdminWidgetCustomizationController ();
     //adminCustCont.checkSelectedValue();
     adminCustCont.setisProjectWise('false');
     adminCustCont.save();
     adminCustCont.Edit();
     adminCustCont.Cancel();
     adminCustCont.getOrders();
     adminCustCont.getProjectNames();
     adminCustCont.getAvailableUserlist();
     adminCustCont.SearchProject();
     //adminCustCont.printchk();
     adminCustCont.changeUserType();
     adminCustCont.saveTabSetting();
    
    System.debug('LSTWRAp::::' +adminCustCont.LstWrap);
   // adminCustCont.LstWrap[0].set_order=''
     //adminCustCont.operation_Index=;
      adminCustCont.update_records();
    //change order and cover custom order type project by calling upadet_racord method  
    List<Project_name__c> prlist=[select id,orderType__c from project_name__c];
     for(project_name__c pr:prlist){
       pr.orderType__c='Custom';
     }    
     update prlist;
     
     AdminWidgetCustomizationController  adminCustCont1=new AdminWidgetCustomizationController ();
    // adminCustCont1.checkSelectedValue();
     adminCustCont1.setisProjectWise('false');
     adminCustCont1.save();
     adminCustCont1.Edit();
     adminCustCont1.Cancel();
     adminCustCont1.saveTabSetting();
     adminCustCont1.getOrders();
     adminCustCont1.getProjectNames();
     adminCustCont1.getAvailableUserlist();
     adminCustCont1.SearchProject();
     //adminCustCont1.printchk();
     adminCustCont1.changeUserType();
     adminCustCont1.update_records();
     integer op_index=0;
     
     integer iterate=0;
     for(AdminWidgetCustomizationController.Wrapper wr:adminCustCont1.LstWrap){
     
     if(wr.availableuser.equalsIgnoreCase('CSS'))
     {
      op_index=iterate;
      break;
     }
     iterate=iterate+1;
     }
     //now test for CSS
      adminCustCont1.operation_index=op_index;
      //custom set order  for css
      adminCustCont1.LstWrap[adminCustCont1.operation_index].availableuser='CSS';
      adminCustCont1.update_records();
      //for Default set order
      adminCustCont1.LstWrap[adminCustCont1.operation_index].set_order='Default';
      adminCustCont1.update_records();
      adminCustCont1.LstWrap[adminCustCont1.operation_index].set_order='Custom';
      String keyseqNo;
      for(integer i=1;i<=2;i++){
              keyseqNo=adminCustCont1.LstWrap[adminCustCont1.operation_index].Pname+
                      adminCustCont1.LstWrap[adminCustCont1.operation_index].set_order+
                         adminCustCont1.LstWrap[adminCustCont1.operation_index].availableuser+
                         adminCustCont1.LstWrap[adminCustCont1.operation_index].CSSCHKWidgets[i-1].widgetName+'--->'+i+';';  
                         }
      AdminWidgetCustomizationController.UpdateRecord(keyseqNo);    
    }
    public static testMethod void  projectname1(){
    
        Account acc=AdminWidgetCustomizationControllerTest.createAccount();
        insert acc;
        
        user user = AdminWidgetCustomizationControllerTest.createUser(acc);
        insert user;
      }
    
    private static Account createAccount(){
        Account objAccount = new Account();
        objAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Booked Account').getRecordTypeId();
        objAccount.FirstName = 'Test1';
        objAccount.LastName = 'Account1';
        objAccount.CRN__c = '154215';
        objAccount.H_Mobile_No__c = '1234560789';
        objAccount.Mobile_Phone__c = '21241222';
        objAccount.Co_Applicant__c = 'test';
        return objAccount;
      }
      
      private static Project_Name__c createProject(){
        Project_Name__c projectname = new Project_Name__c();
        projectname.Name='TestProject';
        projectname.Project_Type__c='Aspirational';
        projectname.Record_Type__c='Residential';
        projectname.CurrencyIsoCode='INR';
        projectname.OrderType__c='Default';
        return projectname;
      }
      
      private static User createUser(Account a){
       list<profile> pf = [Select Id From Profile Where Name = 'Custom Overage High Volume Customer Portal' limit 1];
       system.debug('**pf**'+pf);
       
        User objUser = new User();
        contact c=[select id from contact where accountid=:a.id limit 1];
       /* objUser.ProfileID = [Select Id From Profile Where Name = 'Custom Overage High Volume Customer Portal'].id;*/
        objUser.ProfileID = pf[0].id;
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
        objUser.ContactId = c.id;
        //objUser.AccountId=a.id;

        return objUser;
        
      }  
      
       public static WidgetInfo__c CreateRmWidInfo(){
      
          WidgetInfo__c w= new WidgetInfo__c();
          w.Name= 'testWidget1';
          w.Available_For__c='RM';                
              return w;
    }
    
     public static WidgetInfo__c CreateCSSWidInfo(){
     
          WidgetInfo__c w= new WidgetInfo__c();
          w.Name= 'testWidget2';
          w.Available_For__c='CSS';               
              return w;
    }
    
     public static WidgetInfo__c CreateBothWidInfo(){
      
          WidgetInfo__c w= new WidgetInfo__c();
          w.Name= 'testWidget3';
          w.Available_For__c='Both';              
              return w;
    }
    
    public static testMethod void  CreateWidseq(){
        
        
        Account acc1=AdminWidgetCustomizationControllerTest.createAccount();
        insert acc1;
        
        Project_Name__c PNmae1 =AdminWidgetCustomizationControllerTest.createProject();
        insert PNmae1;
        
        user user1 = AdminWidgetCustomizationControllerTest.createUser(acc1);
        insert user1;
        
        WidgetInfo__c widInfo5 =AdminWidgetCustomizationControllerTest.CreateBothWidInfo();
        insert widInfo5;
        
        Widget_Sequence__c Wseq = new Widget_Sequence__c();
            Wseq.Project_Name__c=PNmae1.id;
            Wseq.Sequence_ClickCount__c=0;
            Wseq.Sequence_for__c='RM';
            Wseq.User__c=user1.id;
            Wseq.WidgetInfo__c=widInfo5.id;
            insert Wseq;
        }
        
    public static testmethod void CheckBackGroundImage(){
        CSSBackgroundImageSetting__c CBIS= new CSSBackgroundImageSetting__c(Name = 'CSS Background Image');
        insert CBIS;
        PageReference pageRef = Page.AdminWidgetCustomizationPage;
        Test.setCurrentPage(pageRef);
        AdminWidgetCustomizationController AWCC = new AdminWidgetCustomizationController();
        AWCC.isProjectWise='true';
        AWCC.save();
        
        list<CSSBackgroundImageSetting__c> BackgroundImagelist = CSSBackgroundImageSetting__c.getall().values();
        //BackgroundImagelist [0].isProjectWise
        Boolean b = Boolean.valueOf('true');
        system.assertEquals(BackgroundImagelist[0].Project_Wise__c,b);
        
        
        AWCC.isProjectWise='false';
        AWCC.save();
         AWCC.getItems();
        list<CSSBackgroundImageSetting__c> BackgroundImagelist1 = CSSBackgroundImageSetting__c.getall().values();
        Boolean f = Boolean.valueOf('false');
        system.assertEquals(BackgroundImagelist1[0].Project_Wise__c,f);
    }
    
    public static testmethod void CheckBannerTye(){
        list<Banner_Type_Setting__c> BTSList = new list<Banner_Type_Setting__c>();
        Banner_Type_Setting__c BTS = new Banner_Type_Setting__c();
            BTS.Name='% of CV Paid';
            BTS.isSelected__c=false;
            BTSList.add(BTS);
            
       Banner_Type_Setting__c BTS1 = new Banner_Type_Setting__c();
            BTS1.Name='No Banner';
            BTS1.isSelected__c=true;
            BTSList.add(BTS1);
      
       Banner_Type_Setting__c BTS2 = new Banner_Type_Setting__c();
            BTS2.Name='NRI / Non NRI';
            BTS2.isSelected__c=false;
            BTSList.add(BTS2);
          insert  BTSList;
          
       PageReference pageRef = Page.AdminWidgetCustomizationPage;
        Test.setCurrentPage(pageRef);
        AdminWidgetCustomizationController AWBanner = new AdminWidgetCustomizationController();
       AWBanner.bannerType='% of CV Paid';
       AWBanner.saveBannerType();
        AWBanner.getBannerOptions();
        AWBanner.getisProjectWise();
       list<Banner_Type_Setting__c> BTList = Banner_Type_Setting__c.getall().values();
        Boolean T = Boolean.valueOf('true');
        system.assertEquals(BTList[0].isSelected__c,T);
            
    }
      
 

}