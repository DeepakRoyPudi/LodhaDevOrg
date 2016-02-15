public class updateCC_email{

public static void updatccemailOnOppty(list<opportunity> oppLst){
    Map<id,string> oppvsccname=new Map<id,string>();
    Map<string,string> usernameVsemail=new Map<string,string>();
    set<string> ccnameLst=new set<string>();
    List<user> usersLst=null;
    for(opportunity o:oppLst){
        if(o.Name_of_CC_Associated__c!= null && o.Name_of_CC_Associated__c!='' && o.Name_of_CC_Associated__c!='NA'){
            oppvsccname.put(o.id,o.Name_of_CC_Associated__c);
            ccnameLst.add(o.Name_of_CC_Associated__c);
        } 
        else{
            o.CC_email__c=null;
        }   
    }
    if(ccnameLst!= null && ccnameLst.size()>0){
        for(user u:[select id,name,email,isactive from user where name IN:ccnameLst]){
            usernameVsemail.put(u.name,u.email);
        }
    }
    
    integer i=0;
    for(opportunity o:oppLst){
        
        if(oppvsccname.containskey(o.id)==true){
            o.CC_email__c=usernameVsemail.get(oppvsccname.get(o.id));
            if(o.CC_email__c==null || o.CC_email__c ==''){
                trigger.new[i].adderror('Name of CC Associated field is configured with incorrect user name: '+ oppvsccname.get(o.id));
            }    
        } 
        i++;   
    
    }
}

public static void updateCCemailOnLead(List<lead> LeadLst){
    
    Map<id,string> Leadvsccname=new Map<id,string>();
    Map<string,string> usernameVsemail=new Map<string,string>();
    set<string> ccnameLst=new set<string>();
    List<user> usersLst=null;
    for(Lead o:LeadLst){
        if(o.Attended_by_Customer_Care__c != null && o.Attended_by_Customer_Care__c !='' && o.Attended_by_Customer_Care__c !='NA'){
            Leadvsccname.put(o.id,o.Attended_by_Customer_Care__c);
            ccnameLst.add(o.Attended_by_Customer_Care__c);
        }    
        else{
            o.CC_email__c=null;
        }
    }
    if(ccnameLst!= null && ccnameLst.size()>0){
        for(user u:[select id,name,email,isactive from user where name IN:ccnameLst]){
            usernameVsemail.put(u.name,u.email);
        }
    }
    
    integer i=0;
    for(Lead o:LeadLst){
        
        if(Leadvsccname.containskey(o.id)==true){
            o.CC_email__c=usernameVsemail.get(Leadvsccname.get(o.id));
            if(o.CC_email__c==null || o.CC_email__c ==''){
                trigger.new[i].adderror('Attended by Customer Care field is configured with incorrect user name: '+ Leadvsccname.get(o.id));
            }    
        } 
        i++;   
    
    }


}


}