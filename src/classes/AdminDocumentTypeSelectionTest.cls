/* --
   Description:
   @Created by: Sudeep Dube
   @Created Date: 18/06/2015
   Description : this test class test for extension used in admin widget 
   Extension ClassName: AdminDocumentTypeSelection
   --------------------------------------------------------------------------------
   | Modified By      | Modified Date       | Version        | Description         |
   --------------------------------------------------------------------------------
   |
   --------------------------------------------------------------------------------
   |
   --------------------------------------------------------------------------------
   --*/
   
 @isTest
 (seeAllData=false) 
 
 public class AdminDocumentTypeSelectionTest {
 
 public static List<AdminDocumnetCategory__c> PicklistValues;
 public static testmethod void coverAdminDocumentTypeSelection(){
     
      AdminDocumentTypeSelectionTest.PicklistValues=new List<AdminDocumnetCategory__c>();
      //craete custom setting data category 
      List<AdminDocumnetCategory__c> allReadyExitingDocument=insertDocumentTypesFromField();
      
      AdminWidgetCustomizationController controller=new AdminWidgetCustomizationController();
      AdminDocumentTypeSelection adts=new AdminDocumentTypeSelection(controller);
      
      System.assertEquals(adts.documentForRight.size(),allReadyExitingDocument.size());
      System.assertEquals(adts.documentForLeft.size(),
                         AdminDocumentTypeSelectionTest.PicklistValues.size()-
                         allReadyExitingDocument.size()
                         );
      
      adts.getLeftValues();
      adts.getRightValues();
      adts.leftSelectedValues=new List<String>(adts.documentForLeft);
      adts.selectclick();
      adts.saveDocumentType();
    
      /*
      assert for all the picklist vaues As select and saved 
      and now stored in custom setting so that the size must be equal
      */
      
      System.assertEquals( adts.documentForRight.size(),
                           AdminDocumnetCategory__c.getAll().values().size() 
                         );
     
      
      adts.rightSelectedValues=new List<String>(adts.documentForRight);
      adts.unselectclick();
      adts.saveDocumentType();
      
      /*
      assert for all the picklist values As unselect and saved 
      and now check remove custom setting  values 
      
      */
      
      System.assertEquals( adts.documentForRight.size(),
                           AdminDocumnetCategory__c.getAll().values().size() 
                         );
    
   
 }
 
  //this method return insert document types values from DocumneCategory piclist 
    // of Document__c object
    public static  List<AdminDocumnetCategory__c> insertDocumentTypesFromField()
    {
        List<AdminDocumnetCategory__c> allPicklistValuesToInsert = new List<AdminDocumnetCategory__c>();
        
        Schema.DescribeFieldResult fieldResult = Documents__c.Document_Category__c.getDescribe();
   
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        integer i=0;
        for( Schema.PicklistEntry f : ple){
         
         if(Math.mod(i, 2)==0){
         allPicklistValuesToInsert.add(new AdminDocumnetCategory__c(name=f.getValue()));
         }
        i=i+1;
          AdminDocumentTypeSelectionTest.PicklistValues.add(new AdminDocumnetCategory__c(name=f.getValue()));
        }   

        if(allPicklistValuesToInsert.size()>0){    
         insert allPicklistValuesToInsert;
         
         
         }
      return allPicklistValuesToInsert;    
    }
 
 }