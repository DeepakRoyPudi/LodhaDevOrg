public class IdentifyStdFlat {
public string Preflatstatus{get; set;}
public string flatLst{get; set;}
public string FlatId{get; set;}
public string Profilename{get; set;}
public flat__c flatrecord{get; set;}
public boolean salesNmarketing{get; set;}

    public IdentifyStdFlat(ApexPages.StandardController controller) {
        
        salesNmarketing=false;        
        string Id= controller.getId();
        FlatId= ApexPages.currentPage().getParameters().get('Id');
        system.debug('-----------------'+Id);
        Profilename = [select id,name,profile.name from user where id=:Userinfo.getUserId()].profile.name;
        
        if( Profilename == 'Sales Planning' || Profilename == 'Marketing Manager' ){
            salesNmarketing=true;
        }
        
        if(Id != null){
            flatrecord=[select id,Name,Oasys_Flat_code__c,createddate,lastmodifieddate,Carpet_Area__c,CreatedByid,LastmodifiedByid,LastModifiedBy.name,Flat_No__c,Floor__c,Wing__c,Salable_Area__c,Flat_Type__c,ProjectName__c ,Status__c,View__c,Actual_Consideration__c,Stage_Completed__c,Amount_Due_Rs__c,Token_Amount_Rs__c,Base_Rate_Sq_Ft_Rs__c,
            Infrastructure_Cost_Rs__c,Floor_Rise_Sq_Ft_Rs__c,Infrastructure_Cost2_Rs__c,Premium_Sq_Ft_Rs__c,Club_Charges_Rs__c,Calculated_Total_SqFt_Rate__c,Consideration_Rs__c,Flat_Cost_Rs__c,Applicable_Waiver_Sq_Ft_Rs__c,Infrastructure_Incl_in_CV__c,
            DAM_Offer_Sq_Ft_Rs__c,Infrastructure2_Incl_in_CV__c,Total_Rate_Sq_Ft_Rs__c,Club_Charges_Incl_in_CV__c,Message__c from flat__c where id=:Id];
            Preflatstatus=flatrecord.Status__c;
            system.debug('-----------------inside If'+flatrecord+'-'+Preflatstatus);
        }
        else{
            system.debug('-----------------inside else');
        }
    }
    
    Public Pagereference save(){
        system.debug('-----------------inside save');
        if( ( Profilename == 'Sales Planning' || Profilename == 'Marketing Manager' ) && (( flatrecord.Status__c != 'OPEN' && flatrecord.Status__c != 'HOLD' && flatrecord.Status__c != 'NOT AVAILABLE' ) || ( Preflatstatus != 'OPEN' && Preflatstatus != 'HOLD' && Preflatstatus != 'NOT AVAILABLE' )) ){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'You dont have access to change this status.');
            ApexPages.addMessage(myMsg); 
            return null;            
        }   
        else{
            update flatrecord;        
        }
        Pagereference PageRef=new Pagereference('/'+FlatId);
        PageRef.setRedirect(true);
        return PageRef;    
    }

}