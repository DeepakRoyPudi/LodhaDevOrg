/*
*    Description : Future method for consuming the webservice provided by PHP team in order to 
*                  send the Oasys Flat code to PHP if the flat is booked from SFDC(backend)
*
*    Version       Date            Author            Description
*    1.0          05/11/2014      Asmita Bubane     Initial Draft
*/

global class FutureClassForConsumingPalavaWebservice {
    
    private static final String STRENDPOINTURL = System.Label.PalavaEndpointUrl;
    private static final String STRXACTION = System.Label.XAction;
    private static final String STRXACTIONNAME = System.Label.XActionName;
    private static final String STROASYSFLATCODENAME = System.Label.OasysFlatCode;
    private static final String STRMETHOD = System.Label.RequestMethod;
    
    public static void sendOasysCode(String pStrOasysFlatCode){
    	
        // Instantiate a new http object
        Http h = new Http();
        
        // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
        HttpRequest req = new HttpRequest();
        
        req.setEndpoint(STRENDPOINTURL);
        
        String strOasysFlatCode = EncodingUtil.urlEncode(pStrOasysFlatCode, 'UTF-8');
        req.setBody(STRXACTION + '=' + STRXACTIONNAME + '&' + STROASYSFLATCODENAME + '=' + strOasysFlatCode);
        req.setMethod('POST');

        // Send the request, and return a response
        	try{
                HttpResponse res = h.send(req);
        	}
        	catch(System.CalloutException e){
        		System.debug('Catch Exception :::: ' + e);
        	}
    }
}