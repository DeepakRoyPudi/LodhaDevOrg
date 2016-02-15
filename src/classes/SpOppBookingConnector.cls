public class SpOppBookingConnector {

public Id Opp_id{get;set;}
public String proj_name{get;set;}
public String clust_name{get;set;}
public String wing_name{get;set;}
public decimal fno{get;set;}
String ErrorMessage = 'Please provide values for ';

public SpOppBookingConnector(ApexPages.StandardController controller) {

  Opp_id = ApexPages.currentPage().getParameters().get('oppid');
  proj_name = ApexPages.currentPage().getParameters().get('proj');
  clust_name = ApexPages.currentPage().getParameters().get('clusterid');
  wing_name = ApexPages.currentPage().getParameters().get('wid');
  String flat_number = ApexPages.currentPage().getParameters().get('flatno');
  
  if(flat_number == null || flat_number == '') {
    fno=0;
  }
  else {
    fno = decimal.valueof(flat_number);
  }
  
  if(wing_name == NULL || wing_name == ''){
    ErrorMessage += 'Wing, ';
  }
  if(clust_name == NULL || clust_name == ''){
    ErrorMessage += 'Cluster, ';
  }
  if(fno == 0){
    ErrorMessage += 'Flat No';
  }
  ErrorMessage = ErrorMessage.removeEnd(', ');
}

public PageReference goToBooking(){
  String fid;
  proj_name  = proj_name.replace('+', ' ');
  
  List<Flat__c> flatlist = new List<Flat__c>();
  List<Booking_Information__c> booking = new List<Booking_Information__c>();
  
  flatlist = [select Id, Wing__r.Project__c,Wing__r.name, Wing__r.Cluster_hidden__c from Flat__c where 
               Wing__r.Project__c=:proj_name and Wing__r.name =:wing_name and 
               Wing__r.Cluster_hidden__c =:clust_name and Flat_No__c =:fno];
  List<Project_name__c> projectLst= [select name,IsSp2__c from Project_name__c where name=:proj_name];             
  booking = [select Id from Booking_Information__c Where Name_Of_Opportunity__c=:Opp_id and Booking_Status__c != 'CANCELLATION' and InActive__c = FALSE];   
 
  if(flatlist.size() > 0 && booking.size() > 0) {
    for(Flat__c f:flatlist){
      fid = f.id;
    }
    
    if(projectLst != null && projectLst.size() == 1 && projectLst[0].IsSp2__c == true){
        PageReference pr = new PageReference('/apex/Sp2Booking'); 
        pr.getParameters().put('fid',fid); 
        pr.getParameters().put('oppid',String.ValueOf(Opp_id));
        pr.setRedirect(true);               
        return pr;
    }
    else if(projectLst != null && projectLst.size() == 1 && projectLst[0].IsSp2__c == false){
        PageReference pr = new PageReference('/apex/SpBookInventory'); 
        pr.getParameters().put('fid',fid); 
        pr.getParameters().put('oppid',String.ValueOf(Opp_id));
        pr.setRedirect(true);               
        return pr;    
    }
   else{
       ErrorMessage+='Project name is invalid';
       ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ErrorMessage));
       return null;
   }
  }
  else if(booking.size() == 0){
    PageReference pr = new PageReference('/apex/SpSearchInventory'); 
    pr.getParameters().put('proj',proj_name); 
    pr.getParameters().put('oppid',String.ValueOf(Opp_id));
    pr.setRedirect(true);               
    return pr;
  }else{
      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, ErrorMessage));
      return null;
  }
}

}