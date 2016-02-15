public class GetSessionIdController {

        public String hosturl {get;set;}
        public List<String> baseurl {get;set;}
        public String Instances_var{get;set;}

                public GetSessionIdController()
                
                    {
                                            
                        hosturl=URL.getSalesforceBaseUrl().gethost();
                        baseurl=hosturl.split('\\.');   
                        Instances_var=baseurl[1];                                                               
                    
                    }
                    
 

    static testMethod void unitTest()
    {
        GetSessionIdController getsession=new GetSessionIdController();
    }
}