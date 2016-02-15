@IsTest
public with sharing class pdfpopupControllerTest{
    public static testMethod void pdfpopupControllerTest(){
    

      /* 
        test.startTest();
        //  Id b_Id = ApexPages.currentPage().getParameters().get('id');
         PageReference pr;
        pdfpopupController pp= new pdfpopupController();
        pp.getItems();
        pp.getParameters('b_Id');
        
       if(pp.SelectedItem == 'Invoice_Without_ServiceTax') {
          pr=  new PageReference('/apex/Invoice_without_Service_Tax'); 
         }
     
       else {
          pr = new PageReference('/apex/Invoice_with_Service_Tax'); 
          } 
          pr.getParameters().put('id',pp.Id );
          pr.setRedirect(true);
          test.stop();           
         return pr; 
         test.stop();*/
         
         pdfpopupController pdobj=new pdfpopupController();
         pdobj.selectedItem='Invoice_Without_ServiceTax';
         pdobj.selectedItem='Invoice_With_ServiceTax';
         pdobj.selectedItem='';
         pdobj.generate_pdf();
         pdobj.getItems();
         }
        }