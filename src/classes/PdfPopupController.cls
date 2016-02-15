public class PdfPopupController{

    public String selectedItem{get;set;}
   
    Id b_Id = ApexPages.currentPage().getParameters().get('id');
   /*  public string getSelectedItem(){
          return s;
     }
     public void setSelectedItem(String s){
         this.s = s;
     }*/
     

    // public string picklistvalue{get;set;}



     public list<SelectOption> getItems (){
         list<SelectOption> options = new list<SelectOption>();
         options.add(new SelectOption('','Select one'));
         options.add(new SelectOption('Invoice_Without_ServiceTax','Invoice Without ServiceTax'));
         options.add(new SelectOption('Invoice_With_ServiceTax','Invoice With ServiceTax'));
         return options;
     }

    public PageReference generate_pdf() {
      PageReference pr;
     if(SelectedItem == 'Invoice_Without_ServiceTax') {
          pr = new PageReference('/apex/Invoice_without_Service_Tax'); 
     }
     else {
          pr = new PageReference('/apex/Invoice_with_Service_Tax'); 
     }
      pr.getParameters().put('id',b_Id );
      pr.setRedirect(true);               
      return pr;
    }

 }