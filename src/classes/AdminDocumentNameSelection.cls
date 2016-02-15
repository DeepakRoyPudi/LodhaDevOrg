/* --
Description:
@Created by:Aditi Mulmule
@Created Date: 16/07/2015
Description: The class is Used as Extension Controller in AdminWidgetCustomization VF page
It is bind with the admin document name selection for CSS2.0
--------------------------------------------------------------------------------
| Modified By      | Modified Date       | Version        | Description         |
--------------------------------------------------------------------------------
|
--------------------------------------------------------------------------------
|
--------------------------------------------------------------------------------
--*/


public class AdminDocumentNameSelection{
    public List<string> leftSelectedNameValues{get;set;}
    public List<string> rightSelectedNameValues{get;set;}
    @TestVisible private Set<String> documentForLeft;
    @TestVisible private Set<String> documentForRight; 
    //success message
    private static final String DOCMSG='Changes saved succesfully';
    public AdminDocumentNameSelection(){
    }
    
    public AdminDocumentNameSelection(AdminWidgetCustomizationController controller) {
       
        documentForLeft= new Set<String>();
        documentForRight = new Set<String>(); 
        documentForLeft = getDocumentNameFromMasterListCustomSetting();  
        documentForRight = getDocumentNamesFromCustomSetting();
        // Filter the values the values present in custom setting data 
        // Those must not be vailable in left side for selection of multipickliist 
        documentForLeft.removeAll(documentForRight); 
        
        leftSelectedNameValues = new List<string>();
        rightSelectedNameValues = new List<string>();
    }
    /* This method returns all the document name values from MasterDocumentList__c  Custom Setting
     DocumentNamesList*/
    public set<String> getDocumentNameFromMasterListCustomSetting()
    {
        set<String> documentNameMasterList = new set<String>();
        list<MasterDocumentList__c> masterListDocument = MasterDocumentList__c.getAll().values();
        
        for(MasterDocumentList__c master_doc : masterListDocument){
            
            documentNameMasterList.add(master_doc.Document_Name__c); 
        }     
        return documentNameMasterList ;
    }
    
    /*This method returns all the document Name values stored in Custom Setting AdminDocumentName__c*/
    public Set<String> getDocumentNamesFromCustomSetting(){
        
        Set<String> selectedDocumentNames = new Set<String>();
        
        List<AdminDocumentName__c> docnames = AdminDocumentName__c.getAll().values();
      
        for(AdminDocumentName__c doc_name : docnames){
            
            selectedDocumentNames.add(doc_name.Document_Name__c); 
        }     
        
        return selectedDocumentNames;
    }
    // For left selected values
    public PageReference selectClickName(){
        
        documentForRight.addAll(leftSelectedNameValues);
        documentForLeft.removeAll(leftSelectedNameValues);
        return null;
    }
    // For right selected values
    public PageReference unSelectClickName(){
        
        documentForRight.RemoveAll(rightSelectedNameValues);
        documentForLeft.addAll(rightSelectedNameValues);
        return null;
    }
    // Method to get list of document names available for selection
    public List<SelectOption> getLeftNameValues(){
        
        List<SelectOption> leftOptions = new List<SelectOption>();
        
         List<String> docLeftList=new List<String>(documentForLeft); 
      
        if(documentForLeft.size()>0){
            docLeftList.sort();
        }
        
        for(String op: docLeftList){
            leftOptions.add(new SelectOption(op,op) );
        }
        
        return leftOptions ;
    }
    // Method to get list of document names selected
    public List<SelectOption> getRightNameValues(){
        
        List<SelectOption> rightOptions = new List<SelectOption>();
        
        List<String> docRightList=new List<String>(documentForRight); 
      
        if(documentForRight.size()>0){
            docRightList.sort();
        }
        
        for(String op: docRightList){
            rightOptions.add(new SelectOption(op,op) );   
        }
        return rightOptions ;
    }
    
    /* The method updates the custom setting in not available any record then insert 
       with comma seprated values */ 
    public void saveDocumentName(){
        try {
            
                 List<AdminDocumentName__c> listOldDocNames=AdminDocumentName__c.getAll().values();
                 
                 if(listOldDocNames.size()>0){
                    delete  listOldDocNames;      
                 }
                 
                 List<AdminDocumentName__c> listNewDocNames=new list<AdminDocumentName__c>();
                 Integer count =1;
                 for(String docName : documentForRight){
                    
                    String countStr=String.valueOf(count);
                    
                    AdminDocumentName__c selectDocToEnable
                                         =new AdminDocumentName__c(name=countStr,Document_Name__c=docName);
                    listNewDocNames.add(selectDocToEnable);                     
                    count=count+1;                     
                 }
                 
                if(listNewDocNames.size()>0){
                
                    insert listNewDocNames;  
                
                }
           
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,DOCMSG));
        } 
        catch (Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error :'+e));
            return ;
        } 
    }
    
}