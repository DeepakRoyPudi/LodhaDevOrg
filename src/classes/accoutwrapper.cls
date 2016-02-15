public class accoutwrapper{
    
    public String Accountid{get;set;}
    public String AccountName{get;set;}
    public String mobilenumber{get;set;}
    public Account cat { get; set;}
 
    public accoutwrapper(){
        cat = new Account();

    }
 
    public accoutwrapper(Account c){
        cat = c;

    }
 
    
 
}