/* --
   Description:
   @Created by: Sudeep Dube
   @Created Date: 04/06/2015
   Description: The class Used as Extension Controller in AdminWidgetCustomization VF page
   It is bind with the admin documnet selection category for CSS2.0
   --------------------------------------------------------------------------------
   | Modified By      | Modified Date       | Version        | Description         |
   --------------------------------------------------------------------------------
   |
   --------------------------------------------------------------------------------
   |
   --------------------------------------------------------------------------------
   --*/
public class AdminDocumentTypeSelection{

    
    public List<string> leftSelectedValues{get;set;}
    
    public List<string> rightSelectedValues{get;set;}
    
    public Set<String> documentForLeft;
    public Set<String> documentForRight; 
   
    //success message
    private static final String DOCMSG='Changes saved succesfully';

   
    public AdminDocumentTypeSelection(){
         
            
    }
    
    public AdminDocumentTypeSelection(AdminWidgetCustomizationController controller) {
         
         //the below two line all the values presents in picklist and custom setting name field 
         documentForLeft=getDocumentTypesFromField();  
         documentForRight=getDocumentTypesFromCustomSetting();
         
         //filter the values the values present in custom setting data 
         //those must not be vailable in left side for selection of multipickliist 
         documentForLeft.removeAll(documentForRight); 
         
         leftSelectedValues=new List<string>();
         rightSelectedValues=new List<string>();
    }
   
    
   
    /*
    this method return all the document types values from DocumneCategory piclist 
     of Document__c object
    */
    public Set<String> getDocumentTypesFromField()
    {
        Set<String> allPicklistValues = new Set<String>();
        
        Schema.DescribeFieldResult fieldResult = Documents__c.Document_Category__c.getDescribe();
   
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple){
         
         allPicklistValues.add(f.getValue());
        }       
      return allPicklistValues ;
    }
     
   /*
   this method is return all the documnet Category values stored in Custom Setting Name : AdminDocumentCategory
   the name field stored the picklist values
   */
   public Set<String> getDocumentTypesFromCustomSetting(){
      
      Set<String> SelectedPicklistValues = new Set<String>();
        
      List<AdminDocumnetCategory__c> vle= AdminDocumnetCategory__c.getAll().values();
      
      for(AdminDocumnetCategory__c v:vle){
         
         SelectedPicklistValues.add(v.name); 
      }     
      
      return SelectedPicklistValues ;
   }
   
    public PageReference selectClick(){
       
       documentForRight.addAll(leftSelectedValues);
       documentForLeft.removeAll(leftSelectedValues);
       return null;
    }
     
    public PageReference unselectclick(){
       
       documentForRight.RemoveAll(rightSelectedValues);
       documentForLeft.addAll(rightSelectedValues);
        return null;
    }
 
    public List<SelectOption> getLeftValues(){
     
        List<SelectOption> LeftOptions = new List<SelectOption>();
      
        List<String> docLeftList=new List<String>(documentForLeft); 
      
        if(documentForLeft.size()>0){
            docLeftList.sort();
        }
        
        for(String op: docLeftList){
           LeftOptions .add(new SelectOption(op,op) );
        }
        
         
        return LeftOptions ;
    }
 
    public List<SelectOption> getRightValues(){
       
      
       
       List<SelectOption> RightOptions = new List<SelectOption>();
        
       List<String> docRightList=new List<String>(documentForRight); 
      
        if(documentForRight.size()>0){
            docRightList.sort();
        }
         
        for(String op: docRightList){
           RightOptions .add(new SelectOption(op,op) );   
        }
       
 
        return RightOptions ;
    }
    
    /*
    the action method which is called from the save button
    the method update the custom setting in not available any record then insert 
    with comma seprated values
    */ 
   public void saveDocumentType(){
     
      try {
          
            Set<string> inCustomSettingAvailableValues=getDocumentTypesFromCustomSetting();
            
            /*
            the below filter extract the values which are new in selected in 
            right side which not available in custom setting
            so this values are new to insert the, values is all ready 
            present not required to insert
            */
            Set<String>  newValuesToInsert=new Set<String>(documentForRight);
            
            newValuesToInsert.removeAll(inCustomSettingAvailableValues);
            
            List<AdminDocumnetCategory__c > newListValues=new List<AdminDocumnetCategory__c >();
            
            for(String newName:newValuesToInsert){
            
            newListValues.add(new AdminDocumnetCategory__c (name=newName) );
            
            }
            
            if(newListValues.size()>0){
            insert newListValues;
            }
            
            /*
            the below filter extract the values which are available  
            means old values and are not present right side 
            So these values have been deleted
            */
            Set<String> oldValuesToDelete=new Set<String>(inCustomSettingAvailableValues);
            
            OldValuesToDelete.removeAll(documentForRight);
            
           
            list <AdminDocumnetCategory__c > oldListValues =new list <AdminDocumnetCategory__c >();
           
            for(String nameToDel: oldValuesToDelete){
              oldListValues.add(AdminDocumnetCategory__c.getValues(nameToDel));
            }
            if(oldListValues.size()>0){
            delete oldListValues;
            }
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,DOCMSG));
            
          } 
          catch (Exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error :'+e));
            return ;
          } 
     

   }
    
}