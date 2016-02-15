/*@Created by: Deepak Pudi 
     @Created Date:  6/3/2015 -->
 
 -- ------------------------------------------------------------------------------
 | Modified By      | Modified Date       | Version        | Description         |
 --------------------------------------------------------------------------------
 |Deepak Pudi           28/4/2015            1.0           Admin Customization for Widgets,BackGroundImages and Banner.
 |Deepak Pudi           20/5/2015            1.1           Code induntation changes.
 --------------------------------------------------------------------------------
 |Sudeep Dube			24/07/2015			 1.1			Update Error Message Severity 
 ------------------------------------------------------------------------------ --*/
public with sharing class AdminWidgetCustomizationController {
    
    //Properties
    public integer operation_Index {get;set;}
    public String selectedValue{get;set;}
   
    //For Project  search 
    public list < string > Prjnames {get;set;}
    list < Project_Name__c > PNamesLst {get;set;}
    public string SearchProject{get;set;}
    public list < Wrapper > LstWrap{get;set;}
    public map<string,id> mapProjectNameWidgetNamewithRecordID_enabledisableobject;
    public String currentRecordName{get;set;}
    @testVisible  public String bannerType  {get; set;}
    public static Map<string,id> MapofWidSequesceRecordID;
    
     //list of available widgets in default and dynamic order 
     public list<Widget_Sequence__c > widgetsAvailableDefaultDyanmic_RM;
     public list<Widget_Sequence__c > widgetsAvailableDefaultDyanmic_CSS;
     
     //map of enable disable widgets for RM and CSS 
     public Map<string,boolean> rm_widgets_enable_disable;
     public Map<string,boolean> css_widgets_enable_disable;
    
    //map of project ID with list of widgets sequence record in descending order for RM in Custom Order Type
    public Map<id,list<Widget_Sequence__c >> MapofProjectToWidgetsRMCustom;
    //map of project ID with list of widgets sequence record in descending order for CSS in Custom Order Type
    public Map<id,list<Widget_Sequence__c >> MapofProjectToWidgetsCSSCustom; 
    
    public List<CSS2_0TabEnableDisableSetting__c> tabEnableDisableSetting {get;set;}
    
    @testVisible private String isProjectWise ;
    //Private Variables 
    private List<CSSBackgroundImageSetting__c> backgroundImgSetting;
    private static final String INFOMSG = 'Changes saved succesfully ';
    private list<Banner_Type_Setting__c> selectedRecords;
    
    //Constants
    private static final string ISPROJECTWISE_TRUE = 'true';
    private static final string ISPROJECTWISE_FALSE = 'false';
    private static final string RM = 'RM';
    private static final string CSS = 'CSS';
    private static final string DEFAULTD ='Default';
    private static final string CUSTOM='Custom';
    private static final string DYNAMIC='Dynamic';

    public List<SelectOption> getBannerOptions() {
        List<SelectOption> options = new List<SelectOption>(); 
        for(Banner_Type_Setting__c  bts : Banner_Type_Setting__c.getall().values()) {
            options.add(new SelectOption(bts.Name,bts.Name));   
        }
        return options; 
    }
    public String getisProjectWise() {
        return isProjectWise;
    }
    public void setisProjectWise(String isProjectWise) { 
        this.isProjectWise = isProjectWise;
    }
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption(ISPROJECTWISE_FALSE,DEFAULTD)); 
        options.add(new SelectOption(ISPROJECTWISE_TRUE,'Project Wise')); 
        return options; 
    }
   
    
     //for Available Widgets
    public List < SelectOption > UserOptions{get;set;}
    list < WidgetInfo__c > avialableRMWidgets;
    list < WidgetInfo__c > avialableCSSWidgets;
    
    public AdminWidgetCustomizationController() {
        SearchProject = '';
        tabEnableDisableSetting = CSS2_0TabEnableDisableSetting__c.getall().values();
        backgroundImgSetting = CSSBackgroundImageSetting__c.getall().values();
        if(backgroundImgSetting.size() > 0) {
            if(backgroundImgSetting[0].Project_Wise__c) 
                isProjectWise = ISPROJECTWISE_TRUE;
            else
                isProjectWise = ISPROJECTWISE_FALSE;
        }
        selectedRecords = new list<Banner_Type_Setting__c>();
        for( Banner_Type_Setting__c setting: Banner_Type_Setting__c.getall().values()) {
            if(setting.isSelected__c) {
                bannerType = setting.Name;
                selectedRecords.add(setting);   
            }
        }
        MapofWidSequesceRecordID=AdminWidgetCustomizationController.getCustomRecordTypeWidgetSeq();
       //project level list of widgets for RM Customize 
      list<Project_name__c> ProjectListWidSeqRMCustom=[select id,name ,(select id,WidgetInfo__r.name , Sequence_for__c,Sequence_ClickCount__c from Widget_Sequences__r where Sequence_for__c=:RM and recordtype.name=:CUSTOM  order by Sequence_ClickCount__c ASC) from Project_name__c ];
      MapofProjectToWidgetsRMCustom =new Map<id,list<Widget_Sequence__c >>();
      for(Project_Name__c projectWidgetsseq : ProjectListWidSeqRMCustom)
      {
       MapofProjectToWidgetsRMCustom.put(projectWidgetsseq.id,projectWidgetsseq.Widget_Sequences__r);
      }
       //project level list of widgets  for CSS Customize   
       list<Project_name__c> ProjectListWidSeqCSSCustom=[select id,name ,(select id,WidgetInfo__r.name , Sequence_for__c,Sequence_ClickCount__c from Widget_Sequences__r where Sequence_for__c=:CSS and recordtype.name=:CUSTOM  order by Sequence_ClickCount__c ASC) from Project_name__c ];
       MapofProjectToWidgetsCSSCustom =new Map<id,list<Widget_Sequence__c >>();
       for(Project_Name__c projectWidgetsseq : ProjectListWidSeqCSSCustom)
      {
       MapofProjectToWidgetsCSSCustom.put(projectWidgetsseq.id,projectWidgetsseq.Widget_Sequences__r);
      }
       //list of widgets at Org Level RM Default and Dynamic
        widgetsAvailableDefaultDyanmic_RM=[select id,WidgetInfo__r.name , Sequence_for__c,Sequence_ClickCount__c from Widget_Sequence__c where Sequence_for__c=:RM and recordtype.name=:DEFAULTD  order by Sequence_ClickCount__c ASC] ;   
       //list of widgets at Org Level CSS Default and Dynamic
       widgetsAvailableDefaultDyanmic_CSS=[select id,WidgetInfo__r.name , Sequence_for__c,Sequence_ClickCount__c from Widget_Sequence__c where Sequence_for__c=:CSS and recordtype.name=:DEFAULTD  order by Sequence_ClickCount__c ASC] ;           
      //map of project id+widget id with boolean enable or not RM
        map<string,map<string,boolean>> rm_css_widgets_enable_disable=new map<string,map<string,boolean>>();
        
        rm_css_widgets_enable_disable=get_rm_css_widgets_enable_disable();
        
        rm_widgets_enable_disable=new Map<string,Boolean>();
        if(rm_css_widgets_enable_disable.containsKey(RM))
        rm_widgets_enable_disable=rm_css_widgets_enable_disable.get(RM);
        
        css_widgets_enable_disable=new Map<string,Boolean>();
        if(rm_css_widgets_enable_disable.containsKey(CSS))
        css_widgets_enable_disable=rm_css_widgets_enable_disable.get(CSS);
        
        createWrapperList('');
        }
   
    /* Save method to save Backgrounf image preference, wheteher it is project wise or Default.
     * The preference is stored in a Custom setting
     */
    public void save() {
        CSSBackgroundImageSetting__c objCS;
        if(backgroundImgSetting.size() > 0)
            objCS = backgroundImgSetting[0];
        
        if(objCS == null)
            objCS = new CSSBackgroundImageSetting__c(Name = 'CSS Background Image');
        
        if(isProjectWise == ISPROJECTWISE_TRUE)
            objCS.Project_Wise__c = true;
        else    
            objCS.Project_Wise__c = false;
            
        try {
            upsert objCS;
            
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,INFOMSG));
            
        } catch (Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error :'+e));
            return;
        }
    }
    
    public void saveTabSetting() {
        try {
            upsert tabEnableDisableSetting;
            
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,INFOMSG));
            
        } catch (Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error :'+e));
            return;
        }
           
    }
    
    /* Save method to save Banner type preference 
     */
    public void saveBannerType() {
        for(Banner_Type_Setting__c selectedRec : selectedRecords ) {
            selectedRec.isSelected__c = false;
        }
        update selectedRecords;
        selectedRecords.clear();
        Banner_Type_Setting__c  setting  =  Banner_Type_Setting__c.getInstance(bannerType);
        setting.isSelected__c = true;
        update setting;
        for( Banner_Type_Setting__c bannerSetting: Banner_Type_Setting__c.getall().values()) {
            if(setting.isSelected__c) {
                //bannerType = bannerSetting.Name;
                selectedRecords.add(bannerSetting); 
            }
        }
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,INFOMSG));
    }
    public void createWrapperList(string searchproj){
        searchproj=searchproj.Trim();
        searchproj+='%';
        operation_Index = 0;
        PNamesLst = new list < Project_Name__c > ();
        LstWrap = new list < Wrapper > ();
        PNamesLst = [select Name, OrderType__c,id from Project_Name__c Where Name like:searchproj];
        integer index = 0;
        for (Project_Name__c Plist: PNamesLst) {
            wrapper wrp = new wrapper();
            wrp.Pname = Plist.Name;
            wrp.pid=Plist.id;
            wrp.set_order = Plist.OrderType__c;
            wrp.isEdit = false;
            wrp.List_index = index;
            wrp.availableuser = RM;
            wrp.isRM = true;
            wrp.RMCHKWidgets = new list < WidgetCheckWrapper > ();
            //for RM widget List for Default and Dynamic Seq.  
            for (Widget_Sequence__c  w_seq: widgetsAvailableDefaultDyanmic_RM) {
                String keyString=Plist.name+w_seq.WidgetInfo__r.name;
                
                if(rm_widgets_enable_disable.containsKey(KeyString)){
                boolean b=rm_widgets_enable_disable.get(KeyString);
                
                WidgetCheckWrapper wcp = new WidgetCheckWrapper(b,w_seq.WidgetInfo__r.name,w_seq.id);
                wrp.RMCHKWidgets.add(wcp);
                }
            }
                       //for CSS widgets list for Default and Dynamic Seq.  
            wrp.CSSCHKWidgets = new list < WidgetCheckWrapper > ();
            for (Widget_Sequence__c w_seq: widgetsAvailableDefaultDyanmic_CSS) {
               
                String keyString=Plist.name+w_seq.WidgetInfo__r.name;
                
                if(css_widgets_enable_disable.containsKey(KeyString)){ 
                boolean b=css_widgets_enable_disable.get(KeyString);
               
                WidgetCheckWrapper wcp = new WidgetCheckWrapper(b, w_seq.WidgetInfo__r.name,w_seq.id);
                wrp.CSSCHKWidgets.add(wcp);
                }
            }
            
            //for RM widget List for Customize Seq.
              wrp.RMCHKWidgets_Customize =new list < WidgetCheckWrapper >();
              //public list < WidgetCheckWrapper > CSSCHKWidgets_Customize {get;set;}
            
              if(MapofProjectToWidgetsRMCustom != null && MapofProjectToWidgetsRMCustom.containsKey(Plist.id))
                  for(Widget_Sequence__c w_seq : MapofProjectToWidgetsRMCustom.get(Plist.id)){
                   
                    String keyString=Plist.name+w_seq.WidgetInfo__r.name;
                    
                    if(rm_widgets_enable_disable.ContainsKey(KeyString)){
                    boolean b=rm_widgets_enable_disable.get(KeyString);
     
                    WidgetCheckWrapper wcp = new WidgetCheckWrapper(b, w_seq.WidgetInfo__r.name,w_seq.id);
                    wrp.RMCHKWidgets_Customize.add(wcp);
                    }  
                  } 
              
               //for CSS widget List for Customize Seq.
              wrp.CSSCHKWidgets_Customize =new list < WidgetCheckWrapper >();
            
             if(MapofProjectToWidgetsCSSCustom != null && MapofProjectToWidgetsCSSCustom.containsKey(Plist.id))
              for(Widget_Sequence__c w_seq : MapofProjectToWidgetsCSSCustom.get(Plist.id)){
               
                String keyString=Plist.name+w_seq.WidgetInfo__r.name;
                
                if(css_widgets_enable_disable.containsKey(KeyString)){
                boolean b=css_widgets_enable_disable.get(KeyString);
                
                WidgetCheckWrapper wcp = new WidgetCheckWrapper(b, w_seq.WidgetInfo__r.name,w_seq.id);
               
                 wrp.CSSCHKWidgets_Customize .add(wcp);
                }  
              } 
              
            LstWrap.add(wrp);
            index = index + 1;
        }

    }
    
    //the method is used to create rm css widgets with their respective boolean value 
    public map<string,map<string,boolean>> get_rm_css_widgets_enable_disable(){
           map<string,map<string,boolean>> rmcss_enabledisable_widgets=new Map<string,map<string,boolean>>();
           map<string,boolean> rmenable_disable_widgets=new map<string,boolean>();
           map<string,boolean> cssenable_disable_widgets=new map<string,boolean>();
           mapProjectNameWidgetNamewithRecordID_enabledisableobject= new map<string,id>();
             for(EnableDisable_widgets__c edw:[select id,Project_Name__r.name,WidgetInfo__r.name,isEnableForRM__c,isEnableForCustomer__c from EnableDisable_widgets__c])
             {
             string keystring=edw.Project_Name__r.name+edw.WidgetInfo__r.name;
              rmenable_disable_widgets.put(keyString,edw.isEnableForRM__c);
              cssenable_disable_widgets.put(keyString,edw.isEnableForCustomer__c);   
              mapProjectNameWidgetNamewithRecordID_enabledisableobject.put(keyString,edw.id);                           
             }        
       Map<string,map<string,boolean>> rm_css_map_enable_disable=new map<string,map<string,boolean>>();
       rm_css_map_enable_disable.put(RM,rmenable_disable_widgets);
       rm_css_map_enable_disable.put(CSS,cssenable_disable_widgets);
       return rm_css_map_enable_disable;
      }
    public Void Edit() {
        LstWrap[operation_Index].isEdit = true;
      }
     public void Cancel() {
       
        createWrapperList('');
      
    }
     public List < SelectOption > getOrders() {
        List < SelectOption > options = new List < SelectOption > ();
        options.add(new SelectOption(DEFAULTD, '       '));
        options.add(new SelectOption(DYNAMIC, '       '));
        options.add(new SelectOption(CUSTOM, '       '));
        return options;
    }
    public list < string > getProjectNames() {
        Prjnames = new list < string > ();
        for (Project_Name__c p: [select Name from Project_Name__c]) {
            Prjnames.add(p.Name);
        }
        return Prjnames;
    }
    public List < SelectOption > getAvailableUserlist() {
        List < SelectOption > UserOptions = new List < SelectOption > ();
        UserOptions.add(new SelectOption(RM, RM));
        UserOptions.add(new SelectOption(CSS, CSS));
        return UserOptions;
    }

    Public Void SearchProject() {
        createWrapperList(SearchProject);
    }
    
    public void changeUserType() {
        if (LstWrap[operation_Index].availableuser.equalsIgnoreCase(RM)) {
            LstWrap[operation_Index].isRM = true;
        }
        IF(LstWrap[operation_Index].availableuser.equalsIgnoreCase(CSS)) {
            LstWrap[operation_Index].isRM = false;
        }

    }
   public pagereference update_records(){
            Project_Name__c project_to_update_order=new Project_Name__c ();
            project_to_update_order.id= LstWrap[operation_index].pid;
            project_to_update_order.OrderType__c= LstWrap[operation_index].set_order;
            update project_to_update_order;      
            
   
    //check update for RM
    if(LstWrap[operation_index].availableuser.equalsIgnoreCase(RM)){
     list<EnableDisable_widgets__c> list_EnableDisable_widgets =new list<EnableDisable_widgets__c>();
    
    //check update by the default or dynamic order..
    if(LstWrap[operation_index].set_order.equalsIgnoreCase(DEFAULTD) || LstWrap[operation_index].set_order.equalsIgnoreCase(DYNAMIC)){
    for(WidgetCheckWrapper wcp:LstWrap[operation_index].RMCHKWidgets){
    
      String keystring=LstWrap[operation_index].pname+wcp.widgetName;
      
      if(mapProjectNameWidgetNamewithRecordID_enabledisableobject.containsKey(keystring))     
      {
      Id enabel_disable_record_id=mapProjectNameWidgetNamewithRecordID_enabledisableobject.get(keystring);           
      EnableDisable_widgets__c ed=new EnableDisable_widgets__c();
      ed.id=enabel_disable_record_id;
      ed.isEnableForRM__c=wcp.chkb;
      list_EnableDisable_widgets.add(ed);
      }
     }
    } 
    else{
       //check update by the custom order..
    if(LstWrap[operation_index].set_order.equalsIgnoreCase(CUSTOM)){
       for(WidgetCheckWrapper wcp:LstWrap[operation_index].RMCHKWidgets_Customize){
    
      String keystring=LstWrap[operation_index].pname+wcp.widgetName;
      
      if(mapProjectNameWidgetNamewithRecordID_enabledisableobject.containsKey(keystring)) {
      Id enabel_disable_record_id=mapProjectNameWidgetNamewithRecordID_enabledisableobject.get(keystring);           
      EnableDisable_widgets__c ed=new EnableDisable_widgets__c();
      ed.id=enabel_disable_record_id;
      ed.isEnableForRM__c=wcp.chkb;
      list_EnableDisable_widgets.add(ed);
      }
     }
    }}     
    update list_EnableDisable_widgets;
   }
   
   //check update for CSS equalsIgnoreCase
    if(LstWrap[operation_index].availableuser.equalsIgnoreCase(CSS)){
     list<EnableDisable_widgets__c> list_EnableDisable_widgets =new list<EnableDisable_widgets__c>();
    
    //check update by the default or dynamic order..
    if(LstWrap[operation_index].set_order.equalsIgnoreCase(DEFAULTD) || LstWrap[operation_index].set_order.equalsIgnoreCase(DYNAMIC)){
    for(WidgetCheckWrapper wcp:LstWrap[operation_index].CSSCHKWidgets){
    
      String keystring=LstWrap[operation_index].pname+wcp.widgetName;
      
      if(mapProjectNameWidgetNamewithRecordID_enabledisableobject.containsKey(keystring)){
      Id enabel_disable_record_id=mapProjectNameWidgetNamewithRecordID_enabledisableobject.get(keystring);           
      EnableDisable_widgets__c ed=new EnableDisable_widgets__c();
      ed.id=enabel_disable_record_id;
      ed.isEnableForCustomer__c=wcp.chkb;
      list_EnableDisable_widgets.add(ed);
      }
     }
    }
    else{
        //check update by the custom order..
      if(LstWrap[operation_index].set_order.equalsIgnoreCase(CUSTOM)){
       
        for(WidgetCheckWrapper wcp:LstWrap[operation_index].CSSCHKWidgets_Customize){
    
      String keystring=LstWrap[operation_index].pname+wcp.widgetName;
      
      if(mapProjectNameWidgetNamewithRecordID_enabledisableobject.containsKey(keystring)){
      Id enabel_disable_record_id=mapProjectNameWidgetNamewithRecordID_enabledisableobject.get(keystring);           
      EnableDisable_widgets__c ed=new EnableDisable_widgets__c();
      ed.id=enabel_disable_record_id;
      ed.isEnableForCustomer__c=wcp.chkb;
      list_EnableDisable_widgets.add(ed);
      }
     }  
    }}
    update list_EnableDisable_widgets;
   }
   
    PageReference pf=ApexPages.currentPage();
    pf.setRedirect(true);
    return pf;
 }  
 
 
    //methods for mapping wiidgetseq record id to project,order,usertype,widget string it will use for the update that record in widget sequence object
     public static map<string,id> getCustomRecordTypeWidgetSeq(){
       list <Widget_Sequence__c> widgetSeqList = [select id,Project_Name__r.name,recordtype.name,Sequence_for__c,WidgetInfo__r.name  from Widget_Sequence__c where recordType.name=:CUSTOM];
       Map <String,id> keyStringtowidgetSeqReorcdID= new Map<String,id>();
       for(Widget_Sequence__c  w_s:widgetSeqList ){
         String keyString =w_s.Project_Name__r.name+w_s.recordtype.name+w_s.Sequence_for__c+w_s.WidgetInfo__r.name; 
         Id idvalue=w_s.id;
         keyStringtowidgetSeqReorcdID.put(keyString , idvalue);
       }
      return  keyStringtowidgetSeqReorcdID;
     } 
     
 
 
    @RemoteAction
    public static Boolean UpdateRecord(string KeyWithSeqNO ) {
       
        list<Widget_Sequence__c > listwidgetSeqtoUpdate=new list<Widget_Sequence__c >();
      
        map<String,id> mapStringID =  AdminWidgetCustomizationController.getCustomRecordTypeWidgetSeq();
        for(String splitstrings:KeyWithSeqNO.split(';')){
        list<string> keyValuePair=splitstrings.split('--->');
      
         Widget_Sequence__c w_s=new Widget_Sequence__c ();
         
         if(mapStringID.containsKey(keyvaluePair[0])){
         w_s.id=mapStringID.get(keyvaluePair[0]);
         w_s.Sequence_ClickCount__c=Decimal.valueOf(keyvaluePair[1]);
         listwidgetSeqtoUpdate.add(w_s);
         }
       }
       
       if(listwidgetSeqtoUpdate.size()>0)
       update listwidgetSeqtoUpdate;
       
       return true;
    }
    public Class Wrapper {
        //project name with id to update
        public string Pname {get;set;}
        public ID pid{get;set;}
        //selected radio option as order     
        public string set_order {get;set;}
        //row is editable or not
        public Boolean isEdit {get;set;}
        //index of list
        public Integer List_index {get;set;}
        //select user type from custom picklist(RM or CSS) 
        Public string availableuser{get;set;}
        //Rm and CSS widget with checkbox object create by wrapper class WidgetCheckWrapper default and dynamic
        public list < WidgetCheckWrapper > RMCHKWidgets {get;set;}
        public list < WidgetCheckWrapper > CSSCHKWidgets {get;set;}
        Public boolean isRM {get;set;}
        public String radioValue {get;set;}
        //RM CSS widgets list customize part
        public list < WidgetCheckWrapper > RMCHKWidgets_Customize {get;set;}
        public list < WidgetCheckWrapper > CSSCHKWidgets_Customize {get;set;}
        
        public Wrapper() {
        }
    }

    public class WidgetCheckWrapper {
        public boolean chkb {get;set;}
        public String widgetName{get;set;}
        public Id widgetsequece_recordID{get;set;}
        public WidgetCheckWrapper(boolean chkb, String widgetName,id idvalue) {
            this.chkb = chkb;
            this.widgetName = widgetName;
            widgetsequece_recordID=idvalue;
        }

    }
}