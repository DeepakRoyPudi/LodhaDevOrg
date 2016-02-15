/*    Description: Creating a Mock Callout class to set the response of the callout made while consuming Aftership Integration webservice
*                  for Last Delivery Status field update. This class is written for DMS
*    
*    Version            Date            Author                    Description
*    1.0                03/09/2014      Asmita(Eternus)           Initial Draft
*/

@isTest
global class MockHttpResponseForAftershipLastDelivery implements HttpCalloutMock{

     global  HTTPResponse respond(HTTPRequest req){
    	String strResBody = '';
    	
    	// Creating a fake response
    	HttpResponse oHResponse = new HttpResponse(); 
    	oHResponse.setHeader('Content-Type', 'application/json');
        strResBody = '{"meta": { "code": 200},"data": {"page": 1,"limit": 100,"count": 3,"keyword": "","slug": "","origin": [],"destination": [],"tag": "","fields": "","created_at_min": "2014-03-27T07:36:14+00:00","created_at_max": "2014-06-25T07:36:14+00:00",';
        strResBody = strResBody + '"trackings": [{"id": "53aa7b5c415a670000000021","created_at": "2014-06-25T07:33:48+00:00","updated_at": "2014-06-25T07:33:55+00:00","tracking_number": "123456789","tracking_account_number": null,"tracking_postal_code": null,"tracking_ship_date": null,"slug": "dhl","active": false,';
        strResBody = strResBody + '"custom_fields": {"product_price": "USD19.99","product_name": "iPhone Case"},"customer_name": null,"destination_country_iso3": null,';
        strResBody = strResBody + '"emails": ["email@yourdomain.com","another_email@yourdomain.com"],';
        strResBody = strResBody + '"expected_delivery": null,"note": null,"order_id": "ID 1234","order_id_path": "http://www.aftership.com/order_id=1234","origin_country_iso3": null,"shipment_package_count": 0,"shipment_type": null,"signed_by": "raul","smses": [],"source": "api","tag": "Delivered","title": "Title Name","tracked_count": 1,"unique_token": "xy_fej9Llg",';
        strResBody = strResBody + '"checkpoints": [{"slug": "dhl","city": null,"created_at": "2014-06-25T07:33:53+00:00","country_name": "VALENCIA - SPAIN","message": "Awaiting collection by recipient as requested","country_iso3": null,"tag": "InTransit","checkpoint_time": "2014-05-12T12:02:00","coordinates": [],"state": null,"zip": null},';
        strResBody = strResBody + '{"slug": "dhl","city": null,"created_at": "2014-06-25T07:33:53+00:00","country_name": "VALENCIA - SPAIN","message": "Delivered","country_iso3": null,"tag": "InTransit","checkpoint_time": "2014-05-12T12:02:00Z","coordinates": [],"state": null,"zip": null}';
        strResBody = strResBody + ']}]}}';
    	oHResponse.setBody(strResBody);
    	oHResponse.setStatusCode(200);
    	return oHResponse;
    }
}