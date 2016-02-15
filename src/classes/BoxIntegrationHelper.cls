/*
*    Description : This class is a helper for integrating Box environment with Salesforce
*                  The class essentially provides the functionality that generates the 'Session URL' that 
*                  can be used to display the contents of a document uploaded on 'Box Environment' on to a visualforce page
* 
*    Version            Date            Author                    Description
*    1.0                07/06/2014      Siddharth(Eternus)        Initial Draft
*/

public with sharing class BoxIntegrationHelper {
    
    private static final String STRVIEWAPIKEY = 'kyu4f6h69kfv429dvok82wh03gal1jqt';
    
    String strDocumentId;
    String strSessionId;
    String strRequestUrl;
    String strDocumentStatus;
    
    public BoxIntegrationHelper(){
    
        strDocumentId = '';
        strSessionId = '';
        strRequestUrl = '';
        strDocumentStatus = '';
    }

    //Method accepts the shared document URL and generates the Document ID
    public String generateDocumentId(String pStrDocumentUrl){
    
        HttpRequest oRequest = new HttpRequest();
        oRequest.setEndpoint('https://view-api.box.com/1/documents');
        oRequest.setHeader('Content-Type', 'application/json');
        oRequest.setHeader('Authorization', 'Token ' + STRVIEWAPIKEY);
        oRequest.setBody('{"url": "' + pStrDocumentUrl + '"}');
        oRequest.setMethod('POST');
        
        Http oHttp = new Http();
        HttpResponse oResponse = oHttp.send(oRequest);
        
        return this.returnId(oResponse.getBody(), 'id');
    }
    
    //Method accepts the Shared URL of the Document from Box environment and returns the 'Session URL'
    public String generateSessionUrl(String pStrDocumentId){
        
        //Generate the Document ID
        strDocumentId = pStrDocumentId;
        
        //Retrieve the status of the Document
        if(!String.isBlank(strDocumentId))
            strDocumentStatus = this.checkDocumentStatus(strDocumentId);
        
        System.debug('strDocumentId::'+strDocumentId);
        System.debug('strDocumentStatus::'+strDocumentStatus);        
            
        
        if(!String.isBlank(strDocumentId) &&
           !String.isBlank(strDocumentStatus) && 
           strDocumentStatus.equalsIgnoreCase('done')){
            
            HttpRequest oSessionRequest = new HttpRequest();
            oSessionRequest.setEndpoint('https://view-api.box.com/1/sessions');        
            oSessionRequest.setMethod('POST');
            String strSessionAuthHeader = 'Token ' + STRVIEWAPIKEY;
         
            oSessionRequest.setHeader('Content-Type', 'application/json');
            oSessionRequest.setHeader('Authorization', strSessionAuthHeader);
            oSessionRequest.setBody('{"document_id": "' + strDocumentId + '", "duration": "5", "is_downloadable": "false"}');
        
            Http oSessionHttp = new Http();
            HttpResponse oSessionResponse = oSessionHttp.send(oSessionRequest);
            
            strSessionId = this.returnId(oSessionResponse.getBody(), 'id');
            
            //strRequestUrl = 'https://view-api.box.com/1/sessions/' + strSessionId + '/view?theme=dark';
            strRequestUrl = strSessionId;
            System.debug('strRequestUrl ::'+strRequestUrl );
        }
        
        return strRequestUrl;
    }
    
    //Method accepts the processed document Id and returns the status of the Document
    public String checkDocumentStatus(String pStrDocumentId){
        
        HttpResponse oStatusResponse = new HttpResponse();
        
        if(!String.isBlank(strDocumentId)){
            
            HttpRequest oStatus = new HttpRequest();
            oStatus.setEndpoint('https://view-api.box.com/1/documents/' + pStrDocumentId);
            oStatus.setHeader('Authorization', 'Token ' + STRVIEWAPIKEY);
            oStatus.setMethod('GET');
            Http oHStatus = new Http();
            oStatusResponse = oHStatus.send(oStatus);
        }    
        return this.returnId(oStatusResponse.getBody(), 'status');
    }
    
    //Method returns Token value from the provided JSON String
    public String returnId(String pStrJson, String pStrToken){
    
        String strId = '';
        JSONParser parser = JSON.createParser(pStrJson);
            
        while (parser.nextToken() != null) {
            
            if ((parser.getText() == pStrToken)) {
            
                parser.nextToken();
                strId = parser.getText();
                break;
            }
        }
        return strId;
    }
    
    /*
    //Method to check the status of the Http Response
    public Boolean isSuccessful(HttpResponse pResponse){
    
        Boolean blnIsResponseSuccessful = false;
        if(pResponse.getStatusCode() == 200 || pResponse.getStatusCode() == 202)
            blnIsResponseSuccessful = true;
        return blnIsResponseSuccessful;
    }
    */
}