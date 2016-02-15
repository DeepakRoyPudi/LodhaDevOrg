/* --
   Description:
   @Created by:Aditi Mulmule
   @Created Date: 16/07/2015
   Description: Test class for AdminDocumentNameSelection
   --------------------------------------------------------------------------------
   | Modified By      | Modified Date       | Version        | Description         |
   --------------------------------------------------------------------------------
   |
   --------------------------------------------------------------------------------
   |
   --------------------------------------------------------------------------------
   --*/


@isTest (SeeAlldata= false)
public class AdminDocumentNameSelectionTest {
    public static List<AdminDocumentName__c> masterLabelListValues;
    
   public static testMethod void nameSelectionTest () {
      AdminDocumentNameSelectionTest.masterLabelListValues=new List<AdminDocumentName__c>();
      //craete custom setting data category 
      List<AdminDocumentName__c> allReadyExitingDocument = insertDocumentNamesFromMasterListCustomSetting();
      
      AdminWidgetCustomizationController controller = new AdminWidgetCustomizationController();
      AdminDocumentNameSelection docNameObj = new AdminDocumentNameSelection(controller);
      
      System.assertEquals(docNameObj.documentForRight.size(),allReadyExitingDocument.size());
      System.assertEquals(docNameObj.documentForLeft.size(),
                         AdminDocumentNameSelectionTest.masterLabelListValues.size()-
                         allReadyExitingDocument.size()
                         );
      
      docNameObj.getLeftNameValues();
      docNameObj.getRightNameValues();
      docNameObj.leftSelectedNameValues = new List<String>(docNameObj.documentForLeft);
      docNameObj.selectClickName();
      docNameObj.saveDocumentName();
    
      /*
      assert for all the master label values As select and saved 
      and now stored in custom setting so that the size must be equal
      */
      
      System.assertEquals( docNameObj.documentForRight.size(),
                           AdminDocumentName__c.getAll().values().size() 
                         );
      docNameObj.rightSelectedNameValues=new List<String>(docNameObj.documentForRight);
      docNameObj.unSelectClickName();
      docNameObj.saveDocumentName();
      /*
      assert for all the master label values As unselect and saved 
      and now check remove custom setting  values 
      
      */
      System.assertEquals( docNameObj.documentForRight.size(),
                           AdminDocumentName__c.getAll().values().size() 
                         );
    }
    
    //this method return insert document Name values from Document Name master label  
    public static  List<AdminDocumentName__c> insertDocumentNamesFromMasterListCustomSetting() {
        List<AdminDocumentName__c> allNameValuesToInsert = new List<AdminDocumentName__c>();
        
        set<String> documentNameMasterList = new set<String>();
   
        list <MasterDocumentList__c> masterList = getMasterList();
        integer i=0;
        for( MasterDocumentList__c masterObj : masterList){
        
            if(Math.mod(i, 2)==0){
                allNameValuesToInsert.add(new AdminDocumentName__c(name = masterObj.name,Document_Name__c= masterObj.Document_Name__c ));
            }
            i=i+1;
            AdminDocumentNameSelectionTest.masterLabelListValues.add(new AdminDocumentName__c(name= masterObj.name,Document_Name__c= masterObj.Document_Name__c));
        }         

        if(allNameValuesToInsert.size()>0){    
             insert allNameValuesToInsert;
         
         }
        return allNameValuesToInsert;    
    }
    
    public static list<MasterDocumentList__c> getMasterList() {
        list <MasterDocumentList__c> masterList = new list<MasterDocumentList__c>();
        for(integer i=0;i<10;i++)
        {
           MasterDocumentList__c mastObj = new MasterDocumentList__c();
           mastObj.Name='Test'+i;
           mastObj.Document_Name__c = 'Document'+i;
           masterList.add(mastObj);
        }  
        insert masterList;
        return masterList;
    }
           
    
}