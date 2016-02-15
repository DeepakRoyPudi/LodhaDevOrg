public class SearchAccountClass {
Public string Accvar{get; set;}
public string Accvarhidden {get; set;}
public boolean flag {get; set;}
public List<Account> Acclst{get; set;}
public integer NoOfAccounts{get; set;}
public boolean isBSports{get; set;}
public string tittle{get; set;}
Public boolean norecordsflag {get; set;}
Public boolean pageblockflag {get; set;}
public boolean buttonchange {get; set;}

public boolean CCprofileRender{get; set;}
public boolean CCOperatorProfileRender{get; set;}
public boolean OtherProfileRender{get; set;}

public string linkvar {get; set;}

Public static boolean bname{get; set;}
Public static boolean bproject{get; set;}
Public static boolean bcluster{get; set;}
Public static boolean bwing{get; set;}
Public static boolean bflatno{get; set;}
Public static boolean bmobileno{get; set;}
Public static boolean bcrn{get; set;}
Public static boolean bloyaltyid{get; set;}
Public static boolean bownername{get; set;}

public boolean bname1{get; set;}
private string userprofilename;

public SearchAccountClass() {
    tittle='Accounts';  
    NoOfAccounts=0;  
    pageblockflag = false; 
    flag=false; 
    SearchAccountClass.bname=false;
    SearchAccountClass.Bcrn=false; 
    buttonchange=false;  
    userprofilename=[select id,name,profile.name from user where id=:UserInfo.getUserId()].profile.name;
    profilerender();
}

public pagereference Search(){
    try{
        buttonchange=false;
        string NewAccvar;
        norecordsflag=false;
        pageblockflag = false;        
        SearchAccountClass.bname=false;
        SearchAccountClass.Bcrn=false;         
        flag=false;
        Acclst=null;
        NoOfAccounts=0;      
        profilerender();                
        List<string> Splitted=new List<string>();
        system.debug('!!!!!!!!!!!string first'+Accvar);
        NewAccvar=Accvar.Normalizespace();
        NewAccvar=string.escapeSingleQuotes(NewAccvar);
        system.debug('!!!!!!!!!!!string initial'+NewAccvar);
        integer i;
        list<boolean> j=new list<boolean>();
        for(i=0;i<NewAccvar.length();i++){
            if(NewAccvar.substring(i,i+1).contains('*')==true){
                j.add(true);
                system.debug('!!!!!!!!!!!j111'+NewAccvar.substring(i,i+1)+'-'+j);
            }        
        }
        system.debug('!!!!!!!!!!!j'+j);  
        if(NewAccvar != null && NewAccvar !=''){    
            system.debug('!!!!!!!!!!!string'+NewAccvar);        
            if(NewAccvar.startswith('*')==true && NewAccvar.endswith('*')==true && j.size()==2){
                NewAccvar=NewAccvar.remove('*');
                system.debug('!!!!!!!!!!!if 1'+NewAccvar);
                Acclst=[select id,name,Project_Name__c,IsPersonAccount,Cluster__c,Wing__c,Sport_s__c,Flat_No__c,Mobile_Phone__c,Status__c,recordtype.name,CRN__c,Loyalty_Details__c,LoyaltyID__c,owner.name,Primary_PAN_number__c,PersonEmail,Personal_Email__pc from account where recordtype.name='Booked Account'  AND ( CRN__c like:'%'+NewAccvar+'%' OR LoyaltyID__c like:'%'+NewAccvar+'%' OR Name Like:'%'+NewAccvar+'%' OR owner.name Like:'%'+NewAccvar+'%' OR Project_Name__c Like:'%'+NewAccvar+'%' OR Cluster__c Like:'%'+NewAccvar+'%' OR Wing__c Like:'%'+NewAccvar+'%' OR Flat_No__c Like:'%'+NewAccvar+'%' OR Mobile_Phone__c Like:'%'+NewAccvar+'%')]; 
                system.debug('!!!!!!!!!!!if list'+Acclst); 
                if(Acclst.size()==0){
                    norecordsflag=true;
                    //profilerender();
                    CCprofileRender=false;
                    CCOperatorProfileRender=false; 
                    OtherProfileRender=false;
                }
                else{
                    system.debug('!!!!!!!!!!!filter'+NewAccvar+'-'+Splitted);
                    Splitted.add(NewAccvar);
                    system.debug('!!!!!!!!!!!filter1'+NewAccvar+'-'+Splitted);
                    SearchAccountClass.searchfilter(Acclst,Splitted,'Contains');
                    profilerender();
                }
            }
            else if(NewAccvar.startswith('*')==true && NewAccvar.endswith('*')==false && j.size()==1){
                NewAccvar=NewAccvar.remove('*');
                system.debug('!!!!!!!!!!!esle if 1'+NewAccvar);
                Acclst=[select id,name,Project_Name__c,IsPersonAccount,Cluster__c,Wing__c,Flat_No__c,Sport_s__c,Mobile_Phone__c,Status__c,recordtype.name,CRN__c,Loyalty_Details__c,LoyaltyID__c,owner.name,Primary_PAN_number__c,PersonEmail,Personal_Email__pc from account where recordtype.name='Booked Account'  AND ( CRN__c like:'%'+NewAccvar OR LoyaltyID__c like:'%'+NewAccvar OR Name Like:'%'+NewAccvar OR owner.name Like:'%'+NewAccvar OR Project_Name__c Like:'%'+NewAccvar OR Cluster__c Like:'%'+NewAccvar OR Wing__c Like:'%'+NewAccvar OR Flat_No__c Like:'%'+NewAccvar OR Mobile_Phone__c Like:'%'+NewAccvar)];
                system.debug('!!!!!!!!!!!esle if 1 list'+Acclst); 
                if(Acclst.size()==0){
                    norecordsflag=true;
                    //profilerender();
                    CCprofileRender=false;
                    CCOperatorProfileRender=false; 
                    OtherProfileRender=false;
                }
                else{
                    Splitted.add(NewAccvar);
                    SearchAccountClass.searchfilter(Acclst,Splitted,'Endswith');
                    profilerender();
                }
            }
            else if(NewAccvar.startswith('*')==false && NewAccvar.endswith('*')==true && j.size()==1){                
                NewAccvar=NewAccvar.remove('*');
                system.debug('!!!!!!!!!!!esle if 2'+NewAccvar);
                Acclst=[select id,name,IsPersonAccount,Project_Name__c,Cluster__c,Wing__c,Flat_No__c,Sport_s__c,Mobile_Phone__c,Status__c,recordtype.name,CRN__c,Loyalty_Details__c,LoyaltyID__c,owner.name,Primary_PAN_number__c,PersonEmail,Personal_Email__pc from account where recordtype.name='Booked Account'  AND ( CRN__c like:NewAccvar+'%' OR LoyaltyID__c like:NewAccvar+'%'  OR Name Like:NewAccvar+'%' OR owner.name Like:NewAccvar+'%' OR Project_Name__c Like:NewAccvar+'%' OR Cluster__c Like:NewAccvar+'%' OR Wing__c Like:NewAccvar+'%' OR Flat_No__c Like:NewAccvar+'%' OR Mobile_Phone__c Like:NewAccvar+'%')]; 
                system.debug('!!!!!!!!!!!esle if 2 list'+Acclst); 
                if(Acclst.size()==0){
                    norecordsflag=true;
                    //profilerender();
                    CCprofileRender=false;
                    CCOperatorProfileRender=false; 
                    OtherProfileRender=false;
                }
                else{
                    Splitted.add(NewAccvar);
                    system.debug('!!!!!!!!!!!lst'+Splitted);
                    SearchAccountClass.searchfilter(Acclst,Splitted,'StartsWith');
                    profilerender();
                }
            }
            else if(NewAccvar.startswith('*')==false && NewAccvar.endswith('*')==false && NewAccvar.contains('*')==true && j.size()==1){

                Splitted=NewAccvar.split('\\*',-1);
                system.debug('!!!!!!!!!!!if 1111'+NewAccvar);
                Acclst=[select id,IsPersonAccount,name,Project_Name__c,Cluster__c,Wing__c,Sport_s__c,Flat_No__c,Mobile_Phone__c,Status__c,recordtype.name,CRN__c,Loyalty_Details__c,LoyaltyID__c,owner.name,Primary_PAN_number__c,PersonEmail,Personal_Email__pc from account where recordtype.name='Booked Account'  AND ((CRN__c like:Splitted[0]+'%' AND CRN__c like:'%'+Splitted[1]) OR (LoyaltyID__c like:Splitted[0]+'%' AND LoyaltyID__c like:'%'+Splitted[1]) OR (Name like:Splitted[0]+'%' AND Name like:'%'+Splitted[1]) OR (owner.name like:Splitted[0]+'%' AND owner.name like:'%'+Splitted[1]) OR (Project_Name__c like:Splitted[0]+'%' AND Project_Name__c like:'%'+Splitted[1]) OR (Cluster__c like:Splitted[0]+'%' AND Cluster__c like:'%'+Splitted[1]) OR (Wing__c like:Splitted[0]+'%' AND Wing__c like:'%'+Splitted[1]) OR (Flat_No__c like:Splitted[0]+'%' AND Flat_No__c like:'%'+Splitted[1]) OR (Mobile_Phone__c like:Splitted[0]+'%' AND Mobile_Phone__c like:'%'+Splitted[1]))]; 
                system.debug('!!!!!!!!!!!if list11'+Acclst); 
                if(Acclst.size()==0){
                    norecordsflag=true;
                    //profilerender();
                    CCprofileRender=false;
                    CCOperatorProfileRender=false; 
                    OtherProfileRender=false;
                }
                else{
                    SearchAccountClass.searchfilter(Acclst,Splitted,'Both');
                    profilerender();
                }

            }
            else if( ( NewAccvar.startswith('*')==false && NewAccvar.endswith('*')==true && j.size()>1 ) || ( NewAccvar.startswith('*')==true && NewAccvar.endswith('*')==false && j.size()>1 ) || ( NewAccvar.startswith('*')==false && NewAccvar.endswith('*')==false && j.size()>1 ) || j.size()>2 ){
                    system.debug('!!!!!!!!!!!if 2222'+NewAccvar);
                    norecordsflag=true;
                    CCprofileRender=false;
                    CCOperatorProfileRender=false; 
                    OtherProfileRender=false;
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING, 'Please use wildcards (*) with query string for efficient search.ex: ABC* or *ABC or A*BC');
                    ApexPages.addMessage(myMsg);
            
            }            
            else{
                system.debug('!!!!!!!!!!!esle'+NewAccvar);            
                Acclst=[select id,name,Project_Name__c,Cluster__c,Wing__c,Flat_No__c,Sport_s__c,Mobile_Phone__c,Status__c,recordtype.name,CRN__c,Loyalty_Details__c,LoyaltyID__c,owner.name,Primary_PAN_number__c,PersonEmail,Personal_Email__pc from account where recordtype.name='Booked Account'  AND ( CRN__c=:NewAccvar OR LoyaltyID__c=:NewAccvar OR Name=:NewAccvar OR owner.name=:NewAccvar OR Project_Name__c=:NewAccvar OR Cluster__c=:NewAccvar OR Wing__c=:NewAccvar OR Flat_No__c=:NewAccvar OR Mobile_Phone__c=:NewAccvar)]; 
                system.debug('!!!!!!!!!!!esle list'+Acclst);    
                if(Acclst != null && Acclst.size()==0){
                   norecordsflag=true;
                   CCprofileRender=false;
                   CCOperatorProfileRender=false; 
                   OtherProfileRender=false;
                   ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'Please use wildcards (*) with query string for efficient search.ex: ABC* or *ABC or A*BC');
                   ApexPages.addMessage(myMsg);
                }
                else{
                    Splitted.add(NewAccvar);
                    SearchAccountClass.searchfilter(Acclst,Splitted,'Equal');
                    profilerender();
                }
            }
            if(Acclst != null && Acclst.size()==0){
                system.debug('!!!!!!!!!!!error'+Acclst);
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'No records found');
                ApexPages.addMessage(myMsg); 
            }
            if(Acclst.size()>0 && (SearchAccountClass.bname ==true || SearchAccountClass.bproject==true || SearchAccountClass.bcluster || SearchAccountClass.bwing || SearchAccountClass.bflatno || SearchAccountClass.bmobileno || SearchAccountClass.bcrn || SearchAccountClass.bloyaltyid || SearchAccountClass.bownername)){
                buttonchange=true;
            }
        }
        NoOfAccounts=Acclst.size();
        tittle='Accounts ('+NoOfAccounts+')';
        system.debug('!!!!!!!!!!Booleans'+SearchAccountClass.bname+'-'+SearchAccountClass.Bcrn);
    }
    catch(exception e){
        system.debug('!!!!!!!!!!!EXception'+e+e.getLinenumber());
    }
    return null;
}

Public static void searchfilter(List<account> Acclst,List<String> input,string  stringtype){
    SearchAccountClass.bname=false;
    SearchAccountClass.bproject=false;
    SearchAccountClass.bcluster=false;
    SearchAccountClass.bwing=false;
    SearchAccountClass.bflatno=false;
    SearchAccountClass.bmobileno=false;
    SearchAccountClass.bcrn=false;
    SearchAccountClass.bloyaltyid=false;
    SearchAccountClass.bownername=false;
    system.debug('!!!!!!!!!!insidefilter'+Acclst+'-'+input[0]+'-'+stringtype);
    for(account a:Acclst){
        system.debug('!!!!!!!!!!a'+a.name+'-'+a.CRN__C);

        if(stringtype == 'StartsWith'){
            if(a.Name != null){
            SearchAccountClass.checkfilter(a.Name,input,'StartsWith','Name');
            if(a.Project_Name__c != null)
            SearchAccountClass.checkfilter(a.Project_Name__c,input,'StartsWith','Project Name');
            if(a.Cluster__c != null)
            SearchAccountClass.checkfilter(a.Cluster__c,input,'StartsWith','Cluster');
            if(a.Wing__c != null)
            SearchAccountClass.checkfilter(a.Wing__c,input,'StartsWith','Wing');
            if(a.Flat_No__c != null)
            SearchAccountClass.checkfilter(a.Flat_No__c,input,'StartsWith','Flat No');
            if(a.Mobile_Phone__c != null)
            SearchAccountClass.checkfilter(a.Mobile_Phone__c,input,'StartsWith','Mobile No');
            if(a.CRN__c!= null)
            SearchAccountClass.checkfilter(a.CRN__c,input,'StartsWith','CRN');
            if(a.LoyaltyID__c!= null)
            SearchAccountClass.checkfilter(a.LoyaltyID__c,input,'StartsWith','Loyalty ID');
            if(a.owner.name!= null)
            SearchAccountClass.checkfilter(a.owner.name,input,'StartsWith','Owner Name');

        } 
        }
        else if(stringtype == 'EndsWith'){
            if(a.Name != null){
            SearchAccountClass.checkfilter(a.Name,input,'EndsWith','Name');
            if(a.Project_Name__c != null)
            SearchAccountClass.checkfilter(a.Project_Name__c,input,'EndsWith','Project Name');
            if(a.Cluster__c != null)
            SearchAccountClass.checkfilter(a.Cluster__c,input,'EndsWith','Cluster');
            if(a.Wing__c != null)
            SearchAccountClass.checkfilter(a.Wing__c,input,'EndsWith','Wing');
            if(a.Flat_No__c != null)
            SearchAccountClass.checkfilter(a.Flat_No__c,input,'EndsWith','Flat No');
            if(a.Mobile_Phone__c != null)
            SearchAccountClass.checkfilter(a.Mobile_Phone__c,input,'EndsWith','Mobile No');
            if(a.CRN__c!= null)
            SearchAccountClass.checkfilter(a.CRN__c,input,'EndsWith','CRN');
            if(a.LoyaltyID__c!= null)
            SearchAccountClass.checkfilter(a.LoyaltyID__c,input,'EndsWith','Loyalty ID');
            if(a.owner.name!= null)
            SearchAccountClass.checkfilter(a.owner.name,input,'EndsWith','Owner Name');

        }
        }
        else if(stringtype == 'Both'){
            if(a.Name != null){
            SearchAccountClass.checkfilter(a.Name,input,'Both','Name');
            if(a.Project_Name__c != null)
            SearchAccountClass.checkfilter(a.Project_Name__c,input,'Both','Project Name');
            if(a.Cluster__c != null)
            SearchAccountClass.checkfilter(a.Cluster__c,input,'Both','Cluster');
            if(a.Wing__c != null)
            SearchAccountClass.checkfilter(a.Wing__c,input,'Both','Wing');
            if(a.Flat_No__c != null)
            SearchAccountClass.checkfilter(a.Flat_No__c,input,'Both','Flat No');
            if(a.Mobile_Phone__c != null)
            SearchAccountClass.checkfilter(a.Mobile_Phone__c,input,'Both','Mobile No');
            if(a.CRN__c!= null)
            SearchAccountClass.checkfilter(a.CRN__c,input,'Both','CRN');
            if(a.LoyaltyID__c!= null)
            SearchAccountClass.checkfilter(a.LoyaltyID__c,input,'Both','Loyalty ID');
            if(a.owner.name!= null)
            SearchAccountClass.checkfilter(a.owner.name,input,'Both','Owner Name');

            } 
        }
        else if(stringtype == 'Contains'){
            if(a.Name != null){
            SearchAccountClass.checkfilter(a.Name,input,'Contains','Name');
            if(a.Project_Name__c != null)
            SearchAccountClass.checkfilter(a.Project_Name__c,input,'Contains','Project Name');
            if(a.Cluster__c != null)
            SearchAccountClass.checkfilter(a.Cluster__c,input,'Contains','Cluster');
            if(a.Wing__c != null)
            SearchAccountClass.checkfilter(a.Wing__c,input,'Contains','Wing');
            if(a.Flat_No__c != null)
            SearchAccountClass.checkfilter(a.Flat_No__c,input,'Contains','Flat No');
            if(a.Mobile_Phone__c != null)
            SearchAccountClass.checkfilter(a.Mobile_Phone__c,input,'Contains','Mobile No');
            if(a.CRN__c!= null)
            SearchAccountClass.checkfilter(a.CRN__c,input,'Contains','CRN');
            if(a.LoyaltyID__c!= null)
            SearchAccountClass.checkfilter(a.LoyaltyID__c,input,'Contains','Loyalty ID');
            if(a.owner.name!= null)
            SearchAccountClass.checkfilter(a.owner.name,input,'Contains','Owner Name');

        } 
        }
        else {
            if(a.Name != null){
            SearchAccountClass.checkfilter(a.Name,input,'Equal','Name');
            if(a.Project_Name__c != null)
            SearchAccountClass.checkfilter(a.Project_Name__c,input,'Equal','Project Name');
            if(a.Cluster__c != null)
            SearchAccountClass.checkfilter(a.Cluster__c,input,'Equal','Cluster');
            if(a.Wing__c != null)
            SearchAccountClass.checkfilter(a.Wing__c,input,'Equal','Wing');
            if(a.Flat_No__c != null)
            SearchAccountClass.checkfilter(a.Flat_No__c,input,'Equal','Flat No');
            if(a.Mobile_Phone__c != null)
            SearchAccountClass.checkfilter(a.Mobile_Phone__c,input,'Equal','Mobile No');
            if(a.CRN__c!= null)
            SearchAccountClass.checkfilter(a.CRN__c,input,'Equal','CRN');
            if(a.LoyaltyID__c!= null)
            SearchAccountClass.checkfilter(a.LoyaltyID__c,input,'Equal','Loyalty ID');
            if(a.owner.name!= null)
            SearchAccountClass.checkfilter(a.owner.name,input,'Equal','Owner Name');

            }       
        }
    }
    system.debug('!!!!!!!!!!Booleans Lst'+SearchAccountClass.bname+'-'+SearchAccountClass.bproject+'-'+SearchAccountClass.bcluster+'-'+SearchAccountClass.bwing+'-'+SearchAccountClass.bflatno+'-'+SearchAccountClass.bmobileno+'-'+SearchAccountClass.bcrn+'-'+SearchAccountClass.bloyaltyid+'-'+SearchAccountClass.bownername);
}

    public static void checkfilter(string queryString,List<string> input,string inputtype,string var){
            
            if(inputtype =='StartsWith'){
                system.debug('!!!!!!!!!each'+input+'-'+queryString+'-'+queryString.Startswith(input[0]));
                if(queryString.toLowercase().Startswith(input[0].toLowerCase())==true){
                    SearchAccountClass.finalcheck(var);
                }                
            }
            else if(inputtype =='EndsWith'){
                if(queryString.toLowercase().EndsWith(input[0].toLowerCase())==true){
                    SearchAccountClass.finalcheck(var);
                }
            }
            else if(inputtype =='Contains'){
               if(queryString.toLowercase().Contains(input[0].toLowerCase())==true){
                    SearchAccountClass.finalcheck(var);
               }
               /*integer i=queryString.toLowercase().CountMatches(input[0].toLowerCase());
               if((queryString.toLowercase().Startswith(input[0].toLowerCase())==true && queryString.toLowercase().EndsWith(input[0].toLowerCase())==false && i>1) || (queryString.toLowercase().Startswith(input[0].toLowerCase())==false && queryString.toLowercase().EndsWith(input[0].toLowerCase())==true && i>1) || (queryString.toLowercase().Startswith(input[0].toLowerCase())==true && queryString.toLowercase().EndsWith(input[0].toLowerCase())==true && i>2) || (queryString.toLowercase().Startswith(input[0].toLowerCase())==false && queryString.toLowercase().EndsWith(input[0].toLowerCase())==false && i>1)){
                   system.debug('!!!!!!!!!!dynamicsearch'+queryString.toLowercase().Startswith(input[0].toLowerCase())+'-'+queryString.toLowercase().EndsWith(input[0].toLowerCase())+'-'+i);
                   SearchAccountClass.finalcheck(var);
               }*/
               
            }
            else if(inputtype =='Both'){
                if(queryString.toLowercase().Startswith(input[0].toLowerCase())==true && queryString.EndsWith(input[1])==true){
                    SearchAccountClass.finalcheck(var);
                }
            }
            else{
                if(queryString.toLowercase()==input[0].toLowerCase()){
                    SearchAccountClass.finalcheck(var);
                }
            }

    }
    
    Public static void finalcheck(string var){

        if(var=='Name'){        
            SearchAccountClass.bname=true;
        }
        if(var=='Project Name'){        
            SearchAccountClass.bproject=true;
        }
        if(var=='Cluster'){        
            SearchAccountClass.bcluster=true;
        }
        if(var=='Wing'){        
            SearchAccountClass.bwing=true;
        }
        if(var=='Flat No'){        
            SearchAccountClass.bflatno=true;
        }
        if(var=='Mobile No'){        
            SearchAccountClass.bmobileno=true;
        }
        if(var=='CRN'){        
            SearchAccountClass.bcrn=true;
        }
        if(var=='Loyalty ID'){        
            SearchAccountClass.bloyaltyid=true;
        }
        if(var=='Owner Name'){        
            SearchAccountClass.bownername=true;
        }
    
    }
    
    public pagereference dynamicsearch(){
        system.debug('!!!!!!!!!!dynamicsearch'+Accvar+linkvar);
        buttonchange=false;        
        if(Accvar !='' && linkvar !=''){
            string newString=Accvar;
            if(newString.startswith('*')==true && newString.endswith('*')==false){
                newString=newString.remove('*');
                //string query='select id,name,Project_Name__c,IsPersonAccount,Cluster__c,Wing__c,Sport_s__c,Flat_No__c,Mobile_Phone__c,Status__c,recordtype.name,CRN__c,Loyalty_Details__c,LoyaltyID__c,owner.name from account where recordtype.name=\'Booked Account\' AND '+linkvar+'=\''+newString+'\'';
                string query='select id,name,Project_Name__c,IsPersonAccount,Cluster__c,Wing__c,Sport_s__c,Flat_No__c,Mobile_Phone__c,Status__c,recordtype.name,CRN__c,Loyalty_Details__c,LoyaltyID__c,owner.name,Primary_PAN_number__c,PersonEmail,Personal_Email__pc from account where recordtype.name=\'Booked Account\' AND '+linkvar+' Like \'%'+newString+'\'';
                system.debug('!!!!!!!!!!dynamicsearch1'+query);
                List<SObject> SobjLst=database.query(query);
                Acclst=(List<Account>)SobjLst;
                profilerender();
            }
            else if(newString.startswith('*')==false&& newString.endswith('*')==true){
                system.debug('!!!!!!newString'+newString);
                newString=newString.remove('*');
                system.debug('!!!!!!newString1'+newString);
                //string query='select id,name,Project_Name__c,IsPersonAccount,Cluster__c,Wing__c,Sport_s__c,Flat_No__c,Mobile_Phone__c,Status__c,recordtype.name,CRN__c,Loyalty_Details__c,LoyaltyID__c,owner.name from account where recordtype.name=\'Booked Account\' AND '+linkvar+'=\''+newString+'\'';
                string query='select id,name,Project_Name__c,IsPersonAccount,Cluster__c,Wing__c,Sport_s__c,Flat_No__c,Mobile_Phone__c,Status__c,recordtype.name,CRN__c,Loyalty_Details__c,LoyaltyID__c,owner.name,Primary_PAN_number__c,PersonEmail,Personal_Email__pc from account where recordtype.name=\'Booked Account\' AND ('+linkvar+' LIKE \''+newString+'%\')';
                system.debug('!!!!!!!!!!dynamicsearch1'+query);
                List<SObject> SobjLst=database.query(query);
                Acclst=(List<Account>)SobjLst;
                profilerender();
            }
            else if(newString.startswith('*')==false&& newString.endswith('*')==false && newString.contains('*')==true){
                List<string> lst=newString.split('\\*',-1);
                //string query='select id,name,Project_Name__c,IsPersonAccount,Cluster__c,Wing__c,Sport_s__c,Flat_No__c,Mobile_Phone__c,Status__c,recordtype.name,CRN__c,Loyalty_Details__c,LoyaltyID__c,owner.name from account where recordtype.name=\'Booked Account\' AND '+linkvar+'=\''+newString+'\'';
                string query='select id,name,Project_Name__c,IsPersonAccount,Cluster__c,Wing__c,Sport_s__c,Flat_No__c,Mobile_Phone__c,Status__c,recordtype.name,CRN__c,Loyalty_Details__c,LoyaltyID__c,owner.name,Primary_PAN_number__c,PersonEmail,Personal_Email__pc from account where recordtype.name=\'Booked Account\' AND ('+linkvar+' LIKE \''+lst[0]+'%\') AND ('+linkvar+' LIKE \'%'+lst[1]+'\')';
                system.debug('!!!!!!!!!!dynamicsearch1'+query);
                List<SObject> SobjLst=database.query(query);
                Acclst=(List<Account>)SobjLst;
                profilerender();
            }
            else if(newString.startswith('*')==true && newString.endswith('*')==true){
                newString=newString.remove('*');
                //string query='select id,name,Project_Name__c,IsPersonAccount,Cluster__c,Wing__c,Sport_s__c,Flat_No__c,Mobile_Phone__c,Status__c,recordtype.name,CRN__c,Loyalty_Details__c,LoyaltyID__c,owner.name from account where recordtype.name=\'Booked Account\' AND '+linkvar+'=\''+newString+'\'';
                string query='select id,name,Project_Name__c,IsPersonAccount,Cluster__c,Wing__c,Sport_s__c,Flat_No__c,Mobile_Phone__c,Status__c,recordtype.name,CRN__c,Loyalty_Details__c,LoyaltyID__c,owner.name,Primary_PAN_number__c,PersonEmail,Personal_Email__pc from account where recordtype.name=\'Booked Account\' AND ('+linkvar+' LIKE \'%'+newString+'%\')';
                system.debug('!!!!!!!!!!dynamicsearch1'+query);
                List<SObject> SobjLst=database.query(query);
                Acclst=(List<Account>)SobjLst;
                profilerender();
            }
            else{
                string query='select id,name,Project_Name__c,IsPersonAccount,Cluster__c,Wing__c,Sport_s__c,Flat_No__c,Mobile_Phone__c,Status__c,recordtype.name,CRN__c,Loyalty_Details__c,LoyaltyID__c,owner.name,Primary_PAN_number__c,PersonEmail,Personal_Email__pc from account where recordtype.name=\'Booked Account\' AND '+linkvar+'=\''+newString+'\'';
                system.debug('!!!!!!!!!!dynamicsearch1'+query);
                List<SObject> SobjLst=database.query(query);
                Acclst=(List<Account>)SobjLst;
                profilerender();
            }
            NoOfAccounts=Acclst.size();
            tittle='Accounts ('+NoOfAccounts+')';
            
        }
        return null;
    }
    
    public void profilerender(){
        if(userprofilename=='Customer Care'){
            CCprofileRender=true;
            CCOperatorProfileRender=false; 
            OtherProfileRender=false;                  
        }
        else if(userprofilename=='Customer Care Operator'){
            CCprofileRender=false;
            CCOperatorProfileRender=true; 
            OtherProfileRender=false;                  
        }
        else{
            CCprofileRender=false;
            CCOperatorProfileRender=false; 
            OtherProfileRender=true;
        }    
    }
}